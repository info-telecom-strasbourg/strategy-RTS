#ifndef SENSOR_H
#define SENSOR_H

#include <Vector.h>
#include "Pos.h"

/**
 * This abstract class represent the sensors
 * It contains functions that must be implemented if you create a sensor
 */
class Sensor
{
public:
    /**
	 * Constructor of Sensor
	 */
    Sensor(){}

    /**
	 * Return what the sensor detect
	 * @param detectables: an array of obstacles the sensor is sure to detect
	 * @return an array of obstacles detected by the sensor
	 */
    virtual Vector<Pos> detection(Vector<Pos> detectables);

    /**
	 * Draw the sensors
	 */
    virtual void draw();

    /**
	 * Indicate if the obstacle located at the position "pos" is detected by
     * the sensor
	 * @param pos: position of an obstacle
	 * @return if the obstacle is located by the sensor
	 */
    virtual bool capture(Pos pos);

};

#endif
