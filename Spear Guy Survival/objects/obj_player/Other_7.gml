/// @description attack
if (moveState == moveStates.attack) {
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
	isHurt = false;
	invincible = false;
	invincibleTimer = 0;
}
