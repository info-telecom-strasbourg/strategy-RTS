/**
 * This class represent the task inked to the windocks
 */
class Windsock extends Task
{
	/* The beginning of the task */
    long windsock_wait;

    Windsock(int id, int points, Pos position, long max_time, ArrayList<Pos> windsock_checkpoints)
    {
        super(id, points, position, max_time);
        this.checkpoints = windsock_checkpoints;
        this.windsock_wait = -1;
    }

	/**
	 * A function that windsock to be raised
	 * @return a boolean that indicate if the windsock is raised
	 */
    boolean raise_windsock()
	{
        if(windsock_wait == -1)
            windsock_wait = millis();
        
        return (millis() - windsock_wait > 4000);
	}

	/**
	 * Simulate the execution of the windsock task
	 */
	void do_task()
	{		
		this.in_progress();
				
		this.checkpoints.get(0).x = robot_RTS.position.x;
		robot_RTS.next_destination = this.checkpoints.get(0);

		if(!robot_RTS.position.is_around(robot_RTS.next_destination, 5))
		{
			strat.path(robot_RTS.next_destination);
			robot_RTS.goTo(true);
			return;
		}

		if(!raise_windsock())
			return;
			
		boolean done = true;
		if(done)
		{
			this.over();
			strat.removeTaskOrder(0);
			strat.score += this.points;
			if ((this.id == TASK_WINDSOCK_1 && strat.tab_tasks.get(TASK_WINDSOCK_2).done == DONE)
			|| (this.id == TASK_WINDSOCK_2 && strat.tab_tasks.get(TASK_WINDSOCK_1).done == DONE))
				strat.score += this.points;
		}
		else
		{
			this.windsock_wait = -1;
			this.interrupted();
			strat.tab_tasks.get(TASK_CALIBRATION).in_progress();
		}		
	}
}
