// Newsletter status constants.
var NEWSLETTER_SIGNUP_REQUESTED = 1;
var NEWSLETTER_SIGNUP_SUBMITTED = 2;
var NEWSLETTER_SIGNUP_COOKIE_NAME = 'newsletter_signup_v20';
var NEWSLETTER_SIGNUP_EXPIRATION = 365;
var NEWSLETTER_SIGNUP_FORM_URL = '/news' + 'letter' + '/form.h' + 'tml';
var NEWSLETTER_SIGNUP_POST_URL = '/news' + 'letter' + '/signup.p' + 'hp';

$(function() {
	if (!hasNewsletterCookie()) {
		setNewsletterCookie(NEWSLETTER_SIGNUP_REQUESTED);
		$.get(NEWSLETTER_SIGNUP_FORM_URL, function(content) {
			$(content).appendTo('body');
			
			$("#newsletter-image").one("load", function() {
				$(this).show();
				$('#newsletter-signup').css("top", "100px")
					.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()) + "px");
				$('#dim-bg').show();
			}).each(function() {
				if(this.complete) $(this).load();
			});
			
			$(document).mouseup(function(e){
				var container = $("#newsletter-signup");

				if (!container.is(e.target) 
					&& container.has(e.target).length === 0) {
					$("#newsletter-signup").remove();
				$('#dim-bg').remove();
				}
			});
			
			$("#newsletter-signup .signup-close").on('click', function(){
				$("#newsletter-signup").remove();
				$('#dim-bg').remove();
			});
			$("#newsletter-signup .signup-submit").on('click', function(){
				var emailAddress = $("#newsletter-signup-email-address").val(),
				    validEmailRegEx = /\S+@\S+\.\S+/;
				
				if (!emailAddress || !validEmailRegEx.test(emailAddress)) {
					alert("Please enter a valid email address.");
					return;
				}
				
				setNewsletterCookie(NEWSLETTER_SIGNUP_SUBMITTED);
				
				$.post(NEWSLETTER_SIGNUP_POST_URL, {email: emailAddress}, function(){
					$("#newsletter-signup").remove();
					$('#dim-bg').remove();
					$("#newsletter-signup-email-address").val();
				});
			});
		});
	}
});

function setNewsletterCookie(status) {
    var expires,
	    name = NEWSLETTER_SIGNUP_COOKIE_NAME,
		value = status,
		days = NEWSLETTER_SIGNUP_EXPIRATION;

    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        expires = "; expires=" + date.toGMTString();
    } else {
        expires = "";
    }
    document.cookie = encodeURIComponent(name) + "=" + encodeURIComponent(value) + expires + "; path=/";
}

function hasNewsletterCookie() {
    var name = NEWSLETTER_SIGNUP_COOKIE_NAME,
	    nameEQ = encodeURIComponent(name) + "=",
        ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) === ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) === 0) return decodeURIComponent(c.substring(nameEQ.length, c.length));
    }
    return null;
}