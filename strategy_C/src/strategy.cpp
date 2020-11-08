//#include <Arduino.h>
//#include "board.h"
//#include "turn_and_go.h"
//#include "lidar.h"
//#include "odometry.h"
#include <math.h>
#include <vector>
#include "../include/BottomLidar.h"
#include "../include/TopLidar.h"
#include "../include/MobileLidar.h"
#include "../include/Weathercock.h"
#include "../include/RTSRob.h"
#include "../include/Strat.h"

extern Pos POS_LIGHTHOUSE;
extern Pos POS_LIGHTHOUSE_OP;
extern Pos POS_WEATHERCOCK;
extern Pos POS_WINDSOCK_1;
extern Pos POS_WINDSOCK_2;
extern Pos POS_MOORING_AREA;

/**
* Launcher of the simulation
*/




//Global variables

std::vector<Sensor> sensors_null;
Pos pos_null(0,0);
RTSRob robot_RTS(&pos_null, 0, sensors_null);
OpponentRob rob_op(&pos_null, 0);
OpponentRob rob_op_2(&pos_null, 0);
WeathercockColour weathercock;
std::vector<OpponentRob> rob_opponents;
std::vector<Pos> dectable_lidar_mobile;
Strat strat(robot_RTS);




/**
 * Initialise sensors
 * @return an std::vector of sensors
 */
std::vector<Sensor> init_sensors()
{
    BottomLidar bottomLidar;
    TopLidar topLidar;
    MobileLidar mobileLidar;

    std::vector<Sensor> sensors;
    sensors.push_back(bottomLidar);
    sensors.push_back(topLidar);
    sensors.push_back(mobileLidar);

    return sensors;
}

/**
 * Initialize robot parameters and tasks position according to the start position
 * @param dir: the start position (left or right)
 */
void init_robots()
{
	if (dir == left)
	{
    RTSRob robot_RTS(new Pos(100, 410), 0, init_sensors());

		POS_WINDSOCK_1 = Pos(100,800);
		POS_WINDSOCK_2 = Pos(300,800);
		POS_LIGHTHOUSE = Pos(250,125);
		POS_LIGHTHOUSE_OP = Pos(1250, 125);
		POS_MOORING_AREA = Pos(100, -50);
		POS_WEATHERCOCK = Pos(450, 125);
	}
	else
	{
    RTSRob robot_RTS(new Pos(1400, 410), M_PI, init_sensors());


		POS_WINDSOCK_1 = Pos(1400,800);
		POS_WINDSOCK_2 = Pos(1200,800);
		POS_LIGHTHOUSE = Pos(1250, 125);
		POS_LIGHTHOUSE_OP = Pos(250,125);
		POS_MOORING_AREA = Pos(1400, -50);
		POS_WEATHERCOCK = Pos(1050, 125);
	}
}

/**
 * Initialize the tasks
 */
void init_tasks()
{
  strat.tasks_order.add(TASK_LIGHTHOUSE);
	strat.tasks_order.add(TASK_WINDSOCK_1);
	strat.tasks_order.add(TASK_WINDSOCK_2);

    std::vector<Pos> checkpoint_windsock;
    checkpoint_windsock.add(new Pos(-1,945));
    std::vector<Pos> checkpoint_lighthouse;
    checkpoint_lighthouse.add(new Pos(-1,50));
    std::vector<Pos> checkpoint_weathercock;
    checkpoint_weathercock.add(new Pos(ARENA_HEIGHT/2, -1));

    Weathercock task_weathercock = new Weathercock(TASK_WEATHERCOCK, 10, POS_WEATHERCOCK, 25000, checkpoint_weathercock);
	Windsock task_windsock_1 = new Windsock(TASK_WINDSOCK_1, 5, POS_WINDSOCK_1, 20000, checkpoint_windsock);
	Windsock task_windsock_2 = new Windsock(TASK_WINDSOCK_2, 5, POS_WINDSOCK_2, 20000, checkpoint_windsock);
	Lighthouse task_lighthouse = new Lighthouse(TASK_LIGHTHOUSE, 13, POS_LIGHTHOUSE, 10000, checkpoint_lighthouse);
	MooringArea task_mooring_area = new MooringArea(TASK_MOORING_AREA, 10, POS_MOORING_AREA, 100000);

	Calibration task_calibration = new Calibration(TASK_CALIBRATION, 0, new Pos(-50, -50), 15000);
	GameOver game_over = new GameOver(GAME_OVER, 0, new Pos(-50, -50), 1000000);

    strat.tab_tasks.add(task_weathercock);
    strat.tab_tasks.add(task_windsock_1);
    strat.tab_tasks.add(task_windsock_2);
    strat.tab_tasks.add(task_lighthouse);
    strat.tab_tasks.add(task_mooring_area);
    strat.tab_tasks.add(task_calibration);
    strat.tab_tasks.add(game_over);
}



/**
 * Display the task when our robot know their position
 */
void display_tasks()
{
	for(int i = 0; i < strat.tab_tasks.size(); i++)
		strat.tab_tasks[i].display(true);
}

/**
 * Display the score and the time
 */
void display_infos()
{
	// Afficher sur l'IHM
	// textSize(30);
	// textAlign(LEFT);
	// text((millis() - strat.time)/1000, 1, 21);
	// text(strat.score, 1450, 21);
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

void display_tasks_order(int id)
{
	switch (id)
	{
		case TASK_WEATHERCOCK:
			println("TASK_WEATHERCOCK");
			break;
		case TASK_WINDSOCK_1:
			println("TASK_WINDSOCK_1");
			break;
		case TASK_WINDSOCK_2:
			println("TASK_WINDSOCK_2");
			break;
		case TASK_LIGHTHOUSE:
			println("TASK_LIGHTHOUSE");
			break;
		case TASK_MOORING_AREA:
			println("TASK_MOORING_AREA");
			break;
		case TASK_CALIBRATION:
			println("TASK_CALIBRATION");
			break;
		case GAME_OVER:
			println("GAME_OVER");
			break;
	}
}

Lidar lidar;

void setup() {
    // Setup serial link
    Serial.begin(9600);

		init_robots();


    dectable_lidar_mobile.push_back(POS_LIGHTHOUSE);
    dectable_lidar_mobile.add(POS_LIGHTHOUSE_OP);
    dectable_lidar_mobile.add(POS_WEATHERCOCK);
    dectable_lidar_mobile.add(rob_op.position);
    dectable_lidar_mobile.add(rob_op_2.position);

    weathercock = new WeathercockColour();

    strat = new Strat(robot_RTS);

    init_tasks();

	smooth();

}

void loop() {
	distance_read = lidar.readDistance();

	strat.apply();

	display_infos();

	for (int i = 0; i < strat.tasks_order.size(); i++)
		display_tasks_order(strat.tasks_order[i]);

	manage_robot_op();
}
