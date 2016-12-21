// ********************************************************************
// Copyright (C) 2001 Microsoft Corporation. All rights reserved.
//
//	IMPORTANT.  Please read the legal.txt file, located in the 
//	"<CMS Install Directory>\Server\httpexec\WBC\Internals" 
//	directory, governing the use of this internal file."
// ********************************************************************

// Define constants
var ARRAY_MONTH_NAME = new Array ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");

//	Write date in local time
function WBC_writeUTC2Local(strDate)
{
	var pDate = new Date(strDate);
	WBC_writeDate(WBC_convertUTC2Local(pDate));
}

//	Convert GMT time to local time
function WBC_convertUTC2Local(pDateUTC)
{
	return new Date(pDateUTC.getTime() - pDateUTC.getTimezoneOffset() * 60 * 1000);
}

//	Convert Local time to GMT time
function WBC_convertLocal2UTC(pDateLocal)
{
	return new Date(pDateLocal.getTime() + pDateLocal.getTimezoneOffset() * 60 * 1000);
}

//	Return a date string in the "MMM DD YYYY, hh:mm:ss am/pm" or 24 hour "MMM DD YYYY, hh:mm:ss" format
function WBC_formatDateToString( pDate, bAmPm )
{
	if (bAmPm)
	{
		var nHours =  pDate.getHours();
		var strAmPm;
		if (nHours == 0) {
			nHours = 12;
			strAmPm = "am";
		} else if (nHours == 12) {
			strAmPm = "pm";
		} else if (nHours > 12) {
			nHours = nHours - 12;
			strAmPm = "pm";
		} else {
			strAmPm = "am";
		}

		return ( ARRAY_MONTH_NAME[pDate.getMonth()] + " " + WBC_addLeadingZero(pDate.getDate()) + " " + WBC_fixJavaScriptYear(pDate.getFullYear()) + ", " + WBC_addLeadingZero(nHours) + ":" + WBC_addLeadingZero(pDate.getMinutes()) + ":" + WBC_addLeadingZero(pDate.getSeconds()) + " " + strAmPm );
	}
	else
	{
		return (ARRAY_MONTH_NAME[pDate.getMonth()] + " " + WBC_addLeadingZero(pDate.getDate()) + " " + WBC_fixJavaScriptYear(pDate.getFullYear()) + " " + WBC_addLeadingZero(pDate.getHours()) + ":" + WBC_addLeadingZero(pDate.getMinutes()) + ":" + WBC_addLeadingZero(pDate.getSeconds()));
	}
}


//	Write date using document.write()
function WBC_writeDate(pDate) 
{
	document.write( WBC_formatDateToString( pDate, true ) );
}

// returns an integer value representing the number of 
// milliseconds between midnight, January 1, 1970 and the time value in the Date object
function WBC_getTime( strDate ) 
{
	var pDate = new Date( strDate );
	return pDate.getTime();
}

// Add leading zero to number less than 10
function WBC_addLeadingZero(nNum)
{
	if (nNum < 10) 
	{
		return "0" + nNum;
	}
	else 
	{
		return nNum;
	}
}

// Returns correct year for any year after 1000
function WBC_fixJavaScriptYear( nYear )
{
	if (nYear < 1000) 
	{
		return nYear + 1900;
	}
	else 
	{
		return nYear;
	}
}

// ----------------------------------------------------------------------------
//
// Deprecated functions; retained for backward compatibility with Version 3.x
//
// ----------------------------------------------------------------------------

function WBC_formatDate( pDate )
{
	return WBC_formatDateToString( pDate, false );
}

function WBC_get4DigitsYear( nYear )
{
	return WBC_fixJavaScriptYear( nYear );
}
