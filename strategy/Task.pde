/**
 * A task (weathercock, windsocks, mooring area and lighthouse)
 */
abstract class Task
{
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
    ArrayList<Pos> checkpoints = new ArrayList<Pos>();

	/**
	 * Constructor of Task
	 * @param points: the number of points that this task brings
	 * @param position: the position of the task
	 * @param max_time: the maximum time this task should last
	 */
	Task(int id, int points, Pos position, long max_time)
	{
		this.id = id;
		this.points = points;
		this.position = position;
		this.done = NOT_DONE;
		this.max_time = max_time;
	}

	/**
	 * Indicate that the task in done
	 */
	void over() {this.done = DONE;}

	/**
	 * Indicate that the task is in progress
	 */
	void in_progress() 
	{
		if(this.done == NOT_DONE)
			strat.time_start_task = millis();

		this.done = IN_PROGRESS;
	}

	/**
	 * Indicate that the task is interrupted
	 */
	void interrupted() 
	{
		strat.changeTaskOrder(0, strat.tasks_order.size() - 1);
		strat.tab_tasks.get(TASK_CALIBRATION).in_progress();
		strat.addTaskOrder(TASK_CALIBRATION);
		strat.changeTaskOrder(strat.tasks_order.size() - 1, 0);
		this.done = NOT_DONE;
	}

	/**
	 * Display the task (red if not done, orange if in progress and green if done)
	 */
	void display(boolean disp_checkpoints)
	{
		if (this.id != TASK_CALIBRATION && this.id != GAME_OVER)
		{
			switch (this.done)
			{
				case NOT_DONE:
					fill(255,0,0);
					break;
				case IN_PROGRESS:
					fill(255,165,0);
					break;
				case DONE:
					fill(0,255,0);
					break;
				default :
					fill(0,0,0);
			}

			triangle(position.x, position.y + 30, position.x - 30, position.y - 30, position.x + 30, position.y - 30);
			// if(disp_checkpoints)
            // 	display_checkpoints();
		}
	}

	/**
	 * Display the checkpoints 
	 */
    void display_checkpoints()
    {
        for(int i = 0; i < checkpoints.size(); i++)
            display_checkpoint(checkpoints.get(i));
    }

	/**
	 * Display a specific checkpoint
	 * @param checkpoint: the position of the checkpoint
	 */
    void display_checkpoint(Pos checkpoint)
    {
        pushMatrix();
        translate(checkpoint.x, checkpoint.y, 0);
        fill(255, 255, 255, 125);
        rectMode(CENTER);
        rect(0, 0, 20, 20);
        popMatrix();
        text(this.id, checkpoint.x - 9, checkpoint.y + 11);
    }

	/**
	 * An abstract method that will simulate the completion of the task
	 */
    abstract void do_task();
}
