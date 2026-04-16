/// @description Insert description here
// You can write your code in this editor
if ((moveState != moveStates.hurt) and (moveState != moveStates.slash)) {
if (!invincible) {
	if (other.moveState != moveStates.hurt) {
	event_perform(ev_other, ev_user1);
	global.playerHP--; //Damage to Player
	invincible = true;
	}
}
}
