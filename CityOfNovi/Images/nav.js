﻿function ie6nav() {
	if (document.all&&document.getElementById) {
		navRoot = document.getElementById("nav");
		for (i=0; i<navRoot.childNodes.length; i++) {
			node = navRoot.childNodes[i];
			if (node.nodeName=="LI") {
				node.onmouseover=function() {
					this.className+=" iehover";
 				}
  				node.onmouseout=function() {
  					this.className=this.className.replace(" iehover", "");
   				}
   			}
  		}
 	}
}