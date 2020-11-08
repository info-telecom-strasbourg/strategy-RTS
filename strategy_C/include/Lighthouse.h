#ifndef LIGHTHOUSE_H
#define LIGHTHOUSE_H

#include "Task.h"
#include "RTSRob.h"
#include "TopLidar.h"
#include "Strat.h"

extern RTSRob robot_RTS;
extern Strat strat;

/**
 * This class represent the task
 */
class Lighthouse : public Task
{
public:
	/* The moment when the task began */
    int lighthouse_wait;

	/**
	 * The constructor of Lighthouse
	 * @param id: the identifier of the task
	 * @param points: the points given by the task
	 * @param position: the location of this task
	 * @param max_time: the estimated necessary time to accomplish the task
	 * @param light_house_checkpoints: the checkpoints we need to reach to accomplish the task
	 */
    Lighthouse(int id, int points, Pos position, long max_time, std::vector<Pos> lighthouse_checkpoints)
    : Task(id, points, position, max_time), lighthouse_wait(-1)
    {
        this->checkpoints = lighthouse_checkpoints;
    }

    /**
	 * Deploy the actuator to push the lighthouse button (simulation only)
	 */
	void deploy_actuator_lighthouse()
	{
		float dist_bord = robot_RTS.position.y - float(ROBOT_HEIGHT)/2;
		float adjust_dist;

		if(((millis() - this->lighthouse_wait)*3) < (this->max_time))
		{
			float coeff = (millis() - float(this->lighthouse_wait))/(float(int(this->max_time))/3.0);
			adjust_dist = (1 - coeff) * dist_bord/2;
		}
		else
		{
			float coeff = (millis() - float(this->lighthouse_wait) -
						  float(int(this->max_time))/3.0)/(float(int(this->max_time))/3.0);
			adjust_dist = coeff * dist_bord/2;
		}
	}

	/**
	 * Turn the robot to the right direction and push the button
	 */
	void push_button()
	{
		robot_RTS.goToAngle((3*M_PI)/2);
		if (mod2Pi(robot_RTS.angle - (3*M_PI)/2) < rot_step)
		{
			if(this->lighthouse_wait == -1 || ((millis() - this->lighthouse_wait)*3) > (this->max_time * 2))
				this->lighthouse_wait = millis();

			if (((millis() - this->lighthouse_wait)*3) < (this->max_time * 2))
				deploy_actuator_lighthouse();
			else
			{
				if(((TopLidar)robot_RTS.sensors[TOP_LIDAR]).is_detected(this->id))
				{
					this->over();
					strat.removeTaskOrder(0);
					strat.score += this->points;
				}
				else
				{
					this->lighthouse_wait = -1;
					this->interrupted();
				}
			}
		}
	}

	/**
	 * Simulate the execution of the lighthouse task
	 */
	void do_task()
	{
		this->checkpoints[0].x = robot_RTS.position.x;
		this->in_progress();
		robot_RTS.next_destination = this->checkpoints[0];
		strat.path(robot_RTS.next_destination);
		robot_RTS.goTo(true);
		if (robot_RTS.position.is_around(this->checkpoints[0], 5))
			push_button();
	}
};

#endif
