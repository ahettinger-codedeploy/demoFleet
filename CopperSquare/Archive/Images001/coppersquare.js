
function launchMap(url) {
	var csmap = window.open(url,"csmap","top="+(screen.availHeight-600)/2+",left="+(screen.availWidth-750)/2+",width=750,height=600,statusbar=false,scrollbars=false");
	csmap.focus();
	//document.location.href = url;
}

function launchTour(url) {
	var tourwin = window.open(url,"tourWin","top="+(screen.availHeight-545)/2+",left="+(screen.availWidth-360)/2+",width=360,height=545,statusbar=false");
	tourwin.focus();
}

function launchRemind(url) {
	var remindwin = window.open(url,"tellWin","top="+(screen.availHeight-270)/2+",left="+(screen.availWidth-360)/2+",width=360,height=270,statusbar=false");
	remindwin.focus();
}

function newElement(element) {
	return (document.getElementById(element) ? document.getElementById(element) : false);
}


function tellFriend(url) {
	var tellwin = window.open(url,"tellWin","top="+(screen.availHeight-320)/2+",left="+(screen.availWidth-360)/2+",width=360,height=320,statusbar=false");
	tellwin.focus();
}


function sugarPreload(prefix,names,suffixes,type) { 
  total = names.length + suffixes.length;
  document.imageArray = new Array(total);
  for (var i=0; i<names.length; i++) {
	 document.imageArray[i] = new Image;
	 for (var j=0; j<suffixes.length; j++) document.imageArray[i].src = "/images/" + prefix + "-" + names[i] + "-" + suffixes[j] + "." + type;
  }
}


function sugarDropDown(theMenu) {
	var names = new Array("home","about","whattodo","ambassadors","construction","livinghere","directory","contact","business","gettinghere","workinghere");
	sugarPreload("nav",names,Array("over"),"gif");
	for (var i=0; i<theMenu.getElementsByTagName("A").length; i++) {
		var node = theMenu.getElementsByTagName("A")[i];
		node.onmouseover = function() {
			this.getElementsByTagName("IMG")[0].src=this.getElementsByTagName("IMG")[0].src.replace("up","over");
		}
		node.onfocus = function() {
			this.getElementsByTagName("IMG")[0].src=this.getElementsByTagName("IMG")[0].src.replace("up","over");
		}
		node.onmouseout = function() {
			this.getElementsByTagName("IMG")[0].src=this.getElementsByTagName("IMG")[0].src.replace("over","up");
		}
		node.onblur = function() {
			this.getElementsByTagName("IMG")[0].src=this.getElementsByTagName("IMG")[0].src.replace("over","up");
		}
		node.onclick = function() { window.location.href=this.href; }
	}
}


// Modify DOM when Page is Loaded
window.onload = function() {

	// Check if Javascript is Good
	if (!document.getElementById && !document.getElementsByTagName) return false;


	// Create Dropdown Menu
	if (!document.getElementById("whattodo")) {
		theMenu = newElement("menu");
		if (theMenu) sugarDropDown(theMenu);
	}
	// End Drop Down Creation


	// Change Password Popup
	var password_form = newElement("changePass");
	if (password_form) {
		passwordForm.onclick = function() {
			window.open("/assets/popups/mailpassword.php","lostPassWin","top="+(window.outerHeight-260)/2+",left="+(window.outerWidth-400)/2+",width=360,height=150");
			return false;
		}
	}
	// End Change Password Popup
	
	
	// Begin Marquee Navigation
	var marquee_map = newElement("marqueeMap");
	marquee_image = newElement("marqueeImage");
	if (marquee_map && marquee_image) {
		for (i=0;i!=marquee_map.getElementsByTagName("AREA").length;i++) {
			sugarPreload("nav-mini",Array(i),Array("over","act"),"jpg");
			node = marquee_map.getElementsByTagName("AREA")[i];
			node.onmouseover = node.onfocus = function() { marquee_image.src = marquee_image.src.replace('0-up',this.id.replace("nav",'') + '-over'); }
			node.onmouseout = node.onblur = function() { marquee_image.src = marquee_image.src.replace(this.id.replace("nav",'') + '-over','0-up'); }
		}
	}
	// End Marquee Navigation


	// Add Javascript History Action on Back Links
	var backLink = newElement("backLink");
	if (backLink) {
		backLink.onclick = function() { window.history.back(-1); return false; }
	}
	// End Back Lnks
	
	
	// Create popup for rules link
	var rules_link = newElement("rulesLink");
	if (rules_link) {
		rules_link.onclick = function() {
			window.open(this.href,"rules","top="+(window.outerHeight-400)/2+",left="+(window.outerWidth-700)/2+",width=700,height=400,scrollbars");
			return false;
		}
	}
	// End Back Lnks
	
	
	// Event Keywords
	var keyword_input = newElement("keywords");
	if (keyword_input) {
		keyword_input.onfocus = function() {
			if (this.value=="Search Keywords") this.value = '';
		}
		keyword_input.onblur = function() {
			if (this.value=='') this.value = "Search Keywords";
		}
	}
	// End Event Keywords
	
	
	// Coupon Search
	var interests = newElement("connectInterests");
	var checkbox = newElement("connectCheckbox");
	if (interests && checkbox) {
		checkbox.onmouseup = function() {
			interests.style.display = (!this.checked ? "inline" : "none");
		}
	}
	// End Coupon Search
	
	
	// Connect Form
	var connect_form = newElement("connectForm");
	if (connect_form) {
		connect_form.onsubmit = function() {
			if (this.elements['First Name'].value.length<2) {
				this.elements['First Name'].className = "error";
				return false;
			} else if (this.elements['Last Name'].value.length<2) {
				if (this.elements['First Name'].className=="error") this.elements['First Name'].className = "";
				this.elements['Last Name'].className = "error";
				return false;
			} else if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(this.elements['Email Address'].value)) {
				return true;
			} else {
				if (this.elements['First Name'].className=="error") this.elements['First Name'].className = "";
				if (this.elements['Last Name'].className=="error") this.elements['Last Name'].className = "";
				this.elements['Email Address'].className = "error";
				return false;
			}
		}
	}
	// End Connect Form
	
	

}
// End Document OnLoad

