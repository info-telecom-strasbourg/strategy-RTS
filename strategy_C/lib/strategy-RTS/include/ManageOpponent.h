#ifndef MANAGEOPPONENT_H
#define MANAGEOPPONENT_H

#include "Robot.h"

extern Vector<OpponentRob> rob_opponents;

/**
 * This class allow our robot to avoid the opponent
 * You can make a class that inherits this class to keep this behaviour
 */
class ManageOpponent
{
public:
	/* The robot that avoid the opponent */
    RTSRob robot;

	/* The opponent(s) position(s) -> for simulation */
    Vector<Pos> opponent_positions;

	/* The path selected by the robot */
    Vector<Pos> path;

	/* The position you want to reach right now */
    Pos objective_position;

	/**
	 * The constructor of the class
	 * @param robot: the robot that will avoid the opponent
	 */
    ManageOpponent(RTSRob robot)
    : robot(robot)
    {
        Pos opp_pos[2];
        Pos path_arr[1024];
        opponent_positions = opp_pos;
        path = path_arr;
    }

    /**
	 * Identify the opponents position with the mobile lidar
	 * @param: opponent: the opponent's robot (for simulation)
	 */
	void find_the_opponent();

    /**
	 * Calculate the best path to move to the next task (we use a checkpoint in the
	 * case we have to avoid the opponent), but if no path is found, we stop the robot
	 */
	void find_path(float secu_dist);

	/**
	 * Indicate if is possible to move from the "point_1" to the "point_2" without
	 * collapsing with the opponent
	 * @param: point_1: start point
	 * @param: point_2: arrival point
	 * @param: secu_dist: security distance
	 * @return null if a direct route is possible between point_1 and point_2,
	 * otherwise the intersection point with the opponent
	 */
	Pos access (Pos point_1, Pos point_2, float secu_dist);

    /**
	 * Indicate if the opponent is on the security area
	 * @param: current_pos: the current position
	 * @param: opponent_pos: the opponent position
	 * @param: secu_dist: security distance
	 * @return if the opponent is on the security area
	 */
	bool is_on_security_area(Pos current_pos, Pos opponent_pos, float secu_dist);

	/**
	 * Find a checkpoint to avoid the opponent robot by testing different drifts
	 * @param: intersection: point where our robot collapse with the opponent
	 * @param: secu_dist: security distance
	 * @return null if no checkpoint is found, otherwise the found checkpoint
	 */
	Pos find_step(Pos intersection, float secu_dist);

	/**
	 * Find a checkpoint on a specific drift
	 * @param: angle: the drift angle
	 * @param: secu_dist: security distance
	 * @return null if no checkpoint is found, otherwise the found checkpoint
	 */
	Pos find_checkpoint(float angle, float secu_dist);

	/**
	 * Check if our robot won't collapse by following the path
	 * @param: secu_dist: security distance
	 */
	void check_path(float secu_dist);

	/**
	 * Find the best path in the situation
	 * If we have a path, we check if it still work
	 * else we find a new path
	 * @param objectiv_pos: the destination you want to reach
	 */
    void best_path(Pos objectiv_pos);
};


#endif
