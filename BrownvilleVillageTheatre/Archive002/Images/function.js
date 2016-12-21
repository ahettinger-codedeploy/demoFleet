//Responsive Navigation Dropdown
function goHorizontal() {
location=document.getElementById('dropdown-horizontal').value;
}

function goVertical() {
location=document.getElementById('dropdown-vertical').value;
}

$(document).ready(function() {
		$('a[href=#toplink]').hide();
});

// Back to Top
$(window).scroll(function () {
	if ($(this).scrollTop() > 100) {
		$('a[href=#toplink]').fadeIn();
	} else {
		$('a[href=#toplink]').fadeOut();
	}
});

$('a[href=#toplink]').on('click', function(){
	$('html, body').animate({scrollTop:0}, 'slow');
	return false;
});

// Top Bar Toggle
$(".top-bar-show-hide").click(function () {
$("#top-bar").slideToggle("slow");
});

// Change Default C5 Button classes

	//Search Button
	$(".ccm-search-block-submit").addClass("button");
	$(".ccm-search-block-submit").removeClass("ccm-search-block-submit");
	
	//Form Submit Button
	$(".formBlockSubmitButton").addClass("button");
	
	//Catch All Submits
	$('input[type=submit]').addClass('button');