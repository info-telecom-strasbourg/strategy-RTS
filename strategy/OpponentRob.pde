class OpponentRob extends Robot
{
    /* The list of position to go */
    ArrayList<Pos> list_moves;

    MouseController mouse;

    OpponentRob(Pos init_pos, float angle)
    {
        super(init_pos, angle);
        this.list_moves = random_positions(53);
        this.mouse = null;
    }

    OpponentRob(Pos init_pos, float angle, boolean control_left_click)
    {
        super(init_pos, angle);
        this.mouse = new MouseController(control_left_click);
        this.list_moves = new ArrayList<Pos>();
    }


    ArrayList<Pos> random_positions(int nb)
    {
        ArrayList <Pos> path_op = new ArrayList<Pos>();
        for (int i = 0; i < nb; i++)
        {
            int rand_x = int(random(ARENA_HEIGHT - 200)) + 100;
            int rand_y = int(random(ARENA_WIDTH - 200)) + 100;
            path_op.add(new Pos(rand_x,rand_y));
        }

        return path_op;
    }

    void update_destinations()
    {
        if(this.mouse != null)
            this.mouse.update_list_moves(this.list_moves);

        this.next_destination = (this.list_moves.isEmpty()) ? this.position : this.list_moves.get(0);

        if(this.position.is_around(this.next_destination, 5))
            if(!this.list_moves.isEmpty())
                this.list_moves.remove(0);
    }

    void display_dest()
	{
		for(int i = 0; i < this.list_moves.size(); i++)
		{
            if(this.mouse.left_click)
			    fill(255, 255, 255, 125);
            else
                fill(0, 0, 0, 125);
			ellipse(this.list_moves.get(i).x, this.list_moves.get(i).y, 30, 30);
            if(this.mouse.left_click)
			    fill(0, 0, 0);
            else
                fill(255, 255, 255);
			text(i, this.list_moves.get(i).x - 9, this.list_moves.get(i).y + 11);
		}
	}

    @Override
    void draw_robot()
    {
        pushMatrix();
        
		fill(255, 0, 0);
		translate(this.position.x, this.position.y);
		rotate(this.angle);
		rectMode(CENTER);
		rect(0, 0, ROBOT_WIDTH, ROBOT_HEIGHT);
        fill(0, 0, 0);
		triangle(ROBOT_HEIGHT/2, 0, 0, -ROBOT_WIDTH/2, 0, ROBOT_WIDTH/2);

        popMatrix();
    }
}