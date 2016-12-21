// Custom JavaScript
// Lodging Interactive

	var arr_month = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
	var right_now = new Date();
	var month_now = right_now.getMonth() + 1;

	var day = right_now.getDate();
	
	var counter;
	
	if (month_now == 2)
		counter = 30;
	else if (month_now == 4 || month_now == 6 || month_now == 9 || month_now == 11)
		counter = 31;
	else
		counter = 32;

	if (day == counter)
		month_now = month_now + 1;

	document.write('<SELECT style="" NAME="StartDate_month" onChange="setDaysInMonth(this.form, \'StartDate\'); ">');
	document.write('<option></option>');
	
	for (i = 0; i < 12; i++)
	{
		var val = i + 1;
					
		if (month_now == val)
			document.write('<option value="' + val + '" selected>' + arr_month[i] + '</option>');
		else
			document.write('<option value="' + val + '">' + arr_month[i] + '</option>');
	}
	
	document.write('</SELECT>&nbsp;&nbsp;');
	
	document.write('<SELECT style="" NAME="StartDate_day">');
	document.write('<option></option>');
	
	for (i = 1; i < counter; i++)
	{
		if (day == counter)
			day = 1;
			
		if (day == i)
			document.write('<option value="' + i + '" selected>' + i + '</option>');
		else
			document.write('<option value="' + i + '">' + i + '</option>');
	}
	
	document.write('</SELECT>&nbsp;&nbsp;');

	document.write('<SELECT style="" NAME="StartDate_year" onChange="setDaysInMonth(this.form, \'StartDate\'); ">');
	document.write('<option></option>');
	
	var year = right_now.getYear();
	
	if (year < 2000)
		year = year + 1900;
		
	var next_year = year + 1;
	
	document.write('<option value="' + year + '" selected>' + year + '</option>');
	document.write('<option value="' + next_year + '">' + next_year + '</option>');
	
	document.write('</SELECT>');
	