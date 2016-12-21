var oLastElement = null;

function showLayer (id) {
	if (id=='') {return false;}
	
	var obj = document.getElementById(id);
	if (!obj) {return false;}
	
	if (oLastElement != null) {
		oLastElement.style.display = 'none';
	}	
	obj.style.display = 'block';	
	
	oLastElement = obj;
	return false;
}

function MM_findObj(n, d) { //v4.01
	var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
	d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function IsBlank(obj){return (GetValue(obj)=="");}

function IsEqual(obj1, obj2){return (GetValue(obj1)==GetValue(obj2));}

function IsEmail(obj, allowBlank){
	var s = new String(GetValue(obj));
    var i = 1;
    var sLength = s.length;
    
    if (sLength==0) {return (allowBlank) ? true : false;} //check length
    while ((i < sLength) && (s.charAt(i) != "@")) {i++;} //find @
	
	if ((i >= sLength) || (s.charAt(i) != "@")) {return false;}
    else {i += 2;}
    
    while ((i < sLength) && (s.charAt(i) != ".")) {i++;}//find .
    if ((i >= sLength - 1) || (s.charAt(i) != ".")) {return false;}
	else {return true;}   
}

function IsNumeric(strString, allowBlank){
	if (strString.length == 0){return (allowBlank) ? true : false;}
	
	var strValidChars = "0123456789.,-$";
	var strChar;
	var blnResult = true;

	//  test strString consists of valid characters listed above
	for (i = 0; i < strString.length && blnResult == true; i++) {
	   strChar = strString.charAt(i);
	   if (strValidChars.indexOf(strChar) == -1){blnResult = false;}
	}
	return blnResult;
}

function GetValue(obj){
	var val = null;
	
	if(obj){
		switch(obj.tagName){
			case "SELECT":
				val = obj.options[obj.selectedIndex].value;
				break;
			
			case "RADIO":
				if(obj.length){
					for(i=0;i<obj.length;i++){
						if(obj[i].checked){val=obj[i].value;break;}
					}
					if(val==null){val="";}
				}
				else{
					val = obj.value;
				}
				break;
					
			default:
				val = obj.value;
				break;
		}
	}
	return val;
}
