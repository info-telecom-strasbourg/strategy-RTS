#include <Arduino.h>
#include "Task.h"
#include "Strat.h"
#include "Macro.h"

extern Strat strat;

void Task::in_progress()
{
  if(this->done == NOT_DONE)
    strat.time_start_task = millis();

  this->done = IN_PROGRESS;
}

void Task::interrupted()
{
  strat.changeTaskOrder(0, strat.tasks_order.size() - 1);
  strat.tab_tasks[TASK_CALIBRATION].in_progress();
  strat.addTaskOrder(TASK_CALIBRATION);
  strat.changeTaskOrder(strat.tasks_order.size() - 1, 0);
  this->done = NOT_DONE;
}
