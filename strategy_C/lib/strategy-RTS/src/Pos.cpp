#include "Pos.h"
#include "Macro.h"
#include "Dir.h"

extern Dir dir;

float mod2Pi(float angle)
{
	while ((angle < 0) || (angle >= 2 * M_PI))
		if (angle < 0)
			angle += 2 * M_PI;
		else
			angle -= 2 * M_PI;

	return angle;
}

Pos::Pos(float x, float y)
{
	this->x = x;
	this->y = y;
}

Pos::Pos(Pos &pos)
{
	this->x = pos.x;
	this->y = pos.y;
}

bool Pos::is_around(Pos pos, int distance)
{
	return abs(this->x - pos.x) < distance && abs(this->y - pos.y) < distance;
}

bool Pos::is(Pos pos)
{
	return this->x == pos.x && this->y == pos.y;
}

float Pos::dist(Pos pos)
{
	return sqrt(pow(this->x - pos.x, 2) + pow(this->y - pos.y, 2));
}

float Pos::angle(Pos pos)
{
	return mod2Pi(atan2(pos.y - this->y, pos.x - this->x));
}

int Pos::closer(Vector<Pos> tab_pos)
{
	int closest = 0;
	float dist_ = dist(tab_pos[0]);

	for(unsigned int i = 1; i < tab_pos.size(); i++)
	{
		float dist_pos = dist(tab_pos[i]);
		if(dist_pos < dist_)
		{
			dist_ = dist_pos;
			closest = i;
		}
	}
	return closest;
}

bool Pos::on_arena(int gap)
{
	int gap_port = 100;
	int port_x = (dir == left) ? ARENA_HEIGHT - 200 : 200;
	bool on_port = (dir == left) ? this->x > port_x - gap : this->x < port_x - gap;

	return ((this->x > gap) && (this->x < ARENA_HEIGHT - gap) && (this->y > gap) && (this->y < ARENA_WIDTH - gap)
	& !(on_port && this->y > 250 - gap && this->y < 550 + gap));
}

Pos* Pos::get_mid(Pos pos)
{
	return new Pos((this->x + pos.x)/2, (this->y + pos.y)/2);
}
