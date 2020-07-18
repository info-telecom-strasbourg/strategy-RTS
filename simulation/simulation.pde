//Macro for simulation
final int ROBOT_WIDTH = 100;
final int ROBOT_HEIGHT = 100;
final int ARENA_WIDTH = 1000;
final int ARENA_HEIGHT = 1500;
final float HALF_DIAG = sqrt(pow(ROBOT_WIDTH/2,2) + pow(ROBOT_HEIGHT/2,2));
final float rot_step = PI/50;
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

void init_robot(Dir dir)
{
	if (dir == Dir.left)
	{
		robot = new Robot(new Pos(100, 410), 0);
		robot_op = new Robot(new Pos(1400, 410), PI);
		POS_WINDSOCK = new Pos(100,950);
		POS_LIGHTHOUSE = new Pos(250,125);
		POS_LIGHTHOUSE_OP = new Pos(1250, 125);
		POS_FLAG = new Pos(50, -50);
		POS_WEATHERCOCK = new Pos(450, 125);
		robot.checkpoint_windsock = new Pos(500,-1);
		robot.side = true;
	}
	else if (dir == Dir.right)
	{
		robot = new Robot(new Pos(1400, 410), PI);
		robot_op = new Robot(new Pos(100, 410), 0);
		POS_WINDSOCK = new Pos(1400, 950);
		POS_LIGHTHOUSE = new Pos(1250, 125);
		POS_LIGHTHOUSE_OP = new Pos(250,125);
		POS_FLAG = new Pos(1450, -50);
		POS_WEATHERCOCK = new Pos(1050, 125);
		robot.checkpoint_windsock = new Pos(1000,-1);
		robot.side = false;
	}

	robot.checkpoint_lighthouse = new Pos(-1,15);
	robot.checkpoint_weathercock = new Pos(ARENA_HEIGHT/2, -1);

	fill(0, 255, 0);
	pushMatrix();
	translate(robot.position.x, robot.position.y);
	rotate(robot.angle);
	rectMode(CENTER);
	rect(0, 0, ROBOT_WIDTH, ROBOT_HEIGHT);
	popMatrix();

	pushMatrix();
	fill(255, 0, 0);
	translate(robot_op.position.x, robot_op.position.y);
	rotate(robot_op.angle);
	rectMode(CENTER);
	rect(0, 0, ROBOT_WIDTH, ROBOT_HEIGHT);
	popMatrix();
}

void setup()
{
	img = loadImage("map.png");
	size(1500,1000);
	background(img);
	frameRate(fps);
	init_robot(Dir.right);

	strat = new Strat(robot);
	Pos[] path_op = {new Pos(1300,ARENA_WIDTH/2)};
	dep_robot = new Dep(robot_op, path_op);
	girouette = new Girouette();
	Task task_weathercock = new Task(10, POS_WEATHERCOCK, 25000);
	Task task_windsock = new Task(15, POS_WINDSOCK, 20000);
	Task task_lighthouse = new Task(13, POS_LIGHTHOUSE, 5000);
	Task task_flag = new Task(10, POS_FLAG, 7000);
	Task[] tab_temp = {task_weathercock, task_windsock, task_lighthouse, task_flag};
	tab_tasks = tab_temp;
}

void draw()
{
	background(img);
	strat.apply(robot_op);
	dep_robot.apply();
	girouette.display();

	for(int i = 0; i < tab_tasks.length; i++)
		tab_tasks[i].display();

	textSize(30);
	textAlign(LEFT);
	text((millis() - strat.time)/1000, 1, 21);
	text(strat.score, 1450, 21);
}
