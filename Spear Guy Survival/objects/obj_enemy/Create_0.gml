
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
attackDelayTimer = 0;
attackDelay = 120;

enemMaxHealth = 20;
enemHealth = enemMaxHealth;

range = 200;
attackSpeed = 30;
walkSpeed = 0.5;
damage = 5;

enum enemyActions {
	slash,
	thrust,
	thrustUp,
	counter
}

slashRange = 100;
slashDamage = 5;

thrustRange = 200;
thrustDamage = 5;

thrustUpRange = 50;
thrustUpDamage = 5;

counterRange = 100;
counterDamage = 0;

action = noone;
attackSprite = spr_slash_up;
actionChosen = false;














