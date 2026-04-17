draw_self();

if (global.playerHP > 0) {
	var _temp = image_xscale;
	image_xscale = 1;
	draw_sprite_stretched(spr_health_bar_player,0,x-sprite_width/4,bbox_top-30,(global.playerHP/global.playerHPMax) * sprite_width/2, healthBarHeight);
	image_xscale = _temp;
} else {
draw_text_centered(global.cameraX, global.cameraY, global.cameraX+global.cameraWidth, global.cameraY+global.cameraHeight,
		"The machines have won. Press R to restart", 2);	
}