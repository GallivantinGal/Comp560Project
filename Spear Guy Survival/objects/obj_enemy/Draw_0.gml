draw_self();

if (enemHealth > 0) {
	var _temp = image_xscale;
	image_xscale = 1;
	draw_sprite_stretched(spr_health_bar,0,x-50,bbox_top-30,(enemHealth/enemMaxHealth) * sprite_width/4, 10);
	image_xscale = _temp;
}

if (sprite_index == spr_enemy_death) {
	draw_text_centered(global.cameraX, global.cameraY, global.cameraX+global.cameraWidth, global.cameraY+global.cameraHeight,
		"You survived the spear guy! The machines have lost.", 2);
}
