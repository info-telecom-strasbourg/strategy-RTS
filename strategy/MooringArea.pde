/**
 * This class represent the task linked to the mooring area
 */
class MooringArea extends Task
{
	/**
	 * The constructor of MooringArea
	 * @param id: the identifier of the task
	 * @param points: the points given by the task
	 * @param position: the location of this task
	 * @param max_time: the estimated necessary time to accomplish the task
	 */
    MooringArea(int id, int points, Pos position, long max_time)
    {
        super(id, points, position, max_time);
    }

    /**
	 * Simulate the task linked to the mooring area
	 */
	void do_task()
	{
		if (millis() - strat.time > 99500)
		{
			this.over();
			strat.tab_tasks.get(GAME_OVER).position = robot_RTS.position;
			strat.tab_tasks.get(GAME_OVER).in_progress();
			strat.emptyTaskOrder();
			strat.addTaskOrder(GAME_OVER);
		}
		
		if(this.done == DONE)
			return;

		if(this.done != IN_PROGRESS)
		{
			Pos weth_1 = new Pos(POS_MOORING_AREA.x, 200), weth_2 = new Pos(POS_MOORING_AREA.x, 650);
			if (robot_RTS.position.is_around(weth_1, 5) || robot_RTS.position.is_around(weth_2, 5))
			{
				if (strat.tab_tasks.get(TASK_WEATHERCOCK).done == DONE)
					strat.score += 10;
				else
					strat.score += 5;
				this.over();
				return;
			}
		}
		this.in_progress();
	}
}
