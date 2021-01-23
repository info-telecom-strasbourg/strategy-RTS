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

void test_class_Weathercock(void)
{
	int id = TASK_WEATHERCOCK;
	int points = 5; //?
	Pos position = POS_WEATHERCOCK;
	long max_time = 2000;
	Vector<Pos> weathercock_checkpoints;
	Weathercock weathercock(id, points, position, max_time, weathercock_checkpoints);
	TEST_ASSERT_EQUAL(TASK_WEATHERCOCK, weathercock.id);
	TEST_ASSERT_EQUAL(5, weathercock.points);
	TEST_ASSERT_EQUAL(POS_WEATHERCOCK.x, weathercock.position.x);
	TEST_ASSERT_EQUAL(POS_WEATHERCOCK.y, weathercock.position.y);
	TEST_ASSERT_EQUAL(2000, weathercock.max_time);
}

void test_function_detect_weathercock_col(void)
{
	init_tasks();
	// strat.apply(0);
	int id = TASK_WEATHERCOCK;
	int points = 5; //?
	Pos position = POS_WEATHERCOCK;
	long max_time = 2000;
	Vector<Pos> weathercock_checkpoints;
	Weathercock weathercock(id, points, position, max_time, weathercock_checkpoints);
	weathercockColour.decide_zone(50000);
	weathercockColour.color_w = BLACK;
	strat.tab_tasks[TASK_MOORING_AREA].position.y = 200; //probleme avec ca
	weathercock.detect_weathercock_col(); // probleme avec TASK_MOORING_AREA
	TEST_ASSERT_EQUAL(weathercockColour.color_w, BLACK);

	TEST_ASSERT_EQUAL(strat.tab_tasks[TASK_MOORING_AREA].position.y, 200);
}

int main(int argc, char* argv[])
{
	UNITY_BEGIN();
	RUN_TEST(test_class_Weathercock);
	RUN_TEST(test_function_detect_weathercock_col);
	UNITY_END();
}
