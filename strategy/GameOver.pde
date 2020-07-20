class GameOver extends Task
{
    Gameover(int id, int points, Pos position, long max_time)
    {
        super(id, points, position, max_time);
    }

    @Override
    void do_task()
    {
        strat.tab_tasks[this.id].in_progress();
		this.robot.speed_regime = STOP;
		println("GAME OVER");
    }
}