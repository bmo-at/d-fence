# D-FENCE

![Build Status](https://travis-ci.org/M320Trololol/d-fence.svg?branch=master)

This is  a tower defense game where you have to defend a central tower by shooting the hoards of zombies approaching your scout treehouse from the edges of the garden with a player controlled turret. The turret (a slingshot at the start of the game) is handled by your scout running around inside the treehouse and his fire target can be controlled via touch. It fires in a straight line, so where ever you touch the screen is where the scout will shoot. You receive points for your score via eliminating the hoards of zombies. Oh and you get some coins too if you'd like to buy a laser slingshot or something.

The hoards of zombies have 3 types of enemies:

* a weak zombie, which spawns later on in big groups (easy to kill, but they are numerous)
* a strong zombie, which spawns alone/in small groups (harder to kill, but alone/in small groups)
* an explodey zombie that starts a countdown (indicated by its sprite) as soon as it reaches a fence or the tower (easy to kill, but needs to be killed before it completes its countdown or it will explode and cause a lot of damage)

The hoards of zombies appear in waves, which have more and more enemies as the game progresses.

If an enemy is killed before reaching the tower, the player is awarded points for its score and coins.
The earlier an enemy is killed (smaller distance travelled from spawning), the more points the player receives. The coins are only depending on the type of the zombie.

After every wave you get to spend points to either upgrade your turret, repair your treehouse (expensive) or to place fences, which the hoards of zombies will attack upon bumping into them. They have a health value and price according to their tier (Tier I: Cheap and Easy to destroy, Tier II: semi-expensive and not that easy to destroy, Tier III: Expensive but hard to destroy). 

The tree has a health value, which can be decreased by hoards of zombies damaging it from up close or by explosions from enemies.

The game ends when the trees health value reaches 0 and it falls over killing the scout.

## Menu Concept

Drew this for fun

![MenuConcept](https://i.imgur.com/a7CbkIp.png)
