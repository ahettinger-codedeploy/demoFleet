function getWindowSize() {
if( typeof( window.innerWidth ) == 'number' ) {
		//Non-IE
		windowWidth = window.innerWidth;
		windowHeight = window.innerHeight;
		} 
		else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
			//IE 6+ in 'standards compliant mode'
			windowWidth = document.documentElement.clientWidth;
			windowHeight = document.documentElement.clientHeight;
			} else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
				//IE 4 compatible
				windowWidth = document.body.clientWidth;
				windowHeight = document.body.clientHeight;
			}
		//window.alert( 'Width = ' + myWidth );
		//window.alert( 'Height = ' + myHeight);
}

function setHomepage() {
	windowHeight = 0; 
	windowWidth = 0;
	if (document.getElementById) {
		getWindowSize();
		if (windowHeight > 0 && windowWidth > 0) {
			var contentElement = document.getElementById('homepage');
				contentElement.style.width = (windowWidth) + 'px';
				contentElement.style.height = (windowHeight - 111) + 'px';
		}
	}
}

function setContent() {
	windowHeight = 0; 
	windowWidth = 0;
	if (document.getElementById) {
		getWindowSize();
		if (windowHeight > 0 && windowWidth > 0) {
			var contentElement = document.getElementById('content');
				contentElement.style.width = (windowWidth - 134) + 'px';
				contentElement.style.height = (windowHeight - 111) + 'px';
		}
	}
}

function setContentTesting() {
	windowHeight = 0; 
	windowWidth = 0;
	//alert(windowHeight +' '+windowWidth);
	if (document.getElementById) {
		getWindowSize();
		if (windowHeight > 0 && windowWidth > 0) {
			var contentElement = document.getElementById('content');
				windowWidth = windowWidth - 134;
				windowHeight = windowHeight - 111;
				//alert(windowHeight +' '+windowWidth);
				contentElement.style.width = (windowWidth) + 'px';
				contentElement.style.height = (windowHeight) + 'px';
				//alert(contentElement.style.width +' '+windowWidth);
		}
	}
}


function setContentSmall() {
	windowHeight = 0; 
	windowWidth = 0;
	if (document.getElementById) {
		getWindowSize();
		if (windowHeight > 0 && windowWidth > 0) {
			var contentElementSmall = document.getElementById('content_small');
				contentElementSmall.style.width = (windowWidth - 134) + 'px';
				contentElementSmall.style.height = (windowHeight - 81) + 'px';
		}
	}
}

// Fix right col bg in FF
function startPolling() { setInterval("poll()",500) }
function poll() {
	if (navigator.userAgent.match('Firefox')) {
		if (document.getElementById('content').scrollTop > 0) {
		document.getElementById('content').style.backgroundImage = 'url(../images/sidebar_bg_scroll.gif)';
		}
	}
return true;
}