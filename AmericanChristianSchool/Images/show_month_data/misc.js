// misc.js

function isFramed() {    /* Is KAS running in a iFrame?  */
	return (self.location != top.location);
}

// Used only by the View link (currently the whole title is the view link) so that view.php will recieve the array it needs 
// to support the NEXT and PREV buttons.
// Called from incl_view.php and recent.php
function submit_form_for_view_php( value, view_index )
{
  document.form_show.action = value;    // what item to view
  document.form_show.view_index.value = view_index;  // index of this item in the hidden array view_array[]
  document.form_show.submit();
}


/*************************************************************************
  This code is from Dynamic Web Coding at dyn-web.com
  Copyright 2002-5 by Sharon Paine
  See Terms of Use at http://www.dyn-web.com/bus/terms.html
  regarding conditions under which you may use this code.
  This notice must be retained in the code as is!
*************************************************************************/
/* this code is duplicated in file  "lp_lib.js" for use external LPs by Rob -- this lib has more code */

function showRollTip(msg, e) {
  if ( typeof RollTip == "undefined" || !RollTip.ready ) return;
  RollTip.reveal(msg, e);
}

function hideRollTip() {
  if ( typeof RollTip == "undefined" || !RollTip.ready ) return;
  RollTip.conceal();
}
