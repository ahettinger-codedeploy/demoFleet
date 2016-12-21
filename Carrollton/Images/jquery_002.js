// ===================================================================================================== 
// ! the fsBreakly (Finalsite Breakly) Plugin is a modified version of the fsBreakly plugin (info below)   
// ===================================================================================================== 

/*
	Finalsite Mods:
		- update forward slashes to set them as break characters
		- "$.fn.fsBreakly" updated to full "jQuery" for compatability with fs $j no-conflict prefix
*/


/**
 * jQuery Breakly plugin - Breaks your texts. Gently.
 * This plugin can be used to give the browser an "hint" on when (and eventually how) break
 * some long texts that are wrapped in a container with an explicitely defined width.
 * It works adding a "special" unicode character after the given number of characters.
 * By default the plugin inserts U+200B (the zero width space), but you can specify any
 * other character as the second parameter
 *
 * @name jquery-fsBreakly-1.0.js
 * @author Claudio Cicali - http://claudio.cicali.name
 * @version 1.0
 * @date December 22, 2009
 * @category jQuery plugin
 * @copyright (c) 2009 Claudio Cicali ( http://claudio.cicali.name )
 * @license MIT http://en.wikipedia.org/wiki/MIT_License
 * @examples
 *   $('h3').fsBreakly(3); // "breaks" any h3 text (and any h3's children text too) inserting a \U+200B after every 3 characters
 *   $('h3').fsBreakly(3, 0x202f); // Same as above, but inserts a "NARROW NO-BREAK SPACE" (just for the fun of it)
 
 * Visit http://lab.web20.it/fsBreakly/example.html
 * List of Unicode spaces: http://www.cs.tut.fi/~jkorpela/chars/spaces.html
 */
jQuery.fn.fsBreakly = function(chopAt, spaceCode) {

  spaceCode |= 8203/*8212*/;  // U+200B ZERO WIDTH SPACE
  var zw = String.fromCharCode(spaceCode), re = new RegExp("\\B"), orig, idx, chopped, ch;
  function fsBreakly(node) {
    if (3 == node.nodeType && (orig = node.nodeValue).length > chopAt) {
      idx = 0;
      chopped=[];
      for (var i=0; i < orig.length; i++) {
        ch = orig.substr(i,1);
        chopped.push(ch);
        if (null != ch.match(re)) {
          idx=0;
          continue;
        }
        if (++idx == chopAt) {
          ch = orig.substr(i+1,1); // look ahead
          if (ch && null == ch.match(re)) {
            chopped.push(zw);
            idx=0;
          }
        }
      }
      // add the replace function to ensure slashes, ampersands and equal signs also act as breaking points
      node.nodeValue = chopped.join('').replace( new RegExp( "[/]", "g" ), "/" + zw );
      node.nodeValue = node.nodeValue.replace( new RegExp( "[\]", "g" ), "\\" + zw );
      node.nodeValue = node.nodeValue.replace( new RegExp( "[&]", "g" ), "&" + zw );
      node.nodeValue = node.nodeValue.replace( new RegExp( "[=]", "g" ), "=" + zw );
      
//      console.log( node.nodeValue );
      
    } else {
      for (var i=0; i < node.childNodes.length; i++) {
        fsBreakly(node.childNodes[i]);
      }
    }
  }

  return this.each(function() {
    fsBreakly(this);
  })
}

