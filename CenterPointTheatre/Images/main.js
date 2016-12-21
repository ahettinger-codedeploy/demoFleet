jQuery(document).ready(function($) {
	
	$(window).scroll(function() {
		if ($(this).scrollTop() > 83){
			$('header#masthead').addClass('sticky');
		} else {
			$('header#masthead').removeClass('sticky');
		}
	});

	var toggle = 0

	$('#menu_mobile > i').click(function() {

		if( toggle == 0 ) {
			toggle = 1
			$('#menu_mobile > i').css("color", "#8c1e33");
			$('.menu_mobile_container').addClass('show slide-up-fade-in');
		} else {
			toggle = 0
			$('.menu_mobile_container').addClass('slide-down-fade-out').delay(500).queue(function() {
				$('.menu_mobile_container').removeClass('show slide-up-fade-in slide-down-fade-out');
				$('#menu_mobile > i').css("color", "#000000");
				$(this).dequeue();
			});
			
		}

	});
	
	$('.social_icon_ft, .social_icon_hd').hover(function() {
		$(this).find('i.fa-stack-2x').removeClass('fa-circle-thin');
		$(this).find('i.fa-stack-2x').addClass('fa-circle');
	},function() {
		$(this).find('i.fa-stack-2x').addClass('fa-circle-thin');
		$(this).find('i.fa-stack-2x').removeClass('fa-circle');
	});
	
	sub_menu_hover($);
	fancybox_image($);
	fancybox_gallery($);
	home_poster($);
	search_form($);
	
});

/*
function sub_menu_hover($) {
	$('#site-navigation #primary-menu > li').hover(function() {
	        if ($(window).width() > 1023) {
	            $(this).find('ul.sub-menu').stop(true, true).addClass('show slide-up-fade-in');
				$('.main-navigation li.has-submenu > a').addClass('hovered');
	        }

	    },
	    function() {
	        if ($(window).width() > 1023) {
	            $(this).find('ul.sub-menu').stop(true, true).addClass('show slide-down-fade-out').delay(500).queue(function() {
					$('ul.sub-menu').removeClass('show slide-up-fade-in slide-down-fade-out');
					$('.main-navigation li.has-submenu > a').removeClass('hovered');
					$(this).dequeue();
				});
		}

	})
}
*/

function sub_menu_hover($) {
	$('#site-navigation #primary-menu > li').hover(function() {
			$(this).find('ul.sub-menu').removeClass('slide-down-fade-out');
			$(this).find('ul.sub-menu').addClass('show slide-up-fade-in');
		},
		function() {
			$(this).find('ul.sub-menu').stop().addClass('slide-down-fade-out');
			$(this).find('ul.sub-menu').removeClass('show slide-up-fade-in');
		}
	);
}

function fancybox_image($) {
	$(".fancybox-img").fancybox({
		openEffect   : 'fade',
		closeEffect  : 'fade',
		maxHeight    : 800
	});
}

function fancybox_gallery($) {
	$(".gallery_img").fancybox({
		openEffect   : 'fade',
		closeEffect  : 'fade',
		maxHeight    : 720
	});
}

// https://jsfiddle.net/yaek2oL4/30/

function home_poster($) {

$('.poster-tilt').mouseenter(function() {

    $(this).mousemove(function(e) {

      var offset = $(this).offset();
      var Xrel = e.pageX - offset.left;
      var Yrel = e.pageY - offset.top;

      var centerX = Xrel - $(this).width() / 2;
      var centerY = Yrel - $(this).height() / 2;

      var x = centerX / 32;
      var y = -centerY / 32;
	  var deg = 45 + centerX/22;
	  var trans = 40 + centerX/15;

      //$('#label').text('X:' + y + ' Y:' + x);

      $(this).css({
        'transform': 'rotateX(' + y + 'deg) rotateY(' + x + 'deg)',
        'transition': '100ms linear all'
      });
	  
	  $(this).find('.poster-gradient').css({
		  'background': 'linear-gradient('+ deg +'deg, rgba(0, 0, 0, 0.8), transparent '+ trans +'%)',
		  'transition': '500ms linear all'
	  });
	  	 
    });

  })
  .mouseleave(function() {
    $(this).css({
      'transform': 'rotateX(0deg) rotateY(0deg)',
      'transition': '300ms linear all'
    });
	  $(this).find('.poster-gradient').css({
		  'background': 'linear-gradient(45deg, rgba(0, 0, 0, 0.8), transparent 40%)',
		  'transition': '500ms ease all'
	  });
  });
  
}

function search_form($) {
	var toggle = 0

	$('.show_search_form').click(function() {

		if( toggle == 0 ) {
			toggle = 1
			$('.show_search_form').css("color", "#000000");
			$('.display_search_form').addClass('show slide-up-fade-in');
		} else {
			toggle = 0
			$('.display_search_form').addClass('slide-down-fade-out').delay(500).queue(function() {
				$('.display_search_form').removeClass('show slide-up-fade-in slide-down-fade-out');
				$('.show_search_form').css("color", "#8c1e33");
				$(this).dequeue();
			});
			
		}

	});
}