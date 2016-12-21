<!--

function showHide(id, trigger) {
	if( document.getElementById ) {
		if( document.getElementById(id).style.display ) {
			if( trigger != 0 ) {
				document.getElementById(id).style.display = "block";
				this.blur();
			} else { 
				document.getElementById(id).style.display = "none";
			}
		} else {
			location.href = "http://www.lowkeydesigns.com/dev/bw/bw/";
			return true;
		}
	} else {
	location.href = "http://www.lowkeydesigns.com/dev/bw/bw/";
	return true;
	}
}

var newwindow = '';

function adpop(x) {
	url = '../bwf/ad_popup.php?x='+x;
	if (!newwindow.closed && newwindow.location) {
		newwindow.location.href = url;
	} else {
		var winleft = (screen.width - 550) / 2;
 		var wintop = (screen.height - 650) / 2;
newwindow=window.open(url,'name','height=650,width=550,top='+wintop+',left='+winleft+',scrollbars=yes');
		if (!newwindow.opener) { newwindow.opener = self; }
	}
	if (window.focus) { newwindow.focus(); }
	return false;
}

function galpop(x) {
	url = '../bwf/gal_popup.php?x='+x;
	if (!newwindow.closed && newwindow.location) {
		newwindow.location.href = url;
	} else {
		var winleft = (screen.width - 550) / 2;
 		var wintop = (screen.height - 650) / 2;
newwindow=window.open(url,'name','height=650,width=550,top='+wintop+',left='+winleft+',scrollbars=yes');
		if (!newwindow.opener) { newwindow.opener = self; }
	}
	if (window.focus) { newwindow.focus(); }
	return false;
}

-->