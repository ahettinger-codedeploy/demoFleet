/*
* Core time methods for use across City of Albuquerque applications
* History
* Version	Date		By		Description
*--------------------------------------------------------------------
* 1.0		01/21/2004	ml		New release
*/

//Array containing days in the week
var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

//Array containing months as strings.  Full length names
var fullMonths = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

//Array containing months as strings.  Abbreviated names
var shortMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

/*
Loop and set the status bar with the current time as in ABQ
@return void
*/

function showABQStatusTime(){
	var messageStr = "Time in Albuquerque is " + getABQTimeStrFull();
	defaultStatus = messageStr;
//	status = messageStr;
	setTimeout("showABQStatusTime()", 1000);
}

/*
Abbreviated date and time message forAlbuquerque time
@returns String in the form mm/dd/yyyy hh:mm:ss
*/
function getABQTimeStrFull(){
	var abqDate = getABQTime();
	var hours = abqDate.getUTCHours();
	var minutes = abqDate.getUTCMinutes();
	var seconds = abqDate.getUTCSeconds();

	return(
		abqDate.getUTCMonth() + 1
		+ '/' + abqDate.getUTCDate() + '/'
		+ abqDate.getUTCFullYear()
		+ ' '
		+ (hours >= 10 ? hours : '0' + hours)
		+ ':'
		+ (minutes >= 10 ? minutes: '0' + minutes)
		+ ':'
		+ (seconds >= 10 ? seconds : '0' + seconds)
	);
}

/*
Show the time in ABQ.  Note that this converts a UTC time, so the Date object returned
should assume UTC == MST.  Locale values are therefore trashed.
@returns UTC - 7hrs (6 if daylight savings)
*/
function getABQTime(){
	var stStart = getABQSummerTimeStart();
	var stEnd = getABQSummerTimeEnd();
	var currDate = new Date();
	var currDateLong = currDate.getTime();
	var tz = -7;
	var hrs = currDate.getUTCHours();

	if(currDateLong > stStart.getTime() && currDateLong < stEnd.getTime())
		tz++;

	hrs += tz;

	if(hrs < 0){
		hrs += 24;
		currDate.setUTCDate(currDate.getUTCDate() -1);
	}

	currDate.setUTCHours(hrs);
	return(currDate);
}


/*
Return the start date of daylight savings.  Note that this should be the UTC values -
not the local time values!!
@return GMT date that MST daylight savings starts
*/
function getABQSummerTimeStart(){
	var stDateStart = new Date();
	stDateStart.setUTCMonth(3);
	stDateStart.setUTCDate(1);

	while(stDateStart.getUTCDay() != 0)
		stDateStart.setUTCDate(stDateStart.getUTCDate() +1);

	stDateStart.setUTCHours(9);
	stDateStart.setUTCMinutes(0);
	return(stDateStart);
}

/*
Return the end date of daylight savings.  Note that this should be the UTC values -
not the local time values!!
@return GMT date that MST daylight savings ends
*/
function getABQSummerTimeEnd(){
	var stDateEnd = new Date();
	stDateEnd.setUTCMonth(9);
	stDateEnd.setUTCDate(31);

	while(stDateEnd.getUTCDay() != 0)
		stDateEnd.setUTCDate(stDateEnd.getUTCDate() -1);

	stDateEnd.setUTCHours(9);
	stDateEnd.setUTCMinutes(0);
	return(stDateEnd);
}