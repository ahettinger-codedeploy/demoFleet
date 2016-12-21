function showCalendar(dateField, linkElement, onchange, dateFormatPattern, weekstart, monthnames, daynames)
{
	var cal = new Calendar(dateField, linkElement, onchange, dateFormatPattern, weekstart, monthnames, daynames);
	if (linkElement) 
	{
		cal.showAtElement(linkElement);
	} else
	{
		cal.showAtElement(dateField);
	}

	cal.refresh();
}

Calendar = function(dateField, linkElement, onchange, dateFormatPattern, wks, monthnames, daynames)
{
	this.element = null;
	this.monthNames = monthnames ? monthnames : ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
	this.dayNames = daynames ? daynames : ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
	this.weekstart = wks;
	this.tbody = null;
	this.title = null;
	this.visible = false;
	this.dateField = dateField;
	this.onchange = onchange;
	this.linkElement = linkElement;
	this.dateFormatPattern = dateFormatPattern;
	this.closeOnClick = true;
	this.date = dateField.value ? parseDate(dateField.value, dateFormatPattern) : new Date();

	this.create();
};

function parseDate(dateString, dateFormatPattern)
{
	var dateStringPos = 0;
	var patternPos = 0;
	var maxPatternPos = dateFormatPattern.length;
	
	var month = -1;
	var day = -1;
	var year = -1;
	
	while (patternPos < maxPatternPos)
	{
		ch = dateFormatPattern.charAt(patternPos);
		
		while (patternPos < (maxPatternPos - 1) && dateFormatPattern.charAt(patternPos + 1) == ch) patternPos ++;

		if (patternPos < (maxPatternPos - 1))
		{
			var delimiter = dateFormatPattern.charAt(patternPos + 1);
			index = dateString.indexOf(delimiter, dateStringPos);
			patternPos ++;
		} else
		{
			index = dateString.length;
		}
		
		var s = ntrim(dateString.substr(dateStringPos, (index-dateStringPos)));
		
		if (ch == "M")
		{
			month = parseInt(s);
		} else
		if (ch == "d")
		{
			day = parseInt(s);
		} else
		if (ch == "y")
		{
			year = parseInt(s);
			if (! isNaN(year))
			{
				if (year < 50) year = year + 2000;
				if (year > 50 && year < 100) year = year + 1900;
			}
		}
		
		dateStringPos = index+1;
		patternPos++;
	}		
	
	if (isNaN(month) || isNaN(day) || isNaN(year))
	{
		return new Date();
	} else
	{	
		return new Date(year, month-1, day);
	}
}

function ntrim(str)
{
	var start = 0;
	var end = 0;
	var max = str.length;
	while ((start < max) && (str.charCodeAt(start) < 49 || str.charCodeAt(start) > 59)) start ++;
	
	end = start;
	while ((end < max) && (str.charCodeAt(end) >= 48) && (str.charCodeAt(end) <= 57)) end++;
	
	return str.substr(start, end);
}


Calendar.prototype.create = function()
{	
	var div = this.createElement("div");

	div.className = "calendar";
	div.style.position = "absolute";
	div.style.display = "none";

	var table = this.createElement("table");
	table.cellSpacing = 0;
	table.cellPadding = 0;
	table.calendar = this;

	div.appendChild(table);

	var thead = this.createElement("thead", table);
	

	// Create month, navigation header
	var row = this.createElement("tr", thead);
	var cell = this.createElement("td", row);
	cell.className = "title";
	cell.innerHTML = "<<<";
	cell.data = "m-1";
	cell.calendar = this;
	Calendar.addEventHandler(cell, "mousedown", Calendar.dayMouseDown); 
	Calendar.addEventHandler(cell, "mouseover", Calendar.mouseOver);
	Calendar.addEventHandler(cell, "mouseout", Calendar.mouseOut);		

	cell = this.createElement("td", row);
	cell.className = "title";
	cell.colSpan = 5;
	cell.innerHTML = "Month 2003";	
	this.title = cell;

	cell = this.createElement("td", row);
	cell.className = "title";
	cell.innerHTML = ">>";
	cell.data = "m+1";
	cell.calendar = this;

	Calendar.addEventHandler(cell, "mousedown", Calendar.dayMouseDown); 
	Calendar.addEventHandler(cell, "mouseover", Calendar.mouseOver);
	Calendar.addEventHandler(cell, "mouseout", Calendar.mouseOut);		

	// create weekday names 
	row = this.createElement("tr", thead);

	for (var i=0; i<7; i++) 
	{
		cell = this.createElement("td", row);
		cell.className = "daynames";
		cell.innerHTML = this.dayNames[(this.weekstart + i)%7];
	}


	var tbody = this.createElement("tbody", table);
	this.tbody = tbody;
	
	for (var ri=0; ri<6; ri++) 		
	{
		row = this.createElement("tr", tbody);

		for (var day=0; day<7; day++)	
		{
			var cell = this.createElement("td", row);
			cell.appendChild(document.createTextNode("x"));
			cell.calendar = this;

			Calendar.addEventHandler(cell, "mousedown", Calendar.dayMouseDown); 
			Calendar.addEventHandler(cell, "mouseover", Calendar.mouseOver);
			Calendar.addEventHandler(cell, "mouseout", Calendar.mouseOut);		}
	}

	document.getElementsByTagName("body")[0].appendChild(div);
	this.element = div;
}

Calendar.prototype.destroy = function()
{
	var element = this.element.parentNode();
	element.removeChild(this.element);
	window.calendar = null;
}


Calendar.prototype.setDate = function(date)
{
	this.date = date;
	this.refresh();
}

Calendar.prototype.changeMonth = function(value)
{
	this.date.setMonth(this.date.getMonth() + value);
	this.refresh();
}

Calendar.prototype.refresh = function()
{
	var month = this.date.getMonth();
	var year = this.date.getYear();
	
	if (year < 50) year = year + 2000;
	if (year > 50 && year < 150) year = year + 1900;

	var cal = new Date(this.date);

	var today = new Date();
	var todayDate = -1;
	if ((cal.getFullYear() == today.getFullYear()) && (cal.getMonth() == today.getMonth()))
	{
		todayDate = today.getDate();
	}

	var selectedDate = -1;
	if ((cal.getFullYear() == this.date.getFullYear()) && (cal.getMonth() == this.date.getMonth()))
	{
		selectedDate = this.date.getDate();
	}

   	cal.setDate(1);
	cal.setDate(1 - (7 + cal.getDay() - this.weekstart) % 7);

	// set title
	this.title.firstChild.data = this.monthNames[month] + " " + year;

	var row = this.tbody.firstChild;


	for (var ri=0; ri<6; ri++)
	{
		cell = row.firstChild;
		
		for (var i=0; i<7; i++)
		{
			cell.innerHTML = cal.getDate();
			cell.disabled = false;
			cell.className = "day";
			cell.data = cal.getDate();

			if (cal.getMonth() != this.date.getMonth())
			{
				cell.className += " disabled";
				cell.disabled = true;
			} else
			{
				if (cal.getDate() ==  todayDate)
				{
					cell.className += " today";
				} 

				if (cal.getDay() == 0 || cal.getDay() == 6)
				{
					cell.className += " weekend";
				} 

				if (cal.getDate() == selectedDate)
				{
					cell.className += " active";
				} 
			}

			cell = cell.nextSibling;
			cal.setDate(cal.getDate() + 1);
		}

		row = row.nextSibling;
	}					
}

Calendar.dayMouseDown = function(ev)
{
	var element = Calendar.getElement(ev);

	if (element.data == "m-1")
	{
		element.calendar.changeMonth(-1);		
	} else		
	if (element.data == "m+1")
	{
		element.calendar.changeMonth(1);		
	} else
	{
		calendar = element.calendar;
		var date = calendar.date;
		date.setDate(element.data);
		var result = "";
		var s = "";
		pos = 0;
		max = element.calendar.dateFormatPattern.length;
		
		while (pos < max)
		{
			ch = element.calendar.dateFormatPattern.charAt(pos);
			len = 1;
			while (pos < (max-1) && element.calendar.dateFormatPattern.charAt(pos+1) == ch)
			{
				pos++;
				len++;
			}

			if (ch == 'M')
			{
				s = (date.getMonth() + 1).toString();
				while (s.length < len) s = "0" + s;
				result = result + s;
			} else
			if (ch == 'd')
			{
				s = date.getDate().toString();
				while (s.length < len) s = "0" + s;
				result = result + s;
			} else
			if (ch == 'y')
			{
				if (len == 4)
				{
					s = "" + date.getFullYear();
				} else
				{
					s = "" + (date.getYear() % 100);
					if (s.length == 1) s = "0" + s;
				}
				result = result + s;
			} else
			{
				result = result + ch;
			}
			
			pos++;
		}		

		calendar.dateField.value = result;
		
		if (calendar.onchange == 'y')
		{
			calendar.dateField.onchange();
		}
		
		if (calendar.closeOnClick) calendar.hide();
	}
}

Calendar.mouseOver = function(ev)
{
	var element = Calendar.getElement(ev);
	Calendar.addClass(element, "hilite");
}

Calendar.mouseOut = function(ev)
{
	var element = Calendar.getElement(ev);
	Calendar.removeClass(element, "hilite");
}

Calendar.checkOutSideClick = function(ev)
{	
	var element = Calendar.is_ie ? Calendar.getElement(ev) : Calendar.getTargetElement(ev);

	for (; element != null && element != calendar.element; element = element.parentNode);
	if (element == null)
	{	
		window.calendar.hide();
	}
}


Calendar.getElement = function(ev)
{
	if (Calendar.is_ie)
	{
		return window.event.srcElement;
	} else
	{
		return ev.currentTarget;
	}
}

Calendar.getTargetElement = function(ev)
{
	if (Calendar.is_ie)
	{
		return window.event.srcElement;
	} else
	{
		return ev.target;
	}
}

Calendar.prototype.showAt = function (x, y) 
{
	var s = this.element.style;
	s.left = x + "px";
	s.top = y + "px";
	s.display = "block";
	this.visible = true;

	window.calendar = this;
	Calendar.addEventHandler(document, "mousedown", Calendar.checkOutSideClick);
	this.hideShowCovered();
};

Calendar.getAbsolutePos = function(el) {
	var SL = 0, ST = 0;
	var is_div = /^div$/i.test(el.tagName);
	if (is_div && el.scrollLeft)
		SL = el.scrollLeft;
	if (is_div && el.scrollTop)
		ST = el.scrollTop;
	var r = { x: el.offsetLeft - SL, y: el.offsetTop - ST };
	if (el.offsetParent) {
		var tmp = Calendar.getAbsolutePos(el.offsetParent);
		r.x += tmp.x;
		r.y += tmp.y;
	}
	return r;
};


Calendar.prototype.showAtElement = function(element)
{
	var p = Calendar.getAbsolutePos(element);
	this.showAt(p.x, p.y + element.offsetHeight);
}

Calendar.prototype.hide = function()
{
	this.element.style.display = "none";
	this.visible = false;

	Calendar.removeEventHandler(document, "mousedown", Calendar.checkOutSideClick);
	window.calendar = null;
	this.hideShowCovered();
}

Calendar.prototype.hideShowCovered = function () 
{
	var self = this;

	function getVisib(obj)
	{
		var value = obj.style.visibility;
		if (!value) 
		{
			if (document.defaultView && typeof (document.defaultView.getComputedStyle) == "function") 
			{ // Gecko, W3C
				if (!Calendar.is_khtml)
					value = document.defaultView.getComputedStyle(obj, "").getPropertyValue("visibility");
				else
					value = '';
			} else if (obj.currentStyle) 
			{ // IE
				value = obj.currentStyle.visibility;
			} else
				value = '';
		}
		return value;
	};

	var tags = new Array("applet", "iframe", "select");
	var el = self.element;

	var p = Calendar.getAbsolutePos(el);
	var EX1 = p.x;
	var EX2 = el.offsetWidth + EX1;
	var EY1 = p.y;
	var EY2 = el.offsetHeight + EY1;

	for (var k = tags.length; k > 0; ) 
	{
		var ar = document.getElementsByTagName(tags[--k]);
		var cc = null;

		for (var i = ar.length; i > 0;) 
		{
			cc = ar[--i];

			p = Calendar.getAbsolutePos(cc);
			var CX1 = p.x;
			var CX2 = cc.offsetWidth + CX1;
			var CY1 = p.y;
			var CY2 = cc.offsetHeight + CY1;

			if (self.hidden || (CX1 > EX2) || (CX2 < EX1) || (CY1 > EY2) || (CY2 < EY1)) 
			{
				if (!cc.__msh_save_visibility) 
				{
					cc.__msh_save_visibility = getVisib(cc);
				}

				cc.style.visibility = cc.__msh_save_visibility;
			} else 
			{
				if (!cc.__msh_save_visibility) 
				{
					cc.__msh_save_visibility = getVisib(cc);
				}

				cc.style.visibility = "hidden";
			}
		}
	}
};


Calendar.prototype.createElement = function(type, parent)
{
	var element = null;
	if (document.createElementNS)
	{
		element = document.createElementNS("http://www.w3.org/1999/xhtml", type);
	} else
	{
		element = document.createElement(type);
	}

	if (typeof parent != "undefined")
	{
		parent.appendChild(element);
	}

	return element;
}

Calendar.addClass = function(element, className)
{
	Calendar.removeClass(element, className);
	element.className += " " + className;
}

Calendar.removeClass = function(element, className)
{
	var cls = element.className.split(" ");
	var ar = new Array();
	for (var i=cls.length; i > 0;)
	{
		if (cls[--i] != className) 
		{
			ar[ar.length] = cls[i];
		}
	}

	element.className = ar.join(" ");
}		


Calendar.addEventHandler = function (element, eventName, func)
{
	if (element.attachEvent)
	{
		element.attachEvent("on" + eventName, func);
	} else if (element.addEventListener) 
	{
		element.addEventListener(eventName, func, true);
	} else
	{
		element["on" + eventName] = func;
	}
}


Calendar.removeEventHandler = function(element, eventName, func)
{
	if (element.detachEvent)
	{
		element.detachEvent("on" + eventName, func);
	} else if (element.removeEventListener)
	{
		element.removeEventListener(eventName, func, true);
	} else
	{
		element["on" + eventName] = null;
	}
}


Calendar.is_ie = ( / msie/i.test(navigator.userAgent) && ! /opera/i.test(navigator.userAgent));