/**
 * This class simulate the behaviour of the bottom lidars
 */
class BottomLidar extends Sensor
{
	/**
	 * Constructor of BottomLidar
	 */
    BottomLidar(){super();}

    /**
	 * Draw a cone to visualise what the lidar in the front of the robot detect
	 * The angle is PI/2 => 90°
	 */
    @Override
    void draw()
    {
        fill(255, 255, 255, 150);
		arc(ROBOT_HEIGHT/2, 0, 500, 500, - PI/4,  PI/4);
    }

	/**
	 * Return what the sensor detect
	 * @param detectables: an array of obstacles containing only the opponent position
	 * @return an array of obstacles detected by the sensor
	 */
    @Override
    ArrayList<Pos> detection(ArrayList<Pos> detectables)
    {

        ArrayList<Pos> obstacles = new ArrayList<Pos>();

        for (int i = 0; i < detectables.size(); i++)
            if(capture(detectables.get(i)))
                obstacles.add(detectables.get(i));

        for(int i = 0; i < ARENA_HEIGHT; i+=10)
        {
            Pos left_border = new Pos(i,0);
            Pos right_border = new Pos(i, ARENA_WIDTH);

            if(capture(left_border))
                obstacles.add(left_border);
            if(capture(right_border))
                obstacles.add(right_border);
        }

        for(int i = 0; i < ARENA_WIDTH; i+=10)
        {
            Pos up_border = new Pos(0,i);
            Pos down_border = new Pos(ARENA_HEIGHT,i);

            if(capture(up_border))
                obstacles.add(up_border);
            if(capture(down_border))
                obstacles.add(down_border);
        }

        return obstacles;
    }

    /**
	 * Detect if the "pos" is detected by the fixed lidars
     * The variable robot_RTS is the global variable for our robot
	 * @param: pos: the position to detect
	 * @return if "pos" is detected by the fixed lidars
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

		return (delt_ang < PI/4);
	}

    /**
     * This function decide wich speed regime will be used by the robot
     * @return an int that represent a speed regime
     */
    int manage_speed()
    {
        ArrayList<Pos> oppon_pos = new ArrayList<Pos>();
        for(int i = 0; i < rob_opponents.size(); i++)
            oppon_pos.add(rob_opponents.get(i).position);

        return (detection(oppon_pos).isEmpty()) ? FAST : SLOW;
    }
}
