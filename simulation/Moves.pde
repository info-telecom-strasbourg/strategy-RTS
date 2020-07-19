/**
* Manage the moves of the opponent robot
*/
class Moves
{
	Robot robot_op;
	ArrayList <Pos> list_moves;
	int ind_moves;
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
		this.ind_moves = 0;
		this.robot_op.next_destination = this.list_moves.get(this.ind_moves);
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
			println("OK");
			this.list_moves.add(new Pos(mouseX, mouseY));
			last_click = millis();
		}

		if(mouseButton == RIGHT && (millis() - last_click) > 750)
		{
			println("NOK");
			this.list_moves.add(new Pos(mouseX, mouseY));
			last_click = millis();
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

		if((this.ind_moves < (this.list_moves.size() - 1)) && this.robot_op.position.is_around(this.list_moves.get(this.ind_moves), 5))
		{
			this.ind_moves++;
			this.robot_op.next_destination = list_moves.get(this.ind_moves);
		}
		this.robot_op.display(false);
	}
}
