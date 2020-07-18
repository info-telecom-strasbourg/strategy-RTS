/**
* Launcher of the simulation
*/


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

//Macro for tasks positions
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
Moves robot_moves;
Weathercock weathercock;

/**
 * Using radians, find the angle in [0, 2 pi]
 * @param angle: the initial angle
 * @return the angle's value in [0, 2 pi]
 */
float mod2Pi(float angle)
{
	while ((angle < 0) || (angle >= 2 * PI))
		if (angle < 0)
			angle += 2 * PI;
		else
			angle -= 2 * PI;

	return angle;
}

ArrayList<Pos> random_positions(int nb)
{
	ArrayList <Pos> path_op = new ArrayList<Pos>();
	for (int i = 0; i < nb; i++)
	{
		int rand_x = int(random(ARENA_HEIGHT - 200)) + 100;
		int rand_y = int(random(ARENA_WIDTH - 200)) + 100;
		path_op.add(new Pos(rand_x,rand_y));
	}

	return path_op;
}


/**
 * Initialize robot parameters and tasks position according to the start position
 * @param dir: the start position (left or right)
 */
void init_robots(Dir dir)
{
	if (dir == Dir.left)
	{
		robot = new Robot(new Pos(100, 410), 0);
		robot_op = new Robot(new Pos(1400, 410), PI);
		POS_WINDSOCK = new Pos(100,800);
		POS_LIGHTHOUSE = new Pos(250,125);
		POS_LIGHTHOUSE_OP = new Pos(1250, 125);
		POS_FLAG = new Pos(50, -50);
		POS_WEATHERCOCK = new Pos(450, 125);
		robot.checkpoint_windsock = new Pos(500,-1);
		robot.side = true;
	}
	else
	{
		robot = new Robot(new Pos(1400, 410), PI);
		robot_op = new Robot(new Pos(100, 410), 0);
		POS_WINDSOCK = new Pos(1400, 800);
		POS_LIGHTHOUSE = new Pos(1250, 125);
		POS_LIGHTHOUSE_OP = new Pos(250,125);
		POS_FLAG = new Pos(1450, -50);
		POS_WEATHERCOCK = new Pos(1050, 125);
		robot.checkpoint_windsock = new Pos(1000,-1);
		robot.side = false;
	}
	
	robot.checkpoint_lighthouse = new Pos(-1,100);
	robot.checkpoint_weathercock = new Pos(ARENA_HEIGHT/2, -1);
}

/**
 * Initialise the table of tasks
 */
void init_tab_tasks()
{
	Task task_weathercock = new Task(10, POS_WEATHERCOCK, 25000);
	Task task_windsock = new Task(15, POS_WINDSOCK, 20000);
	Task task_lighthouse = new Task(13, POS_LIGHTHOUSE, 5000);
	Task task_flag = new Task(10, POS_FLAG, 7000);
	Task[] tab_temp = {task_weathercock, task_windsock, task_lighthouse, task_flag};
	tab_tasks = tab_temp;
}

/**
 * Initialise the robots strategies
 */
void init_robots_strat()
{
	strat = new Strat(robot);
	ArrayList <Pos> path_op = random_positions(53);
	robot_moves = new Moves(robot_op, path_op);
}

/**
 * Initialization of the simulation
 */
void setup()
{
	img = loadImage("map.png");
	size(1500,1000);
	background(img);
	frameRate(fps);
	init_robots(Dir.right);
	init_tab_tasks();
	init_robots_strat();
	weathercock = new Weathercock();
}

/**
 * Display the task when our robot know their position
 */
void display_tasks()
{
	for(int i = 0; i < tab_tasks.length; i++)
		tab_tasks[i].display();
}

/**
 * Display the score and the time
 */
void display_infos()
{
	textSize(30);
	textAlign(LEFT);
	text((millis() - strat.time)/1000, 1, 21);
	text(strat.score, 1450, 21);
}

void display_robot()
{
	robot.getCorners();
	robot.borderColision();
	robot.display(true);
}

/**
 * Draw the simulation on the screen
 */
void draw()
{
	background(img);

	strat.apply(robot_op);
	
	robot_moves.apply();
	display_robot();

	weathercock.display();

	display_tasks();

	display_infos();
}
