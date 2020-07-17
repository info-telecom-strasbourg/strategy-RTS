class Task
{
	int points;
	Pos position;
	int done;
	long max_time;

	Task(int points, Pos position, long max_time)
	{
		this.points = points;
		this.position = position;
		this.done = NOT_DONE;
		this.max_time = max_time;
	}

	

	void over() {done = DONE;}

	void in_progress() {done = IN_PROGRESS;}

	void affiche()
	{
		switch (done) 
		{
			case NOT_DONE:
				fill(255,0,0);
				break;
			case IN_PROGRESS:
				fill(255,165,0);
				break;
			case DONE:
				fill(0,255,0);
				break;
			default :
				fill(0,0,0);
		}
			
		triangle(position.x, position.y + 30, position.x - 30, position.y - 30, position.x + 30, position.y - 30);
	}
}
