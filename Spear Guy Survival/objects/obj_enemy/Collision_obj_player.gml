if (enemHealth > 0) {
with (other) {
	obj_enemy.success = damage_player(other.damage, other.image_xscale, other.action);
}
if (adjustWeights) {
switch (action) {
	
	case enemyActions.slash:
		if (success) {
			slashWeight++;
		} else {
			slashWeight = max(1, slashWeight-1);
		}
	break;
		
	case enemyActions.thrust:
		if (success) {
			thrustWeight++;
		} else {
			thrustWeight = max(1, thrustWeight-1);
		}
	break;
		
	case enemyActions.thrustUp:
		if (success) {
			thrustUpWeight++;
		} else {
			thrustUpWeight = max(1, thrustUpWeight-1);	
		}
	break;
		
	case enemyActions.counter:
		if (success) {
			counterWeight++;
		} else {
			counterWeight = max(1, counterWeight-1);
		}
	break;
	
}
}
adjustWeights = false;
}