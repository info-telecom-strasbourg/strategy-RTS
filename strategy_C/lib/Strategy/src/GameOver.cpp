#include "GameOver.h"
#include "Robot.h"

extern RTSRob robot_RTS;

void GameOver::do_task()
{
    this->in_progress();
    robot_RTS.speed_regime = STOP;
}
