/// @func model_destroy
/// @args model
var model = argument0;

var count = ds_list_size(model);
for (var i = 0; i < count; ++i) {
	var mesh = model[|i];
	vertex_delete_buffer(mesh);
}
ds_list_destroy(model);