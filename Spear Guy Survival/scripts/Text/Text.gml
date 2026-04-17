function draw_text_centered(_x1, _y1, _x2, _y2, _string, _scale, _col = c_white) {
	draw_text_transformed_colour((_x1+_x2)/2 - string_width(_string)/2*_scale, (_y1+_y2)/2 - string_height(_string)/2*_scale,
		_string, _scale, _scale, 0, _col, _col, _col, _col, 1);
}