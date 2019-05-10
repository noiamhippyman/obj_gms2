/// @func __obj_new_vertex_group
/// @args vertexGroups,objectName,materialName
var vertexGroups = argument0;
var objectName = argument1;
var materialName = argument2;

var vertexGroup = __ds_vertex_group();
vertexGroup[?"objectName"] = objectName;
vertexGroup[?"materialName"] = materialName;

ds_list_add(vertexGroups,vertexGroup);
ds_list_mark_as_map(vertexGroups, ds_list_size(vertexGroups) - 1);

return vertexGroup;