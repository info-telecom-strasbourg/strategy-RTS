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
}
