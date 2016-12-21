function getmmdd(mm,dd) {
    return (mm > 9 ? '' + mm : '0' + mm) + (dd > 9 ? dd : '0' + dd);
}

///////////////////////////////
// Calendar Date
///////////////////////////////
function CalDate(_date) {
    this.setDate(_date);
}

CalDate.prototype.getmmdd = function () {
    return (this.mm > 9 ? '' + this.mm : '0' + this.mm) + (this.dd > 9 ? this.dd : '0' + this.dd);
};

CalDate.prototype.setDate = function(_date) {
    this.date = _date;
    this.yyyy = this.date.getFullYear();
    this.month = this.date.getMonth();
    this.mm =  this.month + 1;
    this.dd = this.date.getDate();
    this.hashRecur = '0000' + this.getmmdd(this.mm,this.dd);
	this.hash = (this.yyyy < 1000) ? this.hashRecur : this.yyyy + this.getmmdd(this.mm,this.dd);
};

CalDate.prototype.incDay = function() {
    this.date.setDate(this.dd + 1);
    this.yyyy = this.date.getFullYear();
    this.month = this.date.getMonth();
    this.mm =  this.month + 1;
    this.dd = this.date.getDate();
	this.hash = this.yyyy + this.getmmdd(this.mm,this.dd);
    this.hashRecur = '0000' + this.getmmdd(this.mm,this.dd);
};

CalDate.prototype.dateStr = function () {
	// Sunday, June 01, 2008 2:45:57 PM
	var dtstr = this.date.toLocaleString();
	var pos = dtstr.indexOf(':');	    
	if( pos > 0 ) { 
		pos = dtstr.lastIndexOf(' ',pos);
		if( pos > 0 ) {
			dtstr = dtstr.substr(0,pos);
		}
	}
	return dtstr;
};

CalDate.prototype.isMatch = function(cd)
{
	return this.hash == cd.hash || this.hash == cd.hashRecur;
};

function makeCalDate(_yyyy,_mm,_dd) {
	//alert( 'makecaldate(' + _yyyy + ', ' + _mm + ', ' + _dd + ')' );
	var dt = new Date();
	dt.setFullYear(_yyyy,_mm-1,_dd);
	return new CalDate(dt);
}

///////////////////////////////
// Event 
///////////////////////////////
function Event(_yyyy,_mm,_dd,_HTML,_url) {
	//alert('new event : ' + _yyyy + ', ' + _mm + ', ' + _dd);
	this.evDate = makeCalDate(_yyyy,_mm,_dd);
	//alert('new event : ' + this.evDate.date.toLocaleString() + ' / ' + this.evDate.hash + ' / ' + this.evDate.hashRecur);

	this.HTML = _HTML;
	this.URL = _url;
}

///////////////////////////////
// Event Calendar
///////////////////////////////
function EventCal(_calElementName, _startDate) {
	this.calElementName = _calElementName;
	this.calElement = null;
	this.startDate = new CalDate(_startDate);
	this.eventList = new Array();

	this.moy = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
	this.today = new CalDate( new Date() );
}


EventCal.prototype.add = function(ev) {
	this.eventList[ev.evDate.hash] = ev;
};

EventCal.prototype.addEvent = function(_yyyy, _mm, _dd, _HTML, _URL) {
	var ev = new Event(_yyyy,_mm,_dd,_HTML,_URL);
	this.eventList[ev.evDate.hash] = ev;
};

EventCal.prototype.show = function() {
	for(var k in this.eventList)
	{
		var ev = this.eventList[k];
		alert(k + " : " + ev.HTML + " : " + ev.URL );
	}
};

function monthlength(year, month) {
	//alert('month length for : ' + month + ', ' + year);
    var dd = new Date(year, month+1, 0);
    //alert('date is then ' + dd.toLocaleDateString() + ' Which has ' + dd.getDate() + ' days');
    return dd.getDate();
}

EventCal.prototype.start = function () {
	this.dispCal( 0, 0);
};

EventCal.prototype.dispCal = function (yyyy, mm) {
	//alert('displaying cal: ' + yyyy + ', ' + mm);
    if (mm < 0 || mm > 12) {
        alert('month must be between 1 and 12');
        return false;
    }
    if (yyyy !== 0 && (yyyy < 1901 || yyyy > 2100)) {
        alert('year must be after 1900 and before 2101');
        return false;
    }
    
    var dtMonthToShow = new Date();
    dtMonthToShow.setDate(1);
    if (yyyy > 1900 ) {
    	if( mm > 0 ) { dtMonthToShow.setFullYear(yyyy,mm-1); /*alert('setFullYear( ' + yyyy + ', ' + mm + ')');*/ }
    	else { dtMonthToShow.setFullYear(yyyy); /*alert('setFullYear( ' + yyyy + ')'); */}
    }
    else if (mm > 0) { dtMonthToShow.setMonth(mm-1); /*alert('setMonth( ' + mm + ')');*/ }

	var cdMonthToShow = new CalDate( dtMonthToShow );

	//alert('displaying cal (after massaging): ' + cdMonthToShow.yyyy + ', ' + cdMonthToShow.mm);
	
    var dtToday = new Date();
    
	var todayInMonth = -1;
	if( cdMonthToShow.yyyy == dtToday.getFullYear() && cdMonthToShow.month == dtToday.getMonth() )
		{ todayInMonth = dtToday.getDate(); }

	//alert( 'Year: ' + cdMonthToShow.yyyy + ' == ' + dtToday.getFullYear() );
	//alert( 'month: ' + cdMonthToShow.month+ ' == ' + dtToday.getMonth() );
		
	//if( !confirm( 'Today in month: ' + todayInMonth) ) { return; }

    var weekday = dtToday.getDay();
    var daysInMonth = monthlength(cdMonthToShow.yyyy, cdMonthToShow.month);


	// Layout header
    var cal = '';
    cal += '<div id="cal">';
    cal += '<div style="width:240px;font-size:8pt">';
    cal += '<table class="CalStyle" cellspacing="0" cellpadding="2">';
    cal += '<tr><td colspan="7" class="CalHeader1Style">CALENDAR OF EVENTS</td></tr>';
    cal += '<tr><td colspan="7" class="CalHeader2Style">' + this.moy[cdMonthToShow.month] + ' ' + cdMonthToShow.yyyy + '</td></tr>';
    cal += '<tr>';
    cal += '<td class="CalDayHeaderStyle">S</td>';
    cal += '<td class="CalDayHeaderStyle">M</td>';
    cal += '<td class="CalDayHeaderStyle">T</td>';
    cal += '<td class="CalDayHeaderStyle">W</td>';
    cal += '<td class="CalDayHeaderStyle">T</td>';
    cal += '<td class="CalDayHeaderStyle">F</td>';
    cal += '<td class="CalDayHeaderStyle">S</td>';
    cal += '<\/tr>';

	// Spacer (why wasn't this done with padding or margin
    cal += '<tr><td colspan="7"></td></tr>';
    
    // Find day of week that the month starts on
	var dowMonthStart = cdMonthToShow.date.getDay();
	//if( !confirm('cdMonth: ' + cdMonthToShow.date.toLocaleString() + '; DOW month start ' + dowMonthStart) ) { return; }

	//alert("Setting empty data cell");
	var td_emptyDateCell = '<td class="CalDayStyle" />';
	//alert("empty data cell is set: " + td_emptyDateCell);
	// Add cells until starting day of week for month
	cal += '<tr>';
    for (dex = 0; dex < dowMonthStart; dex++) { cal += td_emptyDateCell; }

	// Create date cells
	//alert('creating date cells : ' + daysInMonth);
	var cellDate = new CalDate(cdMonthToShow.date);
	var dow = dowMonthStart;
    for (dex = 1; dex <= daysInMonth; dex++) {

		//if( !confirm('Date cell ' + dex + ' / ' + dow + ' : ' + cellDate.hash) ) { return;}
		
        if (dow == 7) {
            cal += '</tr><tr>';
            dow = 0;
        }
        
		//if( !confirm('genCellContents ' + cellDate.hash) ) { return;}

		cal += '<td class="CalDayStyle' + ((dex == todayInMonth) ? ' CalTodayStyle' : '') + '">';
		cal += this.genCellContents(cellDate);
		cal += '</td>';
		
       	++dow;
    	cellDate.incDay();
    }

	// Finish up last week
    for (dex = dow; dex < 7; dex++) { cal += td_emptyDateCell; }
    cal += '</tr></table></div>';
    
    if (document.getElementById) {
        var mmb = cdMonthToShow.month;
        var yya = cdMonthToShow.yyyy;
        var yyb = yya;
        if (mmb < 1) {
            mmb += 12;
            yyb--;
        }
        var mma = cdMonthToShow.mm + 1;
        if (mma > 12) {
            mma -= 12;
            yya++;
        }
        var yb = cdMonthToShow.yyyy - 1;
        var ya = cdMonthToShow.yyyy + 1;
        cal += '<table class="CalFooterStyle" cellspacing="0" cellpadding="2">';
        cal += '<tr>';
        cal +=   '<td class="CalNavStyle CalNavYearBack"><a href="#" onclick="calRedisplay(' + yb + ',' + cdMonthToShow.mm + '); return false;">&#60;&#60;YEAR</a></td>';
        cal += 	 '<td class="CalNavStyle CalNavMonthBack"><a href="#" onclick="calRedisplay(' + yyb + ',' + mmb + '); return false;">&#60;MONTH</a></td>';
        cal +=   '<td class="CalNavStyle CalNavMonthForward"><a href="#" onclick="calRedisplay(' + yya + ',' + mma + '); return false;">>MONTH</a></td>';
        cal +=   '<td class="CalNavStyle CalNavYearForward"><a href="#" onclick="calRedisplay(' + ya + ',' + cdMonthToShow.mm + '); return false;">>>YEAR</a></td>';
        cal += '</tr></table>';
    } else {
        cal += '<div></div>';
    }
    cal += '</div>';

    var eventPUHTML = '<div id="eventPU" class="PU">';
    eventPUHTML += '<div id="eventPUHeader" class="PUHeader">Event Pop-up Header</div>';
    eventPUHTML += '<div id="eventPUBody" class="PUBody">Event Pop-up Body</div>';

	cal += eventPUHTML + '</div>';
    
    //alert(cal);

    this.calElement = document.getElementById(this.calElementName);
    if( this.calElement === undefined || this.calElement === null ) {
    	alert("Could not find calendar element: " + this.calElementName);
    	return;
    }
    
    this.calElement.innerHTML = cal;
    
	this.eventPU = document.getElementById('eventPU');
	this.eventPUHeader = document.getElementById('eventPUHeader');
	this.eventPUBody = document.getElementById('eventPUBody');

	if( this.eventPU === undefined || this.eventPUHeader === undefined || this.eventPUBody === undefined ) {
		alert("event pop-up is not found!");
	}
};

EventCal.prototype.genCellContents = function (cd) {
	var cellContents = '';
	
	//alert('looking for ' + cd.hash);
    var ev = this.eventList[cd.hash]; // Get specific date event
	if( ev === undefined ) {
		//alert('looking for ' + cd.hashRecur);
    	ev = this.eventList[cd.hashRecur];  // Get recurring date event
    }
    
	if( ev !== undefined ) {
		//alert('Event Found: ' + ev.evDate.hash);
		cellContents = '<a href=' + ev.URL;
    	cellContents += ' onmouseover="ec.evShow(\'' + ev.evDate.hash + '\');return false;"';
    	cellContents += ' onmouseout="ec.evHide();"';
		cellContents += '>' + dex + '</a>';
    }
    else {
		cellContents = '<span>' + dex + '</span>';
    }
    
    return cellContents;
};

EventCal.prototype.evShow = function(evDateHash) {
    var ev = this.eventList[evDateHash]; // Get specific date event
	if( ev === undefined ) {
    	ev = this.eventList['0000' + evDateHash.substr(4)]; // Get recurring date event
    }
    
	if( ev !== undefined )
	{	
		//alert(evDateHash + " : " + ev.HTML);
	
	    this.eventPU.style.top = '550px';
	    this.eventPU.style.left = '200px';
	    this.eventPU.style.display = "block";
	    
	    this.eventPUHeader.innerHTML = ev.evDate.dateStr();
	    this.eventPUBody.innerHTML = ev.HTML;
	}
};

EventCal.prototype.evHide = function() {
	this.eventPU.style.display = "none";
};


function loaded(calendar, startFn) {
    if (document.getElementById && document.getElementById(calendar) !== null) { startFn(calendar); }
    else if (!pageLoaded) { setTimeout('loaded(\'' + calendar + '\',' + startFn + ')', 100); }
}


var pageLoaded = 0;
var ec;
window.onload = function() {
    pageLoaded = 1;
};

function start(calElementName) {
	//alert("start start");
	ec = new EventCal(calElementName, new Date());
		
	if( ec !== null && ec !== undefined)
	{
		ec.addEvent(0000,07,04,'4th of July','calendar_jul.htm');
		ec.addEvent(2008,05,31,'Memorial Day','index.htm');
		ec.addEvent(2008,06,28,'<img style="float:left; margin-right:5px" alt="" src="images/cso_sm.jpg">CSO Pops Concert at the Mable House<br>The Delfonics<br>8:00pm','calendar_jun.htm');
		ec.addEvent(2008,07,04,'<img style="float:left; margin-right:5px" alt="" src="images/fireworks_sm.jpg">CSO Pops Concert<br>at Indian Hills Country Club, 8:00pm','calendar_jul.htm');
		ec.addEvent(2008,07,05,'<img style="float:left; margin-right:5px" alt="" src="images/cso2_sm.jpg">CSO Pops Concert at the<br>Marietta Square (Glover Park), 8:00pm','calendar_jul.htm');
		ec.addEvent(2008,07,19,'<img style="float:left; margin-right:5px" alt="" src="images/michael_bolton_sm.jpg">CSO Pops Concert with Michael Bolton<br>at the Mable House, 8:00pm','calendar_jul.htm');
		ec.addEvent(2008,07,27,'<img style="float:left; margin-right:5px" alt="" src="images/csopark_sm.jpg">CSO Pops Concert at<br>the KSU Amphitheater, 7:30pm','calendar_jul.htm');
		ec.addEvent(2008,08,23,'<img style="float:left; margin-right:5px" alt="" src="images/mac_sm.jpg">Georgia Center for the Arts Presents a Day of the Arts Open House, 9-5 PM','calendar_aug.htm');
		
		ec.addEvent(2008,09,13,'<img style="float:right; margin-left:5px; width:40px; height:40px" alt="" src="images/fm_sm.jpg">Super Saturday’s at the MAC<br>Family Programming<br>10:00 and 11:30 AM<br>--------------------------------------------------<br><img style="float:left; margin-right:5px" alt="" src="images/ag_sm.jpg">MW #1 8:00 PM<br>Rachmaninoff: Variations on a Theme of Paganini<br>Holst: The Planets','cso_10-11_season.htm');
		ec.addEvent(2008,09,14,'<img style="float:left; margin-right:5px" alt="" src="images/ag_sm.jpg">MW #1 3:00 PM<br>Rachmaninoff: Variations on a Theme of Paganini<br>Holst: The Planets','calendar_sep.htm');

		ec.addEvent(2008,10,10,'<img style="float:left; margin-right:5px" alt="" src="images/sk_sm.jpg">CSO Jazz 8:00 PM<br>Sam Skelton and Band<br>8:00 PM Murray Arts Center','calendar_oct.htm');
		ec.addEvent(2008,10,11,'<img style="float:left; margin-right:5px" alt="" src="images/sk_sm.jpg">CSO Jazz 8:00 PMSam Skelton and Band<br>8:00 PM Murray Arts Center','calendar_oct.htm');		
		
		ec.addEvent(2008,10,25,'<img style="float:left; margin-right:5px" alt="" src="images/rj_sm.jpg">MW #2 8:00 PM<br>Tchaikovsky’s Magnificent Fourth<br>Strauss: Concerto for Oboe and Orchestra<br>Robin Johnson, oboe<br>Golijov: Last Round<br>Tchaikovsky: Symphony No.4','cso_10-11_season.htm');
		ec.addEvent(2008,10,26,'<img style="float:left; margin-right:5px" alt="" src="images/rj_sm.jpg">MW #2 3:00 PM<br>Tchaikovsky’s Magnificent Fourth<br>Strauss: Concerto for Oboe and Orchestra<br>Robin Johnson, oboe<br>Golijov: Last Round<br>Tchaikovsky: Symphony No.4','cso_10-11_season.htm');
		ec.addEvent(2008,11,08,'<img style="float:left; margin-right:5px" alt="" src="images/fm_sm.jpg">Super Saturday’s at the MAC<br>Family Programming<br>10:00 and 11:30 AM<br>------------------------------<br><br><img style="float:right; margin-left:5px" alt="" src="images/ma_sm.jpg">WellStar Foundation Benefit Concert 8:00 PM<br>Prokofiev: Concerto for Cello and Orchestra','cso_10-11_season.htm');
		ec.addEvent(2008,11,09,'<img style="float:left; margin-right:5px" alt="" src="images/ma_sm.jpg">WellStar Foundation Benefit Concert 3:00 PM<br>Prokofiev: Concerto for Cello and Orchestra<br>Rodgers and Hammerstein: The Sound of Music<br>Weber: Phantom of the Opera','cso_10-11_season.htm');
		ec.addEvent(2008,12,06,'<img style="float:left; margin-right:5px" alt="" src="images/jfbc_sm.jpg">Holiday Pops Concert<br>3:00 PM Murray Arts Center<br>7:00 PM Johnson Ferry Baptist Church<br>------------------------------<br><img style="float:right; margin-left:5px" alt="" src="images/fm_sm.jpg">Super Saturday’s at the MAC - Family Programming<br>The Night Before Christmas<br>10:00 and 11:30 AM','cso_10-11_season.htm');
		ec.addEvent(2009,01,17,'<img style="float:left; margin-right:5px" alt="" src="images/fc_sm.jpg">Family Concert<br>1:00 and 3:00 PM<br>Murray Arts Center<br><br>Young Artists Competition Winner, soloist<br>Britten: Young Persons guide to the Orchestra<br>Arnold: Four Scottish Dances','cso_10-11_season.htm');
		ec.addEvent(2009,02,14,'<img style="float:left; margin-right:5px" alt="" src="images/tg_sm.jpg">MW #3 8:00 PM<br>Shostakovich: Concerto for Cello and Orchestra<br>Tina Guo, cello<br>Dvorak: Carnival Overture<br>Brahms: Symphony No.3','cso_10-11_season.htm');
		ec.addEvent(2009,02,15,'<img style="float:left; margin-right:5px" alt="" src="images/tg_sm.jpg">MW #3 3:00 PM<br>Shostakovich: Concerto for Cello and Orchestra<br>Tina Guo, cello<br>Dvorak: Carnival Overture<br>Brahms: Symphony No.3','cso_10-11_season.htm');
		ec.addEvent(2009,03,13,'<img style="float:left; margin-right:5px" alt="" src="images/tw_sm.jpg">Selections from The Who! 8:00 PM<br>Tim Whalen, guest vocalist/arranger','calendar_mar.htm');
		ec.addEvent(2009,03,14,'<img style="float:left; margin-right:5px" alt="" src="images/tw_sm.jpg">Selections from The Who! 8:00 PM<br>Tim Whalen, guest vocalist/arranger','calendar_mar.htm');
		ec.addEvent(2009,03,28,'<img style="float:left; margin-right:5px" alt="" src="images/gb_sm.jpg">LIVE! CSO and The Georgia Ballet 2:00 and 7:00 PM<br>Jessica Peek-Sherwood, flute<br>Britten: Young Persons Guide to the Orchestra<br>Minkus: Pas de Quatre<br>Auber: Grand Pas Classique','cso_10-11_season.htm');
		ec.addEvent(2009,03,29,'<img style="float:left; margin-right:5px" alt="" src="images/gb_sm.jpg">LIVE! CSO and The Georgia Ballet 2:00 PM<br>Jessica Peek-Sherwood, flute<br>Britten: Young Persons Guide to the Orchestra<br>Minkus: Pas de Quatre<br>Auber: Grand Pas Classique','cso_10-11_season.htm');
		ec.addEvent(2009,04,04,'<img style="float:left; margin-right:5px" alt="" src="images/orch_sm.jpg">MW #4 8:00 PM<br>Carmina Burana<br>With the CSO Chorus<br>Mendelssohn: Symph No.4<br>------------------------------<br><img style="float:right; margin-left:5px" alt="" src="images/fm_sm.jpg">Super Saturday’s at the MAC - Family Programming<br>Heroes of Tomorrow<br>10:00 and 11:30 AM','cso_10-11_season.htm');
		ec.addEvent(2009,04,05,'<img style="float:left; margin-right:5px" alt="" src="images/orch_sm.jpg">MW #4 3:00 PM<br>Carmina Burana<br>With the CSO Chorus<br>Mendelssohn: Symph No.4','calendar_apr.htm');
		ec.addEvent(2009,04,24,'<img style="float:left; margin-right:5px" alt="" src="images/ss_sm.jpg">CSO Jazz - SUITE! 8:00 PM<br>Sam Skelton and his Big Band','calendar_apr.htm');
		ec.addEvent(2009,04,25,'<img style="float:left; margin-right:5px" alt="" src="images/ss_sm.jpg">CSO Jazz - SUITE! 8:00 PM<br>Sam Skelton and his Big Band','calendar_apr.htm');
		
		ec.addEvent(2010,10,23,'<img style="float:left; margin-right:5px; width:50px; height:40px" alt="" src="images/orchestra%20overhead.JPG">MW #2 8:00 PM<br>Dvorak’s New World Symphony, Schumann’s optimistic Piano Concerto, and Theofanidis’ Rainbow Body','cso_10-11_season.htm');
		ec.addEvent(2010,10,24,'<img style="float:left; margin-right:5px; width:50px; height:40px" alt="" src="images/orchestra%20overhead.JPG">MW #2 3:00 PM<br>Dvorak’s New World Symphony, Schumann’s optimistic Piano Concerto, and Theofanidis’ Rainbow Body','cso_10-11_season.htm');

		ec.addEvent(2010,11,07,'<img style="float:left; margin-right:5px; width:50px; height:45px" alt="" src="images/gyso_Calvin_Miller.jpg">3:00, 5:30 & 7:30 PM @ Kennesaw State University. GYSO & Chorus presents concerts by their ensembles, choruses and orchestras!','cso_10-11_season.htm');
		ec.addEvent(2010,11,13,'<img style="float:left; margin-right:5px; width:45px; height:55px" alt="" src="images/MatthewAllen.gif">8:00 PM. Matthew Allen performs Dvorak’s Cello Concerto. CSO, Chamber & the GYSO Choruses perform Stravinsky’s Mass and Bernstein’s Chichester Psalms','cso_10-11_season.htm');
		ec.addEvent(2010,11,14,'<img style="float:left; margin-right:5px; width:45px; height:55px" alt="" src="images/MatthewAllen.gif">3:00 PM. Matthew Allen performs Dvorak’s Cello Concerto. CSO, Chamber & the GYSO Choruses perform Stravinsky’s Mass and Bernstein’s Chichester Psalms','cso_10-11_season.htm');


		ec.start();
	}
}

function calRedisplay(_yyyy, _mm)
{
	if( !ec )
		alert("No calendar object found");

	//alert("redisplay with " + _yyyy + ', ' + _mm);
	ec.dispCal(_yyyy,_mm);
}

loaded('calendar', start);

