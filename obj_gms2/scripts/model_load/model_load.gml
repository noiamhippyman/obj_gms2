/// @func model_load
/// @args filename
var filename = argument0;

#region Initialize data structures

var materials = ds_map_create();
var vertexPositions = ds_list_create();
var vertexUVs = ds_list_create();
var vertexNormals = ds_list_create();
var vertexGroups = ds_list_create();

#endregion

#region File Validation

if (!file_exists(filename)) {
	show_error("File not found - " + filename, true);
}

if (filename_ext(filename) != ".obj") {
	show_error("Filetype not .obj - " + filename, true);
}

#endregion

#region Parse file

var file = file_text_open_read(filename);

var currVertexGroup = noone;
var currObjectName = "";

while (!file_text_eof(file)) {

	var line = string_replace(file_text_readln(file),"\n","");
	var element = string_extract(line," ",0);
	
	switch (element) {
		case "#": //  a comment! How nice? :D
		break;
		
		case "mtllib": // a file with one or more material definitions that will be added to materials ds_map
			var matfilename = filename_path(filename) + string_extract(line," ",1);
			__obj_parse_material_file(matfilename,materials);
		break;
		
		case "usemtl": // a material is being assigned to a new vertex group
			var materialName = string_extract(line," ",1);
			currVertexGroup = __obj_setup_new_vertex_group(vertexGroups,currObjectName,materialName);
		break;
		
		case "f": // faces are being added to the current vertex group being processed
			__obj_parse_face(line,currVertexGroup);
		break;
		
		case "s": // smoothing settings applied to the current vertex group being processed
			
			var smoothing = string_extract(line," ",1) == "off" ? false : true;
			currVertexGroup[?"smoothing"] = smoothing;
			
		break;
		
		case "o": // object
		case "g": // group (afaik they're the same thing. haven't tested enough.)
			
			currObjectName = string_extract(line," ",1);
			
		break;
		
		case "v": // vertex positions
			__obj_parse_vertex_position(line,vertexPositions);
		break;
		
		case "vt": // vertex texture coordinates (UV)
			__obj_parse_vertex_uv(line,vertexUVs);
		break;
		
		case "vn": // vertex normals
			__obj_parse_vertex_normal(line,vertexNormals);
		break;
		
		default:
			show_error("Unknown element: " + element,true);
		break;
	}

}

file_text_close(file);

#endregion

#region Create vertex buffers from parsed data
var vertexBuffers = ds_list_create();



#endregion

#region Cleanup data structures

//ds_map_destroy(materials);
//ds_list_destroy(vertexPositions);
//ds_list_destroy(vertexUVs);
//ds_list_destroy(vertexNormals);
//ds_list_destroy(vertexGroups);
ds_list_add(vertexBuffers,materials,vertexPositions,vertexUVs,vertexNormals,vertexGroups); // just for testing and debugging

#endregion

return vertexBuffers;