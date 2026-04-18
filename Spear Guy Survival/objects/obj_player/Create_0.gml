/// @description Motion values init

hSpeed = 0;
vSpeed = 0;
gravitySpeed = 0.3;
walkSpeed = 3;
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
deathSprite = spr_player_death;
blockSprite = spr_block;

invincible = false;
invincibleTimer = 0;
invincibleDuration = 60;

weaponDmg = 1;

hitByAttack = ds_list_create();

attackerDirection = 0;
//-1 = right, 1 = left

global.playerHPMax = 60;
global.playerHP = global.playerHPMax;


slashAgain = false;

shieldDir = 1;

enum moveStates {
	walk,
	jump,
	hurt,
	idle,
	block,
	attack,
	stun,
	dead
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