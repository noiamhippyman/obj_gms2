/// @func model_destroy
/// @args model
var model = argument0;


if (ds_exists(model,ds_type_map)) {
	
	var key = ds_map_find_first(model);
	var count = ds_map_size(model);
	for (var i = 0; i < count; ++i) {
		var mesh = model[?key];
		vertex_delete_buffer(mesh);
		key = ds_map_find_next(model,key);
	}
	ds_map_destroy(model);
	
} else if (ds_exists(model,ds_type_list)) {
	
	var count = ds_list_size(model);
	for (var i = 0; i < count; ++i) {
		var mesh = model[|i];
		vertex_delete_buffer(mesh);
	}
	ds_list_destroy(model);
	
} else {
	vertex_delete_buffer(model);
}