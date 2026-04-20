
if (enemHealth <= 0) {
	sprite_index = spr_enemy_death;
} else {

/// @description Movement

startAttack = false;

var moveSpd = moveIdle;

if (attackDelayTimer > 0) {
	attackDelayTimer --;	
}

if (!actionChosen) {
	//action = choose(enemyActions.slash, enemyActions.thrust, enemyActions.thrustUp, enemyActions.counter);
	action = choose_weighted(enemyActions.slash, slashWeight, enemyActions.thrust, thrustWeight, enemyActions.thrustUp, thrustUpWeight, enemyActions.counter, counterWeight);
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
			if (obj_player.x < x - 10) {
				moveSpd = moveLeft;
		
			} else if (obj_player.x > x) { moveSpd = moveRight; }
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
	if (startAttack) { image_index = 0; startAttack = false; adjustWeights = true; }
	moveSpd = moveIdle;
	sprite_index = attackSprite;
	image_speed = 1;
}

hSpeed = moveSpd * walkSpeed;

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
}
}