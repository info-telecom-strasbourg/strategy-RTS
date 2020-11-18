#include <Arduino.h>
#include <math.h>
#include <Vector.h>
#include "BottomLidar.h"
#include "Calibration.h"
#include "Cups.h"
#include "GameOver.h"
#include "Lighthouse.h"
#include "ManageOpponent.h"
#include "MobileLidar.h"
#include "MooringArea.h"
#include "Pos.h"
#include "Robot.h"
#include "Sensor.h"
#include "Strat.h"
#include "Task.h"
#include "TopLidar.h"
#include "Weathercock.h"
#include "WeathercockColour.h"
#include "Windsock.h"
#include "Dir.h"
#include "Macro.h"

//Macro for tasks positions
Pos POS_LIGHTHOUSE;
Pos POS_LIGHTHOUSE_OP;
Pos POS_WEATHERCOCK;
Pos POS_WINDSOCK_1;
Pos POS_WINDSOCK_2;
Pos POS_MOORING_AREA;

//Macro for null types
Pos POS_NULL(-1,-1);

//Global variables

Vector<Sensor> sensors_null;
RTSRob robot_RTS(&POS_NULL, 0, sensors_null);
OpponentRob rob_op(&POS_NULL, 0);
OpponentRob rob_op_2(&POS_NULL, 0);
WeathercockColour weathercock;
Vector<OpponentRob> rob_opponents;
Vector<Pos> dectable_lidar_mobile;
Strat strat(robot_RTS);

Dir dir = right;



/**
 * Initialise sensors
 * @return an Vector of sensors
 */
Vector<Sensor> init_sensors()
{
    BottomLidar bottomLidar;
    TopLidar topLidar;
    MobileLidar mobileLidar;

    Vector<Sensor> sensors;
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
  strat.tasks_order.push_back(TASK_LIGHTHOUSE);
	strat.tasks_order.push_back(TASK_WINDSOCK_1);
	strat.tasks_order.push_back(TASK_WINDSOCK_2);

    Vector<Pos> checkpoint_windsock;
    checkpoint_windsock.push_back(Pos(-1,945));
    Vector<Pos> checkpoint_lighthouse;
    checkpoint_lighthouse.push_back(Pos(-1,50));
    Vector<Pos> checkpoint_weathercock;
    checkpoint_weathercock.push_back(Pos(ARENA_HEIGHT/2, -1));

    Weathercock task_weathercock(TASK_WEATHERCOCK, 10, POS_WEATHERCOCK, 25000, checkpoint_weathercock);
	Windsock task_windsock_1(TASK_WINDSOCK_1, 5, POS_WINDSOCK_1, 20000, checkpoint_windsock);
	Windsock task_windsock_2(TASK_WINDSOCK_2, 5, POS_WINDSOCK_2, 20000, checkpoint_windsock);
	Lighthouse task_lighthouse(TASK_LIGHTHOUSE, 13, POS_LIGHTHOUSE, 10000, checkpoint_lighthouse);
	MooringArea task_mooring_area(TASK_MOORING_AREA, 10, POS_MOORING_AREA, 100000);

  Pos pos_50(-50, -50);
	Calibration task_calibration(TASK_CALIBRATION, 0, pos_50, 15000);
	GameOver game_over(GAME_OVER, 0, pos_50, 1000000);

    strat.tab_tasks.push_back(task_weathercock);
    strat.tab_tasks.push_back(task_windsock_1);
    strat.tab_tasks.push_back(task_windsock_2);
    strat.tab_tasks.push_back(task_lighthouse);
    strat.tab_tasks.push_back(task_mooring_area);
    strat.tab_tasks.push_back(task_calibration);
    strat.tab_tasks.push_back(game_over);
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

void display_tasks_order(int id)
{
  /**
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
  **/
}

Sensor lidar;

void setup() {
    // Setup serial link
    Serial.begin(9600);

		init_robots();


    dectable_lidar_mobile.push_back(POS_LIGHTHOUSE);
    dectable_lidar_mobile.push_back(POS_LIGHTHOUSE_OP);
    dectable_lidar_mobile.push_back(POS_WEATHERCOCK);
    dectable_lidar_mobile.push_back(rob_op.position);
    dectable_lidar_mobile.push_back(rob_op_2.position);

    init_tasks();

}

void loop() {
	//distance_read = lidar.readDistance();

	strat.apply();

	display_infos();

	for (unsigned int i = 0; i < strat.tasks_order.size(); i++)
		display_tasks_order(strat.tasks_order[i]);

}
