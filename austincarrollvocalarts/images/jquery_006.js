/*! Copyright (c) 2011 Brandon Aaron (http://brandonaaron.net)
 * Licensed under the MIT License (LICENSE.txt).
 *
 * Thanks to: http://adomas.org/javascript-mouse-wheel/ for some pointers.
 * Thanks to: Mathias Bank(http://www.mathias-bank.de) for a scope bug fix.
 * Thanks to: Seamus Leahy for adding deltaX and deltaY
 *
 * Version: 3.0.6
 * 
 * Requires: 1.2.2+
 */
(function(t){function e(e){var i=e||window.event,s=[].slice.call(arguments,1),a=0,n=0,o=0,e=t.event.fix(i);return e.type="mousewheel",i.wheelDelta&&(a=i.wheelDelta/120),i.detail&&(a=-i.detail/3),o=a,i.axis!==void 0&&i.axis===i.HORIZONTAL_AXIS&&(o=0,n=-1*a),i.wheelDeltaY!==void 0&&(o=i.wheelDeltaY/120),i.wheelDeltaX!==void 0&&(n=-1*i.wheelDeltaX/120),s.unshift(e,a,n,o),(t.event.dispatch||t.event.handle).apply(this,s)}var i=["DOMMouseScroll","mousewheel"];if(t.event.fixHooks)for(var s=i.length;s;)t.event.fixHooks[i[--s]]=t.event.mouseHooks;t.event.special.mousewheel={setup:function(){if(this.addEventListener)for(var t=i.length;t;)this.addEventListener(i[--t],e,!1);else this.onmousewheel=e},teardown:function(){if(this.removeEventListener)for(var t=i.length;t;)this.removeEventListener(i[--t],e,!1);else this.onmousewheel=null}},t.fn.extend({mousewheel:function(t){return t?this.bind("mousewheel",t):this.trigger("mousewheel")},unmousewheel:function(t){return this.unbind("mousewheel",t)}})})(jQuery);