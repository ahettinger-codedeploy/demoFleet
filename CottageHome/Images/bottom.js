/***
 * Javascript code to support http://www.cottagehome.com
 * Last updated: March 27, 2009
 * Coded by: Osama Zakaria
 * Contact Info:
 *      E-mail eng.osama.cs@gmail.com
 ***/



if(IE6){
    attachMenuEvents();
}
setBg(8, 10);
adjustHeights();



/*Start adjustHeights*/
function adjustHeights(){
	var leftContent = document.getElementById('left-content');
	var mainContent = document.getElementById('main-content');
	var rLeftContent = document.getElementById('r-left-content');
	
	if( !leftContent || !mainContent || !rLeftContent )
		return;
	
	var maxHeight = Math.max(leftContent.offsetHeight, mainContent.offsetHeight);
	
	rLeftContent.style.height = maxHeight + 'px';
	
	setTimeout('adjustHeights()', 0);
}
/*End adjustHeights*/



/*Start setBg*/
function setBg(availableImagesNum, maxImagesNum){
    var imageNum = -1;
    
    if( window.navigator.cookieEnabled ) {
        imageNum = getCookie("bodyBackground");
        if(imageNum == null)
            imageNum = -1;
    }
    
    if(imageNum == -1) {
        while( (imageNum = parseInt(Math.random() * maxImagesNum)) && imageNum > (availableImagesNum - 1) )
        {/* Empty while-body */}
        
        if( window.navigator.cookieEnabled )
            setCookie("bodyBackground", imageNum);
    }
    
    var isPopup = document.getElementById('popup-wrapper') ? true : false;
    
    document.body.style.backgroundImage = "url(" + ( isPopup ? "../" : "" ) + "images/background/" + imageNum + ".jpg)";
}
/*End setBg*/



/*Start setCookie*/
function setCookie( cookieName, value, expiredays) {

    var exdate = new Date();

    exdate.setDate( exdate.getDate() + expiredays );

    document.cookie = cookieName + "=" + escape(value)+ ((expiredays == null) ? "" : ";expires=" + exdate.toGMTString());

}
/*End getCookie*/



/*Start getCookie*/
function getCookie( cookieName ) {

    if ( document.cookie.length > 0 ) {

        

        var cookieStart = document.cookie.indexOf( cookieName + "=" );

        if ( cookieStart != -1 ) { 

            cookieStart = cookieStart + cookieName.length + 1; 

            

            var cookieEnd = document.cookie.indexOf( ";", cookieStart );

            if ( cookieEnd == -1 )

                cookieEnd = document.cookie.length;

            

            return unescape( document.cookie.substring(cookieStart, cookieEnd) );

        }

    }

    return null;

}        
/*End getCookie*/



/*Start attachMenuEvents*/
function attachMenuEvents(){
    var menu = document.getElementById('menu');
    
    if( !menu )
        return;
    
    var LIs = menu.getElementsByTagName('li');
    for(var i = 0; i < LIs.length; i++){
        LIs[i].onmouseover = function() {
                this.className = this.className.indexOf('hover') == -1 ? this.className.trim() + ' hover' : this.className;
            };
        LIs[i].onmouseout = function() {
                this.className = this.className.indexOf('hover') != -1 ? this.className.replace('hover', '').trim() : this.className;
            };
    }
}
/*End attachMenuEvents*/



/* Start Pre-Loading hover images */
var img1 = new Image();
img1.src = "css/images/decrease_hover.gif";
var img2 = new Image();
img2.src = "css/images/increase_hover.gif";
var img3 = new Image();
img3.src = "css/images/mobile_over.gif";
var img4 = new Image();
img4.src = "css/images/purchase_your_home_hover.gif";
var img5 = new Image();
img5.src = "css/images/contact_us_hover.gif";
var img6 = new Image();
img6.src = "css/images/green_built_hover.gif";
var img7 = new Image();
img7.src = "css/images/t_box_hover.jpg";
var img8 = new Image();
img8.src = "css/images/l_box_hover.jpg";
var img9 = new Image();
img9.src = "css/images/r_box_hover.jpg";
var img10 = new Image();
img10.src = "css/images/b_box_hover.jpg";
var img11 = new Image();
img11.src = "css/images/tl_box_hover.jpg";
var img12 = new Image();
img12.src = "css/images/tr_box_hover.jpg";
var img13 = new Image();
img13.src = "css/images/bl_box_hover.jpg";
var img14 = new Image();
img14.src = "css/images/br_box_hover.jpg";
var img15 = new Image();
img15.src = "css/images/t_box_hover2.jpg";
var img16 = new Image();
img16.src = "css/images/l_box_hover2.jpg";
var img17 = new Image();
img17.src = "css/images/r_box_hover2.jpg";
var img18 = new Image();
img18.src = "css/images/b_box_hover2.jpg";
var img19 = new Image();
img19.src = "css/images/tl_box_hover2.jpg";
var img20 = new Image();
img20.src = "css/images/tr_box_hover2.jpg";
var img21 = new Image();
img21.src = "css/images/bl_box_hover2.jpg";
var img22 = new Image();
img22.src = "css/images/br_box_hover2.jpg";
/* End Pre-Loading hover images */



_uacct = "UA-921792-4";

urchinTracker();