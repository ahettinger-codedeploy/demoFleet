var event_images;
var event_link;
var event_menu;
var event_photo;
var geocoder;
var google_map_element;
var image_ext;
var map;
var menu;
var menu_images_up;
var menu_images_over;
var page;
var promo_images;
var promo_link;
var promo_menu;
var promo_photo;
var rating_select;
var rating_value;

function addListener(element, type, expression, bubbling) {
	bubbling = bubbling || false;
	if(window.addEventListener) { // Standard
		element.addEventListener(type, expression, bubbling);
		return true;
	} else if(window.attachEvent) { // IE
		element.attachEvent('on' + type, expression);
		return true;
	} else return false;
}

function getGoogleData(results, status) {
	if (status == 'OK' && results.length > 0) {
		getGoogleMap(results[0]);
	} else {
		alert("Geocode was not successful for the following reason: " + status);
	}
}

function getGoogleMap(geodata) {
	myOptions = {
		zoom: 8,
		center: geodata.geometry.location,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	}
	var map = new google.maps.Map(google_map_element, myOptions);
	map.fitBounds(geodata.geometry.viewport);
	myOptions = {
		map: map,
		position: geodata.geometry.location,
		title: google_map_element.getAttribute('gmaptitle')
	}
	marker = setGoogleMarker(myOptions)
}

function getElement(element_id) {
	if (document.getElementById(element_id)) {
		return document.getElementById(element_id);
	} else {
		return false;
	}
}

function getMap(url) {
	var dpp_map = window.open(url,"csmap","top="+(screen.availHeight-600)/2+",left="+(screen.availWidth-800)/2+",width=800,height=600,statusbar=false,scrollbars=false");
	dpp_map.focus();
}

function removeClass(element, class_name) {
	if (!element.className) {
		element = getElement(element);
	}
	if (element.className == class_name) {
		element.className = undefined;
	} else {
		classes = element.className.split(" ");
		for (i = 0, len = classes.length; i < len; i++) {
			if (class_name == classes[i]) {
				trash = classes.splice(i, 1);
				element.className = classes.join(" ");
				break;
			}
		}
	}
}

function onWindowLoaded() {
	page = document.getElementsByTagName("BODY")[0].id;
	if (page=="home") {
		image_ext = "-home.jpg";
		var skip_intro = getElement("skip_intro");
		if (skip_intro) {
			skip_intro.onclick = function() {
				getElement("intro").className = "hide";
				getElement("help").className = "";
				setCookie("_downtownphoenix_intro", "skip", 365);
				return false;
			}
		}
	} else {
		image_ext = ".jpg";
	}
	/* NAVIGATION */
	menu_images_up = new Array();
	menu_images_over = new Array();
	menu = getElement("menu");
	if (menu) {
		for (i=0, len=menu.getElementsByTagName('IMG').length; i<len; i++) {
			node = menu.getElementsByTagName('IMG')[i];
			if (node.src.indexOf("-over.")>0) {
				continue;
			}
			node.index = i;
			menu_images_up[i] = new Image();
			menu_images_over[i] = new Image();
			menu_images_up[i].src = node.src;
			src = node.src.replace(".gif", "-over.gif");
			menu_images_over[i].src = src.substring(0, src.indexOf("?"));
			node.onmouseover = function() {
				this.src = menu_images_over[this.index].src;
			}
			node.onmouseout = function() {
				this.src = menu_images_up[this.index].src;
			}
		}
	}
	/* EVENT VIEWER */
	event_menu = getElement("event_menu");
	if (page=="home" && event_menu) {
		event_link = getElement("event_link");
		event_photo = getElement("event_photo");
		event_images = new Array();
		for (i=0, total = event_menu.getElementsByTagName("IMG").length; i<total; i++) {
			node = event_menu.getElementsByTagName("IMG")[i];
			event_images[i] = new Image();
			event_images[i].src = node.src;
		}
		for (i=0, total=event_menu.getElementsByTagName("A").length; i<total; i++) {
			node = event_menu.getElementsByTagName("A")[i];
			node.index = i;
			/*node.onclick = function() {
				setEventPhoto(this);
				return false;
			}*/
		}
		var interval = setInterval(setEventPhoto, 5000);
	}
	/* ACCOUNT EDIT */
	var email_topics = getElement("email_topics");
	var email_checkbox = getElement("user_preference_email_alerts");
	var mobile_topics = getElement("mobile_topics");
	var mobile_checkbox = getElement("user_preference_mobile_alerts");
	if (email_topics && email_checkbox && mobile_topics && mobile_checkbox) {
		email_checkbox.onclick = function() {
			if (this.checked) {
				removeClass(email_topics, "hide");
			} else {
				email_topics.className += " hide";
			}
		}
		mobile_checkbox.onclick = function() {
			if (this.checked) {
				removeClass(mobile_topics, "hide");
			} else {
				mobile_topics.className += " hide";
			}
		}
	}
	/* AMBASSADOR VIEWER */
	var ambassador_photo = getElement("ambassador_photo")
	if (ambassador_photo) {
		var ambassador_photo_index = 0;
		var ambassador_photos = new Array();
		ambassador_photo_names = ["back", "front", "full"];
		for (i=0, len=ambassador_photo_names.length; i<len; i++) {
			ambassador_photos[i] = new Image();
			ambassador_photos[i].src = "/images/ambassadors/uniform_" + ambassador_photo_names[i] + ".jpg"
		}
		var next_link = getElement("next_link");
		var prev_link = getElement("prev_link");
		next_link.onclick = function() {
			new_index = ambassador_photo_index + 1;
			if (new_index >= ambassador_photos.length) {
				new_index = 0;
			}
			ambassador_photo.src = ambassador_photos[new_index].src;
			ambassador_photo_index = new_index;
			return false;
		}
		prev_link.onclick = function() {
			new_index = ambassador_photo_index - 1;
			if (new_index < 0) {
				new_index = 2;
			}
			ambassador_photo.src = ambassador_photos[new_index].src;
			ambassador_photo_index = new_index;
			return false;
		}
	}
	/* PHOTO VIEWER */
	var gallery = $('photo_viewer');
	if (gallery) {
		var gallery_photos = new Array();
		var gallery_active = 1;
		for (i=0, len = gallery.getElementsByTagName("IMG").length; i<len; i++) {
			node = gallery.getElementsByTagName("IMG")[i];
			if (node.className=="main") {
				var gallery_photo = node;
			} else {
				var index = gallery_photos.length;
				gallery_photos[index] = new Image();
				gallery_photos[index].src = node.src.replace("-thumb.", "-photo.");
				node.gallery_index = index;
				node.onclick = function() {
					gallery_photo.src = gallery_photos[this.gallery_index].src
					for (i = 1, len = gallery.getElementsByTagName("IMG").length; i < len; i++) {
						node = gallery.getElementsByTagName("IMG")[i]
						node.className = node.className.replace("active", "");
					}
					this.className += " active";
				}
			}
			//image_id = node.id.replace("promo_link", "");
			//event_images[i] = new Image();
			//event_images[i].src = "/images/businesses/" + image_id + image_ext;
		}
		/*for (i=0, total=event_menu.getElementsByTagName("A").length; i<total; i++) {
			node = event_menu.getElementsByTagName("A")[i];
			node.onclick = setEventPhoto;
		}*/
	}
	/* SEARCH FORM */
	var search_input = getElement("search_query");
	if (search_input) {
		search_input.onfocus = function() {
			if (this.value=="Search") {
				this.value = "";
			}
		}
		search_input.onblur = function() {
			if (this.value=="") {
				this.value = "Search";
			}
		}
	}
	/* INDIVIDUAL FORMS */
	var record_input = getElement("record_query");
	if (record_input) {
		record_input.onfocus = function() {
			if (this.value == "Search Keywords") {
		 		this.value = "";
			}
		}
		record_input.onblur = function() {
			if (this.value=="") {
				this.value = "Search Keywords";
			}
		}
	}
	/* BUSINESS REVIEWS */
	business_review_form = getElement("business_review_form")
	business_review_link = getElement("business_review_link")
	if (business_review_form && business_review_link) {
		business_review_link.onclick = function() {
			classes = business_review_form.className.split(" ");
			for (key in classes) {
				if (classes[key]=="hide") {
					classes.splice(key, 1);
				}
			}
			business_review_form.className = classes.join(" ");
			this.className = "hide";
			return false;
		}
	}
	/* LIST REVIEWS */
	list_review_form = getElement("list_review_form")
	list_review_link = getElement("list_review_link")
	if (list_review_form && list_review_link) {
		list_review_link.onclick = function() {
			classes = list_review_form.className.split(" ");
			for (key in classes) {
				if (classes[key]=="hide") {
					classes.splice(key, 1);
				}
			}
			list_review_form.className = classes.join(" ");
			this.className = "hide";
			return false;
		}
	}
	// RATING STARS
	rating_select = getElement("rating_select");
	rating_value = getElement("rating_value");
	if (rating_select) {
		for (i=0, len=rating_select.getElementsByTagName("IMG").length; i<len; i++) {
			node = rating_select.getElementsByTagName("IMG")[i];
			node.rating = i+1;
			node.onmouseover = function(){
				setRating(this.rating);
			}
		}
	}
	/* GETTING AROUND */
	var area_select = getElement("area_select");
	if (area_select) {
		area_select.onchange = function() {
			if (this.value!=undefined && this.value!="null") {
				window.location.href = "/getting-around/directions/" + this.value;
			}
			return false;
		}
	}
	/* DIRECTIONS */
	var business_directions = getElement("venue_directions");
	if (business_directions) {
		business_directions.onsubmit = function() {
			if (this.aid.selectedIndex==0) {
				window.alert("Please select an origin");
				return false;
			}
			if (this.did.selectedIndex==0) {
				window.alert("Please select a destination");
				return false;
			}
		}
	}
	/* CONTACT FORM */
	var contact_form = $('contactForm');
	if (contact_form) {
		contact_form.onsubmit = function() {
			var sEmail		= this.email.value;
			var regEmail	= /^([\w-]+\.?)*\w+@([\da-zA-z-]+\.)+[a-zA-z]{2,3}$/
			if ((this.name.value.length == 0) || (this.email.value.length == 0) || (this.comments.value.length == 0)) {
				alert("All fields are required. Please check the form and resubmit.");
				return false;
			} else if (!regEmail.test(sEmail)) {
				alert("This does not appear to be a valid email address. Please check the email address and resubmit.");
				return false;
			} else {
				return true;
			}
		}
		contact_form = undefined;
	}
	/* GOOGLE MAPS */
	google_map_element = $('google_map');
	if (google_map_element) {
		geocoder = new google.maps.Geocoder();
		address = google_map_element.getAttribute('gmaplocation');
		geocoder.geocode({'address': address, 'partialmatch': true}, getGoogleData);
	}
	/* SEND2PHONE */
	var phone_link = getElement("phone_link");
	if (phone_link) {
		phone_link.onclick = function() {
			mobile = this.attributes.getNamedItem('mobile').value;
			if (mobile.length!=10) {
				mobile = "555-123-4567"
			}
			mobile = prompt("Please enter your mobile number. Message & data rates may apply.", mobile);
			if (!mobile) {
		 		return false;
		 	} else {
		 		mobile = mobile.replace(/[^0-9]+/g, "");
		 	}
			if (mobile.length!=10) {
				alert("Please enter a valid number. " + mobile);
				return false;
			}
			setPhoneNotification(this.href + "?mobile="+mobile);
			return false;
		}
	}
	/* SEND2PHONE2 */
	var phone_link = getElement("phone_link_too");
	if (phone_link) {
		phone_link.onclick = function() {
			mobile = this.attributes.getNamedItem('mobile')
			if (mobile.length!=10) {
				mobile = prompt("Please enter your mobile number.", "555-123-4567");
			}
			if (!mobile) {
		 		return false;
		 	} else {
		 		mobile = mobile.replace(/[^0-9]+/g, "");
		 	}
			if (mobile.length!=10) {
				alert("Please enter a valid number. " + mobile);
				return false;
			}
			setPhoneNotification(this.href + "?mobile="+mobile);
			return false;
		}
	}
}

function onWindowUnloaded() {
	delete geocoder;
	delete google_map_element;
	delete map;
}

function setCookie(c_name, value, expiredays) {
	var exdate = new Date();
	exdate.setDate(exdate.getDate()+expiredays);
	document.cookie = c_name + "=" + escape(value)+((expiredays==null) ? "" : ";expires="+exdate.toGMTString());
}

function setEventPhoto(element) {
	if (!element || !element.className) { 
		n = event_menu.className.replace("active", "").toString();
		if (n >= event_menu.getElementsByTagName("LI").length) {
			n = 0;
		}
		element = event_menu.getElementsByTagName("LI")[n].firstChild;
	}
	index = element.className.replace("event", "");
	id = element.id.replace("event", "");
	event_menu.className = "active" + index;
	event_link.href = element.href;
	event_link.title = element.title;
	event_photo.src = event_images[index - 1].src;
}

function setGoogleMarker(options) {
	return new google.maps.Marker(options)
}

function setMarqueePhoto(element) {
	if (!element || !element.className) { 
		n = promo_menu.className.replace("active", "").toString();
		if (n>=promo_menu.getElementsByTagName("LI").length) {
			n = 0;
		}
		element = promo_menu.getElementsByTagName("LI")[n].firstChild;;
	}
	index = element.className.replace("promo_index", "");
	promo_link.href = element.href;
	promo_link.title = element.title;
	promo_photo.alt = element.title;
	promo_menu.className = "active" + index;
	$('promo_excerpt').firstChild.data = element.getAttribute("excerpt");
	$('promo_name').firstChild.data = element.title;
	promo_photo.src = promo_images[index-1].src;
}

function setPhoneNotification(url) {
	var myAjax = new Ajax.Request(url, {
		method: 'get',
		onCreate: function(object) {
			//alert("create " + object.status);
		},
		onSuccess: function(object) {
			if (object.status == 200) {
		 		alert("Successfully sent to phone.");
			} else {
				alert(json.Response.result.status);
			}
		}
	});
	return false;
}

function setRating(value) {
	for (i=0, len=rating_select.getElementsByTagName("IMG").length; i<len; i++) {
		node = rating_select.getElementsByTagName("IMG")[i];
		if (i < value) {
			node.src = "/images/ratings/yes.gif";
		} else {
			node.src = "/images/ratings/no.gif";
		}
		rating_value.value = value;
	}
}

Event.observe(window, "load", onWindowLoaded);
Event.observe(window, "unload", onWindowUnloaded);
