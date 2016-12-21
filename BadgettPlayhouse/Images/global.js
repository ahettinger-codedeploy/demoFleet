// Place all 'onload' items inside the following block

$(document).ready(function() {

	// Initialize the navigation rollovers
	$('#main_nav a').each(function() {
		$(this).hover(function(){
			$(this).css('background', 'url(../images/navigation/' + $(this).attr('id') + '_on.gif) no-repeat');
		},function(){
			$(this).css('background', 'none');
		});
	});

});

//home page main content slideshow
function slideSwitch() {
    var $active = $('#slideshow div.active');

    if ( $active.length == 0 ) $active = $('#slideshow div:last');

    var $next =  $active.next().length ? $active.next()
        : $('#slideshow div:first');

    $active.addClass('last-active');

    $next.css({opacity: 0.0})
        .addClass('active')
        .animate({opacity: 1.0}, 1000, function() {
            $active.removeClass('active last-active');
        });
}

$(function() {
    setInterval( "slideSwitch()", 6000 );
});


////////////////////
//toggle status
//Browser Support Code
function getCalMonth(month,year){
	var ajaxRequest;  // The variable that makes Ajax possible!
	
	try{
		// Opera 8.0+, Firefox, Safari
		ajaxRequest = new XMLHttpRequest();
	} catch (e){
		// Internet Explorer Browsers
		try{
			ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try{
				ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e){
				// Something went wrong
				alert("Your browser broke!");
				return false;
			}
		}
	}
	// Create a function that will receive data sent from the server
	ajaxRequest.onreadystatechange = function(){
		if(ajaxRequest.readyState == 4){
			var ajaxDisplay = document.getElementById('calDiv');
			ajaxDisplay.innerHTML = ajaxRequest.responseText;
		}
	}

	
	var queryString = "?m=" + month + "&y=" + year;
	ajaxRequest.open("GET", "../calendar/calendar-new.php" + queryString, true);
	ajaxRequest.send(null); 
}