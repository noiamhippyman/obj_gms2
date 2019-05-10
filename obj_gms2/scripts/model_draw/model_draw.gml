/// @func model_draw
/// @args model,texture,matrix,[shader]
var model = argument[0];
var texture = argument[1];
var matrix = argument[2];
var shader = argument_count > 3 ? argument[3] : noone;

if (shader != noone) shader_set(shader);
matrix_set(matrix_world, matrix);
var count = ds_list_size(model);
for (var i = 0; i < count; ++i) vertex_submit(model[|i],pr_trianglelist,texture);
matrix_set(matrix_world, matrix_build_identity());
if (shader != noone) shader_reset();