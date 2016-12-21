/* =========================================================

// jquery.innerfade.js

// Datum: 2008-02-14
// Firma: Medienfreunde Hofmann & Baldes GbR
// Author: Torsten Baldes
// Mail: t.baldes@medienfreunde.com
// Web: http://medienfreunde.com

// based on the work of Matt Oakes http://portfolio.gizone.co.uk/applications/slideshow/
// and Ralf S. Engelschall http://trainofthoughts.org/

 *
 *  <ul id="news"> 
 *      <li>content 1</li>
 *      <li>content 2</li>
 *      <li>content 3</li>
 *  </ul>
 *  
 *  $('#news').innerfade({ 
 *	  animationtype: Type of animation 'fade' or 'slide' (Default: 'fade'), 
 *	  speed: Fading-/Sliding-Speed in milliseconds or keywords (slow, normal or fast) (Default: 'normal'), 
 *	  timeout: Time between the fades in milliseconds (Default: '2000'), 
 *	  type: Type of slideshow: 'sequence', 'random' or 'random_start' (Default: 'sequence'), 
 * 		containerheight: Height of the containing element in any css-height-value (Default: 'auto'),
 *	  runningclass: CSS-Class which the container get’s applied (Default: 'innerfade'),
 *	  children: optional children selector (Default: null)
 *  }); 
 *

// ========================================================= */

( function($) {

	$.fn.innerfade = function(options) {


		return this.each( function() {
			$.innerfade(this, options);
		});
	};

	$.innerfade = function(container, options) {
		var settings = {
			'animationtype' : 'fade',
			'speed' : 2000,
			'type' : 'sequence',
		//	'type' : 'random',
			'timeout' : 5000,
			'containerheight' : '310px',
			'runningclass' : 'innerfade',
			'children' : null,
			'onStartedProcessing' : null,
			'onFinishedProcessing' : null

		};
		
		if (options) {
		
		if (options['onStartedProcessing'])
			$.innerfade.onStartedProcessing = options['onStartedProcessing'];
		if (options['onFinishedProcessing'])
			$.innerfade.onFinishedProcessing = options['onFinishedProcessing'];
		
		}

		if (options)
			$.extend(settings, options);
		if (settings.children === null)
			var elements = $(container).children();
		else
			var elements = $(container).children(settings.children);

		if (elements.length > 1) {
			$(container).css('position', 'relative').css('height',
					settings.containerheight).addClass(settings.runningclass);
			for ( var i = 0; i < elements.length; i++) {
				$(elements[i]).css('z-index', String(elements.length - i)).css(
						'position', 'absolute').hide();
			}
			
			if ($.innerfade.onStartedProcessing != null) {
				$.innerfade.onStartedProcessing(elements, settings, 0, 0);
			}
			
			if ($.innerfade.onFinishedProcessing != null) {
				$.innerfade.onFinishedProcessing(elements, settings, 0, 0);
			}
			
			if (settings.type == "sequence") {
				setTimeout( function() {
					$.innerfade.next(elements, settings, 1, 0);
				}, settings.timeout);
				$(elements[0]).show();
			} else if (settings.type == "random") {
				var last = Math.floor(Math.random() * (elements.length));
				setTimeout(
						function() {
							do {
								current = Math.floor(Math.random()
										* (elements.length));
							} while (last == current);
							$.innerfade.next(elements, settings, current, last);
						}, settings.timeout);
				$(elements[last]).show();
			} else if (settings.type == 'random_start') {
				settings.type = 'sequence';
				var current = Math.floor(Math.random() * (elements.length));
				setTimeout( function() {
					$.innerfade.next(elements, settings, (current + 1)
							% elements.length, current);
				}, settings.timeout);
				$(elements[current]).show();
			} else {
				alert('Innerfade-Type must either be \'sequence\', \'random\' or \'random_start\'');
			}
		}
	};

	$.innerfade.next = function(elements, settings, current, last) {
		if (this.onStartedProcessing != null) {
			this.onStartedProcessing(elements, settings, current, last);
		}

		if (settings.animationtype == 'slide') {
			$(elements[last]).slideUp(settings.speed);
			$(elements[current]).slideDown(settings.speed);
		} else if (settings.animationtype == 'fade') {
			$(elements[last]).fadeOut(settings.speed);
			$(elements[current]).fadeIn(settings.speed, function() {
				removeFilter($(this)[0]);
			});
		} else
			alert('Innerfade-animationtype must either be \'slide\' or \'fade\'');
		if (settings.type == "sequence") {
			if ((current + 1) < elements.length) {
				current = current + 1;
				last = current - 1;
			} else {
				current = 0;
				last = elements.length - 1;
			}
		} else if (settings.type == "random") {
			last = current;
			while (current == last)
				current = Math.floor(Math.random() * elements.length);
		} else
			alert('Innerfade-Type must either be \'sequence\', \'random\' or \'random_start\'');

		if (this.onFinishedProcessing) {
			this.onFinishedProcessing(elements, settings, current, last);
		}

		setTimeout(( function() {
			$.innerfade.next(elements, settings, current, last);
		}), settings.timeout);
	};

})(jQuery);

// **** remove Opacity-Filter in ie ****
function removeFilter(element) {
	if (element.style.removeAttribute) {
		element.style.removeAttribute('filter');
	}
}

function showTitle(element) {
	var title = $(element).attr('title');
	var copy = $(element).attr('alt');
	$('.message strong').html('');
	$('.message').hide();
	if (title != '') {
		$('.message strong').html(title);
		$('.message').fadeIn();
	}
	
	$('.media small').html('');
	$('.media small').hide();
	if (copy != '' && (copy.substr(0,1) == '©' )) {
		$('.media small').html(copy);
		$('.media small').fadeIn();
	}
}
