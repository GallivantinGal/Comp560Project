/// @description Motion values init

hSpeed = 0;
vSpeed = 0;
gravitySpeed = 0.3;
walkSpeed = 2.2;
fallSpeed = 6.5;
hurtTimer = 0;

healthBarHeight = 10;

defSprite = spr_run;
airSprite = spr_jump;
slashUpSprite = spr_slash_up;
slashDownSprite = spr_slash_down;
thrustSprite = spr_thrust;
hurtSprite = spr_hurt;
idleSprite = spr_idle;
runAttackSprite = spr_run_attack;

invincible = false;
invincibleTimer = 0;

weaponDmg = 1;


isHurt = false;

slashAgain = false;

shieldDir = 1;

enum moveStates {
	walk,
	jump,
	hurt,
	idle,
	block,
	attack,
	stun
}

enum attackTypes {
	slashUp,
	slashDown,
	thrust,
	jumpAttack,
	none
}

attackType = attackTypes.none;

moveState = moveStates.walk;