class Robot
{
	//STRATEGY
	Pos position;
	float angle;
	int speed_regime;
	Pos next_position;
	int detected_color;
	Pos checkpoint_windsock;

	Robot(Pos pos, float angle)
	{
		this.position = pos;
		this.angle = angle;
		this.speed_regime = STOP;
		this.next_position = null;


		//SIMULATION
		//bas gauche
		this.corners[0].x = pos.x + DEMI_DIAG * cos(mod2Pi(this.angle + PI/4));
		this.corners[0].y = pos.y + DEMI_DIAG * sin(mod2Pi(this.angle + PI/4));
		//haut gauche
		this.corners[1].x = pos.x + DEMI_DIAG * cos(mod2Pi(this.angle + 3 * PI/4));
		this.corners[1].y = pos.y + DEMI_DIAG * sin(mod2Pi(this.angle + 3 * PI/4));
		//haut droite
		this.corners[2].x = pos.x + DEMI_DIAG * cos(mod2Pi(this.angle - 3 * PI/4));
		this.corners[2].y = pos.y + DEMI_DIAG * sin(mod2Pi(this.angle - 3 * PI/4));
		//bas droite
		this.corners[3].x = pos.x + DEMI_DIAG * cos(mod2Pi(this.angle - PI/4));
		this.corners[3].y = pos.y + DEMI_DIAG * sin(mod2Pi(this.angle - PI/4));
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
		theta = mod2Pi(theta);
		float angleDiff = theta - this.angle;

		if (abs(angleDiff) < petite_rot)
			this.angle = theta;
		else
		{
			if ((angleDiff > 0 && angleDiff < PI) || (angleDiff < 0 && angleDiff < -PI))
				this.angle = mod2Pi(this.angle + petite_rot);
			else
				this.angle = mod2Pi(this.angle - petite_rot);
		}
 	}

	void goTo()
	{

		if (this.position.isAround(this.next_position, 50)) //le robot est à destination
			return;


		float dist = sqrt(pow((this.position.x - this.next_position.x),2) + pow((this.position.y - this.next_position.y),2));
		float theta = this.position.angle(this.next_position);
		println("theta", theta);

		if (mod2Pi(theta - this.angle) > petite_rot && (this.new_position.x != this.next_position.x || this.new_position.y != this.next_position.y))
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

	void getCorners()
	{
		//le PI/4 est vrai que si le robot est carré

		//haut gauche
		corners[0].x = this.position.x + DEMI_DIAG * cos(this.angle + PI/4);
		corners[0].y = this.position.y + DEMI_DIAG * sin(this.angle + PI/4);
		//bas gauche
		corners[1].x = this.position.x + DEMI_DIAG * cos(this.angle + 3 * PI/4);
		corners[1].y = this.position.y + DEMI_DIAG * sin(this.angle + 3 * PI/4);
		//bas droite
		corners[2].x = this.position.x + DEMI_DIAG * cos(this.angle - 3 * PI/4);
		corners[2].y = this.position.y + DEMI_DIAG * sin(this.angle - 3 * PI/4);
		//haut droite
		corners[3].x = this.position.x + DEMI_DIAG * cos(this.angle - PI/4);
		corners[3].y = this.position.y + DEMI_DIAG * sin(this.angle - PI/4);
	}

	void borderColision()
	{
		if ((corners[1].x < 0) && corners[2].x < 0)
		{
			this.angle = 0;
			this.position.x = LONGUEUR_ROBOT/2; // la longeur étant la distance de l'avant à l'arrière du robot
			getCorners();
		}
		else if ((corners[1].x > LONGUEUR_TERRAIN - 1) && (corners[2].x > LONGUEUR_TERRAIN - 1))
		{
			this.angle = PI;
			this.position.x = LONGUEUR_TERRAIN - 1 - LONGUEUR_ROBOT/2;
			getCorners();
		}
		if ((corners[1].y < 0) && (corners[2].y < 0))
		{
			this.angle = PI/2;
			this.position.y = LONGUEUR_ROBOT/2;
			getCorners();
		}
		else if ((corners[1].y > LARGEUR_TERRAIN - 1) && (corners[2].y > LARGEUR_TERRAIN - 1))
		{
			this.angle = 3 * PI/2;
			this.position.y = LARGEUR_TERRAIN - 1 - LONGUEUR_ROBOT/2;
			getCorners();
		}
		if ((corners[0].x < 0) && corners[3].x < 0)
		{
			this.angle = PI;
			this.position.x = LONGUEUR_ROBOT/2; // la longeur étant la distance de l'avant à l'arrière du robot
			getCorners();
		}
		else if ((corners[0].x > LONGUEUR_TERRAIN - 1) && (corners[3].x > LONGUEUR_TERRAIN - 1))
		{
			this.angle = 0;
			this.position.x = LONGUEUR_TERRAIN - 1 - LONGUEUR_ROBOT/2;
			getCorners();
		}
		if ((corners[0].y < 0) && (corners[3].y < 0))
		{
			this.angle = 3 * PI/2;
			this.position.y = LONGUEUR_ROBOT/2;
			getCorners();
		}
		else if ((corners[0].y > LARGEUR_TERRAIN - 1) && (corners[3].y > LARGEUR_TERRAIN - 1))
		{
			this.angle = PI/2;
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
					this.angle += angleDiff;
				else if(corners[i].y > this.position.y)
					this.angle -= angleDiff;
				else
					this.position.x -= corners[i].x;
				getCorners();
			}
			else if (corners[i].x > LONGUEUR_TERRAIN - 1)
			{
				angleDiff = acos((LONGUEUR_TERRAIN - 1 - this.position.x)/sqrt(pow(this.position.y - corners[i].y,2) + pow(this.position.x - corners[i].x,2))) - atan(abs((this.position.y - corners[i].y)/(this.position.x - corners[i].x)));
				if (corners[i].y < this.position.y)
					this.angle -= angleDiff;
				else if(corners[i].y > this.position.y)
					this.angle += angleDiff;
				else
					this.position.x -= corners[i].x - LONGUEUR_TERRAIN + 1;
				getCorners();
			}
			if (corners[i].y < 0)
			{
				angleDiff = acos(this.position.y/sqrt(pow(this.position.y - corners[i].y,2) + pow(this.position.x - corners[i].x,2))) - atan(abs((this.position.x - corners[i].x)/(this.position.y - corners[i].y)));
				if (corners[i].x < this.position.x)
					this.angle -= angleDiff;
				else if(corners[i].x > this.position.x)
					this.angle += angleDiff;
				else
					this.position.y -= corners[i].y;
				getCorners();
			}
			else if (corners[i].y > LARGEUR_TERRAIN - 1)
			{
				angleDiff = acos((LARGEUR_TERRAIN - 1 - this.position.y)/sqrt(pow(this.position.y - corners[i].y,2) + pow(this.position.x - corners[i].x,2))) - atan(abs((this.position.x - corners[i].x)/(this.position.y - corners[i].y)));
				if (corners[i].x < this.position.x)
					this.angle += angleDiff;
				else if(corners[i].x > this.position.x)
					this.angle -= angleDiff;
				else
					this.position.y -= corners[i].y - LARGEUR_TERRAIN + 1;
				getCorners();
			}
		}
	}
}
