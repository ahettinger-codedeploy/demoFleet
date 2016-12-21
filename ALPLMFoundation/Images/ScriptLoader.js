if ($) {
	$(document).ready(
		function() {
			$('#youtubebtn').hover(
				function() {
				  $(this).attr("src", "/alplm/Style%20Library/StateHome/Images/youtubeFade.png");
				}, 
				function() {
				  $(this).attr("src", "/alplm/Style%20Library/StateHome/Images/youtubeGreyFade.png");
				}
			);
			$('#twitterbtn').hover(
				function() {
				  $(this).attr("src", "/alplm/Style%20Library/StateHome/Images/TwitterFade.png");
				}, 
				function() {
				  $(this).attr("src", "/alplm/Style%20Library/StateHome/Images/TwitterGreyFade.png");
				}
			);
			$('#facebookbtn').hover(
				function() {
				  $(this).attr("src", "/alplm/Style%20Library/StateHome/Images/FacebookFade.png");
				}, 
				function() {
				  $(this).attr("src", "/alplm/Style%20Library/StateHome/Images/FacebookGreyFade.png");
				}
			);
			$('#rssbtn').hover(
				function() {
				  $(this).attr("src", "/alplm/Style%20Library/StateHome/Images/RssFade.png");
				}, 
				function() {
				  $(this).attr("src", "/alplm/Style%20Library/StateHome/Images/RssGreyFade.png");
				}
			);
			$('#tumblrbtn').hover(
				function() {
				  $(this).attr("src", "/alplm/Style%20Library/StateHome/Images/Tumblr.png");
				}, 
				function() {
				  $(this).attr("src", "/alplm/Style%20Library/StateHome/Images/TumblrGreyFade.png");
				}
			);
		}
		
	);
}    
