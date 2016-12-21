jQuery.noConflict();
jQuery(document).ready(function(){
	
	jQuery(".project.small img").hover(
		function() {
			jQuery(this).stop().fadeTo("fast", .5);
		},
		function() {
			jQuery(this).stop().fadeTo("fast", 1);
	});
	
	jQuery(".gallery a").attr('rel', 'gallery').fancybox({
			'overlayColor'	:	'#000',
			'titleShow'	:	false,
			'titlePosition'	:	'inside'
	});
	
	jQuery("a.lightbox").fancybox({
			'overlayColor'	:	'#000',
			'titleShow'	:	false,
			'titlePosition'	:	'inside'
	}); 
	
});