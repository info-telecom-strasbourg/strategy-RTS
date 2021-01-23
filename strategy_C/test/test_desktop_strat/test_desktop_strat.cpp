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

void test_class_Strat(void)
{
	TEST_ASSERT(strat.id_current_task == -1);
	TEST_ASSERT(strat.time == 0);
	TEST_ASSERT(strat.time_start_task == 0);
	TEST_ASSERT(strat.score == 7);
	TEST_ASSERT(strat.weathercock_insterted == false);
}

void test_function_apply(void)
{
	strat.apply(0);
	// blabla
}

void test_function_select_mooring_area(void)
{
	init_robots();
	strat.select_mooring_area();
	TEST_ASSERT(strat.tab_tasks[TASK_MOORING_AREA].position == Pos (POS_MOORING_AREA.x, 200));

	// le robot dans strat n'est pas le meme que robot_RTS car pas pointeur
	strat.robot.position = Pos (500, 600);
	strat.select_mooring_area();
	TEST_ASSERT(strat.tab_tasks[TASK_MOORING_AREA].position == Pos (POS_MOORING_AREA.x, 650));
	// faire le if
}

void test_function_find_best_task(void)
{
	dir = right;
	init_robots();

	// La tache est d'aller à la zone de mouillage mais on ne connais pas la
	// couleur de la girouette, alors on va au plus près
	strat.id_current_task = TASK_MOORING_AREA;
	strat.robot.detected_color = NO_COLOR;
	strat.robot.position = Pos (500, 600);
	strat.find_best_task(0);
	TEST_ASSERT(strat.tab_tasks[TASK_MOORING_AREA].position == Pos (1400, 650));
	TEST_ASSERT(strat.time == 0);


	// On vérifie qu'a la fin du match le drapeau se déploie
	int actual_score = strat.score;
	strat.find_best_task(99000);
	TEST_ASSERT(strat.robot.flag_deployed == true);
	TEST_ASSERT(strat.score == actual_score + 10);

	// Si on a pas encore la girouette dans les taches et qu'elle est arrêtée,
	// on met la tache girouette dans les taches à faire
	strat.find_best_task(50000);
	TEST_ASSERT(strat.tasks_order[strat.tasks_order.size()] == TASK_WEATHERCOCK);
	TEST_ASSERT(strat.weathercock_insterted == true);

	// On regarde si le changement de tache marche (si une tache est trop longue
	strat.tab_tasks[strat.tasks_order[0]].done = NOT_DONE;
	strat.time_start_task = 1000;
	strat.find_best_task(12000);


}

void test_function_manage_last_tasks(void)
{
	bool last_tasks;
	strat.robot.flag_deployed = true;
	strat.addTaskOrder(TASK_WINDSOCK_1, 99600);
	strat.addTaskOrder(TASK_WEATHERCOCK, 99600);

	last_tasks = strat.manage_last_tasks(99600);
	TEST_ASSERT(last_tasks == true);
	TEST_ASSERT(strat.tasks_order.size() == 1);

	strat.emptyTaskOrder(5000);
	last_tasks = strat.manage_last_tasks(5000);
	TEST_ASSERT(last_tasks == true);
	TEST_ASSERT(strat.tasks_order.size() == 1);

	strat.robot.flag_deployed = false;
	strat.tab_tasks[TASK_MOORING_AREA].done = DONE;
	last_tasks = strat.manage_last_tasks(90000);
	TEST_ASSERT(last_tasks == false);

	strat.tab_tasks[TASK_MOORING_AREA].done = NOT_DONE;
	last_tasks = strat.manage_last_tasks(90000);
	TEST_ASSERT(last_tasks == true);
	TEST_ASSERT(strat.tasks_order.size() == 1);
	TEST_ASSERT(strat.tasks_order[0] == TASK_MOORING_AREA);

}

void test_function_final_move_with_color(void)
{
	bool final_move;
	dir = left;
	init_robots();
	strat.tab_tasks[TASK_WEATHERCOCK].done = DONE;
	strat.tab_tasks[TASK_MOORING_AREA].position = Pos(750,700);

	final_move = strat.final_move_with_color(10000);
	TEST_ASSERT(final_move == true);

	final_move = strat.final_move_with_color(12000);
	TEST_ASSERT(final_move == false);

}

void test_function_final_move_without_color(void)
{
	bool final_move;
	strat.tab_tasks[TASK_MOORING_AREA].done = NOT_DONE;

	dir = left;
	init_robots();
	strat.robot.position = Pos(800,300);

	final_move = strat.final_move_without_color(9000);
	TEST_ASSERT(final_move == true);

	final_move = strat.final_move_without_color(12000);
	TEST_ASSERT(final_move == false);

	strat.tab_tasks[TASK_MOORING_AREA].done = DONE;

	final_move = strat.final_move_without_color(9000);
	TEST_ASSERT(final_move == false);

	final_move = strat.final_move_without_color(12000);
	TEST_ASSERT(final_move == false);
}

void test_function_is_final_move(void)
{
	bool final_move;
	strat.robot.position = Pos(700,600);
	Pos pos(100,200);

	final_move = strat.is_final_move(pos, 9900);
	TEST_ASSERT(final_move == true);

	final_move = strat.is_final_move(pos, 20000);
	TEST_ASSERT(final_move == false);

	final_move = strat.is_final_move(pos, 12000);
	TEST_ASSERT(final_move == false);

	final_move = strat.is_final_move(pos, 10300);
	TEST_ASSERT(final_move == false);

	final_move = strat.is_final_move(pos, 10200);
	TEST_ASSERT(final_move == true);
}

void test_function_changeTaskOrder(void)
{
	int tab_tasks_order_temp[7];
	Vector<int> vect(tab_tasks_order_temp);
	strat.emptyTaskOrder(10000);

	vect.push_back(TASK_MOORING_AREA);
	vect.push_back(TASK_WINDSOCK_1);
	vect.push_back(TASK_LIGHTHOUSE);
	vect.push_back(TASK_CALIBRATION);
	vect.push_back(TASK_WINDSOCK_2);
	vect.push_back(TASK_WEATHERCOCK);

	strat.addTaskOrder(TASK_MOORING_AREA, 10000);
	strat.addTaskOrder(TASK_WINDSOCK_1, 10000);
	strat.addTaskOrder(TASK_LIGHTHOUSE, 10000);
	strat.addTaskOrder(TASK_CALIBRATION, 10000);
	strat.addTaskOrder(TASK_WINDSOCK_2, 10000);
	strat.addTaskOrder(TASK_WEATHERCOCK, 10000);

	strat.changeTaskOrder(2, 2, 10000);
	for (int i = 0; i < 6; i++)
		TEST_ASSERT(vect[i] == strat.tasks_order[i]);

	strat.changeTaskOrder(-1, 2, 10000);
	for (int i = 0; i < 6; i++)
		TEST_ASSERT(vect[i] == strat.tasks_order[i]);

	strat.changeTaskOrder(3, -5, 10000);
	for (int i = 0; i < 6; i++)
		TEST_ASSERT(vect[i] == strat.tasks_order[i]);

	strat.changeTaskOrder(6, 2, 10000);
	for (int i = 0; i < 6; i++)
		TEST_ASSERT(vect[i] == strat.tasks_order[i]);

	strat.changeTaskOrder(5, 8, 10000);
	for (int i = 0; i < 6; i++)
		TEST_ASSERT(vect[i] == strat.tasks_order[i]);

	strat.changeTaskOrder(2, 4, 10000);
}

void test_function_emptyTaskOrder(void)
{
	strat.addTaskOrder(TASK_LIGHTHOUSE, 15000);
	strat.emptyTaskOrder(12000);
	TEST_ASSERT(strat.tasks_order.size() == 0);
	TEST_ASSERT(strat.time_start_task == 12000);
}

void test_function_addTaskOrder(void)
{
	strat.addTaskOrder(TASK_LIGHTHOUSE, 15000);
	TEST_ASSERT(strat.time_start_task == 15000);
	TEST_ASSERT(strat.tasks_order[strat.tasks_order.size() - 1] == TASK_LIGHTHOUSE);

	strat.addTaskOrder(TASK_MOORING_AREA, 74000);
	TEST_ASSERT(strat.time_start_task == 74000);
	TEST_ASSERT(strat.tasks_order[strat.tasks_order.size() - 1] == TASK_MOORING_AREA);

	strat.addTaskOrder(TASK_WINDSOCK_2, 52070);
	TEST_ASSERT(strat.time_start_task == 52070);
	TEST_ASSERT(strat.tasks_order[strat.tasks_order.size() - 1] == TASK_WINDSOCK_2);
}

void test_function_removeTaskOrder(void)
{
	strat.emptyTaskOrder(10000);
	strat.addTaskOrder(TASK_CALIBRATION, 10000);
	strat.addTaskOrder(TASK_WINDSOCK_1, 10000);
	strat.addTaskOrder(TASK_MOORING_AREA, 10000);
	strat.addTaskOrder(TASK_WEATHERCOCK, 10000);
	strat.addTaskOrder(TASK_WINDSOCK_2, 10000);
	strat.addTaskOrder(TASK_LIGHTHOUSE, 10000);
	strat.removeTaskOrder(3, 10000); // on retire TASK_WEATHERCOCK
	TEST_ASSERT(strat.tasks_order.size() == 5);
	TEST_ASSERT(strat.tasks_order[0] == TASK_CALIBRATION);
	TEST_ASSERT(strat.tasks_order[1] == TASK_WINDSOCK_1);
	TEST_ASSERT(strat.tasks_order[2] == TASK_MOORING_AREA);
	TEST_ASSERT(strat.tasks_order[3] == TASK_WINDSOCK_2);
	TEST_ASSERT(strat.tasks_order[4] == TASK_LIGHTHOUSE);
}

int main(int argc, char* argv[])
{
	UNITY_BEGIN();
	RUN_TEST(test_class_Strat);
	RUN_TEST(test_function_apply);
	RUN_TEST(test_function_select_mooring_area);
	RUN_TEST(test_function_find_best_task);
	RUN_TEST(test_function_manage_last_tasks);
	RUN_TEST(test_function_final_move_with_color);
	RUN_TEST(test_function_final_move_without_color);
	RUN_TEST(test_function_is_final_move);
	RUN_TEST(test_function_changeTaskOrder);
	RUN_TEST(test_function_emptyTaskOrder);
	RUN_TEST(test_function_addTaskOrder);
	RUN_TEST(test_function_removeTaskOrder);
	UNITY_END();
}
