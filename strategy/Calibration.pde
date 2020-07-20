/**
 * This class represent the task calibration. It allows
 * the robot to reinitialize its position
 */
class Calibration extends Task
{
    /* A checkpoint to help to robot to calibrate in security */
    Pos calibrate_checkpoint;

    /* Indicate if we are calibrating the robot following the axis x*/
    boolean x_calibration;

    /* Indicate if we have calibrated the robot following the axis y*/
    boolean y_calibrated;
    
    /**
	 * Constructor of Calibration
     * @param id: task id
     * @param points: points of this task (=0)
     * @param position: task position
     * @param max_time: the max time this task should last
	 */
    Calibration(int id, int points, Pos position, long max_time)
    {
        super(id, points, position, max_time);
        this.calibrate_checkpoint = null;
        this.x_calibration = false;
        this.y_calibrated = false;
        this.done = DONE;
    }

    /**
	 * Calibrate the robot when we have lost our position
	 */
    void do_task()
    {
        float calib_x = (robot_RTS.position.x < ARENA_HEIGHT/2) ? 0 : ARENA_HEIGHT;
        float calib_y = (robot_RTS.position.y < ARENA_WIDTH/2) ? 0 : ARENA_WIDTH;
        float calib_secu_y = (robot_RTS.position.y < ARENA_WIDTH/2) ? 100 : ARENA_WIDTH - 100;

        if(!y_calibrated)
            y_calibration(calib_y, calib_secu_y);
        else
            x_calibration(calib_x, calib_secu_y);
    }

    /**
	 * Calibrate the robot following the y axis
	 */
    void y_calibration(float calib_y, float calib_secu_y)
    {
        this.calibrate_checkpoint = new Pos(robot_RTS.position.x, calib_y);
        robot_RTS.next_destination = this.calibrate_checkpoint;	

        robot_RTS.getCorners();
        if(!robot_RTS.corners[0].on_arena(1) && !robot_RTS.corners[3].on_arena(1))
        {
            this.y_calibrated = true;
            this.calibrate_checkpoint = new Pos(robot_RTS.position.x, calib_secu_y);
            robot_RTS.next_destination = this.calibrate_checkpoint;	
        }
        strat.path(robot_RTS.next_destination);
        robot_RTS.goTo(true);
    }

    /**
	 * Calibrate the robot following the x axis
	 */
    void x_calibration(float calib_x, float calib_secu_y)
    {
        if(!this.x_calibration)
        {
            if(robot_RTS.position.is_around(calibrate_checkpoint, 5))
            {
                x_calibration = true;
                calibrate_checkpoint = new Pos(calib_x, calib_secu_y);
                robot_RTS.next_destination = calibrate_checkpoint;	
            }
            if (robot_RTS.haveToBack())
                robot_RTS.goTo(false); 
            else
                robot_RTS.goTo(true); 
        }
        else
        {
            if(!robot_RTS.corners[0].on_arena(1) && !robot_RTS.corners[3].on_arena(1))
            {
                strat.tab_tasks.get(TASK_CALIBRATION).over();
                strat.tasks_order.remove(0);
                y_calibrated = false;
                x_calibration = false;
                strat.tab_tasks.get(TASK_CALIBRATION).position = new Pos(-50, -50);
            }
            strat.path(robot_RTS.next_destination);
            robot_RTS.goTo(true);
        }   
    }
}
