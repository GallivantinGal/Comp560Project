/// @description Follow player

global.cameraX = 0;
global.cameraY = 0;
global.cameraXOffset = 10;
global.cameraYOffset = -45;

global.cameraWidth = 960;
global.cameraHeight = 540;

//Display
displayScale = 2;
displayWidth = global.cameraWidth * displayScale;
displayHeight = global.cameraHeight * displayScale;


camera_set(obj_player);
