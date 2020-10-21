#ifndef OPPONENTROB_H
#define OPPONENTROB_H

#include "Robot.h"

/**
 * This class simulate the opponent behaviour
 */
class OpponentRob : public Robot
{
public:
    /* The list of positions to go */
    std::vector<Pos> list_moves;

    /**
	 * Constructor of the OpponentRob (random version)
	 * @param init_pos: initial position of the opponent
     * @param angle: angle of the opponent
	 */
    OpponentRob(Pos init_pos, float angle)
    : Robot(init_pos, angle), list_moves(random_positions(53))
    {
      this->speed_regime = FAST;
    }
};

#endif
