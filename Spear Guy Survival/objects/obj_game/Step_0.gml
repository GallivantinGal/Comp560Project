global.key_up = keyboard_check(ord("W"));
global.key_down = keyboard_check(ord("S"));
global.key_left = keyboard_check(ord("A"));
global.key_right = keyboard_check(ord("D"));

global.key_up_pressed = keyboard_check_pressed(ord("W"));
global.key_down_pressed = keyboard_check_pressed(ord("S"));
global.key_left_pressed = keyboard_check_pressed(ord("A"));
global.key_right_pressed = keyboard_check_pressed(ord("D"));

global.key_jump = keyboard_check_pressed(vk_space);

global.key_slash = keyboard_check_pressed(ord("E"));
global.key_thrust = keyboard_check_pressed(ord("Q"));
global.key_block = keyboard_check(vk_shift);

//Parallax backgrounds
layer_x("Background", lerp(0,global.cameraX,.1));