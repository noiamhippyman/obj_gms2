/// @func model_draw
/// @args model,texture,[matrix_or_][x,y,z,xrot,yrot,zrot,xscale,yscale,zscale]
var model = argument[0];
var texture = argument[1];
var matrix;

if (argument_count == 2) {
	matrix = matrix_build(0,0,0,0,0,0,1,1,1);
}else if (argument_count == 3) {
	matrix = argument[2];
} else if (argument_count == 11) {
	var mx = argument[2];
	var my = argument[3];
	var mz = argument[4];
	var mxr = argument[5];
	var myr = argument[6];
	var mzr = argument[7];
	var mxs = argument[8];
	var mys = argument[9];
	var mzs = argument[10];
	matrix = matrix_build(mx,my,mz,mxr,myr,mzr,mxs,mys,mzs)
}

shader_set(shader_model);
matrix_set(matrix_world, matrix);

if (ds_exists(model,ds_type_list)) {
	
	var count = ds_list_size(model);
	for (var i = 0; i < count; ++i) {
		var mesh = model[|i];
		vertex_submit(mesh,pr_trianglelist,texture);
	}
	
} else {
	vertex_submit(model,pr_trianglelist,texture);
}

matrix_set(matrix_world, matrix_build_identity());
shader_reset();