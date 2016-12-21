/*
 * jQuery idleTimer plugin
 * version 0.9.100511
 * by Paul Irish. 
 *   http://github.com/paulirish/yui-misc/tree/
 * MIT license
 
 * adapted from YUI idle timer by nzakas:
 *   http://github.com/nzakas/yui-misc/
*/
(function(a){a.idleTimer=function(d,b){var j=false,h=true,f=3e4,i="mousemove keydown DOMMouseScroll mousewheel mousedown";b=b||document;var e=function(d){if(typeof d=="number")d=undefined;var c=a.data(d||b,"idleTimerObj");c.idle=!c.idle;c.olddate=+new Date;var e=jQuery.Event(a.data(b,"idleTimer",c.idle?"idle":"active")+".idleTimer");e.stopPropagation();a(b).trigger(e)},k=function(b){var c=a.data(b,"idleTimerObj");c.enabled=false;clearTimeout(c.tId);a(b).unbind(".idleTimer")},g=function(){var b=a.data(this,"idleTimerObj");clearTimeout(b.tId);if(b.enabled){b.idle&&e(this);b.tId=setTimeout(e,b.timeout)}},c=a.data(b,"idleTimerObj")||new function(){};c.olddate=c.olddate||+new Date;if(typeof d=="number")f=d;else if(d==="destroy"){k(b);return this}else if(d==="getElapsedTime")return+new Date-c.olddate;a(b).bind(a.trim((i+" ").split(" ").join(".idleTimer ")),g);c.idle=j;c.enabled=h;c.timeout=f;c.tId=setTimeout(e,c.timeout);a.data(b,"idleTimer","active");a.data(b,"idleTimerObj",c)};a.fn.idleTimer=function(b){this[0]&&a.idleTimer(b,this[0]);return this}})(jQuery)