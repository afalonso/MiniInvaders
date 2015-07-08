# MiniInvaders
Based on Space Invaders


My final project was intended to be a version of the classic videogame "Space Invaders" (https://en.wikipedia.org/wiki/Space_Invaders); that is, some sort of "mini-invaders". My goal, though, was not so ambitious and I just tried to include two alien ships, but other aspects as missile, barriers, and points.

At first, I felt overwhelmed by all the pending task to face and solve, so I follow the main advice for the final project, namely: keep it simple! So, I decided to include each game element step by step, starting with the space ship and its movement, the alien ships, the missile, the missile hits an alien ship, the barriers, the point counting, and a time limit. 

This strategy was fine at the beginning, quite easy, and the main obstacle was to change the initial perspective that focused on the player ship to a more generic and ample perspective: the "world"; that is, space ship, alien ships, and missile would be part of a big structure, called "world", so it would be easier (even possible) they could interact among them. 

However, as the world becomes more and more complex, I realized that some of my initial functions, with signatures involving Ship, Alien or Missile, weren't appropriate to deal satisfactorily with element interactions (for example, when a missile hits an alien ship and then counting the corresponding bonus points). My initial code structure was not adequate to support all the complexity of possible interactions, and it would require some, in my opinion, confusing tricks (you can see that in the function "hit-ufo", with too many parameters in my opinion) that could be prevented by using an unique parameter (representing the "World") and probably another one for very specific tasks (as the key pressed or something like that).

The code is totally functional, but it does not include explosions, counting points or time limit. I am still working on the code (it has already been assessed and got full points: thanks a lot!!), so any comment would be appreciated.

Instead of pasting the code here, I copied it to github, where is easier to check and read, and it preserves indentation: https://github.com/afalonso/MiniInvaders/blob/master/alien-invasion.rkt

Let me know if you have some issue to download it.
