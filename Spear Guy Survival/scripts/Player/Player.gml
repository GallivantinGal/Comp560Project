function player_attack_state(){ //also damage definitions
	
	var _hitbox, _dmg;
	
	switch (sprite_index) {
		case slashDownSprite:
			_hitbox = spr_slash_down_hb;
			_dmg = 5;
		break;
		case slashUpSprite:
			_hitbox = spr_slash_up_hb;
			_dmg = 5;
		break;
		case thrustSprite:
			_hitbox = spr_thrust_hb;
			_dmg = 10;
		break;
		case runAttackSprite:
			_hitbox = spr_run_attack_hb;
			_dmg = 10;
		break;
		default:
			_hitbox = spr_idle;
			_dmg = 0;
	}
	
	mask_index = _hitbox

	var _hitByAttackNow = ds_list_create();
	var _hits = instance_place_list(x,y,obj_enemy,_hitByAttackNow,false);
	if (_hits > 0) {
		for (var _i = 0; _i < _hits; _i++) {
			var _hitID = _hitByAttackNow[| _i];
			if (ds_list_find_index(hitByAttack, _hitID) == -1) {
				ds_list_add(hitByAttack, _hitID);
				with (_hitID) {
					damage_enemy(_dmg); //might be out of scope, can just be lazy and make global if needed
				}
			}
		}
		
	}
	
	ds_list_destroy(_hitByAttackNow);
	mask_index = spr_idle;
}

function damage_player(_val, _dir, _attackType) {
	if ((moveState != moveStates.block and !invincible) or (_attackType == enemyActions.counter)) {
		global.playerHP -= _val;
		moveState = moveStates.hurt;
		image_index = 0;
		hurtTimer = 0;
		invincible = true;
		attackerDirection = _dir;
		return true;
	}
	
	return false;
	
}