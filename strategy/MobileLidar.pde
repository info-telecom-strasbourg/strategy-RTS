/**
 * This class simulate the mobile lidar behaviour
 */
class MobileLidar extends Sensor
{
    /**
	 * Constructor of MobileLidar
	 */
    MobileLidar(){super();}

    /**
	 * Draw nothing
	 */
    @Override
    void draw()
	{
		if (!robot_RTS.haveToBack())
		{
			fill(0, 0, 255, 100);
			arc(0, 0, 400, 400, - PI/2,  PI/2);
		}
		else 
		{
			fill(255, 0, 255, 100);
			arc(0, 0, 400, 400, PI/2,  3*PI/2);		
		}
		fill (255, 255, 0, 100);
		ellipse(0, 0, 300, 300);
	}


    /**
	 * Return what the sensor detect
	 * @param detectables: an array of obstacles the sensor detect
	 * @return an array of obstacles detected by the sensor
	 */
    @Override
    ArrayList<Pos> detection(ArrayList<Pos> detectables)
    {
		return detectables;
    }

    /**
	 * Return false (method never used)
	 * @param: pos: the position to detect
	 * @return false
	 */
    @Override
	boolean capture(Pos pos) {return false;}
}