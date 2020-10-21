#ifndef RTSROBOT_H
#define RTSROBOT_H

#include "Robot.h"

/**
 * This class represent our robot
 */
class RTSRob : public Robot
{
public:
    /* The weathercock's color detected by our robot */
    int detected_color;

    /* A boolean that indicate if the flag is deployed*/
    bool flag_deployed;

    /**
	 * Constructor of our robot
	 * @param pos: the initial position of the robot
	 * @param angle: the initial position of the robot
     * @param sensors: the list of sensors of our robot
	 */
    RTSRob(Pos init_position, float angle, std::vector<Sensor> sensors)
    : Robot(init_position, angle, sensors)
    {
        this->detected_color = NO_COLOR;
        this->flag_deployed = false;
    }
};


#endif
