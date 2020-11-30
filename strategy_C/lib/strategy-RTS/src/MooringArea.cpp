#include "MooringArea.h"
#include "Strat.h"
#include "Robot.h"
#include "Macro.h"

extern Pos POS_MOORING_AREA;
extern RTSRob robot_RTS;
extern Strat strat;

MooringArea::MooringArea(int id, int points, Pos position, long max_time)
: Task(id, points, position, max_time)
{}

void MooringArea::do_task(int millis)
{
  if (millis - strat.time > 99500)
  {
    this->over();
    strat.tab_tasks[GAME_OVER].position = robot_RTS.position;
    strat.tab_tasks[GAME_OVER].in_progress(millis);
    strat.emptyTaskOrder(millis);
    strat.addTaskOrder(GAME_OVER, millis);
  }

  if(this->done == DONE)
    return;

  if(this->done != IN_PROGRESS)
  {
    Pos weth_1(POS_MOORING_AREA.x, 200);
    Pos weth_2(POS_MOORING_AREA.x, 650);
    if (robot_RTS.position.is_around(weth_1, 5) || robot_RTS.position.is_around(weth_2, 5))
    {
      if (strat.tab_tasks[TASK_WEATHERCOCK].done == DONE)
        strat.score += 10;
      else
        strat.score += 5;
      this->over();
      return;
    }
  }
  this->in_progress(millis);
}
