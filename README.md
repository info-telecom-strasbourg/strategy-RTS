# Strategy-RTS
Creation of the robot strategy for RTS

## Installation

Here is the list of commands to install and start the simulation:

`
git clone git@github.com:info-telecom-strasbourg/strategy-RTS.git
`

At this point, the last update is on the branch `struct`. 
To access it, just enter:

```
git checkout struct
git pull origin struct
```

You can now start the simulation with your processing IDE.


## Expected behaviour
In the simulation, there are 2 robots. The green one is RTS' robot, and the red one is the opponent's one. The white translucent cone is the area where obstacles are detected. Our robot should slow down if an obstacle is in this area.

The triangles are the tasks locations:

- Red: the task is not done yet.
- Orange: the task is in progress.
- Green: the task is done.

The tasks location depend on the initial position and adapt themselves with the location given.
  
The weathercock should take a random color after 25 seconds (black or white). When it's done a new task appear. In the futur, we plan to add this task only when our robot detect the color of the weathercock.

We have simulated the behavior of the robot when it collapses with a border of the arena. 


## Adopted strategy
The robot will follow this strategy :
1) If time left < time to go to the mooring area + time to hoist the flag => go to hoist the flag
2) Turn on the light-house
3) Dress the windsocks
4) Detect the weathercock's color

## Futur steps
- Create the tasks
- Avoidance of the opposing robot
- Make some tests
- Adapt the code in C++

## Rules of the competition
You can find the rules of the competition [by clicking here](https://www.coupederobotique.fr/wp-content/uploads/Eurobot2020_Rules_Cup_OFFICIAL_FR.pdf).

## Contributors
- [Hugo LAULLIER](https://github.com/HugoLaullier)
- [Thomas RIVES](https://github.com/ThomasRives)
- [Thomas LEFEVRE](https://github.com/Zaicu)
- [Arnaud SCHLUMBERGER](https://github.com/ArnaudSchlumberger)
