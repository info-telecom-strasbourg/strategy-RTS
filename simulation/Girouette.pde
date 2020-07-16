class Girouette
{
	int color_g;
	boolean activate;
	int begin;

	Girouette()
	{
		color_g = NO_COLOR;
		begin = second();
	}

	void decide_zone()
	{
		if((second() - begin > 5) && color_g == NO_COLOR)
			color_g = int(random(50))%2 + 1;
	}

	void affiche()
	{
		decide_zone();
		switch (color_g)
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
		ellipse(LONGUEUR_TERRAIN/2, 0, 60, 60);
	}
}
