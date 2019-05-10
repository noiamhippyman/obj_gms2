if (model != noone) {
	var scale = 25;
	var t = (current_time / 10) mod 360;
	var matrix = matrix_build(mouse_x,mouse_y - (100*dcos(t)),0,-15 * dsin(t),0,0,scale,scale,scale);
	model_draw(model,-1,matrix);
}