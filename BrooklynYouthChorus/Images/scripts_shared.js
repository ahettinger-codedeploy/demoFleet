
var is_msie = (navigator.appName == "Microsoft Internet Explorer") ? true : false;


// global variables 





function val_form_simple(formname) {
filled = true;
	for(i=0;i<document[formname].elements.length-1;i++) {
		if(!document[formname].elements[i].value && document[formname].elements[i].name != 'othertext') {
		alert('You must fill out the form completely.');
		filled = false;
		break;
		}
	}
	if (filled) {
	document[formname].submit();
	}
}

// BYCA audition form

function val_form_audition() {

// test gender
gender_choice = false;
	for(i=0;i<document.auditionform.gender.length;i++) {
		if(document.auditionform.gender[i].checked)
		gender_choice = true;
	}

	if (!document.auditionform.fname.value) {
	document.auditionform.fname.focus();
	alert("You must enter the child's FIRST name.");
	return false;
	} else if (!document.auditionform.lname.value) {
	document.auditionform.lname.focus();
	alert("You must enter the child's LAST name.");
	return false;
	} else if (!document.auditionform.dob.value) {
	document.auditionform.dob.focus();
	alert("You must enter the child's DATE OF BIRTH.");
	return false;
	} else if (!document.auditionform.age.value) {
	document.auditionform.age.focus();
	alert("You must enter the child's CURRENT AGE.");
	return false;
	} else if (!gender_choice) {
	alert("You must select the child's GENDER.");
	return false;
	} else if (!document.auditionform.grade.value) {
	document.auditionform.grade.focus();
	alert("You must enter the child's GRADE.");
	return false;
	} else if (!document.auditionform.parent.value) {
	document.auditionform.parent.focus();
	alert("You must enter the child's PARENT OR GUARDIAN NAME.");
	return false;
	} else if (!document.auditionform.email.value) {
	document.auditionform.email.focus();
	alert("You must enter the EMAIL ADDRESS.");
	return false;
	/*} else if (!document.auditionform.how1.checked && !document.auditionform.how2.checked && !document.auditionform.how3.checked && !document.auditionform.how4.checked && !document.auditionform.how5.checked) {
	alert("You must enter HOW YOU HEARD OF BYCA.");
	return false;*/
	} else {
	document.auditionform.submit();
	}
}



// BYCA alumni form

function val_form_alumni() {

	if (!document.alumniform.fname.value) {
	document.alumniform.fname.focus();
	alert("You must enter your FIRST name.");
	return false;
	} else if (!document.alumniform.lname.value) {
	document.alumniform.lname.focus();
	alert("You must enter your LAST name.");
	return false;
	} else if (!document.alumniform.email.value) {
	document.alumniform.email.focus();
	alert("You must enter your EMAIL ADDRESS.");
	return false;
	} else if (!document.alumniform.address.value) {
	document.alumniform.address.focus();
	alert("You must enter your home ADDRESS.");
	return false;
	} else if (!document.alumniform.city.value) {
	document.alumniform.city.focus();
	alert("You must enter your CITY.");
	return false;
	} else if (!document.alumniform.zip.value) {
	document.alumniform.zip.focus();
	alert("You must enter your ZIP CODE.");
	return false;
	} else if (!document.alumniform.homephone.value) {
	document.alumniform.homephone.focus();
	alert("You must enter your HOME PHONE NUMBER.");
	return false;
	} else if (!document.alumniform.homephone.value) {
	document.alumniform.homephone.focus();
	alert("You must enter your HOME PHONE NUMBER.");
	return false;
	} else {
	document.alumniform.submit();
	}
}



// BYCA absense exception form

function val_form_absense() {

// test if absense type selected
type_chosen = false;
	for(i=0;i<document.exceptionform.absense_type.length;i++) {
		if(document.exceptionform.absense_type[i].checked) {
		type_chosen = true;
		type_choice = document.exceptionform.absense_type[i].value;
		}
	}


	if (!document.exceptionform.name.value) {
	document.exceptionform.name.focus();
	alert("You must enter the chorister's NAME.");
	return false;
	} else if (document.exceptionform.division.value == 'x') {
	alert("You must select a DIVISION.");
	return false;
	} else if (!type_chosen) {
	alert("You must choose the TYPE of absense.");
	return false;
	} else if (type_choice == 'regular' && !document.exceptionform.exdate.value) {
	document.exceptionform.exdate.focus();
	alert("You must enter the REHEARSAL DATE(S).");
	return false;
	} else if (type_choice == 'regular' && !document.exceptionform.reason.value) {
	document.exceptionform.reason.focus();
	alert("You must enter a REASON for the absense.");
	return false;
	} else if (type_choice == 'performance' && !document.exceptionform.exconcert.checked && !document.exceptionform.exdress.checked) {
	alert("You must specify one PERFORMACE EXCEPTION REQUEST TYPE.");
	return false;
	} else if (type_choice == 'performance' && document.exceptionform.exconcert.checked && !document.exceptionform.conname.value) {
	document.exceptionform.exdate.focus();
	alert("Please enter the CONCERT PERFORMANCE(S).");
	return false;
	} else if (type_choice == 'performance' && document.exceptionform.exdress.checked && !document.exceptionform.rehearsal.value) {
	document.exceptionform.reason.focus();
	alert("Please enter the DRESS/TECH REHEARSAL(S).");
	return false;
	} else if (type_choice == 'performance' && !document.exceptionform.prefreason.value) {
	document.exceptionform.prefreason.focus();
	alert("Please enter the REASON for the exception request.");
	return false;
	} else if (type_choice == 'performance' && document.exceptionform.exdress.checked && !document.exceptionform.excheck.checked) {
	document.exceptionform.reason.focus();
	alert("You must check the I UNDERSTAND checkbox.");
	return false;
	} else if (!document.exceptionform.parentname.value) {
	document.exceptionform.parentname.focus();
	alert("You must enter the PARENT/GUARDIAN NAME.");
	return false;
	} else {
	document.exceptionform.submit();
	}
}



// BYCA password form

function val_passwordform() {

	if (!document.passwordform.password.value) {
	document.passwordform.password.focus();
	alert("You must enter a password.");
	return false;
	} else if (document.passwordform.password.value && document.passwordform.password.value != document.passwordform.password_repeat.value) {
	alert("The passwords do not match.");
	return false;
	} else {
	document.passwordform.submit();
	}
}





function go_page(page_name) {
top.window.location.href=page_name;
}

function go_page_replace(page_name) {
top.window.location.replace(page_name);
}


var cases_ids = ['cases_challenge','cases_solution','cases_results'];

function show_cases(case_num) {

	for(i=0;i<cases_ids.length;i++) {
	get_el(cases_ids[i]).style.display = 'none';
	get_el(cases_ids[i]+'_link').className = 'nav_off';
	}
get_el(cases_ids[case_num]).style.display = 'block';
get_el(cases_ids[case_num]+'_link').className = 'nav_on';

}


var locstr = String(top.window.location);
var q_preview = (locstr.search('previewpage') != -1 || locstr.search('previewcategory') != -1 || locstr.search('previewsection') != -1) ? true : false;

var dir_img = (local_dev) ? '/~asmoller/cms_master/img' : '/img';

function get_el(d) {
	return document.getElementById(d);
}

function hide_div(d) {
	document.getElementById(d).style.display = "none";
}

function show_div(d) {
	document.getElementById(d).style.display = "block";
}


function show_hide_div(id,zindex) {
var el = document.getElementById(id);
	if (el.style.display != "none") {
	el.style.display = "none";
		if (zindex) {
		el.style.zIndex = "0";
		}
	}
	else {
	el.style.display = "";
		if (zindex) {
		el.style.zIndex = zindex;
		}
	}
}


function make_page_title(common_page_title,page_title) {
page_title = (page_title) ? ' :: '+page_title : '';
document.title = (common_page_title+page_title);
}


function preload_img(img_path) {
var img_file = new Image();
img_file.src = img_path;
}




var fade_timer;
var div_fadeamt = 0;
var fade_div_name;

function fade_div(div_name,direction,max_opacity) {
	max_opacity = (!max_opacity) ? 10 : max_opacity;
	if (!is_msie) {
	fade_div_name = div_name;
var divobj = document.all ? document.all[div_name] : document.getElementById ? document.getElementById(div_name) : "";
	//clearTimeout(fade_timer);
	if (direction == 'in') {
		divobj.style.display = "";
		//show_hide_div(fade_div_name,'1000');
		if(div_fadeamt < max_opacity) {
		div_fadeamt++;
		divobj.style.filter = "alpha(opacity="+div_fadeamt*10+")";
		divobj.style.opacity = div_fadeamt/10;
		fade_timer = setTimeout("fade_div('"+fade_div_name+"','in',"+max_opacity+")",15);
		} else {
		clearTimeout(fade_timer);
		}
	} else if (direction == 'out') {
		if(div_fadeamt > 0) {
		div_fadeamt--;
		divobj.style.filter = "alpha(opacity="+div_fadeamt*10+")";
		divobj.style.opacity = div_fadeamt/10;
		fade_timer = setTimeout("fade_div('"+fade_div_name+"','out')",20);
		} else {
		clearTimeout(fade_timer);
		//show_hide_div(fade_div_name,'0');
		divobj.style.display = "none";
		div_fadeamt = 0;
		}
	}
	} else {
		show_hide_div(div_name,'100');
	}
}





function load_map() {

	if (GBrowserIsCompatible()) {
	var map = new GMap2(document.getElementById('contactmap'));
	var marker = new GMarker(new GLatLng(40.715468,-74.005601));
	var infowin_content = '<span class="map_bubble">Ritchie | Tye<br>299 Broadway #1105<br>New York, NY 10007<br><a href="http://maps.google.com/maps?f=q&source=s_q&hl=en&geocode=&q=Ritchie Tye+299+Broadway+Suite+1105+New+York,+NY+10007&sll=40.723649,-73.997984&sspn=0.010229,0.022724&ie=UTF8&hq=&hnear=299+Broadway+%231105,+New+York,+10007&ll=40.716119,-74.001224&spn=0.01023,0.022724&z=16&iwloc=A&iwstate1=dir" target="_blank">directions</a></span>';
	
	map.setCenter(new GLatLng(40.717019,-74.004404), 16);
		if (is_msie) {
		map.addControl(new GSmallMapControl());
		} else {
		map.addControl(new GSmallZoomControl3D()); 
		}
	map.enableScrollWheelZoom();
	
	GEvent.addListener(marker, "click", function() {
	marker.openInfoWindowHtml(infowin_content);
	});
	map.addOverlay(marker);
	}

marker.openInfoWindowHtml(infowin_content);
}


function createMarker(latlng, imageURL, imageSize) {  
var marker = new GIcon(G_DEFAULT_ICON, imageURL);  
marker.iconSize = imageSize;  
return new GMarker(latlng, { icon: marker });  
}  



function esc_close_window(evt) {
	if (evt.keyCode == 27) {
	}
}


function capture_key(evt) {
	if (evt.keyCode == 37) {
	go_portfolio('back');
	} else if (evt.keyCode == 39) {
	go_portfolio('next');
	}
}




function womOn(){
window.onload = womGo;
}

function womGo(){
	for(var i = 0;i < woms.length;i++)
	eval(woms[i]);
}

function womAdd(func){
woms[woms.length] = func;
}

var woms = new Array();



// BYCA
function confirm_audition_delete(page_name) {
	do_delete = confirm('Are you sure you want to delete this audition request?\n\nThis can not be undone.');

	if (do_delete)
	top.window.location.href=page_name;
}

