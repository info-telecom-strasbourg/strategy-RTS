/**
 * This class represent the cups 
 * Work in 
 */
class Cups extends Task
{
    /* The color of the cup */
    int color_cup;

    /**
     * The constructor of the class
     */
    Cups(int id, int points, Pos position, long max_time, int color_c)
    {
        super(id, points, position, max_time);
        this.color_cup = color_c;
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