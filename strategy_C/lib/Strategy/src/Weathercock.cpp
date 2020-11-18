#include <Arduino.h>
#include <stdio.h>
#include "Weathercock.h"
#include "Strat.h"
#include "Robot.h"
#include "WeathercockColour.h"
#include "TopLidar.h"
#include "Macro.h"

extern Strat strat;
extern RTSRob robot_RTS;
extern WeathercockColour weathercock;




void Weathercock::detect_weathercock_col()
{
  robot_RTS.detected_color = weathercock.color_w;
  if (robot_RTS.detected_color == BLACK)
      strat.tab_tasks[TASK_MOORING_AREA].position.y = 200;
  else if (robot_RTS.detected_color == WHITE)
      strat.tab_tasks[TASK_MOORING_AREA].position.y = 650;
  else
      printf("No color found\n");
}

void Weathercock::do_task()
{
  this->in_progress();
  this->checkpoints[0].y = robot_RTS.position.y;
  robot_RTS.next_destination = this->checkpoints[0];

  if (robot_RTS.position.is_around(this->checkpoints[0], 5))
  {
    this->checkpoints[0].y = 50;
    robot_RTS.next_destination = this->checkpoints[0];
  }

  if (robot_RTS.position.is_around(this->checkpoints[0], 5))
  {
    if(mod2Pi(3*M_PI/2 - robot_RTS.angle) < rot_step)
    {
      if(this->weathercock_wait == -1)
        this->weathercock_wait = millis();

      if((millis() - this->weathercock_wait) > 2000)
      {
        if(((TopLidar)robot_RTS.sensors[TOP_LIDAR]).is_detected(this->id))
        {
          this->detect_weathercock_col();
          this->over();
          strat.removeTaskOrder(0);
        }
        else
          this->interrupted();
      }
    }
    else
      robot_RTS.goToAngle(3*M_PI/2);
  }
  strat.best_path(robot_RTS.next_destination);
  robot_RTS.goTo(true);
}
