/**
* Manage the moves of the opponent robot
*/
class Moves
{
	Robot robot_op;
	ArrayList <Pos> list_moves;
	boolean click;
	long last_click;

	/**
	 * Constructor of Moves
	 * @param robot_op: the opponent's robot
	 * @param tab_pos: the list of position the robot will go to
	 */
	Moves(Robot robot_op, ArrayList <Pos> tab_pos)
	{
		this.robot_op = robot_op;
		this.list_moves =  tab_pos;
		this.click = false;
		this.robot_op.next_destination = this.list_moves.get(0);
	}

	Moves(Robot robot_op)
	{
		this.robot_op = robot_op;
		this.list_moves =  new ArrayList();
		this.list_moves.add(new Pos(this.robot_op.position.x, this.robot_op.position.y));
		this.click = true;
		this.robot_op.next_destination = this.robot_op.position;
	}

	void detect_click()
	{
		if(mouseButton == LEFT && (millis() - last_click) > 750)
		{
			this.list_moves.add(new Pos(mouseX, mouseY));
			last_click = millis();
		}

		if(mouseButton == RIGHT && (millis() - last_click) > 750)
		{
			Pos point_click = new Pos(mouseX, mouseY);
			for(int i = 0; i < this.list_moves.size(); i++)
				if(this.list_moves.get(i).is_around(point_click, 10))
					this.list_moves.remove(this.list_moves.get(i));
					
			if(this.list_moves.isEmpty())
				this.list_moves.add(this.robot_op.position);

			last_click = millis();
		}
	}

	void display_dest()
	{
		for(int i = 0; i < this.list_moves.size(); i++)
		{
			fill(255, 255, 255, 125);
			ellipse(this.list_moves.get(i).x, this.list_moves.get(i).y, 20, 20);
			fill(255, 0, 0);
			text(i, this.list_moves.get(i).x - 9, this.list_moves.get(i).y + 11);
		}
	}

	/**
	 * Simulate the behavior of the opponent's robot
	 */
	void apply()
	{
		robot_op.speed_regime = FAST;

		this.robot_op.goTo(true);
		this.robot_op.getCorners();
		this.robot_op.borderColision();

		if(this.click)
			detect_click();

		if(this.list_moves.size() > 1 && this.robot_op.position.is_around(this.list_moves.get(0), 5))
			list_moves.remove(0);
			
		this.robot_op.next_destination = list_moves.get(0);


		this.display_dest();
		this.robot_op.display(false);
	}
}
