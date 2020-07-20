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

//Macro for tasks
final int TASK_WEATHERCOCK = 0;
final int TASK_WINDSOCK_1 = 1;
final int TASK_WINDSOCK_2 = 2;
final int TASK_LIGHTHOUSE = 3;
final int TASK_CUPS = 4;
final int TASK_FLAG = 5;
final int TASK_CALIBRATION = 6;
final int GAME_OVER = 7;

//Macro for speed regimes
final int STOP = 0;
final int SLOW = 3;
final int FAST = 10;

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
Pos POS_WINDSOCK_1 = null;
Pos POS_WINDSOCK_2 = null;
Pos POS_CUPS = null;
Pos POS_FLAG = null;

//Macro for tasks positions
int BOTTOM_LIDAR = 0;
int TOP_LIDAR = 1;
int MOBILE_LIDAR = 2;


enum Dir {left , right };
Dir dir = Dir.left;

//Global variables
PImage img;
RTSRob robot_RTS;
OpponentRob rob_op;
OpponentRob rob_op_2;
WeathercockColour weathercock;
ArrayList<OpponentRob> rob_opponents = new ArrayList();
ArrayList<Pos> dectable_lidar_mobile = new ArrayList();
Strat strat;



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

/**
 * Initialise sensors
 * @return an ArrayList of sensors
 */
ArrayList<Sensor> init_sensors()
{
    BottomLidar bottomLidar = new BottomLidar();
    TopLidar topLidar = new TopLidar();
    MobileLidar mobileLidar = new MobileLidar();

    ArrayList<Sensor> sensors = new ArrayList();
    sensors.add(bottomLidar);
    sensors.add(topLidar);
    sensors.add(mobileLidar);

    return sensors;
}

/**
 * Manage the opponent behavement
 */
void manage_robot_op()
{
    rob_op.update_destinations();
    rob_op.goTo(true);
    rob_op.draw_robot();
    rob_op.display_dest();
}

/**
 * Initialize robot parameters and tasks position according to the start position
 * @param dir: the start position (left or right)
 */
void init_robots()
{
    // rob_op_2 = new OpponentRob(new Pos(1400, 700), PI, false);
    // rob_op_2.speed_regime = FAST;
    // rob_opponents.add(rob_op_2);
	if (dir == Dir.left)
	{
        robot_RTS = new RTSRob(new Pos(100, 410), 0, init_sensors());
		rob_op = new OpponentRob(new Pos(1400, 410), PI, true);

		POS_WINDSOCK_1 = new Pos(100,800);
		POS_WINDSOCK_2 = new Pos(300,800);
		POS_LIGHTHOUSE = new Pos(250,125);
		POS_LIGHTHOUSE_OP = new Pos(1250, 125);
		POS_FLAG = new Pos(100, -50);
		POS_WEATHERCOCK = new Pos(450, 125);
	}
	else
	{
        robot_RTS = new RTSRob(new Pos(1400, 410), PI, init_sensors());
		rob_op = new OpponentRob(new Pos(100, 410), 0, true);
    
		POS_WINDSOCK_1 = new Pos(1400,800);
		POS_WINDSOCK_2 = new Pos(1200,800);
		POS_LIGHTHOUSE = new Pos(1250, 125);
		POS_LIGHTHOUSE_OP = new Pos(250,125);
		POS_FLAG = new Pos(1400, -50);
		POS_WEATHERCOCK = new Pos(1050, 125);
	}
	
    rob_opponents.add(rob_op);
	POS_CUPS = new Pos(ARENA_HEIGHT/2, ARENA_WIDTH/2);
}

/**
 * Initialize the tasks
 */
void init_tasks()
{
    strat.tasks_order.add(TASK_LIGHTHOUSE);
	strat.tasks_order.add(TASK_WINDSOCK_1);
	strat.tasks_order.add(TASK_WINDSOCK_2);
	strat.tasks_order.add(TASK_WEATHERCOCK);
	strat.tasks_order.add(TASK_CUPS);
	strat.tasks_order.add(TASK_FLAG);
	strat.tasks_order.add(GAME_OVER);

    ArrayList<Pos> checkpoint_windsock = new ArrayList<Pos>();
    checkpoint_windsock.add(new Pos(-1,945));
    ArrayList<Pos> checkpoint_lighthouse = new ArrayList<Pos>();
    checkpoint_lighthouse.add(new Pos(-1,50));
    ArrayList<Pos> checkpoint_weathercock = new ArrayList<Pos>();
    checkpoint_weathercock.add(new Pos(ARENA_HEIGHT/2, -1));
    
    Weathercock task_weathercock = new Weathercock(TASK_WEATHERCOCK, 10, POS_WEATHERCOCK, 25000, checkpoint_weathercock);
	Windsock task_windsock_1 = new Windsock(TASK_WINDSOCK_1, 5, POS_WINDSOCK_1, 20000, checkpoint_windsock);
	Windsock task_windsock_2 = new Windsock(TASK_WINDSOCK_2, 5, POS_WINDSOCK_2, 20000, checkpoint_windsock);
	Lighthouse task_lighthouse = new Lighthouse(TASK_WEATHERCOCK, 13, POS_LIGHTHOUSE, 5000, checkpoint_lighthouse);
	Cups task_cups = new Cups(TASK_CUPS, 0, POS_CUPS, 10000, 1);
	Flag task_flag = new Flag(TASK_FLAG, 10, POS_FLAG, 7000);
	Calibration task_calibration = new Calibration(TASK_CALIBRATION, 0, new Pos(-50, -50), 15000);
	GameOver game_over = new GameOver(GAME_OVER, 0, new Pos(-50, -50), 1000000);

    strat.tab_tasks.add(task_weathercock);
    strat.tab_tasks.add(task_windsock_1);
    strat.tab_tasks.add(task_windsock_2);
    strat.tab_tasks.add(task_lighthouse);
    strat.tab_tasks.add(task_cups);
    strat.tab_tasks.add(task_flag);
    strat.tab_tasks.add(task_calibration);
    strat.tab_tasks.add(game_over);
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

    init_robots();  
    

    dectable_lidar_mobile.add(POS_LIGHTHOUSE);
    dectable_lidar_mobile.add(POS_LIGHTHOUSE_OP);
    dectable_lidar_mobile.add(POS_WEATHERCOCK);
    dectable_lidar_mobile.add(rob_op.position);
    // dectable_lidar_mobile.add(rob_op_2.position);

    weathercock = new WeathercockColour();

    strat = new Strat(robot_RTS);
    
    init_tasks();

	smooth();
}

/**
 * Display the task when our robot know their position
 */
void display_tasks()
{
	for(int i = 0; i < strat.tab_tasks.size(); i++)
		strat.tab_tasks.get(i).display(true);
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

/**
 * Manage the robot displayment
 */
void display_robot()
{
	robot_RTS.getCorners();
	robot_RTS.borderColision();
	robot_RTS.draw_robot();
}

/**
 * Draw the simulation on the screen
 */
void draw()
{
    background(img);
    
	strat.apply();
	
	display_robot();

	weathercock.display();

	display_tasks();

	display_infos();

	println("-------------");
	for (int i = 0; i < strat.tasks_order.size(); i++)
		println("TASK ", strat.tasks_order.get(i));

    manage_robot_op();
}
