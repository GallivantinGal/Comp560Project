/// @description Camera Setup

//Camera


view_enabled = true;
view_visible[0] = true;

camera_set_view_size(view_camera[0], global.cameraWidth, global.cameraHeight);
camera_set(obj_player);



window_set_size(displayWidth, displayHeight);
surface_resize(application_surface, displayWidth, displayHeight);

//GUI
display_set_gui_size(global.cameraWidth, global.cameraHeight);

alarm[0] = 1;