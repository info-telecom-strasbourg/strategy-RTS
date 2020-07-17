class Strat
{
	Robot robot;
	int id_current_task;
	Pos[] opponent_positions;
	int color_weathercock;
	int time;
	Pos[] path;
	int score;

	//Simulation
	int lighthouse_wait = -1;

	Strat(Robot robot)
	{
		this.robot = robot;
		this.id_current_task = -1;
		this.opponent_positions = null;
		this.color_weathercock = NO_COLOR;
		this.time = millis();
		this.path = null;
		this.score = 0;
	}

	void apply(Robot opponent)
	{
		// robot.position = get_position(); //à coder
		robot.speed_regime = fixed_lidar(opponent); //adaptation of the speed according to the environment
		this.find_the_opponent(opponent); //identify the opponent
		this.id_current_task = find_best_task(); //choose the task we have to do now
		if (this.id_current_task == TASK_FLAG && this.color_weathercock == NO_COLOR)
			tab_tasks[TASK_FLAG].position = this.robot.position.closer(new Pos(POS_FLAG.x, 150), new Pos(POS_FLAG.x, 850));
		this.robot.next_position = tab_tasks[this.id_current_task].position; //our robot's dest

		println("Y : ",this.robot.position.y);
		if(robot.position.isAround(tab_tasks[this.id_current_task].position, 50) || tab_tasks[this.id_current_task].done == IN_PROGRESS)
		{
			do_task();
			this.path = null;
		}
		else
		{
			// if (this.path == null)
			// 	this.path = find_path(); //à coder
			// else
			// 	this.path = checkPath(); //à coder
			//
			// robot.next_position = this.path[0];
			// if (robot.position.isAround(this.path[0]))
			// 	this.path[0].erase(); //trouver une alternative
			// move(robot.speed_regime, this.next_position); //à coder
			robot.goTo(); //move
		}
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
		if (((tab_tasks[TASK_WEATHERCOCK].done == DONE) && (((100000 - millis() - time) < (tab_tasks[TASK_FLAG].max_time + tab_tasks[TASK_FLAG].position.dist(robot.position)/SLOW)))) ||
				((100000 - millis() - time < tab_tasks[TASK_FLAG].max_time + new Pos(POS_FLAG.x, 150).dist(robot.position)/SLOW) &&
				(100000 - millis() - time < tab_tasks[TASK_FLAG].max_time + new Pos(POS_FLAG.x, 850).dist(robot.position)/SLOW)))
			return TASK_FLAG;

		if(tab_tasks[TASK_LIGHTHOUSE].done != DONE)
			return TASK_LIGHTHOUSE;

		if(tab_tasks[TASK_WINDSOCK].done != DONE)
			return TASK_WINDSOCK;

		if(tab_tasks[TASK_WEATHERCOCK].done != DONE)
			return TASK_WEATHERCOCK;

		return TASK_FLAG;
	}

	void do_task()
	{
		switch (this.id_current_task) {
			case TASK_WEATHERCOCK:
				weathercock();
				break;
			case TASK_WINDSOCK:
				windsock();
				break;
			case TASK_LIGHTHOUSE:
				lighthouse();
				break;
			case TASK_FLAG:
				flag();
				break;
		}

	}

	void weathercock()
	{
		tab_tasks[TASK_WEATHERCOCK].in_progress();
		tab_tasks[TASK_WEATHERCOCK].over();
	}

	void windsock()
	{
		this.robot.checkpoint_windsock.y = robot.position.y;
		tab_tasks[TASK_WINDSOCK].in_progress();
		this.robot.next_position = this.robot.checkpoint_windsock;
		this.robot.goTo();

		if (this.robot.position.isAround(this.robot.checkpoint_windsock, 50))
			tab_tasks[TASK_WINDSOCK].over();
	}

	void lighthouse()
	{
		tab_tasks[TASK_LIGHTHOUSE].in_progress();
		this.robot.goToAngle((3*PI)/2);
		if (mod2Pi(this.robot.angle - (3*PI)/2) < petite_rot)
		{
			if(this.lighthouse_wait == -1)
				this.lighthouse_wait = millis();
			

			if(((millis() - this.lighthouse_wait)*3) < (tab_tasks[TASK_LIGHTHOUSE].max_time))
			{
				float dist_bord = this.robot.position.y - float(LONGUEUR_ROBOT)/2;
				float coeff = (millis() - float(this.lighthouse_wait))/(float(int(tab_tasks[TASK_LIGHTHOUSE].max_time))/3.0);
				float adjust_dist = (1 - coeff) * dist_bord/2;
				float to_print = dist_bord/2 + adjust_dist;
				fill(0, 255, 0);
				pushMatrix();
				translate(this.robot.position.x, dist_bord/2 + adjust_dist);
				rectMode(CENTER);

				rect(0, 0, 10, dist_bord - adjust_dist*2);
				popMatrix();
			}
			else if (((millis() - this.lighthouse_wait)*3) < (tab_tasks[TASK_LIGHTHOUSE].max_time * 2))
			{
				float dist_bord = this.robot.position.y - float(LONGUEUR_ROBOT)/2;
				float coeff = (millis() - float(this.lighthouse_wait) - float(int(tab_tasks[TASK_LIGHTHOUSE].max_time))/3.0)/(float(int(tab_tasks[TASK_LIGHTHOUSE].max_time))/3.0);
				float adjust_dist = coeff * dist_bord/2;
				float to_print = dist_bord/2 + adjust_dist;
				fill(0, 255, 0);
				pushMatrix();
				translate(this.robot.position.x, dist_bord/2 + adjust_dist);
				rectMode(CENTER);

				rect(0, 0, 10, dist_bord - adjust_dist*2);
				popMatrix();
			}
			else
				tab_tasks[TASK_LIGHTHOUSE].over();	
		}
	}

	void flag()
	{
		tab_tasks[TASK_FLAG].in_progress();
		tab_tasks[TASK_FLAG].over();
	}

}
