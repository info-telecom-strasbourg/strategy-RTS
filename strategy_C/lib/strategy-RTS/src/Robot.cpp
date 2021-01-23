#include "Robot.h"
#include "BottomLidar.h"
#include "Macro.h"

Robot::Robot(Pos pos_ini, float angle)
: position(pos_ini), angle(angle), speed_regime(STOP)
{
  for (int i = 0; i < 4; ++i)
  {
    float angle_corner = this->angle + M_PI/4 + i*M_PI/2;
    this->corners[i] = Pos(
                  pos_ini.x + HALF_DIAG * cos(angle_corner),
                  pos_ini.y + HALF_DIAG * sin(angle_corner)
                 );
  }
}

Robot::Robot(Pos pos, float angle, Sensor sensors[3])
: position(pos),	angle(angle), speed_regime(STOP)
{
  for (int i = 0; i < 4; ++i)
  {
    float angle_corner = this->angle + M_PI/4 + i*M_PI/2;
    this->corners[i] = Pos(
                  pos.x + HALF_DIAG * cos(angle_corner),
                  pos.y + HALF_DIAG * sin(angle_corner)
                 );
  }
  for (int i = 0; i < 3; i++)
  {
      this->sensors[i] = sensors[i];
  }
}

void Robot::goTo(bool forward)
{
  float turn = (forward) ? 0 : M_PI;

  if (this->position.is_around(this->next_destination, 5))
    return;

  if (forward)
  {
    float dist = this->position.dist(this->next_destination);
    float theta = this->position.angle(this->next_destination);

    if (mod2Pi(theta + turn - this->angle) > rot_step && !this->position.is_around(this->next_destination, 5))
    {
      goToAngle(theta + turn);
      return;
    }
  }

  if(this->speed_regime != STOP)
  {
    // if(this->sensors.size() != 0)
    // {
      BottomLidar lidar(this->sensors[BOTTOM_LIDAR]);
      this->speed_regime = lidar.manage_speed();
    // }
    // else
    //   this->speed_regime = FAST;
  }

  this->position.x += this->speed_regime * cos(this->angle + turn);
  this->position.y += this->speed_regime * sin(this->angle + turn);
}

void Robot::goToAngle(float theta)
{
  theta = mod2Pi(theta);
  float delta_angle = theta - this->angle;

  if (abs(delta_angle) < rot_step)
    this->angle = theta;
  else
    if ((delta_angle > 0 && delta_angle < M_PI) || (delta_angle < 0 && delta_angle < - M_PI))
      this->angle = mod2Pi(this->angle + rot_step);
    else
      this->angle = mod2Pi(this->angle - rot_step);
}

bool Robot::haveToBack()
{
  this->getCorners();

  if(!this->corners[0].on_arena(10) || !this->corners[3].on_arena(10))
    return true;

  return false;
}

void Robot::getCorners()
{
  for (int i = 0; i < 4; ++i)
  {
    this->corners[i].x = this->position.x + HALF_DIAG * cos(this->angle + M_PI/4 + i*M_PI/2);
    this->corners[i].y = this->position.y + HALF_DIAG * sin(this->angle + M_PI/4 + i*M_PI/2);
  }
}

void Robot::borderColision()
{
  if ((corners[1].x < 0) && corners[2].x < 0)
  {
    this->angle = 0;
    this->position.x = ROBOT_HEIGHT/2; // la longeur étant la distance de l'avant à l'arrière du robot
    getCorners();
  }
  else if ((corners[1].x > ARENA_HEIGHT - 1) && (corners[2].x > ARENA_HEIGHT - 1))
  {
    this->angle = M_PI;
    this->position.x = ARENA_HEIGHT - 1 - ROBOT_HEIGHT/2;
    getCorners();
  }
  if ((corners[1].y < 0) && (corners[2].y < 0))
  {
    this->angle = M_PI/2;
    this->position.y = ROBOT_HEIGHT/2;
    getCorners();
  }
  else if ((corners[1].y > ARENA_WIDTH - 1) && (corners[2].y > ARENA_WIDTH - 1))
  {
    this->angle = 3 * M_PI/2;
    this->position.y = ARENA_WIDTH - 1 - ROBOT_HEIGHT/2;
    getCorners();
  }

  if ((corners[0].x < 0) && corners[3].x < 0)
  {
    this->angle = M_PI;
    this->position.x = ROBOT_HEIGHT/2; // la longeur étant la distance de l'avant à l'arrière du robot
    getCorners();
  }
  else if ((corners[0].x > ARENA_HEIGHT - 1) && (corners[3].x > ARENA_HEIGHT - 1))
  {
    this->angle = 0;
    this->position.x = ARENA_HEIGHT - 1 - ROBOT_HEIGHT/2;
    getCorners();
  }
  if ((corners[0].y < 0) && (corners[3].y < 0))
  {
    this->angle = 3 * M_PI/2;
    this->position.y = ROBOT_HEIGHT/2;
    getCorners();
  }
  else if ((corners[0].y > ARENA_WIDTH - 1) && (corners[3].y > ARENA_WIDTH - 1))
  {
    this->angle = M_PI/2;
    this->position.y = ARENA_WIDTH - 1 - ROBOT_HEIGHT/2;
    getCorners();
  }

  for(int i = 0; i < 4; i++)
  {
    float delt_ang;
    if (corners[i].x < 0)
    {
      delt_ang = acos(this->position.x/sqrt(pow(this->position.y - corners[i].y,2) + pow(this->position.x - corners[i].x,2))) - atan(abs((this->position.y - corners[i].y)/(this->position.x - corners[i].x)));
      if (corners[i].y < this->position.y)
        this->angle += delt_ang;
      else if(corners[i].y > this->position.y)
        this->angle -= delt_ang;
      else
        this->position.x -= corners[i].x;
      getCorners();
    }
    else if (corners[i].x > ARENA_HEIGHT - 1)
    {
      delt_ang = acos((ARENA_HEIGHT - 1 - this->position.x)/sqrt(pow(this->position.y - corners[i].y,2) + pow(this->position.x - corners[i].x,2))) - atan(abs((this->position.y - corners[i].y)/(this->position.x - corners[i].x)));
      if (corners[i].y < this->position.y)
        this->angle -= delt_ang;
      else if(corners[i].y > this->position.y)
        this->angle += delt_ang;
      else
        this->position.x -= corners[i].x - ARENA_HEIGHT + 1;
      getCorners();
    }
    if (corners[i].y < 0)
    {
      delt_ang = acos(this->position.y/sqrt(pow(this->position.y - corners[i].y,2) + pow(this->position.x - corners[i].x,2))) - atan(abs((this->position.x - corners[i].x)/(this->position.y - corners[i].y)));
      if (corners[i].x < this->position.x)
        this->angle -= delt_ang;
      else if(corners[i].x > this->position.x)
        this->angle += delt_ang;
      else
        this->position.y -= corners[i].y;
      getCorners();
    }
    else if (corners[i].y > ARENA_WIDTH - 1)
    {
      delt_ang = acos((ARENA_WIDTH - 1 - this->position.y)/sqrt(pow(this->position.y - corners[i].y,2) + pow(this->position.x - corners[i].x,2))) - atan(abs((this->position.x - corners[i].x)/(this->position.y - corners[i].y)));
      if (corners[i].x < this->position.x)
        this->angle += delt_ang;
      else if(corners[i].x > this->position.x)
        this->angle -= delt_ang;
      else
        this->position.y -= corners[i].y - ARENA_WIDTH + 1;
      getCorners();
    }
  }
}
