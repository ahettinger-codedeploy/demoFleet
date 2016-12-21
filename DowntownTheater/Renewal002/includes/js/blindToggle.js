	jQuery.fn.blindToggle = function(speed, easing, callback) 
	{
	var h = (this.height() + parseInt(this.css('paddingTop')) + parseInt(this.css('paddingBottom')) + 0);
	return this.animate({marginTop: parseInt(this.css('marginTop')) < 3 ? 3 : -h}, speed, easing, callback);  
	};

	jQuery.fn.slideFadeToggle = function(speed, easing, callback) 
	{
	return this.animate({opacity: 'toggle', height: 'toggle'}, speed, easing, callback);  
	};

	$('#btn-options').click(function() 
	{
		$('#panel-options .panel-inner').blindToggle(1000, 'easeInOutQuart');
	}); 
