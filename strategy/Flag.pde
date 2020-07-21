/**
 * This class represent the task linked to the flag
 */
class Flag extends Task
{
	/**
	 * The class' constructor
	 * @param id: the identifier of the task
	 * @param points: the points given by the task
	 * @param position: the location of this task
	 * @param max_time: the estimated necessary time to accomplish the task
	 */
    Flag(int id, int points, Pos position, long max_time)
    {
        super(id, points, position, max_time);
    }

    /**
	 * Simulate the task linked to the flag
	 */
	void do_task()
	{
		if (millis() - strat.time > 95500)
		{
			robot_RTS.flag_deployed = true;
			this.over();
			strat.removeTaskOrder(0);
			strat.score += this.points;
		}
		
		if(this.done == DONE)
			return;

		if(this.done != IN_PROGRESS)
		{
			Pos weth_1 = new Pos(POS_FLAG.x, 200), weth_2 = new Pos(POS_FLAG.x, 650);
			if (robot_RTS.position.is_around(weth_1, 5) || robot_RTS.position.is_around(weth_2, 5))
				if (strat.tab_tasks.get(TASK_WEATHERCOCK).done == DONE)
					strat.score += 10;
				else
					strat.score += 5;
		}

		this.in_progress();
	}
}
