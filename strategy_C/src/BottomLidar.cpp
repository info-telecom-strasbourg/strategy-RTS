#include "BottomLidar.h"

Vector<Pos> BottomLidar::detection(Vector<Pos> detectables)
{

    Vector<Pos>* obstacles = new Vector<Pos>();

    for (unsigned int i = 0; i < detectables.size(); i++)
        if(capture(detectables[i]))
            obstacles->push_back(detectables[i]);

    for(int i = 0; i < ARENA_HEIGHT; i+=10)
    {
        Pos left_border (i,0);
        Pos right_border (i, ARENA_WIDTH);

        if(capture(left_border))
            obstacles->push_back(left_border);
        if(capture(right_border))
            obstacles->push_back(right_border);
    }

    for(int i = 0; i < ARENA_WIDTH; i+=10)
    {
        Pos up_border (0,i);
        Pos down_border (ARENA_HEIGHT,i);

        if(capture(up_border))
            obstacles->push_back(up_border);
        if(capture(down_border))
            obstacles->push_back(down_border);
    }

    return *obstacles;
}

bool BottomLidar::capture(Pos pos)
{
  Pos sensor(robot_RTS.position.x + cos(robot_RTS.angle) * ROBOT_WIDTH/2,
            robot_RTS.position.y + sin(robot_RTS.angle) * ROBOT_WIDTH/2);

  if(sensor.dist(pos) > 250)
    return false;

  float delt_ang = mod2Pi(sensor.angle(pos) - robot_RTS.angle);
  delt_ang = (delt_ang < M_PI) ? delt_ang : 2*M_PI - delt_ang;

  return (delt_ang < M_PI/4);
}

int BottomLidar::manage_speed()
{
    Vector<Pos> oppon_pos;
    for(unsigned int i = 0; i < rob_opponents.size(); i++)
        oppon_pos.push_back(rob_opponents[i].position);

    return (detection(oppon_pos).empty()) ? FAST : SLOW;
}
