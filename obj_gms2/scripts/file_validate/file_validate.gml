/// @func file_validate
/// @args filename,ext
/// @desc Checks if a file exists and if it's the expected filetype
var filename = argument0;
var ext = argument1;

if (!file_exists(filename)) {
	show_error("File not found - " + filename, true);
}

if (filename_ext(filename) != ext) {
	show_error("Filetype not " + string(ext) + " - " + filename, true);
}