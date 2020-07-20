class Cups extends Task
{
    Cups(int id, int points, Pos position, long max_time)
    {
        super(id, points, position, max_time);
    }

    @Override
    void do_task()
    {
        this.over();
		strat.tasks_order.remove(0);
    }
}