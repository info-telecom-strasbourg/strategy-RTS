/**
 * This class represent the cups 
 * Work in progress
 */
class Cups extends Task
{

    /**
     * The constructor of the class
     */
    Cups(int id, int points, Pos position, long max_time)
    {
        super(id, points, position, max_time);
    }

    /**
     * Simulate the task
     */
    @Override
    void do_task()
    {
        this.over();
		strat.tasks_order.remove(0);
    }
}