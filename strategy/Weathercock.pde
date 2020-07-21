/**
 * This class represent the task weathercock
 */
class Weathercock extends Task
{
	/* The begining of the task */
    int weathercock_wait;

	/**
	 * The constructor of Weathercock
	 * @param id: the identifier of the task
	 * @param points: the points given by the task
	 * @param position: the location of this task
	 * @param max_time: the estimated necessary time to accomplish the task
	 * @param weathercock_checkpoints: the checkpoints we need to reach to accomplish the task
	 */
    Weathercock(int id, int points, Pos position, long max_time, ArrayList<Pos> weathercock_checkpoints)
    {
        super(id, points, position, max_time);
        this.checkpoints = weathercock_checkpoints;
        this.weathercock_wait = -1;
    }

    /**
	 * Detect the weathercock color and update POS_MOORING_AREA
	 */
	void detect_weathercock_col()
	{
		switch (robot_RTS.detected_color = weathercock.color_w)
		{
			case BLACK:
				strat.tab_tasks.get(TASK_MOORING_AREA).position.y = 200;
				break;
			case WHITE:
				strat.tab_tasks.get(TASK_MOORING_AREA).position.y = 650;
				break;
			default:
				println("No color found");
		}
	}

	/**
	 * Simulate the execution of the weathercock
	 */
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
					if(((TopLidar)robot_RTS.sensors.get(TOP_LIDAR)).is_detected(this.id))
					{
						this.detect_weathercock_col();
						this.over();
						strat.removeTaskOrder(0);
					}
					else
						this.interrupted();
				}
			}
			else
				robot_RTS.goToAngle(3*PI/2);
		strat.path(robot_RTS.next_destination);
		robot_RTS.goTo(true);
	}
}
