#ifndef WEATHERCOCK_H
#define WEATHERCOCK_H

#include <stdio.h>
#include "Task.h"
#include "RTSRob.h"
#include "Strat.h"
#include "WeathercockColour.h"
#include "TopLidar.h"

extern WeathercockColour weathercock;
extern RTSRob robot_RTS;
extern Strat strat;

/**
 * This class represent the task weathercock
 */
class Weathercock : public Task
{
public:
	/* The begining of the task */
    int weathercock_wait;

	/**
	 * The constructor of Weathercock
	 * @param id: the identifier of the task
	 * @param points: the points given by the task
	 * @param position: the location of this task
	 * @param max_time: the estimated necessary time to accomplish the task
	 * @param weathercock_checkpoints: the checkpoints we need to reach to accomplish the task
	 */
    Weathercock(int id, int points, Pos position, long max_time, std::vector<Pos> weathercock_checkpoints)
    : Task(id, points, position, max_time), weathercock_wait(-1)
    {
      this->checkpoints = weathercock_checkpoints;
    }

    /**
	 * Detect the weathercock color and update POS_MOORING_AREA
	 */
	void detect_weathercock_col()
	{
		switch (robot_RTS.detected_color = weathercock.color_w)
		{
			case BLACK:
				strat.tab_tasks[TASK_MOORING_AREA].position.y = 200;
				break;
			case WHITE:
				strat.tab_tasks[TASK_MOORING_AREA].position.y = 650;
				break;
			default:
				printf("No color found\n");
		}
	}

	/**
	 * Simulate the execution of the weathercock
	 */
    void do_task()
	{
		this->in_progress();
		this->checkpoints[0].y = robot_RTS.position.y;
		robot_RTS.next_destination = this->checkpoints[0];

		if (robot_RTS.position.is_around(this->checkpoints[0], 5))
		{
			this->checkpoints[0].y = 50;
			robot_RTS.next_destination = this->checkpoints[0];
		}

		if (robot_RTS.position.is_around(this->checkpoints[0], 5))
    {
			if(mod2Pi(3*M_PI/2 - robot_RTS.angle) < rot_step)
			{
				if(this->weathercock_wait == -1)
					this->weathercock_wait = millis();

				if((millis() - this->weathercock_wait) > 2000)
				{
					if(((TopLidar)robot_RTS.sensors[TOP_LIDAR]).is_detected(this->id))
					{
						this->detect_weathercock_col();
						this->over();
						strat.removeTaskOrder(0);
					}
					else
						this->interrupted();
				}
			}
			else
				robot_RTS.goToAngle(3*M_PI/2);
    }
		strat.path(robot_RTS.next_destination);
		robot_RTS.goTo(true);
	}
};

#endif
