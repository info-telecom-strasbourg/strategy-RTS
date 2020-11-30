#include "WeathercockColour.h"
#include "Macro.h"

WeathercockColour::WeathercockColour(int millis)
: color_w(NO_COLOR)
{
  begin = millis;
}

void WeathercockColour::decide_zone(int millis)
{
  if((millis - begin) > 25000 && color_w == NO_COLOR)
    this->color_w = 1;
}
