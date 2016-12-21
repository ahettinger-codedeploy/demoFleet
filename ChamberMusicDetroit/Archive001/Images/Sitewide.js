/*jslint onevar: true, browser: true, undef: true, nomen: true, eqeqeq: true, plusplus: true, bitwise: true, regexp: true, newcap: true, immed: true */
// Suckerfish menu preparation for IE, found on htmldog.com - modified to use jQuery
$(document).ready(function () {
	// Suckerfish menu preparation for IE, found on htmldog.com - modified to use jQuery and work with iOS devices 
	$('ul.drop-menu li.item').hover(function () { 
		$('ul.drop-menu li.item').removeClass('sfhover'); 
		$(this).addClass('sfhover'); 
	}, function () { 
		$('ul.drop-menu li.item').removeClass('sfhover'); 
	});
});

//Initialize Javascript on site load
function init()
{
	$('.searchform-query').click(function() {
		this.select();
	});
	$('.selectOnClick').click(function() {
		this.select();
	});
}
$(document).ready(init);

/**
 * Dynamically load the scripts specified in the scripts array.
 * Note: no libraries (including jQuery) are required to run this function
 * 
 * @author Saint Wesonga
 * @param scripts	An array of scripts to be loaded e.g. ['/js/jquery.smth.js']
 * @param options	(Optional) Object containing load options
 * 					{
 * 						// The onLoad function is executed after all the
 * 						// scripts have been loaded and all the globals in the
 * 						// "globals" key are no longer undefined
 * 						onLoad:			function () {},
 * 
 * 						// A list of globals variables that must be defined
 * 						// Before the onLoad callback is executed (if any) and
 * 						// the function completes
 * 						globals:		[var1, var2, ...],
 * 
 * 						// A list of defined objects, each of which with a
 * 						// corresponding array in "waitMembers" specifying
 * 						// which members of the object must be defined before
 * 						// the loading of the scripts can be considered complete.
 * 						waitObjects:	[obj1, obj2, ...],
 * 						waitMembers:	[	[obj1_member1, obj1_member2, ...],
 * 											[obj1_member2, obj2_member2, ...],
 * 											...
 * 										]
 * 					}
 */
function loadScripts(scripts, options)
{
	(function () {
		if (typeof scripts === "string") {
			scripts = [scripts];
		}
		
		for (var x = 0; x < scripts.length; x++) {
			var script = document.createElement('script');
			script.src = scripts[x];
			// append script to the head (or the body if no head exists)
			document.documentElement.firstChild.appendChild(script);
		}
		
		if (options) {
			// Function to check whether all members are !== undefined
			// obj is an object and members is an array of strings
			var membersDefined = function (obj, members) {
				for (var i = 0; i < members.length; i++) {
					if (typeof obj[members[i]] === "undefined") {
						return false;
					}
				}
				
				return true;
			};
			
			var checkLoaded = function () {
				var checkAgain = false;
				
				if (options.globals.length > 0) {
					checkAgain = !membersDefined(window, options.globals);
				}
				
				if (!checkAgain) {
					for (var i = 0; i < options.waitObjects.length; i++) {
						checkAgain = !membersDefined(options.waitObjects[i], options.waitMembers[i]);
						
						if (checkAgain) {
							break;
						}
					}
				}
				
				if (checkAgain) {
					setTimeout(checkLoaded, 20);
				} else {
					// Execute the callback
					if (options.onLoad) {
						options.onLoad();
					}
				}
			};
			
			setTimeout(checkLoaded, 20);
		}
	}());
}
