var carousel = jQuery('.carousel');
if(carousel){
	window.addEvent('domready', function(){
		if (typeof jQuery != 'undefined' && typeof MooTools != 'undefined' ) {
			Element.implement({
				slide: function(how, mode){
					return this;
				}
			});
		}
	});
}

var countdown_value = '2014/5/18 00:00:00 ';
var countdown_finish = 'countdown finished';