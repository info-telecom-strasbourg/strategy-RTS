#include "ManageOpponent.h"

void ManageOpponent::find_the_opponent()
{
  Vector<Pos> obstacles;
  Vector<Pos> mob_lid_detectable;
  for(unsigned int i = 0; i < rob_opponents.size(); i++)
    mob_lid_detectable.push_back(rob_opponents[i].position);

  mob_lid_detectable.push_back(POS_LIGHTHOUSE);
  mob_lid_detectable.push_back(POS_LIGHTHOUSE_OP);
  mob_lid_detectable.push_back(POS_WEATHERCOCK);

  obstacles = this->robot.sensors[MOBILE_LIDAR].detection(mob_lid_detectable);

  if (obstacles.size() == 0)
    return;

  for (unsigned int i = 0; i < obstacles.size(); i++)
    if (!obstacles[i].is_around(POS_LIGHTHOUSE, 5) &&
    !obstacles[i].is_around(POS_LIGHTHOUSE_OP, 5) &&
    !obstacles[i].is_around(POS_WEATHERCOCK, 5))
      this->opponent_positions.push_back(obstacles[i]);
}

void ManageOpponent::find_path(float secu_dist)
{
  this->path.clear();
  Pos intersection;
  intersection = access(this->robot.position, objective_position, secu_dist);
  if(intersection != POS_NULL)
  {
    Pos checkpoint;
    checkpoint = this->find_step(intersection, secu_dist);
    if(checkpoint != POS_NULL)
    {
      this->path.push_back(checkpoint);
      this->path.push_back(objective_position);
    }
    else
      this->robot.speed_regime = STOP;
  }
  else
    this->path.push_back(objective_position);
}

Pos ManageOpponent::access (Pos point_1, Pos point_2, float secu_dist)
{
  float nb_seg = 100;
  float delta_x = point_2.x - point_1.x;
  float delta_y = point_2.y - point_1.y;

  for (float i = 0; i < nb_seg; i++)
  {
    Pos new_pos(point_1.x + i*delta_x/nb_seg, point_1.y + i*delta_y/nb_seg);
    for (unsigned int j = 0; j < this->opponent_positions.size(); j++)
      if (is_on_security_area(new_pos, this->opponent_positions[j], secu_dist))
        return new_pos;
  }
  return POS_NULL;
}

bool ManageOpponent::is_on_security_area(Pos current_pos, Pos opponent_pos, float secu_dist)
{
  if(current_pos.dist(opponent_pos) < 150)
    return true;
  if(current_pos.dist(opponent_pos) > secu_dist)
    return false;

  return (current_pos.angle(opponent_pos) < M_PI) ? true : false;
}

Pos ManageOpponent::find_step(Pos intersection, float secu_dist)
{
  float angle_step = M_PI/12;
  float angle_dep = this->robot.position.angle(this->robot.next_destination);
  if(angle_step != 0)
    for(float i = angle_dep; i < angle_dep + M_PI/2; i += angle_step)
    {
      float angle_to_check = mod2Pi(i);

      Pos checkpoint;
      checkpoint = find_checkpoint(angle_to_check, secu_dist);
      if(checkpoint != POS_NULL)
        return checkpoint;

      checkpoint = find_checkpoint(mod2Pi(2*angle_dep - angle_to_check), secu_dist);
      if(checkpoint != POS_NULL)
        return checkpoint;

      angle_to_check = mod2Pi(i + M_PI);

      checkpoint = find_checkpoint(angle_to_check, secu_dist);
      if(checkpoint != POS_NULL)
        return checkpoint;

      checkpoint = find_checkpoint(mod2Pi(2*angle_dep - angle_to_check), secu_dist);
      if(checkpoint != POS_NULL)
        return checkpoint;
    }
  return POS_NULL;
}

Pos ManageOpponent::find_checkpoint(float angle, float secu_dist)
{
  float step = 10;
  Pos checkpoint(this->robot.position);

  while (checkpoint.on_arena(100))
  {
    checkpoint.x += step*cos(angle);
    checkpoint.y += step*sin(angle);

    if(access(this->robot.position, checkpoint, secu_dist) == POS_NULL
      && access(checkpoint, objective_position, secu_dist) == POS_NULL)
        return checkpoint;
  }
  return POS_NULL;
}

void ManageOpponent::check_path(float secu_dist)
{
  if (!this->objective_position.is_around(this->path[path.size() - 1], 5)
    || access(this->robot.position, this->path[0], secu_dist) != POS_NULL)
    {
      this->path.clear();
      find_path(secu_dist);
    }
}

void ManageOpponent::best_path(Pos objectiv_pos)
{
  this->objective_position = objectiv_pos;
if (this->path.empty())
  find_path(300);
else
  check_path(200);
}
