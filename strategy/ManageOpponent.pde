/**
 * This class allow our robot to avoid the opponent
 * You can make a class that inherits this class to keep this behaviour
 */
class ManageOpponent
{
	/* The robot that avoid the opponent */
    RTSRob robot;

	/* The opponent(s) position(s) -> for simulation */
    ArrayList<Pos> opponent_positions = new ArrayList<Pos>();

	/* The path selected by the robot */
    ArrayList<Pos> path  = new ArrayList<Pos>();

	/* The position you want to reach right now */
    Pos objective_position;

	/**
	 * The constructor of the class
	 * @param robot: the robot that will avoid the opponent
	 */
    ManageOpponent(RTSRob robot)
    {
        this.robot = robot;
        this.objective_position = null;
    }

    /**
	 * Identify the opponents position with the mobile lidar
	 * @param: opponent: the opponent's robot (for simulation)
	 */
	void find_the_opponent()
	{
		this.opponent_positions = new ArrayList<Pos>();
		ArrayList<Pos> obstacles;
		ArrayList<Pos> mob_lid_detectable = new ArrayList<Pos>();
		for(int i = 0; i < rob_opponents.size(); i++)
			mob_lid_detectable.add(rob_opponents.get(i).position);
			
		mob_lid_detectable.add(POS_LIGHTHOUSE);
		mob_lid_detectable.add(POS_LIGHTHOUSE_OP);
		mob_lid_detectable.add(POS_WEATHERCOCK);

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
	void find_path(float secu_dist)
	{
        this.path = new ArrayList<Pos>();
        
		Pos intersection = access(this.robot.position, objective_position, secu_dist);
		if(intersection != null)
		{
			Pos checkpoint = this.find_step(intersection, secu_dist);
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
	 * @param: secu_dist: security distance
	 * @return null if a direct route is possible between point_1 and point_2, 
	 * otherwise the intersection point with the opponent
	 */
	Pos access (Pos point_1, Pos point_2, float secu_dist)
	{
		float nb_seg = 100;
		float delta_x = point_2.x - point_1.x;
		float delta_y = point_2.y - point_1.y;

		for (float i = 0; i < nb_seg; i++)
		{
			Pos new_pos = new Pos(point_1.x + i*delta_x/nb_seg, point_1.y + i*delta_y/nb_seg);
			for (int j = 0; j < this.opponent_positions.size(); j++)
				if (is_on_security_area(new_pos, this.opponent_positions.get(j), secu_dist))
					return new_pos;
		}
		return null;
	}

    /**
	 * Indicate if the opponent is on the security area
	 * @param: current_pos: the current position
	 * @param: opponent_pos: the opponent position
	 * @param: secu_dist: security distance
	 * @return if the opponent is on the security area
	 */
	boolean is_on_security_area(Pos current_pos, Pos opponent_pos, float secu_dist) 
	{
		if(current_pos.dist(opponent_pos) < 150)
			return true;
		if(current_pos.dist(opponent_pos) > secu_dist)
			return false;

		return (current_pos.angle(opponent_pos) < PI) ? true : false;
	}

	/**
	 * Find a checkpoint to avoid the opponent robot by testing different drifts 
	 * @param: intersection: point where our robot collapse with the opponent 
	 * @param: secu_dist: security distance
	 * @return null if no checkpoint is found, otherwise the found checkpoint
	 */
	Pos find_step(Pos intersection, float secu_dist)
	{
		float distance = this.robot.position.dist(intersection);
		float angle_step = 3 * distance / 1000;
		float angle_dep = this.robot.position.angle(this.robot.next_destination);
		if(angle_step != 0)
			for(float i = angle_dep; i < angle_dep + PI; i += angle_step)
			{
				float angle_to_check = mod2Pi(i);
				Pos check_1 = find_checkpoint(angle_to_check, secu_dist);
				if(check_1 != null)
					return check_1;
				Pos check_2 = find_checkpoint(mod2Pi(2*angle_dep - angle_to_check), secu_dist);
				if(check_2 != null)
					return check_2;
			}
		return null;
	}

	/**
	 * Find a checkpoint on a specific drift
	 * @param: angle: the drift angle
	 * @param: secu_dist: security distance
	 * @return null if no checkpoint is found, otherwise the found checkpoint
	 */
	Pos find_checkpoint(float angle, float secu_dist)
	{
		float step = 10;
		Pos checkpoint = new Pos(this.robot.position);

		while(checkpoint.on_arena(1) && !checkpoint.on_arena(100))
		{
			checkpoint.x += step*cos(angle);
			checkpoint.y += step*sin(angle);

			if(access(this.robot.position, checkpoint, secu_dist) == null 
				&& access(checkpoint, objective_position, secu_dist) == null)
					return checkpoint;
		}

		while (checkpoint.on_arena(100))
		{
			checkpoint.x += step*cos(angle);
			checkpoint.y += step*sin(angle);

			if(access(this.robot.position, checkpoint, secu_dist) == null 
				&& access(checkpoint, objective_position, secu_dist) == null)
					return checkpoint;
		}
		return null;
	}

	/**
	 * Check if our robot won't collapse by following the path
	 * @param: secu_dist: security distance
	 */
	void check_path(float secu_dist)
	{
		if (!this.objective_position.is_around(this.path.get(path.size() - 1), 5) 
			|| access(this.robot.position, this.path.get(0), secu_dist) != null)
			{				
				this.path = new ArrayList();
				find_path(secu_dist);
			}
	}
    
	/**
	 * Find the best path in the situation
	 * If we have a path, we check if it still work
	 * else we find a new path
	 * @param objectiv_pos: the destination you want to reach
	 */
    void path(Pos objectiv_pos)
	{
    	this.objective_position = objectiv_pos;
		if (this.path.isEmpty())
			find_path(280);
		else
			check_path(200); 
	}
}
