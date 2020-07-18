class Robot
{
	//STRATEGY
	Pos position;
	float angle;
	int speed_regime;
	Pos next_position;
	int detected_color;
	Pos checkpoint_windsock;
	Pos checkpoint_lighthouse;
	Pos checkpoint_weathercock;
	boolean flag;
	boolean side;
	boolean deployed;

	Robot(Pos pos, float angle)
	{
		this.position = pos;
		this.angle = angle;
		this.speed_regime = STOP;
		this.next_position = null;
		this.flag = false;
		this.deployed = false;


		//SIMULATION
		// 0: bas gauche
		// 1: haut gauche
		// 2: haut droite
		// 3: bas droite
		for (int i = 0; i < 4; ++i)
		{
			this.corners[i].x = pos.x + HALF_DIAG * cos(this.angle + PI/4 + i*PI/2);
			this.corners[i].y = pos.y + HALF_DIAG * sin(this.angle + PI/4 + i*PI/2);
		}
		detected_color = NO_COLOR;
	}

	void update_angle(float var){this.angle = mod2Pi(this.angle + var);}

	void update_pos(Pos var)
	{
		this.position.x += var.x;
		this.position.y += var.y;
	}


	//SIMULATION
	Pos new_position = new Pos(0,0);
	Pos[] corners = new Pos[] {new Pos(0,0), new Pos(0,0), new Pos(0,0), new Pos(0,0)};

	void display(boolean our_robot)
	{
		if (our_robot)
			fill(0, 255, 0);
		else
			fill(255, 0, 0);
		pushMatrix();
		translate(this.position.x, this.position.y);
		rotate(this.angle);
		rectMode(CENTER);
		rect(0, 0, ROBOT_WIDTH, ROBOT_HEIGHT);
		if(our_robot)
		{
			fill(255, 255, 255, 150);
			arc(ROBOT_HEIGHT/2, 0, 500, 500, - PI/4,  PI/4);
			fill(255,165,0, 150);
			arc(ROBOT_HEIGHT/2, 0, 500, 500, - PI/12,  PI/12);
			fill(255,255,255);
			triangle(ROBOT_HEIGHT/2, 0, 0, -ROBOT_WIDTH/2, 0, ROBOT_WIDTH/2);
			if (flag)
			{
				fill(0, 0, 255);
				ellipse(-25,0, 20, 20);
			}
		}
		else
		{
			fill(0,0,0);
			triangle(ROBOT_HEIGHT/2, 0, 0, -ROBOT_WIDTH/2, 0, ROBOT_WIDTH/2);
		}
		popMatrix();
	}

	void goToAngle(float theta)
	{
		theta = mod2Pi(theta);
		float delta_angle = theta - this.angle;

		if (abs(delta_angle) < rot_step)
			this.angle = theta;
		else
		{
			if ((delta_angle > 0 && delta_angle < PI) || (delta_angle < 0 && delta_angle < -PI))
				this.angle = mod2Pi(this.angle + rot_step);
			else
				this.angle = mod2Pi(this.angle - rot_step);
		}
 	}

	void goTo()
	{

		if (this.position.isAround(this.next_position, 50)) //le robot est à destination
			return;


		float dist = sqrt(pow((this.position.x - this.next_position.x),2) + pow((this.position.y - this.next_position.y),2));
		float theta = this.position.angle(this.next_position);

		if (mod2Pi(theta - this.angle) > rot_step && (this.new_position.x != this.next_position.x || this.new_position.y != this.next_position.y))
		{
			goToAngle(theta);
			return;
		}

		if (this.new_position.x != this.next_position.x || this.new_position.y != this.next_position.y)
		{
			this.new_position.x = this.next_position.x;
			this.new_position.y = this.next_position.y;
		}

		if (dist < this.speed_regime)
		{
			this.position.x = this.next_position.x;
			this.position.y = this.next_position.y;
		}
		else
		{
			this.position.x += this.speed_regime * cos(this.angle);
			this.position.y += this.speed_regime * sin(this.angle);
		}
	}

	void goBack ()
	{
		if (this.position.isAround(this.next_position, 50)) //le robot est à destination
			return;

		float dist = sqrt(pow((this.position.x - this.next_position.x),2) + pow((this.position.y - this.next_position.y),2));
		float theta = this.position.angle(this.next_position);

		if (mod2Pi(theta + PI - this.angle) > rot_step && (this.new_position.x != this.next_position.x || this.new_position.y != this.next_position.y))
		{
			goToAngle(theta + PI);
			return;
		}


		if (this.new_position.x != this.next_position.x || this.new_position.y != this.next_position.y)
		{
			this.new_position.x = this.next_position.x;
			this.new_position.y = this.next_position.y;
		}

		if (dist < this.speed_regime)
		{
			this.position.x = this.next_position.x;
			this.position.y = this.next_position.y;
		}
		else
		{
			this.position.x -= this.speed_regime * cos(this.angle);
			this.position.y -= this.speed_regime * sin(this.angle);
		}
	}



	void getCorners()
	{
		//le PI/4 est vrai que si le robot est carré
		for (int i = 0; i < 4; ++i)
		{
			this.corners[i].x = this.position.x + HALF_DIAG * cos(this.angle + PI/4 + i*PI/2);
			this.corners[i].y = this.position.y + HALF_DIAG * sin(this.angle + PI/4 + i*PI/2);
		}
	}

	void borderColision()
	{
		if ((corners[1].x < 0) && corners[2].x < 0)
		{
			this.angle = 0;
			this.position.x = ROBOT_HEIGHT/2; // la longeur étant la distance de l'avant à l'arrière du robot
			getCorners();
		}
		else if ((corners[1].x > ARENA_HEIGHT - 1) && (corners[2].x > ARENA_HEIGHT - 1))
		{
			this.angle = PI;
			this.position.x = ARENA_HEIGHT - 1 - ROBOT_HEIGHT/2;
			getCorners();
		}
		if ((corners[1].y < 0) && (corners[2].y < 0))
		{
			this.angle = PI/2;
			this.position.y = ROBOT_HEIGHT/2;
			getCorners();
		}
		else if ((corners[1].y > ARENA_WIDTH - 1) && (corners[2].y > ARENA_WIDTH - 1))
		{
			this.angle = 3 * PI/2;
			this.position.y = ARENA_WIDTH - 1 - ROBOT_HEIGHT/2;
			getCorners();
		}
		if ((corners[0].x < 0) && corners[3].x < 0)
		{
			this.angle = PI;
			this.position.x = ROBOT_HEIGHT/2; // la longeur étant la distance de l'avant à l'arrière du robot
			getCorners();
		}
		else if ((corners[0].x > ARENA_HEIGHT - 1) && (corners[3].x > ARENA_HEIGHT - 1))
		{
			this.angle = 0;
			this.position.x = ARENA_HEIGHT - 1 - ROBOT_HEIGHT/2;
			getCorners();
		}
		if ((corners[0].y < 0) && (corners[3].y < 0))
		{
			this.angle = 3 * PI/2;
			this.position.y = ROBOT_HEIGHT/2;
			getCorners();
		}
		else if ((corners[0].y > ARENA_WIDTH - 1) && (corners[3].y > ARENA_WIDTH - 1))
		{
			this.angle = PI/2;
			this.position.y = ARENA_WIDTH - 1 - ROBOT_HEIGHT/2;
			getCorners();
		}

		for(int i = 0; i < 4; i++)
		{
			float delt_ang;
			if (corners[i].x < 0)
			{
				delt_ang = acos(this.position.x/sqrt(pow(this.position.y - corners[i].y,2) + pow(this.position.x - corners[i].x,2))) - atan(abs((this.position.y - corners[i].y)/(this.position.x - corners[i].x)));
				if (corners[i].y < this.position.y)
					this.angle += delt_ang;
				else if(corners[i].y > this.position.y)
					this.angle -= delt_ang;
				else
					this.position.x -= corners[i].x;
				getCorners();
			}
			else if (corners[i].x > ARENA_HEIGHT - 1)
			{
				delt_ang = acos((ARENA_HEIGHT - 1 - this.position.x)/sqrt(pow(this.position.y - corners[i].y,2) + pow(this.position.x - corners[i].x,2))) - atan(abs((this.position.y - corners[i].y)/(this.position.x - corners[i].x)));
				if (corners[i].y < this.position.y)
					this.angle -= delt_ang;
				else if(corners[i].y > this.position.y)
					this.angle += delt_ang;
				else
					this.position.x -= corners[i].x - ARENA_HEIGHT + 1;
				getCorners();
			}
			if (corners[i].y < 0)
			{
				delt_ang = acos(this.position.y/sqrt(pow(this.position.y - corners[i].y,2) + pow(this.position.x - corners[i].x,2))) - atan(abs((this.position.x - corners[i].x)/(this.position.y - corners[i].y)));
				if (corners[i].x < this.position.x)
					this.angle -= delt_ang;
				else if(corners[i].x > this.position.x)
					this.angle += delt_ang;
				else
					this.position.y -= corners[i].y;
				getCorners();
			}
			else if (corners[i].y > ARENA_WIDTH - 1)
			{
				delt_ang = acos((ARENA_WIDTH - 1 - this.position.y)/sqrt(pow(this.position.y - corners[i].y,2) + pow(this.position.x - corners[i].x,2))) - atan(abs((this.position.x - corners[i].x)/(this.position.y - corners[i].y)));
				if (corners[i].x < this.position.x)
					this.angle += delt_ang;
				else if(corners[i].x > this.position.x)
					this.angle -= delt_ang;
				else
					this.position.y -= corners[i].y - ARENA_WIDTH + 1;
				getCorners();
			}
		}
	}
}
