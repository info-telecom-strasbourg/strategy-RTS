#ifndef TASK_H
#define TASK_H

#include "Pos.h"

extern const int NOT_DONE;
extern const int DONE;

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
	Task(int id, int points, Pos position, long max_time)
	{
		this->id = id;
		this->points = points;
		this->position = position;
		this->done = NOT_DONE;
		this->max_time = max_time;
	}

	/**
	 * Indicate that the task in done
	 */
	void over() {this->done = DONE;}

	/**
	 * Indicate that the task is in progress
	 */
	void in_progress();

	/**
	 * Indicate that the task is interrupted
	 */
	void interrupted();

	/**
	 * An abstract method that will simulate the completion of the task
	 */
  virtual void do_task();
};

#endif
