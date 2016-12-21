/*************************************************************************
  This code is from Dynamic Web Coding at www.dyn-web.com
  Copyright 2003-4 by Sharon Paine 
  See Terms of Use at www.dyn-web.com/bus/terms.html
  regarding conditions under which you may use this code.
  This notice must be retained in the code as is!
*************************************************************************/
// alert('glide');
/*
  dw_glide.js - requires dw_lib.js
  version date July 2004 
*/

// acc is number between -1 and 1 ( -1 full decelerated, 1 full accelerated, 0 linear, i.e. no acceleration)
dynObj.prototype.slideTo = function (destX,destY,slideDur,acc,endFn) {
  if (!document.getElementById) return;
  this.slideDur = slideDur || .0001; var acc = -acc || 0;
  if (endFn) this.onSlideEnd = endFn;
  // hold destination values (check for movement on 1 axis only)
 	if (destX == null) this.destX = this.x;	else this.destX = destX;
  if (destY == null) this.destY = this.y; else this.destY = destY;
  this.startX = this.x; this.startY = this.y;
	this.st = new Date().getTime();
	// control points for bezier-controlled slide (see www.youngpup.net accelimation)
  this.xc1 = this.x + ( (1+acc) * (this.destX-this.x)/3 );
	this.xc2 = this.x + ( (2+acc) * (this.destX-this.x)/3 );
  this.yc1 = this.y + ( (1+acc) * (this.destY-this.y)/3 );
	this.yc2 = this.y + ( (2+acc) * (this.destY-this.y)/3 );
	this.sliding = true;
  this.onSlideStart();
  dw_Animation.add(this.animString + ".doSlide()");
}

dynObj.prototype.doSlide = function() {
	if (!this.sliding) return;	
	var elapsed = new Date().getTime() - this.st;
	if (elapsed < this.slideDur) {
    var x = dw_Bezier.getValue(elapsed/this.slideDur, this.startX, this.destX, this.xc1, this.xc2);
    var y = dw_Bezier.getValue(elapsed/this.slideDur, this.startY, this.destY, this.yc1, this.yc2);
		this.shiftTo( Math.round(x) ,Math.round(y) );
		this.onSlide();
	} else {	// if time's up
    dw_Animation.remove(this.animString + ".doSlide()");
		this.shiftTo(this.destX,this.destY);
		this.onSlide();
		this.sliding = false;
		this.onSlideEnd();
	}
}

dynObj.prototype.slideBy = function(dx,dy,slideDur,acc,endFn) {
	var destX=this.x+dx; var destY=this.y+dy;
	this.slideTo(destX,destY,slideDur,acc,endFn);
}

dynObj.prototype.onSlideStart = function () {}
dynObj.prototype.onSlide = function () {}
dynObj.prototype.onSlideEnd = function () { if (this.el) this.el = null; }