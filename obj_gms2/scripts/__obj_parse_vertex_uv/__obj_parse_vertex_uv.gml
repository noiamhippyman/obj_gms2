/// @func __obj_parse_vertex_uv
/// @args string,vertexUVs
var vstring = argument0;
var vertexUVs = argument1;

var vertexUV = ds_list_create();
ds_list_add(vertexUV,
	real(string_extract(vstring," ",1)),
	real(string_extract(vstring," ",2))
);
			
ds_list_add(vertexUVs,vertexUV);
ds_list_mark_as_list(vertexUVs, ds_list_size(vertexUVs) - 1);