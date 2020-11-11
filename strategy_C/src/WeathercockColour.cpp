#include "WeathercockColour.h"

extern const int NO_COLOR;

void WeathercockColour::decide_zone()
{
  if((millis() - begin) > 25000 && color_w == NO_COLOR)
    this->color_w = int(random(50))%2 + 1;
}