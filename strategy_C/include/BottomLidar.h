#ifndef BOTTOMLIDAR_H
#define BOTTOMLIDAR_H

#include <Vector.h>
#include "Sensor.h"

/**
 * This class simulate the behaviour of the bottom lidars
 */
class BottomLidar : public Sensor
{
public:
	/**
	 * Constructor of BottomLidar
	 */
    BottomLidar()
    : Sensor()
    {}

    BottomLidar(Sensor sensor)
    : Sensor(sensor)
    {}



	 /**
	 * Return what the sensor detect
	 * @param detectables: an array of obstacles containing only the opponent position
	 * @return an array of obstacles detected by the sensor
	 */
    Vector<Pos> detection(Vector<Pos> detectables);

    /**
	 * Detect if the "pos" is detected by the fixed lidars
     * The variable robot_RTS is the global variable for our robot
	 * @param: pos: the position to detect
	 * @return if "pos" is detected by the fixed lidars
	 */
	  bool capture(Pos pos) override;

    /**
     * This function decide wich speed regime will be used by the robot
     * @return an int that represent a speed regime
     */
    int manage_speed();
};

#endif
