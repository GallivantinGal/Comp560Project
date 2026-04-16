/// @description attack
if (moveState == moveStates.slash) {
	moveState = moveStates.walk;
	if (vSpeed != 0) {
	moveState = moveStates.jump;
	timer = 10;
	}
}

if (moveState == moveStates.hurt) {
	moveState = moveStates.idle;
	isHurt = false;
	invincible = false;
	invincibleTimer = 0;
}
