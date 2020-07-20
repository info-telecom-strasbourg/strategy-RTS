class Weathercock extends Task
{
    int weathercock_checkpoints;

    Weathercock(int id, int points, Pos position, long max_time, ArrayList<Pos> weathercock_checkpoints)
    {
        super(id, points, position, max_time);
        this.checkpoints = weathercock_checkpoints;
        this.weathercock_checkpoints = -1;
    }

    /**
	 * Detect the weathercock color and update POS_FLAG
	 */
	void detect_weathercock_col()
	{
		switch (this.robot.detected_color = weathercock.color_w)
		{
			case BLACK:
				strat.tab_tasks[TASK_FLAG].position.y = 200;
				break;
			case WHITE:
				strat.tab_tasks[TASK_FLAG].position.y = 650;
				break;
			default:
				println("No color found");
		}
	}


    void do_task()
	{
		this.in_progress();
		this.checkpoints.get(0).y = robot_RTS.position.y;
		robot_RTS.next_destination = this.checkpoints.get(0);

		if (robot_RTS.position.is_around(this.checkpoints.get(0), 5))
		{
			this.checkpoints.get(0).y = 50;
			robot_RTS.next_destination = this.checkpoints.get(0);
		}

		if (robot_RTS.position.is_around(this.checkpoints.get(0), 5))
			if(mod2Pi(3*PI/2 - robot_RTS.angle) < rot_step)
			{
				if(this.weathercock_wait == -1)
					this.weathercock_wait = millis();

				if((millis() - this.weathercock_wait) > 2000)
				{
					this.detect_weathercock_col();
					this.over();
					strat.tasks_order.remove(0);
				}
			}
			else
				robot_RTS.goToAngle(3*PI/2);
		strat.path();
		robot_RTS.goTo(true);
	}
}