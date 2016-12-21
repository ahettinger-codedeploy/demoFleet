var monthsTxt = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
var daysTxt = ['S','M','T','W','T','F','S'];

var Calendar = {
	active : 0,
	count : 0,
	
	add : function(input) { input = $(input);
		this.count++;
		input.calendar = this.count;
		input.insert({after: new Element('img', {src : XMS.url_root + 'xms/images/calendar.png', style : 'cursor: pointer', border : 0}).observe('mousedown',
			(function() {
				CALEvents.ignore_body_click = true;
				if(this.active != input.calendar) {
					this.load(input);
				} else {
					this.unload();
				}
			}).bindAsEventListener(this)
		)});
	},
	
	load : function(input) { input = $(input);

		if(this.active > 0) {
			this.unload();
		}
		
		this.active = input.calendar;
		
		var body = $(document.body);
		var pos = input.viewportOffset();
		var dpos = document.viewport.getScrollOffsets();
		var constyle = Object.clone(CALStyle.container);
		
		constyle.top = (constyle.top + input.getHeight() + pos.top + dpos.top) + 'px';
		constyle.left = (constyle.left + pos.left + dpos.left) + 'px';
		
		var container = new Element('div', {id : 'calc_object'}).setStyle(constyle).addClassName('calendar_container');
		
		var dobj = new Date();
		var tdayo = new Date();
		var stime = Date.parse(input.value);
		if(! isNaN(stime)) dobj.setTime(stime);
		
		var today = {
			month : tdayo.getMonth(),
			date : tdayo.getDate(),
			year : tdayo.getFullYear()
		};
		
		var mi = dobj.monthInfo();
		var lowerDayRange = mi.days + mi.weekday;
		var higherDayRange = Math.ceil(lowerDayRange / 7) * 7;
		var dayCount = 0;
		var offDay = 1;
		var day, month, year, dayStyle, dayClass;
		
		var back = new Element('div').setStyle(CALStyle.nav_left).addClassName('calendar_nav_left').insert("&laquo;").observe('click', CALNavEvents.click);
		var forward = new Element('div').setStyle(CALStyle.nav_right).addClassName('calendar_nav_right').insert("&raquo;").observe('click', CALNavEvents.click);
		
		back.day = mi.date;
		back.month = mi.month-1;
		back.year = mi.year;
		back.input = input;
		forward.day = mi.date;
		forward.month = mi.month+1;
		forward.year = mi.year;
		forward.input = input;
		
		var month_row = new Element('div').setStyle(CALStyle.month).addClassName('calendar_month');
		
		for(var rr=0; rr<7; rr++) {
			var rrow = new Element('div').setStyle(CALStyle.render_row).addClassName('calendar_render_row');
			if(rr==0) month_row.insert(rrow.insert(back));
			else if(rr==6) month_row.insert(rrow.insert(forward));
			else month_row.insert(rrow);
			//month_row.insert(rrow);
		}
			
		
		month_row.insert(new Element('div').setStyle(CALStyle.month_text).addClassName('calendar_month_text').insert(monthsTxt[mi.month] + ' ' + mi.year));
		
		container.insert(month_row);
		var dayhead_row = new Element('div').setStyle(CALStyle.dayhead_row).addClassName('calendar_day_header_row');
		
		for(var h=0; h<daysTxt.length; h++) {
			dayhead_row.insert(new Element('div').setStyle(CALStyle.dayhead).addClassName('calendar_day_header').insert(daysTxt[h]));
		}
		
		dayhead_row.insert(new Element('br').setStyle(CALStyle.br));
		container.insert(dayhead_row);
		container.insert(new Element('br').setStyle(CALStyle.br));
		
		for(var d=1; d <= higherDayRange; d++) {
			dayCount++;			
			
			var dayE = new Element('div').setStyle(CALStyle.day).addClassName('calendar_day');
			
			if(d <= mi.weekday) {
				day = mi.lastMonthDays+d-mi.weekday;
				month = mi.lastMonth;
				year = mi.lastYear;
				dayE.setStyle(CALStyle.offDay).addClassName('calendar_off_day');
			} else if(d <= lowerDayRange) {
				day = (d-mi.weekday)
				month = mi.month;
				year = mi.year;
				if(day == mi.date) dayE.setStyle(CALStyle.selected).addClassName('calendar_selected');
			} else {
				day = offDay;
				month = mi.nextMonth;
				year = mi.nextYear;
				dayE.setStyle(CALStyle.offDay).addClassName('calendar_off_day');
				offDay++;
			}
			
			if(month == today.month && day == today.date && year == today.year)
				dayE.setStyle(CALStyle.today).addClassName('calendar_today');
			
			dayE.insert(day).observe('click', CALDayEvents.click
			).observe('mousedown', CALDayEvents.down
			).observe('mouseup', CALDayEvents.up
			).observe('mouseover', CALDayEvents.over
			).observe('mouseout', CALDayEvents.out);
			
			dayE.id = 'calcd_' + month + '_' + day;	
			dayE.month = month;
			dayE.day = day;
			dayE.year = year;
			dayE.input = input;
			
			container.insert(dayE);
			
			if(dayCount == 7) {
				container.insert(new Element('br').setStyle(CALStyle.br));
				dayCount = 0;
			}
		}
		
		Event.observe(document, 'mousedown', CALEvents.bdown);
		container.observe('mousedown', CALEvents.cdown);
		
		container.onselectstart=function() {return false};
		container.onmousedown=function() {return false};
		container.style.MozUserSelect = 'none';
		
		body.insert(container);	
	},
	
	unload : function() {
		var container = $('calc_object');
		Event.stopObserving(document, 'mousedown', CALEvents.bdown);
		container.remove();
		this.active = 0;
	}
};

var CALEvents = {
	ignore_body_click : false,
	bdown : function(e) {
		if(CALEvents.ignore_body_click == false) Calendar.unload();
		CALEvents.ignore_body_click = false;
	},
	cdown : function(e) {
		CALEvents.ignore_body_click = true;
	}
};

var CALDayEvents = {
	click : function(e) {},
	down : function(e) {
		var newval = (this.month + 1) + '/' + this.day + '/' + this.year;
		if(this.input.value != newval)
			document.fire('xms:calendar:change');
		this.input.value = newval;
		Calendar.unload();
	},
	up : function(e) {},
	over : function(e) {
		this.setStyle(CALStyle.hover).addClassName('calendar_day_hover');
	},
	out : function(e) {
		this.setStyle(CALStyle.unhover).removeClassName('calendar_day_hover');
	}
};

var CALNavEvents = {
	click : function(e) {
		if(this.month < 0) {
			this.month = 11;
			this.year--;
		} else if(this.month > 11) {
			this.month = 0;
			this.year++;
		}
		this.input.value = (this.month + 1) + '/' + this.day + '/' + this.year;
		Calendar.load(this.input);
	}
};

var CALStyle = {
	container : { // calendar_container
		position : 'absolute',
		backgroundColor : '#FFF',
		color : '#000',
		fontSize: '0.9em',
		border : '1px solid #999',
		whiteSpace : 'nowrap',
		padding: '0.4em',
		top : 3,
		left: 0,
		cursor : 'pointer'
	},
	render_row : { // calendar_render_row
		width: '1.7em',
		height : '1px',
		borderLeft : '0.1em solid #CCC',
		borderRight : '0.1em solid #CCC',
		position : 'relative',
		float : 'left'
	},
	month : { // calendar_month
		height : '1.5em',
		lineHeight : '1.5em',
		backgroundColor: '#CCC',
		borderBottom : '1px solid #CCC',
		textAlign : 'center'
	},
	month_text : { //calendar_month_text
		clear : 'both'
	},
	nav : { // calendar_navigation
		width : '1.6em',
		height : '1.5em',
		lineHeight : '1.5em',
		position: 'absolute',
		top : 0, left : 0
	},
	today : { // calendar_today
		border : '0.1em solid #F00'
	},
	selected : { // calendar_selected
		backgroundColor : '#FFFFBB'
	},
	hover : { // calendar_day_hover
		textDecoration : 'underline'
	},
	unhover : { // calendar_day_hover
		textDecoration : 'none'
	},
	day : { // calendar_day
		backgroundColor : '#FFF',
		width: '1.7em',
		height : '1.7em',
		border : '0.1em solid #FFF',
		lineHeight : '1.7em',
		float : 'left',
		textAlign : 'center'
	},
	offDay : { //calendar_off_day
		color : '#999'
	},
	dayhead : { // calendar_day_header
		width: '1.7em',
		height : '1.5em',
		border : '0.1em solid #FFF',
		lineHeight : '1.5em',
		float : 'left',
		textAlign : 'center'
	},
	dayhead_row : { // calendar_day_header_row
		borderBottom : '0.1em solid #999',
		marginBottom : '0.1em',
		float : 'left',
		overflow : 'auto'
	},
	br : {
		clear: 'both', 
		display: 'block',
		height: '1px',
		margin: '-1px 0 0 0'
	}
};

Date.prototype.monthInfo = function() {
	var info = {
		date : this.getDate(),
		month : this.getMonth(),
		year : this.getFullYear(),
		weekday : null, days : null, lastMonthDays : null,
		lastMonth : null, lastYear : null,
		nextMonth : null, nextYear : null
	};
	
	this.setDate(1);
	info.weekday = this.getDay();
	this.setMonth(info.month+1);
	this.setDate(0);
	info.days = this.getDate();
	this.setMonth(info.month);
	this.setDate(0);
	info.lastMonthDays = this.getDate();
	this.setMonth(info.month-1);
	this.setDate(info.date);
	info.lastMonth = this.getMonth();
	info.lastYear = this.getFullYear();
	this.setMonth(info.month+1);
	info.nextMonth = this.getMonth();
	info.nextYear = this.getFullYear();
	this.setDate(info.date);
	this.setMonth(info.month);
	return info;
};