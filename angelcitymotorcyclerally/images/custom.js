/*Image Fade Out */
function image_fade_out(){
jQuery(document).ready(function($) {
$(".imgf,.tagcloud a").css("opacity","1.0");
$(".imgf,.tagcloud a").hover(function () {
$(this).stop().animate({
opacity:0.5
}, "fast");
},
function () {
$(this).stop().animate({
opacity: 1.0
}, "fast");
});
});
}

image_fade_out();




/*Image Fade In */
function image_fade_in(){
jQuery(document).ready(function($) {
$(".imgi").css("opacity","0.4");
$(".imgi").hover(function () {
$(this).stop().animate({
opacity:1.0
}, "fast");
},
function () {
$(this).stop().animate({
opacity: 0.4
}, "fast");
});
});
}

image_fade_in();


/* Image Hover */

function img_hover(){
jQuery(document).ready(function($) {
$(".img_hover").css("opacity","0.0");
$(".img_hover").hover(function () {
$(this).stop().animate({
opacity:1.0
}, "fast");
},
function () {
$(this).stop().animate({
opacity: 0.0
}, "fast");
});
});
}

img_hover();

jQuery(document).ready(function($) {
	
	if($('#custom_tabs,#custom_tabs_1,#custom_tabs_2,#custom_tabs_3,#custom_tabs_4').length){
		
$("#custom_tabs,#custom_tabs_1,#custom_tabs_2,#custom_tabs_3,#custom_tabs_4").organicTabs();

}else{
	
	/* tabs script will not load if not on page */
	
	}
});

/* Superfish */
jQuery(document).ready(function($) {
$("ul.top_menu").superfish({ 
animation: {opacity:'show', height:'show', width:'show'},   // slide-down effect without fade-in 
delay:200,               // 1.2 second delay on mouseout 
autoArrows: false, 
speed: 'fast',
dropShadows: false
}); 
});

jQuery(document).ready(function($) {
	if($('audio').length){
        // Setup the player to autoplay the next track
        var a = audiojs.createAll({
          trackEnded: function() {
            var next = $('ol li.playing').next();
            if (!next.length) next = $('ol li').first();
            next.addClass('playing').siblings().removeClass('playing');
            audio.load($('a', next).attr('data-src'));
            audio.play();
          }
        });
        
        // Load in the first track
		if($("audio").size() == 1){ var $audio_num = 0; } else { var $audio_num = 2; }
        var audio = a[0];
            first = $('ol a').attr('data-src');
        $('ol li').first().addClass('playing');
        audio.load(first);

        // Load in a track on click
        $('ol li').click(function(e) {
          e.preventDefault();
          $(this).addClass('playing').siblings().removeClass('playing');
          audio.load($('a', this).attr('data-src'));
          audio.play();
        });
        // Keyboard shortcuts
        $(document).keydown(function(e) {
          var unicode = e.charCode ? e.charCode : e.keyCode;
             // right arrow
          if (unicode == 39) {
            var next = $('li.playing').next();
            if (!next.length) next = $('ol li').first();
            next.click();
            // back arrow
          } else if (unicode == 37) {
            var prev = $('li.playing').prev();
            if (!prev.length) prev = $('ol li').last();
            prev.click();
            // spacebar
          } else if (unicode == 32) {
            audio.playPause();
          }
        })
		}else{
	
	/* audio script will not load if not on page */
	
	}
      });

     


//Accordion & Toggle Box
jQuery(document).ready(function($) {
	
	// Accordion
	jQuery("ul.gdl-accordion li").each(function(){
		//jQuery(this).children(".accordion-content").css('height', function(){ 
			//return jQuery(this).height(); 
		//});
		
		if(jQuery(this).index() > 0){
			jQuery(this).children(".accordion-content").css('display','none');
		}else{
			//jQuery(this).find(".accordion-head-image").addClass('active');
		}
		
		jQuery(this).children(".accordion-head").bind("click", function(){
			jQuery(this).children().addClass(function(){
				if(jQuery(this).hasClass("active")) return "";
				return "active";
			});
			jQuery(this).siblings(".accordion-content").slideDown();
			jQuery(this).parent().siblings("li").children(".accordion-content").slideUp();
			jQuery(this).parent().siblings("li").find(".active").removeClass("active");
		});
	});
	});
	jQuery(document).ready(function($) {
	
	
	// Toggle Box
	jQuery("ul.gdl-toggle-box li").each(function(){
		//jQuery(this).children(".toggle-box-content").css('height', function(){ 
			//return jQuery(this).height(); 
		//});
		jQuery(this).children(".toggle-box-content").not(".active").css('display','none');
		
		jQuery(this).children(".toggle-box-head").bind("click", function(){
			jQuery(this).children().addClass(function(){
				if(jQuery(this).hasClass("active")){
					jQuery(this).removeClass("active");
					return "";
				}
				return "active";
			});
			jQuery(this).siblings(".toggle-box-content").slideToggle();
		});
	});
	

});


jQuery(document).ready(function($) {
 
        $(window).scroll(function(){
            if ($(this).scrollTop() > 100) {
                $('.scrollup').fadeIn();
            } else {
                $('.scrollup').fadeOut();
            }
        }); 
 
        $('.scrollup').click(function(){
            $("html, body").animate({ scrollTop: 0 }, 600);
            return false;
        });
 
    });
	

jQuery(document).ready(function($) {
$("a#fancybox1").fancybox();
});
jQuery(document).ready(function($) {
$("a[rel=fancybox2]").fancybox({
		'transitionIn'		: 'none',
		'transitionOut'		: 'none',
		'titlePosition' 	: 'over',
		'titleFormat'       : function(title, currentArray, currentIndex, currentOpts) {
		    return '<span id="fancybox-title-over">Image ' +  (currentIndex + 1) + ' / ' + currentArray.length + ' ' + title + '</span>';
		}
	});});

jQuery(document).ready(function($) {
$(".various").fancybox({
		'transitionIn'	: 'none',
		'transitionOut'	: 'none'
	});
});


//sidebar responsive slider
jQuery(document).ready(function($) {
      $("#slider3").responsiveSlides({
        auto: false,
        pager: false,
        nav: true,
        speed: 500,
        maxwidth: 800,
        namespace: "large-btns"
      });

    });


// Slideshow 2
jQuery(document).ready(function($) {
      $("#slider2,#slider4").responsiveSlides({
        auto: false,
        pager: true,
        nav: true,
        speed: 500,
        maxwidth: 800,
        namespace: "transparent-btns"
      });
});
/* Start Document */
jQuery(document).ready(function() {

/*----------------------------------------------------*/
/*	Responsive Menu
/*----------------------------------------------------*/

			// Create the dropdown bases
		/*	jQuery("<select />").appendTo("#navigation"); */
			
			// Create default option "Go to..."
			jQuery("<option />", {
			   "selected": "selected",
			   "value"   : "",
			   "text"    : "Menu"
			}).appendTo("");
			
				
			// Populate dropdowns with the first menu items
			jQuery("#navigation li a").each(function() {
			 	var el = jQuery(this);
			 	jQuery("<option />", {
			     	"value"   : el.attr("href"),
			    	"text"    : el.text()
			 	}).appendTo("#navigation select");
			});
			
				
			//make responsive dropdown menu actually work			
	     	jQuery("#navigation select").change(function() {
		       	window.location = jQuery(this).find("option:selected").val();
		   	});});
			
			function changeLocation(menuObj)
{
   var i = menuObj.selectedIndex;

   if(i > 0)
   {
      window.location = menuObj.options[i].value;
   }
}


	/* Selector DIV */
jQuery(document).ready(function($) {

  $(document)
    .ready(function () {
	
	 $('div.heading h3,div.heading h4')
      .each(function () {
      var h = $(this)
        .html();
      var index = h.indexOf(' ');
      if (index == -1) {
        index = h.length;
      }
      $(this)
        .html('<span class="first_">' + h.substring(0, index) + '</span>' + h.substring(index, h.length));
    });
	
	});

});


	