/**
 * A task (weathercock, windsocks, flag and lighthouse)
 */
class Task
{
	int points;
	Pos position;
	int done;
	long max_time;


	/**
	 * Constructor of Task
	 * @param points: the number of points that this task brings
	 * @param position: the position of the task
	 * @param max_time: the maximum time this task should last
	 */
	Task(int points, Pos position, long max_time)
	{
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
	void display()
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
	}
}
