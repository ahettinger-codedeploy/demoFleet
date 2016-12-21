var rtJS;

(function($) {

rtJS = {

	updateTimer : function() {
        setTimeout('rtJS.updateTimer()', 1000);
  
        var now = new Date();
        //alert(now.toLocaleString());

        if(now >= rt_event_start && now < rt_event_end) {
				$('#rt-countdown').hide();
				$('#rt-until').hide();
				$('#rt-on').show();
                return;
        } else if(now > rt_event_end) {
                rt_event_start = rt_event_start_next;
        }
        
        //there is probably a better way to do this
        var total = (rt_event_start - now) / 1000; //remove millis
        var days = parseInt(total / 60 / 60 / 24);
        total -= days * 60 * 60 * 24; //remove days
        var hours = parseInt(total / 60 / 60);
        total -= hours * 60 * 60; //remove hours
        var minutes = parseInt(total / 60);
        total -= minutes * 60; //remove minutes
        var seconds = parseInt(total);
  
		$('#rt-on').hide();
		$('#rt-days').html(days);
		$('#rt-hours').html(hours);
		$('#rt-minutes').html(minutes);
		$('#rt-seconds').html(seconds);	
		$('#rt-countdown').show();
		$('#rt-until').show();
		$('#rt-event').show();
	},

	getJSDate : function(date_string) {
        var date_millis = Date.parse(date_string);
        if(isNaN(date_millis)) {
            alert('Error parsing ' + date_string);
        }
        var date = new Date();
        date.setTime(date_millis);
        return date;
	}

};

$(document).ready(function($){
	//don't include if there's no widget container
	if( $('#rt-content').length > 0 ) 
		rtJS.updateTimer(); 
});

})(jQuery);
