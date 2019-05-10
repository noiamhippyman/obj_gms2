var scale = 50;
var t = (current_time / 10) mod 360;
var matrix = matrix_build(
	room_width/2, room_height/2 - (100*dcos(t)), 0,
	-15 * dsin(t),45,10,scale,scale,scale);
model_draw(model,-1,matrix);