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

enum Dir {left , right };
Dir dir = null;

//Global variables
PImage img;
Robot robot;
OpponentRob rob_op;
OpponentRob rob_op_2;


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
 * Initialization of the simulation
 */
void setup()
{
	img = loadImage("map.png");
	size(1500,1000);
	background(img);
	frameRate(fps);

    robot = new Robot(new Pos(100, 410), 0);
    robot.speed_regime = FAST;
    robot.next_destination = new Pos(750, 500);
    rob_op = new OpponentRob(new Pos(1400, 410), PI, true);
    rob_op.speed_regime = FAST;
    rob_op_2 = new OpponentRob(new Pos(700, 410), PI, false);
    rob_op_2.speed_regime = FAST;
	smooth();
}

/**
 * Draw the simulation on the screen
 */
void draw()
{
    background(img);
    robot.goTo(true);
    robot.draw_robot();

    rob_op.update_destinations();
    rob_op.goTo(true);
    rob_op.draw_robot();
    rob_op.display_dest();

    rob_op_2.update_destinations();
    rob_op_2.goTo(true);
    rob_op_2.draw_robot();
    rob_op_2.display_dest();
}