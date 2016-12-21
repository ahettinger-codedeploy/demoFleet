/***********

by Jeff Fohl for Godengo, Inc.
Updated: 08.21.2007
derived from Image Cross Fade Redux by steve@slayeroffice.com

DEPENDENCIES:

Make sure that the following functions are available - from either /core/media/js/prototype.js, or /core/media/js/base.js:

getElementsByClassName();
addLoadEvent();

***********/

// gallery object array //
var galleryObjects = new Array();

// gallery object constructor //
function Gallery(galleryContainer) {
	this.container = galleryContainer;
	this.id = null;
	this.current = 0;
	this.next = 1;
	this.cOpacity = 1;
	this.nOpacity = 0;
	this.previous = null;
	this.playState = true;
	this.slideIncrement = null;
	this.fadeIncrement = null;
	this.links = new Array();
	this.slides = new Array();
	this.extras = new Array();
	this.playButton = null;
	this.previousButton = null;
	this.nextButton = null;
}

// Gallery xFade function //
Gallery.prototype.xFade = function() {
	var thisGallery = this;
	this.cOpacity = this.slides[this.current].xOpacity;												
	this.nOpacity = this.slides[this.next].xOpacity;
	
	this.cOpacity-=.05;
	this.nOpacity+=.05;
	
	this.slides[this.next].style.display = "block";
	this.slides[this.current].xOpacity = this.cOpacity;
	this.slides[this.next].xOpacity = this.nOpacity;
	
	this.setOpacity(this.current);
	this.setOpacity(this.next);
	
	if(this.cOpacity<=0) {
		this.cOpacity = 0;
		this.nOpacity = 1;
		this.slides[this.current].style.display = "none";
		this.tabID = this.slides[this.current].getAttribute("id");
		if (this.extras.length) {
		this.extrasID = this.extras[this.current].getAttribute("id");
		}
		if (this.links.length) {
		for (var n=0; n < this.links.length; n++) {
			this.tabTitle = this.links[n].getAttribute("name");
			if (this.tabID == this.tabTitle) {
				this.clearTab(this.links[n]);
			}
			if (this.extrasID == ("extra"+this.tabTitle)) {
				this.hideExtras(this.links[n]);
			}
		}
		}
		this.current = this.next;
		this.previous = this.slides[this.current-1]?this.current-1:this.slides.length-1;
		this.next = this.slides[this.current+1]?this.current+1:0;
		this.tabID = this.slides[this.current].getAttribute("id");
		if (this.extras.length){
		this.extrasID = this.extras[this.current].getAttribute("id");
		}
		if (this.links.length) {
		for (var n=0; n < this.links.length; n++) {
			this.tabTitle = this.links[n].getAttribute("name");
			if (this.tabID == this.tabTitle) {
				this.showTab(this.links[n]);
				this.nextTab = this.links[n+1];
			}
			if (this.extrasID == ("extra"+this.tabTitle)) {
				this.showExtras(this.links[n]);
			}
		}
		}
		this.slideIncrement = window.setTimeout( function(){ thisGallery.xFade() }, 5000);														
	} else {
		this.slideIncrement = window.setTimeout( function(){ thisGallery.xFade() }, 50);	
	}
}

// clears menutitems //
Gallery.prototype.clearTab = function (tab) {
	tab.className = "unselected";
	tab.parentNode.className = "unselected";
}

// shows current menuitem //
Gallery.prototype.showTab = function (tab) {
	tab.className = "selected";
	tab.parentNode.className = "selected";
}

// shows current content //
Gallery.prototype.showExtras = function (extra) {
	var currentTab = extra.getAttribute("name");
	var hiddenExtra = document.getElementById("extra"+currentTab);
	hiddenExtra.style.display = "block";
}

// hides other content //
Gallery.prototype.hideExtras = function (extra) {
	var currentTab = extra.getAttribute("name");
	var hiddenExtra = document.getElementById("extra"+currentTab);
	hiddenExtra.style.display = "none";
}

// clears timeouts from window object //
Gallery.prototype.clearFade = function () {
	if (this.slideIncrement) {
		var thisSlideIncrement = this.slideIncrement;
		window.clearTimeout(thisSlideIncrement);	
	}
	if (this.fadeIncrement) {
		var thisFadeIncrement = this.fadeIncrement;
		window.clearTimeout(thisfadeIncrement);
	}
}

// shows content when a menu item, previous, or next buttons are clicked //
Gallery.prototype.showContent = function(id) {
	this.clearFade();
	this.playState = false;
	if (this.controls.length){
	this.playButton.innerHTML = "Play";
	}
	for (var i=0;i<this.slides.length;i++){
		this.slides[i].style.display = "none";
		this.slides[i].style.opacity = 0;
		this.slides[i].style.MozOpacity = 0;
		this.slides[i].style.filter = "alpha(opacity=0)";
		if (this.extras.length) {
		this.extras[i].style.display = "none";	
		}
		if (this.links.length) {
		this.links[i].className = "unselected";
		this.links[i].parentNode.className = "unselected";
		}
		this.slides[i].xOpacity = 0;
	}
		this.slides[id].style.display = "block";	
		this.slides[id].style.opacity = 1;
		this.slides[id].style.MozOpacity = 1;
		this.slides[id].style.filter = "alpha(opacity=100)";
		if (this.extras.length) {
		this.extras[id].style.display = "block";
		}
		if (this.links.length) {
		this.links[id].className = "selected";
		this.links[id].parentNode.className = "selected";
		}
		this.current = id;
		this.previous = this.slides[this.current-1]?this.current-1:this.slides.length-1;
		this.next = this.slides[this.current+1]?this.current+1:0;
		this.slides[id].xOpacity = 1;
}

// counter to determine what the id of each menuitem is //
Gallery.prototype.linkItem = function(obj) {
	for (var i=0;i<this.links.length;i++){
		if (obj === this.links[i]) {
		return i;
		}
	}
}

// onclick function to go to previous slide //
Gallery.prototype.previousSlide = function () {
	this.showContent(this.previous);
}

// onclick function to go to next slide //
Gallery.prototype.nextSlide = function () {
	this.showContent(this.next);
}

// onclick function for play or pause //
Gallery.prototype.play = function () {
	if (this.playState == false) {
		this.playButton.innerHTML = "Pause";
		this.playState = true;
		this.xFade();
	}
	else {
			this.clearFade();
			this.playState = false;
			this.playButton.innerHTML = "Play";
	}
}

// set the opacity of slides //
Gallery.prototype.setOpacity = function (id) {
		if (this.slides[id].xOpacity > .99) {
			this.slides[id].xOpacity = 1;
			return;
		}
		this.slides[id].style.opacity = this.slides[id].xOpacity;
		this.slides[id].style.MozOpacity = this.slides[id].xOpacity;
		this.slides[id].style.filter = "alpha(opacity=" + (this.slides[id].xOpacity*100) + ")";
}


// initialize new gallery //
Gallery.prototype.initialize = function() {
	var thisGallery = this;
	this.slides = getElementsByClassName(this.container, "div", "photo");
	for(var i=0;i<this.slides.length;i++){
		this.slides[i].xOpacity = 0;
		}
	this.extras = getElementsByClassName(this.container, "div", "content");
	if (this.extras.length){
	for(var i=0;i<this.extras.length;i++){
		this.extras[i].visible = false;
		}
	}
	this.menu = getElementsByClassName(this.container, "*", "photoFaderMenu");	
	if (this.menu.length){
	this.links = this.menu[0].getElementsByTagName("a");
	for(var i=0;i<this.links.length;i++){
		this.links[i].on = false;
		}
	}
	this.controls = getElementsByClassName(this.container, "div", "controls");
	if (this.controls.length){
	this.previous = this.slides.length;
	this.buttons = this.controls[0].getElementsByTagName("a");
	this.previousButton = this.buttons[0];
	this.playButton = this.buttons[1];
	this.nextButton = this.buttons[2];
	this.playButton.onclick = function () {
			thisGallery.play();
			return false;
		}
	this.previousButton.onclick = function () {
			thisGallery.previousSlide();
			return false;
		}
	this.nextButton.onclick = function () {
			thisGallery.nextSlide();
			return false;
		}
	}
	for (var m=0; m < this.links.length; m++) {
		this.links[m].onclick = function() {
			thisGallery.showContent(thisGallery.linkItem(this));
			return false;
		}
	}
	this.showContent(0);
	this.playState = true;
	if (this.controls.length) {
	this.playButton.innerHTML = "Pause";
	}
	this.slides[this.current].xOpacity = 1;
	this.slideIncrement = window.setTimeout( function(){ thisGallery.xFade() }, 5000);	
}

// get galleries //
function getGalleries() {
	galleries = getElementsByClassName(document, "div", "photoFader-gallery");
	for (var i=0;i<galleries.length;i++){
		galleryObjects[i] = new Gallery(galleries[i]);
		galleryObjects[i].id = i;
		galleryObjects[i].initialize();
		}
}

// add this to the onload queue //
addLoadEvent(getGalleries);