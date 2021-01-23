#include <Task.h>
#include <Dir.h>
#include <unity.h>
#include <Vector.h>
#include <Robot.h>
#include <Strat.h>
#include <WeathercockColour.h>

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
WeathercockColour weathercock(0);
Vector<OpponentRob> rob_opponents;
Vector<Pos> dectable_lidar_mobile;
Strat strat(robot_RTS, 0);

Dir dir = right;


void test_function_over(void)
{
  Pos pos;
  Task task(0, 0, pos, 1000);
  task.over();
  TEST_ASSERT_EQUAL(DONE, task.done);
}

int main (int argc, char* argv[])
{
  UNITY_BEGIN();
  RUN_TEST(test_function_over);
  UNITY_END();
}
