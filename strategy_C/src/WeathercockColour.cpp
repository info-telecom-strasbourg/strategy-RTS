#include "WeathercockColour.h"
#include "Macro.h"

WeathercockColour::WeathercockColour()
: color_w(NO_COLOR)
{
  begin = millis();
}

void WeathercockColour::decide_zone()
{
  if((millis() - begin) > 25000 && color_w == NO_COLOR)
    this->color_w = int(random(50))%2 + 1;
}
