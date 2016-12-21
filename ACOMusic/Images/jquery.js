(function($) {
		  
$.fn.topmenu = function ()
{
	return this.each(function() {

		var dropdown = this;
	
		$('li', dropdown).hover(
			function() {
				$(this).addClass("hover");
				$('ul', this).fadeIn('fast');
			}, 
			function() {
				$(this).removeClass("hover");
				$('ul', this).hide();
			}
		);
//		$('li', dropdown).click(
//			function() {
//				var url = $('a', this).attr('href');
//				if (url)
//				{
//					window.location.href = url;
//					return false;
//				}
//			}
//		);
	});
}  
		  
})(jQuery);