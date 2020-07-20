class GameOver extends Task
{
    GameOver(int id, int points, Pos position, long max_time)
    {
        super(id, points, position, max_time);
    }

    @Override
    void do_task()
    {
        this.in_progress();
    		robot_RTS.speed_regime = STOP;
    		println("GAME OVER");
    }
}
