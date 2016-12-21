
/* ----------- BROWSER DETECTION ----------- */
browserName = navigator.appName;
browserVer = parseInt(navigator.appVersion);

if((browserName == "Netscape" && browserVer >=3)||(browserName == "Microsoft Internet Explorer" && browserVer >=4))
	browser = "ver3";
else browser = "ver2";


/* ----------- POPUP WINDOW FUNCTIONS ----------- */
var newWin
function closeWin()
{
	if(newWin && !newWin.closed)
	{
		newWin.close()
	}
}

function openWin(obj,wt,ht,sc,rz)

{
	if ((browser == "ver3") && (browserName == "Microsoft Internet Explorer" && navigator.platform != "MacPPC"))
	{
		var Upobj=obj.toUpperCase()
		if(Upobj.indexOf("PRESSMAINT")!=-1)
			{
				wt=560
				ht=760
			}
		if(Upobj.indexOf("PAGEMAINT")!=-1)
			{
				wt=510
				ht=760
			}
		if(Upobj.indexOf("POSTINGSMAINT")!=-1)
			{
				wt=470
				ht=680
			}
		if(Upobj.indexOf("CONTACTSMAINT")!=-1)
			{
				wt=530
				ht=760
			}
		if(Upobj.indexOf("PRODUCTMAINT")!=-1)
			{
				wt=800
				ht=760
			}
		if(Upobj.indexOf("EVENTSMAINT")!=-1)
			{
				wt=800
				ht=760
			}
		if(Upobj.indexOf("OHMAINT")!=-1)
			{
				wt=510
				ht=760
			}
		if(Upobj.indexOf("DOWNLOADMAINT")!=-1)
			{
				wt=510
				ht=760
			}
		itsNav3(obj,wt,ht,sc,rz)
	}
	else if (browser == "ver2")
		{
			var Upobj=obj.toUpperCase()
			if(Upobj.indexOf("PRESSMAINT")!=-1)
				{
					wt=560
					ht=760
				}
			if(Upobj.indexOf("PAGEMAINT")!=-1)
				{
					wt=510
					ht=760
				}
			if(Upobj.indexOf("POSTINGSMAINT")!=-1)
				{
					wt=470
					ht=680
				}			
			if(Upobj.indexOf("CONTACTSMAINT")!=-1)
				{
					wt=530
					ht=760
				}
			if(Upobj.indexOf("PRODUCTMAINT")!=-1)
				{
					wt=800
					ht=760
				}
			if(Upobj.indexOf("EVENTSMAINT")!=-1)
				{
					wt=800
					ht=760
				}
			if(Upobj.indexOf("OHMAINT")!=-1)
				{
					wt=510
					ht=760
				}
			if(Upobj.indexOf("DOWNLOADMAINT")!=-1)
				{
					wt=510
					ht=760
				}
			ie3(obj,wt,ht,sc,rz)
		}
		else
		{
			var Upobj=obj.toUpperCase()
			if(Upobj.indexOf("PRESSMAINT")!=-1)
				{
					wt=560
					ht=760
				}
			if(Upobj.indexOf("PAGEMAINT")!=-1)
				{
					wt=510
					ht=760
				}
			if(Upobj.indexOf("POSTINGSMAINT")!=-1)
				{
					wt=470
					ht=680
				}
			if(Upobj.indexOf("CONTACTSMAINT")!=-1)
				{
					wt=530
					ht=760
				}
			if(Upobj.indexOf("PRODUCTMAINT")!=-1)
				{
					wt=800
					ht=760
				}
			if(Upobj.indexOf("OHMAINT")!=-1)
				{
					wt=510
					ht=760
				}
			if(Upobj.indexOf("DOWNLOADMAINT")!=-1)
				{
					wt=510
					ht=760
				}
			ie2(obj,wt,ht)
		}
}

function itsNav3(obj,wt,ht,sc,rz)
{
	if(sc=="" || sc == null)
	{
		sc="yes"
	}
	if(rz=="" || rz == null)
	{
		rz="yes"
	}
	var Upobj=obj.toUpperCase()
	if(Upobj.indexOf("PRESSMAINT")!=-1)
		{
			wt=560
			ht=760
		}
	if(Upobj.indexOf("PAGEMAINT")!=-1)
		{
			wt=510
			ht=760
		}
	if(Upobj.indexOf("POSTINGSMAINT")!=-1)
		{
			wt=470
			ht=680
		}
	if(Upobj.indexOf("CONTACTSMAINT")!=-1)
		{
			wt=530
			ht=760
		}
	if(Upobj.indexOf("PRODUCTMAINT")!=-1)
		{
			wt=800
			ht=760
		}
	if(Upobj.indexOf("OHMAINT")!=-1)
		{
			wt=510
			ht=760
		}
	if(Upobj.indexOf("DOWNLOADMAINT")!=-1)
		{
			wt=510
			ht=760
		}
	if(newWin == null || newWin.closed)
	{
		newWin = window.open(obj, "", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars="+sc+",resizable="+rz+",width=" + wt + ",height=" + ht + ",top=25,left=150")
	}
	else
	{
		newWin.close()
		newWin = window.open(obj, "","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars="+sc+",resizable="+rz+",width=" + wt + ",height=" + ht + ",top=25,left=150")
	}
}

function ie3(obj,wt,ht,sc,rz)
{
	if(sc=="" || sc == null)
	{
		sc="yes"
	}
	if(rz=="" || rz == null)
	{
		rz="yes"
	}
	var Upobj=obj.toUpperCase()
	if(Upobj.indexOf("PRESSMAINT")!=-1)
		{
			wt=560
			ht=760
		}
	if(Upobj.indexOf("PAGEMAINT")!=-1)
		{
			wt=510
			ht=760
		}
	if(Upobj.indexOf("POSTINGSMAINT")!=-1)
		{
			wt=470
			ht=680
		}
	if(Upobj.indexOf("CONTACTSMAINT")!=-1)
		{
			wt=530
			ht=760
		}
	if(Upobj.indexOf("PRODUCTMAINT")!=-1)
		{
			wt=800
			ht=760
		}
	if(Upobj.indexOf("OHMAINT")!=-1)
		{
			wt=510
			ht=760
		}
	if(Upobj.indexOf("DOWNLOADMAINT")!=-1)
		{
			wt=510
			ht=760
		}
	if(newWin == null || newWin.closed)
	{
		newWin = window.open(obj, 'newWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars="+sc+",resizable="+rz+",width=' + wt + ',height=' + ht + ',top=25,left=150')
	}
	else
	{
		newWin = window.open(obj, 'newWin','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars="+sc+",resizable="+rz+",width=' + wt + ',height=' + ht + ',top=25,left=150')
	}
}

function ie2(obj,wt,ht,sc,rz)
{
	if(sc=="" || sc == null)
	{
		sc="yes"
	}
	if(rz=="" || rz == null)
	{
		rz="yes"
	}
	var Upobj=obj.toUpperCase()
	if(Upobj.indexOf("PRESSMAINT")!=-1)
		{
			wt=560
			ht=760
		}
	if(Upobj.indexOf("PAGEMAINT")!=-1)
		{
			wt=510
			ht=760
		}
	if(Upobj.indexOf("POSTINGSMAINT")!=-1)
		{
			wt=470
			ht=680
		}
	if(Upobj.indexOf("CONTACTSMAINT")!=-1)
		{
			wt=530
			ht=760
		}
	if(Upobj.indexOf("PRODUCTMAINT")!=-1)
		{
			wt=800
			ht=760
		}
	if(Upobj.indexOf("OHMAINT")!=-1)
		{
			wt=510
			ht=760
		}
	if(Upobj.indexOf("DOWNLOADMAINT")!=-1)
		{
			wt=510
			ht=760
		}
		newWin = window.open(obj, "", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars="+sc+",resizable="+rz+",width=" + wt + ",height=" + ht + ",top=25,left=150")
}



