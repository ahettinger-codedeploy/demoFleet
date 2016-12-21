function emailCheck(emailFormField, showerror) {

	var txt = emailFormField.value;
	var error = "";

	var emailRe = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*\.(\w{2}|(com|net|org|edu|int|mil|gov|arpa|biz|aero|name|coop|info|pro|museum))$/
	var phoneRe = /^((\+\d{1,3}(-| )?\(?\d\)?(-| )?\d{1,5})|(\(?\d{2,6}\)?))(-| )?(\d{3,4})(-| )?(\d{4})(( x| ext)\d{1,5}){0,1}$/

	if (!(emailRe.test(txt))) {
		error = "Please enter a valid email address.\n";
	}

	var illegalChars = /[\(\)\<\>\,\;\:\\\/\"\[\]]/
	if (txt.match(illegalChars)) {
		error += "The email address contains illegal characters.\n";
	}

	if (error.length > 0) {
		if (showerror) {
			emailFormField.focus();
			alert(error);
		}
		return false;
	}
	return true;
}

function printEvents() {
	$('body').toggleClass('print-events');
	window.print();
	$('body').toggleClass('print-events');
}
function printCalendar() {
	$('body').toggleClass('shedule');
	window.print();
	$('body').toggleClass('shedule');
}


$(function(){

		ini = $('#fx img:first').attr('longdesc') + '?' + Math.random();
		if (ini) {
			$('#fx img:first').ready(function() {
				$.getJSON(ini, function(data) {
					$.each(data, function(item) {
						$("<img>").attr("src", data[item]).css( {
							'display' : 'none'
						}).appendTo("#fx");
					});
					$('div#fx').innerfade();
				});
	
			});
		}
		
		if($(".featuresroll").val() != null) {
			$(".featuresroll").innerfade({containerheight : '125px'});
		}
	
		$(".reservation-btn").toggle(function(){
			$("#booking").animate({
				top: "30px"
			}, 500);
		}, function(){
			$("#booking").animate({
				top: "-200px"
			}, 500);
		});

		$(".date-pick").datePicker();
	
	/** booking **/
	
		var HeBS_Link_Checkin_Checkout_Inputs = function HeBS_Link_Checkin_Checkout_Inputs_function(checkin_selector, checkout_selector) {
			Date.format = 'mm/dd/yyyy';
	
			
			
			$(checkin_selector).bind('dateSelected', function(e, selectedDate, $td, state) {
				var t = new Date(selectedDate);
				var dt = new Date.fromString($(checkin_selector).val());		
			    var edate = new Date.fromString($(checkout_selector).val());			
			    var one_day=1000*60*60*24;
			    var days_diff = Math.ceil((edate.getTime() - dt.getTime())/(one_day));
			    
			    if(edate.getTime() <= dt.getTime()) {
			        $(checkout_selector).val(t.addDays(1).asString());
			    }
			});
			
			$(checkout_selector).bind('dateSelected', function(e, selectedDate, $td, state) {
				var t = new Date(selectedDate);
				var dt = new Date.fromString($(checkin_selector).val());	
			    var edate = new Date.fromString($(checkout_selector).val());				
			    var one_day=1000*60*60*24;
			    var days_diff = Math.ceil((edate.getTime() - dt.getTime())/(one_day));
			    
			    var edate = new Date.fromString($(checkout_selector).val());			
			    if(edate.getTime() <= dt.getTime()) {
			        $(checkin_selector).val(t.addDays(-1).asString());
			    }		
			});
			
			var today = new Date();
			$(checkin_selector).val(today.asString());
			$(checkout_selector).val(today.addDays(1).asString());
			
		    $(checkout_selector).dpSetStartDate(today.asString());
		};
		
		HeBS_Link_Checkin_Checkout_Inputs('#checkin', '#checkout');

//	end of booking
	
});