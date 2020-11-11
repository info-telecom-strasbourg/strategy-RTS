#include "Pos.h"

float mod2Pi(float angle)
{
	while ((angle < 0) || (angle >= 2 * M_PI))
		if (angle < 0)
			angle += 2 * M_PI;
		else
			angle -= 2 * M_PI;

	return angle;
}
