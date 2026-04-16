// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function camera_set(targetInput){

	target = targetInput
	
	if (instance_exists(target)) {
		

		global.cameraX = target.x - (global.cameraWidth/2) + global.cameraXOffset;
		global.cameraY = target.y - (global.cameraHeight/2) + global.cameraYOffset;
		
		global.cameraX = clamp(global.cameraX, 0, (room_width - global.cameraWidth));
		global.cameraY = clamp(global.cameraY, 0, (room_height - global.cameraHeight));
		
	}
	
	camera_set_view_pos(view_camera[0], global.cameraX, global.cameraY);
}