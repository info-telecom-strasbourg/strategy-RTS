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
ArrayList<Pos> dectable_lidar_mobile = new ArrayList();


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
    rob_op_2 = new OpponentRob(new Pos(1400, 700), PI, false);
    rob_op_2.speed_regime = FAST;

    dectable_lidar_mobile.add(POS_LIGHTHOUSE);
    dectable_lidar_mobile.add(POS_LIGHTHOUSE_OP);
    dectable_lidar_mobile.add(POS_WEATHERCOCK);
    dectable_lidar_mobile.add(rob_op.position);
    dectable_lidar_mobile.add(rob_op_2.position);

	smooth();
}

/**
 * Draw the simulation on the screen
 */
void draw()
{
    background(img);
    robot_RTS.goTo(true);
    robot_RTS.draw_robot();

    rob_op.update_destinations();
    rob_op.goTo(true);
    rob_op.draw_robot();
    rob_op.display_dest();

    rob_op_2.update_destinations();
    rob_op_2.goTo(true);
    rob_op_2.draw_robot();
    rob_op_2.display_dest();
}