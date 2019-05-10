/// @func __obj_parse_face
/// @args facestring,vertexGroup
var fstring = argument0;
var vertexGroup = argument1;

var v1 = string_extract(fstring," ",1); // "i/j/k"
var v2 = string_extract(fstring," ",2); // "i/j/k"
var v3 = string_extract(fstring," ",3); // "i/j/k"
			
var face = ds_list_create();
ds_list_add(face,
	real(string_extract(v1,"/",0)),real(string_extract(v1,"/",1)),real(string_extract(v1,"/",2)), // vpi,vti,vni (tri1)
	real(string_extract(v2,"/",0)),real(string_extract(v2,"/",1)),real(string_extract(v2,"/",2)), // vpi,vti,vni (tri2)
	real(string_extract(v3,"/",0)),real(string_extract(v3,"/",1)),real(string_extract(v3,"/",2))  // vpi,vti,vni (tri3)
);
			
var faces = vertexGroup[?"faces"];
ds_list_add(faces,face);
ds_list_mark_as_list(faces, ds_list_size(faces) - 1);