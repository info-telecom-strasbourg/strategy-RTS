#ifndef WEATHERCOCK_H
#define WEATHERCOCK_H


#include "Task.h"

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
    Weathercock(int id, int points, Pos position, long max_time, Vector<Pos> weathercock_checkpoints)
    : Task(id, points, position, max_time), weathercock_wait(-1)
    {
      this->checkpoints = weathercock_checkpoints;
    }

    /**
	 * Detect the weathercock color and update POS_MOORING_AREA
	 */
	void detect_weathercock_col();

	/**
	 * Simulate the execution of the weathercock
	 */
    void do_task(int millis);
};

#endif
