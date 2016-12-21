// ----------------------------------------------------------------------------
//   browser / feature detection
// ----------------------------------------------------------------------------

// stolen from youngpup!

isIE = window.clientInformation ? true : false
isIEDTD = ((document.doctype && document.doctype.name.indexOf(".dtd")>-1) || document.compatMode == "CSS1Compat") ? true : false;
isN4 = document.layers ? true : false
isN6  = navigator.appName == "Netscape" && parseInt(navigator.appVersion) >= 5
isO5 = navigator.userAgent.indexOf("Opera") != -1 && parseInt(navigator.appVersion) >= 4

ie = document.all != null && !isO5;
safari = navigator.userAgent.indexOf("Safari/125") != -1;
moz = !ie && !safari && document.getElementById != null && document.layers == null && navigator.userAgent.indexOf("Netscape/7.02") == -1 && (navigator.userAgent.indexOf("Gecko") || navigator.userAgent.indexOf("Firefox"));
mac = (navigator.userAgent.indexOf("Macintosh") != -1 || navigator.userAgent.indexOf("Mac_PowerPC") != -1);

if (safari) {
  document.write("<style> input.button, input.button[disabled] { font-size: 12px; } </style>");
}

// ----------------------------------------------------------------------------
//   auto login state reconstruction helpers
// ----------------------------------------------------------------------------

function ql_nt(loc) {
  n = new Array();
  qidx = loc.indexOf('?');
  if (qidx == -1) {
    return( loc );
  }
  p = loc.substring(0, qidx);
  s = loc.substring(qidx+1).split('&');
  for( i = 0; i < s.length; ++i ) {
    if(!(s[i].indexOf('returnUrl') == 0) && !(s[i].indexOf('SS_CSAT') == 0) && !(s[i].indexOf('SS_SERIALIZED_FORM_STATE') == 0) && !(s[i].indexOf('SS_INPUT_FORM_STATE') == 0) && SS_INPUT_FORM_STATE.indexOf(s[i]) == -1) {
      n[n.length] = s[i];
    }
  }
  return( p + (n.length ? '?' : '') + n.join('&') );
}

function ql_sifs() {
  return(SS_INPUT_FORM_STATE ? SS_INPUT_FORM_STATE : '');
}

function ql_sfs() {
  v='';
  f=document.getElementById('dataform');
  if(!f)f=document.dataform;
  if(f){
    for( i = 0; i<f.elements.length; ++i) {
      e=f.elements[i];
      if (e.name.length && e.type != 'hidden' && e.type != 'password' && e.name != 'returnUrl' && e.name != 'cardNumber' && e.name != 'securityCode' && e.name != 'expriation') {
        v+=(v.length>0?'&':'')+escape(e.name)+'='+escape(e.value);
      }
    }
  }
  return(v);
}

function ql_csat() {
  var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  var i = 40;
  var key = String();
  while( i-- > 0 ) { key += letters.charAt( random(0, 25) ); }
  return( key );
}

function deserializeFormState(state) {
  f=document.getElementById('dataform');
  if(!f)f=document.dataform;
  if(f){
    s = state.split('&');
    for( i = 0; i < s.length; ++i ) {
      c = s[i].split('=');
      for( j = 0; j < c.length; ++j ) {
        e = f.elements[unescape(c[0])];
        if (e && e.type != 'hidden') { e.value = unescape(c[1]); }
      }
    }
  }
}

// ----------------------------------------------------------------------------
//   a nice rng
// ----------------------------------------------------------------------------

function NextRandomNumber()  {
  var hi   = this.seed / this.Q;
  var lo   = this.seed % this.Q;
  var test = this.A * lo - this.R * hi;
  if (test > 0)
    this.seed = test;
  else
    this.seed = test + this.M;
  return (this.seed * this.oneOverM);
}

function RandomNumberGenerator() {
  var d = new Date();
  this.seed = 2345678901 +
    (d.getSeconds() * 0xFFFFFF) +
    (d.getMinutes() * 0xFFFF);
  this.A = 48271;
  this.M = 2147483647;
  this.Q = this.M / this.A;
  this.R = this.M % this.A;
  this.oneOverM = 1.0 / this.M;
  this.next = NextRandomNumber;
  return this;
}

function random(lrn, urn) {
  // Random LowerRange Number (lrn)
  // Random UpperRange Number (urn)
  return Math.floor((urn - lrn + 1) * rand.next() + lrn);
}

var rand = new RandomNumberGenerator();


// ----------------------------------------------------------------------------
//   form submission / effects processing
// ----------------------------------------------------------------------------


function statusifyElements(root) {
  var as = root.getElementsByTagName("a");
  for (var i = 0; i < as.length; i++) {
    var anchor = as[i];
    if (anchor.title) {
      anchor.onmouseover = function() { window.status = this.title; return true; }
      anchor.onmouseout = function() { window.status = ''; return true; }
    }
  }
  var as = root.getElementsByTagName("img");
  for (var i = 0; i < as.length; i++) {
    var img = as[i];
    if (img.title) {
      img.onmouseover = function() { window.status = this.title; return true; }
      img.onmouseout = function() { window.status = ''; return true; }
    }
  }
}

function urlAttributeAdjust(url, name, val) {

  if (url.match(new RegExp("(\\?|\\&)" + name + "=([^&]*)", "g"))) {
    url= url.replace(new RegExp("(\\?|\\&)" + name + "=([^&]*)", "g"), "$1" + name + "=" + val);
  } else {
    if (url.indexOf("?") == -1) {
      url = url + "?" + name + "=" + val;
    } else {
      url = url + "&" + name + "=" + val;
    }
  }
  return( url );

}

function disableButtonForAction(buttonObj) {
  buttonObj.disabled = 'true';
//  buttonObj.value = 'Submitting..';
}

function smartSubmit(buttonObj, formName) {
  disableButtonForAction( buttonObj );
  document.forms[formName].submit();
  return true;
}

function smartLocation(buttonObj, loc) {
  disableButtonForAction( buttonObj );
  document.location = loc;
  return true;
}

function smartGoBack(buttonObj) {
  disableButtonForAction( buttonObj );
  history.go(-1);
  return true;
}

function smartCancel() {
  window.close();
}

function scrollToElement(name) {
  window.scrollTo(0, getYCoord(document.getElementById(name)) - 100 );
}

functionMap = new Array();
oldButtonColors = new Array();
numericChars = "0123456789";


function inputContainsErrors(targetId) {

  // method 1: fine errorText in it's standard title

  var titleObj = document.getElementById(targetId + '_title');
  if (titleObj) {
    var scanDivs = titleObj.getElementsByTagName("div");
    for (var i = 0; i < scanDivs.length; ++i) {
      if (scanDivs[i].className == "errorText") { return( true ); }
    }
  }
  return( false );

}

function autoFocus(formName, defaultFocus) {

  var f = document.forms[formName];
  if (!f) return;

  var elCount = f.elements.length;
  var errorsSeen = false;
  var focusEl = false;

  for (var i = 0; i < elCount; ++i) {
    el = f.elements[i];
    if (el.type == 'text' || el.type == 'edit' || el.type == 'password' || el.type == 'textarea' || el.type == 'checkbox' || el.type == 'radio' || el.type == 'select-one') {
      if (inputContainsErrors( el.id ) && !focusEl) {
        errorsSeen = true;
        focusEl = el;
      } else if (defaultFocus && !focusEl) {
        focusEl = el;
      }
    }
  }

  if (focusEl) focusEl.focus();

}

function initFormEffects(formName) {

  var f = document.forms[formName];
  if (!f) return;

  var elCount = f.elements.length;

  for (var i = 0; i < elCount; i++) {

    el = f.elements[i];

    if (el.type == 'text' || el.type == 'edit' || el.type == 'password' || el.type == 'textarea' || el.type == 'checkbox' || el.type == 'select-one' || el.type == 'input') {

      var inSequence = false;
      var elNum, elName;
      var n = el.name;
      for (j=0; j < n.length; j++) {
        if (numericChars.indexOf( n.charAt(j) ) == -1) continue; // if we found a number in the string
        elName = n.substring(0, j);
        elNum  = n.substring(j);
        // if this is not the first item, and it doesnt have its own title, its part of a sequence
        if (elNum != "1" && document.getElementById(elName + '_title')) { inSequence = true; }
        break;
      }

      if (inSequence) {
        focusObjName = elName + '1_title';
      } else {
        focusObjName = el.name + '_title';
      }

      o = document.getElementById(focusObjName);
      if (o != null) {
        functionMap[el.name] = focusObjName;
        if (el.type == 'checkbox') {
          functionMap[o.id] = focusObjName;
        }
        el.onfocus = function() { document.getElementById(functionMap[this.name]).style.fontWeight = 'bold'; };
        el.onblur  = function() { document.getElementById(functionMap[this.name]).style.fontWeight = 'normal'; };
      }

    } else if (el.type == 'button' || el.type == 'submit') {

       //el.onfocus = function() { oldButtonColors[this.name] = this.style.backgroundColor; this.style.backgroundColor = '#BBBBBB'; };
       //el.onblur  = function() { this.style.backgroundColor = oldButtonColors[this.name]; };

    }

  }

}


// ----------------------------------------------------------------------------
//   add string helpers
// ----------------------------------------------------------------------------

Date.prototype.getFullYear =  function () { return( window.moz || window.safari ? this.getYear() + 1900 : this.getYear() ); }

String.prototype.trim =  function () { return this.replace(/^\s+/,'').replace(/\s+$/,''); }

function escapeForJS(str) {
  return( str.replace(/"\'"/g, "\\\'").replace(/"\""/g, "\\\"") );
}

function capitalizeFirst(s) {
  return( s.substring(0,1).toUpperCase() + s.substring(1).toLowerCase() );
}

String.prototype.endsWith = function(sEnd) {
  return (this.substr(this.length-sEnd.length)==sEnd);
}

String.prototype.startsWith = function(sStart) {
  return (this.substr(0,sStart.length)==sStart);
}

// ----------------------------------------------------------------------------
//   global functions
// ----------------------------------------------------------------------------

function copyToClipboard(resourceName, str, resourceIsText) {
  if (!resourceIsText) { resourceName = "\'" + resourceName + "\'"; }
  if (window.ie) {
    window.clipboardData.setData('text', str);
    showHelpTip(window.event, '<strong>URL Copied to Clipboard</strong><br/>The URL for ' + resourceName + ' has been copied to your clipboard.  To give this file to someone, simply paste this URL to them.' );
  } else {
    showObject( document.getElementById("clipboardTextContainer") );
    document.getElementById("clipboardTextFilename").innerHTML = resourceName + " ";
    document.getElementById("clipboardTextContent").innerHTML = str;
  }
}

function noop() { }

function getMouseRelativeX() {
  return( parseInt(window.event.clientX) );
}
function getMouseRelativeY() {
  return( parseInt(window.event.clientY) );
}

function getMouseX(e)
{
  if (!e) var e = window.event;
  if (e.pageX) return e.pageX;
  return e.clientX + getViewportScrollX();
}
function getMouseY(e)
{
  if (!e) var e = window.event;
  if (e.pageY) return e.pageY;
  return e.clientY + getViewportScrollY();
}

function getWidth(obj) {
  return( parseInt(obj.offsetWidth) );
}
function getHeight(obj) {
  return( parseInt(obj.offsetHeight) );
}
function getLeft(obj) {
  return( parseInt(obj.offsetLeft) );
}
function getTop(obj) {
  return( parseInt(obj.offsetTop) );
}

function setLeft(obj, distance) {
  obj.style.left = distance + "px";
}

function setTop(obj, distance) {
  obj.style.top = distance + "px";
}

function getXCoord(obj) {
  x = getLeft(obj);
  while (obj.offsetParent.tagName != "BODY" && obj.offsetParent.tagName != "HTML") {
    obj = obj.offsetParent;
    if (obj.offsetParent.tagName != "FORM") { x += getLeft(obj); }
  }
  return( x );
}
function getYCoord(obj) {

  y = getTop(obj);
  while (obj.offsetParent.tagName != "BODY" && obj.offsetParent.tagName != "HTML") {
    obj = obj.offsetParent;
    if (obj.offsetParent.tagName != "FORM") { y += getTop(obj); }
  }
  return( y );
}

function isHidden(obj) {
  return( obj.style.display == "none" );
}

function isVisible(obj) {
  return( !isHidden(obj) );
}

function hideObject(obj) {
  if (obj) obj.style.display = "none";
}
function showObject(obj) {
  if (obj) obj.style.display = "";
}

function toggleVisibility(obj) {
  if (isHidden(obj)) {
    showObject(obj);
  } else {
    hideObject(obj);
  }
}

function trim(str) {
  var idx_start = 0;
  var idx_end = str.length - 1;
  while (str.charAt(idx_start) == ' ') { idx_start++; }
  while (str.charAt(idx_end) == ' ') { idx_end--; }
  return( str.substr(idx_start, (idx_end - idx_start + 1)) );
}

function trimNums(str) {
  var idx_start = 0;
  var idx_end = str.length - 1;
  while (str.charAt(idx_start) == ' ' || !isNaN(str.charAt(idx_start)) || str.charAt(idx_start) == '_') { idx_start++; }
  while (str.charAt(idx_end) == ' ' || !isNaN(str.charAt(idx_end)) || str.charAt(idx_end) == '_') { idx_end--; }
  return( str.substr(idx_start, (idx_end - idx_start + 1)) );
}

function getWindowHeight() {
  if (ie) {
    return( document.body.offsetHeight );
  } else {
    return( window.innerHeight );
  }
}

function getWindowWidth() {
  if (ie) {
    return( document.body.offsetWidth );
  } else {
    return( window.innerWidth );
  }
}

function expandWindowHeight(factor) {
  if (ie) {
    window.resizeBy( 0, factor );
  } else {
    window.innerHeight = window.innerHeight + factor;
  }
}

function expandWindowWidth(factor) {
  if (ie) {
    window.resizeBy( factor, 0 );
  } else {
    window.innerWidth = window.innerWidth + factor;
  }
}

function debug(x) {
  if( window.status.length > 0 )
    window.status = window.status + ' | ' + x;
  else
    window.status = x;
}


function getWindowScroll(w) {
  if (!w) {
    if (isIEDTD) return document.documentElement.scrollTop;
    else if (isIE) return document.body.scrollTop;
    else return window.pageYOffset
  } else {
    if (isIEDTD) return w.document.documentElement.scrollTop;
    else if (isIE) return w.document.body.scrollTop;
    else return w.pageYOffset
  }
}

function getIFrameDocument(fName) {
  if (window.safari) {
    return( window.frames[fName].document );
  } else {
    return( document.getElementById(fName).contentWindow.document );
  }

}




// ----------------------------------------------------------------------------
//   viewport functions
// ----------------------------------------------------------------------------

function getViewportHeight() {
  if (self.innerHeight) // all except Explorer
  {
    y = self.innerHeight;
  }
  else if (document.documentElement && document.documentElement.clientHeight)
    // Explorer 6 Strict Mode
  {
    y = document.documentElement.clientHeight;
  }
  else if (document.body) // other Explorers
  {
    y = document.body.clientHeight;
  }
  return( y );
}

function getViewportWidth() {
  if (self.innerHeight) // all except Explorer
  {
    x = self.innerWidth;
  }
  else if (document.documentElement && document.documentElement.clientHeight)
    // Explorer 6 Strict Mode
  {
    x = document.documentElement.clientWidth;
  }
  else if (document.body) // other Explorers
  {
    x = document.body.clientWidth;
  }
  return( x );
}


function getViewportScrollX() {
  if (self.pageYOffset) // all except Explorer
  {
    x = self.pageXOffset;
  }
  else if (document.documentElement && document.documentElement.scrollTop)
    // Explorer 6 Strict
  {
    x = document.documentElement.scrollLeft;
  }
  else if (document.body) // all other Explorers
  {
    x = document.body.scrollLeft;
  }
  return( x );
}

function getViewportScrollY() {
  if (self.pageYOffset) // all except Explorer
  {
    y = self.pageYOffset;
  }
  else if (document.documentElement && document.documentElement.scrollTop)
    // Explorer 6 Strict
  {
    y = document.documentElement.scrollTop;
  }
  else if (document.body) // all other Explorers
  {
    y = document.body.scrollTop;
  }
  return( y );
}


// ----------------------------------------------------------------------------
//   cookie functions
// ----------------------------------------------------------------------------

function setCookie(sName, sValue, expires, path, domain) {
  document.cookie = sName + "=" + escape(sValue) + "; expires=" + (expires == null ? new Date("January 1, 2023").toGMTString() : expires) + "; path=" + ((path == null)  ? "/" : path) + ((domain == null)  ? "" : "; domain=" + domain);
}

function delCookie(sName, path, domain) {
  document.cookie = sName + "=" + escape(getCookie(sName)) + ";expires=" + new Date("December 31, 1975").toGMTString() + "; path=" + ((path == null) ? "/" : path) + ((domain == null)  ? "" : "; domain=" + domain);
}

function getCookie(sCookie) {
  var aCookie = document.cookie.split(";");
  for (var i = 0; i < aCookie.length; i++)
  {
    var aCrumb = aCookie[i].split("=");
    if (sCookie == trim(unescape(aCrumb[0]))) {
      return( unescape(aCrumb[1]) );
    }
  }
  return( null );
}

function getCookieDomain(fullhost) {
  var hs = fullhost.split(".");
  if (hs.length - 2 < 0) {
    return( "" );
  } else {
    return( "." + hs[hs.length - 2] + "." + hs[hs.length - 1] );
  }
}

function toggleContentElement(srcCheckbox, tgtElement) {
  if ( srcCheckbox.checked ) {
    showObject(tgtElement);
  } else {
    hideObject(tgtElement);
  }
}

function toggleContentElementByValue(val, tgtElement) {
  if ( val ) {
    showObject(tgtElement);
  } else {
    hideObject(tgtElement);
  }
}


// ----------------------------------------------------------------------------
//   ie emulation (erik arvidson)
// ----------------------------------------------------------------------------

if (!safari && /Mozilla\/5\.0/.test(navigator.userAgent)) {

  HTMLElement.prototype.insertAdjacentHTML = function (sWhere, sText) {

     var r = document.createRange();
     switch (sWhere) {
      case "beforeBegin":
       r.setStartBefore(this);
       this.parentNode.insertBefore(r.createContextualFragment(sText), this);
       break;

      case "afterBegin":
       r.setStartBefore(this.firstChild);
       this.insertBefore(r.createContextualFragment(sText), this.firstChild);
       break;

      case "beforeEnd":
       r.setStartAfter(this.lastChild);
       this.appendChild(r.createContextualFragment(sText));
       break;

      case "afterEnd":
       r.setStartAfter(this);
       this.parentNode.insertBefore(r.createContextualFragment(sText), this.nextSibling);

       break;
     }

  }


}


// ----------------------------------------------------------------------------
//   form radio button helpers
// ----------------------------------------------------------------------------

function setRadioValue(formname, radioname, val) {

  obj = document.forms[formname][radioname];
  for(i=0;i<obj.length;i++) {
    if (obj[i].value == val) obj[i].checked = true;
  }

}

function getRadioValue(formname, radioname) {

  obj = document.forms[formname][radioname];
  for(i=0;i<obj.length;i++) {
    if (obj[i].checked) return( obj[i].value );
  }

}

function getRadio(formname, radioname, val) {

  obj = document.forms[formname][radioname];

  for(i=0;i<obj.length;i++) {
    if (obj[i].value == val) return( obj[i] );
  }

}

function getSelectOptionTitleByValue(formname, fieldName, val) {

  obj = document.forms[formname][fieldName];
  for (var i = 0; i < obj.length; ++i) {
    if (obj[i].value == val) { return( obj[i].text ); }
  }
  return( null );

}

function setFieldValue(formname, fieldName, val) {

  obj = document.forms[formname][fieldName];

  if (obj.tagName.toLowerCase() == "select") {

    for (var i = 0; i < obj.length; ++i) {
      if (obj[i].value == val) { obj.selectedIndex = i; break; }
    }

  } else {

    obj.value = val;

  }

}

function setFieldDisabled(formname, fieldName) {

  obj = document.forms[formname][fieldName];
  obj.style.color = '#727272';
  obj.style.backgroundColor = '#F9F9F9';
  obj.readOnly = 1;

}

function setFieldEnabled(formname, fieldName) {

  obj = document.forms[formname][fieldName];
  obj.style.color = '#000000';
  obj.style.backgroundColor = '#FFFFFF';
  obj.readOnly = 0;

}


function openGuide(root, name, size) {
  var w = 0, h = 0;
  if (size == 'small') {
    w = 400;
    h = 560;
  } else if (size == 'medium') {
    w = 500;
    h = 660;
  } else if (size == 'large') {
    w = 765;
    h = 660;
  }
  window.open(root.href, name,'width=' + w + ',height=' + h + ',scrollbars=yes,resizable=yes,titlebar=yes,menubar=no,toolbar=no');
}

function addEvent(obj, et, f) {
  if (obj.addEventListener) {
    obj.addEventListener(et, f, false);
    return( true );
  } else if (obj.attachEvent) {
    var r = obj.attachEvent('on' + ret, f);
    return( r );
  }
  return( false );
}

function cleanForHTML(s) {



  return( s );

}
