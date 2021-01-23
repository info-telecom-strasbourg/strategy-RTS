#include <Task.h>
#include <Dir.h>
#include <unity.h>
#include <Vector.h>
#include <Robot.h>
#include <Strat.h>
#include <WeathercockColour.h>
#include <ManageOpponent.h>
#include <Init.h>
#include "stdio.h"

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

void test_class_ManageOpponent(void)
{
	ManageOpponent manageopponent(robot_RTS);
	TEST_ASSERT(manageopponent.robot.angle == robot_RTS.angle);
	TEST_ASSERT(manageopponent.opponent_positions.size() == 0);
	TEST_ASSERT(manageopponent.path.size() == 0);
}

void test_function_find_the_opponent(void)
{
	// faire des tests sur opponent_positions, c'est le seul truc qui bouge
	ManageOpponent manageopponent(robot_RTS);
	manageopponent.find_the_opponent();
	TEST_ASSERT(manageopponent.opponent_positions.size() == 0);

	rob_opponents.push_back(rob_op);
	manageopponent.find_the_opponent();
	TEST_ASSERT(manageopponent.opponent_positions.size() == 1);
	TEST_ASSERT(manageopponent.opponent_positions[0] == POS_NULL);
	//
	rob_opponents.push_back(rob_op_2);
	manageopponent.opponent_positions.clear();
	manageopponent.find_the_opponent();
	TEST_ASSERT(manageopponent.opponent_positions.size() == 2);
	TEST_ASSERT(manageopponent.opponent_positions[0] == POS_NULL);
	TEST_ASSERT(manageopponent.opponent_positions[1] == POS_NULL);

	Pos pos1(100, 300);
	rob_opponents[0].position = pos1;
	manageopponent.opponent_positions.clear();
	manageopponent.find_the_opponent();
	TEST_ASSERT(manageopponent.opponent_positions.size() == 2);
	TEST_ASSERT(manageopponent.opponent_positions[0] == pos1);
	TEST_ASSERT(manageopponent.opponent_positions[1] == POS_NULL);
}

void test_function_find_path(void)
{

}

void test_function_access(void)
{
	//J'ai l'impression que cette fonction ne fait pas ce qu'elle devrait faire,
	//enfin c'est surtout les is_on_security_area
	ManageOpponent manageopponent(robot_RTS);

	// Pas de robot sur le chemin
	Pos pos1(800, 500);
	Pos pos2(1000, 800);
	Pos posRob1(0, 0);
	Pos posRob2(100, 500);
	manageopponent.opponent_positions.push_back(posRob1);
	manageopponent.opponent_positions.push_back(posRob2);
	TEST_ASSERT(manageopponent.opponent_positions.size() == 2);
	TEST_ASSERT(manageopponent.access(pos1, pos2, 10000) != POS_NULL);
}

void test_function_is_on_security_area(void)
{
	ManageOpponent manageopponent(robot_RTS);

	Pos pos1(100, 200);
	Pos pos2(500, 300);
	TEST_ASSERT(manageopponent.is_on_security_area(pos1, pos2, 300) == false);
}

void test_function_find_step(void)
{
	ManageOpponent manageopponent(robot_RTS);

	Pos intersection(100, 100);
	TEST_ASSERT(manageopponent.find_step(intersection, 300) == POS_NULL);
}

void test_function_find_checkpoint(void)
{

}

void test_function_check_path(void)
{

}

void test_function_best_path(void)
{

}

int main (int argc, char* argv[])
{
	init_robots();
	UNITY_BEGIN();
	RUN_TEST(test_class_ManageOpponent);
	RUN_TEST(test_function_find_the_opponent);
	RUN_TEST(test_function_find_path);
	RUN_TEST(test_function_access);
	RUN_TEST(test_function_is_on_security_area);
	RUN_TEST(test_function_find_step);
	RUN_TEST(test_function_find_checkpoint);
	RUN_TEST(test_function_check_path);
	RUN_TEST(test_function_best_path);
	UNITY_END();
}
