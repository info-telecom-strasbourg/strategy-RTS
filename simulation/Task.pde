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


}
