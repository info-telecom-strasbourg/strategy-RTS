#ifndef MOORINGAREA_H
#define MOORINGAREA_H

#include "Task.h"

/**
 * This class represent the task linked to the mooring area
 */
class MooringArea : public Task
{
public:
	/**
	 * The constructor of MooringArea
	 * @param id: the identifier of the task
	 * @param points: the points given by the task
	 * @param position: the location of this task
	 * @param max_time: the estimated necessary time to accomplish the task
	 */
    MooringArea(int id, int points, Pos position, long max_time)
    : Task(id, points, position, max_time)
    {}

    /**
	 * Simulate the task linked to the mooring area
	 */
	void do_task();
};

#endif
