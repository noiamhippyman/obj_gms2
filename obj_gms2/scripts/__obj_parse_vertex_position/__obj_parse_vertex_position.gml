/// @func __obj_parse_vertex_position
/// @args string,vertexPositions
var vstring = argument0;
var vertexPositions = argument1;

var vertexPosition = ds_list_create();
ds_list_add(vertexPosition,
	real(string_extract(vstring," ",1)),
	real(string_extract(vstring," ",2)),
	real(string_extract(vstring," ",3))
);
			
ds_list_add(vertexPositions,vertexPosition);
ds_list_mark_as_list(vertexPositions, ds_list_size(vertexPositions) - 1);