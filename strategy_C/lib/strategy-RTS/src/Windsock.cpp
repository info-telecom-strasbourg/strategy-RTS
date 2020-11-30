#include "Windsock.h"
#include "Robot.h"
#include "Strat.h"
#include "TopLidar.h"
#include "Macro.h"

extern RTSRob robot_RTS;
extern Strat strat;

Windsock::Windsock(int id, int points, Pos position, long max_time, Vector<Pos> windsock_checkpoints)
: Task(id, points, position, max_time), windsock_wait(-1)
{
  this->checkpoints = windsock_checkpoints;
}

bool Windsock::raise_windsock(int millis)
{
    if(windsock_wait == -1)
        windsock_wait = millis;

    return (millis - windsock_wait > 4000);
}

void Windsock::do_task(int millis)
{
  this->in_progress(millis);

  this->checkpoints[0].x = robot_RTS.position.x;
  robot_RTS.next_destination = this->checkpoints[0];

  if(!robot_RTS.position.is_around(robot_RTS.next_destination, 5))
  {
    strat.best_path(robot_RTS.next_destination);
    robot_RTS.goTo(true);
    return;
  }

  if(!raise_windsock(millis))
    return;


  TopLidar lidar(robot_RTS.sensors[TOP_LIDAR]);
  if(lidar.is_detected(this->id))
  {
    this->over();
    strat.removeTaskOrder(0, millis);
    strat.score += this->points;
    if ((this->id == TASK_WINDSOCK_1 && strat.tab_tasks[TASK_WINDSOCK_2].done == DONE)
    || (this->id == TASK_WINDSOCK_2 && strat.tab_tasks[TASK_WINDSOCK_1].done == DONE))
      strat.score += this->points;
  }
  else
  {
    this->windsock_wait = -1;
    this->interrupted(millis);
  }
}