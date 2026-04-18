/// @description Controls


//dying
if (global.playerHP <= 0) {
	if (moveState != moveStates.dead) {
		image_index = 0;	
	}
	moveState = moveStates.dead;
	sprite_index = deathSprite;
	hSpeed = 0;
	vSpeed = 0;
} else {

var moveSpd = global.key_right - global.key_left;
hSpeed = moveSpd * walkSpeed;
vSpeed += gravitySpeed;

if (moveState == moveStates.attack) and (sprite_index == slashDownSprite) {
	if (global.key_slash) {
		slashAgain = true;
	}
}

switch (moveState) {
	case moveStates.attack:
		player_attack_state();
	break;
}

if (moveState != moveStates.attack) {
	ds_list_clear(hitByAttack);	
}




if ((moveState != moveStates.attack) and (moveState != moveStates.hurt)) {
	
	if (global.key_slash) {
		if (moveState == moveStates.walk) {
			sprite_index = runAttackSprite;	
		} else {
			sprite_index = slashDownSprite;
		}
		image_index = 0;
		image_speed = 1;
		moveState = moveStates.attack;
			
	} else if (global.key_thrust) {
		sprite_index = thrustSprite;
		image_index = 0;
		image_speed = 1;
		moveState = moveStates.attack;
			
	}
}

if (moveState == moveStates.hurt) {
	hurtTimer++;
	//image_speed = 1;
	sprite_index = hurtSprite;
	if (attackerDirection == 1) { hSpeed = 2; } else { hSpeed = -2; }
	if (hurtTimer > 20) {
		event_perform(ev_other, ev_animation_end);
		hSpeed = 0;
	}
}



//Always
//horz collision
if (place_meeting(x+hSpeed, y, obj_wall)) { //actual collision
	
	while (!place_meeting(x+sign(hSpeed), y, obj_wall)) { // pixel perfect collision
		x += sign(hSpeed);
	}
	hSpeed = 0;
}
//vert collision
if (place_meeting(x, y+vSpeed, obj_wall)) {
	
	while (!place_meeting(x, y+sign(vSpeed), obj_wall)) {
		y += sign(vSpeed);
	}
	vSpeed = 0;
	if ((hSpeed == 0) and (moveState != moveStates.attack) and (moveState != moveStates.hurt)) { 
		moveState = moveStates.idle;
	}
	if (moveState == moveStates.attack and sprite_index != spr_run_attack) {
		hSpeed = 0;
	} 
}

if (moveState != moveStates.hurt) {
	if (hSpeed != 0) { 
		image_xscale = sign(hSpeed);
	}
}

//jumping
if (moveState != moveStates.hurt) {
	if ((place_meeting(x, y+1, obj_wall)) and (global.key_jump)) {
		vSpeed = -fallSpeed;
		moveState = moveStates.jump;
		timer = 0;
	}
}

if (moveState == moveStates.jump) {
	image_speed = 0;
	sprite_index = airSprite;
	timer++;
	if (timer >= 10) {
	image_index = 1;
	}
}

//falling
if ((moveState != moveStates.jump) and (moveState != moveStates.attack) and (vSpeed != 0)) {
	moveState = moveStates.jump;
	timer = 10;
}

if((vSpeed == 0) and (moveState != moveStates.attack) and (moveState != moveStates.hurt) and (hSpeed != 0)) {
	moveState = moveStates.walk;
	//GMS code is sequential so we are still invulnerable while blocking even if theres a brief pause here
}

if ((moveState == moveStates.walk) or (moveState == moveStates.idle)) {
	if (global.key_block) {
		moveState = moveStates.block;
	}
}

if (moveState == moveStates.block) {
	sprite_index = blockSprite;
	image_index = 0;
	image_speed = 0;
}

//Sprite direction
if (moveState == moveStates.walk) {
	sprite_index = defSprite;
	if (hSpeed != 0) { 
		image_speed = 1;
	} else {
		image_speed = 0;
		image_index = 0; 
		}
}

if (moveState == moveStates.idle) {
	sprite_index = idleSprite;
	image_speed = 1;
}

//invincibility frames
if (invincible) {
	invincibleTimer ++;
	image_alpha = 0.5;
	if (invincibleTimer > invincibleDuration) {
	invincible = false;
	invincibleTimer = 0;
	}
} else { image_alpha = 1; }



//Movement, should be last
if ((moveState == moveStates.walk) or (moveState == moveStates.jump) or (moveState == moveStates.attack) or (moveState == moveStates.hurt)) {
	x += hSpeed;
}// else if (moveState == moveStates.hurt) {
//	x -= hSpeed;
//}
y += vSpeed;

}