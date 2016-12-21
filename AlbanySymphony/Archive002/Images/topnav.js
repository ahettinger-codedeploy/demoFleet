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
function preloadImages() {
	if (document.images) {
		nav01_over = newImage("img/nav/nav01-over.gif");
		nav02_over = newImage("img/nav/nav02-over.gif");
		nav03_over = newImage("img/nav/nav03-over.gif");
		nav04_over = newImage("img/nav/nav04-over.gif");
		nav05_over = newImage("img/nav/nav05-over.gif");
		nav06_over = newImage("img/nav/nav06-over.gif");
		nav07_over = newImage("img/nav/nav07-over.gif");
		nav08_over = newImage("img/nav/nav08-over.gif");
		preloadFlag = true;
	}
}