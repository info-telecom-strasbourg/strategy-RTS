class Windsock extends Task
{
    long windsock_wait;

    Windsock(int id, int points, Pos position, long max_time, ArrayList<Pos> windsock_checkpoints)
    {
        super(id, points, position, max_time);
        this.checkpoints = weathercock_checkpoints;
        this.windsock_wait = -1;
    }

    boolean raise_windsock()
	{
        if(windsock_wait == -1)
            windsock_wait = millis();
        
        return (millis() - windsock_wait > 4000);
	}

	void do_task(int id)
	{		
		strat.tab_tasks[this.id].in_progress();
		
		
		this.checkpoints.get(0).x = robot_RTS.position.x;
		robot_RTS.next_destination = this.checkpoints.get(0);

		if(!robot_RTS.position.is_around(robot_RTS.next_destination, 5))
		{
			start.path();
			robot_RTS.goTo(true);
			return;
		}

		if(!raise_windsock())
			return;
		
		if(object_is_located(true))
		{
			this.over();
			strat.tasks_order.remove(0);
			strat.score += this.points;
			if (this.done == DONE)
				strat.score += this.points;
		}
		else
		{
			this.windsock_wait = -1;
			this.interrupted();
			strat.tab_tasks[TASK_CALIBRATION].in_progress();
		}		
	}
}