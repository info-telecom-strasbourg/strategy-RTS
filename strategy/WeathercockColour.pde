
/**
 * Simulate the behavior of the weathercock
 */
class WeathercockColour
{
	int color_w;
	boolean activate;
	long begin;

	/**
	 * Constructor of Weathercock
	 */
	WeathercockColour()
	{
		color_w = NO_COLOR;
		begin = millis();
	}

	/**
	 * Choose randomly a color for the weathercock
	 * The color is selected 25 seconds after the beginnig of the game
	 */
	void decide_zone()
	{
		if((millis() - begin) > 25000 && color_w == NO_COLOR)
			this.color_w = int(random(50))%2 + 1;
	}

	/**
	 * Display the weathercock with it's current color 
	 * grey if it's not activated, white or black if it is
	 */
	void display()
	{
		decide_zone();
		switch (this.color_w)
		{
			case BLACK:
				fill(0,0,0);
				break;
			case WHITE:
				fill(255,255,255);
				break;
			default:
				fill(127,127,127);
		}
		ellipse(ARENA_HEIGHT/2, 0, 60, 60);
	}
}
