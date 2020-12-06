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
#include "Init.h"

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
WeathercockColour weathercockColour(millis());
Vector<OpponentRob> rob_opponents;
Vector<Pos> dectable_lidar_mobile;
Strat strat(robot_RTS, millis());

Dir dir = right;





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

	strat.apply(millis());

	display_infos();

	for (unsigned int i = 0; i < strat.tasks_order.size(); i++)
		display_tasks_order(strat.tasks_order[i]);

}
