/**
 * A point on the map
 * Don't forget :
 *  --> X
 * |
 * v Y 
 */
class Pos
{
	float x;
	float y;

	/**
	 * Constructor of Pos
	 * @param x: the position of the point following the axe x
	 * @param y: the position of the point following the axe y
	 */
	Pos(float x, float y)
	{
		this.x = x;
		this.y = y;
	}

	/**
	 * Copy constructor
	 */
	Pos(Pos pos)
	{
		this.x = pos.x;
		this.y = pos.y;
	}

	/**
	 * Check if a point is near of another one
	 * @param pos: the position you want to compare yours with
	 * @param distance: the approximation you want to make
	 * @return a boolean that indicate if the point is arround "pos"
	 */
	boolean is_around(Pos pos, int distance)
	{
		return abs(this.x - pos.x) < distance && abs(this.y - pos.y) < distance;
	}

	/**
	 * Calculate the euclidian distance between two points
	 * @param pos: the position of the other point
	 * @return the distance between the point and "pos"
	 */
	float dist(Pos pos)
	{
		return sqrt(pow(this.x - pos.x, 2) + pow(this.y - pos.y, 2));
	}

	/**
	 * Calculate the angle between two points
	 * @param pos: the position of the other point
	 * @return the angle between the point and "pos"
	 */
	float angle(Pos pos)
	{
		return mod2Pi(atan2(pos.y - this.y, pos.x - this.x));
	}

	/**
	 * Check wich pos is closer to yours
	 * @param tab_pos: the list of position to compare
	 * @return the closest pos contained in "tab_pos"
	 */
	Pos closer(Pos[] tab_pos)
	{
		Pos closest = tab_pos[0];
		float dist = dist(tab_pos[0]);

		for(int i = 1; i < tab_pos.length; i++)
		{
			float dist_pos = dist(tab_pos[i]);
			if(dist_pos < dist)
			{
				dist = dist_pos;
				closest = tab_pos[i];
			}
		}

		return closest;
	}

	/**
	 * Check if the position is in the arena
	 * @return a boolean that indicate if the point in the arena
	 */
	boolean onArena()
	{
		return ((this.x > 0) && (this.x < ARENA_HEIGHT - 100) && (this.y > 0) && (this.y < ARENA_WIDTH - 100));
	}
	/**
	* Find the point in the middle of 2 points
	* @param pos: the other point
	* @return the point in the middle of the 2 points
	*/
	Pos get_mid(Pos pos)
	{
		return new Pos((this.x + pos.x)/2, (this.y + pos.y)/2);
	}
}

