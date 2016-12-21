/*
 * jquery-periodic.js
 *
 * Adds a "periodic" function to jQuery which takes a callback and
options for the frequency (in seconds) and a
 * boolean for allowing parallel execution of the callback function
(shielded from exceptions by a try..finally block.
 * The first parameter passed to the callback is a pcontroller object.
 *
 * Return falsy value from the callback function to end the periodic
execution.
 *
 * For a callback which initiates an asynchronous process:
 * There is a boolean in the pcontroller object which will prevent the
callback from executing while it is "true".
 *   Be sure to reset this boolean to false when your asynchronous
process is complete, or the periodic execution
 *   won't continue.
 *
 * To stop the periodic execution, you can also call the "stop" method
of the pcontroller object, instead of returning
 * false from the callback function.
 *
 */
 
jQuery.periodic = function(pcallback, options) {
	pcallback = pcallback || (function() { return false; });
	options = jQuery.extend({ }, {frequency:10, allowParallelExecution:true}, options);
	
	var currentlyExecuting = false;
	var timer;
	
	var pcontroller = {
		stop : function() {
			if (timer) {
				window.clearInterval(timer);
				timer = null;
			}
		},
		
		currentlyExecuting : false,
		currentlyExecutingAsync : false
	};
	
	timer = window.setInterval(function() {
		if (options.allowParallelExecution || !(pcontroller.currentlyExecuting || pcontroller.currentlyExecutingAsync)) {
			try {
				pcontroller.currentlyExecuting = true;
				
				if (!(pcallback(pcontroller, options))) {
					pcontroller.stop();
				}
			} finally {
				pcontroller.currentlyExecuting = false;
			}
		}
	}, options.frequency * 1000);
};