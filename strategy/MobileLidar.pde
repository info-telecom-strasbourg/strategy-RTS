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
    void draw(){}

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
	 * Return false (method never used)
	 * @param: pos: the position to detect
	 * @return false
	 */
    @Override
	boolean capture(Pos pos) {return false;}
}