var t;
var t2;
var slidetimeout = 6000;
var timing = 400;

function switchCCCSlides() {
	clearTimeout(t);

	var $slider = $(".box-1");

	if ($slider.is(".slide3")){
		$('.box-1').stop().animate({
		    opacity: 0,
		  }, timing, function() {
			$('.home-slide-text').hide();
			$('.home-slide-text.celebrate').show();
		    $(this).removeClass('slide2').removeClass('slide3').addClass('slide1');
		    $(this).animate({
			    opacity: 1,
			  }, timing, function() {});
		  });
	}
	if ($slider.is(".slide1")){
		$('.box-1').stop().animate({
		    opacity: 0,
		  }, timing, function() {
			$('.home-slide-text').hide();
			$('.home-slide-text.connect').show();
			 $(this).removeClass('slide1').removeClass('slide3').addClass('slide2');
		    $(this).animate({
			    opacity: 1,
			  }, timing, function() {});
		  });
	}
	if ($slider.is(".slide2")){
		$('.box-1').stop().animate({
		    opacity: 0,
		  }, timing, function() {
			$('.home-slide-text').hide();
			$('.home-slide-text.contribute').show();
			 $(this).removeClass('slide1').removeClass('slide2').addClass('slide3');
		    $(this).animate({
			    opacity: 1,
			  }, timing, function() {});
		  });
	}

	t = setTimeout("switchCCCSlides()", slidetimeout);
}

function switchEventsSlides(target) {
	clearTimeout(t2);
	var targetSlide = target || 0;
	$('.events-controller-item').removeClass('active');

	$slidesCount = $(".event-slide-couple").not(".disable").size();

	for (var i=0; i < $slidesCount; i++){
		var k = ((i+2) <= $slidesCount) ? (i+2) : ((i+2)%$slidesCount);
		if (targetSlide == k || (targetSlide == 0 && $('#event-'+(i+1)+'-copy').is(':visible'))){
			$('.events-controller-item').eq((i+1)%$slidesCount).addClass("active");
			$('.events-copy').fadeOut();
			$('.event-slide-couple').stop().animate({
				opacity: 0,
			  }, timing, function() {
				  $('.event-slide-couple').hide();
				  $('#event-slide-'+k).children().first().show();
				  $('#event-slide-'+k).show().animate({
				    opacity: 1,
				  }, timing, function() {});
				  $('#event-'+k+'-copy').fadeIn();
			  });
			
			$(".event-slide.hover").hide();
			t2 = setTimeout("switchEventsSlides()", slidetimeout);
			break;
		}
	}

}

$(document).ready(function(){

t = setTimeout("switchCCCSlides()", slidetimeout);
t2 = setTimeout("switchEventsSlides()", 3000);

$(".events-controller-item").click(function(){
	switchEventsSlides($(this).index()+1);
});

var slideIndexDisable = 0; 
$(".event-slide-couple").each(function(){
	if ($(this).is(".disable")){
		$(".events-controller-item").eq(slideIndexDisable).hide();
	}
	slideIndexDisable++;
});

$("#events-slider-container-left").hover(
		function () {
			$bw = $(this).find(".event-slide:visible");
			$color = $bw.next();
			$bw.hide();
			$color.show();
		},
		function () {
			$(this).find(".event-slide.hover:visible").hide().prev().show();
		}
);


$(".learn-more-container .learn-more-right").stick_in_parent();
$("#location-add-social").stick_in_parent({parent: $("body"), offset_top: 1000});


//Patchy fix to location home button anchors
if ($("#location-news-bottom").size()>0){
	var i = 0;
	$(this).find("a.btn").each(function(){
		if ($(this).closest(".church-lowright-box").size()==0){
			$(this).attr("href","learn-more/#title-"+i);
			$(this).parent().contents().filter(function() { return this.nodeType == 3; }).remove();
			i++;
		}
	});
	var i = 0;
	$("#location-news-bottom .posts-list .row-fluid").each(function(){
		if ($(this).find("figure a").size() > 0){
			$(this).find("figure a").first().attr("href","learn-more/#title-"+i);
		}
		i++;
	});
	var i = 0;
	$("#location-news-bottom .posts-list .post-header .post-title a").each(function(){
		$(this).attr("href","learn-more/#title-"+i);
		i++;
	});
}
	
// ---------------------------------------------------------
// CustomSlider
// ---------------------------------------------------------
$('.home .box-1').find("span.meta").mouseenter(function(){
	$(this).closest('.recent-posts_li').find('span.post-month').css('visibility','visible');
	if ($(this).closest('.celebrate').size()>0){
		$('.box-1').stop().animate({
		    opacity: 0,
		  }, timing, function() {
			$('.home-slide-text').hide();
			$('.home-slide-text.celebrate').show();
		    $(this).removeClass('slide2').removeClass('slide3').addClass('slide1');
		    $(this).animate({
			    opacity: 1,
			  }, timing, function() {});
		  });
	}
	if ($(this).closest('.connect').size()>0){
		$('.box-1').stop().animate({
		    opacity: 0,
		  }, timing, function() {
			$('.home-slide-text').hide();
			$('.home-slide-text.connect').show();
			 $(this).removeClass('slide1').removeClass('slide3').addClass('slide2');
		    $(this).animate({
			    opacity: 1,
			  }, timing, function() {});
		  });
	}
	if ($(this).closest('.contribute').size()>0){
		$('.box-1').stop().animate({
		    opacity: 0,
		  }, timing, function() {
			$('.home-slide-text').hide();
			$('.home-slide-text.contribute').show();
			 $(this).removeClass('slide1').removeClass('slide2').addClass('slide3');
		    $(this).animate({
			    opacity: 1,
			  }, timing, function() {});
		  });
	}
}).mouseleave(function(){
	$(this).closest('.recent-posts_li').find('span.post-month').css('visibility','hidden');
});

//---------------------------------------------------------
//Equalize boxes heights
//---------------------------------------------------------
if ($(".page-template-page-ourCommunity-php, .page-template-page-thisWeekend-php, .page-template-event1-php, .page-template-event2-php, .page-template-event3-php").size()==0){
	$(".portfolio_item_holder").each(function(){
		$(this).css('min-height', '500px');
	});

	$(".page-template-page-whatWeBelieve-php .portfolio_item_holder").each(function(){
		$(this).css('min-height', '470px');
	});
}
$(".page-template-page-ourCommunity-php .portfolio_item_holder").each(function(){
	$(this).find("a").css('position', 'relative').css('margin-top', '10px');
});

// ---------------------------------------------------------
// Prettyphoto
// ---------------------------------------------------------
	var viewportWidth = $('body').innerWidth();
	$("a[rel^='prettyPhoto']").prettyPhoto({
		overlay_gallery: true,
		theme: 'pp_default',
		social_tools: false,
	 	changepicturecallback: function(){
			// 767px is presumed here to be the widest mobile device. Adjust at will.
			if (viewportWidth < 767) {
			   $(".pp_pic_holder.pp_default").css("top",window.pageYOffset+"px");
			}
		}
	});
// ---------------------------------------------------------
// Tooltip
// ---------------------------------------------------------
	$("[rel='tooltip']").tooltip();
// ---------------------------------------------------------
// Back to Top
// ---------------------------------------------------------
	$(window).scroll(function () {
		if ($(this).scrollTop() > 100) {
			$('#back-top').fadeIn();
		} else {
			$('#back-top').fadeOut();
		}
	});
	$('#back-top a').click(function () {
		$('body,html').stop(false, false).animate({
			scrollTop: 0
		}, 800);
		return false;
	});
// ---------------------------------------------------------
// Add accordion active class
// ---------------------------------------------------------
	$('.accordion').on('show', function (e) {
        $(e.target).prev('.accordion-heading').find('.accordion-toggle').addClass('active');
    });
    $('.accordion').on('hide', function (e) {
        $(this).find('.accordion-toggle').not($(e.target)).removeClass('active');
    });
// ---------------------------------------------------------
// Isotope Init
// ---------------------------------------------------------
	$("#portfolio-grid").css({"visibility" : "visible"});
// ---------------------------------------------------------
// Menu Android
// ---------------------------------------------------------
	/*
	if(window.orientation!=undefined){
		var regM = /ipod|ipad|iphone/gi,
			result = navigator.userAgent.match(regM)
		if(!result) {
			$('.sf-menu li').each(function(){
				if($(">ul", this)[0]){
					$(">a", this).toggle(
						function(){
							return false;
						},
						function(){
							window.location.href = $(this).attr("href");
						}
					);
				} 
			})
		}
	}
	*/
});