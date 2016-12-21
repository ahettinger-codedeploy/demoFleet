
if (!Date.parseDate) {
	Date.parseDate = function(str, fmt) {
		var today = new Date();
		var y = 0;
		var m = -1;
		var d = 0;
		var a = str.split(/\W+/);
		var b = fmt.match(/%./g);
		var i = 0, j = 0;
		var hr = 0;
		var min = 0;
		for (i = 0; i < a.length; ++i) {
			if (!a[i])
				continue;
			switch (b[i]) {
					case "%d":
					case "%e":
				d = parseInt(a[i], 10);
				break;
	
					case "%m":
				m = parseInt(a[i], 10) - 1;
				break;
	
					case "%Y":
					case "%y":
				y = parseInt(a[i], 10);
				(y < 100) && (y += (y > 29) ? 1900 : 2000);
				break;
	
					case "%b":
					case "%B":
				for (j = 0; j < 12; ++j) {
					if (MonthPicker_months[j].substr(0, a[i].length).toLowerCase() == a[i].toLowerCase()) { m = j; break; }
				}
				break;
	
					case "%H":
					case "%I":
					case "%k":
					case "%l":
				hr = parseInt(a[i], 10);
				break;
	
					case "%P":
					case "%p":
				if (/pm/i.test(a[i]) && hr < 12)
					hr += 12;
				else if (/am/i.test(a[i]) && hr >= 12)
					hr -= 12;
				break;
	
					case "%M":
				min = parseInt(a[i], 10);
				break;
			}
		}
		if (isNaN(y)) y = today.getFullYear();
		if (isNaN(m)) m = today.getMonth();
		if (isNaN(d)) d = today.getDate();
		if (isNaN(hr)) hr = today.getHours();
		if (isNaN(min)) min = today.getMinutes();
		if (y != 0 && m != -1 && d != 0)
			return new Date(y, m, d, hr, min, 0);
		y = 0; m = -1; d = 0;
		for (i = 0; i < a.length; ++i) {
			if (a[i].search(/[a-zA-Z]+/) != -1) {
				var t = -1;
				for (j = 0; j < 12; ++j) {
					if (MonthPicker_months[j].substr(0, a[i].length).toLowerCase() == a[i].toLowerCase()) { t = j; break; }
				}
				if (t != -1) {
					if (m != -1) {
						d = m+1;
					}
					m = t;
				}
			} else if (parseInt(a[i], 10) <= 12 && m == -1) {
				m = a[i]-1;
			} else if (parseInt(a[i], 10) > 31 && y == 0) {
				y = parseInt(a[i], 10);
				(y < 100) && (y += (y > 29) ? 1900 : 2000);
			} else if (d == 0) {
				d = a[i];
			}
		}
		if (y == 0)
			y = today.getFullYear();
		if (m != -1 && d != 0)
			return new Date(y, m, d, hr, min, 0);
		return today;
	};
}

if (!Date.prototype.print) {
	Date.prototype.print = function (str) {
		var m = this.getMonth();
		var d = this.getDate();
		var y = this.getFullYear();
//		var wn = this.getWeekNumber();
		var w = this.getDay();
		var s = {};
		var hr = this.getHours();
		var pm = (hr >= 12);
		var ir = (pm) ? (hr - 12) : hr;
//		var dy = this.getDayOfYear();
		if (ir == 0)
			ir = 12;
		var min = this.getMinutes();
		var sec = this.getSeconds();
//		s["%a"] = Calendar._SDN[w]; // abbreviated weekday name [FIXME: I18N]
//		s["%A"] = Calendar._DN[w]; // full weekday name
//		s["%b"] = Calendar._SMN[m]; // abbreviated month name [FIXME: I18N]
		s["%B"] = MonthPicker_months[m]; // full month name
		// FIXME: %c : preferred date and time representation for the current locale
		s["%C"] = 1 + Math.floor(y / 100); // the century number
		s["%d"] = (d < 10) ? ("0" + d) : d; // the day of the month (range 01 to 31)
		s["%e"] = d; // the day of the month (range 1 to 31)
		// FIXME: %D : american date style: %m/%d/%y
		// FIXME: %E, %F, %G, %g, %h (man strftime)
		s["%H"] = (hr < 10) ? ("0" + hr) : hr; // hour, range 00 to 23 (24h format)
		s["%I"] = (ir < 10) ? ("0" + ir) : ir; // hour, range 01 to 12 (12h format)
//		s["%j"] = (dy < 100) ? ((dy < 10) ? ("00" + dy) : ("0" + dy)) : dy; // day of the year (range 001 to 366)
		s["%k"] = hr;		// hour, range 0 to 23 (24h format)
		s["%l"] = ir;		// hour, range 1 to 12 (12h format)
		s["%m"] = (m < 9) ? ("0" + (1+m)) : (1+m); // month, range 01 to 12
		s["%M"] = (min < 10) ? ("0" + min) : min; // minute, range 00 to 59
		s["%n"] = "\n";		// a newline character
		s["%p"] = pm ? "PM" : "AM";
		s["%P"] = pm ? "pm" : "am";
		// FIXME: %r : the time in am/pm notation %I:%M:%S %p
		// FIXME: %R : the time in 24-hour notation %H:%M
		s["%s"] = Math.floor(this.getTime() / 1000);
		s["%S"] = (sec < 10) ? ("0" + sec) : sec; // seconds, range 00 to 59
		s["%t"] = "\t";		// a tab character
		// FIXME: %T : the time in 24-hour notation (%H:%M:%S)
//		s["%U"] = s["%W"] = s["%V"] = (wn < 10) ? ("0" + wn) : wn;
		s["%u"] = w + 1;	// the day of the week (range 1 to 7, 1 = MON)
		s["%w"] = w;		// the day of the week (range 0 to 6, 0 = SUN)
		// FIXME: %x : preferred date representation for the current locale without the time
		// FIXME: %X : preferred time representation for the current locale without the date
		s["%y"] = ('' + y).substr(2, 2); // year without the century (range 00 to 99)
		s["%Y"] = y;		// year with the century
		s["%%"] = "%";		// a literal '%' character
	
		var re = /%./g;
//		if (!Calendar.is_ie5 && !Calendar.is_khtml)
//			return str.replace(re, function (par) { return s[par] || par; });
	
		var a = str.match(re);
		for (var i = 0; i < a.length; i++) {
			var tmp = s[a[i]];
			if (tmp) {
				re = new RegExp(a[i], 'g');
				str = str.replace(re, tmp);
			}
		}
	
		return str;
	};
}

var MonthPicker_months = new Array(_l("January"), _l("February"), _l("March"), _l("April"), _l("May"), _l("June"), _l("July"), _l("August"), _l("September"), _l("October"), _l("November"), _l("December"));

var MonthPicker = Class.create();
MonthPicker.prototype = {
    monthArray: new Array(),
		monthDisplayArray: new Array(),
		prevYear: null,
		nextYear: null,
    element: null,
    trigger: null,
    tableShown: false,
		divElement: null,
		callback: null,
    
    initialize: function(element, trigger, callback) {
        this.element = $(element);
        this.trigger = $(trigger);
				this.callback = callback;
        
				// Hook into onclick event
        this.trigger.onclick = this.toggleTable.bindAsEventListener(this);
    },
		getXYElementPos: function(elementOrId) {
				var x = 0, y = 0, element;
				
				element = $(elementOrId);
				if (element && element.offsetParent) {
					do {
						x += element.offsetLeft;
						y += element.offsetTop;
					} while (element = element.offsetParent);
				}
				
				return [ x, y ];
		},
    initMonthArray: function(centerDate) {
				var dateval = Date.parseDate(centerDate, "%Y-%m-%d");
        this.monthArray = new Array();
				this.monthDisplayArray = new Array();
        for(i = -3; i < 13; i++) {
						var month = dateval.getMonth();
						var year = dateval.getFullYear();
						month += i;
						if ( month < 0 ) {
							year --;
							month += 12;
						}
						if ( month > 11 ) {
							year ++;
							month -= 12;
						}
						var datevalcalc = new Date(year, month, 15);
            this.monthDisplayArray.push(MonthPicker_months[datevalcalc.getMonth()] + " " + datevalcalc.getFullYear());
						this.monthArray.push(datevalcalc);
        }
				var prevYear = new Date(dateval.getFullYear() - 1, dateval.getMonth(), dateval.getDate());
				this.prevYear = prevYear.print("%Y-%m-%d");
				var nextYear = new Date(dateval.getFullYear() + 1, dateval.getMonth(), dateval.getDate());
				this.nextYear = nextYear.print("%Y-%m-%d");
				
				var currentval = Date.parseDate(this.element.value, "%Y-%m-%d");
				this.currentMonthDisplay = MonthPicker_months[currentval.getMonth()] + " " + currentval.getFullYear();
    },
    buildTable: function() {
				html = "<div id=\"" + this.trigger.id + "MonthPicker\" class=\"monthPicker\" style=\"display: none\">";
				html += "<table id=\"" + this.trigger.id + "MonthPickerTable\">"
				html += "<tr>";
				html += "<td id=\"" + this.trigger.id + "MonthPickerPrev\" width=\"50%\" align=\"center\" title=\"Go backward 12 months\"> &lt;&lt; </td>";
				html += "<td id=\"" + this.trigger.id + "MonthPickerNext\" width=\"50%\" align=\"center\" title=\"Go forward 12 months\"> &gt;&gt; </td>";
				html += "</tr>";
				for(i = 0; i < this.monthArray.length; i++) {
						if (this.monthDisplayArray[i] == this.currentMonthDisplay) {
							myclass = "monthPickerCurrentMonth";
						}
						else {
							myclass = "monthPickerMonth";
						}
						html += "<tr>";
						html += "<td class=\"" + myclass + "\" colspan=\"2\" id=\"" + this.trigger.id + "MonthPickerMonth" + i + "\">";
						html += this.monthDisplayArray[i];
						html += "</td>";
						html += "</tr>";
				}
				html += "</table>";
				html += "</div>";
        if(!this.tableShown) {
            this.trigger.insert({ after: html });
						this.tableShown = true;
				}
				else {
						this.divElement.replace(html);
				}
				this.divElement = $(this.trigger.id + "MonthPicker");
				document.body.appendChild(this.divElement);
				$(this.trigger.id + "MonthPickerPrev").onclick = this.gotoPrevYear.bindAsEventListener(this);
				$(this.trigger.id + "MonthPickerPrev").onmouseover = this.mouseOver.bindAsEventListener(this);
				$(this.trigger.id + "MonthPickerPrev").onmouseout = this.mouseOut.bindAsEventListener(this);
				$(this.trigger.id + "MonthPickerNext").onclick = this.gotoNextYear.bindAsEventListener(this);
				$(this.trigger.id + "MonthPickerNext").onmouseover = this.mouseOver.bindAsEventListener(this);
				$(this.trigger.id + "MonthPickerNext").onmouseout = this.mouseOut.bindAsEventListener(this);
				for (i = 0; i < this.monthArray.length; i++) {
						$(this.trigger.id + "MonthPickerMonth" + i).onclick = this.clickMonth.bindAsEventListener(this, i);
						$(this.trigger.id + "MonthPickerMonth" + i).onmouseover = this.mouseOver.bindAsEventListener(this);
						$(this.trigger.id + "MonthPickerMonth" + i).onmouseout = this.mouseOut.bindAsEventListener(this);
				}
				var xy = this.getXYElementPos(this.trigger);
				this.divElement.style.top = (xy[1] + this.trigger.offsetHeight + 2) + "px";
				this.divElement.style.left = xy[0] + "px";

    },
		mouseOver: function(myevent) {
			var elem = Event.element(myevent);
			elem.addClassName('monthPickerHilite');
		},
		mouseOut: function(myevent) {
			var elem = Event.element(myevent);
			elem.removeClassName('monthPickerHilite');
		},
		clickMonth: function(myevent, index) {
				if (index >= 0 && index < this.monthArray.length) {
					var newval = this.monthArray[index].print("%Y-%m-%d");
					if (this.element.value != newval) {
							this.element.value = newval;
							if (this.callback)
									this.callback(newval);
					}
				}
				return this.toggleTable(myevent);
		},
		gotoPrevYear: function(myevent) {
				if (this.divElement && this.divElement.style.display == 'block')
					this.divElement.style.display = 'none';
				this.initMonthArray(this.prevYear);
				this.buildTable();
				this.divElement.style.display = 'block';
				return Event.stop(myevent);
		},
		gotoNextYear: function(myevent) {
				if (this.divElement && this.divElement.style.display == 'block')
					this.divElement.style.display = 'none';
				this.initMonthArray(this.nextYear);
				this.buildTable();
				this.divElement.style.display = 'block';
				return Event.stop(myevent);
		},
		docClick: function(myevent) {
				var elem = Event.element(myevent);
				for (; elem != null && elem != this.divElement; elem = elem.parentNode);
				if (elem == null) {
					return this.toggleTable(myevent);
				}
		},
		docKey: function(myevent) {
				var key = myevent.keyCode;
				if (key == 27) {
					return this.toggleTable(myevent);
				}
		},
    toggleTable: function(myevent) {
				if (!this.divElement || this.divElement.style.display == 'none') {
						// Initialise the color array
        		this.initMonthArray(this.element.value);
 	      		this.buildTable();
				}
				if (this.divElement.style.display != 'block') {
	        this.divElement.style.display = 'block';
					this.docClick_bound = this.docClick.bindAsEventListener(this);
					this.docKey_bound = this.docKey.bindAsEventListener(this);
					Event.observe(document, 'click', this.docClick_bound);
					Event.observe(document, 'keydown', this.docKey_bound);
				}
				else {
	        this.divElement.style.display = 'none';
					Event.stopObserving(document, 'click', this.docClick_bound);
					Event.stopObserving(document, 'keydown', this.docKey_bound);
				}
				return Event.stop(myevent);
    }
};

