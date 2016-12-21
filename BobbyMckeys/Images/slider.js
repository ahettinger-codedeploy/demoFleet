$.fn.slider = function(options) {

	var defaults = {
		speed : '4000'
	};
	var settings = $.extend({}, defaults, options);
   
	return this.each(function() {
		$slideshow = $(this);
		numberSlides($slideshow);
		$slideshow.find('li').css({opacity: 0.0}).addClass('hide');
		$slideshow.find('li:first').css({opacity: 1.0}).addClass('show').removeClass('hide');
		slide($slideshow);
	});

	function numberSlides($slideshow) {
		$slideshow.find('li').each(function(index){
			slideNum = index+1;
			$(this).addClass('slide-'+slideNum);
		});
	}
	
	function slide($slideshow) {
		$current = currentSlide($slideshow);
		$next = nextSlide($slideshow);
		$current.animate({opacity: 0.0}).queue(function(){
			$(this).removeClass('show')
			.addClass('hide')
			.attr('style', '')
			.dequeue();
		});
		$next.animate({opacity: 1.0}).queue(function(){
			$(this).removeClass('hide')
			.addClass('show')
			.attr('style', '')
			.dequeue();
		}).delay(settings.speed).queue(function(){
			slide($slideshow);
			$(this).dequeue();
		});
			
	}
	
	function nextSlide($slideshow) {
		var $current = currentSlide($slideshow);
		if($current.next().size()>0)
			$next = $current.next();
		else
			$next = firstSlide($slideshow);
		return $next;
	}
	
	function currentSlide($slideshow) {
		return $slideshow.find('li.show');
	}
	
	function firstSlide($slideshow) {
		return $slideshow.find('li:first');
	}	
}