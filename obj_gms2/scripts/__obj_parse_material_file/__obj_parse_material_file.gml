/// @func __obj_parse_material_file
/// @args filename,materials
var filename = argument0;
var materials = argument1;

#region File validation

file_validate(filename,".mtl");
//if (!file_exists(filename)) {
//	show_error("File not found - " + filename, true);
//}

//if (filename_ext(filename) != ".mtl") {
//	show_error("Filetype not .mtl - " + filename, true);
//}

#endregion

#region Parse file

var currMtl = noone;

var file = file_text_open_read(filename);

while (!file_text_eof(file)) {
	var line = string_replace(file_text_readln(file),"\n","");
	var element = string_extract(line," ",0);
	
	switch (element) {
		case "#": // a comment! How nice? :D
		break;
		
		case "newmtl": // a new material is about to start
			
			var name = string_extract(line," ",1);
			var mtl = materials[?name];
			
			if (is_undefined(mtl)) {
				currMtl = __ds_material();
				ds_map_add_map(materials, name, currMtl);
			} else exit;
			
		break;
		
		case "Ns": // specular exponent
		
			currMtl[?"specularExponent"] = real(string_extract(line," ",1));
		
		break;
		
		case "Ka": // ambient
		
			var ambient = currMtl[?"ambient"];
			ds_list_add(ambient, 
				real(string_extract(line," ",1)), 
				real(string_extract(line," ",2)), 
				real(string_extract(line," ",3)));
		
		break;
		
		case "Kd": // diffuse
		
			var diffuse = currMtl[?"diffuse"];
			ds_list_add(diffuse,  
				real(string_extract(line," ",1)), 
				real(string_extract(line," ",2)), 
				real(string_extract(line," ",3)));
		
		break;
		
		case "Ks": // specular
		
			var specular = currMtl[?"specular"];
			ds_list_add(specular,  
				real(string_extract(line," ",1)), 
				real(string_extract(line," ",2)), 
				real(string_extract(line," ",3)));
		
		break;
		
		case "Ke": // emission
		
			var emission = currMtl[?"emission"];
			ds_list_add(emission,  
				real(string_extract(line," ",1)), 
				real(string_extract(line," ",2)), 
				real(string_extract(line," ",3)));
		
		break;
		
		case "Ni": // index of refraction (ior)
		
			currMtl[?"ior"] = real(string_extract(line," ",1));
		
		break;
		
		case "d": // dissolve
		
			currMtl[?"dissolve"] = real(string_extract(line," ",1));
		
		break;
		
		case "illum": // illumination model
		
			currMtl[?"illum"] = real(string_extract(line," ",1));
		
		break;
	}
	
}

file_text_close(file);

#endregion