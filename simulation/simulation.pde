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
final int TASK_WEATHERCOCK = 0;
final int TASK_WINDSOCK = 1;
final int TASK_LIGHTHOUSE = 2;
final int TASK_FLAG = 3;

//Macro for colors (weathercock)
final int NO_COLOR = 0;
final int BLACK = 1;
final int WHITE = 2;

//Macro for done
final int NOT_DONE = 0;
final int IN_PROGRESS = 1;
final int DONE = 2;

Pos POS_LIGHTHOUSE = null;
Pos POS_LIGHTHOUSE_OP = null;
Pos POS_WEATHERCOCK = null;
Pos POS_WINDSOCK = null;
Pos POS_FLAG = null;

enum Dir {left , right };
Task[] tab_tasks = null;


//Variables
Robot robot;
Robot robot_op;
PImage img;
Strat strat;
Dep dep_robot;
Girouette girouette;


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

float arcos(Pos pos_rob, Pos pos_des) {
	float dist = pos_rob.dist(pos_des);
	if(pos_des.y > pos_rob.y && pos_des.x > pos_rob.x)
		return acos(abs(pos_des.x - pos_rob.x)/dist);
	if(pos_des.y > pos_rob.y && pos_des.x < pos_rob.x)
		return PI - acos(abs(pos_des.x - pos_rob.x)/dist);
	if(pos_des.y < pos_rob.y && pos_des.x > pos_rob.x)
		return 2*PI - acos(abs(pos_des.x - pos_rob.x)/dist);
	else
		return PI + acos(abs(pos_des.x - pos_rob.x)/dist);
 }

void init_robot(Dir dir)
{
	if (dir == Dir.left)
	{
		robot = new Robot(new Pos(100, 410), 0);
		robot_op = new Robot(new Pos(1400, 410), PI);
		POS_WINDSOCK = new Pos(50,925);
		POS_LIGHTHOUSE = new Pos(250,125);
		POS_LIGHTHOUSE_OP = new Pos(1250, 875);
		POS_FLAG = new Pos(50, -50);
		POS_WEATHERCOCK = new Pos(450, 125);
	}
	else if (dir == Dir.right)
	{
		robot = new Robot(new Pos(1400, 410), PI);
		robot_op = new Robot(new Pos(100, 410), 0);
		POS_WINDSOCK = new Pos(1450, 925);
		POS_LIGHTHOUSE = new Pos(1250, 875);
		POS_LIGHTHOUSE_OP = new Pos(250,125);
		POS_FLAG = new Pos(1450, -50);
		POS_WEATHERCOCK = new Pos(1050, 125);
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

	strat = new Strat(robot);
	dep_robot = new Dep(robot_op);
	girouette = new Girouette();
	Task task_weathercock = new Task(10, POS_WEATHERCOCK, 25000);
	Task task_windsock = new Task(15, POS_WINDSOCK, 20000);
	Task task_lighthouse = new Task(13, POS_LIGHTHOUSE, 15000);
	Task task_flag = new Task(10, POS_FLAG, 7000);
	Task[] tab_temp = {task_weathercock, task_windsock, task_lighthouse, task_flag};
	tab_tasks = tab_temp;
}

void draw()
{
	background(img);
	strat.apply(robot_op);
	dep_robot.apply();
	girouette.affiche();

	for(int i = 0; i < tab_tasks.length; i++)
		tab_tasks[i].affiche();
}
