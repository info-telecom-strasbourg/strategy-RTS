//Macro for simulation
final int LARGEUR_ROBOT = 100;
final int  LONGUEUR_ROBOT = 100;
final int  LARGEUR_TERRAIN = 1000;
final int  LONGUEUR_TERRAIN = 1500;
final float DEMI_DIAG = sqrt(pow(LARGEUR_ROBOT/2,2) + pow(LONGUEUR_ROBOT/2,2));
final float  petite_rot = PI/50;
final int fps = 30;


//Macro for speed regimes
final int STOP = 0;
final int SLOW = 3;
final int FAST = 10;


//Macro for tasks
final int TASK_WEATHERCOCK = 1;
final int TASK_WINDSOCK_1 = 2;
final int TASK_WINDSOCK_2 = 3;
final int TASK_LIGHTHOUSE = 4;
final int TASK_FLAG_B = 5;
final int TASK_FLAG_W = 6;

//Macro for colors (weathercock)
final int BLACK = 0;
final int WHITE = 1;
final int NO_COLOR = 2;

enum Dir {left , right };

//Global variables for simulation
Robot robot;
PImage img;

//GLobal variables for real strategy
Pos next_position = new Pos(1000, 900);
Pos[] position_goals = new Pos[] {new Pos(0,0), new Pos(0,0), new Pos(0,0), new Pos(0,0), new Pos(0,0), new Pos(0,0)};
int id_current_task;
//vector<Pos> obstacles;
Pos opponent_position;
int color_weathercock = NO_COLOR;
//clock_t time;
//bool[] task_to_do = new bool[] {true, true, true, true, true, true};
//bool final_move = false;
int score = 0;
//vecot<Pos> path;

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
  //Attributes for simulation
  float angle;
  Pos[] corners = new Pos[] {new Pos(0,0), new Pos(0,0), new Pos(0,0), new Pos(0,0)};
  Pos new_position = new Pos(0,0);
  
  //Attributes for real strategy
  int speed_regime = STOP;
	Pos position = new Pos(0,0);
	
  
  

	Robot(int x, int y, float angle)
	{
		this.position.x = x;
		this.position.y = y;
		this.angle = angle + PI;
		this.new_position.x = x;
		this.new_position.y = y;

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
		// println(this.position.x);
		// println(this.position.y);
		//println(this.angle);
		fill(255, 255, 0);
		translate(this.position.x, this.position.y);
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

 
	void goTo(Pos pos)
	{
		if ((this.position.x == pos.x) && (this.position.y == pos.y))
		//le robot est à destination
			return;

		float dist = sqrt(pow((this.position.x - pos.x),2) + pow((this.position.y - pos.y),2));
		float theta = acos((this.position.x - pos.x)/dist);
		// println("dist", dist);
		if (this.position.y - pos.y < 0)
		//detination dans le bas du cercle
			theta -= 2*theta;

		if (abs(theta - this.angle) > petite_rot && (this.new_position.x != pos.x || this.new_position.y != pos.y))
		{
			goToAngle(theta);
			return;
		}

		if (this.new_position.x != pos.x || this.new_position.y != pos.y)
		{
			this.new_position.x = pos.x;
			this.new_position.y = pos.y;
		}

		if (dist < this.speed_regime)
		{
			this.position.x = pos.x;
			this.position.y = pos.y;
		}
		else
		{
			this.position.x -= this.speed_regime * cos(this.angle);
			this.position.y -= this.speed_regime * sin(this.angle);
		}
		return;
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
};

void affichePos(Pos pos, Pos position, float angle)
{
	fill(0, 0, 255);
	rotate(-angle);
	circle(pos.x - position.x, pos.y - position.y, 10);
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
	if (dir == Dir.left)
		robot = new Robot(100, 410, 0);
	else if (dir == Dir.right)
		robot = new Robot(1400, 410, PI);
}

void setup()
{
	size(1500,1000);
	img = loadImage("map.png");
	background(img);
	frameRate(fps);
	initialization(Dir.left);
}

void draw()
{
	//boucle

  //real strategy
  //robot.position = get_position();
  println(robot.position.x," - ", robot.position.y);
  robot.speed_regime = FAST; //fixed_lidar();
  //manage_the_opponent(...); //identify the opponent, and stop if it's usefull
  //id_current_task = find_best_task();
  //if(isAround(robot.position, position_goals[id_current_task], epsilon)
      //do_task(id_current_task) // do the task id_current_task
      //path = [];
  //else
      //if (path == [])
        //path = find_path(); 
      //else
        //path = checkPath();
      //next_position = path[0];
      //if (robot_position ~= path[0])
        //path[0].erase();
  robot.goTo(next_position);
  
  
  
  //simulation
	robot.getCorners();
	robot.borderColision();
	robot.affiche();
	//affichePos(robot.corners[1], robot.position, robot.angle);
}
