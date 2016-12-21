function sugarPreload(input) {
	document.imageArray = new Array(input.length);
	for (var i=0; i<input.length; i++) {
		document.imageArray[i] = new Image();
		document.imageArray[i].src = "assets/images/nav_" + input[i] + "_over.gif";
	}
}

function sugarMenu(names,element) {
	sugarPreload(names);
	var theMenu = document.getElementById(element);
	var nodeIMG;
	for (var i=0; i<theMenu.getElementsByTagName("A").length; i++) {
		var node = theMenu.getElementsByTagName("A")[i];
		if (node.getElementsByTagName("IMG")[0]) {
			node.onmouseover = function() {
				nodeIMG = this.getElementsByTagName("IMG")[0];
				nodeIMG.src = nodeIMG.src.replace("_up.","_over.");
			}
			node.onfocus = function() {
				nodeIMG = this.getElementsByTagName("IMG")[0];
				nodeIMG.src = nodeIMG.src.replace("_up.","_over.");
			}
			node.onmouseout = function() {
				nodeIMG = this.getElementsByTagName("IMG")[0];
				nodeIMG.src = nodeIMG.src.replace("_over.","_up.");
			}
			node.onblur = function() {
				nodeIMG = this.getElementsByTagName("IMG")[0];
				nodeIMG.src = nodeIMG.src.replace("_over.","_up.");
			}
			node.onclick = function() { window.location.href=this.href; }
		}
	}
}

window.onload = function() {
	var names = new Array("expo","loft","papa","pub","fireworks");
	if (document.getElementById("menu")) { sugarMenu(names,"menu"); }
	names = ("sub-pat","sub-pro","sub-emp","sub-fou","sub-cal");
	if (document.getElementById("subnav")) { sugarMenu(names,"subnav"); }
}

function launchMap(url) {
	var csmap = window.open(url,"csmap","top="+(screen.availHeight-600)/2+",left="+(screen.availWidth-750)/2+",width=750,height=600,statusbar=false,scrollbars=false");
	csmap.focus();
	//document.location.href = url;
}