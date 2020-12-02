#ifndef TASK_H
#define TASK_H

#include "Pos.h"
#include "Macro.h"

/**
 * A task (weathercock, windsocks, mooring area and lighthouse)
 */
class Task
{
public:
	/* The identifier of the a task */
	int id;

	/* The points earned if we accomplish the task */
	int points;

	/* The position of the task */
	Pos position;

	/* Represent the state of the task */
	int done;

	/* The max time this task should last */
	long max_time;

	/* An ArrayList of checkpoints we need to reach to acomplish the task */
    Vector<Pos> checkpoints;

	/**
	 * Constructor of Task
	 * @param points: the number of points that this task brings
	 * @param position: the position of the task
	 * @param max_time: the maximum time this task should last
	 */
	Task(int id, int points, Pos position, long max_time);

	/**
	 * Destructor of Task
	 */
	~Task() {};

	/**
	 * Indicate that the task in done
	 */
	void over();

	/**
	 * Indicate that the task is in progress
	 */
	void in_progress(int millis);

	/**
	 * Indicate that the task is interrupted
	 */
	void interrupted(int millis);

	/**
	 * An abstract method that will simulate the completion of the task
	 */
  	virtual void do_task(int millis) {;}
};

#endif
