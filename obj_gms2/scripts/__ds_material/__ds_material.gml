var material = ds_map_create();

ds_map_add(material,"specularExponent",0);
ds_map_add_list(material,"ambient",ds_list_create());
ds_map_add_list(material,"diffuse",ds_list_create());
ds_map_add_list(material,"specular",ds_list_create());
ds_map_add_list(material,"emission",ds_list_create());
ds_map_add(material,"ior",0);
ds_map_add(material,"dissolve",0);
ds_map_add(material,"illum",0);

return material;