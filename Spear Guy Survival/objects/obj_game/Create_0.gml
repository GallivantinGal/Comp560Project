/// @description Init global values, once theres saves these will be different

global.gameSaveSlot = 0;

global.font_main = Font1;
draw_set_font(global.font_main);
gameIsPaused = false;
inventoryScreen = false;
levelingScreen = false;


global.overworldXoffset = 16;
global.overworldYoffset = 16;

global.playerRest = false;

global.exp = 0;
global.playerLevel = 1;
nextLevel = 0;

///Stats
global.playerHPMax = 14;
global.playerHP = global.playerHPMax;
global.playerManaMax = 6;
global.playerMana = global.playerManaMax;

healthbar_width = 128;
healthbar_height = 6;
healthbar_x = 32;
healthbar_y = 3;

manabar_width = 100;
manabar_height = 6;
manabar_x = 32;
manabar_y = 13;

