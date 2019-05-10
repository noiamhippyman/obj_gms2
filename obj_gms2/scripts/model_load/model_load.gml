/// @func model_load
/// @args filename
var filename = argument0;

#region Initialize data structures

var materials = ds_map_create();
var objectNames = ds_list_create();
var vertexPositions = ds_list_create();
var vertexUVs = ds_list_create();
var vertexNormals = ds_list_create();
var vertexGroups = ds_list_create();

#endregion

#region File Validation

file_validate(filename,".obj");
//if (!file_exists(filename)) {
//	show_error("File not found - " + filename, true);
//}

//if (filename_ext(filename) != ".obj") {
//	show_error("Filetype not .obj - " + filename, true);
//}

#endregion

__obj_parse_obj_file(filename,materials,objectNames,vertexGroups,vertexPositions,vertexUVs,vertexNormals);
var vertexBuffers = __obj_generate_vertex_buffers(materials,objectNames,vertexGroups,vertexPositions,vertexUVs,vertexNormals);

#region Cleanup data structures

ds_map_destroy(materials);
ds_list_destroy(objectNames);
ds_list_destroy(vertexPositions);
ds_list_destroy(vertexUVs);
ds_list_destroy(vertexNormals);
ds_list_destroy(vertexGroups);
//ds_list_add(vertexBuffers,materials,vertexPositions,vertexUVs,vertexNormals,vertexGroups); // just for testing and debugging

#endregion

return vertexBuffers;