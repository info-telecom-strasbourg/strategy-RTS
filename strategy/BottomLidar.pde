class BottomLidar implements Sensor
{
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

    @Override
    ArrayList<Pos> detection(OpponentRob opponent)
    {
        ArrayList<Pos> obstacles = new ArrayList<Pos>();
        
    
    }

    /**
	 * Detect if the "pos" is detected by the fixed lidars
	 * @param: pos: the position to detect
	 * @return if "pos" is detected by the fixed lidars
	 */
	boolean capture(Pos pos)
	{
		Pos sensor = new Pos(this.robot.position.x + cos(this.robot.angle) * ROBOT_WIDTH/2,
							this.robot.position.y + sin(this.robot.angle) * ROBOT_WIDTH/2);

		if(sensor.dist(pos) > 250)
			return false;

		float delt_ang = mod2Pi(sensor.angle(pos) - this.robot.angle);
		delt_ang = (delt_ang < PI) ? delt_ang : 2*PI - delt_ang;

		return (delt_ang < PI/4);
	}
}