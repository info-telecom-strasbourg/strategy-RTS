class Dep
{
	Robot robot_op;
	Pos[] list_dep;
	int ind_dep;

	Dep(Robot robot_op, Pos[] tab_pos)
	{
		this.robot_op = robot_op;
		this.list_dep = tab_pos;
		this.ind_dep = 0;
		this.robot_op.next_position = list_dep[this.ind_dep];
	}

	void apply()
	{
		robot_op.speed_regime = FAST;

		this.robot_op.goTo();
		this.robot_op.getCorners();
		this.robot_op.borderColision();

		if((this.ind_dep < (this.list_dep.length - 1)) && this.robot_op.position.isAround(this.list_dep[this.ind_dep], 50))
		{
			this.ind_dep++;
			this.robot_op.next_position = list_dep[this.ind_dep];
		}

		this.robot_op.affiche(false);
	}
}
