/*
 * Date Format 1.2.3
 * (c) 2007-2009 Steven Levithan <stevenlevithan.com>
 * MIT license
 *
 * Includes enhancements by Scott Trenda <scott.trenda.net>
 * and Kris Kowal <cixar.com/~kris.kowal/>
 *
 * Accepts a date, a mask, or a date and a mask.
 * Returns a formatted version of the given date.
 * The date defaults to the current date/time.
 * The mask defaults to dateFormat.masks.default.
 */

var dateFormat = function () {
	var	token = /d{1,4}|m{1,4}|yy(?:yy)?|([HhMsTt])\1?|[LloSZ]|"[^"]*"|'[^']*'/g,
		timezone = /\b(?:[PMCEA][SDP]T|(?:Pacific|Mountain|Central|Eastern|Atlantic) (?:Standard|Daylight|Prevailing) Time|(?:GMT|UTC)(?:[-+]\d{4})?)\b/g,
		timezoneClip = /[^-+\dA-Z]/g,
		pad = function (val, len) {
			val = String(val);
			len = len || 2;
			while (val.length < len) val = "0" + val;
			return val;
		};

	// Regexes and supporting functions are cached through closure
	return function (date, mask, utc) {
		var dF = dateFormat;

		// You can't provide utc if you skip other args (use the "UTC:" mask prefix)
		if (arguments.length == 1 && Object.prototype.toString.call(date) == "[object String]" && !/\d/.test(date)) {
			mask = date;
			date = undefined;
		}
		var saveDate = date;
		// Passing date through Date applies Date.parse, if necessary
		date = date ? new Date(date) : new Date;
		if (isNaN(date)) { alert("invalid date: "+saveDate); throw SyntaxError("invalid date"); }

		mask = String(dF.masks[mask] || mask || dF.masks["default"]);

		// Allow setting the utc argument via the mask
		if (mask.slice(0, 4) == "UTC:") {
			mask = mask.slice(4);
			utc = true;
		}

		var	_ = utc ? "getUTC" : "get",
			d = date[_ + "Date"](),
			D = date[_ + "Day"](),
			m = date[_ + "Month"](),
			y = date[_ + "FullYear"](),
			H = date[_ + "Hours"](),
			M = date[_ + "Minutes"](),
			s = date[_ + "Seconds"](),
			L = date[_ + "Milliseconds"](),
			o = utc ? 0 : date.getTimezoneOffset(),
			flags = {
				d:    d,
				dd:   pad(d),
				ddd:  dF.i18n.dayNames[D],
				dddd: dF.i18n.dayNames[D + 7],
				m:    m + 1,
				mm:   pad(m + 1),
				mmm:  dF.i18n.monthNames[m],
				mmmm: dF.i18n.monthNames[m + 12],
				yy:   String(y).slice(2),
				yyyy: y,
				h:    H % 12 || 12,
				hh:   pad(H % 12 || 12),
				H:    H,
				HH:   pad(H),
				M:    M,
				MM:   pad(M),
				s:    s,
				ss:   pad(s),
				l:    pad(L, 3),
				L:    pad(L > 99 ? Math.round(L / 10) : L),
				t:    H < 12 ? "a"  : "p",
				tt:   H < 12 ? "am" : "pm",
				T:    H < 12 ? "A"  : "P",
				TT:   H < 12 ? "AM" : "PM",
				Z:    utc ? "UTC" : (String(date).match(timezone) || [""]).pop().replace(timezoneClip, ""),
				o:    (o > 0 ? "-" : "+") + pad(Math.floor(Math.abs(o) / 60) * 100 + Math.abs(o) % 60, 4),
				S:    ["th", "st", "nd", "rd"][d % 10 > 3 ? 0 : (d % 100 - d % 10 != 10) * d % 10]
			};

		return mask.replace(token, function ($0) {
			return $0 in flags ? flags[$0] : $0.slice(1, $0.length - 1);
		});
	};
}();

// Some common format strings
dateFormat.masks = {
	"default":      "ddd mmm dd yyyy HH:MM:ss",
	shortDate:      "m/d/yy",
	mediumDate:     "mmm d, yyyy",
	longDate:       "mmmm d, yyyy",
	fullDate:       "dddd, mmmm d, yyyy",
	shortTime:      "h:MM TT",
	mediumTime:     "h:MM:ss TT",
	longTime:       "h:MM:ss TT Z",
	isoDate:        "yyyy-mm-dd",
	isoTime:        "HH:MM:ss",
	isoDateTime:    "yyyy-mm-dd'T'HH:MM:ss",
	isoUtcDateTime: "UTC:yyyy-mm-dd'T'HH:MM:ss'Z'"
};

// Internationalization strings
dateFormat.i18n = {
	dayNames: [
		"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat",
		"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
	],
	monthNames: [
		"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
		"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
	]
};

// For convenience...
Date.prototype.format = function (mask, utc) {
	return dateFormat(this, mask, utc);
};

function findPos(obj) {
	var cleft = 0;
    var ctop = 0;
    if (obj.offsetParent) {
			do {
				cleft += obj.offsetLeft;
				ctop += obj.offsetTop;
			} while (obj = obj.offsetParent);
    }
    return [ctop,cleft];
}


/* color picker */

var colorData = [
    [  '#111111' , 'Obsidian' ],
    [  '#2D2D2D' , 'Dark Gray' ],
    [  '#434343' , 'Shale' ],
    [  '#5B5B5B' , 'Flint' ],
    [  '#737373' , 'Gray' ],
    [  '#8B8B8B' , 'Concrete' ],
    [  '#A2A2A2' , 'Gray' ],
    [  '#B9B9B9' , 'Titanium' ],
    [  '#000000' , 'Black' ],
    [  '#D0D0D0' , 'Light Gray' ],
    [  '#E6E6E6' , 'Silver' ],
    [  '#FFFFFF' , 'White' ],
    [  '#BFBF00' , 'Pumpkin' ],
    [  '#FFFF00' , 'Yellow' ],
    [  '#FFFF40' , 'Banana' ],
    [  '#FFFF80' , 'Pale Yellow' ],
    [  '#FFFFBF' , 'Butter' ],
    [  '#525330' , 'Raw Siena' ],
    [  '#898A49' , 'Mildew' ],
    [  '#AEA945' , 'Olive' ],
    [  '#7F7F00' , 'Paprika' ],
    [  '#C3BE71' , 'Earth' ],
    [  '#E0DCAA' , 'Khaki' ],
    [  '#FCFAE1' , 'Cream' ],
    [  '#60BF00' , 'Cactus' ],
    [  '#80FF00' , 'Chartreuse' ],
    [  '#A0FF40' , 'Green' ],
    [  '#C0FF80' , 'Pale Lime' ],
    [  '#DFFFBF' , 'Light Mint' ],
    [  '#3B5738' , 'Green' ],
    [  '#668F5A' , 'Lime Gray' ],
    [  '#7F9757' , 'Yellow' ],
    [  '#407F00' , 'Clover' ],
    [  '#8A9B55' , 'Pistachio' ],
    [  '#B7C296' , 'Light Jade' ],
    [  '#E6EBD5' , 'Breakwater' ],
    [  '#00BF00' , 'Spring Frost' ],
    [  '#00FF80' , 'Pastel Green' ],
    [  '#40FFA0' , 'Light Emerald' ],
    [  '#80FFC0' , 'Sea Foam' ],
    [  '#BFFFDF' , 'Sea Mist' ],
    [  '#033D21' , 'Dark Forrest' ],
    [  '#438059' , 'Moss' ],
    [  '#7FA37C' , 'Medium Green' ],
    [  '#007F40' , 'Pine' ],
    [  '#8DAE94' , 'Yellow Gray Green' ],
    [  '#ACC6B5' , 'Aqua Lung' ],
    [  '#DDEBE2' , 'Sea Vapor' ],
    [  '#00BFBF' , 'Fog' ],
    [  '#00FFFF' , 'Cyan' ],
    [  '#40FFFF' , 'Turquoise Blue' ],
    [  '#80FFFF' , 'Light Aqua' ],
    [  '#BFFFFF' , 'Pale Cyan' ],
    [  '#033D3D' , 'Dark Teal' ],
    [  '#347D7E' , 'Gray Turquoise' ],
    [  '#609A9F' , 'Green Blue' ],
    [  '#007F7F' , 'Seaweed' ],
    [  '#96BDC4' , 'Green Gray' ],
    [  '#B5D1D7' , 'Soapstone' ],
    [  '#E2F1F4' , 'Light Turquoise' ],
    [  '#0060BF' , 'Summer Sky' ],
    [  '#0080FF' , 'Sky Blue' ],
    [  '#40A0FF' , 'Electric Blue' ],
    [  '#80C0FF' , 'Light Azure' ],
    [  '#BFDFFF' , 'Ice Blue' ],
    [  '#1B2C48' , 'Navy' ],
    [  '#385376' , 'Biscay' ],
    [  '#57708F' , 'Dusty Blue' ],
    [  '#00407F' , 'Sea Blue' ],
    [  '#7792AC' , 'Sky Blue Gray' ],
    [  '#A8BED1' , 'Morning Sky' ],
    [  '#DEEBF6' , 'Vapor' ],
    [  '#0000BF' , 'Deep Blue' ],
    [  '#0000FF' , 'Blue' ],
    [  '#4040FF' , 'Cerulean Blue' ],
    [  '#8080FF' , 'Evening Blue' ],
    [  '#BFBFFF' , 'Light Blue' ],
    [  '#212143' , 'Deep Indigo' ],
    [  '#373E68' , 'Sea Blue' ],
    [  '#444F75' , 'Night Blue' ],
    [  '#00007F' , 'Indigo Blue' ],
    [  '#585E82' , 'Dockside' ],
    [  '#8687A4' , 'Blue Gray' ],
    [  '#D2D1E1' , 'Light Blue Gray' ],
    [  '#6000BF' , 'Neon Violet' ],
    [  '#8000FF' , 'Blue Violet' ],
    [  '#A040FF' , 'Violet Purple' ],
    [  '#C080FF' , 'Violet Dusk' ],
    [  '#DFBFFF' , 'Pale Lavender' ],
    [  '#302449' , 'Cool Shale' ],
    [  '#54466F' , 'Dark Indigo' ],
    [  '#655A7F' , 'Dark Violet' ],
    [  '#40007F' , 'Violet' ],
    [  '#726284' , 'Smoky Violet' ],
    [  '#9E8FA9' , 'Slate Gray' ],
    [  '#DCD1DF' , 'Violet White' ],
    [  '#BF00BF' , 'Royal Violet' ],
    [  '#FF00FF' , 'Fuchsia' ],
    [  '#FF40FF' , 'Magenta' ],
    [  '#FF80FF' , 'Orchid' ],
    [  '#FFBFFF' , 'Pale Magenta' ],
    [  '#4A234A' , 'Dark Purple' ],
    [  '#794A72' , 'Medium Purple' ],
    [  '#936386' , 'Cool Granite' ],
    [  '#7F007F' , 'Purple' ],
    [  '#9D7292' , 'Purple Moon' ],
    [  '#C0A0B6' , 'Pale Purple' ],
    [  '#ECDAE5' , 'Pink Cloud' ],
    [  '#BF005F' , 'Hot Pink' ],
    [  '#FF007F' , 'Deep Pink' ],
    [  '#FF409F' , 'Grape' ],
    [  '#FF80BF' , 'Electric Pink' ],
    [  '#FFBFDF' , 'Pink' ],
    [  '#451528' , 'Purple Red' ],
    [  '#823857' , 'Purple Dino' ],
    [  '#A94A76' , 'Purple Gray' ],
    [  '#7F003F' , 'Rose' ],
    [  '#BC6F95' , 'Antique Mauve' ],
    [  '#D8A5BB' , 'Cool Marble' ],
    [  '#F7DDE9' , 'Pink Granite' ],
    [  '#C00000' , 'Apple' ],
    [  '#FF0000' , 'Fire Truck' ],
    [  '#FF4040' , 'Pale Red' ],
    [  '#FF8080' , 'Salmon' ],
    [  '#FFC0C0' , 'Warm Pink' ],
    [  '#441415' , 'Sepia' ],
    [  '#82393C' , 'Rust' ],
    [  '#AA4D4E' , 'Brick' ],
    [  '#800000' , 'Brick Red' ],
    [  '#BC6E6E' , 'Mauve' ],
    [  '#D8A3A4' , 'Shrimp Pink' ],
    [  '#F8DDDD' , 'Shell Pink' ],
    [  '#BF5F00' , 'Dark Orange' ],
    [  '#FF7F00' , 'Orange' ],
    [  '#FF9F40' , 'Grapefruit' ],
    [  '#FFBF80' , 'Canteloupe' ],
    [  '#FFDFBF' , 'Wax' ],
    [  '#482C1B' , 'Dark Brick' ],
    [  '#855A40' , 'Dirt' ],
    [  '#B27C51' , 'Tan' ],
    [  '#7F3F00' , 'Nutmeg' ],
    [  '#C49B71' , 'Mustard' ],
    [  '#E1C4A8' , 'Pale Tan' ],
    [  '#FDEEE0' , 'Marble' ]
];
var colorDlg;
var colorPicker;
var colorName;
var colorPatch;
var colorPickerControlTrigger;
var colorPickerControlObj;
var colorPickerCallback;

function setupColorPicker(divName, divPickerName, divColorName, divColorPatch, callback) {
	var html = '';
	for (var i =0; i < colorData.length; i++) {
					if ((i % 12) == 0 && i !=0)
					{
							html += "<br>";
					}
				 html+= '<div style="background-color: ' + colorData[i][0] + ';color:'+colorData[i][0]+';border:1px solid white;width:10px;height:10px;display:inline;font-size:10px" onmouseover="showColor(\''+colorData[i][0]+'\', \''+colorData[i][1]+'\');this.style.border=\'1px solid black\';" onmouseout="this.style.border=\'1px solid white\';" onmousedown="setColor(\''+colorData[i][0]+'\');">&nbsp;&nbsp;&nbsp;</div>';
	}
	colorDlg = document.getElementById(divName);
	colorPicker = document.getElementById(divPickerName)
	colorName = document.getElementById(divColorName);
	colorPatch = document.getElementById(divColorPatch);
	colorPickerCallback = callback;
	colorPicker.innerHTML=html;
}

function showColor(c, n) {
	colorName.innerHTML=n;
	colorPatch.style.backgroundColor=c;
	colorPatch.style.color=c;
}

function setColor(c) {
	if (colorPickerControlTrigger != null) {
		colorPickerControlTrigger.value = c.substring(1); // everything except the leading #
	}
	if (colorPickerControlObj != null) {
		colorPickerControlObj.style.backgroundColor=c;
	}
	showColorPicker(null, false);
	if (colorPickerCallback != null) {
		colorPickerCallback();
	}
}

function showColorPicker(triggerObj, visible, controlObj) {
	if (visible) {
		if (triggerObj != null) {
			var xy = findPos(triggerObj);
			colorDlg.style.top = (xy[0]-120)+"px";
			colorDlg.style.left = (xy[1]+60)+"px";
		}
		colorDlg.style.visibility="visible";
		colorDlg.style.display="";
		colorPickerControlTrigger = triggerObj;
		if (triggerObj.value != "") {
			showColor("#"+triggerObj.value, "#"+triggerObj.value);
		}
		colorPickerControlObj = controlObj;
	} else {
		colorDlg.style.visibility="hidden";
		colorDlg.style.display="none";
		colorPickerControlTrigger = null;
		colorPickerControlObj = null;
	}
}

var saveBorder1;
var saveBorder2;
var flashObj;
var flashObj2;
var flashBorders = [ '2px solid orange', '2px solid black', '2px solid orange', '2px solid black'];
var flashCounter = 0;
function flashBorder(controlObj, controlObj2) {
	if (controlObj != null) {
		saveBorder = controlObj.style.border;
		flashObj = controlObj;
		flashCounter = 0;
	}
	if (controlObj2 != null) {
		saveBorder2 = controlObj2.style.border;
		flashObj2 = controlObj2;
	}
	if (flashCounter >= flashBorders.length) {
		if (flashObj != null) {
			flashObj.style.border = saveBorder;
			flashObj = null;
		}
		if (flashObj2 != null) {
			flashObj2.style.border = saveBorder2;
			flashObj2 = null;
		}
	} else {
		setTimeout('flashBorder(null)', 250);
		if (flashObj != null) {
			flashObj.style.border = flashBorders[flashCounter];
		}
		if (flashObj2 != null) {
			flashObj2.style.border = flashBorders[flashCounter];
		}
		flashCounter++;
	}
}

// silent asynch request to server
function saveToServerOnly(sessionVar, value) {
    var url="saveToServer.php"
    new Ajax.Request(url, {
        method: 'post',
				postBody: "sessionVar="+sessionVar+"&value="+value,
        onSuccess: function() {
            ;
        },
        onFailure: function(oXHR) {
            alert(oXHR.statusText);
        }
    });
}

/************************************************ ad support *************************************************/
var ad_vert_views = 16;
var ad_vert_side_percent = 85;
var ad_horz_views = 2;
var ad_refresh_views = 7; // number of views before forces a refresh

var adVertCounter = Math.floor(Math.random()*ad_vert_views);
var adLeaderCounter =  adVertCounter + (ad_horz_views / 2);
var adRefreshCounter = 1;

function showAds() {
	var leftAd = $('cal_vertical_left_ad');
	var rightAd = $('cal_vertical_right_ad');
	var linkAd = $('cal_horizontal_link_ad');
	var leaderboardAd = $('cal_horizontal_leaderboard_ad');
	// on 7/16/2010, Robert wanted to try full time leaderboard ads
		if (leaderboardAd != null) leaderboardAd.style.visibility = "visible";
		if (leaderboardAd != null) leaderboardAd.style.display = "block";
/*
	if ((adVertCounter % ad_vert_views) == 0) {
		var switcher = Math.floor(Math.random()*100);
		if (switcher < ad_vert_side_percent) {
			if (leftAd != null) leftAd.style.visibility = "visible";
			if (leftAd != null) leftAd.style.display = "block";
		} else {
			if (rightAd != null) rightAd.style.visibiilty = "visible";
			if (rightAd != null) rightAd.style.display = "block";
		}
	} else {
		if (leftAd != null) leftAd.style.visibility = "hidden";
		if (leftAd != null) leftAd.style.display = "none";
		if (rightAd != null) rightAd.style.visibiilty = "hidden";
		if (rightAd != null) rightAd.style.display = "none";
	}

	if ( (adLeaderCounter % ad_horz_views) == 0) {
		if (linkAd != null) linkAd.style.visibility = "hidden";
		if (linkAd != null) linkAd.style.display = "none";
		if (leaderboardAd != null) leaderboardAd.style.visibility = "visible";
		if (leaderboardAd != null) leaderboardAd.style.display = "block";
	} else {
		if (linkAd != null) linkAd.style.visibility = "visible";
		if (linkAd != null) linkAd.style.display = "block";
		if (leaderboardAd != null) leaderboardAd.style.visibility = "hidden";
		if (leaderboardAd != null) leaderboardAd.style.display = "none";
	}
*/
	adVertCounter++;
	adLeaderCounter++;

	if (linkAd != null) {
		// save the counters to the session
		saveToServerOnly("formAdCounters", adVertCounter+":"+adLeaderCounter)
	}
}

function restoreAdCounters(value) {
	if (value == null || value.length < 3) {
		return;
	}
	var values = value.split(":");
	adVertCounter = values[0];
	adLeaderCounter = values[1];
}

function checkForAdRefresh() {
	if (adRefreshCounter++ >= ad_refresh_views) {
		return true;
	}
	return false;
}