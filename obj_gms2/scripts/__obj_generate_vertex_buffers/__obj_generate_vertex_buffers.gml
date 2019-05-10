/// @func __obj_generate_vertex_buffers
/// @args materials,objectNames,vertexGroups,vertexPositions,vertexUVs,vertexNormals

var materials = argument0;
var objectNames = argument1;
var vertexGroups = argument2;
var vertexPositions = argument3;
var vertexUVs = argument4;
var vertexNormals = argument5;

var vertexBuffers = ds_list_create();

var vgroupCount = ds_list_size(vertexGroups);
var objectCount = ds_list_size(objectNames);
for (var objectIndex = 0; objectIndex < objectCount; ++objectIndex) {
	var objectName = objectNames[| objectIndex ];
	
	var vertexBuffer = vertex_create_buffer(); 
	vertex_begin(vertexBuffer,__obj_model_format());
	
	for (var vertexGroupIndex = 0; vertexGroupIndex < vgroupCount; ++vertexGroupIndex) {
		var vertexGroup = vertexGroups[| vertexGroupIndex ];
		if (vertexGroup[? "objectName" ] != objectName) continue;
		
		var currMtl = vertexGroup[? "materialName" ];
		currMtl = materials[? currMtl ];
		
		var mtlDiffuse = currMtl[? "diffuse" ];
		var mtlR = mtlDiffuse[|0] * 255;
		var mtlG = mtlDiffuse[|1] * 255;
		var mtlB = mtlDiffuse[|2] * 255;
		
		var faces = vertexGroup[? "faces" ];
		var faceCount = ds_list_size(faces);
		for (var faceIndex = 0; faceIndex < faceCount; ++faceIndex) {
			
			var face = faces[| faceIndex ];
			for (var facePropertyId = 0; facePropertyId < 3; ++facePropertyId) {
				var index = facePropertyId * 3;
				var vpi = face[| index ];
				var vti = face[| index+1 ];
				var vni = face[| index+2 ];
				var vp = vertexPositions[| vpi - 1 ];
				var vt = vertexUVs[| vti - 1 ];
				var vn = vertexNormals[| vni - 1 ];
				vertex_position_3d(vertexBuffer,vp[|0],vp[|1],vp[|2]);
				vertex_texcoord(vertexBuffer,vt[|0],vt[|1]);
				vertex_normal(vertexBuffer,vn[|0],vn[|1],vn[|2]);
				vertex_color(vertexBuffer,make_color_rgb(mtlR,mtlG,mtlB),1);
			}
		}
		
	}
	
	vertex_end(vertexBuffer);
	ds_list_add(vertexBuffers,vertexBuffer);
	
}

return vertexBuffers;