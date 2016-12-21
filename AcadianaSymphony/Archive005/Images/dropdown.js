$(document).load(function() {
	$(".down").find("ul").each().slideUp(600).removeClass("down"); //Remove initial subnavs in down state
});  
		
$(document).ready(function() {

	$(".subnav a").click(function() { //When trigger is clicked...  
		$(this).parent().find("ul").slideDown(400).show().addClass("down"); //Drop down the subnav on click  

			$(this).parent().hover(function() {  
				$(this).parent().find("ul").slideUp(600).removeClass("down"); //When the mouse hovers out of the subnav, move it back up  
				});  
	});  
	
});