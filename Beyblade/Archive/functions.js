function showStatus(msg) {
	window.status = msg;
	return true;
}

function on(imgName) {
	if (document.images) {
		eval("var " + imgName + "_on" + "= new Image()");
		eval(imgName.toString() + "_on.src = \"\/PrivateLabel\/Beyblade\/images\/" + imgName + "-on.gif\"");
		document[imgName].src = eval(imgName + "_on.src");
	}
}

function off(imgName) {
	if (document.images) {
		eval("var " + imgName + "_off" + "= new Image()");
		eval(imgName.toString() + "_off.src = \"\/PrivateLabel\/Beyblade\/images\/" + imgName + "-off.gif\"");
		document[imgName].src = eval(imgName + "_off.src");

		return showStatus('');

	}
}

function openWindow(url, name, width, height, options) {
	var newWin = window.open(url, name, "width=" + width + ",height=" + height + "," + options);
}

function openBridge(URL) {
	openWindow(URL,'clickthrough', 600,400,'scrollbars=1,menubar=0,toolbar=0,location=0,status=0,resizable=1');
}

function showEvents(URL) {
	openWindow(URL,'events', 650,500,'scrollbars=1,menubar=0,toolbar=0,location=0,status=0,resizable=1');
}