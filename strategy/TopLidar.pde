/**
 * The top lidar (to detect the completion of tasks)
 */
class TopLidar extends Sensor
{
    /**
	 * Constructor of TopLidar
	 */
    TopLidar(){super();}

    /**
	 * Draw a cone to visualise what the lidar in the front of the robot detect
	 * The angle is PI/2 => 90°
	 */
    @Override
    void draw()
    {
       fill(255,165,0, 150);
       arc(ROBOT_HEIGHT/2, 0, 500, 500, - PI/12,  PI/12);
    }

    /**
	 * Return what the sensor detect
	 * @param detectables: an array of obstacles the sensor detect
	 * @return an array of obstacles detected by the sensor
	 */
    @Override
    ArrayList<Pos> detection(ArrayList<Pos> detectable)
    {
	    return detectable;
    }

    /**
	 * Detect if the "pos" is detected by the fixed lidar
     * The variable robot_RTS is the global variable for our robot
	 * @param: pos: the position to detect
	 * @return if "pos" is detected by the fixed lidar
	 */
    @Override
	boolean capture(Pos pos)
	{
		Pos sensor = new Pos(robot_RTS.position.x + cos(robot_RTS.angle) * ROBOT_WIDTH/2,
							robot_RTS.position.y + sin(robot_RTS.angle) * ROBOT_WIDTH/2);

		if(sensor.dist(pos) > 250)
			return false;

		float delt_ang = mod2Pi(sensor.angle(pos) - robot_RTS.angle);
		delt_ang = (delt_ang < PI) ? delt_ang : 2*PI - delt_ang;

		return (delt_ang < PI/12);
	}

	boolean is_detected(int id)
	{
		return (id == TASK_LIGHTHOUSE) ? false : true;
	}
}