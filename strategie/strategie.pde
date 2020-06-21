final int LARGEUR_ROBOT = 100;
final int  LONGUEUR_ROBOT = 100;
final int  LARGEUR_TERRAIN = 1000;
final int  LONGUEUR_TERRAIN = 1500;
final float  petite_rot = PI/50;
final int  petite_dist = 3;
final int fps = 30;

enum Dir {gauche , droite };

Robot robot;
PImage img;
Pos[] pos_obj = new Pos[] {new Pos(100,200), new Pos(500, 400), new Pos(1000,830), new Pos(1200, 300)};
int num_obj = 0;

class Pos
{
  int x;
  int y;

  Pos(int x, int y)
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

	Robot(int x, int y, float angle)
	{
		this.x = x;
		this.y = y;
		this.angle = angle;
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
		if (abs(theta - angle) < petite_rot)
			angle = theta;
		else
		{
			if (angle > theta)
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
    println(theta - angle);
		if ((theta - angle) > petite_rot)
		{
			goToAngle(theta);
			return 0;
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

}

void initialization(Dir dir)
{
	if (dir == Dir.gauche)
		robot = new Robot(100, 410, PI);
	else if (dir == Dir.droite)
		robot = new Robot(1400, 410, 0);
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
	robot.affiche();
}
