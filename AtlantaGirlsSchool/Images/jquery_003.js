	/*******************************
	********************************
	********* jQuery Group Plugin **
	********************************
	*********** Alexander Bradley **
	*******************************/

(function($){
	$.fn.group = function(options) {
		
		var settings = {
			'size'		: 2,
			'wrapElem'	: '<div class="group"></div>'
		}
		var grouped = 0;
		
		return this.each(function(i) {
					
			if (options) { 
				$.extend(settings, options);
			}

			var $this = $(this);
			var $temp = null, $wrap= null;		
			
			if ($this.index() === 0) {
				grouped = i;
			}
			
			if((i - grouped) % settings.size === 0) {    
				$temp = $(this), $wrap = $(this);
				for (var j = 0; j < settings.size - 1; j++) {
					if ($temp.next() && $temp.next().index() !== 0) {
						$wrap = $wrap.add($temp = $temp.next());
					}
				}
  			    $wrap.wrapAll(settings.wrapElem);
			}
		});
	};
})(jQuery);