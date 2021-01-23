#include <unity.h>
#include <Vector.h>
#include "Macro.h"
#include "Dir.h"
#include "Weathercock.h"
#include "WeathercockColour.h"
#include "Strat.h"
#include "Init.h"

#define TASK_MOORING_AREA 4

Vector<Sensor> sensors_null;
Pos POS_WINDSOCK_1(100,800);
Pos POS_WINDSOCK_2(300,800);
Pos POS_LIGHTHOUSE(250,125);
Pos POS_LIGHTHOUSE_OP(1250, 125);
Pos POS_MOORING_AREA(100, -50);
Pos POS_WEATHERCOCK(450, 125);
Pos POS_NULL(-1,-1);
Dir dir = left;
RTSRob robot_RTS(&POS_NULL, 0);
Vector<OpponentRob> rob_opponents;
Strat strat(robot_RTS, 0);

WeathercockColour weathercockColour(0);

void test_function_init_sensor(void)
{
	Sensor sensors[3];
	init_sensors(sensors);
	//TEST_ASSERT_EQUAL(vector.size(),3); //revoir ca parcequ'avant c'était un vecteur
}

void test_function_init_robots(void)
{
	dir = left;
	init_robots();
	TEST_ASSERT(POS_WINDSOCK_1 == Pos(100,800));
	TEST_ASSERT(POS_WINDSOCK_2 == Pos(300,800));
	TEST_ASSERT(POS_LIGHTHOUSE == Pos(250,125));
	TEST_ASSERT(POS_LIGHTHOUSE_OP == Pos(1250, 125));
	TEST_ASSERT(POS_MOORING_AREA == Pos(100, -50));
	TEST_ASSERT(POS_WEATHERCOCK == Pos(450, 125));
	TEST_ASSERT(robot_RTS.position == Pos(100, 410));
	TEST_ASSERT(robot_RTS.angle == 0);

	dir = right;
	init_robots();
	TEST_ASSERT(POS_WINDSOCK_1 == Pos(1400,800));
	TEST_ASSERT(POS_WINDSOCK_2 == Pos(1200,800));
	TEST_ASSERT(POS_LIGHTHOUSE == Pos(1250, 125));
	TEST_ASSERT(POS_LIGHTHOUSE_OP == Pos(250,125));
	TEST_ASSERT(POS_MOORING_AREA == Pos(1400, -50));
	TEST_ASSERT(POS_WEATHERCOCK == Pos(1050, 125));
	TEST_ASSERT(robot_RTS.position == Pos(1400, 410));
	TEST_ASSERT(robot_RTS.angle == (float)M_PI);
}

void test_function_init_tasks(void)
{
	init_tasks();
	TEST_ASSERT(strat.tasks_order.size() == 3);
	TEST_ASSERT(strat.tab_tasks.size() == 7);
}

int main(int argc, char* argv[])
{
	UNITY_BEGIN();
	RUN_TEST(test_function_init_sensor);
	RUN_TEST(test_function_init_robots);
	RUN_TEST(test_function_init_tasks);
	UNITY_END();
}
