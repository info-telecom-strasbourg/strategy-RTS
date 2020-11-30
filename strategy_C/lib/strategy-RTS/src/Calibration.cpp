#include "Calibration.h"
#include "Robot.h"
#include "Strat.h"
#include "Macro.h"

extern RTSRob robot_RTS;
extern Strat strat;

Calibration::Calibration(int id, int points, Pos position, long max_time)
: Task(id, points, position, max_time), x_calibration(false), y_calibrated(false)
{
  this->done = DONE;
}

void Calibration::do_task(int millis)
{
    float calib_x = (robot_RTS.position.x < ARENA_HEIGHT/2) ? 0 : ARENA_HEIGHT;
    float calib_y = (robot_RTS.position.y < ARENA_WIDTH/2) ? 0 : ARENA_WIDTH;
    float calib_secu_y = (robot_RTS.position.y < ARENA_WIDTH/2) ? 100 : ARENA_WIDTH - 100;

    if(!y_calibrated)
        y_do_calibration(calib_y, calib_secu_y);
    else
        x_do_calibration(calib_x, calib_secu_y, millis);
}

void Calibration::y_do_calibration(float calib_y, float calib_secu_y)
{
    this->calibrate_checkpoint = Pos(robot_RTS.position.x, calib_y);
    robot_RTS.next_destination = this->calibrate_checkpoint;

    robot_RTS.getCorners();
    if(!robot_RTS.corners[0].on_arena(1) && !robot_RTS.corners[3].on_arena(1))
    {
        this->y_calibrated = true;
        this->calibrate_checkpoint = Pos(robot_RTS.position.x, calib_secu_y);
        robot_RTS.next_destination = this->calibrate_checkpoint;
    }
    strat.best_path(robot_RTS.next_destination);
    robot_RTS.goTo(true);
}

void Calibration::x_do_calibration(float calib_x, float calib_secu_y, int millis)
{
    if(!this->x_calibration)
    {
        if(robot_RTS.position.is_around(this->calibrate_checkpoint, 5))
        {
            x_calibration = true;
            this->calibrate_checkpoint = Pos(calib_x, calib_secu_y);
            robot_RTS.next_destination = this->calibrate_checkpoint;
        }

        strat.best_path(robot_RTS.next_destination);
        if (robot_RTS.haveToBack())
            robot_RTS.goTo(false);
        else
            robot_RTS.goTo(true);
    }
    else
    {
        if(!robot_RTS.corners[0].on_arena(1) && !robot_RTS.corners[3].on_arena(1))
        {
            strat.tab_tasks[TASK_CALIBRATION].over();
            strat.removeTaskOrder(0, millis);
            y_calibrated = false;
            x_calibration = false;
            strat.tab_tasks[TASK_CALIBRATION].position = Pos(-50, -50);
        }
        strat.best_path(robot_RTS.next_destination);
        robot_RTS.goTo(true);
    }
}
