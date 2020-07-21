/**
 * This class is our strategy
 */
class Strat extends ManageOpponent
{
	/* The identifier of the current task that correspond to its
	 place in tab_task*/
    int id_current_task;

	/* Beginnig of the match */
    int time;

	/* Time elapsed since we want to go to the next task */
    long time_go_task;

	/* Our score */
    int score;

	/* The list of tasks to do classified in the order of completion*/
    ArrayList<Integer> tasks_order = new ArrayList<Integer>();

	/* The list of tasks that must be done */
    ArrayList<Task> tab_tasks = new ArrayList<Task>();

	/* The task Weathercock has been inserted in tasks_order */
	boolean weathercock_insterted;


	/**
	 * The constructor of the class
	 * @param robot: the robot that must fllow the strategy
	 */
    Strat(RTSRob robot)
    {
        super(robot);
        this.id_current_task = -1;
        this.time = millis();
		this.time_go_task = millis();
        this.score = 7;
		this.weathercock_insterted = false;
    }

    /**
	 * Apply the strategy
	 * @param: opponent: the opponent's robot (for simulation)
	 */
	void apply()
	{
		this.robot.speed_regime = ((BottomLidar)this.robot.sensors.get(BOTTOM_LIDAR)).manage_speed();
		find_the_opponent(); //identify the opponent
		this.id_current_task = find_best_task(); //choose the task we have to do now
		
		if(this.robot.position.is_around(this.tab_tasks.get(this.id_current_task).position, 5) 
		   || this.tab_tasks.get(this.id_current_task).done == IN_PROGRESS)
		{
			this.tab_tasks.get(this.id_current_task).do_task();
			if (!this.path.isEmpty())
				this.path = new ArrayList();
			
		}
		else
		{
			path(this.robot.next_destination);

			if (!this.path.isEmpty() && this.robot.position.is_around(this.path.get(0), 5))
				this.path.remove(0);

			if (!this.path.isEmpty())
			{
				this.robot.next_destination = this.path.get(0);

				this.robot.getCorners();

				if (!this.robot.haveToBack())
					this.robot.goTo(true); 
			}

			if (this.robot.haveToBack())
					this.robot.goTo(false); 
		}
	}

    /**
	 * Select the closer mooring area (use if we do not know the weathercock color)
	 * The position of the flag's task is changed to fit to the decision
	 */
	void select_mooring_area()
	{
		Pos[] points_for_closer = new Pos [] {new Pos(POS_FLAG.x, 200), new Pos(POS_FLAG.x, 650)};
		tab_tasks.get(TASK_FLAG).position = this.robot.position.closer(points_for_closer);
	}

    /**
	 * Find the task to do
	 * @return the index of the task in tab_tasks
	 */
	int find_best_task()
	{
		if (this.id_current_task == TASK_FLAG && this.robot.detected_color == NO_COLOR)
			select_mooring_area();


		long time_left = 100000 - millis() - time;

		if (!this.weathercock_insterted && time_left < 75000)
		{
			this.tasks_order.add(TASK_WEATHERCOCK);
			this.weathercock_insterted = true;
		}

		if ((this.tab_tasks.get(this.tasks_order.get(0)).done == NOT_DONE && millis() - this.time_go_task > 10000)
		|| (this.tab_tasks.get(this.tasks_order.get(0)).done == IN_PROGRESS) && millis() - this.time_go_task > this.tab_tasks.get(this.tasks_order.get(0)).max_time)
		{
			this.tab_tasks.get(this.tasks_order.get(0)).done = NOT_DONE;
			changeTaskOrder(0, this.tasks_order.size() - 1);
			for (int i = 0; i < this.tasks_order.size(); i++)
				if(access(this.robot.position, this.tab_tasks.get(this.tasks_order.get(i)).position, 280) == null)
				{
					changeTaskOrder(i, 0);
					break;
				}

		}


		if (final_move_with_color(time_left) || final_move_without_color(time_left) || this.tasks_order.isEmpty())
		{
			this.emptyTaskOrder();
			this.addTaskOrder(TASK_FLAG);
		}	

		if (time_left < 0.5 || this.tasks_order.isEmpty())
		{
			tab_tasks.get(GAME_OVER).position = this.robot.position;
			this.emptyTaskOrder();
			this.addTaskOrder(GAME_OVER);
		}
		
		if (this.tab_tasks.get(this.tasks_order.get(0)).done == NOT_DONE)
			this.robot.next_destination = this.tab_tasks.get(this.tasks_order.get(0)).position;

		return this.tasks_order.get(0);
	}
    
    /**
	 * Calculate if we have to move to the mooring area with the color of the weathercock
	 * @param: time_left: the time before the end of the game
	 * @return if we have to move to the mooring area 
	 */
	boolean final_move_with_color(long time_left)
	{
		return (tab_tasks.get(TASK_WEATHERCOCK).done == DONE && is_final_move(tab_tasks.get(TASK_FLAG).position, time_left));
	}

	/**
	 * Calculate if we have to move to the closest mooring area without the color of the weathercock
	 * @param: time_left: the time before the end of the game
	 * @return if we have to move to the closest mooring area 
	 */
	boolean final_move_without_color(long time_left)
	{
		return (is_final_move(new Pos(POS_FLAG.x, 200), time_left) 
			&& is_final_move(new Pos(POS_FLAG.x, 650), time_left) 
			&& tab_tasks.get(TASK_FLAG).done != DONE);
	}
	
	/**
	 * Calculate if we have the time to move to "pos" before the end of the game
	 * @param: pos: position of the robot
	 * @param: time_left: the time before the end of the game
	 * @return if we have the time to move to "pos" before the end of the game
	 */
	boolean is_final_move (Pos pos, long time_left)
	{
		return time_left < (tab_tasks.get(TASK_FLAG).max_time + pos.dist(robot.position)/SLOW);
	}

	/**
	 * Move in the array "tasks_order" a task from the index "index_start" to
	 * the index "index_end"
	 * @param index_start: index of the task to move
	 * @param index_end: index where the task has to be moved
	 */
    void changeTaskOrder(int index_start, int index_end)
	{
		this.time_go_task = millis();
		if (index_start == index_end || index_start >= this.tasks_order.size() || index_end >= this.tasks_order.size()
		|| index_start < 0 || index_end < 0)
			return;

		ArrayList <Integer> tasks_order_temp = new ArrayList();

		if (index_start > index_end)
		{
			for(int i = 0; i < index_end; i++)
				tasks_order_temp.add(this.tasks_order.get(i));
			tasks_order_temp.add(this.tasks_order.get(index_start));
			for(int i = index_end; i < this.tasks_order.size(); i++)
				if(i != index_start)
					tasks_order_temp.add(this.tasks_order.get(i));
		}
		else
		{
			for(int i = 0; i <= index_end; i++)
				if(i != index_start)
					tasks_order_temp.add(this.tasks_order.get(i));
			tasks_order_temp.add(this.tasks_order.get(index_start));
			for(int i = index_end + 1; i < this.tasks_order.size(); i++)
				tasks_order_temp.add(this.tasks_order.get(i));
		}

		this.tasks_order = tasks_order_temp;
	}

	void emptyTaskOrder()
	{
		this.time_go_task = millis();
		this.tasks_order = new ArrayList();
	}

	void addTaskOrder(int id)
	{
		this.time_go_task = millis();
		this.tasks_order.add(id);
	}

	void removeTaskOrder(int index)
	{
		this.time_go_task = millis();
		this.tasks_order.remove(index);
	}
}
