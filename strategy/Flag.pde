class Flag extends Task
{
    Flag(int id, int points, Pos position, long max_time)
    {
        super(id, points, position, max_time);
    }

    /**
	 * Simulate the task linked to the flag
	 */
	void do_task()
	{
		if(strat.tab_tasks[this.id].done == DONE)
			return;

		if(strat.tab_tasks[this.id].done != IN_PROGRESS)
		{
			Pos weth_1 = new Pos(POS_FLAG.x, 200), weth_2 = new Pos(POS_FLAG.x, 650);
			if (this.robot.position.is_around(weth_1, 5) || this.robot.position.is_around(weth_2, 5))
				if (strat.tab_tasks[TASK_WEATHERCOCK].done == DONE)
					this.score += 10;
				else
					this.score += 5;
		}

		strat.tab_tasks[this.id].in_progress();
		if (millis() - this.time > 95500)
		{
			this.robot.flag = true;
			strat.tab_tasks[this.id].over();
			tasks_order.remove(0);
			this.score += strat.tab_tasks[this.id].points;
		}
	}
}