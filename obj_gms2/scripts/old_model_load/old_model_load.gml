/// @func model_load
/// @args filename
var filename = argument0;

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
var vColors = ds_list_create();
var materials = ds_list_create();
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
					
					var v = ds_list_create();
					ds_list_add(v,
						real(string_extract(vstring," ",0)),
						real(string_extract(vstring," ",1))
					);
					
					ds_list_add(vUVs,v);
					ds_list_mark_as_list(vUVs, ds_list_size(vUVs)-1);
				#endregion
				break;
				
				case "n": #region vertex normal
					type = "vn";
					
					var vstring = string_replace(line,type+" ","");
					
					var v = ds_list_create();
					ds_list_add(v,
						real(string_extract(vstring," ",0)),
						real(string_extract(vstring," ",1)),
						real(string_extract(vstring," ",2))
					);
					
					ds_list_add(vNormals,v);
					ds_list_mark_as_list(vNormals, ds_list_size(vNormals)-1);
				#endregion
				break;
				
				default: #region vertex position
					
					var vstring =string_replace(line,type+" ","");
					
					var v = ds_list_create();
					ds_list_add(v,
						real(string_extract(vstring," ",0)),
						real(string_extract(vstring," ",1)),
						real(string_extract(vstring," ",2))
					);
					
					ds_list_add(vPositions,v);
					ds_list_mark_as_list(vPositions, ds_list_size(vPositions)-1);
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
			
			var face = ds_list_create();
			var fstring = string_replace(line,type+" ","");
			fstring = string_replace(fstring,"\n","");
			for (var i = 0; i < 3; ++i) {// loop through three indices for each triangle
				var v = string_extract(fstring," ",i);
				
				for (var j = 0; j < 3; ++j) ds_list_add(face,string_extract(v,"/",j)); //face[| ds_list_size(face)-1 ] = string_extract(v,"/",j);
			}
			
			// check if this face is using a material
			var color = currentMtlMap[?"diffuse"];
			
			ds_list_add(faces,face);
			ds_list_mark_as_list(faces,ds_list_size(faces)-1);
		#endregion
		break;
		
		case "m": #region mtllib
		
			var type = "mtllib";
			var matfilename = filename_path(filename) + string_replace(line,type+" ","");
			matfilename = string_replace(matfilename,"\n","");
			
			if (!file_exists(matfilename)) {
				show_error("Missing .mtl file:"+matfilename,true);
			}
			
			var matfile = file_text_open_read(matfilename);
			
			var currentMtlMap = noone;
			while (!file_text_eof(matfile)) {
				var matline = file_text_readln(matfile);
				var mattype = string_char_at(matline,1);
				
				switch (mattype) {
					case "n": // new material
						mattype = "newmtl";
						var matname = string_replace(matline,mattype+" ","");
						var mtlMap = ds_map_create();
						mtlMap[?"name"] = matname;
						currentMtlMap = mtlMap;
						ds_list_add(materials,mtlMap);
						ds_list_mark_as_map(materials,ds_list_size(materials)-1);
					break;
					
					//case "N":
					//	switch (string_char_at(matline,2)) {
					//		case "s": // specular exponent
					//			mattype = "Ns";
					//			var specexp = string_replace(matline,mattype+" ","");
					//			currentMtlMap[?"specularExp"] = real(specexp);
					//		break;
							
					//		case "i": // index of refraction
					//			mattype = "Ni";
					//			var ior = string_replace(matline,mattype+" ","");
					//			currentMtlMap[?"ior"] = real(ior);
					//		break;
					//	}
					//break;
					
					case "K":
						switch (string_char_at(matline,2)) {
							//case "a": // ambient
							//break;
							
							case "d": // diffuse
								mattype = "Kd";
								var matstring = string_replace(matline,mattype+" ","");
								//var matdiff = [
								//	real(string_extract(matstring," ",0)),
								//	real(string_extract(matstring," ",1)),
								//	real(string_extract(matstring," ",2))
								//];
								var matdiff = ds_list_create();
								ds_list_add(matdiff,
									real(string_extract(matstring," ",0)),
									real(string_extract(matstring," ",1)),
									real(string_extract(matstring," ",2))
								);
								ds_map_add_list(currentMtlMap,"diffuse",matdiff);
							break;
							
							//case "s": // specular
							//break;
							
							//case "e": // emission?
							//break;
						}
					break;
					
					//case "d": // dissolve
					//break;
					
					//case "i": // illumination model
					//break;
				}
			}
			
			file_text_close(matfile);
		
		#endregion material
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
	ds_list_destroy(materials);
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
			var kk = (k*4);
			var vpi = real(face[| kk]);
			var vti = real(face[| kk+1]);
			var vni = real(face[| kk+2]);
			var color = face[|kk+3];
			var vpos = vPositions[|vpi-1];
			var vtex = vUVs[|vti-1];
			var vnor = vNormals[|vni-1];
			vertex_position_3d(vbuff,vpos[|0],vpos[|1],vpos[|2]);
			vertex_texcoord(vbuff,vtex[|0],vtex[|1]);
			vertex_normal(vbuff,vnor[|0],vnor[|1],vnor[|2]);
			vertex_color(vbuff,make_color_rgb(color[|0]*255,color[|1]*255,color[|2]*255),1);
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
ds_list_destroy(materials);
ds_list_destroy(meshes);

var ret = vertexBuffers;
if (meshCount == 1) {
	ret = vertexBuffers[|0];
	ds_list_destroy(vertexBuffers);
}

return ret;

#endregion