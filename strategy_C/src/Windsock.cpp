#include "Windsock.h"
#include "Robot.h"
#include "Strat.h"
#include "TopLidar.h"

extern RTSRob robot_RTS;
extern Strat strat;

bool Windsock::raise_windsock()
{
    if(windsock_wait == -1)
        windsock_wait = millis();

    return (millis() - windsock_wait > 4000);
}

void Windsock::do_task()
{
  this->in_progress();

  this->checkpoints[0].x = robot_RTS.position.x;
  robot_RTS.next_destination = this->checkpoints[0];

  if(!robot_RTS.position.is_around(robot_RTS.next_destination, 5))
  {
    strat.best_path(robot_RTS.next_destination);
    robot_RTS.goTo(true);
    return;
  }

  if(!raise_windsock())
    return;


  TopLidar lidar(robot_RTS.sensors[TOP_LIDAR]);
  if(lidar.is_detected(this->id))
  {
    this->over();
    strat.removeTaskOrder(0);
    strat.score += this->points;
    if ((this->id == TASK_WINDSOCK_1 && strat.tab_tasks[TASK_WINDSOCK_2].done == DONE)
    || (this->id == TASK_WINDSOCK_2 && strat.tab_tasks[TASK_WINDSOCK_1].done == DONE))
      strat.score += this->points;
  }
  else
  {
    this->windsock_wait = -1;
    this->interrupted();
  }
}
