/**
 * Simulate a strategy
 */
class Strat
{
	//STRATEGY
	Robot robot;
	int id_current_task;
	ArrayList <Pos> opponent_positions = new ArrayList();
	int time;
	ArrayList <Pos> path = new ArrayList();
	int score;
	boolean move_back;

	//SIMULATION
	int lighthouse_wait = -1;
	int windsock_1_wait = -1;
	int windsock_1_wait_2 = -1;
	int windsock_2_wait = -1;
	int windsock_2_wait_2 = -1;
	int weathercock_wait = -1;

	/**
	 * Constructor of Strat
	 * @param robot: the robot that must apply the strategy
	 */
	Strat(Robot robot)
	{
		this.robot = robot;
		this.id_current_task = -1;
		this.opponent_positions = null;
		this.time = millis();
		this.score = 7;
		this.move_back = false;
	}

	/**
	 * Apply the strategy
	 * @param: opponent: the opponent's robot (for simulation)
	 */
	void apply(Robot opponent)
	{
		this.robot.speed_regime = fixed_lidar(opponent); //adaptation of the speed according to the environment
		this.find_the_opponent(opponent); //identify the opponent
		this.id_current_task = find_best_task(); //choose the task we have to do now
		
		if(this.robot.position.is_around(tab_tasks[this.id_current_task].position, 5) 
		   || tab_tasks[this.id_current_task].done == IN_PROGRESS)
		{
			do_task();
			if (!this.path.isEmpty())
				this.path = new ArrayList();
		}
		else
		{
			if (this.path.isEmpty())
				find_path();
			else
			{
				check_path(); 
			}
			
			if (!this.path.isEmpty() && this.robot.position.is_around(this.path.get(0), 5))
				this.path.remove(0);

			if (!this.path.isEmpty())
			{
				this.robot.next_destination = this.path.get(0);

				this.robot.getCorners();

				if (!this.robot.haveToBack())
					this.robot.goTo(true); 

			}

			if (this.robot.haveToBack())
					this.robot.goTo(false); 
		}
	}

	/**
	 * Identify the opponents position with the mobile lidar
	 * @param: opponent: the opponent's robot (for simulation)
	 */
	void find_the_opponent(Robot opponent)
	{
		this.opponent_positions = new ArrayList();
		Pos[] obstacles = mobile_lidar(this.robot.position, opponent);
		
		if (obstacles.length == 0)
			return;

		for (int i = 0; i < obstacles.length; i++)
			if (!obstacles[i].is_around(POS_LIGHTHOUSE, 5) && 
			!obstacles[i].is_around(POS_LIGHTHOUSE_OP, 5) && 
			!obstacles[i].is_around(POS_WEATHERCOCK, 5))
				this.opponent_positions.add(obstacles[i]);
	}

	/**
	 * Detect all the objects that are taller than the mobile lidar
	 * @param pos: position of the robot
	 * @param: opponent: the opponent's robot (for simulation)
	 * @return a table of objetcs' position
	 */
	Pos[] mobile_lidar(Pos pos, Robot opponent)
	{
		return new Pos[] {POS_LIGHTHOUSE, POS_LIGHTHOUSE_OP, POS_WEATHERCOCK, opponent.position};
	}

	/**
	 * Adapt the robot speed according to the environment detected by the bottom
	 * fixed lidars
	 * @param: opponent: the opponent's robot (for simulation)
	 * @return the speed regime
	 */
	int fixed_lidar(Robot opponent)
	{
		Pos[] robot_op_shape = find_robot_op_shape(opponent);
		for(int i = 0; i < robot_op_shape.length; i++)
			if (capture(robot_op_shape[i]))
				return SLOW;
		for(int i = 0; i < ARENA_HEIGHT; i+=10)
			if (capture(new Pos(i, 0)) || capture(new Pos(i, ARENA_WIDTH)))
				return SLOW;
		for(int i = 0; i < ARENA_WIDTH; i+=10)
			if (capture(new Pos(0, i)) || capture(new Pos(ARENA_HEIGHT, i)))
				return SLOW;
		return FAST;
	}

	/**
	 * Detect if the "pos" is detected by the fixed lidars
	 * @param: pos: the position to detect
	 * @return if "pos" is detected by the fixed lidars
	 */
	boolean capture(Pos pos)
	{
		Pos sensor = new Pos(this.robot.position.x + cos(this.robot.angle) * ROBOT_WIDTH/2,
							this.robot.position.y + sin(this.robot.angle) * ROBOT_WIDTH/2);

		if(sensor.dist(pos) > 250)
			return false;

		float delt_ang = mod2Pi(sensor.angle(pos) - this.robot.angle);
		delt_ang = (delt_ang < PI) ? delt_ang : 2*PI - delt_ang;

		return (delt_ang < PI/4);
	}

	/**
	 * Detect if the "pos" is detected by the fixed lidars
	 * @param: pos: the position to detect
	 * @return if "pos" is detected by the fixed lidars
	 */
	Pos[] find_robot_op_shape(Robot opponent)
	{
		Pos[] shapes = new Pos[8];

		for(int i = 0; i < 4; i++)
		{
			shapes[i] = opponent.corners[i];
			shapes[i+4] = opponent.corners[i].get_mid(opponent.corners[(i+1)%4]);
		}

		return shapes;
	}

	/**
	 * Select the closer mooring area (use if we do not know the weathercock color)
	 * The position of the flag's task is changed to fit to the decision
	 */
	void select_mooring_area()
	{
		Pos[] points_for_closer = new Pos [] {new Pos(POS_FLAG.x, 200), new Pos(POS_FLAG.x, 800)};
		tab_tasks[TASK_FLAG].position = this.robot.position.closer(points_for_closer);
	}

	/**
	 * Find the task to do
	 * @return the index of the task in tab_tasks
	 */
	int find_best_task()
	{
		if (this.id_current_task == TASK_FLAG && this.robot.detected_color == NO_COLOR)
			select_mooring_area();


		long time_left = 100000 - millis() - time;

		if (final_move_with_color(time_left) || final_move_without_color(time_left))		
			return TASK_FLAG;

		if(tab_tasks[TASK_LIGHTHOUSE].done != DONE)
			return TASK_LIGHTHOUSE;

		if(tab_tasks[TASK_WINDSOCK_1].done != DONE)
			return TASK_WINDSOCK_1;
		
		if(tab_tasks[TASK_WINDSOCK_2].done != DONE)
			return TASK_WINDSOCK_2;

		if(tab_tasks[TASK_WEATHERCOCK].done != DONE)
			return TASK_WEATHERCOCK;

		return TASK_FLAG;
	}

	/**
	 * Calculate if we have to move to the mooring area with the color of the weathercock
	 * @param: time_left: the time before the end of the game
	 * @return if we have to move to the mooring area 
	 */
	boolean final_move_with_color(long time_left)
	{
		return (tab_tasks[TASK_WEATHERCOCK].done == DONE && is_final_move(tab_tasks[TASK_FLAG].position, time_left));
	}

	/**
	 * Calculate if we have to move to the closest mooring area without the color of the weathercock
	 * @param: time_left: the time before the end of the game
	 * @return if we have to move to the closest mooring area 
	 */
	boolean final_move_without_color(long time_left)
	{
		return (is_final_move(new Pos(POS_FLAG.x, 200), time_left) 
			&& is_final_move(new Pos(POS_FLAG.x, 800), time_left) 
			&& tab_tasks[TASK_FLAG].done != DONE);
	}
	
	/**
	 * Calculate if we have the time to move to "pos" before the end of the game
	 * @param: pos: position of the robot
	 * @param: time_left: the time before the end of the game
	 * @return if we have the time to move to "pos" before the end of the game
	 */
	boolean is_final_move (Pos pos, long time_left)
	{
		return time_left < (tab_tasks[TASK_FLAG].max_time + pos.dist(robot.position)/SLOW);
	}

	/**
	 * Do the current task
	 */
	void do_task()
	{
		switch (this.id_current_task) {
			case TASK_WEATHERCOCK:
				weathercock();
				break;
			case TASK_WINDSOCK_1:
				windsock_1();
				break;
			case TASK_WINDSOCK_2:
				windsock_2();
				break;
			case TASK_LIGHTHOUSE:
				lighthouse();
				break;
			case TASK_FLAG:
				flag();
				break;
			default:
				println("No task found");
		}
	}

	/**
	 * Detect the weathercock color and update POS_FLAG
	 */
	void detect_weathercock_col()
	{
		switch (this.robot.detected_color = weathercock.color_w)
		{
			case BLACK:
				POS_FLAG.y = 200;
				break;
			case WHITE:
				POS_FLAG.y = 800;
				break;
			default:
				println("No color found");
		}
	}

	void weathercock()
	{
		tab_tasks[TASK_WEATHERCOCK].in_progress();
		this.robot.checkpoint_weathercock.y = robot.position.y;
		this.robot.next_destination = this.robot.checkpoint_weathercock;

		if (this.robot.position.is_around(this.robot.checkpoint_weathercock, 5))
		{
			this.robot.checkpoint_weathercock.y = 100;
			this.robot.next_destination = this.robot.checkpoint_weathercock;
		}

		if (this.robot.position.is_around(this.robot.checkpoint_weathercock, 5))
			if(mod2Pi(3*PI/2 - this.robot.angle) < rot_step)
			{
				if(this.weathercock_wait == -1)
					this.weathercock_wait = millis();

				if((millis() - this.weathercock_wait) > 2000)
				{
					detect_weathercock_col();
					tab_tasks[TASK_WEATHERCOCK].over();
				}
			}
			else
				this.robot.goToAngle(3*PI/2);

		this.robot.goTo(true);
	}

	/**
	 * Dress the windsocks
	 * THIS METHOD WILL BE MODIFIED SOON
	 */
	// void windsock()
	// {
	// 	if(this.robot.angle < PI - rot_step)
	// 	{
	// 		this.robot.goToAngle(PI);
	// 		return;
	// 	}

	// 	if(this.windsock_wait == -1)
	// 		this.windsock_wait = millis();

	// 	if((millis() - this.windsock_wait) < 2000)
	// 	{
	// 		fill(0, 255, 0);
	// 		pushMatrix();
	// 		float dist_bord = ARENA_WIDTH - this.robot.position.y - float(ROBOT_HEIGHT)/2;
	// 		float coeff = float(millis() - this.windsock_wait)/2000.0;
	// 		float act_height = coeff * dist_bord;
	// 		act_height = (act_height > 36) ? 36 : act_height;
	// 		translate(this.robot.position.x, this.robot.position.y + ROBOT_WIDTH/2 + act_height/2);//50
	// 		rect(0, 0, 10, act_height);
	// 		popMatrix();
	// 		this.robot.deployed = true;
	// 		return;
	// 	}

	// 	this.robot.checkpoint_windsock.y = robot.position.y;
	// 	tab_tasks[TASK_WINDSOCK].in_progress();
	// 	this.robot.next_destination = this.robot.checkpoint_windsock;
	// 	this.robot.goTo(true);

	// 	if(this.robot.position.is_around(this.robot.checkpoint_windsock, 5) && this.robot.deployed)
	// 	{
	// 		if(this.windsock_wait_2 == -1)
	// 			this.windsock_wait_2 = millis();

	// 		if((millis() - this.windsock_wait_2) < 2000)
	// 		{
	// 			fill(0, 255, 0);
	// 			pushMatrix();
	// 			float dist_bord = float(ARENA_WIDTH) - this.robot.position.y - float(ROBOT_HEIGHT)/2;
	// 			float coeff = float(millis() - this.windsock_wait_2)/2000.0;
	// 			float act_height = (1 - coeff) * dist_bord;
	// 			act_height = (act_height > 36) ? 36 : act_height;
	// 			translate(this.robot.position.x, this.robot.position.y + ROBOT_WIDTH/2 + act_height/2);//50
	// 			rect(0, 0, 10, act_height);
	// 			popMatrix();
	// 		}
	// 		else
	// 			this.robot.deployed = false;
	// 		return;
	// 	}
	// 	else if(this.robot.position.is_around(this.robot.checkpoint_windsock, 5))
	// 	{
	// 		tab_tasks[TASK_WINDSOCK].over();
	// 		this.score += tab_tasks[TASK_WINDSOCK].points;
	// 		return;
	// 	}

	// 	fill(0, 255, 0);
	// 	pushMatrix();
	// 	translate(this.robot.position.x, this.robot.position.y + ROBOT_WIDTH/2 + 18);//50
	// 	rect(0, 0, 10, 36);
	// 	popMatrix();

	// }

	void windsock_1()
	{
		tab_tasks[TASK_WINDSOCK_1].in_progress();
		if(this.robot.angle < PI/2 - rot_step || this.robot.angle > PI/2 + rot_step)
		{
			this.robot.goToAngle(PI/2);
			return;
		}
		// this.robot.checkpoint_windsock_1.x = robot.position.x;
		// this.robot.next_destination = this.robot.checkpoint_windsock_1;
		// if(!this.robot.position.is_around(this.robot.next_destination, 5))
		// {
		// 	this.robot.goTo(true);
		// 	return;
		// }

		tab_tasks[TASK_WINDSOCK_1].over();
		this.score += tab_tasks[TASK_WINDSOCK_1].points;
		if (tab_tasks[TASK_WINDSOCK_2].done == DONE)
			this.score += tab_tasks[TASK_WINDSOCK_1].points;
	}

	void windsock_2()
	{
		tab_tasks[TASK_WINDSOCK_2].in_progress();
		if(this.robot.angle < PI/2 - rot_step || this.robot.angle > PI/2 + rot_step)
		{
			this.robot.goToAngle(PI/2);
			return;
		}
		// this.robot.checkpoint_windsock_2.x = robot.position.x;
		// this.robot.next_destination = this.robot.checkpoint_windsock_2;
		// if(!this.robot.position.is_around(this.robot.next_destination, 5))
		// {
		// 	this.robot.goTo(true);
		// 	return;
		// }

		tab_tasks[TASK_WINDSOCK_2].over();
		this.score += tab_tasks[TASK_WINDSOCK_2].points;
		if (tab_tasks[TASK_WINDSOCK_1].done == DONE)
			this.score += tab_tasks[TASK_WINDSOCK_2].points;
	}


	/**
	 * Deploy the actuator to push the lighthouse button (simulation only)
	 */
	void deploy_actuator_lighthouse()
	{
		float dist_bord = this.robot.position.y - float(ROBOT_HEIGHT)/2;
		float adjust_dist;

		if(((millis() - this.lighthouse_wait)*3) < (tab_tasks[TASK_LIGHTHOUSE].max_time))
		{
			float coeff = (millis() - float(this.lighthouse_wait))/(float(int(tab_tasks[TASK_LIGHTHOUSE].max_time))/3.0);
			adjust_dist = (1 - coeff) * dist_bord/2;
		}
		else
		{
			float coeff = (millis() - float(this.lighthouse_wait) - 
						  float(int(tab_tasks[TASK_LIGHTHOUSE].max_time))/3.0)/(float(int(tab_tasks[TASK_LIGHTHOUSE].max_time))/3.0);
			adjust_dist = coeff * dist_bord/2;
		}
		fill(0, 255, 0);
		pushMatrix();
		translate(this.robot.position.x, dist_bord/2 + adjust_dist);
		rectMode(CENTER);

		rect(0, 0, 10, dist_bord - adjust_dist*2);
		popMatrix();
	}

	/**
	 * Turn the robot to the right direction and push the button
	 */
	void push_button()
	{
		this.robot.goToAngle((3*PI)/2);
		if (mod2Pi(this.robot.angle - (3*PI)/2) < rot_step)
		{
			if(this.lighthouse_wait == -1)
				this.lighthouse_wait = millis();
				
			if (((millis() - this.lighthouse_wait)*3) < (tab_tasks[TASK_LIGHTHOUSE].max_time * 2))
				deploy_actuator_lighthouse();
			else
			{
				tab_tasks[TASK_LIGHTHOUSE].over();
				this.score += tab_tasks[TASK_LIGHTHOUSE].points;
			}
		}
	}

	/**
	 * Simulate the execution of the lighthouse task
	 */
	void lighthouse()
	{
		this.robot.checkpoint_lighthouse.x = robot.position.x;
		tab_tasks[TASK_LIGHTHOUSE].in_progress();
		this.robot.next_destination = this.robot.checkpoint_lighthouse;
		this.robot.goTo(true);
		if (this.robot.position.is_around(this.robot.checkpoint_lighthouse, 5))
			push_button();
		
	}

	/**
	 * Simulate the task linked to the flag
	 */
	void flag()
	{
		if(tab_tasks[TASK_FLAG].done == DONE)
			return;

		if(tab_tasks[TASK_FLAG].done != IN_PROGRESS)
		{
			Pos weth_1 = new Pos(POS_FLAG.x, 200), weth_2 = new Pos(POS_FLAG.x, 800);
			if (this.robot.position.is_around(weth_1, 5) || this.robot.position.is_around(weth_2, 2))
				if (tab_tasks[TASK_WEATHERCOCK].done == DONE)
					this.score += 10;
				else
					this.score += 5;
		}

		tab_tasks[TASK_FLAG].in_progress();
		if (millis() - this.time > 95500)
		{
			this.robot.flag = true;
			tab_tasks[TASK_FLAG].over();
			this.score += tab_tasks[TASK_FLAG].points;
		}
	}

	/**
	 * Calculate the best path to move to the next task (we use a checkpoint in the
	 * case we have to avoid the opponent), but if no path is found, we stop the robot
	 */
	void find_path()
	{
		Pos intersection = access(this.robot.position, tab_tasks[this.id_current_task].position, 280);
		if(intersection != null)
		{
			Pos checkpoint = this.find_step(intersection);
			if(checkpoint != null)
			{
				this.path.add(checkpoint);
				this.path.add(tab_tasks[this.id_current_task].position);
			}
			else
				this.robot.speed_regime = STOP;
		}
		else
			this.path.add(tab_tasks[this.id_current_task].position);
	}

	/**
	 * Indicate if is possible to move from the "point_1" to the "point_2" without
	 * collapsing with the opponent
	 * @param: point_1: start point
	 * @param: point_2: arrival point
	 * @param: dist: the security distance
	 * @return null if a direct route is possible between point_1 and point_2, 
	 * otherwise the intersection point with the opponent
	 */
	Pos access (Pos point_1, Pos point_2, int dist)
	{
		float nb_seg = 15;
		float delta_x = point_2.x - point_1.x;
		float delta_y = point_2.y - point_1.y;

		for (float i = 0; i < nb_seg; i++)
		{
			Pos new_pos = new Pos(point_1.x + i*delta_x/nb_seg, point_1.y + i*delta_y/nb_seg);
			for (int j = 0; j < this.opponent_positions.size(); j++)
				if (new_pos.dist(this.opponent_positions.get(j)) < dist)
					return new_pos;
		}
		return null;
	}

	/**
	 * Find a checkpoint to avoid the opponent robot by testing different drifts 
	 * @param: intersection: point where our robot collapse with the opponent 
	 * @return null if no checkpoint is found, otherwise the found checkpoint
	 */
	Pos find_step(Pos intersection)
	{
		float distance = this.robot.position.dist(intersection);
		float angle_step = 3 * distance / 1000;
		float angle_dep = this.robot.position.angle(this.robot.next_destination);
		if(angle_step != 0)
			for(float i = angle_dep; i < angle_dep + PI/2; i+=angle_step)
			{
				float angle_to_check = mod2Pi(i);
				Pos check_1 = find_checkpoint(angle_to_check);
				if(check_1 != null)
					return check_1;
				Pos check_2 = find_checkpoint(mod2Pi(-angle_to_check));
				if(check_2 != null)
					return check_2;
			}
		return null;
	}

	/**
	 * Find a checkpoint on a specific drift
	 * @param: angle: the drift angle
	 * @return null if no checkpoint is found, otherwise the found checkpoint
	 */
	Pos find_checkpoint(float angle)
	{
		float step = 10;
		Pos checkpoint = new Pos(this.robot.position);

		while (checkpoint.on_arena(100))
		{
			checkpoint.x += step*cos(angle);
			checkpoint.y += step*sin(angle);


			if(access(this.robot.position, checkpoint, 280) == null 
				&& access(checkpoint, tab_tasks[this.id_current_task].position, 280) == null)
					return checkpoint;
		}
		return null;
	}

	/**
	 * Check if our robot won't collapse by following the path
	 */
	void check_path()
	{
		if (!tab_tasks[this.id_current_task].position.is_around(this.path.get(path.size() - 1), 5) 
			|| access(this.robot.position, this.path.get(0), 200) != null)
			{				
				this.path = new ArrayList();
				find_path();
			}
	}
}
