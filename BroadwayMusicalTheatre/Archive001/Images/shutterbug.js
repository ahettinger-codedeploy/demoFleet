/*
 Copyright 2006 XtraLean Software, Jan 30, 2008
 Fixed no preload when captions are off
 ShutterBug helper functions
 */

var browserFade = "Undefined";
var globalCanFade = true;
var isSafari = false;

var attrArray = null;

function _addAttr(attrName)
{
	value = attrArray[attrName];
	if (value == null)
		return "";
	return attrName + '="' + value + '" ';
}

function _addParam(attrName)
{
	value = attrArray[attrName];
	if (value == null)
		return "";
	return '  <param name="' + attrName + '" value="' + value + '"' + ' />\n';
}

function insertQuicktime()
{
	attrArray = new Array();
	attrArray["src"] = arguments[1];
	attrArray["width"] = arguments[2];
	attrArray["height"] = arguments[3];
	attrArray["autoplay"] = arguments[4];
	attrArray["controller"] = arguments[5];
	attrArray["loop"] = arguments[6];
	if (arguments[7] == 'true')
		attrArray["hidden"] = arguments[7];
	
	// fixed attributs
	attrArray["classid"] = "clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B";
	attrArray["pluginspage"] = "http://www.apple.com/quicktime/download/";
	attrArray["codebase"] = "http://www.apple.com/qtactivex/qtplugin.cab";
	attrArray["type"] = "video/quicktime";
	
	var insertString = '<object '
		+ _addAttr("classid")
		+ _addAttr("codebase")
		+ _addAttr("height")
		+ _addAttr("width")
		+ '>\n'
		+ _addParam("src")
		+ _addParam("autoplay")
		+ _addParam("controller")
		+ _addParam("loop")
		+ _addParam("hidden")
		+ ' <embed '
		+ _addAttr("src")
		+ _addAttr("height")
		+ _addAttr("width")
		+ _addAttr("type")
		+ _addAttr("pluginspage")
		+ _addAttr("autoplay")
		+ _addAttr("controller")
		+ _addAttr("loop")
		+ _addAttr("hidden")
		+ '> </embed>\n</object>\n';

	var divelement = document.getElementById(arguments[0]);
	divelement.innerHTML = insertString;
}

function insertFlash() 
{
	attrArray = new Array();
	attrArray["src"] = arguments[1];
	attrArray["movie"] = arguments[1];
	attrArray["width"] = arguments[2];
	attrArray["height"] = arguments[3];
	attrArray["loop"] = arguments[4];
	attrArray["scale"] = arguments[5];
	attrArray["bgcolor"] = arguments[6];
	
	attrArray["play"] = "true";
	attrArray["menu"] = "false";
	attrArray["quality"] = "best";
	
	attrArray["classid"] = "clsid:D27CDB6E-AE6D-11cf-96B8-444553540000";
	attrArray["pluginspage"] = "http://www.macromedia.com/go/getflashplayer";
	attrArray["codebase"] = "http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0";
	attrArray["type"] = "application/x-shockwave-flash";
	
	var insertString = '<object '
		+ _addAttr("classid")
		+ _addAttr("codebase")
		+ _addAttr("height")
		+ _addAttr("width")
		+ '>\n'
		+ _addParam("movie")
		+ _addParam("play")
		+ _addParam("loop")
		+ _addParam("menu")
		+ _addParam("quality")
		+ _addParam("scale")
		+ _addParam("bgcolor")
		+ ' <embed '
		+ _addAttr("src")
		+ _addAttr("height")
		+ _addAttr("width")
		+ _addAttr("type")
		+ _addAttr("pluginspage")
		+ _addAttr("play")
		+ _addAttr("loop")
		+ _addAttr("menu")
		+ _addAttr("quality")
		+ _addAttr("scale")
		+ _addAttr("bgcolor")
		+ '> </embed>\n</object>\n';
	
	var divelement = document.getElementById(arguments[0]);
	divelement.innerHTML = insertString;
}



function clickLink (address) {
	var max = address.length;
	var i;
	var clickTo = '';
	var c = 0;
	for (i=0; i<max; i++) {
		c = 0;
		while (i<max && address.charCodeAt(i) != 97) {
			c = c*25;
			c = c + address.charCodeAt(i)-98;
			i++;
		}
		clickTo += String.fromCharCode(c);
	}
	parent.location = clickTo;
}

function rollOver (ident, normal, over) {
	this.ident = ident;
	this.normalImage = new Image();
	this.normalImage.src = normal;
	this.overImage = new Image();
	this.overImage.src = over;
	
	this.mouseOver = function () {
		var image = document.getElementById(this.ident);
		if (image) {
			image.src = this.overImage.src;
		}
	}
	
	this.mouseOut = function () {
		var image = document.getElementById(this.ident);
		if (image) {
			image.src = this.normalImage.src;
		}
	}
}


function setOpacity(opacity, id) {
	if (browserFade == "Undefined") {
		if (typeof id.style.opacity != 'undefined')
			browserFade = 'opacity';
		else if (typeof id.style.MozOpacity != 'undefined')
			browserFade = 'MozOpacity';
		else if (typeof id.style.KhtmlOpacity != 'undefined')
			browserFade = 'KhtmlOpacity';
		else if (typeof id.filters == 'object')
			browserFade = 'filters';
		else {
			browserFade = 'none';
			globalCanFade = false;
		}
		
	}
	var object = id.style;
	if (globalCanFade) {
		object.display = "";
		switch(browserFade) {
			case 'opacity':
				object.opacity = (opacity/100);
				break;
			case 'MozOpacity':
				object.MozOpacity = (opacity/100);
				break;
			case 'KhtmlOpacity':
				object:KhtmlOpacity = (opacity/100);
				break;
			case 'filters':
				object.filter = "alpha(opacity=" + opacity + ")";
				break;
			}
	} else {
		if (opacity <= 99)
			object.display = "none";
		else {
			object.display = "";
			if (isSafari)
				object.opacity = 100;
		}
	}
}

function crossFade(fade, imageA, imageB)
{
	var imageAfade = fade;
	var imageBfade = 100-fade;
	if (imageAfade == 100)
		imageAfade = 99.9;
	if (imageBfade == 100)
		imageBfade = 99.9;
	setOpacity(imageAfade, imageA);
	setOpacity(imageBfade, imageB);
}

function fadeIn(fade, imageA)
{
	if (fade == 100)
		fade = 99.9;
	setOpacity(fade, imageA);
}

function slide(number,disable,top,left,width,height) {
	if (parseInt(disable) == 1) {
		this.src = 'pictures/image' + number + '.jpg';
	} else {
		this.src = 'pictures/slide' + number + '.jpg';
	}
	this.textid = 'stext' + number;
	this.top = top + 'px';
	this.left = left + 'px';
	this.width = width + 'px';
	this.height = height + 'px';
}

function slideshow( slideshowname ) {
	this.name = slideshowname;
	this.repeat = true;
	this.prefetch = 2;
	this.image;
	this.timeout = 3000;
	this.slides = new Array();
	this.current = 0;
	this.lastslide = -1;
	this.firstslide = 0;
	this.fade = 0;
	this.fadeprogress = 0;
	this.fadetimeoutid = 0;
	this.imageIn = 0;
	this.imageOut = 0;
	this.playLabel = 'Play';
	this.stopLabel = 'Stop';
	this.playControl = 0;
	this.autoPlay = 0;
	this.prevControl = 0;
	this.nextControl = 0;
	this.loading = 0;
	this.viewerA = 0;
	this.viewerB = 0;
	this.currentViewer = 0;
	
	this.timeoutid = 0;
	this.add_slide = function(number,disable,top,left,width,height) {
		var i = this.slides.length;
		this.slides[i] = new slide (number,disable,top,left,width,height);
	}

	this.setStopLabel = function() {
		this.playControl.innerHTML = this.stopLabel;
	}
	
	this.setPlayLabel = function() {
		this.playControl.innerHTML = this.playLabel;
	}
	
	this.play = function() {
		this.autoPlay = 1;
		if (this.timeoutid != 0) 
			clearTimeout(this.timeoutid);
		this.playnextslide();

		if (this.playControl) {
			this.playControl.href = "javascript:"+this.name+".stop()";
			setTimeout(this.name + ".setStopLabel()", 25);
		}
	}
	
	this.stop = function() {
		this.autoPlay = 0;
		if (this.timeoutid != 0) {
			clearTimeout(this.timeoutid);
			this.timeoutid = 0;
		}
		if (this.playControl) {
			this.playControl.href = "javascript:"+this.name+".play()";
			setTimeout(this.name + ".setPlayLabel()", 25);
		}
	}
	
	this.crossFade = function() {
		crossFade(this.fadeprogress, this.imageIn, this.imageOut);
		if (this.fadeprogress < 100) {
			this.fadetimeoutid = setTimeout(this.name +".crossFade()", 50);
		}
		this.fadeprogress += 5;
	}
	
	this.fadeIn = function() {
		fadeIn(this.fadeprogress, this.imageIn);
		if (this.fadeprogress < 100) {
			this.fadetimeoutid = setTimeout(this.name +".fadeIn()", 50);
		}
			
		this.fadeprogress += 5;
	}
	
	this.update = function() {
		var slide = this.slides[ this.current ];
		
		// the image loader
		imgPreloader = new Image();		
		// once image is preloaded, display the image
		imgPreloader.onload = function() {
			ss.showslide();
		}
		imgPreloader.src = slide.src;
	}
	
	this.playnextslide = function() {
	
		// get the next slide to be played
		if (this.current < this.slides.length - 1) {
			this.lastslide = this.current;
			this.current++;
		} else if (this.repeat) {
			this.lastslide = this.current;
			this.current = this.firstslide;
		} else {
			this.stop();
			return;
		}
		
		// set two conditions false
		this.timeelapsed = 0;
		this.imageready = 0;
		
		// preload slide
		imgPreloader = new Image();
		imgPreloader.onload = function () {
			ss.imageready = 1;
			if (ss.timeelapsed == 1)
				ss.showslide();
		}
		var slide = this.slides[ this.current ];
		imgPreloader.src = slide.src;
		
		this.timeoutid = setTimeout( this.name + ".timefornextslide()", this.timeout);
	}
	
	this.timefornextslide = function() {
		this.timeelapsed = 1;
		if (this.imageready == 1)
			this.showslide();
	}
		
	this.showslide = function () {
	
		if (this.fadetimeoutid != 0) {
			clearTimeout(this.fadetimeoutid);
			this.fadetimeoutid = 0;
			this.fadeprogress = 100;
		}
		var slide = this.slides[ this.current ];
		
		if (this.lastslide != -1) {
		
			if (this.currentViewer == 0) {
				this.imageOut = this.viewerA;
				this.imageIn = this.viewerB;
				this.currentViewer = 1;
			} else {
				this.imageOut = this.viewerB;
				this.imageIn = this.viewerA;
				this.currentViewer = 0;
			}
			
			fadeIn(100, this.imageOut);
			fadeIn(0, this.imageIn);
			
			this.imageOut.style.zIndex = 1;
			this.imageIn.style.zIndex = 2;
			this.imageIn.style.top = slide.top;
			this.imageIn.style.left = slide.left;
			this.imageIn.style.width = slide.width;
			this.imageIn.style.height = slide.height;
			this.imageIn.src = "";
			
			if (this.fade == 0 || globalCanFade == false) {
				crossFade(100, this.imageIn, this.imageOut);
				this.imageIn.src = slide.src;
			} else {
				this.fadeprogress = 0;
				this.imageIn.onload = function () {
					ss.crossFade();
				}
				this.imageIn.src = slide.src;
			}
			caption = document.getElementById(this.slides[this.lastslide].textid);
			if (caption) {
				caption.style.display = "none";
			}
		} else {
			this.imageOut = this.viewerA;
			this.imageIn = this.viewerB;
			this.currentViewer = 1;
			fadeIn(0, this.imageOut);
			fadeIn(0, this.imageIn);
			this.imageIn.style.top = slide.top;
			this.imageIn.style.left = slide.left;
			this.imageIn.style.width = slide.width;
			this.imageIn.style.height = slide.height;
			this.imageIn.src = "";
			this.imageIn.src = slide.src;

			if (this.fade == 0 || globalCanFade == false) {
				fadeIn(100, this.imageIn);
			} else {
				this.fadeprogress = 0;
				this.fadeIn();
			}
		}
		
		caption = document.getElementById(slide.textid);
		if (caption) {
			caption.style.display = "";
		}
		
		if (this.prefetch > 0 && this.autoPlay == 0) {
			var next, prev, count;
			next = this.current;
			prev = this.current;
			count = 0;
			do {
				if (++next >= this.slides.length) next = this.firstslide;
				if (--prev < 0) prev = this.slides.length - 1;
				
				imgPreloader = new Image();
				imgPreloader.src = this.slides[next].src;
				imgPreloader = new Image();
				imgPreloader.src = this.slides[prev].src;
				
			} while (++count < this.prefetch);
		}
		
		if (this.repeat == false) {
			if (this.prevControl != 0) {
				if (this.current == this.firstslide) {
					this.prevControl.style.display = "none";
				} else {
					this.prevControl.style.display = "";
				}
			}
			if (this.nextControl != 0) {
				if (this.current == this.slides.length - 1) {
					this.nextControl.style.display = "none";
				} else {
					this.nextControl.style.display = "";
				}
			}
		}
		
		if (this.autoPlay == 1)
			this.playnextslide();
	}
	
	this.init = function() {
		if (window.clientInformation) {
			if (window.clientInformation.appName.indexOf("croso") > 0)
				if (window.clientInformation.platform.indexOf("PPC") > 0) {
					globalCanFade = false;
				}
		}
		if (navigator.vendor) {
			if (navigator.vendor.indexOf("Apple") >= 0) {
				var jk = navigator.appVersion.indexOf("Safari/");
				if (jk != -1) {
					var version = parseInt(navigator.appVersion.substr(jk+7,3));
					if (version < 312)
						globalCanFade = false;
				}
				isSafari = true;
			}
		}
		this.playControl = document.getElementById('ssplay');
		this.prevControl = document.getElementById('ssprev');
		this.nextControl = document.getElementById('ssnext');	
		this.loading = document.getElementById('ssloading');
		this.viewerA = document.getElementById('ssviewerA');
		this.viewerB = document.getElementById('ssviewerB');
		
		var string1 = location.hash;
		var snum = string1.substring(1,string1.length);
		if (snum) {
			this.current = parseInt(snum);
			if (this.current < this.firstslide)
				this.current = this.firstslide;
		} else {
			this.current = this.firstslide;
		}
		
		if (this.playControl && this.autoPlay==1) {
			this.playControl.href = "javascript:"+this.name+".stop()";
			setTimeout(this.name + ".setStopLabel()", 25);
		}
		
		setTimeout(this.name+".update()", 250);
	}
	
	
	this.goto_slide = function(n) {
		if (this.current != n) {
			if (n == -1) {
				n = this.slides.length - 1;
			}
			if (n < this.firstslide)
				n = this.firstslide;
			
			if (n < this.slides.length && n >= this.firstslide) {
				this.lastslide = this.current;
				this.current = n;
			}
			this.stop();
			this.update();
		}
	}
	
	this.next = function() {
		lastcurrent = this.current;
		if (this.current < this.slides.length - 1) {
			this.lastslide = this.current;
			this.current++;
		} else if (this.repeat) {
			this.lastslide = this.current;
			this.current = this.firstslide;
		}
		if (lastcurrent == this.current)
			return;
		this.stop();
		this.update();
	}
	
	this.previous = function() {
		lastcurrent = this.current;
		if (this.current > this.firstslide) {
			this.lastslide = this.current;
			this.current--;
		} else if (this.repeat) {
			this.lastslide = this.current;
			this.current = this.slides.length - 1;
		}
		if (lastcurrent == this.current)
			return;
		this.stop();
		this.update();
	}
}


