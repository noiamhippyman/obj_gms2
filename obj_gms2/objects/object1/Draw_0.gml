var t = (current_time / 321) mod 360;
var scale = 200;
var matrix = matrix_build(room_width/2,room_height/2,0,0,t,0,scale,scale,scale);
model_draw(model,-1,matrix,shader_model);