/**
 * Simulate a robot
 */
class Robot
{
	//STRATEGY
	Pos position;
	float angle;
	int speed_regime;
	Pos next_destination;
	int detected_color;
	Pos checkpoint_windsock;
	Pos checkpoint_lighthouse;
	Pos checkpoint_weathercock;
	boolean flag;
	boolean side;
	boolean deployed;
	
	//SIMULATION
	Pos new_position = new Pos(0,0);
	// 0: bottom - left (conv left)
	// 1: top - left (conv left)
	// 2: top - right (conv left)
	// 3: bottom - right (conv left)
	Pos[] corners = new Pos[4];

	/**
	 * Constructor of Robot
	 * @param pos: the initial position of the robot
	 * @param angle: the initial position of the robot
	 */
	Robot(Pos pos, float angle)
	{
		this.position = pos;
		this.angle = angle;
		this.speed_regime = STOP;
		this.next_destination = null;
		this.flag = false;
		this.deployed = false;
		this.detected_color = NO_COLOR;

		for (int i = 0; i < 4; ++i)
		{
			float angle_corner = this.angle + PI/4 + i*PI/2;
			this.corners[i] = new Pos(
									  pos.x + HALF_DIAG * cos(angle_corner), 
									  pos.y + HALF_DIAG * sin(angle_corner)
									 );
		}
	}

	/**
	 * Draw a cone to visualise what the lidar in the front of the robot detect
	 * The angle of the white one is PI/2 => 90°
	 * The angle of the orange one is PI/6 => 30°
	 */
	void draw_lidar_vision()
	{
		fill(255, 255, 255, 150);
		arc(ROBOT_HEIGHT/2, 0, 500, 500, - PI/4,  PI/4);
		fill(255,165,0, 150);
		arc(ROBOT_HEIGHT/2, 0, 500, 500, - PI/12,  PI/12);
	}

	/**
	 * Draw a square representing the robot (green if our, red if opponent)
	 * @param our_robot: indicate if it is our robot
	 */
	void draw_robot(boolean our_robot)
	{
		if (our_robot)
			fill(0, 255, 0);
		else
			fill(255, 0, 0);
		translate(this.position.x, this.position.y);
		rotate(this.angle);
		rectMode(CENTER);
		rect(0, 0, ROBOT_WIDTH, ROBOT_HEIGHT);
	}

	/**
	 * Draw the flag when it is hoisted
	 */
	void draw_flag()
	{
		fill(0, 0, 255);
		ellipse(-25,0, 20, 20);
	}

	/**
	 * Draw the triangle to show the robot direction and if it's our robot,
	 * a cone to visualise what the lidar in the front of the robot detect
	 * @param our_robot: indicate if it is our robot
	 */
	void draw_extra(boolean our_robot)
	{
		if(our_robot)
		{
			draw_lidar_vision();
			fill(255,255,255);
			triangle(ROBOT_HEIGHT/2, 0, 0, -ROBOT_WIDTH/2, 0, ROBOT_WIDTH/2);
		}
		else
		{
			fill(0,0,0);
			triangle(ROBOT_HEIGHT/2, 0, 0, -ROBOT_WIDTH/2, 0, ROBOT_WIDTH/2);
		}
	}
	
	/**
	 * Display the robot and its components
	 * @param our_robot: indicate if it is our robot
	 */
	void display(boolean our_robot)
	{
		pushMatrix();
		
		draw_robot(our_robot);
		draw_extra(our_robot);
		if (this.flag)
			draw_flag();

		popMatrix();
	}

	/**
	 * Rotate the robot
	 * @param theta: the angle final the robot has to reach
	 */
	void goToAngle(float theta)
	{
		theta = mod2Pi(theta);
		float delta_angle = theta - this.angle;

		if (abs(delta_angle) < rot_step)
			this.angle = theta;
		else
			if ((delta_angle > 0 && delta_angle < PI) || (delta_angle < 0 && delta_angle < - PI))
				this.angle = mod2Pi(this.angle + rot_step);
			else
				this.angle = mod2Pi(this.angle - rot_step);
 	}

	/**
	* Move the robot to the attribute "next_destination" using the method
	* turn and go, and can go back if forward is false
	* @param forward: indicate if we go forward or back
	*/

	void goTo(boolean forward)
	{
		float turn = (forward) ? 0 : PI;
			
		if (this.position.is_around(this.next_destination, 5))
			return;

		if (forward)
		{
			float dist = this.position.dist(this.next_destination);
			float theta = this.position.angle(this.next_destination);

			if (mod2Pi(theta + turn - this.angle) > rot_step && !this.position.is_around(this.next_destination, 5))
			{
				goToAngle(theta + turn);
				return;
			}
		}
		
		this.position.x += this.speed_regime * cos(this.angle + turn);
		this.position.y += this.speed_regime * sin(this.angle + turn);
		
	}

	boolean haveToBack()
	{
		this.getCorners();

		if(!this.corners[0].on_arena(10) || !this.corners[3].on_arena(10))
			return true;

		return false;
	}

	/**
	 * Calcul the positions of the corners
	 */
	void getCorners()
	{
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
