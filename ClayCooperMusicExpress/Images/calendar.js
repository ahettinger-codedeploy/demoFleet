var calendarScriptHTML = '<scr'+'ipt src="http://calendars.branson.com/calendar.php?';
if(window.branson_cal_name) calendarScriptHTML += 'cal='+branson_cal_name;
if(window.branson_cal_template) calendarScriptHTML += '&amp;tpl='+branson_cal_template;
if(window.branson_cal_begin) calendarScriptHTML += '&amp;begin='+branson_cal_begin;
if(window.branson_cal_end) calendarScriptHTML += '&amp;end='+branson_cal_end;
if(window.branson_cal_narrow) calendarScriptHTML += '&amp;narrow';
if(window.branson_cal_cols) calendarScriptHTML += '&amp;cols='+branson_cal_cols;
if(window.location) calendarScriptHTML += '&amp;loc='+window.location;
calendarScriptHTML += '&amp;output=js" type="text/javascript"></scr'+'ipt>';

document.write(calendarScriptHTML);