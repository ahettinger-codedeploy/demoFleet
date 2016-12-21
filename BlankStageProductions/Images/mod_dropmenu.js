
/*
  - Dropmenu Module for Joomla! ----------------------------------------------------------

  Filename:       mod_dropmenu/mod_dropmenu.js
  Version:        1.3
  Release Date:   08/31/06
  Developer:      David Hunt
  Copyright:      2006 Byrgius Technologies
  License:        GNU/GPL (http://www.gnu.org/copyleft/gpl.html)
  Source:         http://software.byrgius.com/

  - Dependants ---------------------------------------------------------------------------

  none

  ----------------------------------------------------------------------------------------
*/

/* -------------------------------- */
if (document.getElementById) {
  var navMenuTimout = 350;
  var navTimers     = new Array();
  var objNum        = 1;
  var objLev        = 0;
  var found         = new Array();
  var thisID        = 0;
  var debug         = 0;
  do{
    objLev            = 0;
    found[0]          = 0;
    do{
      if ( document.getElementById('dm-'+objNum+'-'+objLev) ) {
        // Parent -------------------------------------------------
        navTimers.push(0); thisID++;
        found[0] = 1;
        found[1] = 1;
        lnkObj = document.getElementById('dm-'+objNum+'-'+objLev);
        lnkObj.onmouseover = function() {
          if(debug)alert( 'mOver: '+this.navTim+' '+this.nodeName );
          if(this.navRoot){
            this.navRoot.style.visibility = 'visible';
            this.navRoot.style.zIndex = 100+(this.navLev*10);
          }
          if(this.navLev==0)imgOver(this);
          return true;
        };
        lnkObj.onmouseout  = function() {
          if(debug)alert( 'mOut: '+this.navTim+' '+this.nodeName );
          if(this.navNum)
            navTimers[this.navTim] = setTimeout( "closeNav('"+this.navNum+"','"+this.navLev+"')", navMenuTimout );
          if(this.navLev==0)imgOver(this);
          return true;
        };
        // Children -----------------------------------------------
        navRoot = document.getElementById("nav"+objNum+'-'+objLev);
        navRoot.origZ = navRoot.style.zIndex;
        if ( navRoot ) {
          lnkObj.navTim  = thisID;
          lnkObj.navNum  = objNum;
          lnkObj.navLev  = objLev;
          lnkObj.navRoot = navRoot;
          for (i=0; i<navRoot.childNodes.length; i++) {
            node = navRoot.childNodes[i];
            node.navTim = thisID;
            node.navNum = objNum;
            node.navLev = objLev;
            node.navRoot = navRoot;
            if (node.nodeName=="LI") {
              node.onmouseover=function() {
                if(debug)alert( 'mOver: '+this.navTim+' '+this.nodeName );
                clearTimeout( navTimers[this.navTim] );
                this.navRoot.style.zIndex = 100+(this.navLev*10);
                this.className+=" over";
              }
              node.onmouseout=function() {
                if(debug)alert( 'mOut: '+this.navTim+' '+this.nodeName );
                navTimers[this.navTim] = setTimeout( "closeNav('"+this.navNum+"','"+this.navLev+"')", navMenuTimout );
                this.className=this.className.replace(" over", "");
              }
            }
          }
        }
      } else {
        found[1] = 0;
      }
      objLev++;
    } while( found[1] > 0 );
    objNum++;
  } while( found[0] > 0 );
  if(debug)alert( 'Found '+thisID+' Menu Object' );
}

/* -------------------------------- */
function closeNav( navNum, navLev ) {
  if( document.getElementById("nav"+navNum+'-'+navLev) )
    document.getElementById("nav"+navNum+'-'+navLev).style.visibility = 'hidden';
};

/* -------------------------------- */
function imgOver(myObj){
  mc=myObj.childNodes[0];
  if( myObj.childNodes[0].nodeName == 'IMG' ){
    mcs=mc.src;
    if( mcs.match('\/hover\/') ) mcs = mcs.replace( /\/hover\//, '\/default\/' );
      else mcs = mcs.replace( /\/default\//, '\/hover\/' );
    mc.src=mcs;
  }
}
