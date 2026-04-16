/// @description Motion values init

hSpeed = 0;
vSpeed = 0;
gravitySpeed = 0.3;
walkSpeed = 2.2;
fallSpeed = 6.5;
hurtTimer = 0;

defSprite = spr_run;
airSprite = spr_jump;
attackSprite = spr_slash_up;
hurtSprite = spr_hurt;
idleSprite = spr_idle;

invincible = false;
invincibleTimer = 0;

weaponDmg = 1;


isHurt = false;

shieldDir = 1;

enum moveStates {
	walk,
	jump,
	attack,
	hurt,
	idle,
	drinkingPotion,
	stun
}

moveState = moveStates.walk;