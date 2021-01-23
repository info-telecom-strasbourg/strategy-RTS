#include "Pos.h"
#include <Vector.h>
#include "Sensor.h"
#include "Robot.h"
#include "WeathercockColour.h"
#include "Strat.h"
#include "Dir.h"
#include "unity.h"
#include "Init.h"
#include "BottomLidar.h"
#include "MobileLidar.h"
#include "TopLidar.h"
#define MAX_SIZE 100

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
RTSRob robot_RTS(&POS_NULL, 0);
OpponentRob rob_op(&POS_NULL, 0);
OpponentRob rob_op_2(&POS_NULL, 0);
WeathercockColour weathercockColour(0);
OpponentRob rob_opponents_arr[2];
Vector<OpponentRob> rob_opponents(rob_opponents_arr);
Vector<Pos> dectable_lidar_mobile;
Strat strat(robot_RTS, 0);

Dir dir = right;


void test_function_capture_BottomLidar(void)
{
  BottomLidar lidar;
}

void test_function_detection_BottomLidar(void)
{
  BottomLidar lidar;
  Pos obstacle[MAX_SIZE];
  Vector<Pos> obstacles(obstacle);
  Pos detectable[MAX_SIZE];
  Vector<Pos> detectables(detectable);
  lidar.detection(obstacles, detectables);
}

int main(int argc, char* argv[])
{
  UNITY_BEGIN();
  RUN_TEST(test_function_capture_BottomLidar);
  RUN_TEST(test_function_detection_BottomLidar);
  RUN_TEST(test_function_capture_MobileLidar);
  RUN_TEST(test_function_detection_MobileLidar);
  RUN_TEST(test_function_capture_TopLidar);
  RUN_TEST(test_function_detection_TopLidar);
  UNITY_END();
}
