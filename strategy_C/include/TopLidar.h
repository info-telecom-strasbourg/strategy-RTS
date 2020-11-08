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

    std::vector<Pos> detection(std::vector<Pos> detectable) override
    {
	    return detectable;
    }

    /**
	 * Detect if the "pos" is detected by the fixed lidar
     * The variable robot_RTS is the global variable for our robot
	 * @param: pos: the position to detect
	 * @return if "pos" is detected by the fixed lidar
	 */
	bool capture(Pos pos) override
	{
		Pos sensor = new Pos(robot_RTS.position.x + cos(robot_RTS.angle) * ROBOT_WIDTH/2,
							robot_RTS.position.y + sin(robot_RTS.angle) * ROBOT_WIDTH/2);

		if(sensor.dist(pos) > 250)
			return false;

		float delt_ang = mod2Pi(sensor.angle(pos) - robot_RTS.angle);
		delt_ang = (delt_ang < M_PI) ? delt_ang : 2*M_PI - delt_ang;

		return (delt_ang < M_PI/12);
	}

	bool is_detected(int id)
	{
		return ((99 * random() + 1) > 90) ? false : true;
	}
};

#endif
