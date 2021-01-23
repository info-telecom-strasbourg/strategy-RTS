#include "Init.h"
#include "BottomLidar.h"
#include "TopLidar.h"
#include "MobileLidar.h"
#include "Macro.h"
#include "Dir.h"
#include "Robot.h"
#include "Strat.h"
#include "Weathercock.h"
#include "Windsock.h"
#include "Lighthouse.h"
#include "GameOver.h"
#include "Calibration.h"
#include "MooringArea.h"

extern Pos POS_WINDSOCK_1;
extern Pos POS_WINDSOCK_2;
extern Pos POS_LIGHTHOUSE;
extern Pos POS_LIGHTHOUSE_OP;
extern Pos POS_MOORING_AREA;
extern Pos POS_WEATHERCOCK;
extern Dir dir;
extern Strat strat;
extern RTSRob robot_RTS;

void init_sensors(Sensor sensors[3])
{
    BottomLidar bottomLidar;
    TopLidar topLidar;
    MobileLidar mobileLidar;

	sensors[BOTTOM_LIDAR] = bottomLidar;
    sensors[TOP_LIDAR] = topLidar;
    sensors[MOBILE_LIDAR] = mobileLidar;

}

void init_robots()
{
	if (dir == left)
	{
		robot_RTS.position = Pos(100, 410);
		robot_RTS.angle = 0;
		init_sensors(robot_RTS.sensors);
		POS_WINDSOCK_1 = Pos(100,800);
		POS_WINDSOCK_2 = Pos(300,800);
		POS_LIGHTHOUSE = Pos(250,125);
		POS_LIGHTHOUSE_OP = Pos(1250, 125);
		POS_MOORING_AREA = Pos(100, -50);
		POS_WEATHERCOCK = Pos(450, 125);
	}
	else
	{
		robot_RTS.position = Pos(1400, 410);
		robot_RTS.angle = M_PI;
		init_sensors(robot_RTS.sensors);
		POS_WINDSOCK_1 = Pos(1400,800);
		POS_WINDSOCK_2 = Pos(1200,800);
		POS_LIGHTHOUSE = Pos(1250, 125);
		POS_LIGHTHOUSE_OP = Pos(250,125);
		POS_MOORING_AREA = Pos(1400, -50);
		POS_WEATHERCOCK = Pos(1050, 125);
	}
}

void init_tasks()
{
	strat.tasks_order.push_back(TASK_LIGHTHOUSE);
	strat.tasks_order.push_back(TASK_WINDSOCK_1);
	strat.tasks_order.push_back(TASK_WINDSOCK_2);

	Pos tab_checkpoint[20];
	Vector<Pos> checkpoint_windsock(tab_checkpoint);
	checkpoint_windsock.push_back(Pos(-1,945));
	Vector<Pos> checkpoint_lighthouse(tab_checkpoint);
	checkpoint_lighthouse.push_back(Pos(-1,50));
	Vector<Pos> checkpoint_weathercock(tab_checkpoint);
	checkpoint_weathercock.push_back(Pos(ARENA_HEIGHT/2, -1));

    Weathercock task_weathercock(TASK_WEATHERCOCK, 10, POS_WEATHERCOCK, 25000, checkpoint_weathercock);
	Windsock task_windsock_1(TASK_WINDSOCK_1, 5, POS_WINDSOCK_1, 20000, checkpoint_windsock);
	Windsock task_windsock_2(TASK_WINDSOCK_2, 5, POS_WINDSOCK_2, 20000, checkpoint_windsock);
	Lighthouse task_lighthouse(TASK_LIGHTHOUSE, 13, POS_LIGHTHOUSE, 10000, checkpoint_lighthouse);
	MooringArea task_mooring_area(TASK_MOORING_AREA, 10, POS_MOORING_AREA, 100000);

	Pos pos_50(-50, -50);
	Calibration task_calibration(TASK_CALIBRATION, 0, pos_50, 15000);
	GameOver game_over(GAME_OVER, 0, pos_50, 1000000);

    strat.tab_tasks.push_back(task_weathercock);
    strat.tab_tasks.push_back(task_windsock_1);
    strat.tab_tasks.push_back(task_windsock_2);
    strat.tab_tasks.push_back(task_lighthouse);
    strat.tab_tasks.push_back(task_mooring_area);
    strat.tab_tasks.push_back(task_calibration);
    strat.tab_tasks.push_back(game_over);
}
