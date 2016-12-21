//==============================================================================
// Suckerfish menu preparation for IE, found on htmldog.com
var sfHover = function() {
	// Retrieve the top level dropdown menu list object
	var sfEls = document.getElementById("dm_toplevel");
	if (sfEls) {
		sfEls = sfEls.getElementsByTagName("LI");
		// For each list item in the top level list...
		for (var i = 0; i < sfEls.length; i++) {
			// Set the mouseover action to add the sfhover class
			sfEls[i].onmouseover = function() {
				this.className += " sfhover";
			};
			// Set the mouseout action to remove the sfhover class
			sfEls[i].onmouseout = function() {
				this.className = this.className.replace(new RegExp(" sfhover\\b"), "");
			};
		}
	}
};

// Set the onload event for the page to be this sfHover function
if (window.attachEvent) {
	window.attachEvent("onload", sfHover);
}
