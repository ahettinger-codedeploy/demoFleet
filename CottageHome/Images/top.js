/***
 * Javascript code to support http://www.cottagehome.com
 * Last updated: March 27, 2009
 * Coded by: Osama Zakaria
 * Contact Info:
 *      E-mail eng.osama.cs@gmail.com
 ***/



var IE = /*@cc_on!@*/false;
var IE6 = false /*@cc_on || @_jscript_version < 5.7 @*/;
var IE7 = false /*@cc_on || @_jscript_version >= 5.7 @*/;

window.onload = onLoad;


String.prototype.trim = function() {
    a = this.replace(/^\s+/, '');
    return a.replace(/\s+$/, '');
};


/*Start onLoad*/
function onLoad(){
	initPopup();
}
/*End onLoad*/


/*Start initPopup*/
function initPopup(){
	var wrapper = document.getElementById('popup-wrapper');
	
	if( !wrapper )
		return;
	
	var width = wrapper.offsetWidth + 90;
	var height = wrapper.offsetHeight + 80;
	
	resizeTo(width, height);
	
	//Center screen
	var left = Math.abs(screen.width - width) / 2;
	var top = Math.abs(screen.height - height) / 2;
	
	moveTo(left,0);
}
/*End initPopup*/


/*Start popup*/
function popup(mylink, windowname){
	var href;
	
	if (typeof(mylink) == 'string')
		href=mylink;
	else
		href=mylink.href;
    
	window.open(href, windowname, 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=yes, width=1, height=1, top=0, left=0');
	
	return false;
}
/*End popup*/


/*Start setFontSize*/
function setFontSize(multiplier){
	var max = 13;
	var min = 7;
	var d = 1;
	
	//Set default font size
	if (document.body.style.fontSize == "")  
		document.body.style.fontSize = "10px";  
	
	var currentFontSize = document.body.style.fontSize;
 	var currentFontSizeNum = parseFloat(currentFontSize);
	var newFontSize = currentFontSizeNum + (multiplier * d);
	
	if(newFontSize <= max && newFontSize >= min)	
		document.body.style.fontSize = newFontSize + "px";  
}
/*End setFontSize*/


/*Start show*/
function show(elementId){
    var element = document.getElementById(elementId);
	if( !element )
	    return;
	element.style.display = 'block';
	element.style.visibility = 'visible';
}
/*End show*/


/*Start hide*/
function hide(elementId){
    var element = document.getElementById(elementId);
	if( !element )
	    return;
	element.style.display = 'none';
	element.style.visibility = 'hidden';
}
/*End hide*/


/*Start boxHover*/
function boxHover(sender, state){
    var divs = sender ? sender.getElementsByTagName('DIV') : null;
	
	if( !divs )
	    return;
    
	for(var i = 0; i < divs.length; i++){
		divs[i].className = divs[i].className.replace('-hover', '');
		divs[i].className = divs[i].className + (state == 'on' ? '-hover' : '');
	}
	
	var a = sender.getElementsByTagName('a');
	if(a.length > 0)
		a[0].className = state == 'on' ? 'a-hover' : '';
}
/*End boxHover*/


/*Start showGallery*/
function showGallery(elementId){
	var gallery = document.getElementById('gallery');
	
	if( !gallery )
	    return;
	
	var images = gallery.getElementsByTagName('img');
	
	for(var i = 0; i < images.length; i++){
		if(elementId == images[i].id)
			show(images[i].id);
		else
			hide(images[i].id);
	}
}
/*End showGallery*/


/*Start submitForm*/
function submitForm(elementId){
	element = document.getElementById(elementId);
	
	if( !element )
	    return;
	
	if(element.nodeName == 'FORM')
		element.submit();
	else if(element.nodeName == 'INPUT' && (element.type == 'submit' || element.type == 'image'))
		element.click();
}
/*End submitForm*/


/* Start setFakeFile */
function setFakeFile(sender, fakefileId) {
    document.getElementById(fakefileId).value = sender.value;
}
/* End setFakeFile */


/* Start isValidImgExtension */
function isValidImgExtension(file){
	var fileName = typeof file == "string" ? file.toLowerCase() : file.value.toLowerCase();
	
	if(fileName.lastIndexOf('.jpeg') == -1 && fileName.lastIndexOf('.jpg') == -1 &&
			fileName.lastIndexOf('.gif') == -1 && fileName.lastIndexOf('.png') == -1){
		alert('Invalid image extension.\r\nValid extensions: jpeg, jpg, gif, png');
		return false;
	} else {
		return true;
	}
}
/* End isValidImgExtension */


