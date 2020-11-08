#ifndef POS_H
#define POS_H

#include <math.h>
#include <Vector.h>
#include <Arduino.h>

//Macro for simulation
const int ROBOT_WIDTH = 100;
const int ROBOT_HEIGHT = 100;
const int ARENA_WIDTH = 1000;
const int ARENA_HEIGHT = 1500;
const float HALF_DIAG = sqrt(pow(ROBOT_WIDTH/2,2) + pow(ROBOT_HEIGHT/2,2));
const float rot_step = M_PI/50;

/**
 * Using radians, find the angle in [0, 2 M_PI]
 * @param angle: the initial angle
 * @return the angle's value in [0, 2 M_PI]
 */
float mod2Pi(float angle)
{
	while ((angle < 0) || (angle >= 2 * M_PI))
		if (angle < 0)
			angle += 2 * M_PI;
		else
			angle -= 2 * M_PI;

	return angle;
}

enum Dir {left , right };
Dir dir = right;

/**
 * A point on the map
 * Don't forget :
 *  --> X
 * |
 * v Y
 */
class Pos
{
public:
	/* The position of the point following the axe x */
	float x;

	/* The position of the point following the axe y */
	float y;

  /**
   * Default constructor of Pos
   */
  Pos()
  {}

	/**
	 * Constructor of Pos
	 * @param x: the position of the point following the axis x
	 * @param y: the position of the point following the axis y
	 */
	Pos(float x, float y)
	{
		this->x = x;
		this->y = y;
	}

	/**
	 * Copy constructor
	 */
	Pos(Pos &pos)
	{
		this->x = pos.x;
		this->y = pos.y;
	}

	/**
	 * Check if a point is near of another one
	 * @param pos: the position you want to compare
	 * @param distance: the approximation you want to make
	 * @return a boolean that indicates if the point is arround "pos"
	 */
	bool is_around(Pos pos, int distance)
	{
		return abs(this->x - pos.x) < distance && abs(this->y - pos.y) < distance;
	}

	/**
	 * Check if a point is at the same position of another one
	 * @param pos: the position you want to compare
	 * @return a boolean that indicates if the point is at the same position of "pos"
	 */
	bool is(Pos pos)
	{
		return this->x == pos.x && this->y == pos.y;
	}

	/**
	 * Calculate the euclidian distance between two points
	 * @param pos: the position of the other point
	 * @return the distance between the point and "pos"
	 */
	float dist(Pos pos)
	{
		return sqrt(pow(this->x - pos.x, 2) + pow(this->y - pos.y, 2));
	}

	/**
	 * Calculate the angle between two points
	 * @param pos: the position of the other point
	 * @return the angle between the point and "pos"
	 */
	float angle(Pos pos)
	{
		return mod2Pi(atan2(pos.y - this->y, pos.x - this->x));
	}

	/**
	 * Check wich pos is closer to yours
	 * @param tab_pos: the list of position to compare
	 * @return the index of the closer position
	 */
	int closer(Vector<Pos> tab_pos)
	{
		int closest = 0;
		float dist_ = dist(tab_pos[0]);

		for(unsigned int i = 1; i < tab_pos.size(); i++)
		{
			float dist_pos = dist(tab_pos[i]);
			if(dist_pos < dist_)
			{
				dist_ = dist_pos;
				closest = i;
			}
		}

		return closest;
	}

	/**
	 * Check if the position is in the arena
	 * @return a boolean that indicate if the point in the arena
	 */
	bool on_arena(int gap)
	{
		int gap_port = 100;
		int port_x = (dir == left) ? ARENA_HEIGHT - 200 : 200;
		bool on_port = (dir == left) ? this->x > port_x - gap : this->x < port_x - gap;

		return ((this->x > gap) && (this->x < ARENA_HEIGHT - gap) && (this->y > gap) && (this->y < ARENA_WIDTH - gap)
		& !(on_port && this->y > 250 - gap && this->y < 550 + gap));
	}
	/**
	* Find the point in the middle of 2 points
	* @param pos: the other point
	* @return the point in the middle of the 2 points
	*/
	Pos* get_mid(Pos pos)
	{
		return new Pos((this->x + pos.x)/2, (this->y + pos.y)/2);
	}

	bool operator!=(const Pos& pos) {return !((this->x == pos.x) && (this->y == pos.y));}

	bool operator==(const Pos& pos) {return ((this->x == pos.x) && (this->y == pos.y));}
};

//Macro for tasks
const int TASK_WEATHERCOCK = 0;
const int TASK_WINDSOCK_1 = 1;
const int TASK_WINDSOCK_2 = 2;
const int TASK_LIGHTHOUSE = 3;
const int TASK_MOORING_AREA = 4;
const int TASK_CALIBRATION = 5;
const int GAME_OVER = 6;
const int NO_TASK = 7;

//Macro for speed regimes
const int STOP = 0;
const int SLOW = 3;
const int FAST = 10;

//Macro for colors (weathercock)
const int NO_COLOR = 0;
const int BLACK = 1;
const int WHITE = 2;

//Macro for done
const int NOT_DONE = 0;
const int IN_PROGRESS = 1;
const int DONE = 2;

//Macro for tasks positions
Pos POS_LIGHTHOUSE;
Pos POS_LIGHTHOUSE_OP;
Pos POS_WEATHERCOCK;
Pos POS_WINDSOCK_1;
Pos POS_WINDSOCK_2;
Pos POS_MOORING_AREA;

//Macro for tasks positions
int BOTTOM_LIDAR = 0;
int TOP_LIDAR = 1;
int MOBILE_LIDAR = 2;

//Macro for null types
Pos POS_NULL(-1,-1);

#endif
