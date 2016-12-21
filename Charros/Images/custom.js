// initialise plugins for Superfish Top Menu
	jQuery(function(){
		jQuery('ul.sf-menu').superfish();
	});
	

// initialise custom font settings
$(document).ready(function(){
	
		if ($('meta[name="enable_cufon"]').attr('content') != "false") {
			Cufon.replace('h1', { fontFamily: 'GeosansLight' });
			Cufon.replace('h2', { fontFamily: 'GeosansLight' });
			Cufon.replace('h3', { fontFamily: 'GeosansLight' });
			Cufon.replace('.portfolio .h4', { fontFamily: 'GeosansLight' });
			//Cufon.replace('.portfolio p', { fontFamily: 'ftra' });
			Cufon.replace('h4', { fontFamily: 'myriad' });
			Cufon.replace('.inquire-button', { fontFamily: 'myriad' });
			Cufon.replace('.button-1', { fontFamily: 'myriad' });
			Cufon.replace('.button-2', { fontFamily: 'myriad' });
		
			//Cufon.replace('.sf-menu a', { fontFamily: 'myriad' });
		}
});	
			
// Gallery image hover	
function portfolio_img_hover($hover_class) {
	jQuery('.'+$hover_class).hover(
		function() {
				jQuery(this).find('.hover_fade').stop().animate({opacity:0.4},400);
			},
			function() {
				jQuery(this).find('.hover_fade').stop().animate({opacity:1},400);
			});
}

$(document).ready(function(){
	var effect = $('meta[name="hover_effect"]').attr('content');
	if (effect == 'Zoom and Stretch') {
		//Larger thumbnail preview 
		$(".thumb").hover(function() {
			$(this).css({'z-index' : '10'});
			$(this).find('img').addClass("hover").stop()
				.animate({
					marginTop: '-50px', 
					marginLeft: '-23px',
					width: '316px', 
					height: '208px',
					padding: '11px'
					
				}, 200);
		
			} , function() {
			$(this).css({'z-index' : '0'});
			$(this).find('img').removeClass("hover").stop()
				.animate({
					marginTop: '0', 
					marginLeft: '0',
					width: '292px', 
					height: '114px', 
					padding: '0px'
					
				}, 400);
		});	
	} else {
		$('.thumb').each(function() {	
			var link = $(this).find('a').attr('href');
			if (link.search("vimeo.com") > -1) {
				$(this).addClass('acc-overlay-video');
			} else if (link.search("youtube.com") > -1) {
				$(this).addClass('acc-overlay-video');
			} else {
				$(this).addClass('acc-overlay-image');
			} 
		});
		$(".thumb").hover(function() {
				$(this).find('img').stop().animate({
					'opacity' : .5
				}, 750);		
			} , function() {
				$(this).find('img').stop().animate({
					'opacity' : 1
				}, 750);	
		});
	}
});	


//HOME GLIDESLIDER BEGINS HERE
$(document).ready(function() {
//Show the paging and activate its first link
$(".paging").show();
$(".paging a:first").addClass("active");

//Get size of the image, how many images there are, then determin the size of the image reel.
var imageWidth = $(".window").width();
var imageSum = $(".image_reel img").size();
var imageReelWidth = imageWidth * imageSum;

//Adjust the image reel to its new size
$(".image_reel").css({'width' : imageReelWidth});

//Paging  and Slider Function
rotate = function(){
    var triggerID = $active.attr("rel") - 1; //Get number of times to slide
    var image_reelPosition = triggerID * imageWidth; //Determines the distance the image reel needs to slide

    $(".paging a").removeClass('active'); //Remove all active class
    $active.addClass('active'); //Add active class (the $active is declared in the rotateSwitch function)

    //Slider Animation
    $(".image_reel").animate({
        left: -image_reelPosition
    }, 500 );

}; 

//Rotation  and Timing Event
rotateSwitch = function(){
    play = setInterval(function(){ //Set timer - this will repeat itself every 7 seconds
        $active = $('.paging a.active').next(); //Move to the next paging
        if ( $active.length === 0) { //If paging reaches the end...
            $active = $('.paging a:first'); //go back to first
        }
        rotate(); //Trigger the paging and slider function
    }, 3000); //Timer speed in milliseconds (3 seconds)
};

rotateSwitch(); //Run function on launch

//On Hover
$(".image_reel a").hover(function() {
    clearInterval(play); //Stop the rotation
}, function() {
    rotateSwitch(); //Resume rotation timer
});	

//On Click
$(".paging a").click(function() {
    $active = $(this); //Activate the clicked paging
    //Reset Timer
    clearInterval(play); //Stop the rotation
    rotate(); //Trigger rotation immediately
    rotateSwitch(); // Resume rotation timer
    return false; //Prevent browser jump to link anchor
});
//HOME SLIDER ENDS HERE
});














