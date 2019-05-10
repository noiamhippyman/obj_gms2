if (!variable_global_exists("__model_vertex_format")) {
	vertex_format_begin();
	vertex_format_add_position_3d();
	vertex_format_add_texcoord();
	vertex_format_add_normal();
	vertex_format_add_color();
	global.__model_vertex_format = vertex_format_end();
}

return global.__model_vertex_format;