final int LARGEUR_ROBOT = 100;
final int  LONGUEUR_ROBOT = 100;
final int  LARGEUR_TERRAIN = 1000;
final int  LONGUEUR_TERRAIN = 1500;
final float DEMI_DIAG = sqrt(pow(LARGEUR_ROBOT/2,2) + pow(LONGUEUR_ROBOT/2,2));
final float  petite_rot = PI/50;
final int  petite_dist = 3;
final int fps = 30;

enum Dir {gauche , droite };

Robot robot;
PImage img;
//Pos[] pos_obj = new Pos[] {new Pos(2000, 200)};
//Pos[] pos_obj = new Pos[] {new Pos(1000, 100), new Pos(-10,-10)};
//Pos[] pos_obj = new Pos[] { new Pos(1000, 900), new Pos(0, 1200)};
Pos[] pos_obj = new Pos[] {new Pos(1500, 1100)};

int num_obj = 0;

class Pos
{
	float x;
	float y;

	Pos(float x, float y)
	{
		this.x = x;
		this.y = y;
	}
};

class Robot
{
	Pos pos = new Pos(0,0);
	float angle;
	Pos[] corners = new Pos[] {new Pos(0,0), new Pos(0,0), new Pos(0,0), new Pos(0,0)};

	Pos dest = new Pos(0,0);

	Robot(int x, int y, float angle)
	{
		this.pos.x = x;
		this.pos.y = y;
		this.angle = angle + PI;
		this.dest.x = x;
		this.dest.y = y;

		//bas gauche
		corners[0].x = x + DEMI_DIAG * cos(angle + PI/4);
		corners[0].y = y + DEMI_DIAG * sin(angle + PI/4);
		//hauche gauche
		corners[1].x = x + DEMI_DIAG * cos(angle + 3 * PI/4);
		corners[1].y = y + DEMI_DIAG * sin(angle + 3 * PI/4);
		//haut droite
		corners[2].x = x + DEMI_DIAG * cos(angle - 3 * PI/4);
		corners[2].y = y + DEMI_DIAG * sin(angle - 3 * PI/4);
		//bas droite
		corners[3].x = x + DEMI_DIAG * cos(angle - PI/4);
		corners[3].y = y + DEMI_DIAG * sin(angle - PI/4);
	}


	void affiche()
	{
		background(img);
		// println(this.pos.x);
		// println(this.pos.y);
		//println(this.angle);
		fill(255, 255, 0);
		translate(this.pos.x, this.pos.y);
		rotate(this.angle);
		rectMode(CENTER);
		rect(0, 0, LARGEUR_ROBOT, LONGUEUR_ROBOT);
	}

	void goToAngle(float theta)
	{
		//println("rotate");
		//println(angle);
		//println(theta);
		float angleDiff = mod2Pi(theta - this.angle);
		if (abs(angleDiff) < petite_rot)
			this.angle = theta;
		else
		{
			if (angleDiff > PI)
				this.angle -= petite_rot;
			else
				this.angle += petite_rot;
		}
 	}

	int goTo(Pos pos)
	{
		if ((this.pos.x == pos.x) && (this.pos.y == pos.y))
		//le robot est à destination
			return 1;

		float dist = sqrt(pow((this.pos.x - pos.x),2) + pow((this.pos.y - pos.y),2));
		float theta = acos((this.pos.x - pos.x)/dist);
		println("dist", dist);
		if (this.pos.y - pos.y < 0)
		//detination dans le bas du cercle
			theta -= 2*theta;

		if (abs(theta - this.angle) > petite_rot && (this.dest.x != pos.x || this.dest.y != pos.y))
		{
			goToAngle(theta);
			return 0;
		}

		if (this.dest.x != pos.x || this.dest.y != pos.y)
		{
			this.dest.x = pos.x;
			this.dest.y = pos.y;
		}

		if (dist < petite_dist)
		{
			this.pos.x = pos.x;
			this.pos.y = pos.y;
		}
		else
		{
			this.pos.x -= petite_dist * cos(this.angle);
			this.pos.y -= petite_dist * sin(this.angle);
		}
		return 0;
	}

	void getCorners()
	{
		//le PI/4 est vrai que si le robot est carré

		//haut gauche
		corners[0].x = this.pos.x + DEMI_DIAG * cos(this.angle + PI/4);
		corners[0].y = this.pos.y + DEMI_DIAG * sin(this.angle + PI/4);
		//bas gauche
		corners[1].x = this.pos.x + DEMI_DIAG * cos(this.angle + 3 * PI/4);
		corners[1].y = this.pos.y + DEMI_DIAG * sin(this.angle + 3 * PI/4);
		//bas droite
		corners[2].x = this.pos.x + DEMI_DIAG * cos(this.angle - 3 * PI/4);
		corners[2].y = this.pos.y + DEMI_DIAG * sin(this.angle - 3 * PI/4);
		//haut droite
		corners[3].x = this.pos.x + DEMI_DIAG * cos(this.angle - PI/4);
		corners[3].y = this.pos.y + DEMI_DIAG * sin(this.angle - PI/4);

		// println("haut gauche");
		// println(corners[0].x);
		// println(corners[0].y);
		// println(corners[1].x);
		// println(corners[1].y);
		// println(corners[2].x);
		// println(corners[2].y);
		// println(corners[3].x);
		// println(corners[3].y);
	}

	void borderColision()
	{
		if ((corners[1].x < 0) && corners[2].x < 0)
		{
			this.angle = 0;
			this.pos.x = LONGUEUR_ROBOT/2; // la longeur étant la distance de l'avant à l'arrière du robot
			getCorners();
		}
		else if ((corners[1].x > LONGUEUR_TERRAIN - 1) && (corners[2].x > LONGUEUR_TERRAIN - 1))
		{
			this.angle = PI;
			this.pos.x = LONGUEUR_TERRAIN - 1 - LONGUEUR_ROBOT/2;
			getCorners();
		}
		if ((corners[1].y < 0) && (corners[2].y < 0))
		{
			this.angle = PI/2;
			this.pos.y = LONGUEUR_ROBOT/2;
			getCorners();
		}
		else if ((corners[1].y > LARGEUR_TERRAIN - 1) && (corners[2].y > LARGEUR_TERRAIN - 1))
		{
			this.angle = 3 * PI/2;
			this.pos.y = LARGEUR_TERRAIN - 1 - LONGUEUR_ROBOT/2;
			getCorners();
		}
		if ((corners[0].x < 0) && corners[3].x < 0)
		{
			this.angle = PI;
			this.pos.x = LONGUEUR_ROBOT/2; // la longeur étant la distance de l'avant à l'arrière du robot
			getCorners();
		}
		else if ((corners[0].x > LONGUEUR_TERRAIN - 1) && (corners[3].x > LONGUEUR_TERRAIN - 1))
		{
			this.angle = 0;
			this.pos.x = LONGUEUR_TERRAIN - 1 - LONGUEUR_ROBOT/2;
			getCorners();
		}
		if ((corners[0].y < 0) && (corners[3].y < 0))
		{
			this.angle = 3 * PI/2;
			this.pos.y = LONGUEUR_ROBOT/2;
			getCorners();
		}
		else if ((corners[0].y > LARGEUR_TERRAIN - 1) && (corners[3].y > LARGEUR_TERRAIN - 1))
		{
			this.angle = PI/2;
			this.pos.y = LARGEUR_TERRAIN - 1 - LONGUEUR_ROBOT/2;
			getCorners();
		}

		for(int i = 0; i < 4; i++)
		{
			float angleDiff;
			if (corners[i].x < 0)
			{
				angleDiff = acos(this.pos.x/sqrt(pow(this.pos.y - corners[i].y,2) + pow(this.pos.x - corners[i].x,2))) - atan(abs((this.pos.y - corners[i].y)/(this.pos.x - corners[i].x)));
				if (corners[i].y < this.pos.y)
					this.angle += angleDiff;
				else if(corners[i].y > this.pos.y)
					this.angle -= angleDiff;
				else
					this.pos.x -= corners[i].x;
				getCorners();
			}
			else if (corners[i].x > LONGUEUR_TERRAIN - 1)
			{
				angleDiff = acos((LONGUEUR_TERRAIN - 1 - this.pos.x)/sqrt(pow(this.pos.y - corners[i].y,2) + pow(this.pos.x - corners[i].x,2))) - atan(abs((this.pos.y - corners[i].y)/(this.pos.x - corners[i].x)));
				if (corners[i].y < this.pos.y)
					this.angle -= angleDiff;
				else if(corners[i].y > this.pos.y)
					this.angle += angleDiff;
				else
					this.pos.x -= corners[i].x - LONGUEUR_TERRAIN + 1;
				getCorners();
			}
			if (corners[i].y < 0)
			{
				angleDiff = acos(this.pos.y/sqrt(pow(this.pos.y - corners[i].y,2) + pow(this.pos.x - corners[i].x,2))) - atan(abs((this.pos.x - corners[i].x)/(this.pos.y - corners[i].y)));
				if (corners[i].x < this.pos.x)
					this.angle -= angleDiff;
				else if(corners[i].x > this.pos.x)
					this.angle += angleDiff;
				else
					this.pos.y -= corners[i].y;
				getCorners();
			}
			else if (corners[i].y > LARGEUR_TERRAIN - 1)
			{
				angleDiff = acos((LARGEUR_TERRAIN - 1 - this.pos.y)/sqrt(pow(this.pos.y - corners[i].y,2) + pow(this.pos.x - corners[i].x,2))) - atan(abs((this.pos.x - corners[i].x)/(this.pos.y - corners[i].y)));
				if (corners[i].x < this.pos.x)
					this.angle += angleDiff;
				else if(corners[i].x > this.pos.x)
					this.angle -= angleDiff;
				else
					this.pos.y -= corners[i].y - LARGEUR_TERRAIN + 1;
				getCorners();
			}
		}
	}
};

void affichePos(Pos pos, Pos posRobot, float angle)
{
	fill(0, 0, 255);
	rotate(-angle);
	circle(pos.x - posRobot.x, pos.y - posRobot.y, 10);
}

float mod2Pi(float nb)
{
	while ((nb < 0) || (nb >= 2 * PI))
	{
		if (nb < 0)
			nb += 2 * PI;
		else
			nb -= 2 * PI;
	}
	return nb;
}

void initialization(Dir dir)
{
	if (dir == Dir.gauche)
		robot = new Robot(100, 410, 0);
	else if (dir == Dir.droite)
		robot = new Robot(1400, 410, PI);
}

void setup()
{
	size(1500,1000);
	img = loadImage("map.png");
	background(img);
	frameRate(fps);
	initialization(Dir.droite);
}

void draw()
{
	//boucle
	if (robot.goTo(pos_obj[num_obj]) == 1)
		num_obj++;
	robot.getCorners();
	robot.borderColision();
	robot.affiche();
	//affichePos(robot.corners[1], robot.pos, robot.angle);
}
