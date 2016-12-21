// Displays rotating images on the home page banner using jquery
var rotation_images_count = 6;
var rotation_delay = 5000;
var current_rotation_image = Math.floor(Math.random()*6);

function rotate_rotation_images() {
	for (var i = 0; i < rotation_images_count; i++)
		jQuery('#rotation_image'+i).hide();
	if (current_rotation_image == rotation_images_count)
		current_rotation_image = 0;
	jQuery('#rotation_image'+current_rotation_image).fadeIn();
	current_rotation_image++;
	setTimeout('rotate_rotation_images()', rotation_delay);
}
