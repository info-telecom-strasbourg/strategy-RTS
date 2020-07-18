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
		set_angle(angle);
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
			this.corners[i].x = pos.x + DEMI_DIAG * cos(this.angle + PI/4 + i*PI/2);
			this.corners[i].y = pos.y + DEMI_DIAG * sin(this.angle + PI/4 + i*PI/2);
		}
		detected_color = NO_COLOR;
	}

	void set_angle(float new_angle)
	{
		this.angle = mod2Pi(new_angle);
	}

	float angle_diff(float angle)
	{
		return mod2Pi(angle - this.angle);
	}

	void update_angle(float var){set_angle(this.angle + var);}

	void update_pos(Pos var)
	{
		this.position.x += var.x;
		this.position.y += var.y;
	}


	//SIMULATION
	Pos new_position = new Pos(0,0);
	Pos[] corners = new Pos[] {new Pos(0,0), new Pos(0,0), new Pos(0,0), new Pos(0,0)};

	void affiche(boolean our_robot)
	{
		if (our_robot)
			fill(0, 255, 0);
		else
			fill(255, 0, 0);
		pushMatrix();
		translate(this.position.x, this.position.y);
		rotate(this.angle);
		rectMode(CENTER);
		rect(0, 0, LARGEUR_ROBOT, LONGUEUR_ROBOT);
		if(our_robot)
		{
			fill(255, 255, 255, 150);
			arc(LONGUEUR_ROBOT/2, 0, 500, 500, - PI/4,  PI/4);
			fill(255,165,0, 150);
			arc(LONGUEUR_ROBOT/2, 0, 500, 500, - PI/12,  PI/12);
			fill(255,255,255);
			triangle(LONGUEUR_ROBOT/2, 0, 0, -LARGEUR_ROBOT/2, 0, LARGEUR_ROBOT/2);
			if (flag)
			{
				fill(0, 0, 255);
				ellipse(-25,0, 20, 20);
			}
		}
		else
		{
			fill(0,0,0);
			triangle(LONGUEUR_ROBOT/2, 0, 0, -LARGEUR_ROBOT/2, 0, LARGEUR_ROBOT/2);
		}
		popMatrix();
	}

	void goToAngle(float theta)
	{
		float angleDiff = angle_diff(theta);

		if (angleDiff < petite_rot || 2*PI - angleDiff < petite_rot)
			set_angle(theta);
		else if (angleDiff < PI)
			set_angle(this.angle + petite_rot);
		else
			set_angle(this.angle - petite_rot);
 	}

	void goTo()
	{

		if (this.position.isAround(this.next_position, 50)) //le robot est à destination
			return;


		float dist = sqrt(pow((this.position.x - this.next_position.x),2) + pow((this.position.y - this.next_position.y),2));
		float theta = this.position.angle(this.next_position);

		if (angle_diff(theta) > petite_rot && 2*PI - angle_diff(theta) > petite_rot && (this.new_position.x != this.next_position.x || this.new_position.y != this.next_position.y))
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

		if (angle_diff(theta + PI) > petite_rot && 2*PI-angle_diff(theta + PI) > petite_rot && (this.new_position.x != this.next_position.x || this.new_position.y != this.next_position.y))
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
			this.corners[i].x = this.position.x + DEMI_DIAG * cos(this.angle + PI/4 + i*PI/2);
			this.corners[i].y = this.position.y + DEMI_DIAG * sin(this.angle + PI/4 + i*PI/2);
		}
	}

	void borderColision()
	{
		if ((corners[1].x < 0) && corners[2].x < 0)
		{
			set_angle(0);
			this.position.x = LONGUEUR_ROBOT/2; // la longeur étant la distance de l'avant à l'arrière du robot
			getCorners();
		}
		else if ((corners[1].x > LONGUEUR_TERRAIN - 1) && (corners[2].x > LONGUEUR_TERRAIN - 1))
		{
			set_angle(PI);
			this.position.x = LONGUEUR_TERRAIN - 1 - LONGUEUR_ROBOT/2;
			getCorners();
		}
		if ((corners[1].y < 0) && (corners[2].y < 0))
		{
			set_angle(PI/2);
			this.position.y = LONGUEUR_ROBOT/2;
			getCorners();
		}
		else if ((corners[1].y > LARGEUR_TERRAIN - 1) && (corners[2].y > LARGEUR_TERRAIN - 1))
		{
			set_angle(3 * PI/2);
			this.position.y = LARGEUR_TERRAIN - 1 - LONGUEUR_ROBOT/2;
			getCorners();
		}
		if ((corners[0].x < 0) && corners[3].x < 0)
		{
			set_angle(PI);
			this.position.x = LONGUEUR_ROBOT/2; // la longeur étant la distance de l'avant à l'arrière du robot
			getCorners();
		}
		else if ((corners[0].x > LONGUEUR_TERRAIN - 1) && (corners[3].x > LONGUEUR_TERRAIN - 1))
		{
			set_angle(0);
			this.position.x = LONGUEUR_TERRAIN - 1 - LONGUEUR_ROBOT/2;
			getCorners();
		}
		if ((corners[0].y < 0) && (corners[3].y < 0))
		{
			set_angle(3 * PI/2);
			this.position.y = LONGUEUR_ROBOT/2;
			getCorners();
		}
		else if ((corners[0].y > LARGEUR_TERRAIN - 1) && (corners[3].y > LARGEUR_TERRAIN - 1))
		{
			set_angle(PI/2);
			this.position.y = LARGEUR_TERRAIN - 1 - LONGUEUR_ROBOT/2;
			getCorners();
		}

		for(int i = 0; i < 4; i++)
		{
			float angleDiff;
			if (corners[i].x < 0)
			{
				angleDiff = acos(this.position.x/sqrt(pow(this.position.y - corners[i].y,2) + pow(this.position.x - corners[i].x,2))) - atan(abs((this.position.y - corners[i].y)/(this.position.x - corners[i].x)));
				if (corners[i].y < this.position.y)
					set_angle(this.angle + angleDiff);
				else if(corners[i].y > this.position.y)
					set_angle(this.angle - angleDiff);
				else
					this.position.x -= corners[i].x;
				getCorners();
			}
			else if (corners[i].x > LONGUEUR_TERRAIN - 1)
			{
				angleDiff = acos((LONGUEUR_TERRAIN - 1 - this.position.x)/sqrt(pow(this.position.y - corners[i].y,2) + pow(this.position.x - corners[i].x,2))) - atan(abs((this.position.y - corners[i].y)/(this.position.x - corners[i].x)));
				if (corners[i].y < this.position.y)
					set_angle(this.angle - angleDiff);
				else if(corners[i].y > this.position.y)
					set_angle(this.angle + angleDiff);
				else
					this.position.x -= corners[i].x - LONGUEUR_TERRAIN + 1;
				getCorners();
			}
			if (corners[i].y < 0)
			{
				angleDiff = acos(this.position.y/sqrt(pow(this.position.y - corners[i].y,2) + pow(this.position.x - corners[i].x,2))) - atan(abs((this.position.x - corners[i].x)/(this.position.y - corners[i].y)));
				if (corners[i].x < this.position.x)
					set_angle(this.angle - angleDiff);
				else if(corners[i].x > this.position.x)
					set_angle(this.angle + angleDiff);
				else
					this.position.y -= corners[i].y;
				getCorners();
			}
			else if (corners[i].y > LARGEUR_TERRAIN - 1)
			{
				angleDiff = acos((LARGEUR_TERRAIN - 1 - this.position.y)/sqrt(pow(this.position.y - corners[i].y,2) + pow(this.position.x - corners[i].x,2))) - atan(abs((this.position.x - corners[i].x)/(this.position.y - corners[i].y)));
				if (corners[i].x < this.position.x)
					set_angle(this.angle + angleDiff);
				else if(corners[i].x > this.position.x)
					set_angle(this.angle - angleDiff);
				else
					this.position.y -= corners[i].y - LARGEUR_TERRAIN + 1;
				getCorners();
			}
		}
	}
}
