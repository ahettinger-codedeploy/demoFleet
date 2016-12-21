document.observe("dom:loaded", function() {
	$('subscription_dropdown_trigger').observe('mouseenter', function() {
		$('subscription_dropdown').addClassName('visible');
	});
	$('subscribe_and_save_container').observe('mouseleave', function() {
		$('subscription_dropdown').removeClassName('visible');
	});
});