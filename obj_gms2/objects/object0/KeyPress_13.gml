if (model == noone) {
	model = model_load("spacecraft1.obj");
} else {
	model_destroy(model);
	model = noone;
}