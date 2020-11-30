#ifndef CALIBRATION_H
#define CALIBRATION_H

#include "Task.h"

/**
 * This class represent the task calibration. It allows
 * the robot to reinitialize its position
 */
class Calibration : public Task
{
public:
    /* A checkpoint to help to robot to calibrate in security */
    Pos calibrate_checkpoint;

    /* Indicate if we are calibrating the robot following the axis x*/
    bool x_calibration;

    /* Indicate if we have calibrated the robot following the axis y*/
    bool y_calibrated;

    /**
	 * Constructor of Calibration
     * @param id: task id
     * @param points: points of this task (=0)
     * @param position: task position
     * @param max_time: the max time this task should last
	 */
    Calibration(int id, int points, Pos position, long max_time);

    /**
	 * Calibrate the robot when we have lost our position
	 */
    void do_task(int millis);

    /**
	 * Calibrate the robot following the y axis
	 */
    void y_do_calibration(float calib_y, float calib_secu_y);

    /**
	 * Calibrate the robot following the x axis
	 */
    void x_do_calibration(float calib_x, float calib_secu_y, int millis);
};

#endif
