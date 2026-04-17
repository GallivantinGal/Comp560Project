function player_attack_state(){
	
	var _hitbox, _dmg;
	
	switch (sprite_index) {
		case slashDownSprite:
			_hitbox = spr_slash_down_hb;
		break;
		case slashUpSprite:
			_hitbox = spr_slash_up_hb;
		break;
		case thrustSprite:
			_hitbox = spr_thrust_hb;
		break;
		case runAttackSprite:
			_hitbox = spr_run_attack_hb;
		break;
		default:
			_hitbox = spr_idle;
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