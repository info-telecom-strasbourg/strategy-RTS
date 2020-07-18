/**
* Manage the moves of the opponent robot
*/
class Moves
{
	Robot robot_op;
	Pos[] list_moves;
	int ind_moves;

	/**
	 * Constructor of Moves
	 * @param robot_op: the opponent's robot
	 * @param tab_pos: the list of position the robot will go to
	 */
	Moves(Robot robot_op, Pos[] tab_pos)
	{
		this.robot_op = robot_op;
		this.list_moves = tab_pos;
		this.ind_moves = 0;
		this.robot_op.next_destination = list_moves[this.ind_moves];
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

		if((this.ind_moves < (this.list_moves.length - 1)) && this.robot_op.position.is_around(this.list_moves[this.ind_moves], 5))
		{
			this.ind_moves++;
			this.robot_op.next_destination = list_moves[this.ind_moves];
		}

		this.robot_op.display(false);
	}
}
