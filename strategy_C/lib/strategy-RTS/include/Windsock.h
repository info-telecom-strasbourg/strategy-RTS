#ifndef WINDSOCK_H
#define WINDSOCK_H

#include "Task.h"

/**
 * This class represent the task inked to the windocks
 */
class Windsock : public Task
{
public:
	/* The beginning of the task */
  long windsock_wait;

  Windsock(int id, int points, Pos position, long max_time, Vector<Pos> windsock_checkpoints);

	/**
	 * A function that windsock to be raised
	 * @return a boolean that indicate if the windsock is raised
	 */
  bool raise_windsock(int millis);

	/**
	 * Simulate the execution of the windsock task
	 */
	void do_task(int millis);
};


#endif
