#ifndef WEATHERCOCKCOLOUR_H
#define WEATHERCOCKCOLOUR_H

#include "Geometry.h"

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
	WeathercockColour()
  : color_w(NO_COLOR)
	{
		begin = millis();
	}

	/**
	 * Choose randomly a color for the weathercock
	 * The color is selected 25 seconds after the beginnig of the game
	 */
	void decide_zone()
	{
		if((millis() - begin) > 25000 && color_w == NO_COLOR)
			this->color_w = int(random(50))%2 + 1;
	}
};

#endif
