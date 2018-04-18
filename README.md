# D-FENCE

This is  a tower defense game where you have to defend a central tower by shooting the hoards of something approaching you from the edges of the screen with a user controlled turret. It is located on the tower and can be rotated 360 degrees by touch. It fires in a straight line, so where ever you touch the screen is where the turret will point. You receive points for eliminating the hoards.

The Hoards of something have 3 types of enemies:

* a weak something, which spawns in big hoards (easy to kill, but they are numerous)
* a strong something, which spawns alone/in small hoards (harder to kill, but alone)
* an explodey something that starts a countdown (indicated by its sprite) as soon as it reaches a fence or the tower (easy to kill, but needs to be killed before it completes its countdown or it will explode and cause a lot of damage)

The hoards appear in 1 minute long waves, which increase in numbers of enemies as the game progresses.

After every wave you get to spend points to either repair your tower (expensive) or to place fences, which the hoards will attack upon bumping into them. They have a health value and price according to their tier (Tier I: Cheap and Easy to destroy, Tier II: semi-expensive and not that easy to destroy, Tier III: Expensive but hard to destroy). 

The tower has a health value, which can be decreased by hoards damaging it from up close or by explosions from enemies.

The game ends when the Towers health value reaches 0. The Score is calculated by measuring the time survived ((wavecount - 1 * 60) + time remaining, the hoards killed (counted during game) and the points earned).