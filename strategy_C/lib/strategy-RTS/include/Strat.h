#ifndef STRAT_H
#define STRAT_H

#include "ManageOpponent.h"
#include "Task.h"

/**
 * This class is our strategy
 */
class Strat : public ManageOpponent
{
public:
	/* The identifier of the current task that correspond to its
	 place in tab_task*/
    int id_current_task;

	/* Beginnig of the match */
    int time;

	/* Time elapsed since we want to go to the next task */
    long time_start_task;

	/* Our score */
    int score;

	/* The list of tasks to do classified in the order of completion*/
    Vector<int> tasks_order;

	/* The list of tasks that must be done */
    Vector<Task> tab_tasks;

	/* The task Weathercock has been inserted in tasks_order */
	bool weathercock_insterted;


	/**
	 * The constructor of the class
	 * @param robot: the robot that must fllow the strategy
	 */
  Strat(RTSRob robot, int millis);

    /**
	 * Apply the strategy
	 * @param: opponent: the opponent's robot (for simulation)
	 */
	void apply(int millis);

    /**
	 * Select the closer mooring area (use if we do not know the weathercock color)
	 * The position of the flag's task is changed to fit to the decision
	 */
	void select_mooring_area();

    /**
	 * Find the task to do
	 * @return the index of the task in tab_tasks
	 */
	int find_best_task(int millis);

	/**
	 * This function check if the last task must be done
	 * @return a bool that indicate if the final task must be done
	 */
	bool manage_last_tasks(int millis);

    /**
	 * Calculate if we have to move to the mooring area with the color of the weathercock
	 * @param: time_left: the time before the end of the game
	 * @return if we have to move to the mooring area
	 */
	bool final_move_with_color(long time_left);

	/**
	 * Calculate if we have to move to the closest mooring area without the color of the weathercock
	 * @param: time_left: the time before the end of the game
	 * @return if we have to move to the closest mooring area
	 */
	bool final_move_without_color(long time_left);

	/**
	 * Calculate if we have the time to move to "pos" before the end of the game
	 * @param: pos: position of the robot
	 * @param: time_left: the time before the end of the game
	 * @return if we have the time to move to "pos" before the end of the game
	 */
	bool is_final_move (Pos pos, long time_left);


	/**
	 * Move in the array "tasks_order" a task from the index "index_start" to
	 * the index "index_end"
	 * @param index_start: index of the task to move
	 * @param index_end: index where the task has to be moved
	 */
  void changeTaskOrder(int index_start, int index_end, int millis);

	/**
	 * Empty the Vector tasks_order and reinitialize
	 * time_start_task
	 */
	void emptyTaskOrder(int millis);

	/**
	 * Add id to the Vector tasks_order and reinitialize
	 * time_start_task
	 * @param id: the id of the task
	 */
	void addTaskOrder(int id, int millis);

	/**
	 * remove the int an index to the Vector tasks_order and reinitialize
	 * time_start_task
	 * @param index: the position of the id you want to remove
	 */
	void removeTaskOrder(int index, int millis);
};


#endif
