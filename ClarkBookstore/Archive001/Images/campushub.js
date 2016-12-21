// CampusHub Javascript Library
// Last modified: 22 June 2006




/* ###############################
	Product Detail
   ############################### */
	
	function enlarge(imageurl) {
		window.open(imageurl,"productphoto","menubar=0,resizable=1,width=400,height=400");
	}
	
	function validateAddToCart(e) {
		if(!document.getElementById("fQty").value.match(/\D/)){
			document.getElementById("frmCart").submit();
		}else{
			alert("Please enter a quantity of at least 1."); return false;
		}
	}

/* ###############################
	Account Creation
   ############################### */

	function initAccountForm() {
		addEvent(document.getElementById("fShipSameAsBill"),'click',cloneShippingToggle);
		if (document.getElementById("fShipSameAsBill").checked) {
			setShippingDisabled(true);
			cloneShippingInfo();
		}
	}
	
	cloneShippingToggle = function() {
		
		setShippingDisabled(this.checked);
		if (this.checked) {
			cloneShippingInfo();
		}
		
		var shipElements = ["fShippingFirstName", "fShippingLastName", "fShippingAddress","fShippingAddress2","fShippingCountry","fShippingCity","fShippingState","fShippingZip","fShippingPhone"];
		for (var i=0; i<shipElements.length; i++) {
			addEvent(document.getElementById(shipElements[i]),'change',cloneShippingInfo);
		}
	}
	

	function cloneShippingInfo() {
		if (document.getElementById("fShipSameAsBill").checked) {
		    document.getElementById("fBillingFirstName").value = document.getElementById("fShippingFirstName").value;
		    document.getElementById("fBillingLastName").value = document.getElementById("fShippingLastName").value;
			document.getElementById("fBillingAddress").value = document.getElementById("fShippingAddress").value;
			document.getElementById("fBillingAddress2").value = document.getElementById("fShippingAddress2").value;
			document.getElementById("fBillingCountry").selectedIndex = document.getElementById("fShippingCountry").selectedIndex;
			to_country_onchange("fBillingState","fBillingCountry");
			document.getElementById("fBillingCity").value = document.getElementById("fShippingCity").value;
			document.getElementById("fBillingState").selectedIndex = document.getElementById("fShippingState").selectedIndex;
			document.getElementById("fBillingZip").value = document.getElementById("fShippingZip").value;
			document.getElementById("fBillingPhone").value = document.getElementById("fShippingPhone").value;
		}
	}
	
	function setShippingDisabled(bool) {
		var elements = ["fBillingFirstName","fBillingLastName","fBillingAddress","fBillingAddress2","fBillingCountry","fBillingCity","fBillingState","fBillingZip","fBillingPhone"];
		for (var i=0; i<elements.length; i++) {
			document.getElementById(elements[i]).disabled = bool;	
		}
	}
	
	function internationalshipping(e){
		var isInternational = false;
		var selectedState = "";
		if (document.getElementById("fShippingState")){
			selectedState = document.getElementById("fShippingState").value
			if (selectedState=="XX" || selectedState=="AE" || selectedState=="AP" || selectedState=="AA"){
				isInternational = true;
			}	
		}
		if (document.getElementById("ship_to_state")){
			selectedState = document.getElementById("ship_to_state").value
			if (selectedState=="XX" || selectedState=="AE" || selectedState=="AP" || selectedState=="AA"){
				isInternational = true;
			}
		}
		
		if(!isInternational){
			return validateFieldInd(e,"validateconditional-internationalshipping-");
		}else{
			return true;
		}
	}
	function internationalbilling(e){
		var isInternational = false;
		var selectedState = "";
		if (document.getElementById("bill_to_state")){
			selectedState = document.getElementById("bill_to_state").value
			if (selectedState=="XX" || selectedState=="AE" || selectedState=="AP" || selectedState=="AA"){
				isInternational=true;
			}
		}
		if (document.getElementById("fBillingState")){
			selectedState = document.getElementById("fBillingState").value
			if (selectedState=="XX" || selectedState=="AE" || selectedState=="AP" || selectedState=="AA"){
				isInternational = true;
			}
		}
		
		if(!isInternational){
			return validateFieldInd(e,"validateconditional-internationalbilling-");
		}else{
			return true;
		}
	}

/* ###############################
	Tell A Friend
	############################## */
	
	function showEmailForm(el) {

		if (el) {
			$(el.parentNode.parentNode).find(".tellafriend-sms").hide();
			$(el.parentNode.parentNode).find(".tellafriend-email").slideDown("normal");
		} else {
			$("#tellafriend-sms").hide();
			$("#tellafriend-email").slideDown("normal");
		}
	}
	
	function showSMSForm(el) {
		if (el) {

			$(el.parentNode.parentNode).find(".tellafriend-email").hide();
			$(el.parentNode.parentNode).find(".tellafriend-sms").slideDown("normal");
		} else {
			$("#tellafriend-email").hide();
			$("#tellafriend-sms").slideDown("normal");
		}
	}
	
	function cancel(el) {
		$(el.parentNode.parentNode).slideUp("fast");
	}

	function hideSMSForm() {
		$("#tellafriend-sms").slideUp("fast");
	}
	
	function hideEmailForm() {
		$("#tellafriend-email").slideUp("fast");
	}


/* ###############################
	Sell Textbooks 
	############################## */

	// moved to sell_main.js

/* ###############################
	Book Swap - Contact Seller
	############################## */

	function toggleContactForm(id) {
		var el = $("#contact"+id);

		// close any other open forms, and toggle the current one
		$("*[@id*='contact']").each(function(){
			var t = $(this);
			if (t.is("#contact"+id)) {
				if (t.is(".hide")) {
					t.removeClass("hide");
				} else {
					t.addClass("hide");
				}
			} else {
				t.addClass("hide");
			}
		});
			
	}
	
	function toggleNotes(id) {
		var el = $("#note"+id);
		if (el.is(".hide")) {
			el.removeClass("hide");
		} else {
			el.addClass("hide");
		}
	}
	
	function toggleIcon(el) {
		if ($(el).is(".disclosure-expanded")) {
			$(el).removeClass("disclosure-expanded");
		} else {
			$(el).addClass("disclosure-expanded");
		}
		el.blur();
	}


/* ###############################
	Form Helpers
   ############################### */

	// toggleFields()
	// This function is assigned as an onclick event on a checkbox.  It takes an ID or array of IDs and
	// disables/enables them based on it's checked value.
	//
	// @input		- string (ID) or reference of the calling checkbox
	// @target		- string or array of strings of ID(s) of target field(s)
	// @polarity	- boolean that indicates how the disabled of the fields should related to the checked
	//				  of the checkbox. When polarity=true, a checked box results in an enabled field
	function toggleFields(input,target,polarity) {
		if (typeof(target) == "string") {
			document.getElementById(target).disabled = (polarity) ? input.checked : !input.checked;
		} else if (typeof(target) == "object") {
			for (var i=0;i<target.length;i++) {
				document.getElementById(target[i]).disabled = (polarity) ? input.checked : !input.checked;
			}
		}
	}

	function disableEnterKeypress(e){
		if(!e) var e = window.event;
		if(e.keyCode){
			if(e.keyCode==13){
				return false;
			}
		}
		else if(e.which){
			if (e.which==13){
				return false;
			}
		}
	}
/* ###############################
	Simple Form Error Handling
   ############################### */
   
   

	function clearErrorFlash(){
		$("#flash,.error").hide();
	}
   
   
   
   function setFocusOnError() {
		// if the server returned any form errors on the current
		// page, set kb focus to the first instance of an error
		if ($("select,input").filter(".error").size() > 0) {
			var frm = $("#content").find("form").get(0);
			for (var i=0;i<frm.elements.length;i++) {
				if ($(frm.elements[i]).is(".error")) {
					frm.elements[i].focus();
					break;
				}
			}
		}
   }   
   
   function enableSimpleFormValidation(additionalValidation) {
	   // find any <form>s of the class "form-validate" and modify their
	   // submit event to validate its fields
	   
	   $("form.form-validate").submit(function(e) {
			var addVal = false;
			if(additionalValidation == undefined){
				addVal = true;
			}else{
				addVal = additionalValidation();
			}
					
			// prevent default submit action
			if (e.preventDefault) { e.preventDefault(); e.stopPropagation(); } else { e.returnValue = false; e.cancelBubble = true; }
			
			// validate the form
			
			if (validateForm(this) == true && addVal) {
				this.submit();	
				return true;
			} else {
				alert("There is a problem with the information you have entered.");
				setFocusOnError();
				return false;
			}
		});
   }
   
   function validateForm(frm) {
	   var formIsValid = true;

	   // find all elements that contain the class "validate-*"
	  $("*[@class*='validate-'][@disabled='']",frm).each(function() {
			formIsValid = (validateField(this)) ? formIsValid : false;
		});
		
		$("*[@class*='validateconditional-'][@disabled='']",frm).each(function() {
			formIsValid = (validateConditionalField(this)) ? formIsValid : false;
		});	  
		
	
	   
	   return formIsValid;
   }
   
	function validateField(e) {		
		// NOTE - validators are applied in the order they are specified in the field's class declaration
		/*var classArray = e.className.split(" ");
		var fieldIsValid = true;
		var errorMsg = "";
		
	   	for (var i=0; i<classArray.length; i++) {
			if (classArray[i].indexOf("validate-") > -1) {
				var validator = classArray[i].substring(9);
				switch (validator) {
					case ("required"):
						// ################# VALIDATOR FOR REQUIRED FIELDS #####################
						switch (e.tagName) {
						   case "INPUT":
						   		//alert(e.type);
						   		if (e.type == "checkbox") {
									if (e.checked != true) {
										errorMsg = "This checkbox is required.";	
										fieldIsValid = false;
									}
								} else if (e.value.length < 1) {
									errorMsg = "This field is required.";
									fieldIsValid = false;
								}
								break;
							case "TEXTAREA":
								if (e.value.length < 1) {
									errorMsg = "This field is required.";
									fieldIsValid = false;
								}
								break;
						   case "SELECT":
								if (e.selectedIndex == 0) {
									errorMsg = "Please make a selection.";
									fieldIsValid = false;
								}
								break;
					    }
						break;
					case ("email"):
						// ##################### EMAIL ADDRESS VALIDATOR #####################
						var regex = /^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
	   					if (!(e.value.match(regex))) {
							errorMsg = "Please enter a valid email address.";
							fieldIsValid = false;
						}
						break;
						
					case ("phone"):
						// ##################### PHONE NUMBER VALIDATOR #####################
						//var regex = /^\(?\d{3}\)?\s|-\d{3}-\d{4}$/; //(###-###-####)
						var regex = /^\(?\d{3}\)?(\s|-|\.)?\d{3}?(\s|-|\.)?\d{4}$/; // ###-###-####, (###) ###-####, ###.###.####, ### ### ####
	   					if (!(e.value.match(regex))) {
							errorMsg = "Please enter a valid phone number (###-###-####).";
							fieldIsValid = false;
						}
						break;
						
					case ("zip"):
						// ##################### ZIP CODE VALIDATOR #####################
						var regex = /\d{5}(-\d{4})?/;	// validates US ZIP Codes (#####, #####-####)
	   					if (!(e.value.match(regex))) {
							errorMsg = "Please enter a valid ZIP Code.";
							fieldIsValid = false;
						}
						break;
						
					case ("currency"):
						// ##################### CURRENCY VALIDATOR #####################
						var regex = /^\s*[$]?\s*\d+(\.\d{1,2})?\s*$/;	// Validates US currency strings ($12, 12, 12.3, 12.34)
	   					if (!(e.value.match(regex))) {
							errorMsg = "Please enter a valid currency amount.";
							fieldIsValid = false;
						}
						break;
					case ("isbn"):
						var regex = /(?=.{13}$)\d{1,5}([-])\d{1,7}\1\d{1,6}\1(\d|X)$|(^\d{9}[0-9xX]{1}$)/;
						var regex2 = /([\d]{10}|[\d]{9}[xX])|([\d]{13})$/;
						if (!(e.value.match(regex) || e.value.match(regex2))) {
							errorMsg = "Please enter a valid IBSN.";
							fieldIsValid = false;
						}
						break;

				}
			}
			
			// stop checking for other validators of this field has already failed one of them
			if (fieldIsValid == false) {
				break;
			};
		}
		
		if (fieldIsValid == false) {
			displayError(e,errorMsg);
		} else {
			if ($(e).is(".error") == true) {
				removeError(e);
			}
		}*/
		return validateFieldInd(e,"validate-");
	}
   
   
	function validateFieldInd(e,indicator){
		// NOTE - validators are applied in the order they are specified in the field's class declaration
		var classArray = e.className.split(" ");
		var fieldIsValid = true;
		var errorMsg = "";
	   	for (var i=0; i<classArray.length; i++) {
			if (classArray[i].indexOf(indicator) > -1) {
				var validator = classArray[i].substring(indicator.length);
				switch (validator) {
					case ("required"):
						// ################# VALIDATOR FOR REQUIRED FIELDS #####################
						switch (e.tagName) {
						   case "INPUT":
						   		//alert(e.type);
						   		if (e.type == "checkbox") {
									if (e.checked != true) {
										errorMsg = "This checkbox is required.";	
										fieldIsValid = false;
									}
								} else if (e.value.length < 1) {
									errorMsg = "This field is required.";
									fieldIsValid = false;
								}
								break;
							case "TEXTAREA":
								if (e.value.length < 1) {
									errorMsg = "This field is required.";
									fieldIsValid = false;
								}
								break;
						   case "SELECT":
								if (e.selectedIndex == 0) {
									errorMsg = "Please make a selection.";
									fieldIsValid = false;
								}
								break;
					    }
						break;
					case ("email"):
						// ##################### EMAIL ADDRESS VALIDATOR #####################
						var regex = /^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
	   					if (!(e.value.match(regex))) {
							errorMsg = "Please enter a valid email address.";
							fieldIsValid = false;
						}
						break;
						
					case ("phone"):
						// ##################### PHONE NUMBER VALIDATOR #####################
						//var regex = /^\(?\d{3}\)?\s|-\d{3}-\d{4}$/; //(###-###-####)
						var regex = /^\(?\d{3}\)?(\s|-|\.)?\d{3}?(\s|-|\.)?\d{4}$/; // ###-###-####, (###) ###-####, ###.###.####, ### ### ####
	   					if (!(e.value.match(regex))) {
							errorMsg = "Please enter a valid phone number (###-###-####).";
							fieldIsValid = false;
						}
						break;
						
					case ("zip"):
						// ##################### ZIP CODE VALIDATOR #####################
					    var regex = /\d{5}(-\d{4})?|[A-Z]\d[A-Z]\s\d[A-Z]\d|[A-Z]\d[A-Z]\d[A-Z]\d/; // validates US ZIP Codes (#####, #####-####)
	   					if (!(e.value.match(regex))) {							// and Canadian ZIP codes (A#A #A#)
							errorMsg = "Please enter a valid ZIP Code (#####) or Postal Code (A#A #A#).";
							fieldIsValid = false;
						}
						break;
						
					case ("currency"):
						// ##################### CURRENCY VALIDATOR #####################
						var regex = /^\s*[$]?\s*\d+(\.\d{2})?\s*$/;	// Validates US currency strings ($12, 12, 12.34)
	   					if (!(e.value.match(regex))) {
							errorMsg = "Please enter a valid currency amount.";
							fieldIsValid = false;
						}
						break;
					case ("isbn"):
						var regex = /(?=.{13}$)\d{1,5}([-])\d{1,7}\1\d{1,6}\1(\d|X)$|(^\d{9}[0-9xX]{1}$)/;
						var regex2 = /([\d]{10}|[\d]{9}[xX])|([\d]{13})$/;
						if (!(e.value.match(regex) || e.value.match(regex2))) {
							errorMsg = "Please enter a valid IBSN.";
							fieldIsValid = false;
						}
						break;
						
						/*var regex = /(?=.{13}$)\d{1,5}([-])\d{1,7}\1\d{1,6}\1(\d|X)$|(^\d{9}[0-9xX]{1}$)/;
						if (!(e.value.match(regex))) {
							errorMsg = "Please enter a valid IBSN.";
							fieldIsValid = false;
						}
						break;*/
				}
			}
			
			// stop checking for other validators of this field has already failed one of them
			if (fieldIsValid == false) {
				break;
			};
		}
		
		if (fieldIsValid == false) {
			displayError(e,errorMsg);
		} else {
			if ($(e).is(".error") == true) {
				removeError(e);
			}
		}
		return fieldIsValid;
	
	}
	
	function validateConditionalField(e){
		//pull out function name
		var conditional;
		var isValid = true;
		
		var classArray = e.className.split(" ");
		
	   	for (var i=0; i<classArray.length; i++) {
			if (classArray[i].indexOf("validateconditional-") > -1) {
				var validatorArray = classArray[i].split("-");
				conditional=eval(validatorArray[1]);
				//indicator=validatorArray[2];
			
				if(conditional){
					isValid = (conditional(e)) ? isValid : false
				}
			}
		}
		
		
		return isValid;// set this conditional="international" (the function name)
		
	}
		
   	function validateFieldOnce(e) {		
		// NOTE - validators are applied in the order they are specified in the field's class declaration
		/*var classArray = e.className.split(" ");
		var fieldIsValid = true;
		var errorMsg = "";
		
	   	for (var i=0; i<classArray.length; i++) {
			if (classArray[i].indexOf("validateonce-") > -1) {
				var validator = classArray[i].substring(13);
				switch (validator) {
					case ("required"):
						// ################# VALIDATOR FOR REQUIRED FIELDS #####################
						switch (e.tagName) {
						   case "INPUT":
						   		//alert(e.type);
						   		if (e.type == "checkbox") {
									if (e.checked != true) {
										errorMsg = "This checkbox is required.";	
										fieldIsValid = false;
									}
								} else if (e.value.length < 1) {
									errorMsg = "This field is required.";
									fieldIsValid = false;
								}
								break;
							case "TEXTAREA":
								if (e.value.length < 1) {
									errorMsg = "This field is required.";
									fieldIsValid = false;
								}
								break;
						   case "SELECT":
								if (e.selectedIndex == 0) {
									errorMsg = "Please make a selection.";
									fieldIsValid = false;
								}
								break;
					    }
						break;
					case ("email"):
						// ##################### EMAIL ADDRESS VALIDATOR #####################
						var regex = /^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
	   					if (!(e.value.match(regex))) {
							errorMsg = "Please enter a valid email address.";
							fieldIsValid = false;
						}
						break;
						
					case ("phone"):
						// ##################### PHONE NUMBER VALIDATOR #####################
						//var regex = /^\(?\d{3}\)?\s|-\d{3}-\d{4}$/; //(###-###-####)
						var regex = /^\(?\d{3}\)?(\s|-|\.)?\d{3}?(\s|-|\.)?\d{4}$/; // ###-###-####, (###) ###-####, ###.###.####, ### ### ####
	   					if (!(e.value.match(regex))) {
							errorMsg = "Please enter a valid phone number (###-###-####).";
							fieldIsValid = false;
						}
						break;
						
					case ("zip"):
						// ##################### ZIP CODE VALIDATOR #####################
						var regex = /\d{5}(-\d{4})?/;	// validates US ZIP Codes (#####, #####-####)
	   					if (!(e.value.match(regex))) {
							errorMsg = "Please enter a valid ZIP Code.";
							fieldIsValid = false;
						}
						break;
						
					case ("currency"):
						// ##################### CURRENCY VALIDATOR #####################
						var regex = /^\s*[$]?\s*\d+(\.\d{2})?\s*$/;	// Validates US currency strings ($12, 12, 12.34)
	   					if (!(e.value.match(regex))) {
							errorMsg = "Please enter a valid currency amount.";
							fieldIsValid = false;
						}
						break;
					case ("isbn"):
						var regex = /(?=.{13}$)\d{1,5}([-])\d{1,7}\1\d{1,6}\1(\d|X)$|(^\d{9}[0-9xX]{1}$)/;
						var regex2 = /([\d]{10}|[\d]{9}[xX])|([\d]{13})$/;
						if (!(e.value.match(regex) || e.value.match(regex2))) {
							errorMsg = "Please enter a valid IBSN.";
							fieldIsValid = false;
						}
						break;
						
				}
			}
			
			// stop checking for other validators of this field has already failed one of them
			if (fieldIsValid == false) {
				break;
			};
		}
		
		if (fieldIsValid == false) {
			displayError(e,errorMsg);
		} else {
			if ($(e).is(".error") == true) {
				removeError(e);
			}
		}*/
		return validateFieldInd(e,"validateonce-");
	}
	
	
	function displayError(e,msg) {
		$(e).addClass("error");		// add the class ".error" to the input element that generated the error
		$("//label[@for='" + e.id + "']").addClass("error");	// find the label for e.id, and add the class ".error"
		
		// see if an error, or a container for an error already exists.
		// error divs have IDs in the form "<formElementName>-error"
		if (document.getElementById(e.name + "-error")) {
			// the error already exists update its content with the new error msg
			var error = document.getElementById(e.name + "-error");
			msg = (error.title) ? error.title : msg;	// if the error has a title, use it as a custom error msg
			$(document.getElementById(e.name + "-error")).html("<p>" + msg + "</p>");
			$(document.getElementById(e.name + "-error")).show();
			
		} else {
			// the error does not exist, create it
			if (e.type == "checkbox") {		// special case for displaying errors on checkboxes
				$("label",e.parentNode).after("<div id='" + e.name + "-error' class='error checkbox'><p>" + msg + "</p></div>");
			} else {
				//alert("creating div id='" + e.name + "-error'");
				$(e).after("<div id='" + e.name + "-error' class='error'><p>" + msg + "</p></div>");
			}
		}
   }
   
   function removeError(e) {
		// hide the error's container and clear out its message
		$(document.getElementById(e.name + "-error")).html("").hide();
		$(e).removeClass("error");
		$("//label[@for='" + e.id + "']").removeClass("error");
   }
  
  function limitText(limitField, limitNum) {
	if (limitField.value.length > limitNum) {
		limitField.value = limitField.value.substring(0, limitNum);
		alert("The maximum length of this field is " + limitNum + " characters.");
	} 
}

  
// ############ ADD EVENT FUNCTIONS #######################

function addEvent( obj, type, fn ) {
	if (obj.addEventListener) {
		obj.addEventListener( type, fn, false );
		EventCache.add(obj, type, fn);
	}
	else if (obj.attachEvent) {
		obj["e"+type+fn] = fn;
		obj[type+fn] = function() { obj["e"+type+fn]( window.event ); }
		obj.attachEvent( "on"+type, obj[type+fn] );
		EventCache.add(obj, type, fn);
	}
	else {
		obj["on"+type] = obj["e"+type+fn];
	}
}
	
var EventCache = function(){
	var listEvents = [];
	return {
		listEvents : listEvents,
		add : function(node, sEventName, fHandler){
			listEvents.push(arguments);
		},
		flush : function(){
			var i, item;
			for(i = listEvents.length - 1; i >= 0; i = i - 1){
				item = listEvents[i];
				if(item[0].removeEventListener){
					item[0].removeEventListener(item[1], item[2], item[3]);
				};
				if(item[1].substring(0, 2) != "on"){
					item[1] = "on" + item[1];
				};
				if(item[0].detachEvent){
					item[0].detachEvent(item[1], item[2]);
				};
				item[0][item[1]] = null;
			};
		}
	};
}();
addEvent(window,'unload',EventCache.flush);


/*
Sweet Titles (c) Creative Commons 2005
http://creativecommons.org/licenses/by-sa/2.5/
Author: Dustin Diaz | http://www.dustindiaz.com
*/

Array.prototype.inArray = function (value) {
	var i;
	for (i=0; i < this.length; i++) {
		if (this[i] === value) {
			return true;
		}
	}
	return false;
};

var sweetTitles = {
    xCord: 0, 							// @Number: x pixel value of current cursor position
    yCord: 0, 							// @Number: y pixel value of current cursor position
    tipElements: ['a', 'abbr', 'acronym', 'span', 'tr'], // @Array: Allowable elements that can have the toolTip
    obj: Object, 						// @Element: That of which you're hovering over
    tip: Object, 						// @Element: The actual toolTip itself
    active: 0, 							// @Number: 0: Not Active || 1: Active
    init: function () {
        if (!document.getElementById ||
			!document.createElement ||
			!document.getElementsByTagName) {
            return;
        }
        var i, j;
        this.tip = document.createElement('div');
        this.tip.id = 'toolTip';
        document.getElementsByTagName('body')[0].appendChild(this.tip);
        this.tip.style.top = '0';
        this.tip.style.visibility = 'hidden';
        $(".sweetTitles").each(function () {
            addEvent(this, 'mouseover', sweetTitles.tipOver);
            addEvent(this, 'mouseout', sweetTitles.tipOut);

            var tag = this.nodeName.toLowerCase();
            if (tag == 'a' || tag == 'abbr' || tag == 'acronym') {
                this.setAttribute('tip', this.title);
                this.removeAttribute('title');
            }
        });
        $("#nav").find("a").each(function () {	// this includes the main navigation... sweetTitles class cannot be used there
            addEvent(this, 'mouseover', sweetTitles.tipOver);
            addEvent(this, 'mouseout', sweetTitles.tipOut);
            this.setAttribute('tip', this.title);
            this.removeAttribute('title');
        });
    },
    updateXY: function (e) {
        if (document.captureEvents) {
            sweetTitles.xCord = e.pageX;
            sweetTitles.yCord = e.pageY;
        } else if (window.event.clientX) {
            sweetTitles.xCord = window.event.clientX + document.documentElement.scrollLeft;
            sweetTitles.yCord = window.event.clientY + document.documentElement.scrollTop;
        }
    },
    tipOut: function () {
        if (window.tID) {
            clearTimeout(tID);
        }
        if (window.opacityID) {
            clearTimeout(opacityID);
        }
        sweetTitles.tip.style.visibility = 'hidden';
    },
    checkNode: function () {
        var trueObj = this.obj;
        if (this.tipElements.inArray(trueObj.nodeName.toLowerCase())) {
            return trueObj;
        } else {
            return trueObj.parentNode;
        }
    },
    tipOver: function (e) {
        sweetTitles.obj = this;
        tID = window.setTimeout("sweetTitles.tipShow()", 500);
        sweetTitles.updateXY(e);
    },
    tipShow: function () {
        var scrX = Number(this.xCord);
        var scrY = Number(this.yCord);
        var tp = parseInt(scrY + 15);
        var lt = parseInt(scrX + 10);
        var anch = this.checkNode();
        //var addy = '';
        var access = '';
        if (anch.nodeName.toLowerCase() == 'a') {
            //addy = (anch.href.length > 25 ? anch.href.toString().substring(0,25)+"..." : anch.href);
            var access = (anch.accessKey ? ' <span>[' + anch.accessKey + ']</span> ' : '');
        } else {
            //addy = anch.firstChild.nodeValue;
        }
        this.tip.innerHTML = "<p>" + anch.getAttribute('tip') + "<em>" + access + "</em></p>";
        if (parseInt(document.documentElement.clientWidth + document.documentElement.scrollLeft) < parseInt(this.tip.offsetWidth + lt)) {
            this.tip.style.left = parseInt(lt - (this.tip.offsetWidth + 10)) + 'px';
        } else {
            this.tip.style.left = lt + 'px';
        }
        if (parseInt(document.documentElement.clientHeight + document.documentElement.scrollTop) < parseInt(this.tip.offsetHeight + tp)) {
            this.tip.style.top = parseInt(tp - (this.tip.offsetHeight + 10)) + 'px';
        } else {
            this.tip.style.top = tp + 'px';
        }
        this.tip.style.visibility = 'visible';
        this.tip.style.opacity = '.1';
        this.tipFade(10);
    },
    tipFade: function (opac) {
        var passed = parseInt(opac);
        var newOpac = parseInt(passed + 10);
        if (newOpac < 80) {
            this.tip.style.opacity = '.' + newOpac;
            this.tip.style.filter = "alpha(opacity:" + newOpac + ")";
            opacityID = window.setTimeout("sweetTitles.tipFade('" + newOpac + "')", 20);
        }
        else {
            this.tip.style.opacity = '.80';
            this.tip.style.filter = "alpha(opacity:80)";
        }
    }
};
function pageLoader() {
	sweetTitles.init();
}
addEvent(window,'load',pageLoader);



//  ###### CH Autolinks  ######


function autoLinkInit() {

	if (!document.getElementsByTagName) return;

	var anchors = document.getElementsByTagName("a");

	for (var i=0; i<anchors.length; i++) {

		var anchor = anchors[i];

		if (anchor.getAttribute("href")){
			var relAttr = anchor.getAttribute("rel");
			switch (relAttr) {
				case ("external"):
					anchor.target = "_blank";
				break;
				case ("popup"):
					anchor.onclick = popup
				break;
			}
		}
	}

}



function popup()
{
	var URL = this.getAttribute("href");
	
	window.open(URL,'autopopup','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=500,height=400,left=312,top=234');
	return false;
}

function insertHtmlBefore(source, destination){
	$(destination).before($(source).html());
}

function insertHtmlAfter(source, destination){
	$(destination).after($(source).html());
}

function replaceHtml(source, destination){
	$(destination).html($(source).html());
}

function prependHtml(source, destination){
	$(destination).prepend($(source).html());
}

function appendHtml(source, destination){
	$(destination).append($(source).html());
}
