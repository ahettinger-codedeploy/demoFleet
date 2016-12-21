function dateStamp(){
	var months=new Array(13);
	months[1]="Jan";
	months[2]="Feb";
	months[3]="Mar";
	months[4]="Apr";
	months[5]="May";
	months[6]="Jun";
	months[7]="Jul";
	months[8]="Aug";
	months[9]="Sep";
	months[10]="Oct";
	months[11]="Nov";
	months[12]="Dec";
	var time=new Date();
	var lmonth=months[time.getMonth() + 1];
	var date=time.getDate();
	var year=time.getYear();
	if (year < 2000)    // Y2K Fix, Isaac Powell
	year = year + 1900; // http://onyx.idbsu.edu/~ipowell
	document.write(lmonth + " ");
	document.write(date + ", " + year);
}