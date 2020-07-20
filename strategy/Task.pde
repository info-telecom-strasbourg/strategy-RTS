/**
 * A task (weathercock, windsocks, flag and lighthouse)
 */
abstract class Task
{
	int id;
	int points;
	Pos position;
	int done;
	long max_time;
    ArrayList<Pos> checkpoints;

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
	void over() {done = DONE;}

	/**
	 * Indicate that the task is in progress
	 */
	void in_progress() {done = IN_PROGRESS;}

	/**
	 * Indicate that the task is interrupted
	 */
	void interrupted() {done = NOT_DONE;}

	/**
	 * Display the task (red if not done, orange if in progress and green if done)
	 */
	void display(boolean disp_checkpoints)
	{
		if (this.id != TASK_CALIBRATION && this.id != GAME_OVER)
		{
			switch (done)
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
            display_checkpoints();
		}
	}

    void display_checkpoints()
    {
        for(int i = 0; i < checkpoints.size(); i++)
            display_checkpoint(checkpoints.get(i));
    }

    void display_checkpoint(Pos checkpoint)
    {
        pushMatrix();
        translate(checkpoint.x, checkpoint.y, 0);
        fill(0, 0, 0, 125);
        rectMode(CENTER);
        rect(0, 0, 10, 10);
        popMatrix();
        text(this.id, checkpoint.x - 9, checkpoint.y + 11);
    }

    abstract do_task();
}
