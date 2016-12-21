// IIRE SOCIAL LITE - 12/15/2012 - 9:00 AM

jQuery(document).ready(function() {
	
	// ADD TO FAVORITES
	jQuery('div#iire-favorite').bind('click', function(e) {
		e.preventDefault();	

		var sURL = location.href;
		var sTitle = document.title;

		var userAgent = navigator.userAgent.toLowerCase();
		var userBrowserName  = navigator.appName.toLowerCase();
		jQuery.browser = {
			version: (userAgent.match( /.+(?:rv|it|ra|ie)[\/: ]([\d.]+)/ ) || [0,'0'])[1],
			safari: /webkit/.test( userAgent ),
			opera: /opera/.test( userAgent ),
			msie: /msie/.test( userAgent ) && !/opera/.test( userAgent ),
			mozilla: /mozilla/.test( userAgent ) && !/(compatible|webkit)/.test( userAgent ),
			name:userBrowserName
		};
		
		if (window.chrome) {
  			alert ('Press Ctrl+D to bookmark this page in Google Chrome.');			
			return;
		}		
		if (jQuery.browser.safari == true) {
			alert ('Press Ctrl+D (Command+D) to bookmark this page in Apple Safari.');
			return;
		}
		if (jQuery.browser.opera == true) {
			alert ('Press Ctrl+D to bookmark this page in Opera.');
			return;
		}
		if (jQuery.browser.msie == true) {
 			window.external.AddFavorite (sURL,sTitle);			
			return;
		}
		if (jQuery.browser.mozilla == true) {
			window.sidebar.addPanel(sTitle,sURL, "");			
			return;
		}
	});	



	// ICON OPACITY ON MOUSE ENTER
	jQuery('div.opacity').live('mouseenter', function() {
		jQuery(this).css("opacity", "1.00");			
	});	

	// ICON OPACITY ON MOUSE OUT
	var opac = jQuery('div.opacity').css("opacity");
	jQuery('div.opacity').live('mouseout', function() {
		jQuery(this).css("opacity", opac);			
	});

}); // End Document Ready