/// @func model_draw_index
/// @args model,texture,meshIndex,matrix,[shader]
var model = argument[0];
var texture = argument[1];
var meshIndex = argument[2]
var matrix = argument[3];
var shader = argument_count > 4 ? argument[4] : noone;

if (shader != noone) shader_set(shader);
matrix_set(matrix_world, matrix);
vertex_submit(model[|meshIndex],pr_trianglelist,texture);
matrix_set(matrix_world, matrix_build_identity());
if (shader != noone) shader_reset();