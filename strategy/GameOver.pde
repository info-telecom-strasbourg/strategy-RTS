/**
 * This class represent the end of the game
 */
class GameOver extends Task
{
    /**
	 * The class' constructor
	 * @param id: the identifier of the task
	 * @param points: the points given by the task
	 * @param position: the location of this task
	 * @param max_time: the estimated necessary time to accomplish the task
	 */
    GameOver(int id, int points, Pos position, long max_time)
    {
        super(id, points, position, max_time);
    }

    /**
	 * Simulate the thing to do at the end of the timer
	 */
    @Override
    void do_task()
    {
        this.in_progress();
        robot_RTS.speed_regime = STOP;
        println("GAME OVER");
    }
}
