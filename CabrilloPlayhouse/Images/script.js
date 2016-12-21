// JavaScript Document
				
				var slideshowTimer = 0;
				
                $(document).ready(function(){	
					
					$(".active").animate({opacity: 1.0}, 1000, function() {});
                    $(".thumbs-links a").click(function(){
						clearInterval(slideshowTimer);
						var index = $(".thumbs-links a").index(this);
						var nextImage = $("#slideshow-images img").eq(index);
						var next = $('.thumbs div').eq(index);
						switchImage(next, nextImage);
                    });
                });
				
				function slideshow() {
					slideshowTimer = setInterval('switchImage()',6000);  
				}
				
				function switchImage(nxt, nxtImg) {
					var $active = $('.thumbs div.active');
					var $activeimg = $('#slideshow-images img.active-img');
					var $next;
					var $nextimg;
					
					if(nxt){
						$next = nxt;
						$nextimg = nxtImg;
					}else{
						$next =  $active.next().length ? $active.next()
						: $('.thumbs div:first');
						$nextimg =  $activeimg.next().length ? $activeimg.next()
						: $('#slideshow-images img:first');
					}

					$(".active").animate({opacity: 0.0}, 500, function() {
							 animIn($nextimg,$activeimg,$next,$active);
							});
			
				}
				
				function animIn($nextimg,$activeimg,$next,$active){
						$active.removeClass('active');
						$next.addClass('active');
						$activeimg.addClass('last-active-img');
						$nextimg.addClass('active-img');
						
						$(".active").animate({opacity: 1.0}, 1000, function() {});
	
						$nextimg.css({opacity: 0.0})
						.addClass('active-img')
						.animate({opacity: 1.0}, 1000, function() {
							$activeimg.removeClass('active-img last-active-img');
							
						 });
					}