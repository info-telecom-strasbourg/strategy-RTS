#ifndef WEATHERCOCKCOLOUR_H
#define WEATHERCOCKCOLOUR_H

#include "Pos.h"

/**
 * Simulate the behavior of the weathercock
 */
class WeathercockColour
{
public:
	int color_w;
	bool activate;
	long begin;

	/**
	 * Constructor of Weathercock
	 */
	WeathercockColour(int millis);

	/**
	 * Choose randomly a color for the weathercock
	 * The color is selected 25 seconds after the beginnig of the game
	 */
	void decide_zone(int millis);
};

#endif
