function findPos(obj) {
	var curleft = curtop = 0;
	if (obj.offsetParent) {
		curleft = obj.offsetLeft
		curtop = obj.offsetTop
		while (obj = obj.offsetParent) {
			curleft += obj.offsetLeft
			curtop += obj.offsetTop
		}
	}
	return [curleft,curtop];
}

function addLoadEvent(func) {
	var oldonload = window.onload;
	if (typeof window.onload != 'function') {
		window.onload = func;
	} else {
		window.onload = function() {
			oldonload();
			func();
		}
 	}
}

function clearSearch() {
	if(!document.getElementsByTagName) return false;
	var inputs = document.getElementsByTagName("input");
	for(i=0; i<inputs.length; i++) {
		var inputName = inputs[i].getAttribute("name");
		if(inputName == "zoom_query") {
			inputs[i].onfocus = function() {
				this.value="";
			}
			inputs[i].onblur = function() {
				if(this.value=="") {
					this.value="search...";
				}
			}
		}
	}
}

addLoadEvent(clearSearch);

function closePopup(whatDiv) {
	if(document.getElementById(whatDiv)) {
		var popups = document.getElementById(whatDiv);
		popups.style.display = "none";
	}
}

function initNav() {
	var navHolder = document.getElementById('nav');
	var lis = navHolder.getElementsByTagName('li');
	for(i=0; i<lis.length; i++) {
		lis[i].onmouseover = function() {
			if(undefined!==window.closeTheThing) {
				clearTimeout(closeTheThing);
			}
			var liPartialName = this.id.substring(3, this.id.length);
			var popupName = "s"+liPartialName;
			if((document.getElementById(popupName))&&(this.className!="paged")) {
				var popups = document.getElementById(popupName);
				popups.style.display = "block";
			}
			for(j=0; j<lis.length; j++) {
				var liPName = lis[j].id.substring(3, lis[j].id.length);
				var pName = "s"+liPName;
				if(document.getElementById(pName)) {
					var ps = document.getElementById(pName);
					if(ps!=popups) {
						ps.style.display = "none";
					}
				}
			}
		}		
		lis[i].onmouseout = function() {
			var liPartialName = this.id.substring(3, this.id.length);
			var popupName = "s"+liPartialName;
			var closeIt = "closePopup('"+popupName+"')";
			closeTheThing = setTimeout(closeIt, 250)  
		}
	}
	
	// to keep boxes open //
	var navPop = document.getElementsByTagName('div');
	for(i=0; i<navPop.length; i++) {
		if(navPop[i].className=="navpop") {
			navPop[i].onmouseover = function() {
				if(undefined!==window.closeTheThing) {
					clearTimeout(closeTheThing);
				}
				this.style.display = "block";
				thisID = this.id;
				linkID = "np-"+thisID.substring(1, thisID.length);
				
				if(document.getElementById(linkID)) {
					linkClass = document.getElementById(linkID);
					linkClass.className = "hovered";
				}
			}
			navPop[i].onmouseout = function() {
				thisID = this.id;
				linkID = "np-"+thisID.substring(1, thisID.length);
				if(document.getElementById(linkID)) {
					linkClass = document.getElementById(linkID);
					linkClass.className = "";
				}
				var closeIt = "closePopup('"+thisID+"')";
				closeTheThing = setTimeout(closeIt, 60) 
			}
		}
	}
}

addLoadEvent(initNav);

// Sub Nav

/* Set Link Styles */

function setLinks() {
	if (!document.getElementsByTagName) return false;
	var links = document.getElementsByTagName("a");
	for(i=0; i<links.length; i++) {
		var linksRel = links[i].getAttribute("rel");
		if(linksRel=="video") {
			links[i].onclick = function() {
				window.open(this.href, "littleWindow", "toolbar=0, scrollbars=0, statusbar=0, menubar=0, resizable=0 location=no, width=318, height=240");
				return false;
			}
		}
		if(linksRel=="external") {
			links[i].target = "_blank"
			if(!links[i].className) {
				links[i].className = "ext"
			}
		}
		var linksHref = links[i].getAttribute("href");
		if(linksHref.length>2) {
			var linksExt = linksHref.substring((linksHref.length-3), linksHref.length);
		} else {
			var linksExt = "";
		}
		
		if(linksExt=="pdf") {
			if(!links[i].className) {
				if(links[i].parentNode.className!="largelinks") {
					links[i].className = "acr";
				}
			}
		}
		var linksFExt = linksHref.substring(0,6);
		if (linksFExt=="mailto") {
			links[i].className = "sem";
		}
	}
}

addLoadEvent(setLinks);

function noDoubleClick(what) {
	what.parentNode.style.display = "none";
	var process = document.getElementById("processing");
	process.style.display = "block";
}

function goForm() {
	if(document.getElementById("reloadElement1")) {
		var reloader = document.getElementById("reloadElement1");
		reloader.onchange = function() {
			window.open("index.php?sortBy="+this.value, "_parent");
		}
	}
	if(document.getElementById("fclassDay")) {
		var reloader = document.getElementById("fclassDay");
		reloader.onchange = function() {
			window.open("/lifeu/?day="+this.value, "_parent");
		}
	}
	if(document.getElementById("fcategorySelect")) {
		var reloader = document.getElementById("fcategorySelect");
		reloader.onchange = function() {
			window.open("/lifeu/?cat="+this.value, "_parent");
		}
	}
	if(document.getElementById("fAgeGroup")) {
		var reloader = document.getElementById("fAgeGroup");
		reloader.onchange = function() {
			window.open(this.value, "_parent");
		}
	}
}

addLoadEvent(goForm);