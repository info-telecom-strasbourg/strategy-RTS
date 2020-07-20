class ManageOpponent
{
    RTSRobot robot;
    ArrayList<Pos> opponent_positions;
    ArrayList<Pos> path;
    Pos objective_position;

    ManageOpponent(RTSRob robot)
    {
        this.robot = robot;
        opponent_positions = null;
        path = null;
        objective_position = null;
    }

    /**
	 * Identify the opponents position with the mobile lidar
	 * @param: opponent: the opponent's robot (for simulation)
	 */
	void find_the_opponent(Robot opponent)
	{
		this.opponent_positions = new ArrayList();
		ArrayList<Pos> obstacles;
        ArrayList<Pos> mob_lid_detectable = new ArrayList<Pos>();
        mob_lid_detectable.add(robot_op.position);
        mob_lid_detectable.add(POS_LIGHTHOUSE);
        mob_lid_detectable.add(POS_LIGHTHOUSE_OP);
        mob_lid_detectable.add(POS_WEATHERCOCK);

        if(robot_op_2 != null)
            mob_lid_detectable.add(robot_op_2.position);

		obstacles = this.robot.sensors.get(MOBILE_LIDAR).detection(mob_lid_detectable);
		
		if (obstacles.size() == 0)
			return;

		for (int i = 0; i < obstacles.size(); i++)
			if (!obstacles.get(i).is_around(POS_LIGHTHOUSE, 5) && 
			!obstacles.get(i).is_around(POS_LIGHTHOUSE_OP, 5) && 
			!obstacles.get(i).is_around(POS_WEATHERCOCK, 5))
				this.opponent_positions.add(obstacles.get(i));
	}

    /**
	 * Calculate the best path to move to the next task (we use a checkpoint in the
	 * case we have to avoid the opponent), but if no path is found, we stop the robot
	 */
	void find_path(Pos objective_pos)
	{
        this.objective_position = objective_pos;
        this.path = new ArrayList<Pos>();
        
		Pos intersection = access(this.robot.position, objective_position, 280);
		if(intersection != null)
		{
			Pos checkpoint = this.find_step(intersection);
			if(checkpoint != null)
			{
				this.path.add(checkpoint);
				this.path.add(objective_position);
			}
			else
				this.robot.speed_regime = STOP;
		}
		else
			this.path.add(objective_position);
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
				Pos check_2 = find_checkpoint(mod2Pi(2*angle_dep - angle_to_check));
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
				&& access(checkpoint, objective_position, 280) == null)
					return checkpoint;
		}
		return null;
	}

	/**
	 * Check if our robot won't collapse by following the path
	 */
	void check_path()
	{
		if (!objective_position.is_around(this.path.get(path.size() - 1), 5) 
			|| access(this.robot.position, this.path.get(0), 200) != null)
			{				
				this.path = new ArrayList();
				find_path();
			}
	}
    
    void path()
	{
		if (this.path.isEmpty())
			find_path();
		else
			check_path(); 
	}
}