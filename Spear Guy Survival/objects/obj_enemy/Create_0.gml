
/// @description Motion values init


randomize();

success = false;

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
slashWeight = 1;

thrustRange = 200;
thrustDamage = 5;
thrustWeight = 1;

thrustUpRange = 50;
thrustUpDamage = 5;
thrustUpWeight = 1;

counterRange = 100;
counterDamage = 0;
counterWeight = 1;

action = noone;
attackSprite = spr_slash_up;
actionChosen = false;














