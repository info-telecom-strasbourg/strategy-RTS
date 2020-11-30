#include "Task.h"
#include "Strat.h"
#include "Macro.h"

extern Strat strat;

Task::Task(int id, int points, Pos position, long max_time)
: id(id), points(points), position(position), max_time(max_time)
{
  this->done = DONE;
}

void Task::over() {this->done = DONE;}

void Task::in_progress(int millis)
{
  if(this->done == NOT_DONE)
    strat.time_start_task = millis;

  this->done = IN_PROGRESS;
}

void Task::interrupted(int millis)
{
  strat.changeTaskOrder(0, strat.tasks_order.size() - 1, millis);
  strat.tab_tasks[TASK_CALIBRATION].in_progress(millis);
  strat.addTaskOrder(TASK_CALIBRATION, millis);
  strat.changeTaskOrder(strat.tasks_order.size() - 1, 0, millis);
  this->done = NOT_DONE;
}
