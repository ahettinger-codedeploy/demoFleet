// Based on ideas in http://www.kalzumeus.com/2010/06/07/detecting-bots-in-javascrip/
// If this code is executed, we are guessing the client is human. Hide the captcha and 
// attach a hidden field with calculated values.
function setup_captcha()
{
	// Attach to all forms that have an element with class captcha (usually a <p>).
	jQuery('form').each(function(){
		var a = Math.floor(Math.random()*11);
		var b = Math.floor(Math.random()*11);
		var check = a + ',' + b + ',' + (a + b);
		var calc = jQuery('<input type="hidden" name="captchaValue">').attr('value', check);
		jQuery(this).find('.captcha').append(calc).hide();
	});
}

jQuery(document).ready(function($){
	setup_captcha();
});
