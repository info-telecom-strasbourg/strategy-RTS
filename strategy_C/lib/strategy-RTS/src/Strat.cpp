#include "Strat.h"
#include "BottomLidar.h"
#include "Macro.h"

extern Pos POS_MOORING_AREA;
extern Pos POS_NULL;

int TAB_MAX_TASKS_ORDER[8];
Task TAB_MAX_TASKS[7];

Strat::Strat(RTSRob robot, int millis)
: ManageOpponent(robot), id_current_task(-1), time(millis), time_start_task(millis), score(7), weathercock_insterted(false)
{
	tasks_order = TAB_MAX_TASKS_ORDER;
	tab_tasks = TAB_MAX_TASKS;
}

void Strat::apply(int millis)
{
	this->robot.speed_regime = ((BottomLidar)this->robot.sensors[BOTTOM_LIDAR]).manage_speed();
	find_the_opponent(); //identify the opponent
	this->id_current_task = find_best_task(millis); //choose the task we have to do now

	if(manage_last_tasks(millis))
		this->id_current_task = this->tasks_order[0];

	if(this->robot.position.is_around(this->tab_tasks[this->id_current_task].position, 5)
	|| this->tab_tasks[this->id_current_task].done == IN_PROGRESS)
	{
		this->tab_tasks[this->id_current_task].do_task(millis);
		if (!this->path.empty())
			this->path.clear();
	}
	else
	{
		best_path(this->robot.next_destination);
		if (!this->path.empty() && this->robot.position.is_around(this->path[0], 5))
			this->path.remove(0);
		if (!this->path.empty())
		{
			this->robot.next_destination = this->path[0];
			this->robot.getCorners();
			if (!this->robot.haveToBack())
				this->robot.goTo(true);
		}
		if (this->robot.haveToBack())
			this->robot.goTo(false);
	}
}

void Strat::select_mooring_area()
{
	Pos pos_x(POS_MOORING_AREA.x, 200);
	Pos pos_y(POS_MOORING_AREA.x, 650);
	Pos tab_points_for_closer[2];
	Vector<Pos> points_for_closer(tab_points_for_closer);
	points_for_closer.push_back(pos_x);
	points_for_closer.push_back(pos_y);
	int index_closer = this->robot.position.closer(points_for_closer);
	tab_tasks[TASK_MOORING_AREA].position = points_for_closer[index_closer];

	if(access(this->robot.position, tab_tasks[TASK_MOORING_AREA].position, 280) != POS_NULL
	&& access(this->robot.position, points_for_closer[(index_closer+1)%2], 280) == POS_NULL)
		tab_tasks[TASK_MOORING_AREA].position = points_for_closer[(index_closer+1)%2];
}

int Strat::find_best_task(int millis)
{
  if (this->id_current_task == TASK_MOORING_AREA && this->robot.detected_color == NO_COLOR)
    select_mooring_area();

  long time_left = 100000 - millis - time;

  if (time_left < 4500 && !this->robot.flag_deployed)
  {
    this->score += 10;
    this->robot.flag_deployed = true;
  }


  if (!this->weathercock_insterted && time_left < 75000)
  {
    this->tasks_order.push_back(TASK_WEATHERCOCK);
    this->weathercock_insterted = true;
  }

  if((!this->tasks_order.empty()))
  {
    if (((this->tab_tasks[this->tasks_order[0]].done == NOT_DONE && (millis - this->time_start_task) > 10000)
    || (this->tab_tasks[this->tasks_order[0]].done == IN_PROGRESS) && (millis - this->time_start_task) > this->tab_tasks[this->tasks_order[0]].max_time))
    {
      this->tab_tasks[this->tasks_order[0]].done = NOT_DONE;
      changeTaskOrder(0, this->tasks_order.size() - 1, millis);
      for (unsigned int i = 0; i < this->tasks_order.size(); i++)
        if(access(this->robot.position, this->tab_tasks[this->tasks_order[i]].position, 280) == POS_NULL)
        {
          changeTaskOrder(i, 0, millis);
          break;
        }
    }

    if (this->tab_tasks[this->tasks_order[0]].done == NOT_DONE)
      this->robot.next_destination = this->tab_tasks[this->tasks_order[0]].position;

    return this->tasks_order[0];
  }
  else
    return NO_TASK;
}

bool Strat::manage_last_tasks(int millis)
{
	long time_left = 100000 - millis - time;
	if ((this->robot.flag_deployed) && (time_left < 500 || this->tasks_order.empty()))
	{
		tab_tasks[GAME_OVER].position = this->robot.position;
		this->emptyTaskOrder(millis);
		this->addTaskOrder(GAME_OVER, millis);
		return true;
	}
	if ((final_move_with_color(time_left) || final_move_without_color(time_left) || (this->tasks_order.empty())) && this->tab_tasks[TASK_MOORING_AREA].done != DONE)
	{
		this->emptyTaskOrder(millis);
		Pos pos_mooring_1(POS_MOORING_AREA.x, 200);
		Pos pos_mooring_2(POS_MOORING_AREA.x, 650);
		if(access(this->robot.position, this->tab_tasks[TASK_MOORING_AREA].position, 280) != POS_NULL
		&& (time_left - 10000 < this->robot.position.dist(pos_mooring_1)/SLOW || time_left - 10000 < this->robot.position.dist(pos_mooring_2)/SLOW))
			select_mooring_area();
		this->addTaskOrder(TASK_MOORING_AREA, millis);
		return true;
	}
	return false;
}

bool Strat::final_move_with_color(long time_left)
{
	return (tab_tasks[TASK_WEATHERCOCK].done == DONE
	        && is_final_move(tab_tasks[TASK_MOORING_AREA].position, time_left));
}


bool Strat::final_move_without_color(long time_left)
{
  Pos pos200(POS_MOORING_AREA.x, 200);
  Pos pos650(POS_MOORING_AREA.x, 650);
  return ((is_final_move(pos200, time_left)
    || is_final_move(pos650, time_left))
    && tab_tasks[TASK_MOORING_AREA].done != DONE);
}

bool Strat::is_final_move (Pos pos, long time_left)
{
	return time_left < (10000 + pos.dist(robot.position)/SLOW);
}


void Strat::changeTaskOrder(int index_start, int index_end, int millis)
{
	this->time_start_task = millis;
	if (index_start == index_end || index_start >= this->tasks_order.size() || index_end >= this->tasks_order.size()
	 || index_start < 0 || index_end < 0)
		return;

	int tab_tasks_order_temp[7];
	Vector <int> tasks_order_temp(tab_tasks_order_temp);

	if (index_start > index_end)
	{
		for(int i = 0; i < index_end; i++)
			tasks_order_temp.push_back(this->tasks_order[i]);
		tasks_order_temp.push_back(this->tasks_order[index_start]);
		for(int i = index_end; i < this->tasks_order.size(); i++)
			if(i != index_start)
				tasks_order_temp.push_back(this->tasks_order[i]);
	}
	else
	{
		for(int i = 0; i <= index_end; i++)
			if(i != index_start)
				tasks_order_temp.push_back(this->tasks_order[i]);
		tasks_order_temp.push_back(this->tasks_order[index_start]);
		for(unsigned int i = index_end + 1; i < this->tasks_order.size(); i++)
			tasks_order_temp.push_back(this->tasks_order[i]);
	}
	this->tasks_order = tasks_order_temp;
}

void Strat::emptyTaskOrder(int millis)
{
  this->time_start_task = millis;
  this->tasks_order.clear();
}

void Strat::addTaskOrder(int id, int millis)
{
  this->time_start_task = millis;
  this->tasks_order.push_back(id);
}

void Strat::removeTaskOrder(int index, int millis)
{
  this->time_start_task = millis;
  this->tasks_order.remove(index);
}
