/* How to use roll-tips:
11/09 bug note:  MikeO found that '&nbsp;?&nbsp;' breaks IE rolltips, but ' ? ' does not break.  So perhaps don't have any &nbsp; chars

1) Include this file at very end of your file just before </body> tag:
     <script src="/global/javascript_lp/rolltip_lib.js" type="text/javascript"></script>
2) Include a javascript library that defines functions 'showRollTip' and 'hideRollTip' in the head section (note, yes, these 2 functions seem to have to be in head)
     <script src="/global/javascript_lp/lp_lib.js" type="text/javascript"> </script>
3) Open body tag has to be as such:
     <body onLoad="RollTip.init()">
4) Have a CSS style 'div#rolltipDiv' defined in your CSS file (for Rob it's in landing_pages_new.css.  This is where you control the look of the roll-tip.
5) Invoke the rolltip as follows:
     	<a href="htm/sharing/free-share-with-family.php" onMouseOver="showRollTip('Free family sharing websites',event)" onMouseOut="hideRollTip()">Family</a>
   OR here is a help oriented example (note the use of the 'help' cursor type):
        <a id="foobar" style="cursor:help" onMouseOver="showRollTip('Sample help tip message - what a way to give help' ,event)" onMouseOut="hideRollTip()"><span class="helplink">[?]</span></a>

Here is a sample of the CSS code:
div#rolltipDiv {
  position:absolute; visibility:hidden;
  left:0; top:0; z-index:1000;
  width:220px; padding:3px; font-size:11px;
  background-color:#eaf0fa; border:1px solid #fa0;  
  }

*/

/*************************************************************************
    dw_event.js (version date Feb 2004)
        
    This code is from Dynamic Web Coding at http://www.dyn-web.com/
    See Terms of Use at http://www.dyn-web.com/bus/terms.html
    regarding conditions under which you may use this code.
    This notice must be retained in the code as is!
*************************************************************************/

var dw_event = {
  
  add: function(obj, etype, fp, cap) {
    cap = cap || false;
    if (obj.addEventListener) obj.addEventListener(etype, fp, cap);
    else if (obj.attachEvent) obj.attachEvent("on" + etype, fp);
  }, 

  remove: function(obj, etype, fp, cap) {
    cap = cap || false;
    if (obj.removeEventListener) obj.removeEventListener(etype, fp, cap);
    else if (obj.detachEvent) obj.detachEvent("on" + etype, fp);
  }, 

  DOMit: function(e) { 
    e = e? e: window.event;
    e.tgt = e.srcElement? e.srcElement: e.target;
    
    if (!e.preventDefault) e.preventDefault = function () { return false; }
    if (!e.stopPropagation) e.stopPropagation = function () { if (window.event) window.event.cancelBubble = true; }
        
    return e;
  }
  
}


/*
  dw_rolltip.js   version date: March 2005  
  requires dw_event.js and dw_viewport.js
  algorithm for time-based animation from youngpup.net
*/

var RollTip = {
    followMouse: true,
    offX: 12,
    offY: 12,
    ID: "rolltipDiv",
    // duration of clipping animation
    showAni: 300,
    hideAni: 200,

    ready:false, timer:null, tip:null, 
  
    init: function() {
        // op7.51 can do the clip 
        var opok = ( !window.opera || window.opera && opera.buildNumber && opera.buildNumber() > 3800 )? true: false;        
        if ( document.createElement && document.body && 
            typeof document.body.appendChild != "undefined" && opok ) {
        var el = document.createElement("DIV");
        el.id = this.ID; document.body.appendChild(el);
        this.showMult = el.offsetWidth/this.showAni/this.showAni;	
        this.hideMult = el.offsetWidth/this.hideAni/this.hideAni;	                
        el.style.clip = "rect(0, 0, 0, 0)";
        el.style.visibility = "visible";
        this.ready = true;
        }
    },

    reveal: function(msg, e) {
        if (this.timer) { clearTimeout(this.timer);	this.timer = 0; }
        this.tip = document.getElementById( this.ID );
        this.writeTip(""); // for mac ie 
        this.writeTip(msg);
        viewport.getAll();
        this.w = this.tip.offsetWidth; this.h = this.tip.offsetHeight;
        this.startTime = (new Date()).getTime();
        this.positionTip(e);
        if (this.followMouse) // set up mousemove 
            dw_event.add( document, "mousemove", this.trackMouse, true );
        this.timer = setInterval("RollTip.rollOut()", 10);
    },
  
    rollOut: function() {
        var elapsed = (new Date()).getTime() - this.startTime;
        if (elapsed < this.showAni) {
            var cv = this.w - Math.round( Math.pow(this.showAni - elapsed, 2) * this.showMult );
            this.clipTo(0, cv, this.h, 0);
        } else {
            this.clipTo(0, this.w, this.h, 0);
            clearInterval(this.timer); this.timer = 0;
        }
    },
  
    conceal: function() {
        if (this.timer) { clearTimeout(this.timer);	this.timer = 0; }
        this.startTime = (new Date()).getTime();
        if (this.followMouse) // release mousemove
            dw_event.remove( document, "mousemove", this.trackMouse, true );
        this.timer = setInterval("RollTip.rollUp()", 10);
    },
  
    rollUp: function() {
        var elapsed = (new Date()).getTime() - this.startTime;
        if ( elapsed < this.hideAni ) {
            var cv = Math.round( Math.pow(this.hideAni - elapsed, 2) * this.hideMult );
            this.clipTo(0, cv, this.h, 0);
        } else {
            this.clipTo(0, 0, this.h, 0);
            clearInterval(this.timer); this.timer = 0;
            this.tip = null;
        }  
    },
  
    writeTip: function(msg) {
        if ( this.tip && typeof this.tip.innerHTML != "undefined" ) this.tip.innerHTML = msg;
    },
  
    clipTo: function(top, rt, btm, lft) {
        if (this.tip && this.tip.style) 
            this.tip.style.clip = "rect("+top+"px, "+rt+"px, "+btm+"px, "+lft+"px)";
    },
  
    positionTip: function(e) {
        // put e.pageX/Y first! (for Safari)
        var x = e.pageX? e.pageX: e.clientX + viewport.scrollX;
        var y = e.pageY? e.pageY: e.clientY + viewport.scrollY;

        if ( x + this.tip.offsetWidth + this.offX > viewport.width + viewport.scrollX ) {
            x = x - this.tip.offsetWidth - this.offX;
         //   if ( x < 0 ) x = 0; // no good with roll-out if layer appears over link
        } else x = x + this.offX;
    
        if ( y + this.tip.offsetHeight + this.offY > viewport.height + viewport.scrollY ) {
            y = y - this.tip.offsetHeight - this.offY;
            if ( y < viewport.scrollY ) y = viewport.height + viewport.scrollY - this.tip.offsetHeight;
        } else y = y + this.offY;

        this.tip.style.left = x + "px"; this.tip.style.top = y + "px";
    },
    
    trackMouse: function(e) {
    	e = dw_event.DOMit(e);
     	RollTip.positionTip(e);
    }
    
}
/*************************************************************************

  dw_viewport.js
  version date Nov 2003
  
*************************************************************************/  
  
var viewport = {
  getWinWidth: function () {
    this.width = 0;
    if (window.innerWidth) this.width = window.innerWidth - 18;
    else if (document.documentElement && document.documentElement.clientWidth) 
  		this.width = document.documentElement.clientWidth;
    else if (document.body && document.body.clientWidth) 
  		this.width = document.body.clientWidth;
  },
  
  getWinHeight: function () {
    this.height = 0;
    if (window.innerHeight) this.height = window.innerHeight - 18;
  	else if (document.documentElement && document.documentElement.clientHeight) 
  		this.height = document.documentElement.clientHeight;
  	else if (document.body && document.body.clientHeight) 
  		this.height = document.body.clientHeight;
  },
  
  getScrollX: function () {
    this.scrollX = 0;
  	if (typeof window.pageXOffset == "number") this.scrollX = window.pageXOffset;
  	else if (document.documentElement && document.documentElement.scrollLeft)
  		this.scrollX = document.documentElement.scrollLeft;
  	else if (document.body && document.body.scrollLeft) 
  		this.scrollX = document.body.scrollLeft; 
  	else if (window.scrollX) this.scrollX = window.scrollX;
  },
  
  getScrollY: function () {
    this.scrollY = 0;    
    if (typeof window.pageYOffset == "number") this.scrollY = window.pageYOffset;
    else if (document.documentElement && document.documentElement.scrollTop)
  		this.scrollY = document.documentElement.scrollTop;
  	else if (document.body && document.body.scrollTop) 
  		this.scrollY = document.body.scrollTop; 
  	else if (window.scrollY) this.scrollY = window.scrollY;
  },
  
  getAll: function () {
    this.getWinWidth(); this.getWinHeight();
    this.getScrollX();  this.getScrollY();
  }
  
}
