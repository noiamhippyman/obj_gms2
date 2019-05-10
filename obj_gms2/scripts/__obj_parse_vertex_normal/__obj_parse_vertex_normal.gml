/// @func __obj_parse_vertex_normal
/// @args string,vertexNormals
var vstring = argument0;
var vertexNormals = argument1;

var vertexNormal = ds_list_create();
ds_list_add(vertexNormal,
	real(string_extract(vstring," ",1)),
	real(string_extract(vstring," ",2)),
	real(string_extract(vstring," ",3))
);
			
ds_list_add(vertexNormals,vertexNormal);
ds_list_mark_as_list(vertexNormals, ds_list_size(vertexNormals) - 1);