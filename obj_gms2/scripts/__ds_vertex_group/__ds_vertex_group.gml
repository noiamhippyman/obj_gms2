/// @func __ds_vertex_group

var vertexGroup = ds_map_create();

ds_map_add(vertexGroup,"objectName","");
ds_map_add(vertexGroup,"materialName","");
ds_map_add(vertexGroup,"smoothing",false);
ds_map_add_list(vertexGroup,"faces",ds_list_create());

return vertexGroup;