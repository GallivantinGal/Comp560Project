if (sprite_index == spr_enemy_death) {
	image_speed = 0;
	image_index = image_number-1;
	
}
if (moveState == moveStates.attack and enemHealth > 0) {
	actionChosen = false;
	moveState = moveStates.walk;
	
	attackDelayTimer = attackDelay;
}