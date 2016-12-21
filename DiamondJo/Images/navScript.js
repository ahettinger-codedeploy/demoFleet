<!--

function newImage(arg) {
	if (document.images) {
		rslt = new Image();
		rslt.src = arg;
		return rslt;
	}
}

function changeImages() {
	if (document.images && (preloadFlag == true)) {
		for (var i=0; i<changeImages.arguments.length; i+=2) {
			document[changeImages.arguments[i]].src = changeImages.arguments[i+1];
		}
	}
}

var preloadFlag = false;
function preloadNavImages() {
	if (document.images) {
		nav_home_over = newImage("/PrivateLabel/DiamondJo//PrivateLabel/DiamondJo/Images/nav_home-over.gif");
		nav_dining_over = newImage("/PrivateLabel/DiamondJo//PrivateLabel/DiamondJo/Images/nav_dining-over.gif");
		nav_entertainment_over = newImage("/PrivateLabel/DiamondJo//PrivateLabel/DiamondJo/Images/nav_entertainment-over.gif");
		nav_diamondClub_over = newImage("/PrivateLabel/DiamondJo//PrivateLabel/DiamondJo/Images/nav_diamondClub-over.gif");
		nav_driving_over = newImage("/PrivateLabel/DiamondJo//PrivateLabel/DiamondJo/Images/nav_driving-over.gif");
		nav_pr_over = newImage("/PrivateLabel/DiamondJo//PrivateLabel/DiamondJo/Images/nav_pr-over.gif");
		nav_careers_over = newImage("/PrivateLabel/DiamondJo//PrivateLabel/DiamondJo/Images/nav_careers-over.gif");
		nav_promo_over = newImage("/PrivateLabel/DiamondJo//PrivateLabel/DiamondJo/Images/nav_promo-over.gif");
		nav_contact_over = newImage("/PrivateLabel/DiamondJo//PrivateLabel/DiamondJo/Images/nav_contact-over.gif");
		nav_gaming_over = newImage("/PrivateLabel/DiamondJo//PrivateLabel/DiamondJo/Images/nav_gaming-over.gif");
		preloadFlag = true;
	}
}

// -->
