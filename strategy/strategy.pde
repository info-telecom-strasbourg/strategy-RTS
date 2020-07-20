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
Dir dir = null;

//Global variables
PImage img;
Robot robot_RTS;
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

void manage_robot_op()
{
    rob_op.update_destinations();
    rob_op.goTo(true);
    rob_op.draw_robot();
    rob_op.display_dest();
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

    robot_RTS = new RTSRob(new Pos(100, 410), 0, init_sensors());
    robot_RTS.speed_regime = FAST;
    robot_RTS.next_destination = new Pos(750, 500);

    rob_op = new OpponentRob(new Pos(1400, 410), PI, true);
    rob_op.speed_regime = FAST;
    rob_opponents.add(rob_op);

    // rob_op_2 = new OpponentRob(new Pos(1400, 700), PI, false);
    // rob_op_2.speed_regime = FAST;
    // rob_opponents.add(rob_op_2);

    dectable_lidar_mobile.add(POS_LIGHTHOUSE);
    dectable_lidar_mobile.add(POS_LIGHTHOUSE_OP);
    dectable_lidar_mobile.add(POS_WEATHERCOCK);
    dectable_lidar_mobile.add(rob_op.position);
    // dectable_lidar_mobile.add(rob_op_2.position);

    weathercock = new WeathercockColour();

	smooth();
}

/**
 * Display the task when our robot know their position
 */
void display_tasks()
{
	for(int i = 0; i < strat.tab_tasks.length; i++)
		strat.tab_tasks[i].display(true);
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
    

    background(img);

	strat.apply(robot_op);
	

	display_robot();

	weathercock.display();

	display_tasks();

	display_infos();

	println("-------------");
	for (int i = 0; i < strat.tasks_order.size(); i++)
		println("TASK ", strat.tasks_order.get(i));

    manage_robot_op()
}