#ifndef GAMEOVER_H
#define GAMEOVER_H

#include "Task.h"

/**
 * This class represent the end of the game
 */
class GameOver : public Task
{
public:
    /**
	 * The class' constructor
	 * @param id: the identifier of the task
	 * @param points: the points given by the task
	 * @param position: the location of this task
	 * @param max_time: the estimated necessary time to accomplish the task
	 */
    GameOver(int id, int points, Pos position, long max_time)
    : Task(id, points, position, max_time)
    {}

    /**
	 * Simulate what to do at the end of the timer
	 */
    void do_task(int millis) override;
};


#endif
