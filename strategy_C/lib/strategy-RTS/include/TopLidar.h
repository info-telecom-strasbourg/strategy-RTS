#ifndef TOPLIDAR_H
#define TOPLIDAR_H

#include "Sensor.h"

/**
 * The top lidar (to detect the completion of tasks)
 */
class TopLidar : public Sensor
{
public:
    /**
	 * Constructor of TopLidar
	 */
    TopLidar()
    : Sensor()
    {}

    TopLidar(Sensor sensor)
    : Sensor(sensor)
    {}

    /**
	 * Return what the sensor detect
	 * @param detectables: an array of obstacles the sensor detect
	 * @return an array of obstacles detected by the sensor
	 */

    void detection(Vector<Pos> & obstacles, Vector<Pos> & detectables) override
    {
	    obstacles.fill(detectables);
    }

    /**
	 * Detect if the "pos" is detected by the fixed lidar
     * The variable robot_RTS is the global variable for our robot
	 * @param: pos: the position to detect
	 * @return if "pos" is detected by the fixed lidar
	 */
	bool capture(Pos pos) override;

	bool is_detected(int id);
};

#endif
