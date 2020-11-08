#ifndef MOBILELIDAR_H
#define MOBILELIDAR_H

#include "Sensor.h"

/**
 * This class simulate the mobile lidar behaviour
 */
class MobileLidar : public Sensor
{
public:
    /**
	 * Constructor of MobileLidar
	 */
    MobileLidar()
    : Sensor()
    {}

    /**
	 * Return what the sensor detect
	 * @param detectables: an array of obstacles the sensor detect
	 * @return an array of obstacles detected by the sensor
	 */
    std::vector<Pos> detection(std::vector<Pos> detectables) override
    {
		return detectables;
    }

    /**
	 * Return false (method never used)
	 * @param: pos: the position to detect
	 * @return false
	 */
	bool capture(Pos pos) override {return false;}
};

#endif
