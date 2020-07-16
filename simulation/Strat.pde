class Strat
{
	Robot robot;
	int id_current_task;
	Pos[] opponent_positions;
	int color_weathercock;
	long time;
	Pos[] path;
	Task[] tasks;
	int score;
	Pos next_position;

	Strat(Robot robot, Task[] tasks)
	{
		this.robot = robot;
		this.id_current_task = -1;
		this.opponent_positions = null;
		this.color_weathercock = NO_COLOR;
		this.time = millis();
		this.path = null;
		this.tasks = tasks;
		this.score = 0;
		this.next_position = null;
	}

	void apply(Robot opponent)
	{
		this.next_position = new Pos(LONGUEUR_TERRAIN, LARGEUR_TERRAIN/2);
		robot.speed_regime = FAST;
		robot.goTo(this.next_position);
		robot.getCorners();
		robot.borderColision();
		robot.affiche(true);

		// robot.position = get_position(); //à coder
//
		robot.speed_regime = fixed_lidar(opponent);
		// this.find_the_opponent(opponent);
		// this.id_current_task = find_best_task(); //à coder
		// if(robot.position.isAround(this.tasks[this.id_current_task].position, 50))
		// {
		// 	do_task(this.id_current_task); //à coder
		// 	this.path = null;
		// }
		// else
		// {
		// 	if (this.path == null)
		// 		this.path = find_path(); //à coder
		// 	else
		// 		this.path = checkPath(); //à coder
		//
		// 	robot.next_position = this.path[0];
		// 	if (robot.position.isAround(this.path[0]))
		// 		this.path[0].erase(); //trouver une alternative
		// 	move(robot.speed_regime, this.next_position); //à coder
		// }
	}

	void find_the_opponent(Robot opponent)
	{
		opponent_positions = null;
		Pos[] obstacles = mobile_lidar(this.robot.position, opponent);
		opponent_positions = find_opponent_positions(obstacles);
	}

	Pos[] find_opponent_positions(Pos[] obstacles)
	{
		if (obstacles.length == 0)
			return opponent_positions;

		for (int i=0; i < obstacles.length; i++)
		{
			if (!obstacles[i].isAround(POS_LIGHTHOUSE, 50) && !obstacles[i].isAround(POS_LIGHTHOUSE_OP, 50) && !obstacles[i].isAround(POS_WEATHERCOCK, 50))
				opponent_positions[opponent_positions.length] = obstacles[i];
		}

		return opponent_positions;
	}

	Pos[] mobile_lidar(Pos pos, Robot opponent)
	{
		Pos[] tab  = {POS_LIGHTHOUSE, POS_LIGHTHOUSE_OP, POS_WEATHERCOCK, opponent.position};
		return tab;
	}

	void update_time(){this.time = millis();}


	int fixed_lidar(Robot opponent)
	{
		// for(int i = 0; i < this.tasks.length; i++)
		// 	if (capture(this.tasks[i].position))
		// 		return SLOW;
		if (capture(opponent.position))
			return STOP;
		// for(int i = 0; i < LONGUEUR_TERRAIN; i+=10)
		// 	if (capture(new Pos(i, 0)) || capture(new Pos(i, LARGEUR_TERRAIN)))
		// 		return STOP;
		// for(int i = 0; i < LARGEUR_TERRAIN; i+=10)
		// 	if (capture(new Pos(0, i)) || capture(new Pos(LONGUEUR_TERRAIN, i)))
		// 		return STOP;
		return FAST;
	}

	boolean capture(Pos pos)
	{
		Pos capteur = new Pos(this.robot.position.x + cos(this.robot.angle) * LARGEUR_ROBOT/2,
							this.robot.position.y + sin(this.robot.angle) * LARGEUR_ROBOT/2);
		float dist = capteur.dist(pos);

		if (dist > 250)
			return false;

		println("----");
		float theta = arcos(capteur, pos);
		println(theta);
		println(this.robot.angle);
		if (mod2Pi(abs(theta - this.robot.angle)) < PI/4)
		{
			println("OOOOOOOOOOOOOOOOOOOOOOOOKk");
			return true;
		}
		else
			return false;
	}
}
