class RTSRob extends Robot
{
    int detected_color;
    ArrayList<Sensor> sensors = new ArrayList<Sensor>();
    boolean flag_deployed;

    RTSRob(Pos position, float angle, ArrayList<Sensor> sensors)
    {
        super(position, angle);
        this.sensors = sensors;
        this.detected_color = NO_COLOR;
    }

    @Override
    void draw_robot()
    {
         pushMatrix();
        
		fill(0, 255, 0);
		translate(this.position.x, this.position.y);
		rotate(this.angle);
		rectMode(CENTER);
		rect(0, 0, ROBOT_WIDTH, ROBOT_HEIGHT);
        fill(255, 255, 255);
		triangle(ROBOT_HEIGHT/2, 0, 0, -ROBOT_WIDTH/2, 0, ROBOT_WIDTH/2);
        for(int i = 0; i < this.sensors.size(); i++)
            this.sensors.get(i).draw();

        popMatrix();
    }

}