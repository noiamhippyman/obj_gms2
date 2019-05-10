/// @func model_load
/// @args filename,[returnMap]
var filename = argument[0];
var returnMap = argument_count > 1 ? argument[1] : false;

#region Validate file

if (!file_exists(filename)) {
	show_error("No file found",true);
}

if (filename_ext(filename) != ".obj") {
	show_error("Not an .obj file",true);
}

#endregion

#region Parse .obj file into obj data structure

var file = file_text_open_read(filename);

var currentObjMap = noone;
var vPositions = ds_list_create();
var vUVs = ds_list_create();
var vNormals = ds_list_create();
var meshes = ds_list_create();

while (!file_text_eof(file)) {
	var line = file_text_readln(file);
	var type = string_char_at(line,1);
	
	switch (type) {
		case "g": // group
		case "o": #region object
			var name = string_replace(line,type+" ","");
			name = string_replace(name,"\n","");
			var objMap = ds_map_create();
			objMap[?"name"] = name;
			
			ds_list_add(meshes,objMap);
			ds_list_mark_as_map(meshes, ds_list_size(meshes)-1);
			currentObjMap = objMap;
		#endregion
		break;
		
		case "v": #region vertex data
		
			switch (string_char_at(line,2)) {
				case "t": #region vertex texcoords
					type = "vt";
					
					var vstring =string_replace(line,type+" ","");
					var v = [
						real(string_extract(vstring," ",0)),
						real(string_extract(vstring," ",1))
					];
					
					ds_list_add(vUVs,v);
				#endregion
				break;
				
				case "n": #region vertex normal
					type = "vn";
					
					var vstring = string_replace(line,type+" ","");
					var v = [
						real(string_extract(vstring," ",0)),
						real(string_extract(vstring," ",1)),
						real(string_extract(vstring," ",2))
					];
					
					ds_list_add(vNormals,v);
				#endregion
				break;
				
				default: #region vertex position
					
					var vstring =string_replace(line,type+" ","");
					var v = [
						real(string_extract(vstring," ",0)),
						real(string_extract(vstring," ",1)),
						real(string_extract(vstring," ",2))
					];
					
					ds_list_add(vPositions,v);
				#endregion
				break;
			}
		#endregion
		break;
		
		case "s": #region smoothing
			var smoothing = string_replace(line,type+" ","") == "off" ? false : true;
			currentObjMap[?"smoothing"] = smoothing;
		#endregion
		break;
		
		case "f": #region faces
			var faces = ds_map_find_value(currentObjMap,"faces");
			if (is_undefined(faces)) {
				faces = ds_list_create();
				ds_map_add_list(currentObjMap,"faces",faces);
			}
			
			var face = [];
			var fstring = string_replace(line,type+" ","");
			fstring = string_replace(fstring,"\n","");
			for (var i = 0; i < 3; ++i) {
				var v = string_extract(fstring," ",i);
				for (var j = 0; j < 3; ++j) face[ array_length_1d(face) ] = string_extract(v,"/",j);
			}
			
			ds_list_add(faces,face);
		#endregion
		break;
		
		default: // unsupported
			// do nothing
		break;
	}
}

file_text_close(file);

// No need to do anything. For some reason this jerk gave me an .obj file with no meshes.
if (ds_list_empty(meshes)) {
	ds_list_destroy(vPositions);
	ds_list_destroy(vUVs);
	ds_list_destroy(vNormals);
	ds_list_destroy(meshes);
	return noone;
}

#endregion

#region Setup vertex buffers

var vertexBuffers = ds_list_create();
var meshCount = ds_list_size(meshes);
for (var i = 0; i < meshCount; ++i) {
	var mesh = meshes[|i];
	var faces = mesh[?"faces"];
	var facecount = ds_list_size(faces);
	
	var vbuff = vertex_create_buffer();
	vertex_begin(vbuff,model_format());
	for (var j = 0; j < facecount; ++j) {
		var face = faces[|j];
		for (var k = 0; k < 3; ++k) {
			var kk = (k*3);
			var vpi = face[kk];
			var vti = face[kk+1];
			var vni = face[kk+2];
			var vpos = vPositions[|vpi-1];
			var vtex = vUVs[|vti-1];
			var vnor = vNormals[|vni-1];
			vertex_position_3d(vbuff,vpos[0],vpos[1],vpos[2]);
			vertex_texcoord(vbuff,vtex[0],vtex[1]);
			vertex_normal(vbuff,vnor[0],vnor[1],vnor[2]);
		}
	}
	vertex_end(vbuff);
	
	ds_list_add(vertexBuffers,vbuff);
}

#endregion

#region Cleanup and return

ds_list_destroy(vPositions);
ds_list_destroy(vUVs);
ds_list_destroy(vNormals);

var ret = vertexBuffers;
if (returnMap) {
	ret = ds_map_create();
	for (var i = 0; i < meshCount; ++i) {
		var mesh = meshes[|i];
		var name = mesh[?"name"];
		ret[?name] = vertexBuffers[|i];
	}
	
	ds_list_destroy(vertexBuffers);
} else {
	if (meshCount == 1) {
		ret = vertexBuffers[|0];
		ds_list_destroy(vertexBuffers);
	}
}

ds_list_destroy(meshes);

return ret;

#endregion