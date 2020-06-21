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
Pos[] pos_obj = new Pos[] {new Pos(100, 100), new Pos(500, 400), new Pos(1000,830), new Pos(1200, 300), new Pos(-10,-10)};
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
	float x;
	float y;
	float angle;
	Pos[] corners = new Pos[] {new Pos(0,0), new Pos(0,0), new Pos(0,0), new Pos(0,0)};

	Pos dest = new Pos(0,0);

	Robot(int x, int y, float angle)
	{
		this.x = x;
		this.y = y;
		this.angle = angle + PI;
		dest.x = x;
		dest.y = y;

		//bas gauche
		corners[0].x = x + DEMI_DIAG * cos(angle + PI/4);
		corners[0].y = y + DEMI_DIAG * sin(angle + PI/4);
		//hauche gauche
		corners[1].x = x + DEMI_DIAG * cos(angle + 3 * PI/4);
		corners[1].y = y + DEMI_DIAG * sin(angle + 3 * PI/4);
		//bas droite
		corners[2].x = x + DEMI_DIAG * cos(angle - PI/4);
		corners[2].y = y + DEMI_DIAG * sin(angle - PI/4);
		//haut droite
		corners[3].x = x + DEMI_DIAG * cos(angle - 3 * PI/4);
		corners[3].y = y + DEMI_DIAG * sin(angle - 3 * PI/4);
	}


	void affiche()
	{
		background(img);
		//println(x);
		//println(y);
		//println(angle);
		fill(255, 255, 0);
		translate(x, y);
		rotate(angle);
		rectMode(CENTER);
		rect(0, 0, LARGEUR_ROBOT, LONGUEUR_ROBOT);
	}

	void goToAngle(float theta)
	{
		//println("rotate");
		//println(angle);
		//println(theta);
		float angleDiff = mod2Pi(theta - angle);
		if (abs(angleDiff) < petite_rot)
			angle = theta;
		else
		{
			if (angleDiff > PI)
				angle -= petite_rot;
			else
				angle += petite_rot;
		}
 	}

	int goTo(Pos pos)
	{
		if ((this.x == pos.x) && (this.y == pos.y))
		//le robot est à destination
			return 1;

		float dist = sqrt(pow((this.x - pos.x),2) + pow((this.y - pos.y),2));
		float theta = acos((this.x - pos.x)/dist);
		if (this.y - pos.y < 0)
		//detination dans le bas du cercle
			theta -= 2*theta;

		if (abs(theta - angle) > petite_rot/2 && (dest.x != pos.x || dest.y != pos.y))
		{
			goToAngle(theta);
			return 0;
		}

		if (dest.x != pos.x || dest.y != pos.y)
		{
			dest.x = pos.x;
			dest.y = pos.y;
		}

		if (dist < petite_dist)
		{
			this.x = pos.x;
			this.y = pos.y;
		}
		else
		{
			this.x -= petite_dist * cos(theta);
			this.y -= petite_dist * sin(theta);
		}
		return 0;
	}

	void getCorners()
	{
		//haut gauche
		corners[0].x = this.x + DEMI_DIAG * cos(this.angle + PI/4);
		corners[0].y = this.y + DEMI_DIAG * sin(this.angle + PI/4);
		//bas gauche
		corners[1].x = this.x + DEMI_DIAG * cos(this.angle + 3 * PI/4);
		corners[1].y = this.y + DEMI_DIAG * sin(this.angle + 3 * PI/4);
		//haut droite
		corners[2].x = this.x + DEMI_DIAG * cos(this.angle - PI/4);
		corners[2].y = this.y + DEMI_DIAG * sin(this.angle - PI/4);
		//bas droite
		corners[3].x = this.x + DEMI_DIAG * cos(this.angle - 3 * PI/4);
		corners[3].y = this.y + DEMI_DIAG * sin(this.angle - 3 * PI/4);

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
		for(int i=0; i < 4; i++)
		{
			if (corners[i].x < 0 )
				x -= corners[i].x;
			else if (corners[i].x >= LONGUEUR_TERRAIN)
				x -= corners[i].x - LONGUEUR_TERRAIN + 1;
			if (corners[i].y < 0 )
				y -= corners[i].y;
			else if (corners[i].y >= LARGEUR_TERRAIN)
				y -= corners[i].y - LARGEUR_TERRAIN + 1;
		}
	}
};

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
  initialization(Dir.gauche);
}

void draw()
{
	//boucle
	if (robot.goTo(pos_obj[num_obj]) == 1)
		num_obj++;
	robot.getCorners();
	robot.borderColision();
	robot.affiche();
}
