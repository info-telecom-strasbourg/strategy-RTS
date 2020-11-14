#ifndef POS_H
#define POS_H

#include <math.h>
#include <Vector.h>
#include <Arduino.h>
#include "Dir.h"

/**
 * Using radians, find the angle in [0, 2 M_PI]
 * @param angle: the initial angle
 * @return the angle's value in [0, 2 M_PI]
 */
float mod2Pi(float angle);

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
	Pos(float x, float y);

	/**
	 * Copy constructor
	 */
	Pos(Pos &pos);

	/**
	 * Check if a point is near of another one
	 * @param pos: the position you want to compare
	 * @param distance: the approximation you want to make
	 * @return a boolean that indicates if the point is arround "pos"
	 */
	bool is_around(Pos pos, int distance);

	/**
	 * Check if a point is at the same position of another one
	 * @param pos: the position you want to compare
	 * @return a boolean that indicates if the point is at the same position of "pos"
	 */
	bool is(Pos pos);

	/**
	 * Calculate the euclidian distance between two points
	 * @param pos: the position of the other point
	 * @return the distance between the point and "pos"
	 */
	float dist(Pos pos);

	/**
	 * Calculate the angle between two points
	 * @param pos: the position of the other point
	 * @return the angle between the point and "pos"
	 */
	float angle(Pos pos);

	/**
	 * Check wich pos is closer to yours
	 * @param tab_pos: the list of position to compare
	 * @return the index of the closer position
	 */
	int closer(Vector<Pos> tab_pos);

	/**
	 * Check if the position is in the arena
	 * @return a boolean that indicate if the point in the arena
	 */
	bool on_arena(int gap);
	/**
	* Find the point in the middle of 2 points
	* @param pos: the other point
	* @return the point in the middle of the 2 points
	*/
	Pos* get_mid(Pos pos);

	bool operator!=(const Pos& pos) {return !((this->x == pos.x) && (this->y == pos.y));}

	bool operator==(const Pos& pos) {return ((this->x == pos.x) && (this->y == pos.y));}
};

#endif
