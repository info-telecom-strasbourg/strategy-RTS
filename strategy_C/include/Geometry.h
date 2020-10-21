#ifndef GEOMETRY_H
#define GEOMETRY_H

#include <math.h>
#include "Pos.h"

//Macro for simulation
const int ROBOT_WIDTH = 100;
const int ROBOT_HEIGHT = 100;
const int ARENA_WIDTH = 1000;
const int ARENA_HEIGHT = 1500;
const float HALF_DIAG = sqrt(pow(ROBOT_WIDTH/2,2) + pow(ROBOT_HEIGHT/2,2));
const float rot_step = M_PI/50;


//Macro for tasks
const int TASK_WEATHERCOCK = 0;
const int TASK_WINDSOCK_1 = 1;
const int TASK_WINDSOCK_2 = 2;
const int TASK_LIGHTHOUSE = 3;
const int TASK_MOORING_AREA = 4;
const int TASK_CALIBRATION = 5;
const int GAME_OVER = 6;
const int NO_TASK = 7;

//Macro for speed regimes
const int STOP = 0;
const int SLOW = 3;
const int FAST = 10;

//Macro for colors (weathercock)
const int NO_COLOR = 0;
const int BLACK = 1;
const int WHITE = 2;

//Macro for done
const int NOT_DONE = 0;
const int IN_PROGRESS = 1;
const int DONE = 2;

//Macro for tasks positions
Pos POS_LIGHTHOUSE;
Pos POS_LIGHTHOUSE_OP;
Pos POS_WEATHERCOCK;
Pos POS_WINDSOCK_1;
Pos POS_WINDSOCK_2;
Pos POS_MOORING_AREA;

//Macro for tasks positions
int BOTTOM_LIDAR = 0;
int TOP_LIDAR = 1;
int MOBILE_LIDAR = 2;


enum Dir {left , right };
Dir dir = right;

/**
 * Using radians, find the angle in [0, 2 M_PI]
 * @param angle: the initial angle
 * @return the angle's value in [0, 2 M_PI]
 */
float mod2Pi(float angle)
{
	while ((angle < 0) || (angle >= 2 * M_PI))
		if (angle < 0)
			angle += 2 * M_PI;
		else
			angle -= 2 * M_PI;

	return angle;
}




#endif
