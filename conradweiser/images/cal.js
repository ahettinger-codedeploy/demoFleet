
function pickDate(mm,dd,yyyy)
	{
	var y1 = yyyy*10000;
	var m1 = mm*100;
	var date1 = y1+m1+dd;
	var mm2 = mm;
	if(mm<10) { mm2 = '0'+mm; }
	var dd2 = dd; 
	if(dd<10) { dd2 = '0'+dd; } 
	var datePreview = '';
	if(document.getElementById("datePreview")) // NEW EVENT FORM SHOWING ... 
		{ 
		document.forms.events.newDate.value = date1;
		datePreview = document.getElementById("datePreview").innerHTML = mm2+"/"+dd2+"/"+yyyy; 
		}
	if(document.getElementById("datePreview2"))
		{ 
		var datePreview2 = document.getElementById("datePreview2").innerHTML = mm2+"/"+dd2+"/"+ yyyy; 
		if(document.getElementById("chkMatch2"))
			{
			document.forms.events.chkMatch2.value = mm2+"/"+dd2+"/"+ yyyy;
			}
		}
	}

function pickDate2(mm,dd,yyyy)
	{
	var y1 = yyyy*10000;
	var m1 = mm*100;
	var date1 = y1+m1+dd;
	var mm2 = mm;
	if(mm<10) { mm2 = '0'+mm; }
	var dd2 = dd; 
	if(dd<10) { dd2 = '0'+dd; } 
	var datePreview = '';
	if(document.getElementById("datePreview")) // NEW EVENT FORM SHOWING ... 
		{ 
		document.forms.events.newDate.value = date1;
		datePreview = document.getElementById("datePreview").innerHTML = mm2+"/"+dd2+"/"+yyyy; 
		}
	if(document.getElementById("datePreview2"))
		{ 
		var datePreview2 = document.getElementById("datePreview2").innerHTML = mm2+"/"+dd2+"/"+ yyyy; 
		if(document.getElementById("chkMatch2"))
			{
			document.forms.events.chkMatch2.value = mm2+"/"+dd2+"/"+ yyyy;
			document.forms.events.submit();
			}
		}
	}
	
function changeEvent(n) // 
		{
		document.forms.events.delEvent.value = 0;
		document.forms.events.chngEvent.value = n;
		document.forms.events.submit();
		}
	
function deleteEvent(n)
		{
		// alert("Delete Event No. "+n); // TEST - OK
		document.forms.events.chngEvent.value = 0;
		document.forms.events.delEvent.value = n;
		document.forms.events.submit();
		}
	
