/*
	I18N:check:1
*/
/**
 * iso format: YYYY-MM-DD HH:MM:SS[±II:NN]
 */
function utcIsoToDate(utcIso,honorTimezone) {
	var year 	= utcIso.substring(0, 4);
	var month 	= utcIso.substring(5, 7);
	var date 	= utcIso.substring(8, 10);
	var hours 	= utcIso.substring(11, 13);
	var minutes = utcIso.substring(14, 16);
	var seconds = utcIso.substring(17, 19);
	var correctionHours = correctionMinutes = "";
	if(honorTimezone || window.honorTimezone){
		correctionHours = utcIso.substring(19, 22);
		correctionMinutes = utcIso.substring(23, 25);
	}
	return new Date(Date.UTC(year, month - 1, date, hours - (correctionHours == "" ? 0 : parseInt(correctionHours)), minutes - (correctionMinutes == "" ? 0 : parseInt(correctionMinutes)), seconds));
}

function isoToDate(utcIso) {
	var year 	= utcIso.substring(0, 4);
	var month 	= utcIso.substring(5, 7);
	var date 	= utcIso.substring(8, 10);
	var hours 	= utcIso.substring(11, 13);
	var minutes = utcIso.substring(14, 16);
	var seconds = utcIso.substring(17, 19);
	return new Date(year, month - 1, date, hours, minutes, seconds);
}

// YYYYMMDDHHMMSS
function timestampToDate(ts) {
	var year 	= ts.substring( 0,  4);
	var month 	= ts.substring( 4,  6);
	var date 	= ts.substring( 6,  8);
	var hours 	= ts.substring( 8, 10);
	var minutes = ts.substring(10, 12);
	var seconds = ts.substring(12, 14);
	return new Date(year, month - 1, date, hours, minutes, seconds);
}

// YYYYMMDDHHMMSS => YYYY-MM-DD HH:MM:SS
function timestampToUtcIso(ts) {
	var YYYY	= ts.substring( 0,  4);
	var MM 		= ts.substring( 4,  6);
	var DD 		= ts.substring( 6,  8);
	var hh 		= ts.substring( 8, 10);
	var mm 		= ts.substring(10, 12);
	var ss 		= ts.substring(12, 14);
	
	return YYYY + "-" + MM + "-" + DD + " " + hh + ":" + mm + ":" + ss;
}


/**
 * time stamp format: variable
 * if neither showDate nor showTime are set a timestamp is returned: YYYYMMDDHHMMSS
 * format is currently one of the following:

	f1				:	Friday, July 26, 2003, 2:30 PM
	f2				:	Fri, 7/26/2003, 2:30 PM
	f3				:	7/26/2003 2:30 PM
	format_ja_JP	:	2003年12月4日(木) 午前 6時18分
	f1_it_IT		:	Venerdì,26/07/2003, 2.30
	f2_it_IT		: 	Ven, 26/07/2003, 2.30
	f3_it_IT		: 	26/07/2003, 2.30

	f1_de			: 	Freitag, 26. Juli 2007, 14:30
	f2_de			: 	Fr, 26.7.2007, 14:30
	f3_de			:	26.7.2007 14:30
	f4_de			: 	26.07.2007 14:30
	
	
*/

function getAvailableDateFormats(language, country) { 
	language = (language || "en");
	country  = (country  || "US");
	if (language=="de")
		return ["f1_de_DE", "f2_de_DE", "f3_de_DE", "f4_de_DE"];
	else if (language=="fr")
		return ["f1_fr_FR", "f2_fr_FR", "f3_fr_FR", "f4_fr_FR"];	
	else if (language=="it")
		return ["f1_it_IT", "f2_it_IT", "f3_it_IT"];
	else if (language=="ja")
		return ["format_ja_JP"];
	else if (language=="pl")
		return ["f1_pl_PL", "f2_pl_PL", "f3_pl_PL", "f4_pl_PL"];
	else if (language=="hr")
		return ["f1_hr_HR", "f2_hr_HR", "f3_hr_HR"];
	else if (language=="es")
		return ["f1_es_ES", "f2_es_ES", "f3_es_ES"];
	else if (language=="ca")
		return ["f1_ca_ES", "f2_ca_ES", "f3_ca_ES"];
	else if (language=="eu")
		return ["f1_eu_ES", "f2_eu_ES", "f3_eu_ES"];
	else if (language=="gl")
		return ["f1_gl_ES", "f2_gl_ES", "f3_gl_ES"];
	else if (language=="pt" && country =="PT")
		return ["f1_pt_PT", "f2_pt_PT", "f3_pt_PT", "f4_pt_PT"];
	else if (language=="pt" && country =="BR")
		return ["f1_pt_BR", "f2_pt_BR", "f3_pt_BR", "f4_pt_BR"];
	else if (language=="zh" && ( country =="CN" || country =="TW" ))
		return ["f1_zh_CN", "f2_zh_CN", "f3_zh_CN"];
	else if (language=="sl" && country =="SI")
		return ["f1_sl_SI", "f2_sl_SI", "f3_sl_SI"];
	else
		return ["f1", "f2", "f3"];
}

function dateToLocaleTimeStamp(d,showDate,showTime,format) {
	if (!format && typeof(date$globalFormat) == "string") {
		format = date$globalFormat;
	}

	var r_year    = d.getFullYear();
	var r_month   = d.getMonth();
	var r_date	  = d.getDate();
	var r_day     = d.getDay();
	var r_hours   = d.getHours();
	var r_minutes = d.getMinutes();
	var r_seconds = d.getSeconds();
	var r_timezone = -d.getTimezoneOffset()/60;

	var year    = "" + r_year;
	var month   = (r_month   <  9 ? "0" : "") + (r_month + 1);
	var date    = (r_date    < 10 ? "0" : "") + r_date;
	var hours   = (r_hours   < 10 ? "0" : "") + r_hours;
	var minutes = (r_minutes < 10 ? "0" : "") + r_minutes;
	var seconds = (r_seconds < 10 ? "0" : "") + r_seconds;

	var usHours = (r_hours >  12 ? r_hours-12 : (r_hours == 0 ? 12 : r_hours));
	var sNoon	= (r_hours >= 12 ? "PM" : "AM");

	var sDate   = year + month + date;
	var sTime	= hours + minutes + seconds;
	var sConcat	= "";

	if (format == "f1" || format == "f1_en_US" || format == "f1_en_GB") {
		// Friday, July 26, 2003, 2:30 PM
		sDate   = date$configuration.en.dayNames[r_day] + ", " + date$configuration.en.monthNames[r_month] + " " + r_date + ", " + r_year;
		sTime   = usHours + ":" + minutes + " " + sNoon;
		sConcat = ", ";
	} else if (format == "f2" || format == "f2_en_US" || format == "f2_en_GB") {
		// Fri, 7/26/2003, 2:30 PM
		sDate   = date$configuration.en.dayNames[r_day].substring(0, 3) + ", " + (r_month+1) + "/" + r_date + "/" + r_year;
		sTime   = usHours + ":" + minutes + " " + sNoon;
		sConcat = ", ";
	} else if (format == "f3" || format == "f3_en_US" || format == "f3_en_GB") {
		// 7/26/2003 2:30 PM
		sDate   = (r_month+1) + "/" + r_date + "/" + r_year;
		sTime   = usHours + ":" + minutes + " " + sNoon;
		sConcat = " ";
	} else if (format == "f1_it_IT") {
		// Venerdì, 26/07/2003, 2.30
		sDate   = date$configuration.it.dayNames[r_day] + ", " + date + "/" + month + "/" + year;
		sTime   = r_hours + "." + minutes;
		sConcat = ", ";
	} else if (format == "f2_it_IT") {
		// Ven, 26/07/2003, 2.30
		sDate   = date$configuration.it.dayNames[r_day].substring(0, 3) + ", " + date + "/" + month + "/" + year;
		sTime   = r_hours + "." + minutes;
		sConcat = ", ";
	} else if (format == "f3_it_IT") {
		// 26/07/2003, 2.30
		sDate   = date + "/" + month + "/" + year;
		sTime   = r_hours + "." + minutes;
		sConcat = ", ";
	} else if (format == "f1_es_ES") {
		// Martes, 23/03/2003, 2:30
		sDate   = date$configuration.es.dayNames[r_day] + ", " + date + "/" + month + "/" + year;
		sTime   = r_hours + ":" + minutes;
		sConcat = ", ";
	} else if (format == "f2_es_ES") {
		// Mar, 23/03/2003, 2:30
		sDate   = date$configuration.es.dayNames[r_day].substring(0, 3) + ", " + date + "/" + month + "/" + year;
		sTime   = r_hours + ":" + minutes;
		sConcat = ", ";
	} else if (format == "f3_es_ES") {
		// 23/03/2003, 2:30
		sDate   = date + "/" + month + "/" + year;
		sTime   = r_hours + ":" + minutes;
		sConcat = ", ";
	} else if (format == "f1_ca_ES") {
		// Martes, 23/03/2003, 2:30
		sDate   = date$configuration.ca.dayNames[r_day] + ", " + date + "/" + month + "/" + year;
		sTime   = r_hours + ":" + minutes;
		sConcat = ", ";
	} else if (format == "f2_ca_ES") {
		// Mar, 23/03/2003, 2:30
		sDate   = date$configuration.ca.dayNames[r_day].substring(0, 4) + ", " + date + "/" + month + "/" + year;
		sTime   = r_hours + ":" + minutes;
		sConcat = ", ";
	} else if (format == "f3_ca_ES") {
		// 23/03/2003, 2:30
		sDate   = date + "/" + month + "/" + year;
		sTime   = r_hours + ":" + minutes;
		sConcat = ", ";
	} else if (format == "f1_eu_ES") {
		// Martes, 23/03/2003, 2:30
		sDate   = date$configuration.eu.dayNames[r_day] + ", " + date + "/" + month + "/" + year;
		sTime   = r_hours + ":" + minutes;
		sConcat = ", ";
	} else if (format == "f2_eu_ES") {
		// Mar, 23/03/2003, 2:30
		sDate   = date$configuration.eu.dayNames[r_day].substring(0, 4) + ", " + date + "/" + month + "/" + year;
		sTime   = r_hours + ":" + minutes;
		sConcat = ", ";
	} else if (format == "f3_eu_ES") {
		// 23/03/2003, 2:30
		sDate   = date + "/" + month + "/" + year;
		sTime   = r_hours + ":" + minutes;
		sConcat = ", ";
	} else if (format == "f1_gl_ES") {
		// Martes, 23/03/2003, 2:30
		sDate   = date$configuration.gl.dayNames[r_day] + ", " + date + "/" + month + "/" + year;
		sTime   = r_hours + ":" + minutes;
		sConcat = ", ";
	} else if (format == "f2_gl_ES") {
		// Mar, 23/03/2003, 2:30
		sDate   = date$configuration.gl.dayNames[r_day].substring(0, 3) + ", " + date + "/" + month + "/" + year;
		sTime   = r_hours + ":" + minutes;
		sConcat = ", ";
	} else if (format == "f3_gl_ES") {
		// 23/03/2003, 2:30
		sDate   = date + "/" + month + "/" + year;
		sTime   = r_hours + ":" + minutes;
		sConcat = ", ";
	} else if (format == "format_ja_JP") {
		// 2003年12月4日(木) 午前 6時18分
		sDate   = r_year + "年" + (r_month+1) + "月" + r_date + "日(" + date$configuration.jp.dayNames[r_day] + ")";
		sTime   = r_hours + "時" + minutes + "分";
		sConcat = " ";
	} else if (format == "f1_de_DE" || format == "f1_de" || format == "f1_de_CH") {
		// Freitag, 6. Juli 2007, 7:30
		sDate   = date$configuration.de.dayNames[r_day] + ", " + r_date + ". " + date$configuration.de.monthNames[r_month] + " " + year;
		sTime   = r_hours + ":" + minutes
		sConcat = ", ";
	} else if (format == "f2_de_DE" || format == "f2_de" || format == "f2_de_CH") {
		// Fr, 6.7.2007, 7:30
		sDate   = date$configuration.de.dayNames[r_day].substring(0, 2) + ", " + r_date + "." + (r_month+1) + "." + year;
		sTime   = r_hours + ":" + minutes
		sConcat = ", ";
	} else if (format == "f3_de_DE" || format == "f3_de" || format == "f3_de_CH") {
		// 6.7.2007 7:30
		sDate   = r_date + "." + (r_month+1) + "." + year;
		sTime   = r_hours + ":" + minutes
		sConcat = ", ";
	} else if (format == "f4_de_DE" || format == "f4_de" || format == "f4_de_CH") {
		// 06.07.2007 07:30
		sDate   = date  + "." + month + "." + year;
		sTime   = hours + ":" + minutes
		sConcat = ", ";
	} else if (format == "f1_pl_PL") {
		// piątek, 26 lipca 2007, godz. 14:30
		sDate   = date$configuration.pl.dayNames[r_day] + ", " + r_date + " " + date$configuration.pl.monthNames[r_month] + " " + year;
		sTime   = "godz. " + hours + ":" + minutes
		sConcat = ", ";
	} else if (format == "f2_pl_PL") {
		// 26 lipca 2007, godz. 14:30
		sDate   = r_date + " " + date$configuration.pl.monthNames[r_month] + " " + year;
		sTime   = "godz. " + hours + ":" + minutes
		sConcat = ", ";
	} else if (format == "f3_pl_PL") {
		// 2007.07.26, 14:30
		sDate   = year + "." + month + "." + date;
		sTime   = hours + ":" + minutes
		sConcat = ", ";
	} else if (format == "f4_pl_PL") {
		// 26.07.2007, 14:30
		sDate   = date + "." + month + "." + year;
		sTime   = hours + ":" + minutes
		sConcat = ", ";
	} else if (format == "f1_hr_HR") {
		// subota, 19. studeni 2007, 18:08
		sDate   = date$configuration.hr.dayNames[r_day] + ", " + r_date + ". " + date$configuration.hr.monthNames[r_month] + " " + year;
		sTime   = hours + ":" + minutes
		sConcat = ", ";
	} else if (format == "f2_hr_HR") {
		// 19. studeni 2007, 18:08
		sDate   = r_date + ". " + date$configuration.hr.monthNames[r_month] + " " + year;
		sTime   = hours + ":" + minutes
		sConcat = ", ";
	} else if (format == "f3_hr_HR") {
		// 19.11.2007, 18:08 
		sDate   = year + "." + month + "." + date;
		sTime   = hours + ":" + minutes
		sConcat = ", ";
	}  else if (format == "f1_es_ES"){
		// EEEE d' de 'MMMM' de 'yyyy HH'H'mm'' z
		sDate 	= date$configuration.es.dayNames[r_day]+" "+r_date+" de "+date$configuration.es.monthNames[r_month]+" de "+year;
		sTime	= hours+"H"+minutes+"' GMT"+(r_timezone>0?"+":"")+r_timezone;
		sConcat	= " ";
	}  else if (format == "f2_es_ES"){
		// d' de 'MMMM' de 'yyyy H:mm:ss z
		sDate 	= r_date+" de "+date$configuration.es.monthNames[r_month]+" de "+year;
		sTime	= r_hours+":"+minutes+":"+seconds+" GMT"+(r_timezone>0?"+":"")+r_timezone;
		sConcat	= " ";
	}  else if (format == "f3_es_ES"){
		// dd-MMM-yyyy H:mm:ss
		sDate 	= date+"-"+date$configuration.es.monthNames[r_month].substring(0,date$configuration.es.monthShortcutLength)+"-"+year;
		sTime	= r_hours+":"+minutes+":"+seconds;
		sConcat	= " ";
	}  else if (format == "f4_es_ES"){
		// d/MM/yy H:mm
		sDate 	= r_date+"/"+month+"/"+(year % 100);
		sTime	= r_hours+":"+minutes;
		sConcat	= " ";
	}  else if (format == "f1_pt_BR"){
		// EEEE, d' de 'MMMM' de 'yyyy HH'H'mm'm' z
		sDate 	= date$configuration.pt.dayNames[r_day]+", "+r_date+" de "+date$configuration.pt.monthNames[r_month]+" de "+year;
		sTime	= hours+"H"+minutes+"'m GMT"+(r_timezone>0?"+":"")+r_timezone;
		sConcat	= " ";
	}  else if (format == "f2_pt_BR"){
		// d' de 'MMMM' de 'yyyy H:mm:ss z
		sDate 	= r_date+" de "+date$configuration.pt.monthNames[r_month]+" de "+year;
		sTime	= r_hours+":"+minutes+":"+seconds+" GMT"+(r_timezone>0?"+":"")+r_timezone;
		sConcat	= " ";
	}  else if (format == "f3_pt_BR"){
		// d/MMM/yyyy H:mm:ss
		sDate 	= r_date+"/"+date$configuration.pt.monthNames[r_month].substring(0,date$configuration.pt.monthShortcutLength)+"/"+year;
		sTime	= r_hours+":"+minutes+":"+seconds;
		sConcat	= " ";
	}  else if (format == "f4_pt_BR"){
		// dd-MM-yyyy H:mm
		sDate 	= date+"-"+month+"-"+year;
		sTime	= r_hours+":"+minutes;
		sConcat	= " ";
	}  else if (format == "f1_pt_PT"){
		// EEEE, d' de 'MMMM' de 'yyyy HH'h'mm'min'ss's' z
		sDate 	= date$configuration.pt.dayNames[r_day]+", "+r_date+" de "+date$configuration.pt.monthNames[r_month]+" de "+year;
		sTime	= hours+"h"+minutes+"min"+seconds+"s GMT"+(r_timezone>0?"+":"")+r_timezone;
		sConcat	= " ";
	}  else if (format == "f2_pt_PT"){
		// d' de 'MMMM' de 'yyyy H'h'm'min's's' z
		sDate 	= r_date+" de "+date$configuration.pt.monthNames[r_month]+" de "+year;
		sTime	= r_hours+"h"+r_minutes+"min"+r_seconds+"s GMT"+(r_timezone>0?"+":"")+r_timezone;
		sConcat	= " ";
	}  else if (format == "f3_pt_PT"){
		// dd/MM/yyyy HH:mm:ss
		sDate 	= date+"/"+month+"/"+year;
		sTime	= hours+":"+minutes+":"+seconds;
		sConcat	= " ";
	}  else if (format == "f4_pt_PT"){
		// dd/MM/yy HH:mm
		sDate 	= date+"/"+month+"/"+(year % 100);
		sTime	= hours+":"+minutes;
		sConcat	= " ";
	}  else if ( format == "f1_zh_CN" || format == "f1_zh_TW" ) {
		sNoon = ( sNoon == "PM" ? "下午" : "早晨" );
		// Friday, July 26, 2003, 2:30 PM
		sDate   =  r_year + "年" + (r_month+1) + "月" + r_date + "日" + date$configuration.zh.dayNames[r_day];
		sTime   = sNoon + " " + usHours + ":" + minutes;
		sConcat = ", ";
	} else if ( format == "f2_zh_CN" || format == "f2_zh_TW" ) {
		sNoon = ( sNoon == "PM" ? "下午" : "早晨" );

		// Fri, 7/26/2003, 2:30 PM
		sDate   =  (r_month+1) + "/" + r_date + "/" +  r_year + date$configuration.zh.dayNames[r_day];
		sTime   = sNoon + " " + usHours + ":" + minutes;
		sConcat = ", ";
	} else if ( format == "f3_zh_CN" || format == "f3_zh_TW" ) {
		sNoon = ( sNoon == "PM" ? "下午" : "早晨" );

		// 7/26/2003 2:30 PM
		sDate   =  (r_month+1) + "/" + r_date + "/" +  r_year;
		sTime   = sNoon + " " + usHours + ":" + minutes;
		sConcat = " ";
	}  else if (format == "f1_sl_SI") {
		// četrtek, 09.09.1968, 12:00
		sDate   = date$configuration.sl.dayNames[r_day] + ", " + date + "." + month + "." + year;
		sTime   = r_hours + ":" + minutes;
		sConcat = ", ";
	} else if (format == "f2_sl_SI") {
		// čet, 09.09.1968, 12:00
		sDate   = date$configuration.sl.dayNames[r_day].substring(0, 3) + ", " + date + "." + month + "." + year;
		sTime   = r_hours + ":" + minutes;
		sConcat = ", ";
	} else if (format == "f3_sl_SI") {
		// 09.09.1968, 12:00
		sDate   = date + "." + month + "." + year;
		sTime   = r_hours + ":" + minutes;
		sConcat = ", ";
	} else if (format == "f1_fr_FR") {
		// vendredi 26 juillet 2007 14:30
		sDate   = date$configuration.fr.dayNames[r_day] + " " + r_date + " " + date$configuration.fr.monthNames[r_month] + " " + year;
		sTime   = r_hours + ":" + minutes
		sConcat = " ";
	} else if (format == "f2_fr_FR") {
		// ven 26/7/2007 14:30
		sDate   = date$configuration.fr.dayNames[r_day].substring(0, 3) + " " + r_date + "/" + (r_month+1) + "/" + year;
		sTime   = r_hours + ":" + minutes
		sConcat = " ";
	} else if (format == "f3_fr_FR") {
		// 26/7/2007 14:30
		sDate   = r_date + "/" + (r_month+1) + "/" + year;
		sTime   = r_hours + ":" + minutes
		sConcat = " ";
	} else if (format == "f4_fr_FR") {
		// 26/07/2007 14:30
		sDate   = date  + "/" + month + "/" + year;
		sTime   = hours + ":" + minutes
		sConcat = " ";
	}
	
	if ((showDate && showTime) || (!showDate && !showTime)) {
		return sDate + sConcat + sTime;
	} else if (showDate) {
		return sDate;
	} else if (showTime) {
		return sTime;
	}
}

/*
	##################################################################################
*/

var date$configuration = {

	de	:	{
		monthNames 			: [ "Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember" ],
		dayNames 			: [ "Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag" ],
		monthShortcutLength : 3,
		dayShortcutLength 	: 2
	},

	en	:	{
		monthNames 			: [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ],
		dayNames 			: [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ],
		monthShortcutLength : 3,
		dayShortcutLength 	: 3
	},

	it	:	{
		monthNames 			: [ "Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno", "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre" ],
		dayNames 			: [ "Domenica", "Lunedi", "Martedi", "Mercoledi", "Giovedi", "Vernerdi", "Sabato" ],
		monthShortcutLength : 3,
		dayShortcutLength 	: 2
	},

	es	:	{
		monthNames 			: [ "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre" ],
		dayNames 			: [ "Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado" ]
	},

	jp	:	{
		monthNames 			: [ "１月", "２月", "３月", "４月", "５月", "６月", "７月", "８月", "９月", "１０月", "１１月", "１２月" ],
		dayNames 			: [ "日", "月", "火", "水", "木", "金", "土" ]
	},

	pl	:	{
		monthNames 			: [ "stycznia", "lutego", "marca", "kwietnia", "maja", "czerwca", "lipca", "sierpnia", "września", "października", "listopada", "grudnia" ],
		dayNames 			: [ "niedziela", "poniedziałek", "wtorek", "środa", "czwartek", "piątek", "sobota" ]
	},
	
	hr	:	{
		monthNames 			: [ "siječanj", "veljača", "ožujak", "travanj", "svibanj", "lipanj", "srpanj", "kolovoz", "rujan", "listopad", "studeni", "prosinac" ],
		dayNames 			: [ "nedjelja", "ponedjeljak", "utorak", "srijeda",	"četvrtak", "petak", "subota" ]
	},
	
	es	:	{
		monthNames 			: [ "enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre" ],
		dayNames 			: [ "domingo", "lunes", "martes", "miércoles", "jueves", "viernes", "sábado" ],
		monthShortcutLength : 3,
		dayShortcutLength 	: 3
	},

	ca	:	{
		monthNames 			: [ "Gener", "Febrer", "Març", "Abril", "Maig", "Juny", "Juliol", "Agost", "Setembre", "Octubre", "Novembre", "Desembre" ],
		dayNames 			: [ "Diumenge", "Dilluns", "Dimarts", "Dimecres", "Dijous", "Divendres", "Dissabte" ],
		monthShortcutLength : 3,
		dayShortcutLength 	: 4
	},

	eu	:	{
		monthNames 			: [ "Urtarrila", "Otsail", "Martxoa", "Apirila", "Maiatza", "Ekain", "Uztail", "Abuztu", "Iraila", "Urria", "Azaro", "Abendu" ],
		dayNames 			: [ "Igandea", "Astelehen", "Astearte", "Asteazken", "Ostegun", "Ostiral", "Larunbat" ],
		monthShortcutLength : 3,
		dayShortcutLength 	: 4
	},

	gl	:	{
		monthNames 			: [ "Xaneiro", "Febreiro", "Marzo", "Abril", "Maio", "Xuño", "Xullo", "Agosto", "Setembro", "Outubro", "Novembro", "Decembro" ],
		dayNames 			: [ "Domingo", "Luns", "Martes", "Mércores", "Xoves", "Venres", "Sábado" ],
		monthShortcutLength : 3,
		dayShortcutLength 	: 3
	},
	pt : {
		monthNames 			: [ "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro" ],
		dayNames 			: [ "Domingo", "Segunda-feira", "Terça-feira", "Quarta-feira", "Quinta-feira", "Sexta-feira", "Sábado" ],
		monthShortcutLength : 3,
		dayShortcutLength 	: 3

	},
	zh : {
        monthNames          : [ "1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月" ],
		dayNames            : [ "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" ],
        monthShortcutLength : 3,
        dayShortcutLength   : 3

	},
	sl : {
		monthNames 			: [ "januar", "februar", "marec", "april", "maj", "junij", "julij", "avgust", "september", "oktober", "november", "december" ],
		dayNames 			: [ "ponedeljek", "torek", "sreda", "četrtek", "petek", "sobota", "nedelja" ],
		monthShortcutLength : 3,
		dayShortcutLength 	: 3

	},
	fr : {
		monthNames 			: [ "janvier", "février", "mars", "avril", "mai", "juin", "juillet", "août", "septembre", "octobre", "novembre", "décembre" ],
		dayNames 			: [ "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi", "dimanche" ],
		monthShortcutLength : 3,
		dayShortcutLength 	: 3

	}	
}


/*
	##################################################################################
*/


/**
 * timezone format: "±HH:MM"
 */
function dateToTimeStamp(d, timezone) {
	if (timezone) {
		var oldMillies = d.getTime();
		var tz_hours = timezone.substring(1, 3);
		var tz_minutes = timezone.substring(4, 6);
		d.setTime((timezone.charAt(0) == '+' ? 1 : -1) * 1000 * 60 * (tz_minutes + 60 * tz_hours) + oldMillies);
	}
	var year = "" + d.getUTCFullYear();
	var month = (d.getUTCMonth() < 9 ? "0" : "") + (d.getUTCMonth() + 1);
	var date = (d.getUTCDate() < 10 ? "0" : "") + d.getUTCDate();
	var hours = (d.getUTCHours() < 10 ? "0" : "") + d.getUTCHours();
	var minutes = (d.getUTCMinutes() < 10 ? "0" : "") + d.getUTCMinutes();
	var seconds = (d.getUTCSeconds() < 10 ? "0" : "") + d.getUTCSeconds();
	return timestamp = year + month + date + hours + minutes + seconds;
}

function getTimeStamp(d) {
	var year = "" + d.getFullYear();
	var month = (d.getMonth() < 9 ? "0" : "") + (d.getMonth() + 1);
	var date = (d.getDate() < 10 ? "0" : "") + d.getDate();
	var hours = (d.getHours() < 10 ? "0" : "") + d.getHours();
	var minutes = (d.getMinutes() < 10 ? "0" : "") + d.getMinutes();
	var seconds = (d.getSeconds() < 10 ? "0" : "") + d.getSeconds();
	return timestamp = year + month + date + hours + minutes + seconds;
}

/**
 * iso format: YYYY-MM-DD HH:MM:SS[±II:NN]
 * - time zone (II = hours, NN = minutes) is ignored
 * time stamp format: YYYYMMDDHHMMSS
 */
function utcIsoToLocaleTimestamp(utcIso, showDate, showTime, format) {
	return dateToLocaleTimeStamp(utcIsoToDate(utcIso), showDate, showTime, format);
}

function isoToLocaleTimestamp(iso,showDate,showTime) {
	return dateToLocaleTimeStamp(isoToDate(iso),showDate,showTime);
}

/**
 * iso format: YYYY-MM-DD HH:MM:SS[±II:NN]
 * - time zone (II = hours, NN = minutes) is ignored
 * time stamp format: YYYYMMDDHHMMSS
 */
function utcIsoToTimestamp(utcIso, timezone) {
	return dateToTimeStamp(utcIsoToDate(utcIso), timezone);
}

function getSinceString(isoRef, isoDate) {
	/*
	*/
	var refTime  = isoToDate(isoRef).getTime();
	var dateTime = isoToDate(isoDate).getTime();
	var offset   = Math.round((dateTime - refTime) / 1000);

	if (offset <= 0) {
		return "";
	}

	var seconds  = offset % 60;
	var minutes  = (Math.floor(offset / 60) % 60);
	var hours    = Math.floor(offset / 60 / 60);
	var days     = Math.floor(offset / 60 / 60 / 24);

	if (offset <  60) 	  		return I18N.xlate("extras", "${#value} second(s) later",  { "value" : offset });
	if (offset <  60 * 60) 		return I18N.xlate("extras", "${#value} minutes(s) later", { "value" : minutes });
	if (offset <  60 * 60 * 24)	return I18N.xlate("extras", "${#hours}:${minutes} hour(s) later", { "hours" : hours, "minutes": (minutes < 10 ? "0" + minutes : minutes) });
	else 						return I18N.xlate("extras", "${#value} days(s) later", { "value" : days });
}


