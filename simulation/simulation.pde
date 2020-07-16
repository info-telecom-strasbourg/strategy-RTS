//Macro for simulation
final int LARGEUR_ROBOT = 100;
final int LONGUEUR_ROBOT = 100;
final int LARGEUR_TERRAIN = 1000;
final int LONGUEUR_TERRAIN = 1500;
final float DEMI_DIAG = sqrt(pow(LARGEUR_ROBOT/2,2) + pow(LONGUEUR_ROBOT/2,2));
final float petite_rot = PI/50;
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
final int TASK_FLAG = 5;

//Macro for colors (weathercock)
final int BLACK = 0;
final int WHITE = 1;
final int NO_COLOR = 2;

Pos POS_LIGHTHOUSE = null;
Pos POS_LIGHTHOUSE_OP = null;
final Pos POS_WEATHERCOCK = new Pos(0,0);
Pos POS_WINDSOCK_1 = null;
Pos POS_WINDSOCK_2 = null;
Pos POS_FLAG = null;

enum Dir {left , right };
Task task_weathercock = new Task(10, POS_WEATHERCOCK, 15000);
Task task_windsock_1 = new Task(5, POS_WINDSOCK_1, 15000);
Task task_windsock_2 = new Task(5, POS_WINDSOCK_2, 15000);
Task task_lighthouse = new Task(13, POS_LIGHTHOUSE, 15000);
Task task_flag = new Task(10, null, 5000);


//Variables
Robot robot;
Robot robot_op;
PImage img;
Strat strat;
Dep dep_robot;

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

void init_robot(Dir dir)
{
	if (dir == Dir.left)
	{
		robot = new Robot(new Pos(100, 410), PI);
		robot_op = new Robot(new Pos(1400, 410), 0);
		POS_WINDSOCK_1 = new Pos(0,0);
		POS_WINDSOCK_2 = new Pos(0,0);
		POS_LIGHTHOUSE = new Pos(0,0);
		POS_LIGHTHOUSE_OP = new Pos(0,0);
	}
	else if (dir == Dir.right)
	{
		robot = new Robot(new Pos(1400, 410), 0);
		robot_op = new Robot(new Pos(100, 410), PI);
		POS_WINDSOCK_1 = new Pos(0,0);
		POS_WINDSOCK_2 = new Pos(0,0);
		POS_LIGHTHOUSE = new Pos(0,0);
		POS_LIGHTHOUSE_OP = new Pos(0,0);
	}

	fill(0, 255, 0);
	pushMatrix();
	translate(robot.position.x, robot.position.y);
	rotate(robot.angle);
	rectMode(CENTER);
	rect(0, 0, LARGEUR_ROBOT, LONGUEUR_ROBOT);
	popMatrix();

	pushMatrix();
	fill(255, 0, 0);
	translate(robot_op.position.x, robot_op.position.y);
	rotate(robot_op.angle);
	rectMode(CENTER);
	rect(0, 0, LARGEUR_ROBOT, LONGUEUR_ROBOT);
	popMatrix();
}

void setup()
{
	img = loadImage("map.png");
	size(1500,1000);
	background(img);
	frameRate(fps);
	init_robot(Dir.left);

	Task[] tab_tasks = {task_weathercock, task_windsock_1, task_windsock_2, task_lighthouse, task_flag};
	strat = new Strat(robot, tab_tasks);
	dep_robot = new Dep(robot_op);
}

void draw()
{
	background(img);
	strat.apply(robot_op);
	dep_robot.apply();
}
