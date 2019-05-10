// You need to set these both to true
// Otherwise rendering will not look right
// Read the docs if you want more info
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);

model = model_load("suzanne-multimesh-colored-wmaterials.obj");