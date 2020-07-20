abstract class Sensor
{
    /**
	 * Constructor of Sensor
	 */
    Sensor(){}

    /**
	 * Return what the sensor detect
	 * @param detectables: an array of obstacles the sensor is sure to detect
	 * @return an array of obstacles detected by the sensor
	 */
    abstract ArrayList<Pos> detection(ArrayList<Pos> detectables);

    /**
	 * Draw the sensors
	 */
    abstract void draw();

    /**
	 * Indicate if the obstacle located at the position "pos" is detected by
     * the sensor
	 * @param pos: position of an obstacle
	 * @return if the obstacle is located by the sensor
	 */
    abstract boolean capture(Pos pos);
}