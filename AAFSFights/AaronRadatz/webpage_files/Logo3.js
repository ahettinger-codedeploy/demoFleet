function logoElementLogo3()
{


	if (navigator.userAgent.indexOf("Mozilla/3") != -1)
	{
		var msg = 'Sorry, since you are using an old version of Netscape, you may not be able to access all the pages in this Web site.';
		document.write(msg);
	}
	else
	{

		var strHTML = '';

				strHTML += '<a  href="' + strRelativePathToRoot + 'index.html"';
				strHTML += ' target="" >';
				strHTML += '	<img src="' + strRelativePathToRoot + 'bg-header.jpg"';
				strHTML += ' alt=""';
				strHTML += ' border="0"';
				strHTML += ' width="1000"';
				strHTML += ' height="200" >';
				strHTML += '</a>';


		document.write(strHTML);
	}
}


function netscapeDivCheckLogo3()
{




	var strAppName = navigator.appName;
	var appVer = parseFloat(navigator.appVersion);

	if ( (strAppName == "Netscape") &&
		(appVer >= 4.0 && appVer < 5) ) {
		document.write("</DIV>");
	}
}



logoElementLogo3();


netscapeDivCheckLogo3();

