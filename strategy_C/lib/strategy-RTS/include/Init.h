#include "Vector.h"
#include "Sensor.h"

/**
 * Initialise sensors
 * @return an Vector of sensors
 */
void init_sensors(Sensor sensors[3]);
/**
 * Initialize robot parameters and tasks position according to the start position
 * @param dir: the start position (left or right)
 */
void init_robots();

/**
 * Initialize the tasks
 */
void init_tasks();
