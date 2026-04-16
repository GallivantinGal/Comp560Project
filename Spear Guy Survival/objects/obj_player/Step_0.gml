/// @description Controls


//dying
if (global.playerHP <= 0) {
	room_restart();	
	global.playerHP = global.playerHPMax;
}

var moveSpd = global.key_right - global.key_left;
hSpeed = moveSpd * walkSpeed;
vSpeed += gravitySpeed;


if ((moveState != moveStates.slash) and (moveState != moveStates.hurt)) {
	if (global.key_slash) {
		sprite_index = attackSprite;
		image_index = 0;
		image_speed = 1;
		moveState = moveStates.slash;
			
	}
}


if (isHurt) { 
	moveState = moveStates.hurt;
	image_index = 0;
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
	if ((hSpeed == 0) and (moveState != moveStates.slash) and (moveState != moveStates.hurt)) { 
		moveState = moveStates.idle;
	}
	if (moveState == moveStates.slash) {
		hSpeed = 0;
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
if ((moveState != moveStates.jump) and (moveState != moveStates.slash) and (vSpeed != 0)) {
	moveState = moveStates.jump;
	timer = 10;
}

if((vSpeed == 0) and (moveState != moveStates.slash) and (moveState != moveStates.hurt) and (hSpeed != 0)) {
	moveState = moveStates.walk;
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
	

//Always
if (moveState != moveStates.hurt) {
if (hSpeed != 0) { 
	image_xscale = sign(hSpeed);
	shieldDir = sign(hSpeed);
}
}

//invincibility frames
if (invincible) {
	invincibleTimer ++;
	image_alpha = 0.5;
	if (invincibleTimer > 60) {
	invincible = false;
	}
} else { image_alpha = 1; }



//Movement, should be last
if ((moveState == moveStates.walk) or (moveState == moveStates.jump) or (moveState == moveStates.slash) or (moveState == moveStates.hurt)) {
	x += hSpeed;
}// else if (moveState == moveStates.hurt) {
//	x -= hSpeed;
//}
y += vSpeed;

