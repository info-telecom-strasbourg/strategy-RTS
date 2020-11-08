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
    std::vector<int> tasks_order;

	/* The list of tasks that must be done */
    std::vector<Task> tab_tasks;

	/* The task Weathercock has been inserted in tasks_order */
	bool weathercock_insterted;


	/**
	 * The constructor of the class
	 * @param robot: the robot that must fllow the strategy
	 */
    Strat(RTSRob robot)
    : ManageOpponent(robot), id_current_task(-1), time(millis()), time_start_task(millis()), score(7), weathercock_insterted(false)
    {}

    /**
	 * Apply the strategy
	 * @param: opponent: the opponent's robot (for simulation)
	 */
	void apply()
	{
		this->robot.speed_regime = ((BottomLidar)this->robot.sensors[BOTTOM_LIDAR]).manage_speed();
		find_the_opponent(); //identify the opponent
		this->id_current_task = find_best_task(); //choose the task we have to do now

		if(manage_last_tasks())
				this->id_current_task = this->tasks_order[0];

		if(this->robot.position.is_around(this->tab_tasks[this->id_current_task].position, 5)
		   || this->tab_tasks[this->id_current_task].done == IN_PROGRESS)
		{
			this->tab_tasks[this->id_current_task].do_task();

      if (!this->path.empty())
				this->path.clear();

		}
		else
		{
			best_path(this->robot.next_destination);

			if (!this->path.empty() && this->robot.position.is_around(this->path[0], 5))
				this->path.erase(this->path.begin());

			if (!this->path.empty())
			{
				this->robot.next_destination = this->path[0];

				this->robot.getCorners();

				if (!this->robot.haveToBack())
					this->robot.goTo(true);
			}

			if (this->robot.haveToBack())
					this->robot.goTo(false);
		}
	}

    /**
	 * Select the closer mooring area (use if we do not know the weathercock color)
	 * The position of the flag's task is changed to fit to the decision
	 */
	void select_mooring_area()
	{
    Pos pos_x(POS_MOORING_AREA.x, 200);
    Pos pos_y(POS_MOORING_AREA.x, 650);
		std::vector<Pos> points_for_closer;
    points_for_closer.push_back(pos_x);
    points_for_closer.push_back(pos_y);
		int index_closer = this->robot.position.closer(points_for_closer);
		tab_tasks[TASK_MOORING_AREA].position = points_for_closer[index_closer];

		if(access(this->robot.position, tab_tasks[TASK_MOORING_AREA].position, 280) != POS_NULL
		&& access(this->robot.position, points_for_closer[(index_closer+1)%2], 280) == POS_NULL)
			tab_tasks[TASK_MOORING_AREA].position = points_for_closer[(index_closer+1)%2];
	}

    /**
	 * Find the task to do
	 * @return the index of the task in tab_tasks
	 */
	int find_best_task()
	{
		if (this->id_current_task == TASK_MOORING_AREA && this->robot.detected_color == NO_COLOR)
			select_mooring_area();

		long time_left = 100000 - millis() - time;

		if (time_left < 4500 && !this->robot.flag_deployed)
		{
			if (!this->robot.flag_deployed)
				this->score += 10;
			this->robot.flag_deployed = true;
		}


		if (!this->weathercock_insterted && time_left < 75000)
		{
			this->tasks_order.push_back(TASK_WEATHERCOCK);
			this->weathercock_insterted = true;
		}

		if((!this->tasks_order.empty()))
		{
			if (((this->tab_tasks[this->tasks_order[0]].done == NOT_DONE && (millis() - this->time_start_task) > 10000)
			|| (this->tab_tasks[this->tasks_order[0]].done == IN_PROGRESS) && (millis() - this->time_start_task) > this->tab_tasks[this->tasks_order[0]].max_time))
			{
				this->tab_tasks[this->tasks_order[0]].done = NOT_DONE;
				changeTaskOrder(0, this->tasks_order.size() - 1);
				for (unsigned int i = 0; i < this->tasks_order.size(); i++)
					if(access(this->robot.position, this->tab_tasks[this->tasks_order[i]].position, 280) == POS_NULL)
					{
						changeTaskOrder(i, 0);
						break;
					}
			}

			if (this->tab_tasks[this->tasks_order[0]].done == NOT_DONE)
				this->robot.next_destination = this->tab_tasks[this->tasks_order[0]].position;

			return this->tasks_order[0];
		}
		else
			return NO_TASK;
	}

	/**
	 * This function check if the last task must be done
	 * @return a bool that indicate if the final task must be done
	 */
	bool manage_last_tasks()
	{
		long time_left = 100000 - millis() - time;
		if ((this->robot.flag_deployed) && (time_left < 500 || this->tasks_order.empty()))
		{
			tab_tasks[GAME_OVER].position = this->robot.position;
			this->emptyTaskOrder();
			this->addTaskOrder(GAME_OVER);
			return true;
		}
		if ((final_move_with_color(time_left) || final_move_without_color(time_left) || (this->tasks_order.empty())) && this->tab_tasks[TASK_MOORING_AREA].done != DONE)
		{
			this->emptyTaskOrder();
			Pos pos_mooring_1(POS_MOORING_AREA.x, 200);
			Pos pos_mooring_2(POS_MOORING_AREA.x, 650);
			if(access(this->robot.position, this->tab_tasks[TASK_MOORING_AREA].position, 280) != POS_NULL
			&& (time_left - 10000 < this->robot.position.dist(pos_mooring_1)/SLOW || time_left - 10000 < this->robot.position.dist(pos_mooring_2)/SLOW))
				select_mooring_area();

			this->addTaskOrder(TASK_MOORING_AREA);
			return true;
		}
		return false;
	}

    /**
	 * Calculate if we have to move to the mooring area with the color of the weathercock
	 * @param: time_left: the time before the end of the game
	 * @return if we have to move to the mooring area
	 */
	bool final_move_with_color(long time_left)
	{
		return (tab_tasks[TASK_WEATHERCOCK].done == DONE && is_final_move(tab_tasks[TASK_MOORING_AREA].position, time_left));
	}

	/**
	 * Calculate if we have to move to the closest mooring area without the color of the weathercock
	 * @param: time_left: the time before the end of the game
	 * @return if we have to move to the closest mooring area
	 */
	bool final_move_without_color(long time_left)
	{
    Pos pos200(POS_MOORING_AREA.x, 200);
    Pos pos650(POS_MOORING_AREA.x, 650);
		return ((is_final_move(pos200, time_left)
			|| is_final_move(pos650, time_left))
			&& tab_tasks[TASK_MOORING_AREA].done != DONE);
	}

	/**
	 * Calculate if we have the time to move to "pos" before the end of the game
	 * @param: pos: position of the robot
	 * @param: time_left: the time before the end of the game
	 * @return if we have the time to move to "pos" before the end of the game
	 */
	bool is_final_move (Pos pos, long time_left)
	{
		return time_left < (10000 + pos.dist(robot.position)/SLOW);
	}


	/**
	 * Move in the array "tasks_order" a task from the index "index_start" to
	 * the index "index_end"
	 * @param index_start: index of the task to move
	 * @param index_end: index where the task has to be moved
	 */
    void changeTaskOrder(int index_start, int index_end)
	{
		this->time_start_task = millis();
		if (index_start == index_end || index_start >= this->tasks_order.size() || index_end >= this->tasks_order.size()
		|| index_start < 0 || index_end < 0)
			return;

		std::vector <int> tasks_order_temp;

		if (index_start > index_end)
		{
			for(int i = 0; i < index_end; i++)
				tasks_order_temp.push_back(this->tasks_order[i]);
			tasks_order_temp.push_back(this->tasks_order[index_start]);
			for(int i = index_end; i < this->tasks_order.size(); i++)
				if(i != index_start)
					tasks_order_temp.push_back(this->tasks_order[i]);
		}
		else
		{
			for(int i = 0; i <= index_end; i++)
				if(i != index_start)
					tasks_order_temp.push_back(this->tasks_order[i]);
			tasks_order_temp.push_back(this->tasks_order[index_start]);
			for(unsigned int i = index_end + 1; i < this->tasks_order.size(); i++)
				tasks_order_temp.push_back(this->tasks_order[i]);
		}

		this->tasks_order = tasks_order_temp;
	}

	/**
	 * Empty the std::vector tasks_order and reinitialize
	 * time_start_task
	 */
	void emptyTaskOrder()
	{
		this->time_start_task = millis();
		this->tasks_order.clear();
	}

	/**
	 * Add id to the std::vector tasks_order and reinitialize
	 * time_start_task
	 * @param id: the id of the task
	 */
	void addTaskOrder(int id)
	{
		this->time_start_task = millis();
		this->tasks_order.push_back(id);
	}

	/**
	 * erase the int an index to the std::vector tasks_order and reinitialize
	 * time_start_task
	 * @param index: the position of the id you want to erase
	 */
	void eraseTaskOrder(int index)
	{
		this->time_start_task = millis();
		this->tasks_order.erase(this->tasks_order.begin() + index);
	}
};


#endif
