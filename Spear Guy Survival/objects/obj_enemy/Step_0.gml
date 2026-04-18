if (enemHealth < 0) {
	sprite_index = spr_enemy_death;
}

/// @description Movement

startAttack = false;

var moveSpd = moveIdle;

if (attackDelayTimer > 0) {
	attackDelayTimer --;	
}

if (!actionChosen) {
	action = choose(enemyActions.slash, enemyActions.thrust, enemyActions.thrustUp);
	actionChosen = true;
}
switch (action) {
	
	case enemyActions.slash:
		attackSprite = spr_enemy_slash;
		damage = slashDamage;
		range = slashRange;
	break;
		
	case enemyActions.thrust:
		attackSprite = spr_enemy_thrust;
		damage = thrustDamage;
		range = thrustRange;
	break;
		
	case enemyActions.thrustUp:
		attackSprite = spr_enemy_thrustup;
		damage = thrustUpDamage;
		range = thrustUpRange;
	break;
		
	case enemyActions.counter:
		attackSprite = spr_enemy_counter;
		damage = counterDamage;
		range = counterRange;
	break;
	
}

//walk logic
if (global.playerHP > 0) {
	if (moveState == moveStates.walk){
		if ((x > global.cameraX) and (x < global.cameraX + global.cameraWidth)){
			if (obj_player.x < x - 50) {
				moveSpd = moveLeft;
		
			} else { moveSpd = moveRight; }
		}
		if ((obj_player.x > x - range) and (obj_player.x < x + range) and attackDelayTimer <= 0) {
			moveSpd = moveIdle;
			moveState = moveStates.attack;
			start_attack = true;
		}
	}
}

//attack logic
if (moveState == moveStates.attack) {
	if (startAttack) { image_index = 0; startAttack = false; }
	moveSpd = moveIdle;
	sprite_index = attackSprite;
}





if (moveState == moveStates.hurt) {
	moveSpd = sign(image_xscale) * 1.5;
}

hSpeed = moveSpd * walkSpeed;

if (moveState == moveStates.hurt) {
	hurtTimer++;

	if (enemHealth > 0) {
	if (hurtTimer > 20) { 
	moveState = moveStates.walk;	
	}
	}
}

//Sprite direction
if (moveState == moveStates.walk) {
	sprite_index = spr_enemy_walk;
	if (hSpeed != 0) { 
		image_speed = 1;
	} else {
		image_speed = 0;
		image_index = 0; 
		}
}

//Always
if (hSpeed != 0) { 
	image_xscale = sign(hSpeed);
}

//Movement, should be last
if ((moveState == moveStates.attack) or (moveState == moveStates.walk)) {
	if (obj_player.moveState != moveStates.hurt) {
	x += hSpeed;
	}
} else if (moveState == moveStates.hurt) {
	if (enemHealth > 0) {
	x -= hSpeed;
	}
}