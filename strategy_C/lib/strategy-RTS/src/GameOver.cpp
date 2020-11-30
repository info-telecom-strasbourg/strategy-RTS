#include "GameOver.h"
#include "Robot.h"

extern RTSRob robot_RTS;

void GameOver::do_task(int millis)
{
    this->in_progress(millis);
    robot_RTS.speed_regime = STOP;
}
