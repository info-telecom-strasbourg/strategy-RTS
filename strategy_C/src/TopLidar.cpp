#include "TopLidar.h"
#include "Robot.h"
#include "Macro.h"

extern RTSRob robot_RTS;

bool TopLidar::capture(Pos pos)
{
  Pos sensor(robot_RTS.position.x + cos(robot_RTS.angle) * ROBOT_WIDTH/2,
            robot_RTS.position.y + sin(robot_RTS.angle) * ROBOT_WIDTH/2);

  if(sensor.dist(pos) > 250)
    return false;

  float delt_ang = mod2Pi(sensor.angle(pos) - robot_RTS.angle);
  delt_ang = (delt_ang < M_PI) ? delt_ang : 2*M_PI - delt_ang;

  return (delt_ang < M_PI/12);
}

bool TopLidar::is_detected(int id)
{
  return ((99 * random() + 1) > 90) ? false : true;
}
