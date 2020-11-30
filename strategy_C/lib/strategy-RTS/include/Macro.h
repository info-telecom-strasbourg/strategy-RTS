#ifndef MACRO_H
#define MACRO_H

#include <math.h>
#include "Pos.h"

//Macro for simulation
#define ROBOT_WIDTH 100
#define ROBOT_HEIGHT 100
#define ARENA_WIDTH 1000
#define ARENA_HEIGHT 1500
#define HALF_DIAG sqrt(pow(ROBOT_WIDTH/2,2) + pow(ROBOT_HEIGHT/2,2))
#define rot_step M_PI/50

//Macro for tasks
#define TASK_WEATHERCOCK 0
#define TASK_WINDSOCK_1 1
#define TASK_WINDSOCK_2 2
#define TASK_LIGHTHOUSE 3
#define TASK_MOORING_AREA 4
#define TASK_CALIBRATION 5
#define GAME_OVER 6
#define NO_TASK 7

//Macro for speed regimes
#define STOP 0
#define SLOW 3
#define FAST 10

//Macro for colors (weathercock)
#define NO_COLOR 0
#define BLACK 1
#define WHITE 2

//Macro for done
#define NOT_DONE 0
#define IN_PROGRESS 1
#define DONE 2

//Macro for tasks positions
#define BOTTOM_LIDAR 0
#define TOP_LIDAR 1
#define MOBILE_LIDAR 2

#endif
