class Strat extends ManageOpponent
{
    int id_current_task;
    int time;
    int score;
    ArrayList<Integer> tasks_order = new ArrayList<Integer>();
    ArrayList<Task> tab_tasks = new ArrayList<Task>();

    Strat(RTSRob robot)
    {
        super(robot);
        this.id_current_task = -1;
        this.time = millis();
        this.score = 7;
    }

    /**
	 * Apply the strategy
	 * @param: opponent: the opponent's robot (for simulation)
	 */
	void apply()
	{
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
		tab_tasks.get(GAME_OVER).position = this.robot.position;

		if (this.id_current_task == TASK_FLAG && this.robot.detected_color == NO_COLOR)
			select_mooring_area();


		long time_left = 100000 - millis() - time;


		if (final_move_with_color(time_left) || final_move_without_color(time_left))	
			this.changeTaskOrder(this.tasks_order.size() - 2, 0);

		if (time_left < 0.5)
			this.changeTaskOrder(this.tasks_order.size() - 1, 0);

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

    void changeTaskOrder(int index_start, int index_end)
	{
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
}
