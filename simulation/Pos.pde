class Pos
{
	float x;
	float y;

	Pos(float x, float y)
	{
		this.x = x;
		this.y = y;
	}
	boolean isAround(Pos pos, int distance)
	{
		return abs(this.x - pos.x) < distance && abs(this.y - pos.y) < distance;
	}

	float dist(Pos pos)
	{
		return sqrt(pow(this.x - pos.x, 2) + pow(this.y - pos.y, 2));
	}

	float angle(Pos pos)
	{
		return atan2(pos.y - this.y, pos.x - this.x);
	}

	Pos closer(Pos pos_1, Pos pos_2)
	{
		return (this.dist(pos_1) < this.dist(pos_2)) ? pos_1 : pos_2;
	}
}

Pos get_mid(Pos pos_1, Pos pos_2)
{
	return new Pos((pos_1.x + pos_2.x)/2, (pos_1.y + pos_2.y)/2);
}
