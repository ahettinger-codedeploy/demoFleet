jQuery(document).ready(function($) {

	$('ul#upcoming li').click(function(){

		window.location = $(this).find('a').attr('href');

	});	

});
