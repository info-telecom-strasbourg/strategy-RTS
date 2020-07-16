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
		this.next_position = new Pos(100, 150); //our robot's dest
		// robot.position = get_position(); //à coder
		robot.speed_regime = fixed_lidar(opponent); //adaptation of the speed according to the environment
		this.find_the_opponent(opponent); //identify the opponent




		// this.id_current_task = find_best_task(); //à coder

		// nb de points
		// temps (temps de trajet + temps_max de la tache)

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

		robot.goTo(this.next_position); //move
		robot.getCorners();
		robot.borderColision();
		robot.affiche(true);
	}

	void find_the_opponent(Robot opponent)
	{
		this.opponent_positions = new Pos[0];
		Pos[] obstacles = mobile_lidar(this.robot.position, opponent);
		find_opponent_positions(obstacles);
	}

	void find_opponent_positions(Pos[] obstacles)
	{
		if (obstacles.length == 0)
			return;


		for (int i = 0; i < obstacles.length; i++)
		{
			if (!obstacles[i].isAround(POS_LIGHTHOUSE, 50) && !obstacles[i].isAround(POS_LIGHTHOUSE_OP, 50) && !obstacles[i].isAround(POS_WEATHERCOCK, 50))
				this.opponent_positions = (Pos[]) splice(this.opponent_positions, obstacles[i], this.opponent_positions.length);
		}

	}

	Pos[] mobile_lidar(Pos pos, Robot opponent)
	{
		Pos[] tab  = {POS_LIGHTHOUSE, POS_LIGHTHOUSE_OP, POS_WEATHERCOCK, opponent.position};
		return tab;
	}

	void update_time(){this.time = millis();}


	int fixed_lidar(Robot opponent)
	{
		Pos[] robot_op_shape = find_robot_op_shape(opponent);
		for(int i = 0; i < robot_op_shape.length; i++)
			if (capture(robot_op_shape[i]))
				return SLOW;
		for(int i = 0; i < LONGUEUR_TERRAIN; i+=10)
			if (capture(new Pos(i, 0)) || capture(new Pos(i, LARGEUR_TERRAIN)))
				return SLOW;
		for(int i = 0; i < LARGEUR_TERRAIN; i+=10)
			if (capture(new Pos(0, i)) || capture(new Pos(LONGUEUR_TERRAIN, i)))
				return SLOW;
		return FAST;
	}

	boolean capture(Pos pos)
	{
		Pos capteur = new Pos(this.robot.position.x + cos(this.robot.angle) * LARGEUR_ROBOT/2,
							this.robot.position.y + sin(this.robot.angle) * LARGEUR_ROBOT/2);
		float dist = capteur.dist(pos);

		if(dist > 250)
			return false;

		float theta = arcos(capteur, pos);

		float diff_ang = mod2Pi(theta - this.robot.angle);
		if (diff_ang > PI)
			diff_ang = 2*PI - diff_ang;

		if(diff_ang < PI/4)
			return true;
		else
			return false;
	}

	Pos[] find_robot_op_shape(Robot opponent)
	{
		Pos[] shapes = new Pos[8];
		shapes[0] = opponent.corners[0];
		shapes[1] = opponent.corners[1];
		shapes[2] = opponent.corners[2];
		shapes[3] = opponent.corners[3];
		shapes[4] = get_mid(opponent.corners[0], opponent.corners[1]);
		shapes[5] = get_mid(opponent.corners[1], opponent.corners[2]);
		shapes[6] = get_mid(opponent.corners[2], opponent.corners[3]);
		shapes[7] = get_mid(opponent.corners[3], opponent.corners[0]);
		return shapes;
	}

	int find_best_task()
	{
		return 1;
	}
	//Manche à air ou phare en 1er car zone secu et points à la clé
	//girouettes et pavillons à la fin (!!!! arriver au bon endroit !!!!)
}
