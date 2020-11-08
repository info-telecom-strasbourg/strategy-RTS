#ifndef LIGHTHOUSE_H
#define LIGHTHOUSE_H

#include "Task.h"


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
    Lighthouse(int id, int points, Pos position, long max_time, Vector<Pos> lighthouse_checkpoints)
    : Task(id, points, position, max_time), lighthouse_wait(-1)
    {
        this->checkpoints = lighthouse_checkpoints;
    }

    /**
	 * Deploy the actuator to push the lighthouse button (simulation only)
	 */
	void deploy_actuator_lighthouse();

	/**
	 * Turn the robot to the right direction and push the button
	 */
	void push_button();

	/**
	 * Simulate the execution of the lighthouse task
	 */
	void do_task();
};

#endif
