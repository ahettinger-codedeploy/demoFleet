$(document).ready( function() {
     initMenu();
     $(".trans").css("opacity", "0.5");
     //jQuery.getScript("/loadbg.js");

    var bgURL = "url(" + $("#hidden-block span:first").html() + ")";

    $("#wrapper").css("background-image", bgURL);

     $('#top-photos a').lightBox({fixedNavigation:true});

     $(document).bind("contextmenu",function(e){
	return false;
     });

});