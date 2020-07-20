class Robot
{
    /* The robot position */
    Pos position;
    
    /* The robot angle */
    float angle;

    /* The next destination */
    Pos next_destination;

    /* The corners of the robot */
	Pos[] corners = new Pos[4];

    /* The robot speed regime */
    int speed_regime;

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
	 * If the front of the robot is too close from the border, it indicates that
     * the robot has to move back 
	 * @return if the robot has to move back 
	 */
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
    

    /**
	 * Calcul the positions of the corners
	 */
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

    /**
	 * Draw a square representing the blue 
     * The yellow triangle represent the robot direction
	 */
	void draw_robot()
	{
        pushMatrix();
        
		fill(0, 0, 255);
		translate(this.position.x, this.position.y);
		rotate(this.angle);
		rectMode(CENTER);
		rect(0, 0, ROBOT_WIDTH, ROBOT_HEIGHT);
        fill(255, 255, 0);
		triangle(ROBOT_HEIGHT/2, 0, 0, -ROBOT_WIDTH/2, 0, ROBOT_WIDTH/2);

        popMatrix();
	}
}