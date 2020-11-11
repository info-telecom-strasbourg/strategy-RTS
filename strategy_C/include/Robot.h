#ifndef ROBOT_H
#define ROBOT_H

#include "Pos.h"
#include "Sensor.h"

extern const int STOP;
extern const int FAST;
extern const int NO_COLOR;


/**
 * This class represent a basic robot
 */
class Robot
{
public:
    /* The robot position */
    Pos position;

    /* The robot angle */
    float angle;

    /* The next destination */
    Pos next_destination;

    /* The corners of the robot
	0 & 3 : the front corners
	1 & 2 : the back corners */
	Pos corners[4];

    /* The robot speed regime */
    int speed_regime;

	Vector<Sensor> sensors;


    /**
	 * Constructor of Robot (without sensors, probably the opponent)
	 * @param pos: the initial position of the robot
	 * @param angle: the initial position of the robot
	 */
	Robot(Pos pos_ini, float angle)
	: position(pos_ini),	angle(angle), speed_regime(STOP)
  {
		for (int i = 0; i < 4; ++i)
		{
			float angle_corner = this->angle + M_PI/4 + i*M_PI/2;
			this->corners[i] = Pos(
									  pos_ini.x + HALF_DIAG * cos(angle_corner),
									  pos_ini.y + HALF_DIAG * sin(angle_corner)
									 );
		}
	}

	/**
	 * Constructor of Robot (with sensors, probably the our robot)
	 * @param pos: the initial position of the robot
	 * @param angle: the initial position of the robot
	 * @param sensors_list: the list of sensors of the robot
	 */
	Robot(Pos pos, float angle, Vector<Sensor> sensors_list)
	: position(pos),	angle(angle), speed_regime(STOP), sensors(sensors_list)
  {
		for (int i = 0; i < 4; ++i)
		{
			float angle_corner = this->angle + M_PI/4 + i*M_PI/2;
			this->corners[i] = Pos(
									  pos.x + HALF_DIAG * cos(angle_corner),
									  pos.y + HALF_DIAG * sin(angle_corner)
									 );
		}
	}

    /**
	* Move the robot to the attribute "next_destination" using the method
	* turn and go, and can go back if forward is false
	* @param forward: indicate if we go forward or back
	*/
	void goTo(bool forward);

    /**
	 * Rotate the robot
	 * @param theta: the angle final the robot has to reach
	 */
	void goToAngle(float theta);

     /**
	 * If the front of the robot is too close from the border, it indicates that
     * the robot has to move back
	 * @return if the robot has to move back
	 */
    bool haveToBack();

    /**
	 * Calcul the positions of the corners
	 */
	void getCorners();

    /**
	 * Calcul the positions of the corners
	 */
    void borderColision();
};

/**
 * This class simulate the opponent behaviour
 */
class OpponentRob : public Robot
{
public:
    /* The list of positions to go */
    Vector<Pos> list_moves;

    /**
	 * Constructor of the OpponentRob (random version)
	 * @param init_pos: initial position of the opponent
     * @param angle: angle of the opponent
	 */
    OpponentRob(Pos* init_pos, float angle)
    : Robot(*init_pos, angle)
    {
      this->speed_regime = FAST;
    }
};

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
    RTSRob(Pos* init_position, float angle, Vector<Sensor> sensors)
    : Robot(*init_position, angle, sensors)
    {
        this->detected_color = NO_COLOR;
        this->flag_deployed = false;
    }
};

#endif
