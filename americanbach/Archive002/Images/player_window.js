// Function to pop-up a centered window with specified parameters
function centeredWindow(url,winName,H,W,resizable,scrollbars,status) {
	var iMyWidth;
	var iMyHeight;
	if (!resizable) resizable = 'no';
	if (!scrollbars) scrollbars = 'no';
	if (!status) status = 'no';

	iMyWidth = (window.screen.width/2) - (W/2);
	iMyHeight = (window.screen.height/2) - (25 + H/2);
	var winout = window.open(url,winName,"height="+H+",width="+W+",resizable="+resizable+",left="+iMyWidth+",top="+iMyHeight+",screenX="+iMyWidth+",screenY="+iMyHeight+",scrollbars="+scrollbars+",status="+status);
	winout.focus();
}


//opens a new browser window, and returns the reference to it
function openBrowser(url,windowName,height,width,menubar,toolbar,resizable,scrollbars,status) {
	if (!menubar) menubar = 'no';
	if (!resizable) resizable = 'no';
	if (!scrollbars) scrollbars = 'no';
	if (!status) status = 'no';
	if (!toolbar) toolbar = 'no';
	theWindow = window.open(url, windowName, 'height='+height+',width='+width+',menubar='+menubar+',resizable='+resizable+',scrollbars='+scrollbars+',status='+status+',toolbar='+toolbar);
	return theWindow;
}
