class Task
{
	int points;
	Pos position;
	boolean done;
	long max_time;

	Task(int points, Pos position, long max_time)
	{
		this.points = points;
		this.position = position;
		this.done = false;
		this.max_time = max_time;
	}

	void over() {this.done = true;}

	void affiche()
	{
		if(!done)
			fill(255,0,0);
		else
			fill(0,255,0);
		triangle(position.x, position.y + 30, position.x - 30, position.y - 30, position.x + 30, position.y - 30);
	}


}
