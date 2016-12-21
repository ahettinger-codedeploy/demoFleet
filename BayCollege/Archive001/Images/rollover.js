
function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
var BrowserDetect = {
	init: function () {
		this.browser = this.searchString(this.dataBrowser) || "An unknown browser";
		this.version = this.searchVersion(navigator.userAgent)
			|| this.searchVersion(navigator.appVersion)
			|| "an unknown version";
		this.OS = this.searchString(this.dataOS) || "an unknown OS";
	},
	searchString: function (data) {
		for (var i=0;i<data.length;i++)	{
			var dataString = data[i].string;
			var dataProp = data[i].prop;
			this.versionSearchString = data[i].versionSearch || data[i].identity;
			if (dataString) {
				if (dataString.indexOf(data[i].subString) != -1)
					return data[i].identity;
			}
			else if (dataProp)
				return data[i].identity;
		}
	},
	searchVersion: function (dataString) {
		var index = dataString.indexOf(this.versionSearchString);
		if (index == -1) return;
		return parseFloat(dataString.substring(index+this.versionSearchString.length+1));
	},
	dataBrowser: [
		{ 	string: navigator.userAgent,
			subString: "OmniWeb",
			versionSearch: "OmniWeb/",
			identity: "OmniWeb"
		},
		{
			string: navigator.vendor,
			subString: "Apple",
			identity: "Safari"
		},
		{
			prop: window.opera,
			identity: "Opera"
		},
		{
			string: navigator.vendor,
			subString: "iCab",
			identity: "iCab"
		},
		{
			string: navigator.vendor,
			subString: "KDE",
			identity: "Konqueror"
		},
		{
			string: navigator.userAgent,
			subString: "Firefox",
			identity: "Firefox"
		},
		{
			string: navigator.vendor,
			subString: "Camino",
			identity: "Camino"
		},
		{		// for newer Netscapes (6+)
			string: navigator.userAgent,
			subString: "Netscape",
			identity: "Netscape"
		},
		{
			string: navigator.userAgent,
			subString: "MSIE",
			identity: "Explorer",
			versionSearch: "MSIE"
		},
		{
			string: navigator.userAgent,
			subString: "Gecko",
			identity: "Mozilla",
			versionSearch: "rv"
		},
		{ 		// for older Netscapes (4-)
			string: navigator.userAgent,
			subString: "Mozilla",
			identity: "Netscape",
			versionSearch: "Mozilla"
		}
	],
	dataOS : [
		{
			string: navigator.platform,
			subString: "Win",
			identity: "Windows"
		},
		{
			string: navigator.platform,
			subString: "Mac",
			identity: "Mac"
		},
		{
			string: navigator.platform,
			subString: "Linux",
			identity: "Linux"
		}
	]

};
BrowserDetect.init();
if (BrowserDetect.browser == "Explorer"){
	//reminder for the dimensions first= second=start from top of menu (third)= (fourth)=length of menu
        var myMenu1 = new ypSlideOutMenu("menu1", "down", 265, 130, 200, 550)
		var myMenu2 = new ypSlideOutMenu("menu2", "down", 416, 130, 200, 550)
		var myMenu3 = new ypSlideOutMenu("menu3", "down", 565, 130, 200, 550)
		var myMenu31 = new ypSlideOutMenu("menu31", "down", 567, 130, 200, 550)
		var myMenu4 = new ypSlideOutMenu("menu4", "down", 565, 130, 200, 550)
		var myMenu5 = new ypSlideOutMenu("menu5", "down", 714, 130, 200, 550)
		var myMenu6 = new ypSlideOutMenu("menu6", "down", 714, 130, 200, 550)
		var myMenu7 = new ypSlideOutMenu("menu7", "down", 714, 130, 200, 550)
		
    // for each menu, we set up the onactivate event to call repositionMenu with the amount offset from center, in pixels
        myMenu1.onactivate = function() { repositionMenu(myMenu1, -399); }
		myMenu2.onactivate = function() { repositionMenu(myMenu2, -313); }
		myMenu3.onactivate = function() { repositionMenu(myMenu3, -230); }
        myMenu4.onactivate = function() { repositionMenu(myMenu4, -123); }
		myMenu5.onactivate = function() { repositionMenu(myMenu5, -13); }
		myMenu6.onactivate = function() { repositionMenu(myMenu6, 85); }
		myMenu7.onactivate = function() { repositionMenu(myMenu7, 180); }
}else{
	    	//reminder for the dimensions first= second=start from top of menu (third)= (fourth)=length of menu
        var myMenu1 = new ypSlideOutMenu("menu1", "down", 65, 130, 200, 550)
		var myMenu2 = new ypSlideOutMenu("menu2", "down", 416, 130, 200, 550)
		var myMenu3 = new ypSlideOutMenu("menu3", "down", 565, 130, 200, 550)
		var myMenu4 = new ypSlideOutMenu("menu4", "down", 565, 130, 200, 550)
		var myMenu5 = new ypSlideOutMenu("menu5", "down", 714, 130, 200, 550)
		var myMenu6 = new ypSlideOutMenu("menu6", "down", 714, 130, 200, 550)
		var myMenu7 = new ypSlideOutMenu("menu7", "down", 714, 130, 200, 550)
		
    // for each menu, we set up the onactivate event to call repositionMenu with the amount offset from center, in pixels
        myMenu1.onactivate = function() { repositionMenu(myMenu1, -390); }
		myMenu2.onactivate = function() { repositionMenu(myMenu2, -304); }
		myMenu3.onactivate = function() { repositionMenu(myMenu3, -221); }
        myMenu4.onactivate = function() { repositionMenu(myMenu4, -114); }
		myMenu5.onactivate = function() { repositionMenu(myMenu5, -4); }
		myMenu6.onactivate = function() { repositionMenu(myMenu6, 94); }
		myMenu7.onactivate = function() { repositionMenu(myMenu7, 189); }
}

    // this function repositions a menu to the speicified offset from center
        function repositionMenu(menu, offset)
        {
      // the new left position should be the center of the window + the offset
            var newLeft = getWindowWidth() / 2 + offset;

      // setting the left position in netscape is a little different than IE
            menu.container.style ? menu.container.style.left = newLeft + "px" : menu.container.left = newLeft;
        }
         
    // this function calculates the window's width - different for IE and netscape
        function getWindowWidth()
        {
            return window.innerWidth ? window.innerWidth : document.body.offsetWidth;
        }  
