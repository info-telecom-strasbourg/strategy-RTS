#ifndef BOTTOMLIDAR_H
#define BOTTOMLIDAR_H

#include <vector>
#include "Sensor.h"
#include "RTSRob.h"
#include "OpponentRob.h"

extern RTSRob robot_RTS;
extern std::vector<OpponentRob> rob_opponents;

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
      std::vector<Pos> detection(std::vector<Pos> detectables)
      {

          std::vector<Pos>* obstacles = new std::vector<Pos>();

          for (int i = 0; i < detectables.size(); i++)
              if(capture(detectables[i]))
                  obstacles->push_back(detectables[i]);

          for(int i = 0; i < ARENA_HEIGHT; i+=10)
          {
              Pos left_border (i,0);
              Pos right_border (i, ARENA_WIDTH);

              if(capture(left_border))
                  obstacles->push_back(left_border);
              if(capture(right_border))
                  obstacles->push_back(right_border);
          }

          for(int i = 0; i < ARENA_WIDTH; i+=10)
          {
              Pos up_border (0,i);
              Pos down_border (ARENA_HEIGHT,i);

              if(capture(up_border))
                  obstacles->push_back(up_border);
              if(capture(down_border))
                  obstacles->push_back(down_border);
          }

          return *obstacles;
      }

    /**
	 * Detect if the "pos" is detected by the fixed lidars
     * The variable robot_RTS is the global variable for our robot
	 * @param: pos: the position to detect
	 * @return if "pos" is detected by the fixed lidars
	 */
	bool capture(Pos pos) override
	{
		Pos sensor(robot_RTS.position.x + cos(robot_RTS.angle) * ROBOT_WIDTH/2,
							robot_RTS.position.y + sin(robot_RTS.angle) * ROBOT_WIDTH/2);

		if(sensor.dist(pos) > 250)
			return false;

		float delt_ang = mod2Pi(sensor.angle(pos) - robot_RTS.angle);
		delt_ang = (delt_ang < M_PI) ? delt_ang : 2*M_PI - delt_ang;

		return (delt_ang < M_PI/4);
	}

    /**
     * This function decide wich speed regime will be used by the robot
     * @return an int that represent a speed regime
     */
    int manage_speed()
    {
        std::vector<Pos> oppon_pos;
        for(int i = 0; i < rob_opponents.size(); i++)
            oppon_pos.push_back(rob_opponents[i].position);

        return (detection(oppon_pos).empty()) ? FAST : SLOW;
    }
};

#endif
