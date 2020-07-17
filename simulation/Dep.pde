class Dep
{
	Robot robot_op;
	Pos[] list_dep;

	Dep(Robot robot_op)
	{
		this.robot_op = robot_op;
	}

	void apply()
	{
		robot_op.speed_regime = FAST;
		Pos[] pos_tab = {new Pos(0,500)}; // opponent's dest
		this.list_dep = pos_tab;
		this.robot_op.next_position = list_dep[0];
		this.robot_op.goTo();
		this.robot_op.getCorners();
		this.robot_op.borderColision();
		this.robot_op.affiche(false);
	}
}
