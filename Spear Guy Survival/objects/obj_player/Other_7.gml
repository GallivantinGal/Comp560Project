/// @description attack
if (moveState == moveStates.attack) {
	ds_list_clear(hitByAttack);
	if (sprite_index == slashDownSprite) and (slashAgain) {
		sprite_index = slashUpSprite;
		slashAgain = false;
	} else {
		moveState = moveStates.walk;
		if (vSpeed != 0) {
		moveState = moveStates.jump;
		timer = 10;
		}
	}
}

if (moveState == moveStates.hurt) {
	moveState = moveStates.idle;
}

if (moveState == moveStates.dead) {
	image_speed = 0;
	image_index = image_number-1;
}
