
/// @description Motion values init



dead = false;

//stay the same
hSpeed = 0;
vSpeed = 0;
playerOOR = true;
attackTimer = 0;
moveRight = 1;
moveLeft = -1;
moveIdle = 0;
moveState = moveStates.walk;

enemMaxHealth = 20;
enemHealth = enemMaxHealth;

range = 30;
attackSpeed = 30;
damage = 5;

walkSpeed = 1.2;

enum enemyActions {
	slash,
	thrust,
	counter,
	slashUp
}














