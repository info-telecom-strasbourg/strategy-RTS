/**
 * A class that allow you to control a robot with your mouse
 */
class MouseController
{
    /* Indicate the click side of the robot */
    boolean left_click;

    /**
	 * Constructor of the MouseController
	 * @param control_left_click: indicate the click side of the robot
	 */
    MouseController(boolean control_left_click)
    {
        this.left_click = control_left_click;
    }

    /**
	* Add the mouse position in "list_moves" if the good click was pressed
    * (according to the robot), and remove the position of a point of a "list_moves"
    * located at the mouse position if the key 'd' cas pressed
	*/
    void update_list_moves(ArrayList<Pos> list_moves)
    {
        if((mouseButton == LEFT && left_click) || (mouseButton == RIGHT && !left_click))
		{
            if(list_moves.size() == 0 || !list_moves.get(list_moves.size()-1).is(new Pos(mouseX, mouseY)))
                list_moves.add(new Pos(mouseX, mouseY));
                
            mouseButton = CENTER;
		}

		if((keyPressed && key == 'd'))
		{
			Pos point_click = new Pos(mouseX, mouseY);
			for(int i = 0; i < list_moves.size(); i++)
				if(list_moves.get(i).is_around(point_click, 10))
					list_moves.remove(list_moves.get(i));
		}
    }
}