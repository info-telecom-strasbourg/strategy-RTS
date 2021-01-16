#include <Task.h>
#include <Dir.h>
#include <unity.h>
#include <Vector.h>
#include <Robot.h>
#include <Strat.h>
#include <WeathercockColour.h>
#include <ManageOpponent.h>

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
WeathercockColour weathercock(0);
Vector<OpponentRob> rob_opponents;
Vector<Pos> dectable_lidar_mobile;
Strat strat(robot_RTS, 0);

Dir dir = right;


void test_class_ManageOpponent(void)
{
	ManageOpponent manageopponent(robot_RTS);
	TEST_ASSERT(manageopponent.robot.angle == robot_RTS.angle);
	TEST_ASSERT(manageopponent.opponent_positions.size() == 0);
	TEST_ASSERT(manageopponent.path.size() == 0);
}

void test_function_find_the_opponent(void)
{
	ManageOpponent manageopponent(robot_RTS);
	manageopponent.find_the_opponent();
	TEST_ASSERT(manageopponent.opponent_positions.size() == 0); // faire des tests là dessus, c'est le seul truc qui bouge

	// TEST_ASSERT(manageopponent)
}

int main (int argc, char* argv[])
{
	UNITY_BEGIN();
	RUN_TEST(test_class_ManageOpponent);
	RUN_TEST(test_function_find_the_opponent);
	UNITY_END();
}
