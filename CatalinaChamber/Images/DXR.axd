var __aspxInvalidDimension = -10000;
var __aspxInvalidPosition = -10000;
var __aspxAbsoluteLeftPosition = -10000;
var __aspxAbsoluteRightPosition = 10000;
var __aspxMenuZIndex = 21998;
var __aspxPopupControlZIndex = 11998;
var __aspxPopupShadowWidth = 5;
var __aspxPopupShadowHeight = 5;
var  __aspxCheckSizeCorrectedFlag = true;
var __aspxCallbackSeparator = ":";
var __aspxItemIndexSeparator = "i";
var __aspxCallbackResultPrefix = "/*DX*/";
var __aspxItemClassName = "dxi";
var __aspxAccessibilityEmptyUrl = "javascript:;";
var __aspxClassesScriptParsed = false;
var __aspxDocumentLoaded = false; 
var __aspxEmptyAttributeValue = { };
var __aspxEmptyCachedValue = { };
var __aspxCachedRules = { };
var __aspxStyleCount = 0;
var __aspxStyleNameCache = { };
var __aspxCultureInfo = {
 twoDigitYearMax: 2029,
 ts: ":",
 ds: "/",
 am: "AM",
 pm: "PM",
 monthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December", ""],
 genMonthNames: null,
 abbrMonthNames: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", ""],
 abbrDayNames: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
 dayNames: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
 numDecimalPoint: ".",
 numPrec: 2,
 numGroupSeparator: ",", 
 numGroups: [ 3 ],
 numNegPattern: 1,
 numPosInf: "Infinity", 
 numNegInf: "-Infinity", 
 numNan: "NaN",
 currency: "$",
 currDecimalPoint: ".",
 currPrec: 2,
 currGroupSeparator: ",",
 currGroups: [ 3 ],
 currPosPattern: 0,
 currNegPattern: 0,
 percentPattern: 0,
 shortTime: "h:mm tt",
 longTime: "h:mm:ss tt",
 shortDate: "M/d/yyyy",
 longDate: "dddd, MMMM dd, yyyy",
 monthDay: "MMMM dd",
 yearMonth: "MMMM, yyyy"
};
__aspxCultureInfo.genMonthNames = __aspxCultureInfo.monthNames;
function _aspxGetInvariantDateString(date) {
 if(!date)
  return "01/01/0001";
 var day = date.getDate();
 var month = date.getMonth() + 1;
 var year = date.getFullYear();
 var result = "";
 if(month < 10)
  result += "0";
 result += month.toString() + "/";
 if(day < 10)
  result += "0";
 result += day.toString() + "/";
 if(year < 1000)
  result += "0";
 result += year.toString();
 return result;
}
function _aspxGetInvariantDateTimeString(date) {
 var dateTimeString = _aspxGetInvariantDateString(date);
 var time = {
  h: date.getHours(),
  m: date.getMinutes(),
  s: date.getSeconds()
 };
 for(var key in time) {
  var str = time[key].toString();
  if(str.length < 2)
   str = "0" + str;
  time[key] = str;
 }
 dateTimeString += " " + time.h + ":" + time.m + ":" + time.s;
 var msec = date.getMilliseconds();
 if(msec > 0)
  dateTimeString += "." + msec.toString();
 return dateTimeString;
}
function _aspxExpandTwoDigitYear(value) {
 value += 1900;
 if(value + 99 < __aspxCultureInfo.twoDigitYearMax)
  value += 100;
 return value;  
}
function _aspxToUtcTime(date) {
 var result = new Date();
 result.setTime(date.valueOf() + 60000 * date.getTimezoneOffset());
 return result;
}
function _aspxToLocalTime(date) {
 var result = new Date();
 result.setTime(date.valueOf() - 60000 * date.getTimezoneOffset());
 return result; 
}
function _aspxAreDatesEqualExact(date1, date2) {
 if(date1 == null && date2 == null)
  return true;
 if(date1 == null || date2 == null)
  return false;
 return date1.getTime() == date2.getTime(); 
}
function _aspxFixTimezoneGap(oldDate, newDate) {
 var diff = newDate.getHours() - oldDate.getHours();
 if(diff == 0)
  return;
 var sign = (diff == 1 || diff == -23) ? -1 : 1;
 var trial = new Date(newDate.getTime() + sign * 3600000);
 if(sign > 0 || trial.getDate() == newDate.getDate())
  newDate.setTime(trial.getTime());
}
var ASPxKey = {
 F1     : 112,
 F2     : 113,
 F3     : 114,
 F4     : 115,
 F5     : 116,
 F6     : 117,
 F7     : 118,
 F8     : 119,
 F9     : 120,
 F10    : 121,
 F11    : 122,
 F12    : 123,
 Ctrl   : 17,
 Shift  : 16,
 Alt    : 18,
 Enter  : 13,
 Home   : 36,
 End    : 35,
 Left   : 37,
 Right  : 39,
 Up     : 38,
 Down   : 40,
 PageUp    : 33,
 PageDown  : 34,
 Esc    : 27,
 Space  : 32,
 Tab    : 9,
 Backspace : 8,
 Delete    : 46,
 Insert    : 45,
 ContextMenu  : 93,
 Windows   : 91,
 Decimal   : 110
};
var ASPxCallbackType = {
 Data: "d",
 Common: "c"
};
var ASPxWhiteSpaces = { 
 0x0009: 1, 0x000a: 1, 0x000b: 1, 0x000c: 1, 0x000d: 1, 0x0020: 1, 0x0085: 1, 
 0x00a0: 1, 0x1680: 1, 0x180e: 1, 0x2000: 1, 0x2001: 1, 0x2002: 1, 0x2003: 1, 
 0x2004: 1, 0x2005: 1, 0x2006: 1, 0x2007: 1, 0x2008: 1, 0x2009: 1, 0x200a: 1, 
 0x200b: 1, 0x2028: 1, 0x2029: 1, 0x202f: 1, 0x205f: 1, 0x3000: 1
};
function _aspxFalseFunction() { return false; }
var __aspxServerForm = null;
function _aspxGetServerForm() {
 if (!_aspxIsExistsElement(__aspxServerForm)) {
  __aspxServerForm = null; 
  if(typeof(window.__aspxServerFormID) != "undefined")
   __aspxServerForm = _aspxGetElementById(window.__aspxServerFormID);
  if (!__aspxServerForm) 
   __aspxServerForm = document.forms[0];
 }
 return __aspxServerForm;
}
function _aspxGetActiveElement() {
 try{
  return document.activeElement;
 } catch(e) {
 }
 return null;
}
var __aspxUserAgent = navigator.userAgent.toLowerCase();
var __aspxMozilla,
 __aspxIE,
 __aspxFirefox,
 __aspxNetscape,
 __aspxSafari,
 __aspxChrome,
 __aspxOpera,
 __aspxBrowserVersion, 
 __aspxBrowserMajorVersion, 
 __aspxWindowsPlatform,
 __aspxMacOSPlatform,
 __aspxMacOSMobilePlatform,
 __aspxWebKitFamily, 
 __aspxNetscapeFamily, 
 __aspxBrowserWithHardwareAcceleration;
function _aspxIdentUserAgent(userAgent, ignoreDocumentMode) {
 var browserTypesOrderedList = [ "Mozilla", "IE", "Firefox", "Netscape", "Safari", "Chrome", "Opera", "Opera10" ];
 var defaultBrowserType = "IE";
 var defaultPlatform = "Win";
 var defaultVersions = { Safari: 2, Chrome: 0.1, Mozilla: 1.9, Netscape: 8, Firefox: 2, Opera: 9, IE: 6 };
 if(!userAgent || userAgent.length == 0) {
  _aspxFillUserAgentInfo(browserTypesOrderedList, defaultBrowserType, defaultVersions[defaultBrowserType], defaultPlatform);
  return;
 }
 try {
  var platformIdentStrings = {
   "Windows": "Win",
   "Macintosh": "Mac",
   "Mac OS": "Mac",
   "Mac_PowerPC": "Mac",
   "cpu os": "MacMobile",
   "cpu iphone os": "MacMobile"
  };
  var optSlashOrSpace = "(?:/|\\s*)?";
  var version = "(\\d+)(?:\\.((?:\\d+?[1-9])|\\d)0*?)?";
  var optVersion = "(?:" + version + ")?";
  var patterns = {
   Safari: "applewebkit(?:.*?(?:version/" + version + "[\\.\\w\\d]*?(?:\\s+mobile\/\\S*)?\\s+safari))?",
   Chrome: "chrome(?!frame)" + optSlashOrSpace + optVersion,
   Mozilla: "mozilla(?:.*rv:" + optVersion + ".*Gecko)?",
   Netscape: "(?:netscape|navigator)\\d*/?\\s*" + optVersion,
   Firefox: "firefox" + optSlashOrSpace + optVersion,
   Opera: "opera" + optSlashOrSpace + optVersion,
   Opera10: "opera.*\\s*version" + optSlashOrSpace + optVersion,
   IE: "msie\\s*" + optVersion
  };
  var browserType;
  var version = -1;
  for(var i = 0; i < browserTypesOrderedList.length; i++) {
   var browserTypeCandidate = browserTypesOrderedList[i];
   var regExp = new RegExp(patterns[browserTypeCandidate], "i");
   if(regExp.compile)
    regExp.compile(patterns[browserTypeCandidate], "i");
   var matches = regExp.exec(userAgent);
   if(matches && matches.index >= 0) {
    browserType = browserTypeCandidate;
    if(browserType == "Opera10")
     browserType = "Opera";
    version = -1;
    var versionStr = "";
    if(matches[1]) {
     versionStr += matches[1];
     if(matches[2])
      versionStr += "." + matches[2];
    }
    if(versionStr != "") {
     version = parseFloat(versionStr);
     if(version == NaN)
      version = -1;
    }
   }
  }
  if(!browserType)
   browserType = defaultBrowserType;
  if(version == -1)
   version = defaultVersions[browserType];
  if(!ignoreDocumentMode && browserType == "IE" && version > 7 && document.documentMode < version) {
   version = document.documentMode;
  }
  var platform;
  var minOccurenceIndex = Number.MAX_VALUE;
  for(var identStr in platformIdentStrings) {
   var occurenceIndex = userAgent.indexOf(identStr);
   if(occurenceIndex >= 0 && occurenceIndex < minOccurenceIndex) {
    minOccurenceIndex = occurenceIndex;
    platform = platformIdentStrings[identStr];
   }
  }
  if(!platform)
   platform = defaultPlatform;
  _aspxFillUserAgentInfo(browserTypesOrderedList, browserType, version, platform);
 } catch(e) {
  _aspxFillUserAgentInfo(browserTypesOrderedList, defaultBrowserType, defaultVersions[defaultBrowserType], defaultPlatform);
 }
}
function _aspxFillUserAgentInfo(browserTypesOrderedList, browserType, version, platform) {
 for(var i = 0; i < browserTypesOrderedList.length; i++) { 
  var type = browserTypesOrderedList[i];
  window["__aspx" + type] = type == browserType;
 }
 __aspxBrowserVersion = Math.floor(10.0 * version) / 10.0;
 __aspxBrowserMajorVersion = Math.floor(__aspxBrowserVersion);
 __aspxWindowsPlatform = platform == "Win";
 __aspxMacOSPlatform = platform == "Mac";
 __aspxMacOSMobilePlatform = platform == "MacMobile";
 __aspxWebKitFamily = __aspxSafari || __aspxChrome;
 __aspxNetscapeFamily = __aspxNetscape || __aspxMozilla || __aspxFirefox;
 __aspxBrowserWithHardwareAcceleration = (__aspxIE && __aspxBrowserMajorVersion >= 9) || ( __aspxFirefox && __aspxBrowserMajorVersion >= 4);
}
_aspxIdentUserAgent(__aspxUserAgent);
function _aspxArrayInsert(array, element, position){
 if(0 <= position && position < array.length){
  for(var i = array.length; i > position; i --)
   array[i] = array[i - 1];
  array[position] = element;
 }
 else
  array.push(element);
}
function _aspxArrayRemove(array, element){
 var index = _aspxArrayIndexOf(array, element);
 if(index > -1) _aspxArrayRemoveAt(array, index);
}
function _aspxArrayRemoveAt(array, index){
 if(index >= 0  && index < array.length){
  for(var i = index; i < array.length - 1; i++)
   array[i] = array[i + 1];
  array.pop();
 }
}
function _aspxArrayClear(array){
 while(array.length > 0)
  array.pop();
}
function _aspxArrayIndexOf(array, element, comparer) {
 if(!comparer) {
  for(var i = 0; i < array.length; i++) {
   if(array[i] == element)
    return i;
  }
 } else {
  for(var i = 0; i < array.length; i++) {
   if(comparer(array[i], element))
    return i;
  }
 }
 return -1;
}
function _aspxArrayIntegerAscendingSort(array){
 array.sort(function(i1, i2){
  if (i1 > i2)
   return 1;
  else if (i1 < i2)
   return -1;
  else
   return 0;
 });
}
function _aspxCollectionsUnionToArray(firstCollection, secondCollection) {
 var result = [];
 var firstCollectionLength = firstCollection.length;
 var secondCollectionLength = secondCollection.length;
 for(var i = 0; i <  firstCollectionLength + secondCollectionLength; i++) {
  if(i < firstCollectionLength) 
   result.push(firstCollection[i]);
  else 
   result.push(secondCollection[i - firstCollectionLength]);
 }  
 return result;
}
function _aspxCollectionToArray(collection) {
 var array = [];
 for(var i = 0; i < collection.length; i++)
  array.push(collection[i]);
 return array;
}
function _aspxCreateHashTableFromArray(array) {
 var hash = [];
 for(var i = 0; i < array.length; i++)
  hash[array[i]] = 1;
 return hash;
}
function _aspxCreateIndexHashTableFromArray(array) {
 var hash = [];
 for(var i = 0; i < array.length; i++)
  hash[array[i]] = i;
 return hash;
}
var __aspxDefaultBinarySearchComparer = function(arrayElement, value) {
 if(arrayElement == value)
  return 0;
 else
  return arrayElement < value ? -1 : 1;
};
function _aspxArrayBinarySearch(array, value, binarySearchComparer, startIndex, length) {
 if(!binarySearchComparer)
  binarySearchComparer = __aspxDefaultBinarySearchComparer;
 if(!_aspxIsExists(startIndex))
  startIndex = 0;
 if(!_aspxIsExists(length))
  length = array.length - startIndex;  
 var endIndex = (startIndex + length) - 1;
 while (startIndex <= endIndex) {
  var middle =  (startIndex + ((endIndex - startIndex) >> 1));
  var compareResult = binarySearchComparer(array[middle], value);
  if (compareResult == 0)
   return middle;
  if (compareResult < 0)
   startIndex = middle + 1;
  else
   endIndex = middle - 1;
 }
 return -(startIndex + 1);
}
function _aspxApplyReplacement(text, replecementTable) {
 for(var i = 0; i < replecementTable.length; i++) {
  var replacement = replecementTable[i];
  text = text.replace(replacement[0], replacement[1]);
 }
 return text;
}
function _aspxEncodeHtml(html) {
 return _aspxApplyReplacement(html, [
  [ /&quot;/g, '&quotx;' ], [ /"/g, '&quot;' ],
  [ /&amp;/g,  '&ampx;'  ], [ /&/g, '&amp;'  ],
  [ /&lt;/g,   '&ltx;'   ], [ /</g, '&lt;'   ],
  [ /&gt;/g,   '&gtx;'   ], [ />/g, '&gt;'   ]
 ]);
}
function _aspxDecodeHtml(html) {
 return _aspxApplyReplacement(html, [
  [ /&gt;/g,   '>' ], [ /&gtx;/g,  '&gt;'   ],
  [ /&lt;/g,   '<' ], [ /&ltx;/g,  '&lt;'   ],
  [ /&amp;/g,  '&' ], [ /&ampx;/g, '&amp;'  ],
  [ /&quot;/g, '"' ], [ /&quotx;/g,'&quot;' ]
 ]);
}
function _aspxParseShortcutString(shortcutString) {
 if(!shortcutString)
  return 0;
 var isCtrlKey = false;
 var isShiftKey = false;
 var isAltKey = false;
 var keyCode = null;
 var shcKeys = shortcutString.toString().split("+");
 if (shcKeys.length > 0) {
  for (var i = 0; i < shcKeys.length; i++) {
   var key = _aspxTrim(shcKeys[i].toUpperCase());
   switch (key) {
    case "CTRL":
     isCtrlKey = true;
     break;
    case "SHIFT":
     isShiftKey = true;
     break;
    case "ALT":
     isAltKey = true;
     break;
    case "F1": keyCode = ASPxKey.F1; break;
    case "F2": keyCode = ASPxKey.F2; break;
    case "F3": keyCode = ASPxKey.F3; break;
    case "F4": keyCode = ASPxKey.F4; break;
    case "F5": keyCode = ASPxKey.F5; break;
    case "F6": keyCode = ASPxKey.F6; break;
    case "F7": keyCode = ASPxKey.F7; break;
    case "F8": keyCode = ASPxKey.F8; break;
    case "F9": keyCode = ASPxKey.F9; break;
    case "F10":   keyCode = ASPxKey.F10; break;
    case "F11":   keyCode = ASPxKey.F11; break;
    case "F12":   keyCode = ASPxKey.F12; break;
    case "ENTER": keyCode = ASPxKey.Enter; break;
    case "HOME":  keyCode = ASPxKey.Home; break;
    case "END":   keyCode = ASPxKey.End; break;
    case "LEFT":  keyCode = ASPxKey.Left; break;
    case "RIGHT": keyCode = ASPxKey.Right; break;
    case "UP": keyCode = ASPxKey.Up; break;
    case "DOWN":  keyCode = ASPxKey.Down; break;
    case "PAGEUP": keyCode = ASPxKey.PageUp; break;
    case "PAGEDOWN": keyCode = ASPxKey.PageDown; break;
    case "SPACE": keyCode = ASPxKey.Space; break;
    case "TAB":   keyCode = ASPxKey.Tab; break;
    case "BACK":  keyCode = ASPxKey.Backspace; break;
    case "CONTEXT": keyCode = ASPxKey.ContextMenu; break;
    case "ESCAPE":
    case "ESC":
     keyCode = ASPxKey.Esc;
     break;
    case "DELETE":
    case "DEL":
     keyCode = ASPxKey.Delete;
     break;
    case "INSERT":
    case "INS":
     keyCode = ASPxKey.Insert;
     break;
    case "PLUS":
     keyCode = "+".charCodeAt(0);
     break;
    default:
     keyCode = key.charCodeAt(0);
     break;
   }
  }
 } else
  alert("Invalid shortcut");
 return _aspxGetShortcutCode(keyCode, isCtrlKey, isShiftKey, isAltKey);
}
function _aspxGetShortcutCode(keyCode, isCtrlKey, isShiftKey, isAltKey) {
 var value = keyCode & 0xFFFF;
 var flags = 0;
 flags |= isCtrlKey ? 1 << 0 : 0;
 flags |= isShiftKey ? 1 << 2 : 0;
 flags |= isAltKey ? 1 << 4 : 0;
 value |= flags << 16;
 return value;
}
function _aspxGetShortcutCodeByEvent(evt) {
 return _aspxGetShortcutCode(_aspxGetKeyCode(evt), evt.ctrlKey, evt.shiftKey, evt.altKey);
}
function _aspxIsPasteShortcut(evt){
 var keyCode = _aspxGetKeyCode(evt);
 if (__aspxNetscapeFamily && evt.which == 0)  
  keyCode = evt.keyCode;
 return (evt.ctrlKey && (keyCode == 118  || (keyCode == 86))) ||
     (evt.shiftKey && !evt.ctrlKey && !evt.altKey &&
     (keyCode == ASPxKey.Insert)) ;
}
var ASPxImageUtils = {
 IsAlphaFilterNeed: function(src){
  return __aspxIE && __aspxBrowserVersion < 7 && this.IsPng(src);
 },
 IsPng: function(src){
  return src.slice(-3).toLowerCase() == "png";
 },
 GetImageFilterStyle: function(src){
  return "progid:DXImageTransform.Microsoft.AlphaImageLoader(src=" + src + ", sizingMethod=scale)";
 },
 GetImageSrc: function (image){
  if(_aspxIsAlphaFilterUsed(image)){ 
   var filter = image.style.filter;
   var regSrc = new RegExp("src=", "g");
   var regPng = new RegExp(".png", "g");
   var beginIndex = regSrc.exec(filter).lastIndex;
   var endIndex = regPng.exec(filter).lastIndex;
   return filter.substring(beginIndex, endIndex);
  } 
  return image.src;
 },
 SetImageSrc: function(image, src){
  var isAlphaFilterNeed = this.IsAlphaFilterNeed(src);
  if(isAlphaFilterNeed){
   image.src = __aspxEmptyImageUrl;
   image.style.filter = this.GetImageFilterStyle(src);
  } else {
   image.src = src;
   image.style.filter = "";
  }
 },
 SetSize: function(image, width, height){
  image.style.width = width + "px";
  image.style.height = height + "px";
 },
 GetSize: function(image, isWidth){
  return (isWidth ? image.offsetWidth : image.offsetHeight);
 }
};
function _aspxAddAlphaImageLoaderTarget(id, imageUrl) {
 if(!window._aspxAlphaImageLoaderTargets)
  window._aspxAlphaImageLoaderTargets = [];
 window._aspxAlphaImageLoaderTargets.push({ elementId: id, bgImageUrl: imageUrl });
}
function _aspxEnsureAlphaImageLoaderApplierRegistered() {
 if(!window._aspxPostponedAlphaImageLoaderApplierAdded) {
  var handler = function() {
   if(window._aspxAlphaImageLoaderTargets) {
    for(var i = 0; i < window._aspxAlphaImageLoaderTargets.length; i++) {
     var target = window._aspxAlphaImageLoaderTargets[i];
     _aspxApplyAlphaImageLoaderToBackground(target.elementId, target.bgImageUrl);
    }
    window._aspxAlphaImageLoaderTargets = [];
   }
  };
  if(typeof(aspxGetControlCollection) == "function")
   aspxGetControlCollection().ControlsInitialized.AddHandler(handler);
  else
   window.attachEvent("onload", handler);
  window._aspxPostponedAlphaImageLoaderApplierAdded = true;
 }
}
function _aspxApplyAlphaImageLoaderToBackground(elementId, bgImageUrl) {
 var element = document.all[elementId];
 if(element && element.length)
  element = document.getElementById(elementId);
 element.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src=" + bgImageUrl + ", sizingMethod=crop)";
}
function _aspxApplyAlphaImageLoaderToImage(image) {
 if(image.alphaImageLoaderApplied)
  return;
 if(window.__aspxEmptyImageUrl) {
  image.alphaImageLoaderApplied = true;
  var imageUrl = image.src;
  image.src = window.__aspxEmptyImageUrl;
  image.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src=" + imageUrl + ", sizingMethod=scale)";
 } else {
  var token = window.setInterval(function() {
   if(window.__aspxEmptyImageUrl) {
    _aspxApplyAlphaImageLoaderToImage(image);
    window.clearInterval(token);
   }
  }, 100);
 }
}
var __aspxVerticalScrollBarWidth;
function _aspxGetVerticalScrollBarWidth() {
 if(typeof(__aspxVerticalScrollBarWidth) == "undefined") {
  var container = document.createElement("DIV");
  container.style.cssText = "position: absolute; top: 0px; left: 0px; visibility: hidden; width: 200px; height: 150px; overflow: hidden";
  document.body.appendChild(container);
  var child = document.createElement("P");
  container.appendChild(child);
  child.style.cssText = "width: 100%; height: 200px;";
  var widthWithoutScrollBar = child.offsetWidth;
  container.style.overflow = "scroll";
  var widthWithScrollBar = child.offsetWidth;
  if(widthWithoutScrollBar == widthWithScrollBar)
   widthWithScrollBar = container.clientWidth;
  __aspxVerticalScrollBarWidth = widthWithoutScrollBar - widthWithScrollBar;
  document.body.removeChild(container);
 }
 return __aspxVerticalScrollBarWidth;
}
function _aspxGetVerticalOverflow(element) {
 if(__aspxIE || __aspxSafari && __aspxBrowserVersion >= 3 || __aspxChrome)
  return element.style.overflowY;
 return element.style.overflow;
}
function _aspxSetVerticalOverflow(element, value) {
 if(__aspxIE || __aspxSafari && __aspxBrowserVersion >= 3 || __aspxChrome)
  element.style.overflowY = value;
 else
  element.style.overflow = value;
}
function _aspxHideScrollBarCore(element, scrollName) {
 if(element.tagName == "IFRAME") {
  if((element.scrolling == "yes") || (element.scrolling == "auto")) {
   _aspxChangeAttribute(element, "scrolling", "no");
   return true;
  }
 }
 else if(element.tagName == "DIV") {
  if((element.style[scrollName] == "scroll") || (element.style[scrollName] == "auto")) {
   _aspxChangeStyleAttribute(element, scrollName, "hidden");
   return true;
  }
 }
 return false;
}
function _aspxRestoreScrollBarCore(element, scrollName) {
 if(element.tagName == "IFRAME")
  return _aspxRestoreAttribute(element, "scrolling");
 else if(element.tagName == "DIV")
  return _aspxRestoreStyleAttribute(element, scrollName);
 return false;
}
function _aspxSetScrollBarVisibilityCore(element, scrollName, isVisible) {
 return isVisible ? _aspxRestoreScrollBarCore(element, scrollName) : _aspxHideScrollBarCore(element, scrollName);
}
function _aspxSetScrollBarVisibility(element, isVisible) {
 if(_aspxSetScrollBarVisibilityCore(element, "overflow", isVisible)) 
  return true;
 var result = _aspxSetScrollBarVisibilityCore(element, "overflowX", isVisible)
  || _aspxSetScrollBarVisibilityCore(element, "overflowY", isVisible);
 return result;
}
function _aspxSetTimeout(callString, timeout){
 return window.setTimeout(callString, timeout);
}
function _aspxClearTimer(timerID){
 if(timerID > -1)
  window.clearTimeout(timerID);
 return -1;
}
function _aspxSetInterval(callString, interval){
 return window.setInterval(callString, interval);
}
function _aspxClearInterval(timerID){
 if(timerID > -1)
  window.clearInterval(timerID);
 return -1;
}
function _aspxSetInnerHtml(element, html) {
 if(__aspxIE) {
  element.innerHTML = "<em>&nbsp;</em>" + html;
  element.removeChild(element.firstChild);
 } else
  element.innerHTML = html;
}
function _aspxGetInnerText(container) {
 if (__aspxNetscapeFamily)
  return container.textContent;
 else if (__aspxWebKitFamily) {
  var filter = _aspxGetHtml2PlainTextFilter();
  filter.innerHTML = container.innerHTML;
  _aspxSetElementDisplay(filter, true);
  var innerText = filter.innerText;
  _aspxSetElementDisplay(filter, false);
  return innerText;
 } else
  return container.innerText;
}
var __aspxHtml2PlainTextFilter = null;
function _aspxGetHtml2PlainTextFilter() {
 if (__aspxHtml2PlainTextFilter == null) {
  __aspxHtml2PlainTextFilter = document.createElement("DIV");
  __aspxHtml2PlainTextFilter.style.width = "0";
  __aspxHtml2PlainTextFilter.style.height = "0";
  __aspxHtml2PlainTextFilter.style.overflow = "visible";
  _aspxSetElementDisplay(__aspxHtml2PlainTextFilter, false);
  document.body.appendChild(__aspxHtml2PlainTextFilter);
 }
 return __aspxHtml2PlainTextFilter;
}
function _aspxCreateHiddenField(name, id) {
 var input = document.createElement("INPUT");
 input.setAttribute("type", "hidden");
 if(name)
  input.setAttribute("name", name);
 if(id)
  input.setAttribute("id", id);
 return input;
}
function _aspxCloneObject(srcObject) {
  if(typeof(srcObject) != 'object' || srcObject == null)
 return srcObject;
  var newObject = { };
  for(var i in srcObject) 
 newObject[i] = srcObject[i];
  return newObject;
}
function _aspxIsExists(obj){
 return (typeof(obj) != "undefined") && (obj != null);
}
function _aspxIsFunction(obj){
 return typeof(obj) == "function";
}
function _aspxGetDefinedValue(value, defaultValue){
 return (typeof(value) != "undefined") ? value : defaultValue;
}
function _aspxGetKeyCode(srcEvt) {
 return __aspxNetscapeFamily || __aspxOpera ? srcEvt.which : srcEvt.keyCode;
}
function _aspxSetInputSelection(input, startPos, endPos){
 startPos = _aspxGetDefinedValue(startPos, 0);
 endPos = _aspxGetDefinedValue(endPos, input.value.length);
 if (__aspxIE) {
  var range = input.createTextRange();
  range.collapse(true);
  range.moveStart("character", startPos);
  range.moveEnd("character", endPos - startPos);
  range.select();
 } else {
  try {
   input.setSelectionRange(startPos, endPos);
  } catch(e) { }
 }
}
function _aspxClearInputSelection(input, carretPos){
 var length = typeof(carretPos) == "undefined" ?  input.value.length : carretPos;
 _aspxSetSelection(input, length, length); 
}
function _aspxGetSelectionInfo(input) {
 var start, end;
 if(__aspxIE){
  var range = document.selection.createRange();
  var rangeCopy = range.duplicate();
  range.move('character', -input.value.length);
  range.setEndPoint('EndToStart', rangeCopy);
  start = range.text.length;
  end = start + rangeCopy.text.length;
 } else {
  start = input.selectionStart;
  end = input.selectionEnd;
 }
 return { startPos: start, endPos: end };
}
function  _aspxHasInputSelection(input){
 var selectionInfo = _aspxGetSelectionInfo(input);
 return selectionInfo.startPos == selectionInfo.endPos;
}
function _aspxPreventElementDrag(element) {
 if(__aspxIE)
  _aspxAttachEventToElement(element, "dragstart", _aspxPreventEvent);
 else
  _aspxAttachEventToElement(element, "mousedown", _aspxPreventEvent);
}
function _aspxPreventElementDragAndSelect(element, skipMouseMove, skipIESelect) {
 if (__aspxWebKitFamily)
  _aspxAttachEventToElement(element, "selectstart", _aspxPreventEventAndBubble);
 if (__aspxIE) {
  if (!skipIESelect)
   _aspxAttachEventToElement(element, "selectstart", _aspxFalseFunction);
  if (!skipMouseMove)
   _aspxAttachEventToElement(element, "mousemove", _aspxClearSelectionOnMouseMove);
  _aspxAttachEventToElement(element, "dragstart", _aspxPreventDragStart);
 }
}
function _aspxSetElementAsUnselectable(element, isWithChild) {
 if (element && element.nodeType == 1) {
  element.unselectable = "on";
  if (__aspxNetscapeFamily)
   element.onmousedown = _aspxFalseFunction;
  if(isWithChild === true){
   for(var j = 0; j < element.childNodes.length; j ++)
    _aspxSetElementAsUnselectable(element.childNodes[j]);
  }
 }
}
function _aspxIsWidthSetInPercentage(width) {
 return width.indexOf('%') != -1;
}
function _aspxClearSelection() {
 try {
  if (window.getSelection) {
   if (__aspxWebKitFamily)
    window.getSelection().collapse();
   else
    window.getSelection().removeAllRanges();
  }
  else if (document.selection) {
   if(document.selection.empty)
    document.selection.empty();
   else if(document.selection.clear)
    document.selection.clear();
  }
 } catch(e) {
 }
}
function _aspxClearSelectionOnMouseMove(evt) {
 if (!__aspxIE || (evt.button != 0)) 
  _aspxClearSelection();
}
function _aspxPreventDragStart(evt) {
 evt = _aspxGetEvent(evt);
 var element = _aspxGetEventSource(evt);
 element.releaseCapture(); 
 return false;
}
function _aspxSetElementSelectionEnabled(element, value) {
 var userSelectValue = value ? "" : "none";
 var func = value ? _aspxDetachEventFromElement : _aspxAttachEventToElement;
 if(__aspxFirefox)
  element.style.MozUserSelect = userSelectValue;
 else if(__aspxWebKitFamily)
  element.style.KhtmlUserSelect = userSelectValue;
 else if(__aspxOpera)
  func(element, "mousemove", _aspxClearSelection);
 else {
  func(element, "selectstart", _aspxFalseFunction);
  func(element, "mousemove", _aspxClearSelection);
 }
}
function _aspxGetElementById(id) {
 if(document.getElementById)
  return document.getElementById(id);
 else
  return document.all[id];
}
function _aspxGetInputElementById(id) {
 var elem = _aspxGetElementById(id);
 if(!__aspxIE)
  return elem;
 if(elem) {
  if(elem.id == id)
   return elem;
  else {
   for(var i = 1; i < document.all[id].length; i++) {
    if(document.all[id][i].id == id)
     return document.all[id][i];
   }
  }
 }
 return null;
}
function _aspxGetElementByIdInDocument(documentObj, id) {
 if(documentObj.getElementById)
  return documentObj.getElementById(id);
 else
  return documentObj.all[id];
}
function _aspxGetIsParent(parentElement, element) {
 while(element != null){
  if(element == parentElement)
   return true;
  if(element.tagName == "BODY")
   return false;
  element = element.parentNode;
 }
 return false;
}
function _aspxGetParentById(element, id) {
 element = element.parentNode;
 while(element != null){
  if(element.id == id)
   return element;
  element = element.parentNode;
 }
 return null;
}
function _aspxGetParentByTagName(element, tagName) {
 tagName = tagName.toUpperCase();
 while(element != null) {
  if(element.tagName == "BODY")
   return null;
  if(element.tagName == tagName)
   return element;
  element = element.parentNode;
 }
 return null;
}
function _aspxElementHasCssClass(element, className) {
 return !!element.className.match("(^|\\s)" + className + "(\\s|$)");
}
function _aspxElementCssClassContains(element, className) {
 return element.className.indexOf(className) != -1;
}
function _aspxGetChildNodesByClassName(parent, className) {
 return _aspxGetChildNodes(parent, function(elem) { return elem.className && _aspxElementHasCssClass(elem, className); });
}
function _aspxGetDescendantNodesByClassName(parent, className) {
 return _aspxGetDescendantNodes(parent, function(elem) { return elem.className && _aspxElementHasCssClass(elem, className); });
}
function _aspxGetParentByClassNameInternal(element, className, selector) {
 while(element != null) {
  if(element.tagName == "BODY")
   return null;
  if(selector(element, className))
   return element;
  element = element.parentNode;
 }
 return null;
}
function _aspxGetParentByPartialClassName(element, className) {
 return _aspxGetParentByClassNameInternal(element, className, _aspxElementCssClassContains);
}
function _aspxGetParentByClassName(element, className) {
 return _aspxGetParentByClassNameInternal(element, className, _aspxElementHasCssClass);
}
function _aspxGetParentByTagNameAndAttributeValue(element, tagName, attrName, attrValue) {
 tagName = tagName.toUpperCase();
 while(element != null) {
  if(element.tagName == "BODY")
   return null;
  if(element.tagName == tagName && element[attrName] == attrValue)
   return element;
  element = element.parentNode;
 }
 return null;
}
function _aspxGetChildById(element, id) {
 if(!__aspxIE)
  return _aspxGetElementById(id);
 else{
  var element = element.all[id];
  if(!element)
   return null;
  else if(!_aspxIsExists(element.length)) 
   return element;
  else
   return _aspxGetElementById(id);
 }
}
function _aspxGetElementsByTagName(element, tagName) {
 tagName = tagName.toUpperCase();
 if(element != null){
  var elementAllExists = !!element.all;
  var opera10_50 = __aspxOpera && elementAllExists && !element.all.tags;
  if (elementAllExists && !opera10_50 && (!__aspxFirefox || __aspxBrowserVersion < 3))
   return __aspxNetscape ? element.all.tags[tagName] : element.all.tags(tagName);
  else
   return element.getElementsByTagName(tagName);
 }
 return null;
}
function _aspxGetChildByTagName(element, tagName, index) {
 if(element != null){    
  var collection = _aspxGetElementsByTagName(element, tagName);
  if(collection != null){
   if(index < collection.length)
    return collection[index];
  }
 }
 return null;
}
function _aspxRetrieveByPredicate(scourceCollection, predicate) {
 if(!predicate)
  return scourceCollection;
 var result = [];
 for(var i = 0; i < scourceCollection.length; i++) {
  var element = scourceCollection[i];
  if(predicate(element)) 
   result.push(element);
 }
 return result;
}
function _aspxGetChildNodes(parent, predicate) {
 return _aspxRetrieveByPredicate(parent.childNodes, predicate);
}
function _aspxGetDescendantNodes(parent, predicate) {
 var c = parent.all || parent.getElementsByTagName('*');
 return _aspxRetrieveByPredicate(c, predicate);
}
function _aspxGetElementNodes(parent) {
 if(!parent) return null;
 return _aspxGetChildNodes(parent, function(e) { return e.nodeType == 1 })
}
function _aspxGetElementNodesByPredicate(parent, predicate) {
 if(!parent) return null;
 if(!predicate) return _aspxGetElementNodes(parent);
 return _aspxGetChildNodes(parent, function(e) { return e.nodeType == 1 && predicate(e); })
}
function _aspxGetChildTextNode(element, index) {
 if(element != null){
  var collection = [ ];
  _aspxGetChildTextNodeCollection(element, collection);
  if(index < collection.length)
   return collection[index];
 }
 return null;
}
function _aspxGetChildTextNodeCollection(element, collection) {
 for(var i = 0; i < element.childNodes.length; i ++){
  var childNode = element.childNodes[i];
  if(_aspxIsExists(childNode.nodeValue))
   collection.push(childNode);
  _aspxGetChildTextNodeCollection(childNode, collection);
 }
}
function _aspxGetChildrenByPartialClassName(element, className) {
 var collection = element.all || element.getElementsByTagName('*');
 var ret = [ ];
 if(collection != null) {
  for(var i = 0; i < collection.length; i ++) {
   if(_aspxElementCssClassContains(collection[i], className))
    ret.push(collection[i]);
  }
 }
 return ret;
}
function _aspxGetParentByPartialId(element, idPart){
 while(element != null){
  if(element.id) {
   if(element.id.indexOf(idPart) > -1) return element;
  }
  element = element.parentNode;
 }
 return null;
}
function _aspxGetElementsByPartialId(element, partialName, list) {
 if(element.id && element.id.indexOf(partialName) > -1) {
  list.push(element);
 }
 if(element.childNodes)
 for(var i = 0; i < element.childNodes.length; i ++) {
  _aspxGetElementsByPartialId(element.childNodes[i], partialName, list);
 }
}
function _aspxGetElementDocument(element) {
 return element.document || element.ownerDocument;
}
function _aspxIFrameWindow(name) {
 if(__aspxIE)
  return window.frames[name].window;
 else{
  var frameElement = document.getElementById(name);
  return (frameElement != null) ? frameElement.contentWindow : null;
 }
}
function _aspxIFrameDocument(name) {
 if(__aspxIE)
  return window.frames[name].document;
 else{
  var frameElement = document.getElementById(name);
  return (frameElement != null) ? frameElement.contentDocument : null;
 }
}
function _aspxIFrameDocumentBody(name) {
 var doc = _aspxIFrameDocument(name);
 return (doc != null) ? doc.body : null;
}
function _aspxIFrameElement(name) {
 if(__aspxIE)
  return window.frames[name].window.frameElement;
 else
  return document.getElementById(name);
}
function _aspxRemoveElement(element) {
 if(element && element.parentNode)
  element.parentNode.removeChild(element);
}
function _aspxReplaceTagName(element, newTagName) {
 if (element.nodeType != 1)
  return null;
 if (element.nodeName == newTagName)
  return element;
 var doc = element.ownerDocument;
 var newElem = doc.createElement(newTagName);
 _aspxCopyAllAttributes(element, newElem);
 for (var i = 0; i < element.childNodes.length; i++)
  newElem.appendChild(element.childNodes[i].cloneNode(true));
 element.parentNode.replaceChild(newElem, element);
 return newElem;
}
function _aspxRemoveOuterTags(element) {
 if (__aspxIE) {
  element.insertAdjacentHTML( 'beforeBegin', element.innerHTML ) ;
  _aspxRemoveElement(element);
 } else {
  var docFragment = element.ownerDocument.createDocumentFragment();
  for (var i = 0; i < element.childNodes.length; i++)
   docFragment.appendChild(element.childNodes[i].cloneNode(true));
  element.parentNode.replaceChild(docFragment, element);
 }
}
function _aspxWrapElementInNewElement(element, newElementTagName) { 
 var wrapElement = null;
 if (__aspxIE) {
  var wrapElement = element.ownerDocument.createElement(newElementTagName);
  wrapElement.appendChild(element.cloneNode(true));
  element.parentNode.insertBefore(wrapElement, element);
  element.parentNode.removeChild(element);
 } else {
  var docFragment = element.ownerDocument.createDocumentFragment();
  wrapElement = element.ownerDocument.createElement(newElementTagName);
  docFragment.appendChild(wrapElement);
  wrapElement.appendChild(element.cloneNode(true));
  element.parentNode.replaceChild(docFragment, element);
 }
 return wrapElement;
}
function _aspxInsertElementAfter(newElement, targetElement) {
 var parentElem = targetElement.parentNode;
 if(parentElem.childNodes[parentElem.childNodes.length - 1] == targetElement)
  parentElem.appendChild(newElement);
 else
  parentElem.insertBefore(newElement, targetElement.nextSibling);
}
function _aspxGetEvent(evt){
 return (typeof(event) != "undefined" && event != null && __aspxIE) ? event : evt; 
}
function _aspxPreventEvent(evt){
 if (evt.preventDefault)
  evt.preventDefault();
 else
  evt.returnValue = false;
 return false;
}
function _aspxPreventEventAndBubble(evt){
 _aspxPreventEvent(evt);
 if (__aspxNetscapeFamily)
  evt.stopPropagation();
 evt.cancelBubble = true;
 return false;
}
function _aspxCancelBubble(evt){
 evt.cancelBubble = true;
 return false;
}
function _aspxGetEventSource(evt){
 evt = _aspxGetEvent(evt);
 if(!_aspxIsExists(evt)) return null; 
 return __aspxIE ? evt.srcElement : evt.target;
}
function _aspxGetEventX(evt){
 return evt.clientX  - _aspxGetIEDocumentClientOffsetInternal(true) + (__aspxSafari && __aspxBrowserVersion < 3 || __aspxMacOSMobilePlatform ? 0 : _aspxGetDocumentScrollLeft());
}
function _aspxGetEventY(evt){
 return evt.clientY - _aspxGetIEDocumentClientOffsetInternal(false) + (__aspxSafari && __aspxBrowserVersion < 3 || __aspxMacOSMobilePlatform ? 0 : _aspxGetDocumentScrollTop());
}
function _aspxGetIEDocumentClientOffsetInternal(IsX){
 var clientOffset = 0;
 if(__aspxIE){
  if(document.documentElement)
   clientOffset = IsX ? document.documentElement.clientLeft : document.documentElement.clientTop;
  if(clientOffset == 0 && document.body)
   var clientOffset = IsX ? document.body.clientLeft : document.body.clientTop;
 }
 return clientOffset;
}
function _aspxGetIsLeftButtonPressed(evt){
 evt = _aspxGetEvent(evt);
 if(!evt) return false;
 if(__aspxIE)
  return evt.button == 1;
 else if(__aspxNetscapeFamily || __aspxWebKitFamily)
  return evt.which == 1;
 else if (__aspxOpera)
  return evt.button == 0;  
 return true;  
}
function _aspxGetWheelDelta(evt){
 var ret = __aspxNetscapeFamily ? -evt.detail : evt.wheelDelta;
 if (__aspxOpera && __aspxBrowserVersion < 9)
  ret = -ret;
 return ret;
}
function _aspxDelCookie(name){
 _aspxSetCookieInternal(name, "", new Date(1970, 1, 1));
}
function _aspxGetCookie(name) {
 name = escape(name);
 var cookies = document.cookie.split(';');
 for(var i = 0; i < cookies.length; i++) {
  var cookie = _aspxTrim(cookies[i]);
  if(cookie.indexOf(name + "=") == 0)
   return unescape(cookie.substring(name.length + 1, cookie.length));
  else if(cookie.indexOf(name + ";") == 0 || cookie === name)
   return "";
 }
 return null;
}
function _aspxSetCookie(name, value, expirationDate){
 if(!_aspxIsExists(value)) {
  _aspxDelCookie(name);
  return;
 }
 if(!ASPxIdent.IsDate(expirationDate)) {
  expirationDate = new Date();
  expirationDate.setFullYear(expirationDate.getFullYear() + 1);
 }
 _aspxSetCookieInternal(name, value, expirationDate);
}
function _aspxSetCookieInternal(name, value, date){
 document.cookie = escape(name) + "=" + escape(value.toString()) + "; expires=" + date.toGMTString() + "; path=/";
}
function _aspxGetElementDisplay(element){
 return element.style.display != "none";
}
function _aspxSetElementDisplay(element, value){
 element.style.display = value ? "" : "none";
}
function _aspxGetElementVisibility(element){
 return element.style.visibility != "hidden";
}
function _aspxSetElementVisibility(element, value){
 element.style.visibility = value ? "" : "hidden";
}
function _aspxElementIsVisible(element){
 while(element && element.tagName != "BODY") {
  if(!_aspxGetElementVisibility(element) || !_aspxGetElementDisplay(element))
     return false;
  element = element.parentNode;
 }
 return true;
}
function _aspxElementIsDisplayed(element) {
 while(element && element.tagName != "BODY") {
  if(!_aspxGetElementDisplay(element))
     return false;
  element = element.parentNode;
 }
 return true;
}
function _aspxAddStyleSheetLinkToDocument(doc, linkUrl) {
 var newLink = _aspxCreateStyleLink(doc, linkUrl);
 var head = _aspxGetHeadElementOrCreateIfNotExist(doc);
 head.appendChild(newLink);
}
function _aspxGetHeadElementOrCreateIfNotExist(doc) {
 var elements = _aspxGetElementsByTagName(doc, "head");
 var head = null;
 if (elements.length == 0) {
  head = doc.createElement("head");
  head.visibility = "hidden";
  doc.insertBefore(head, doc.body);
 } else
  head = elements[0];
 return head;
}
function _aspxCreateStyleLink(doc, url) {
 var newLink = doc.createElement("link");
 _aspxSetAttribute(newLink, "href", url);
 _aspxSetAttribute(newLink, "type", "text/css");
 _aspxSetAttribute(newLink, "rel", "stylesheet");
 return newLink;
}
function _aspxGetCurrentStyle(element){
 if (__aspxIE)
  return element.currentStyle;
 else if (__aspxOpera && __aspxBrowserVersion < 9)
  return window.getComputedStyle(element, null);
 else
  return document.defaultView.getComputedStyle(element, null);
}
function _aspxIsElementRightToLeft(element) {
 return _aspxGetElementDirection(element) == "rtl";
}
function _aspxCreateStyleSheetInDocument(doc) {
 if(__aspxIE)
  return doc.createStyleSheet();
 else {
  var styleSheet = doc.createElement("STYLE");
  _aspxGetChildByTagName(doc, "HEAD", 0).appendChild(styleSheet);
  return styleSheet.sheet;
 }
}
function _aspxCreateStyleSheet(){
 return _aspxCreateStyleSheetInDocument(document);
}
function _aspxGetStyleSheetRules(styleSheet){
 try {
  return __aspxIE ? styleSheet.rules : styleSheet.cssRules;
 }
 catch(e) {
  return null;
 }
}
function _aspxGetStyleSheetRule(className){
 if(__aspxCachedRules[className]) {
  if(__aspxCachedRules[className] != __aspxEmptyCachedValue)
   return __aspxCachedRules[className];
  return null;
 }
 for(var i = 0; i < document.styleSheets.length; i ++){
  var styleSheet = document.styleSheets[i];
  var rules = _aspxGetStyleSheetRules(styleSheet);
  if(rules != null){
   for(var j = 0; j < rules.length; j ++){
    if(rules[j].selectorText == "." + className){
     __aspxCachedRules[className] = rules[j];
     return rules[j];
    }
   }
  }
 }
 __aspxCachedRules[className] = __aspxEmptyCachedValue;
 return null;
}
function _aspxCreateImportantStyleRule(styleSheet, cssText) {
 if(__aspxStyleNameCache[cssText])
  return __aspxStyleNameCache[cssText];
 var newText = "";
 var attributes = cssText.split(";");
 for(var i = 0; i < attributes.length; i++){
  if(attributes[i] != "")
   newText += attributes[i] + " !important;";
 }
 var className = "dxh" + __aspxStyleCount;
 _aspxAddStyleSheetRule(styleSheet, "." + className, newText);
 __aspxStyleCount++;
 __aspxStyleNameCache[cssText] = className;
 return className; 
}
function _aspxRemoveStyleSheetRule(styleSheet, index){
 var rules = _aspxGetStyleSheetRules(styleSheet);
 if(rules != null && rules.length > 0 && rules.length >= index){
  if(__aspxIE)
   styleSheet.removeRule(index);
  else   
   styleSheet.deleteRule(index);  
 }    
}
function _aspxAddStyleSheetRule(styleSheet, selector, cssText){
 if(!cssText) return;
 if(__aspxIE)
  styleSheet.addRule(selector, cssText);
 else
  styleSheet.insertRule(selector + " { " + cssText + " }", styleSheet.cssRules.length);
}
function _aspxGetPointerCursor() {
 return "pointer";
}
function _aspxSetPointerCursor(element) {
 if(element.style.cursor == "")
  element.style.cursor = _aspxGetPointerCursor();
}
function _aspxSetElementFloat(element, value) {
 if(_aspxIsExists(element.style.cssFloat))
  element.style.cssFloat = value;
 else if(_aspxIsExists(element.style.styleFloat))
  element.style.styleFloat = value;
 else
  _aspxSetAttribute(element.style, "float", value);
}
function _aspxGetElementFloat(element) {
 var currentStyle = _aspxGetCurrentStyle(element);
 if(_aspxIsExists(currentStyle.cssFloat))
  return currentStyle.cssFloat;
 if(_aspxIsExists(currentStyle.styleFloat))
  return currentStyle.styleFloat;
 return _aspxGetAttribute(currentStyle, "float");
}
function _aspxGetElementDirection(element) {
 return _aspxGetCurrentStyle(element).direction;
}
function _aspxSetElementDirection(element, value) {
 element.style.direction = value;
}
var _aspxWebKit3TDRealInfo = {
 GetOffsetTop: function(tdElement){
  switch(_aspxGetCurrentStyle(tdElement).verticalAlign){
   case "middle":
    return Math.round(tdElement.offsetTop - (tdElement.offsetHeight - tdElement.clientHeight )/2 + tdElement.clientTop);
   case "bottom":
    return tdElement.offsetTop - tdElement.offsetHeight + tdElement.clientHeight + tdElement.clientTop;
  }
  return tdElement.offsetTop;
 },
 GetClientHeight: function(tdElement){
  var valign = _aspxGetCurrentStyle(tdElement).verticalAlign;
  switch(valign){
   case "middle":
    return tdElement.clientHeight + tdElement.offsetTop * 2;
   case "top":
    return tdElement.offsetHeight - tdElement.clientTop * 2;
   case "bottom":
    return tdElement.clientHeight + tdElement.offsetTop;
  }
  return tdElement.clientHeight;
 }
}
function _aspxGetIsValidPosition(pos){
 return pos != __aspxInvalidPosition && pos != -__aspxInvalidPosition;
}
function _aspxGetAbsoluteX(curEl){
 return _aspxGetAbsolutePositionX(curEl);
}
function _aspxGetAbsoluteY(curEl){
 return _aspxGetAbsolutePositionY(curEl);
}
function _aspxSetAbsoluteX(element, x){
 element.style.left = _aspxPrepareClientPosForElement(x, element, true) + "px";
}
function _aspxSetAbsoluteY(element, y){
 element.style.top = _aspxPrepareClientPosForElement(y, element, false) + "px";
}
function _aspxGetAbsolutePositionX(element){
 if (__aspxIE)
  return _aspxGetAbsolutePositionX_IE(element);
 else if (__aspxFirefox && __aspxBrowserVersion >= 3)
  return _aspxGetAbsolutePositionX_FF3(element);
 else if (__aspxOpera)
  return _aspxGetAbsolutePositionX_Opera(element);
 else if(__aspxNetscapeFamily && (!__aspxFirefox || __aspxBrowserVersion < 3))
  return _aspxGetAbsolutePositionX_NS(element);
 else if(__aspxWebKitFamily)
  return _aspxGetAbsolutePositionX_Safari(element);
 else
  return _aspxGetAbsolutePositionX_Other(element);
}
function _aspxGetAbsolutePositionX_Opera(curEl){
 var isFirstCycle = true;
 var pos = _aspxGetAbsoluteScrollOffset_OperaFF(curEl, true);
 while (curEl != null) {
  pos += curEl.offsetLeft;
  if(!isFirstCycle)
   pos -= curEl.scrollLeft;
  curEl = curEl.offsetParent;
  isFirstCycle = false;
 }
 pos += document.body.scrollLeft;
 return pos;
}
function _aspxGetAbsolutePositionX_IE(element){
 if(element == null || __aspxIE && element.parentNode == null) return 0; 
 return element.getBoundingClientRect().left + _aspxGetDocumentScrollLeft() - _aspxGetIEDocumentClientOffsetInternal(true);
}
function _aspxGetAbsolutePositionX_FF3(element){
 if(element == null) return 0;
 var x = element.getBoundingClientRect().left + _aspxGetDocumentScrollLeft();
 return Math.round(x);
}
function _aspxGetAbsolutePositionX_NS(curEl){
 var pos = _aspxGetAbsoluteScrollOffset_OperaFF(curEl, true);
 var isFirstCycle = true;
 while (curEl != null) {
  pos += curEl.offsetLeft;
  if (!isFirstCycle && curEl.offsetParent != null)
   pos -= curEl.scrollLeft;
  if (!isFirstCycle && __aspxFirefox){
   var style = _aspxGetCurrentStyle(curEl);
   if(curEl.tagName == "DIV" && style.overflow != "visible")
    pos += _aspxPxToInt(style.borderLeftWidth);
  }
  isFirstCycle = false;
  curEl = curEl.offsetParent;
 }
 return pos;
}
function _aspxGetAbsolutePositionX_Safari(curEl){
 var pos = _aspxGetAbsoluteScrollOffset_WebKit(curEl, true);
 var isSafariVerNonLessThan3OrChrome = __aspxSafari && __aspxBrowserVersion >= 3 || __aspxChrome;
 if(curEl != null){
  var isFirstCycle = true;
  if(isSafariVerNonLessThan3OrChrome && curEl.tagName == "TD") {
   pos += curEl.offsetLeft;
   curEl = curEl.offsetParent;
   isFirstCycle = false;
  }
  while (curEl != null) {
   pos += curEl.offsetLeft;
   if(isSafariVerNonLessThan3OrChrome && !isFirstCycle && (curEl.tagName == "TD" || curEl.tagName == "TABLE"))
    pos += curEl.clientLeft;
   isFirstCycle = false;
   curEl = curEl.offsetParent;
  }
 }
 return pos;
}
function _aspxGetAbsolutePositionX_Other(curEl){
 var pos = 0;
 var isFirstCycle = true;
 while (curEl != null) {
  pos += curEl.offsetLeft;
  if (!isFirstCycle && curEl.offsetParent != null)
   pos -= curEl.scrollLeft;
  isFirstCycle = false;
  curEl = curEl.offsetParent;
 }
 return pos;
}
function _aspxGetAbsolutePositionY(element){
 if (__aspxIE)
  return _aspxGetAbsolutePositionY_IE(element);
 else if (__aspxFirefox && __aspxBrowserVersion >= 3)
  return _aspxGetAbsolutePositionY_FF3(element);
 else if (__aspxOpera)
  return _aspxGetAbsolutePositionY_Opera(element);
 else if(__aspxNetscapeFamily && (!__aspxFirefox || __aspxBrowserVersion < 3))
  return _aspxGetAbsolutePositionY_NS(element);
 else if(__aspxWebKitFamily)
  return _aspxGetAbsolutePositionY_Safari(element);
 else
  return _aspxGetAbsolutePositionY_Other(element);
}
function _aspxGetAbsolutePositionY_Opera(curEl){
 var isFirstCycle = true;
 if(curEl && curEl.tagName == "TR" && curEl.cells.length > 0)
  curEl = curEl.cells[0];
 var pos = _aspxGetAbsoluteScrollOffset_OperaFF(curEl, false);
 while (curEl != null) {
  pos += curEl.offsetTop;
  if(!isFirstCycle)
   pos -= curEl.scrollTop;
  curEl = curEl.offsetParent;
  isFirstCycle = false;
 }
 pos += document.body.scrollTop;
 return pos;
}
function _aspxGetAbsolutePositionY_IE(element){
 if(element == null || __aspxIE && element.parentNode == null) return 0; 
 return element.getBoundingClientRect().top + _aspxGetDocumentScrollTop() - _aspxGetIEDocumentClientOffsetInternal(false);
}
function _aspxGetAbsolutePositionY_FF3(element){
 if(element == null) return 0;
 var y = element.getBoundingClientRect().top + _aspxGetDocumentScrollTop();
 return Math.round(y);
}
function _aspxGetAbsolutePositionY_NS(curEl){
 var pos = _aspxGetAbsoluteScrollOffset_OperaFF(curEl, false);
 var isFirstCycle = true;
 while (curEl != null) {
  pos += curEl.offsetTop;
  if (!isFirstCycle && curEl.offsetParent != null)
   pos -= curEl.scrollTop;
  if (!isFirstCycle && __aspxFirefox){
   var style = _aspxGetCurrentStyle(curEl);
   if(curEl.tagName == "DIV" && style.overflow != "visible")
    pos += _aspxPxToInt(style.borderTopWidth);
  }
  isFirstCycle = false;
  curEl = curEl.offsetParent;
 }
 return pos;
}
function _aspxGetAbsolutePositionY_Safari(curEl){
 var pos = _aspxGetAbsoluteScrollOffset_WebKit(curEl, false);
 var isSafariVerNonLessThan3OrChrome = __aspxSafari && __aspxBrowserVersion >= 3 || __aspxChrome;
 if(curEl != null){
  var isFirstCycle = true;
  if(isSafariVerNonLessThan3OrChrome && curEl.tagName == "TD") {
   pos += _aspxWebKit3TDRealInfo.GetOffsetTop(curEl);
   curEl = curEl.offsetParent;
   isFirstCycle = false;
  }
  while (curEl != null) {
   pos += curEl.offsetTop;
   if(isSafariVerNonLessThan3OrChrome && !isFirstCycle && (curEl.tagName == "TD" || curEl.tagName == "TABLE"))
    pos += curEl.clientTop;
   isFirstCycle = false;
   curEl = curEl.offsetParent;
  }
 }
 return pos;
}
function _aspxGetAbsoluteScrollOffset_OperaFF(curEl, isX) {
 var pos = 0;   
 var isFirstCycle = true;
 while (curEl != null) {
  if(curEl.tagName == "BODY")
   break;
  var style = _aspxGetCurrentStyle(curEl);
  if(style.position == "absolute")
   break;
  if(!isFirstCycle && curEl.tagName == "DIV" && (style.position == "" || style.position == "static"))
   pos -= isX ? curEl.scrollLeft : curEl.scrollTop;
  curEl = curEl.parentNode;
  isFirstCycle = false;
 }
 return pos; 
}
function _aspxGetAbsoluteScrollOffset_WebKit(curEl, isX) {
 var pos = 0;   
 var isFirstCycle = true;
 var step = 0;
 var absoluteWasFoundAtStep = -1;
 while (curEl != null) {
  if(curEl.tagName == "BODY")
   break;
  var style = _aspxGetCurrentStyle(curEl);
  var positionIsDefault = style.position == "" || style.position == "static";
  var absoluteWasFoundAtPreviousStep = absoluteWasFoundAtStep >= 0 && absoluteWasFoundAtStep < step;
  if(!isFirstCycle && curEl.tagName == "DIV" && (!positionIsDefault || !absoluteWasFoundAtPreviousStep))
   pos -= isX ? curEl.scrollLeft : curEl.scrollTop;
  if(style.position == "absolute")
   absoluteWasFoundAtStep = step;
  curEl = curEl.parentNode;
  isFirstCycle = false;
  step ++;
 }
 return pos; 
}
function _aspxGetAbsolutePositionY_Other(curEl){
 var pos = 0;
 var isFirstCycle = true;
 while (curEl != null) {
  pos += curEl.offsetTop;
  if (!isFirstCycle && curEl.offsetParent != null)
   pos -= curEl.scrollTop;
  isFirstCycle = false;
  curEl = curEl.offsetParent;
 }
 return pos;
}
function _aspxPrepareClientPosForElement(pos, element, isX) {
 pos -= _aspxGetPositionElementOffset(element, isX);
 return pos;
}
function _aspxGetIE8ElementOffset(element, isX) {
    var div = document.createElement('div');
    div.style.top = "0px";
    div.style.left = "0px";
    div.visibility = "hidden";
    div.style.position = _aspxGetCurrentStyle(element).position;
    element.parentNode.appendChild(div); 
    var realPos = isX ? _aspxGetAbsoluteX(div) : _aspxGetAbsoluteY(div);
    element.parentNode.removeChild(div);
    return realPos;
}
function _aspxTestElementParentsByFunc(element, func) {
 while(element) {  
  var tagName = element.tagName;
  if(tagName == "HTML" || tagName == "BODY" )
   return false;
  if(func(element)) 
   return true;
  element = element.parentNode; 
 }
 return false;   
}
function _aspxGetPositionElementOffset(element, isX) {
 var curEl = element.offsetParent;
 var offset = 0;
 var scroll = 0;
 var isThereFixedParent = false;
 var isFixed = false;
 var position = "";
 while(curEl != null) {
  var tagName = curEl.tagName;
  if(tagName == "HTML"){
   break;
  }
  if(tagName == "BODY"){
   if(!__aspxOpera && !__aspxChrome){
    var style = _aspxGetCurrentStyle(curEl);
    if(style.position != "" && style.position != "static"){
     offset += _aspxPxToInt(isX ? style.left : style.top);
     offset += _aspxPxToInt(isX ? style.marginLeft : style.marginTop);
    }
   }
   break;
  }
  if(tagName != "TD" && tagName != "TR") {
   var style = _aspxGetCurrentStyle(curEl);
   isFixed = style.position == "fixed";
   if(isFixed) {
    isThereFixedParent = true;
    if(__aspxIE && __aspxBrowserVersion >= 8) {
     return _aspxGetIE8ElementOffset(element, isX); 
    }
   }
   if (style.position == "absolute" || isFixed || style.position == "relative") {
    offset += isX ? curEl.offsetLeft : curEl.offsetTop;
    if (__aspxIE || __aspxOpera && __aspxBrowserVersion >= 9 || __aspxSafari && __aspxMacOSPlatform)
     offset += _aspxPxToInt(isX ? style.borderLeftWidth : style.borderTopWidth);
   }
  }
  scroll += isX ? curEl.scrollLeft : curEl.scrollTop;
  curEl = curEl.offsetParent;
 }
 offset -= scroll; 
 if((__aspxIE && __aspxBrowserVersion >= 7 || __aspxFirefox && __aspxBrowserVersion >= 3) && isThereFixedParent)
  offset += isX ? _aspxGetDocumentScrollLeft() : _aspxGetDocumentScrollTop();
 return offset;
}
function _aspxPxToInt(px) {
 return _aspxPxToNumber(px, parseInt);
}
function _aspxPxToFloat(px) {
 return _aspxPxToNumber(px, parseFloat);
}
function _aspxPxToNumber(px, parseFunction) {
 var result = 0;
 if (px != null && px != "") {
  try {
   var indexOfPx = px.indexOf("px");
   if (indexOfPx > -1)
    result = parseFunction(px.substr(0, indexOfPx));
  } catch(e) { }
 }
 return result;
}
function _aspxPercentageToFloat(perc) {
 var result = 0;
 if(perc != null && perc != "") {
  try {
   var indexOfPerc = perc.indexOf("%");
   if(indexOfPerc > -1)
    result = parseFloat(perc.substr(0, indexOfPerc)) / 100;
  } catch(e) { }
 }
 return result;
}
function _aspxGetLeftRightBordersAndPaddingsSummaryValue(element) {
 var currentStyle = _aspxGetCurrentStyle(element);
 var value = _aspxPxToInt(currentStyle.paddingLeft) + _aspxPxToInt(currentStyle.paddingRight);
 if(currentStyle.borderLeftStyle != "none")
  value += _aspxPxToInt(currentStyle.borderLeftWidth);
 if(currentStyle.borderRightStyle != "none")
  value += _aspxPxToInt(currentStyle.borderRightWidth);  
 return value;
}
function _aspxGetTopBottomBordersAndPaddingsSummaryValue(element) {
 var currentStyle = _aspxGetCurrentStyle(element);
 var value = _aspxPxToInt(currentStyle.paddingTop) + _aspxPxToInt(currentStyle.paddingBottom);
 if(currentStyle.borderTopStyle != "none")
  value += _aspxPxToInt(currentStyle.borderTopWidth);
 if(currentStyle.borderBottomStyle != "none")
  value += _aspxPxToInt(currentStyle.borderBottomWidth);
 return value;
}
function _aspxGetClearClientWidth(element) {
 return element.offsetWidth - _aspxGetLeftRightBordersAndPaddingsSummaryValue(element);
}
function _aspxGetClearClientHeight(element) {
 return element.offsetHeight - _aspxGetTopBottomBordersAndPaddingsSummaryValue(element);
}
function _aspxSetOffsetWidth(element, widthValue) {
 var currentStyle = _aspxGetCurrentStyle(element);
 var value = widthValue - _aspxPxToInt(currentStyle.marginLeft) - _aspxPxToInt(currentStyle.marginRight);
  value -= _aspxGetLeftRightBordersAndPaddingsSummaryValue(element);
 if(value > -1)
  element.style.width = value + "px";
}
function _aspxSetOffsetHeight(element, heightValue) {
 var currentStyle = _aspxGetCurrentStyle(element);
 var value = heightValue - _aspxPxToInt(currentStyle.marginTop) - _aspxPxToInt(currentStyle.marginBottom);
  value -= _aspxPxToInt(currentStyle.paddingTop) + _aspxPxToInt(currentStyle.paddingBottom) +
   _aspxPxToInt(currentStyle.borderTopWidth) + _aspxPxToInt(currentStyle.borderBottomWidth); 
 if(value > -1)
  element.style.height = value + "px";
}
function _aspxFindOffsetParent(element) {
 if(__aspxIE && __aspxBrowserVersion < 8)
  return element.offsetParent;
 var currentElement = element.parentNode;
 while(_aspxIsExistsElement(currentElement) && currentElement.tagName != "BODY") {
  if (currentElement.offsetWidth > 0 && currentElement.offsetHeight > 0)
   return currentElement;
  currentElement = currentElement.parentNode;
 }
 return document.body;
}
function _aspxGetDocumentScrollTop(){
 if(__aspxWebKitFamily || __aspxIE && __aspxBrowserVersion == 5.5 || document.documentElement.scrollTop == 0) {
  if(__aspxMacOSMobilePlatform) 
   return window.pageYOffset;
  else 
   return document.body.scrollTop;
 }
 else
  return document.documentElement.scrollTop;
}
function _aspxGetDocumentScrollLeft(){
 if(__aspxIE && __aspxBrowserVersion < 8) {
  var body = document.body || document.documentElement;
  if(_aspxIsElementRightToLeft(body))
   return body.scrollWidth - body.scrollLeft - body.clientWidth;
 }
 if(__aspxWebKitFamily || __aspxIE && __aspxBrowserVersion == 5.5 || document.documentElement.scrollLeft == 0)
  return document.body.scrollLeft;
 return document.documentElement.scrollLeft;
}
function _aspxGetDocumentClientWidth(){
 if(__aspxIE && __aspxBrowserVersion == 5.5 || document.documentElement.clientWidth == 0)
  return document.body.clientWidth;
 else
  return document.documentElement.clientWidth;
}
function _aspxGetDocumentClientHeight(){
 if(__aspxOpera) 
  return __aspxBrowserVersion >= 9.6 ? document.documentElement.clientHeight : document.body.clientHeight;
 else if(__aspxIE && __aspxBrowserVersion == 5.5 ||  document.documentElement.clientHeight == 0)
  return document.body.clientHeight;
 else
  return document.documentElement.clientHeight;
}
function _aspxSetStylePosition(element, x, y){
 element.style.left = x + "px";
 element.style.top = y + "px";
}
function _aspxSetStyleSize(element, width, height){
 element.style.width = width + "px";
 element.style.height = height + "px";
}
function _aspxGetDocumentWidth(){
 var bodyWidth = document.body.offsetWidth;
 var docWidth = (__aspxIE && __aspxBrowserMajorVersion != 7) ? document.documentElement.clientWidth : document.documentElement.offsetWidth;
 var bodyScrollWidth = document.body.scrollWidth;
 var docScrollWidth = document.documentElement.scrollWidth;
 return _aspxGetMaxDimensionOf(bodyWidth, docWidth, bodyScrollWidth, docScrollWidth);
}
function _aspxGetDocumentHeight(){
 var bodyHeight = document.body.offsetHeight;
 var docHeight = (__aspxIE && __aspxBrowserMajorVersion != 7) ? document.documentElement.clientHeight : document.documentElement.offsetHeight;
 var bodyScrollHeight = document.body.scrollHeight;
 var docScrollHeight = document.documentElement.scrollHeight;
 var maxHeight = _aspxGetMaxDimensionOf(bodyHeight, docHeight, bodyScrollHeight, docScrollHeight);
 if(__aspxOpera && __aspxBrowserVersion >= 9.6){
  if(__aspxBrowserVersion < 10)
   maxHeight = _aspxGetMaxDimensionOf(bodyHeight, docHeight, bodyScrollHeight);
  var visibleHeightOfDocument = document.documentElement.clientHeight;
  if(maxHeight > visibleHeightOfDocument)
   maxHeight = _aspxGetMaxDimensionOf(window.outerHeight, maxHeight);
  else
   maxHeight = document.documentElement.clientHeight;
  return maxHeight;
 }
 return maxHeight;
}
function _aspxGetDocumentMaxClientWidth(){
 var bodyWidth = document.body.offsetWidth;
 var docWidth = document.documentElement.offsetWidth;
 var docClientWidth = document.documentElement.clientWidth;
 return _aspxGetMaxDimensionOf(bodyWidth, docWidth, docClientWidth);
}
function _aspxGetDocumentMaxClientHeight(){
 var bodyHeight = document.body.offsetHeight;
 var docHeight = document.documentElement.offsetHeight;
 var docClientHeight = document.documentElement.clientHeight;
 return _aspxGetMaxDimensionOf(bodyHeight, docHeight, docClientHeight);
}
function _aspxGetMaxDimensionOf(){
 var max = __aspxInvalidDimension;
 for (var i = 0; i < arguments.length; i++){
  if(max < arguments[i])
   max = arguments[i];
 }
 return max;
}
function _aspxGetClientLeft(element){
 return _aspxIsExists(element.clientLeft) ? element.clientLeft : (element.offsetWidth - element.clientWidth) / 2;
}
function _aspxGetClientTop(element){
 return _aspxIsExists(element.clientTop) ? element.clientTop : (element.offsetHeight - element.clientHeight) / 2;
}
function _aspxRemoveBorders(element) {
 if(!element)
  return;
 element.style.borderWidth = 0;
 for(var i = 0; i < element.childNodes.length; i++) {
  var child = element.childNodes[i];
  if(child.style)
   child.style.border = "0";
 }
}
function _aspxSetBackground(element, background) {
 if(!element)
  return;
 element.style.backgroundColor = background;
 for(var i = 0; i < element.childNodes.length; i++) {
  var child = element.childNodes[i];
  if(child.style)
   child.style.backgroundColor = background;
 }
}
function _aspxDoElementClick(element) {
 try{
  element.click();
 }
 catch(e){ 
 }
}
function _aspxSetFocus(element) {
 window.setTimeout(function() { 
  try {
   element.focus();
   if (__aspxIE && document.activeElement != element)
    element.focus();
  } catch (e) {
  }
 }, 100);
}
function _aspxIsFocusableCore(element, skipContainerVisibilityCheck) {
 var current = element;
 while(current) {
  if (current == element || !skipContainerVisibilityCheck(current)) {
   if (current.tagName == "BODY")
    return true;
   if (current.disabled || !_aspxGetElementDisplay(current) || !_aspxGetElementVisibility(current))
    return false;
  }
  current = current.parentNode;
 }
 return true;
}
function _aspxIsFocusable(element) {
 return _aspxIsFocusableCore(element, _aspxFalseFunction);
}
function _aspxAttachEventToElement(element, eventName, func) {
 if(element.addEventListener)
  element.addEventListener(eventName, func, true);
 else
  element.attachEvent("on" + eventName, func);
}
function _aspxDetachEventFromElement(element, eventName, func) {
 if(element.removeEventListener)
  element.removeEventListener(eventName, func, true);
 else
  element.detachEvent("on" + eventName, func);
}
function _aspxAttachEventToDocument(eventName, func) {
 _aspxAttachEventToElement(document, eventName, func);
}
function _aspxDetachEventFromDocument(eventName, func) {
 _aspxDetachEventFromElement(document, eventName, func);
}
function _aspxCreateEventHandlerFunction(funcName, controlName, withHtmlEventArg) {
 return withHtmlEventArg ?
  new Function("event", funcName + "('" + controlName + "', event);") :
  new Function(funcName + "('" + controlName + "');");
}
function _aspxGetMouseWheelEventName(){
 return __aspxNetscapeFamily ? "DOMMouseScroll" : "mousewheel";
}
function _aspxCreateClass(parentClass, properties) {
 var ret = function() {
  if (ret.preparing) 
   return delete(ret.preparing);
  if (ret.constr) {
   this.constructor = ret;
   ret.constr.apply(this, arguments);
  }
 }
 ret.prototype = {};
 if(parentClass) {
  parentClass.preparing = true;
  ret.prototype = new parentClass;
  ret.prototype.constructor = parentClass;
  ret.constr = parentClass;
 }
 if(properties) {
  var constructorName = "constructor";
  for(var name in properties){
   if (name != constructorName) 
    ret.prototype[name] = properties[name];
  }
  if (properties[constructorName] && properties[constructorName] != Object)
   ret.constr = properties[constructorName];
 }
 return ret;
}
function _aspxGetAttribute(obj, attrName){
 if(obj.getAttribute)
  return obj.getAttribute(attrName);
 else if(obj.getPropertyValue)
  return obj.getPropertyValue(attrName);
 return null;
}
function _aspxSetAttribute(obj, attrName, value){
 if(obj.setAttribute)
  obj.setAttribute(attrName, value);
 else if(obj.setProperty)
  obj.setProperty(attrName, value, "");
}
function _aspxRemoveAttribute(obj, attrName){
 if(obj.removeAttribute)
  obj.removeAttribute(attrName);
 else if(obj.removeProperty)
  obj.removeProperty(attrName);
}
function _aspxIsExistsAttribute(obj, attrName){
 var value = _aspxGetAttribute(obj, attrName);
 return (value != null) && (value !== "");
}
function _aspxSetOrRemoveAttribute(obj, attrName, value) {
 if (!value)
  _aspxRemoveAttribute(obj, attrName);
 else
  _aspxSetAttribute(obj, attrName, value);
}
function _aspxSaveAttribute(obj, attrName, savedObj, savedAttrName){
 if(!_aspxIsExistsAttribute(savedObj, savedAttrName)){
  var oldValue = _aspxIsExistsAttribute(obj, attrName) ? _aspxGetAttribute(obj, attrName) : __aspxEmptyAttributeValue;
  _aspxSetAttribute(savedObj, savedAttrName, oldValue);
 }
}
function _aspxChangeAttributeExtended(obj, attrName, savedObj, savedAttrName, newValue){
 _aspxSaveAttribute(obj, attrName, savedObj, savedAttrName);
 _aspxSetAttribute(obj, attrName, newValue);
}
function _aspxChangeAttribute(obj, attrName, newValue){
 _aspxChangeAttributeExtended(obj, attrName, obj, "saved" + attrName, newValue);
}
function _aspxChangeStyleAttribute(obj, attrName, newValue){
 _aspxChangeAttributeExtended(obj.style, attrName, obj, "saved" + attrName, newValue);
}
function _aspxResetAttributeExtended(obj, attrName, savedObj, savedAttrName){
 _aspxSaveAttribute(obj, attrName, savedObj, savedAttrName);
 _aspxSetAttribute(obj, attrName, "");
 _aspxRemoveAttribute(obj, attrName);
}
function _aspxResetAttribute(obj, attrName){
 _aspxResetAttributeExtended(obj, attrName, obj, "saved" + attrName);
}
function _aspxResetStyleAttribute(obj, attrName){
 _aspxResetAttributeExtended(obj.style, attrName, obj, "saved" + attrName);
}
function _aspxRestoreAttributeExtended(obj, attrName, savedObj, savedAttrName){
 if(_aspxIsExistsAttribute(savedObj, savedAttrName)){
  var oldValue = _aspxGetAttribute(savedObj, savedAttrName);
  if(oldValue != __aspxEmptyAttributeValue)
   _aspxSetAttribute(obj, attrName, oldValue);
  else
   _aspxRemoveAttribute(obj, attrName);
  _aspxRemoveAttribute(savedObj, savedAttrName);
  return true;
 }
 return false;
}
function _aspxRestoreAttribute(obj, attrName){
 return _aspxRestoreAttributeExtended(obj, attrName, obj, "saved" + attrName);
}
function _aspxRestoreStyleAttribute(obj, attrName){
 return _aspxRestoreAttributeExtended(obj.style, attrName, obj, "saved" + attrName);
}
function _aspxCopyAllAttributes(sourceElem, destElement) {
 var attrs = sourceElem.attributes;
 for (var n = 0; n < attrs.length; n++) {
  var attr = attrs[n];
  if (attr.specified) {
   var attrName = attr.nodeName;
   var attrValue = sourceElem.getAttribute(attrName, 2);
   if (attrValue == null)
    attrValue = attr.nodeValue;
   destElement.setAttribute(attrName, attrValue, 0); 
  }
 }
 if (sourceElem.style.cssText !== '')
  destElement.style.cssText = sourceElem.style.cssText;
}
function _aspxRemoveAllAttributes(element, excludedAttributes) {
 var excludedAttributesHashTable = {};
 if (excludedAttributes)
  excludedAttributesHashTable = _aspxCreateHashTableFromArray(excludedAttributes);
 if (element.attributes) {
  var attrArray = element.attributes;
  for (var i = 0; i < attrArray.length; i++) {
   var attrName = attrArray[i].name;
   if (!_aspxIsExists(excludedAttributesHashTable[attrName.toLowerCase()])) {
    try {
     attrArray.removeNamedItem(attrName);
    } catch (e) { }
   }
  }
 }
}
function _aspxRemoveStyleAttribute(element, attrName) {
 if (element.style) {
  if (__aspxFirefox && element.style[attrName]) 
   element.style[attrName] = "";
  if (element.style.removeAttribute && element.style.removeAttribute != "")
   element.style.removeAttribute(attrName);
  else if (element.style.removeProperty && element.style.removeProperty != "")
   element.style.removeProperty(attrName);
 }
}
function _aspxRemoveAllStyles(element) {
 if (element.style) {
  for(var key in element.style)
   _aspxRemoveStyleAttribute(element, key);
    _aspxRemoveAttribute(element, "style");
 }
}
function _aspxChangeTabIndexAttribute(element){
 var attribute = _aspxGetTabIndexAttribute(); 
 if(_aspxGetAttribute(element, attribute) != -1)
    _aspxChangeAttribute(element, attribute, -1);
}
function _aspxRestoreTabIndexAttribute(element){
 var attribute = _aspxGetTabIndexAttribute();
 if(_aspxIsExistsAttribute(element, attribute)) 
    if(_aspxGetAttribute(element, attribute) == -1)   
    if(_aspxIsExistsAttribute(element, "saved" + attribute)){
    var oldValue = _aspxGetAttribute(element, "saved" + attribute);
    if(oldValue != __aspxEmptyAttributeValue)
     _aspxSetAttribute(element, attribute, oldValue);
    else {
    if (__aspxWebKitFamily) 
     _aspxSetAttribute(element, attribute, 0); 
    _aspxRemoveAttribute(element, attribute);   
    }
    _aspxRemoveAttribute(element, "saved" + attribute); 
    }
}
function _aspxGetTabIndexAttribute(){
 return __aspxIE  ? "tabIndex" : "tabindex";
}
function _aspxChangeAttributesMethod(enabled){
 return enabled ? _aspxRestoreAttribute : _aspxResetAttribute;
}
function _aspxInitiallyChangeAttributesMethod(enabled){
 return enabled ? _aspxChangeAttribute : _aspxResetAttribute;
}
function _aspxChangeStyleAttributesMethod(enabled){
 return enabled ? _aspxRestoreStyleAttribute : _aspxResetStyleAttribute;
}
function _aspxInitiallyChangeStyleAttributesMethod(enabled){
 return enabled ? _aspxChangeStyleAttribute : _aspxResetStyleAttribute;
}
function _aspxChangeEventsMethod(enabled){
 return enabled ? _aspxAttachEventToElement : _aspxDetachEventFromElement;
}
function _aspxChangeDocumentEventsMethod(enabled){
 return enabled ? _aspxAttachEventToDocument : _aspxDetachEventFromDocument;
}
function _aspxTrimStart(str) { 
 return _aspxTrimImpl(str, true);
}
function _aspxTrimEnd(str) { 
 return _aspxTrimImpl(str, false, true);
}
function _aspxTrim(str) { 
 return _aspxTrimImpl(str, true, true); 
}
function _aspxTrimImpl(source, trimStart, trimEnd) {
 var len = source.length;
 if(!len)
  return source;
 if(len < 0xBABA1) { 
  var result = source;
  if(trimStart) {
   result = result.replace(/^\s+/, "");
  }
  if(trimEnd) {
   result = result.replace(/\s+$/, "");
  }
  return result;  
 } else {
  var start = 0;
  if(trimEnd) {   
   while(len > 0 && ASPxWhiteSpaces[source.charCodeAt(len - 1)]) {
    len--;
   }
  }
  if(trimStart && len > 0) {
   while(start < len && ASPxWhiteSpaces[source.charCodeAt(start)]) { 
    start++; 
   }   
  }
  return source.substring(start, len);
 }
}
function _aspxInsert(str, subStr, index) { 
 var leftText = str.slice(0, index);
 var rightText = str.slice(index);
 return leftText + subStr + rightText;
}
function _aspxInsertEx(str, subStr, startIndex, endIndex) { 
 var leftText = str.slice(0, startIndex);
 var rightText = str.slice(endIndex);
 return leftText + subStr + rightText;
}
function _aspxNavigateUrl(url, target) {
 var javascriptPrefix = "javascript:";
 if(url == "")
  return;
 else if(url.indexOf(javascriptPrefix) != -1) 
  eval(url.substr(javascriptPrefix.length));
 else {
  try{
   if(target != "")
    _aspxNavigateTo(url, target);
   else
    location.href = url;
  }
  catch(e){
  }
 }
}
function _aspxNavigateTo(url, target) {
 var lowerCaseTarget = target.toLowerCase();
 if("_top" == lowerCaseTarget)
  top.location.href = url;
 else if("_self" == lowerCaseTarget)
  location.href = url;
 else if("_search" == lowerCaseTarget)
  window.open(url, 'blank');
 else if("_media" == lowerCaseTarget)
  window.open(url, 'blank');
 else if("_parent" == lowerCaseTarget)
  window.parent.location.href = url;
 else if("_blank" == lowerCaseTarget)
  window.open(url, 'blank');
 else {
  var frame = _aspxGetFrame(top.frames, target);
  if(frame != null)
   frame.location.href = url;
  else
   window.open(url, 'blank');
 }
}
function _aspxGetFrame(frames, name) {
 if(frames[name])
  return frames[name];
 for(var i = 0; i < frames.length; i++) {
  try {
   var frame = frames[i];
   if(frame.name == name) 
    return frame; 
   frame = _aspxGetFrame(frame.frames, name);
   if(frame != null)   
    return frame; 
  } catch(e) {
  } 
 }
 return null;
}
function _aspxToHex(d) {
 return (d < 16) ? ("0" + d.toString(16)) : d.toString(16);
}
function _aspxColorToHexadecimal(colorValue) {
 if (typeof(colorValue) == "number") {
  var r = colorValue & 0xFF;
  var g = (colorValue >> 8) & 0xFF;
  var b = (colorValue >> 16) & 0xFF;
  return "#" + _aspxToHex(r) + _aspxToHex(g) + _aspxToHex(b);
 }
 if (colorValue && (colorValue.substr(0, 3).toLowerCase() == "rgb")) {
  var re = /rgb\s*\(\s*([0-9]+)\s*,\s*([0-9]+)\s*,\s*([0-9]+)\s*\)/;
  var regResult = colorValue.match(re);
  if (regResult) {
   var r = parseInt(regResult[1]);
   var g = parseInt(regResult[2]);
   var b = parseInt(regResult[3]);
   return "#" + _aspxToHex(r) + _aspxToHex(g) + _aspxToHex(b);
  }
  return null;
 } 
 if (colorValue && (colorValue.charAt(0) == "#"))
  return colorValue;
 return null;
}
function _aspxFormatCallbackArg(prefix, arg) {
 if(prefix == null && arg == null)
  return ""; 
 if(prefix == null) prefix = "";
 if(arg == null) arg = "";
 if(arg != null && !_aspxIsExists(arg.length) && _aspxIsExists(arg.value))
  arg = arg.value;
 arg = arg.toString();
 return [prefix, '|', arg.length, '|' , arg].join('');
}
function _aspxFormatCallbackArgs(callbackData) {
 var sb = [ ];
 for(var i = 0; i < callbackData.length; i++)
  sb.push(_aspxFormatCallbackArg(callbackData[i][0], callbackData[i][1]));
 return sb.join("");
}
function _aspxIsValidElement(element){
 if(__aspxIE && __aspxBrowserVersion < 9)
  return element.parentNode && element.parentNode.tagName;
 else {
  if(!__aspxOpera && element.offsetParent != null)
   return true;
  while(element != null){
   if(element.tagName == "BODY")
    return true;
   element = element.parentNode;
  }
  return false;
 }
}
function _aspxIsValidElements(elements) {
 if (!elements)
  return false; 
 for(var i = 0; i < elements.length; i++) {
  if(elements[i] && !_aspxIsValidElement(elements[i]))
   return false;
 }
 return true;
}
function _aspxIsExistsElement(element) {
 return element && _aspxIsValidElement(element);
}
function _aspxFindParentByTestFunc(element, testFunc){
 if (!testFunc) return null;
 while(element != null && element.tagName != "BODY"){
  if(testFunc(element))
   return element;
  element = element.parentNode;
 }
 return null;
}
ASPxClientEvent = _aspxCreateClass(null, {
 constructor: function() {
  this.handlerInfoList = [];
 },
 AddHandler: function(handler, executionContext) {
  if(typeof(executionContext) == "undefined")
   executionContext = null;
  var handlerInfo = ASPxClientEvent.CreateHandlerInfo(handler, executionContext);
  this.handlerInfoList.push(handlerInfo);
 },
 RemoveHandler: function(handler, executionContext) {
  for(var i = this.handlerInfoList.length - 1; i >= 0; i--) {
   var handlerInfo = this.handlerInfoList[i];
   if(handlerInfo.handler == handler && (!executionContext || handlerInfo.executionContext == executionContext)) {
    _aspxArrayRemoveAt(this.handlerInfoList, i);
    return;
   }
  }
 },
 ClearHandlers: function() {
  this.handlerInfoList.length = 0;
 },
 FireEvent: function(obj, args) {
  for(var i = 0; i < this.handlerInfoList.length; i++) {
   var handlerInfo = this.handlerInfoList[i];
   handlerInfo.handler.call(handlerInfo.executionContext, obj, args);
  }
 },
 InsertFirstHandler: function(handler, executionContext){
  if(typeof(executionContext) == "undefined")
   executionContext = null;
  var handlerInfo = ASPxClientEvent.CreateHandlerInfo(handler, executionContext);
  _aspxArrayInsert(this.handlerInfoList, handlerInfo, 0);
 },
 IsEmpty: function() {
  return this.handlerInfoList.length == 0;
 }
});
ASPxClientEvent.CreateHandlerInfo = function(handler, executionContext) {
 return {
  handler: handler,
  executionContext: executionContext
 };
};
ASPxClientEventArgs = _aspxCreateClass(null, {
 constructor: function() {
 }
});
ASPxClientEventArgs.Empty = new ASPxClientEventArgs();
ASPxClientCancelEventArgs = _aspxCreateClass(ASPxClientEventArgs, {
 constructor: function(){
  this.constructor.prototype.constructor.call(this);
  this.cancel = false;
 }
});
ASPxClientProcessingModeEventArgs = _aspxCreateClass(ASPxClientEventArgs, {
 constructor: function(processOnServer){
  this.constructor.prototype.constructor.call(this);
  this.processOnServer = processOnServer;
 }
});
ASPxClientProcessingModeCancelEventArgs = _aspxCreateClass(ASPxClientProcessingModeEventArgs, {
 constructor: function(processOnServer){
  this.constructor.prototype.constructor.call(this, processOnServer);
  this.cancel = false;
 }
});
ASPxClientBeginCallbackEventArgs = _aspxCreateClass(ASPxClientEventArgs, {
 constructor: function(command){
  this.constructor.prototype.constructor.call(this);
  this.command = command;
 }
});
ASPxClientEndCallbackEventArgs = _aspxCreateClass(ASPxClientEventArgs, {
 constructor: function(){
  this.constructor.prototype.constructor.call(this);
 }
});
ASPxClientCustomDataCallbackEventArgs = _aspxCreateClass(ASPxClientEventArgs, {
 constructor: function(result) {
  this.constructor.prototype.constructor.call(this);
  this.result = result;
 }
});
ASPxClientCallbackErrorEventArgs = _aspxCreateClass(ASPxClientEventArgs, {
 constructor: function(message){
  this.constructor.prototype.constructor.call(this);
  this.message = message;
  this.handled = false;
 }
});
if(_aspxIsFunction(window.WebForm_InitCallbackAddField)) {
 (function() {
  var original = window.WebForm_InitCallbackAddField;
  window.WebForm_InitCallbackAddField = function(name, value) {
   if(typeof(name) == "string" && name)
    original.apply(null, arguments);
  };
 })();
}
ASPxPostHandler = _aspxCreateClass(null, {
 constructor: function() {
  this.Post = new ASPxClientEvent();
  this.PostFinalization = new ASPxClientEvent();
  this.ReplaceGlobalPostFunctions();
  this.HandleDxCallbackBeginning();
  this.HandleMSAjaxRequestBeginning();
 },
 OnPost: function() {
  this.Post.FireEvent(this, ASPxClientEventArgs.Empty);
  this.PostFinalization.FireEvent(this, ASPxClientEventArgs.Empty);
 },
 ReplaceGlobalPostFunctions: function() {
  if(_aspxIsFunction(window.__doPostBack))
   this.ReplaceDoPostBack();
  if(_aspxIsFunction(window.WebForm_DoCallback))
   this.ReplaceDoCallback();
  var form = _aspxGetServerForm();
  if(form == null)
   return;
  if(form.submit)
   this.ReplaceFormSubmit(form);
  this.ReplaceFormOnSumbit(form);
  form = null;
 },
 HandleDxCallbackBeginning: function() {
  aspxGetControlCollection().BeforeInitCallback.AddHandler(function() {
   _aspxRaisePostHandlerOnPost(false, true);
  });
 },
 HandleMSAjaxRequestBeginning: function() {
  if(window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager && Sys.WebForms.PageRequestManager.getInstance) {
   var pageRequestManager = Sys.WebForms.PageRequestManager.getInstance();
   if(pageRequestManager != null && ASPxIdent.IsArray(pageRequestManager._onSubmitStatements)) {
    pageRequestManager._onSubmitStatements.unshift(function() {
     _aspxRaisePostHandlerOnPost(true); return true;
    });
   }
  }
 },
 ReplaceDoPostBack: function() {
  var original = __doPostBack;
  __doPostBack = function(eventTarget, eventArgument) {
   _aspxRaisePostHandlerOnPost();
   original(eventTarget, eventArgument);
  };
 },
 ReplaceDoCallback: function() {
  var original = WebForm_DoCallback;
  WebForm_DoCallback = function(eventTarget, eventArgument, eventCallback, context, errorCallback, useAsync) {
   var postHandler = aspxGetPostHandler();
   if(postHandler.dxCallbackHandled)
    delete postHandler.dxCallbackHandled;
   else
    _aspxRaisePostHandlerOnPost();
   return original(eventTarget, eventArgument, eventCallback, context, errorCallback, useAsync);
  };
 },
 ReplaceFormSubmit: function(form) {
  var originalSubmit = form.submit;
  form.submit = function() {
   _aspxRaisePostHandlerOnPost();
   var callee = arguments.callee;
   this.submit = originalSubmit;
   var submitResult = this.submit();
   this.submit = callee;
   return submitResult;
  };
  form = null;
 },
 ReplaceFormOnSumbit: function(form) {
  var originalSubmit = form.onsubmit;
  form.onsubmit = function() {
   var postHandler = aspxGetPostHandler();
   if(postHandler.msAjaxRequestBeginningHandled)
    delete postHandler.msAjaxRequestBeginningHandled;
   else
    _aspxRaisePostHandlerOnPost();
   return _aspxIsFunction(originalSubmit)
    ? originalSubmit.apply(this, arguments)
    : true;
  };
  form = null;
 }
});
function _aspxRaisePostHandlerOnPost(isMSAjaxRequestBeginning, isDXCallbackBeginning) {
 var postHandler = aspxGetPostHandler();
 if(postHandler) {
  if(isMSAjaxRequestBeginning)
   postHandler.msAjaxRequestBeginningHandled = true;
  else if(isDXCallbackBeginning)
   postHandler.dxCallbackHandled = true;
  postHandler.OnPost();
 }
}
function aspxGetPostHandler() {
 if (!window.__aspxPostHandler)
  window.__aspxPostHandler = new ASPxPostHandler();
 return window.__aspxPostHandler;
}
ASPxClientControlsInitializedEventArgs = _aspxCreateClass(ASPxClientEventArgs, {
 constructor: function(isCallback) {
  this.isCallback = isCallback;
 }
});
ASPxClientControlCollection = _aspxCreateClass(null, {
 constructor: function(){
  this.elements = new Object();
  this.windowResizeSubscribers = [];
  this.prevWndWidth = "";
  this.prevWndHeight = "";
  this.BeforeInitCallback = new ASPxClientEvent();
  this.ControlsInitialized = new ASPxClientEvent();
 },
 Add: function(element){
  this.elements[element.name] = element;
 },
 Remove: function(element) {
  this.elements[element.name] = null;
 },
 Get: function(name){
  return this.elements[name];
 },
 ForEachControl: function(processFunc, context) {
  if(!context)
   context = this;
  for(var name in this.elements) {
   var control = this.elements[name];
   if(ASPxIdent.IsASPxClientControl(control))
    if(processFunc.call(context, control))
     return;
  }
 },
 AdjustControls: function(container, checkSizeCorrectedFlag) {
  if(typeof(container) == "undefined")
   container = null;
  if(typeof(checkSizeCorrectedFlag) == "undefined")
   checkSizeCorrectedFlag = false;
  var collection = this;
  window.setTimeout(function() {
   collection.ProcessControlsInContainer(container, function(control) {
    control.AdjustControl(checkSizeCorrectedFlag);
   });
  }, 0);
 },
 CollapseControls: function(container, checkSizeCorrectedFlag) {
  this.ProcessControlsInContainer(container, function(control) {
   control.CollapseControl(checkSizeCorrectedFlag);
  });
 },
 AtlasInitialize: function(isCallback) {
  _aspxProcessScriptsAndLinks("", isCallback);
 },
 Initialize: function() {
  this.InitializeElements(false );
  if(typeof(Sys) != "undefined" && typeof(Sys.Application) != "undefined")
   Sys.Application.add_load(aspxCAInit);
  this.InitWindowSizeCache();
 },
 InitializeElements: function(isCallback) {
  this.ForEachControl(function(control){
   if(!control.isInitialized)
    control.Initialize();
  });
  if(typeof(_aspxGetEditorStretchedInputElementsManager) != "undefined")
   _aspxGetEditorStretchedInputElementsManager().Initialize();
  this.AfterInitializeElements(true);
  this.AfterInitializeElements(false);
  this.RaiseControlsInitialized(isCallback);
 },
 AfterInitializeElements: function(leadingCall) {
  this.ForEachControl(function(control){
   if (control.leadingAfterInitCall && leadingCall || !control.leadingAfterInitCall && !leadingCall) {
    if(!control.isInitialized)
     control.AfterInitialize();
   }
  });
 },
 DoFinalizeCallback: function() {
  this.ForEachControl(function(control){
   control.DoFinalizeCallback();
  });
 },
 ProcessControlsInContainer: function(container, processFunc) {
  if(container)
   this.ForEachControl(function(control){
    if(this.IsControlInContainer(container, control))
     processFunc(control);
   });
 },
 IsControlInContainer: function(container, control) {
  if(control.GetMainElement) {
   var mainElement = control.GetMainElement();
   if(mainElement && (mainElement != container)) {
    if(_aspxGetIsParent(container, mainElement))
     return true;
   }
  }
  return false;
 },
 RaiseControlsInitialized: function(isCallback) {
  if(!this.ControlsInitialized.IsEmpty()){
   if(typeof(isCallback) == "undefined")
    isCallback = true;
   var args = new ASPxClientControlsInitializedEventArgs(isCallback);
   this.ControlsInitialized.FireEvent(this, args);
  }
 },
 Before_WebForm_InitCallback: function(){
  var args = new ASPxClientEventArgs();
  this.BeforeInitCallback.FireEvent(this, args);
 },
 InitWindowSizeCache: function(){
  this.prevWndWidth = document.documentElement.clientWidth;
  this.prevWndHeight = document.documentElement.clientHeight;
 },
 BrowserWindowSizeChanged: function(){
  var wndWidth = document.documentElement.clientWidth == 0 ? document.body.clientWidth : document.documentElement.clientWidth;
  var wndHeight = document.documentElement.clientHeight == 0 ? document.body.clientHeight : document.documentElement.clientHeight;
  var browserWindowSizeChanged = (this.prevWndWidth != wndWidth) || (this.prevWndHeight != wndHeight);
  if(browserWindowSizeChanged){
   this.prevWndWidth = wndWidth;
   this.prevWndHeight = wndHeight;
   return true;
  }
  return false;
 },
 SubscribeObjectToBrowserWindowResize: function(object){
  this.windowResizeSubscribers.push(object);
 },
 OnBrowserWindowResize: function(evt){
  if(this.BrowserWindowSizeChanged()){
   this.ForEachControl(function(control) {
    control.OnBrowserWindowResizeInternal(evt);
   });
    for(var i = 0; i < this.windowResizeSubscribers.length; i++)
    this.windowResizeSubscribers[i].OnBrowserWindowResize(evt);
  }
 }
});
ASPxClientControl = _aspxCreateClass(null, {
 constructor: function(name){
  this.isASPxClientControl = true;
  this.name = name;
  this.uniqueID = name;  
  this.enabled = true;
  this.clientEnabled = true;
  this.clientVisible = true;
  this.rtl = false;
  this.autoPostBack = false;
  this.allowMultipleCallbacks = true;
  this.callBack = null;
  this.savedCallbacks = null;
  this.isNative = false;
  this.requestCount = 0;
  this.isInitialized = false;
  this.initialFocused = false;
  this.leadingAfterInitCall = false; 
  this.sizeCorrectedOnce = false;
  this.serverEvents = [];
  this.dialogContentHashTable = { };
  this.sizeCorrectedOnce = false;
  this.loadingPanelElement = null;
  this.loadingDivElement = null;  
  this.hasPhantomLoadingPanel = false;
  this.mainElement = null;
  this.renderIFrameForPopupElements = false;
  this.widthValueSetInPercentage = false;
  this.sizingConfig = {
   allowSetWidth: true,
   allowSetHeight: true,
   correction : false,
   adjustControl : false
  };
  this.Init = new ASPxClientEvent();
  this.BeginCallback = new ASPxClientEvent();
  this.EndCallback = new ASPxClientEvent();
  this.CallbackError = new ASPxClientEvent();
  this.CustomDataCallback = new ASPxClientEvent();
  aspxGetControlCollection().Add(this);  
 },
 Initialize: function() {
  if(this.callBack != null)
   this.InitializeCallBackData();
 },
 InlineInitialize: function() {
 },
 InitailizeFocus: function() {
  if(this.initialFocused && this.IsVisible())
   this.Focus();
 },
 AfterInitialize: function() {
  this.AdjustControl(__aspxCheckSizeCorrectedFlag);
  this.InitailizeFocus();
  this.isInitialized = true;
  this.RaiseInit();
  if(this.savedCallbacks) {
   for(var i = 0; i < this.savedCallbacks.length; i++) 
    this.CreateCallbackInternal(this.savedCallbacks[i].arg, this.savedCallbacks[i].command, 
     false, this.savedCallbacks[i].callbackInfo);
   this.savedCallbacks = null;
  }
  this.UpdateWidthCorrectionRequired();
 },
 InitializeCallBackData: function() {
 },
 RenderExistsOnPage: function() {
  return _aspxIsExistsElement(this.GetMainElement());
 },
 GetWidth: function() {
  return this.GetMainElement().offsetWidth;
 },
 GetHeight: function() {
  return this.GetMainElement().offsetHeight;
 },
 SetWidth: function(width) {
  if(this.sizingConfig.allowSetWidth)
   this.SetSizeCore("width", width, "GetWidth", false);
 },
 SetHeight: function(height) {
  if(this.sizingConfig.allowSetHeight)
   this.SetSizeCore("height", height, "GetHeight", false);
 },
 SetSizeCore: function(sizePropertyName, size, getFunctionName, corrected) {
  if(size < 0)
   return;
  this.GetMainElement().style[sizePropertyName] = size + "px";
  if(this.sizingConfig.adjustControl)
   this.AdjustControl(false, true);
  if(this.sizingConfig.correction && !corrected) {
   var realSize = this[getFunctionName]();
   if(realSize != size) {
    var correctedSize = size - (realSize - size);
    this.SetSizeCore(sizePropertyName, correctedSize, getFunctionName, true);
   }
  }
 },
 CollapseControl: function(checkSizeCorrectedFlag) {
 },
 AdjustControl: function(checkSizeCorrectedFlag, nestedCall) {
  if(checkSizeCorrectedFlag && this.sizeCorrectedOnce || ASPxClientControl.adjustControlLocked && !nestedCall) {
   this.TryShowPhantomLoadingPanel();
   return;
  }
  ASPxClientControl.adjustControlLocked = true;
  try {
   var mainElement = this.GetMainElement();
   if (!mainElement || !this.IsDisplayed())
    return;
   this.AdjustControlCore();
   this.TryShowPhantomLoadingPanel();
   this.sizeCorrectedOnce = true;
  } finally {
   delete ASPxClientControl.adjustControlLocked;
  }
 },
 UpdateWidthCorrectionRequired: function() {
  var mainElement = this.GetMainElement();
  if(mainElement) {
   var mainElementStyle = _aspxGetCurrentStyle(mainElement);
   this.widthValueSetInPercentage = _aspxIsWidthSetInPercentage(mainElementStyle.width) || _aspxIsWidthSetInPercentage(mainElement.style.width);
  }
 },
 OnBrowserWindowResize: function(evt) {
 },
 AdjustControlCore: function() {
 },
 OnBrowserWindowResizeInternal: function(evt){
  if(this.widthValueSetInPercentage) 
   this.OnBrowserWindowResize(evt);
 },
 RegisterServerEventAssigned: function(eventNames){
  for(var i = 0; i < eventNames.length; i++)
   this.serverEvents[eventNames[i]] = true;
 },
 IsServerEventAssigned: function(eventName){
  return !!this.serverEvents[eventName];
 },
 GetChild: function(idPostfix){
  var mainElement = this.GetMainElement();
  return mainElement ? _aspxGetChildById(mainElement, this.name + idPostfix) : null;
 },
 GetItemElementName: function(element) {
  var name = "";
  if(element.id)
   name = element.id.substring(this.name.length + 1);
  return name;
 },
 GetLinkElement: function(element) {
  if (element == null) return null;
  return (element.tagName == "A") ? element : _aspxGetChildByTagName(element, "A", 0);
 },
 GetInternalHyperlinkElement: function(parentElement, index) {
  var element = _aspxGetChildByTagName(parentElement, "A", index);
  if (element == null) 
   element = _aspxGetChildByTagName(parentElement, "SPAN", index);
  return element;
 },
 GetParentForm: function(){
  return _aspxGetParentByTagName(this.GetMainElement(), "FORM");
 },
 GetMainElement: function(){
  if(!_aspxIsExistsElement(this.mainElement))
   this.mainElement = _aspxGetElementById(this.name);
  return this.mainElement;
 },
 OnControlClick: function(clickedElement, htmlEvent) {
 },
 IsLoadingContainerVisible: function(){
  return this.IsVisible();
 },
 GetLoadingPanelElement: function(){
  return _aspxGetElementById(this.name + "_LP");
 },
 CloneLoadingPanel: function(element, parent) {
  var clone = element.cloneNode(true);
  clone.id = element.id + "V";
  parent.appendChild(clone);
  return clone;
 },
 CreateLoadingPanelInsideContainer: function(parentElement, hideContent, collapseHeight, collapseWidth) {
  if(this.ShouldHideExistingLoadingPanel())
   this.HideLoadingPanel();
  if(parentElement == null)
   return null;
  if(!this.IsLoadingContainerVisible()) {
   this.hasPhantomLoadingPanel = true;
   return null;
  }
  var element = this.GetLoadingPanelElement();
  if (element != null){
   var width = collapseWidth ? 0 : parentElement.clientWidth;
   var height = collapseHeight ? 0 : parentElement.clientHeight;
   if(hideContent){
    for(var i = 0; i < parentElement.childNodes.length; i++){
     if(parentElement.childNodes[i].style)
      parentElement.childNodes[i].style.display = "none";
    }
   }
   else
    parentElement.innerHTML = "";
   var table = document.createElement("TABLE");
   parentElement.appendChild(table);
   table.border = 0;
   table.cellPadding = 0;
   table.cellSpacing = 0;
   table.style.height = (height > 0) ? height + "px" : "100%";
   table.style.width = (width > 0) ? width + "px" : "100%";
   var tbody = document.createElement("TBODY");
   table.appendChild(tbody);
   var tr = document.createElement("TR");
   tbody.appendChild(tr);
   var td = document.createElement("TD");
   tr.appendChild(td);
   td.align = "center";
   td.vAlign = "middle";
   element = this.CloneLoadingPanel(element, td);
   _aspxSetElementDisplay(element, true);
   this.loadingPanelElement = element;
   return element;
  } else
   parentElement.innerHTML = "&nbsp;";
  return null;
 },
 CreateLoadingPanelWithAbsolutePosition: function(parentElement, offsetElement) {
  if(this.ShouldHideExistingLoadingPanel())
   this.HideLoadingPanel();
  if(parentElement == null)
   return null;
  if(!this.IsLoadingContainerVisible()) {
   this.hasPhantomLoadingPanel = true;
   return null;
  }
  if(!offsetElement)
   offsetElement = parentElement;
  var element = this.GetLoadingPanelElement();
  if(element != null) {
   element = this.CloneLoadingPanel(element, parentElement);
   element.style.position = "absolute";
   _aspxSetElementDisplay(element, true);
   this.SetLoadingPanelLocation(offsetElement, element);
   this.loadingPanelElement = element;
   return element;
  }
  return null;
 },
 CreateLoadingPanelInline: function(parentElement){
  if(this.ShouldHideExistingLoadingPanel())
   this.HideLoadingPanel();
  if(parentElement == null)
   return null;
  if(!this.IsLoadingContainerVisible()) {
   this.hasPhantomLoadingPanel = true;
   return null;
  }
  var element = this.GetLoadingPanelElement();
  if(element != null) {
   element = this.CloneLoadingPanel(element, parentElement);
   _aspxSetElementDisplay(element, true);
   this.loadingPanelElement = element;
   return element;
  }
  return null;
 },
 ShowLoadingPanel: function() {
 },
 HideLoadingPanel: function() {
  this.hasPhantomLoadingPanel = false;
  if(_aspxIsExistsElement(this.loadingPanelElement)) {
   _aspxRemoveElement(this.loadingPanelElement);
   this.loadingPanelElement = null;
  }
 },
 SetLoadingPanelLocation: function(offsetElement, loadingPanel, x, y, offsetX, offsetY) {
  if(!_aspxIsExists(x) || !_aspxIsExists(y)){
   var x1 = _aspxGetAbsoluteX(offsetElement);
   var y1 = _aspxGetAbsoluteY(offsetElement);
   var x2 = x1;
   var y2 = y1;
   if(offsetElement == document.body){
    x2 += _aspxGetDocumentMaxClientWidth();
    y2 += _aspxGetDocumentMaxClientHeight();
   }
   else{
    x2 += offsetElement.offsetWidth;
    y2 += offsetElement.offsetHeight;
   }
   if(x1 < _aspxGetDocumentScrollLeft())
    x1 = _aspxGetDocumentScrollLeft();
   if(y1 < _aspxGetDocumentScrollTop())
    y1 = _aspxGetDocumentScrollTop();
   if(x2 > _aspxGetDocumentScrollLeft() + _aspxGetDocumentClientWidth())
    x2 = _aspxGetDocumentScrollLeft() + _aspxGetDocumentClientWidth();
   if(y2 > _aspxGetDocumentScrollTop() + _aspxGetDocumentClientHeight())
    y2 = _aspxGetDocumentScrollTop() + _aspxGetDocumentClientHeight();
   x = x1 + ((x2 - x1 - loadingPanel.offsetWidth) / 2);
   y = y1 + ((y2 - y1 - loadingPanel.offsetHeight) / 2);
  }
  if(_aspxIsExists(offsetX) && _aspxIsExists(offsetY)){
   x += offsetX;
   y += offsetY;
  }
  loadingPanel.style.left = _aspxPrepareClientPosForElement(x, loadingPanel, true) + "px";
  loadingPanel.style.top = _aspxPrepareClientPosForElement(y, loadingPanel, false) + "px";
 },
 TryShowPhantomLoadingPanel: function() {
  if(this.hasPhantomLoadingPanel && this.InCallback())
   this.ShowLoadingPanel();
  this.hasPhantomLoadingPanel = false;
 },
 GetLoadingDiv: function(){
  return _aspxGetElementById(this.name + "_LD");
 },
 CreateLoadingDiv: function(parentElement, offsetElement){
  if(this.ShouldHideExistingLoadingPanel())
   this.HideLoadingDiv();
  if(parentElement == null || !this.IsLoadingContainerVisible()) return null;
  if(!offsetElement)
   offsetElement = parentElement;
  var div = this.GetLoadingDiv();
  if(div != null){
   div = div.cloneNode(true);
   parentElement.appendChild(div);
   _aspxSetElementDisplay(div, true);
   this.SetLoadingDivBounds(offsetElement, div);
   this.loadingDivElement = div;
   return div;
  }
  return null;
 },
 SetLoadingDivBounds: function(offsetElement, loadingDiv) {
  var absX = (offsetElement == document.body) ? 0 : _aspxGetAbsoluteX(offsetElement);
  var absY = (offsetElement == document.body) ? 0 : _aspxGetAbsoluteY(offsetElement);
  loadingDiv.style.left = _aspxPrepareClientPosForElement(absX, loadingDiv, true) + "px";
  loadingDiv.style.top = _aspxPrepareClientPosForElement(absY, loadingDiv, false) + "px";
  var width = (offsetElement == document.body) ? _aspxGetDocumentWidth() : offsetElement.offsetWidth;
  var height = (offsetElement == document.body) ? _aspxGetDocumentHeight() : offsetElement.offsetHeight;
  if(height < 0) 
   height = 0;
  _aspxSetStyleSize(loadingDiv, width, height); 
  var correctedWidth = 2 * width - loadingDiv.offsetWidth;
  if(correctedWidth <= 0) correctedWidth = width;
  var correctedHeight = 2 * height - loadingDiv.offsetHeight;
  if(correctedHeight <= 0) correctedHeight = height;
  _aspxSetStyleSize(loadingDiv, correctedWidth, correctedHeight);
 },
 HideLoadingDiv: function() {
  if(_aspxIsExistsElement(this.loadingDivElement)){
   _aspxRemoveElement(this.loadingDivElement);
   this.loadingDivElement = null;
  }
 },
 RaiseInit: function(){
  if(!this.Init.IsEmpty()){
   var args = new ASPxClientEventArgs();
   this.Init.FireEvent(this, args);
  }
 },
 RaiseBeginCallbackInternal: function(command){
  if(!this.BeginCallback.IsEmpty()){
   var args = new ASPxClientBeginCallbackEventArgs(command);
   this.BeginCallback.FireEvent(this, args);
  }
 },
 RaiseBeginCallback: function(command){
  this.RaiseBeginCallbackInternal(command);
  if(typeof(aspxGetGlobalEvents) != "undefined")
   aspxGetGlobalEvents().OnBeginCallback(this, command);
 },
 RaiseEndCallback: function(){
  if(!this.EndCallback.IsEmpty()){
   var args = new ASPxClientEndCallbackEventArgs();
   this.EndCallback.FireEvent(this, args);
  }
  if(typeof(aspxGetGlobalEvents) != "undefined")
   aspxGetGlobalEvents().OnEndCallback(this);
 },
 RaiseCallbackError: function(message) {
  if(!this.CallbackError.IsEmpty()) {
   var args = new ASPxClientCallbackErrorEventArgs(message);
   this.CallbackError.FireEvent(this, args);
   if(args.handled)
    return { isHandled: true, errorMessage: args.message };
  }
  if(typeof(aspxGetGlobalEvents) != "undefined") {
   var args = new ASPxClientCallbackErrorEventArgs(message);
   aspxGetGlobalEvents().OnCallbackError(this, args);
   if(args.handled)
    return { isHandled: true, errorMessage: args.message };
  }
  return { isHandled: false, errorMessage: message };
 },
 IsVisible: function() {
  var element = this.GetMainElement();
  return _aspxElementIsVisible(element);
 },
 IsDisplayed: function() {
  var element = this.GetMainElement();
  while(element && element.tagName != "BODY") {
   if(!_aspxGetElementDisplay(element)) 
    return false;
   element = element.parentNode;
  }
  return true;
 },
 Focus: function() {
 },
 GetClientVisible: function(){
  return this.GetVisible();
 },
 SetClientVisible: function(visible){
  this.SetVisible(visible);
 },
 GetVisible: function(){
  return this.clientVisible;
 },
 SetVisible: function(visible){
  if(this.clientVisible != visible){
   this.clientVisible = visible;
   _aspxSetElementDisplay(this.GetMainElement(), visible);
   if (visible) {
    this.AdjustControl(__aspxCheckSizeCorrectedFlag);
    var mainElement = this.GetMainElement();
    if(mainElement)
     aspxGetControlCollection().AdjustControls(mainElement, __aspxCheckSizeCorrectedFlag);
   }
  }
 },
 GetEnabled: function() {
  return this.clientEnabled;
 },
 SetEnabled: function(enabled) {
  this.clientEnabled = enabled;
  if(ASPxClientControl.setEnabledLocked)
   return;
  else
   ASPxClientControl.setEnabledLocked = true;
  aspxGetControlCollection().ProcessControlsInContainer(this.GetMainElement(), function(control) {
   if(_aspxIsFunction(control.SetEnabled))
    control.SetEnabled(enabled);
  });
  delete ASPxClientControl.setEnabledLocked;
 },
 InCallback: function() {
  return this.requestCount > 0;
 },
 DoBeginCallback: function(command) {
  this.RaiseBeginCallback(command || "");
  aspxGetControlCollection().Before_WebForm_InitCallback();
  if(typeof(WebForm_InitCallback) != "undefined" && WebForm_InitCallback) {
   __theFormPostData = "";
   __theFormPostCollection = [ ];
   this.ClearPostBackEventInput("__EVENTTARGET");
   this.ClearPostBackEventInput("__EVENTARGUMENT");
   WebForm_InitCallback();
   this.savedFormPostData = __theFormPostData;   
   this.savedFormPostCollection = __theFormPostCollection;
  }
 },
 ClearPostBackEventInput: function(id){
  var element = _aspxGetElementById(id);
  if(element != null) element.value = "";
 },
 PerformDataCallback: function(arg, handler) {
  this.CreateCustomDataCallback(arg, "", handler);
 }, 
 CreateCallback: function(arg, command) {
  var callbackInfo = this.CreateCallbackInfo(ASPxCallbackType.Common, null);
  this.CreateCallbackByInfo(arg, command, callbackInfo);
 },
 CreateCustomDataCallback: function(arg, command, handler) {
  var callbackInfo = this.CreateCallbackInfo(ASPxCallbackType.Data, handler);
  this.CreateCallbackByInfo(arg, command, callbackInfo);
 },
 CreateCallbackByInfo: function(arg, command, callbackInfo) {
  if(!this.CanCreateCallback()) return;
  if(typeof(WebForm_DoCallback) != "undefined" && WebForm_DoCallback && __aspxDocumentLoaded)
   this.CreateCallbackInternal(arg, command, true, callbackInfo);
  else {
   if(!this.savedCallbacks)
    this.savedCallbacks = [];
   var callbackInfo = { arg: arg, command: command, callbackInfo: callbackInfo };
   if(this.allowMultipleCallbacks)
    this.savedCallbacks.push(callbackInfo);
   else
    this.savedCallbacks[0] = callbackInfo;
  }
 },
 CreateCallbackInternal: function(arg, command, viaTimer, callbackInfo) {
  this.requestCount++;
  this.DoBeginCallback(command);
  if(typeof(arg) == "undefined")
   arg = "";
  if(typeof(command) == "undefined")
   command = "";
  var callbackID = this.SaveCallbackInfo(callbackInfo);
  if(viaTimer)
   window.setTimeout("aspxCreateCallback('" + this.name + "', '" + escape(arg) + "', '" + escape(command) + "', " + callbackID + ");", 0);
  else
   this.CreateCallbackCore(arg, command, callbackID);
 },
 CreateCallbackCore: function(arg, command, callbackID) {
  __theFormPostData = this.savedFormPostData;
  __theFormPostCollection = this.savedFormPostCollection;
  this.callBack(this.GetSerializedCallbackInfoByID(callbackID) + arg);
 },
 CanCreateCallback: function() {
  return this.allowMultipleCallbacks || !this.InCallback();
 },
 DoLoadCallbackScripts: function() {
  _aspxProcessScriptsAndLinks(this.name);
 },
 DoEndCallback: function() {
  this.requestCount--;
  if(this.HideLoadingPanelOnCallback() && this.requestCount < 1) {
   this.HideLoadingDiv();
   this.HideLoadingPanel();
  }
  this.RaiseEndCallback();
 },
 DoFinalizeCallback: function() {
 },
 HideLoadingPanelOnCallback: function() {
  return true;
 },
 ShouldHideExistingLoadingPanel: function() {
  return true;
 },
 EvalCallbackResult: function(resultString){
  return eval(resultString)
 },
 DoCallback: function(result) {
  result = _aspxTrim(result);
  if(result.indexOf(__aspxCallbackResultPrefix) != 0) 
   this.ProcessCallbackGeneralError(result);
  else {
   var resultObj = null;
   try {
    resultObj = this.EvalCallbackResult(result);
   } 
   catch(e) {
   }
   if(resultObj) {
    if(resultObj.redirect){
     if(!__aspxIE)
      window.location.href = resultObj.redirect;
     else { 
      var fakeLink = document.createElement("a");
      fakeLink.href = resultObj.redirect;
      document.body.appendChild(fakeLink); 
      fakeLink.click();
     }
     this.DoLoadCallbackScripts(); 
    }
    else if(resultObj.generalError){
     this.ProcessCallbackGeneralError(resultObj.generalError);
     this.DoLoadCallbackScripts(); 
    }
    else {
     var errorObj = resultObj.error;
     if(errorObj)
      this.ProcessCallbackError(errorObj);
     else {
      if(resultObj.cp) {
       for(var name in resultObj.cp)
        this[name] = resultObj.cp[name];
      }
      var callbackInfo = this.DequeueCallbackInfo(resultObj.id);
      if(callbackInfo.type == ASPxCallbackType.Data) 
       this.ProcessCustomDataCallback(resultObj.result, callbackInfo);
      else 
       this.ProcessCallback(resultObj.result);
     }
     this.DoLoadCallbackScripts();
    }
   } 
  }
 },
 DoCallbackError: function(result) {
  this.HideLoadingDiv();
  this.HideLoadingPanel();
  this.ProcessCallbackGeneralError(result); 
 },
 DoControlClick: function(evt) {
  this.OnControlClick(_aspxGetEventSource(evt), evt);
 },
 ProcessCallback: function(result) {
  this.OnCallback(result);
 },
 ProcessCustomDataCallback: function(result, callbackInfo) {
  if(callbackInfo.handler != null)
   callbackInfo.handler(this, result);
  this.RaiseCustomDataCallback(result);
 },
 RaiseCustomDataCallback: function(result) {
  if(!this.CustomDataCallback.IsEmpty()) {
   var arg = new ASPxClientCustomDataCallbackEventArgs(result);
   this.CustomDataCallback.FireEvent(this, arg);
  }
 },
 OnCallback: function(result) {
 },
 CreateCallbackInfo: function(type, handler) {
  return { type: type, handler: handler };
 },
 GetSerializedCallbackInfoByID: function(callbackID) {
  return this.GetCallbackInfoByID(callbackID).type + callbackID + __aspxCallbackSeparator;
 },
 SaveCallbackInfo: function(callbackInfo) {
  var activeCallbacksInfo = this.GetActiveCallbacksInfo();
  for(var i = 0; i < activeCallbacksInfo.length; i++) {
   if(activeCallbacksInfo[i] == null) {
    activeCallbacksInfo[i] = callbackInfo;
    return i;
   }
  }
  activeCallbacksInfo.push(callbackInfo);
  return activeCallbacksInfo.length - 1;
 },
 GetActiveCallbacksInfo: function() {
  var persistentProperties = this.GetPersistentProperties();
  if(!persistentProperties.activeCallbacks)
   persistentProperties.activeCallbacks = [ ];
  return persistentProperties.activeCallbacks;
 },
 GetPersistentProperties: function() {
  var storage = _aspxGetPersistentControlPropertiesStorage();
  var persistentProperties = storage[this.name];
  if(!persistentProperties) {
   persistentProperties = { };
   storage[this.name] = persistentProperties;
  }
  return persistentProperties;
 },
 GetCallbackInfoByID: function(callbackID) {
  return this.GetActiveCallbacksInfo()[callbackID];
 },
 DequeueCallbackInfo: function(index) {
  var activeCallbacksInfo = this.GetActiveCallbacksInfo();
  if(index < 0 || index >= activeCallbacksInfo.length)
   return null;
  var result = activeCallbacksInfo[index];
  activeCallbacksInfo[index] = null;
  return result;
 },
 ProcessCallbackError: function(errorObj) {
  var data = errorObj.data || null;
  var result = this.RaiseCallbackError(errorObj.message);
  if(!result.isHandled)
   this.OnCallbackError(result.errorMessage, data);
 },
 OnCallbackError: function(errorMessage, data) {
  if(errorMessage)
   alert(errorMessage);
 },
 ProcessCallbackGeneralError: function(errorMessage) {
  var result = this.RaiseCallbackError(errorMessage);
  if(!result.isHandled)
   this.OnCallbackGeneralError(result.errorMessage);
 },
 OnCallbackGeneralError: function(errorMessage) {
  this.OnCallbackError(errorMessage, null);
 },
 SendPostBack: function(params) {
  __doPostBack(this.uniqueID, params);
 }
});
ASPxClientControl.AdjustControls = function(container){
 aspxGetControlCollection().AdjustControls(container);
};
ASPxClientControl.Cast = function(obj) {
 if(typeof obj == "string")
  return window[obj];
 return obj;
};
ASPxIdent = { };
ASPxIdent.IsDate = function(obj) {
 return obj && obj.constructor == Date;
};
ASPxIdent.IsRegExp = function(obj) {
 return obj && obj.constructor === RegExp;
};
ASPxIdent.IsArray = function(obj) {
 return obj && obj.constructor == Array;
};
ASPxIdent.IsASPxClientControl = function(obj) {
 return obj && obj.isASPxClientControl;
};
ASPxIdent.IsASPxClientEdit = function(obj) {
 return obj && obj.isASPxClientEdit;
};
ASPxIdent.IsASPxClientRadioButtonList = function(obj) {
 return obj && obj.isASPxClientRadioButtonList;
};
ASPxClientControl.GetControlCollection = function(){
 return aspxGetControlCollection();
}
var __aspxControlCollection = null;
function aspxGetControlCollection(){
 if(__aspxControlCollection == null)
  __aspxControlCollection = new ASPxClientControlCollection();
 return __aspxControlCollection;
}
var __aspxPersistentControlPropertiesStorage = null;
function _aspxGetPersistentControlPropertiesStorage() {
 if(__aspxPersistentControlPropertiesStorage == null)
  __aspxPersistentControlPropertiesStorage = { };
 return __aspxPersistentControlPropertiesStorage;
}
function _aspxFunctionIsInCallstack(currentCallee, targetFunction, depthLimit) {
 var candidate = currentCallee;
 var depth = 0;
 while(candidate && depth <= depthLimit) {
  candidate = candidate.caller;
  if(candidate == targetFunction)
   return true;
  depth++;
 }
 return false;
}
function aspxCAInit() {
 var isAppInit = typeof(Sys$_Application$_doInitialize) != "undefined" &&
  _aspxFunctionIsInCallstack(arguments.callee, Sys$_Application$_doInitialize, 10 );
 aspxGetControlCollection().AtlasInitialize(!isAppInit);
}
function aspxCreateCallback(name, arg, command, callbackID){
 var control = aspxGetControlCollection().Get(name);
 if(control != null)
  control.CreateCallbackCore(unescape(arg), unescape(command), callbackID);
}
function aspxCallback(result, context){
 var collection = aspxGetControlCollection();
 collection.DoFinalizeCallback();
 var control = collection.Get(context);
 if(control != null)
  control.DoCallback(result);
}
function aspxCallbackError(result, context){
 var control = aspxGetControlCollection().Get(context);
 if(control != null)
  control.DoCallbackError(result, false);
}
function aspxCClick(name, evt) {
 var control = aspxGetControlCollection().Get(name);
 if(control != null) control.DoControlClick(evt);
}
_aspxAttachEventToElement(window, "resize", aspxGlobalWindowResize);
function aspxGlobalWindowResize(evt){
 aspxGetControlCollection().OnBrowserWindowResize(evt); 
}
_aspxAttachEventToElement(window, "load", aspxClassesWindowOnLoad);
function aspxClassesWindowOnLoad(evt){
 __aspxDocumentLoaded = true;
 ASPxResourceManager.SynchronizeResources();
 aspxGetControlCollection().Initialize();
 _aspxInitializeScripts();
 _aspxInitializeLinks();
 _aspxInitializeFocus();
}
function aspxFireDefaultButton(evt, buttonID) {
 if(_aspxIsDefaultButtonEvent(evt, buttonID)) {
  var defaultButton = _aspxGetElementById(buttonID);
  if(defaultButton && defaultButton.click) {
   if(_aspxIsFocusable(defaultButton))
    defaultButton.focus();
   _aspxDoElementClick(defaultButton);
   _aspxPreventEventAndBubble(evt);
   return false;
  }
 }
 return true;
}
function _aspxIsDefaultButtonEvent(evt, defaultButtonID) {
 if(evt.keyCode != ASPxKey.Enter)
  return false;
 var srcElement = _aspxGetEventSource(evt);
 if(!srcElement || srcElement.id === defaultButtonID)
  return true;
 var tagName = srcElement.tagName;
 var type = srcElement.type;
 return tagName != "TEXTAREA" && tagName != "BUTTON" && tagName != "A" &&
  (tagName != "INPUT" || type != "checkbox" && type != "radio" && type != "button" && type != "submit" && type != "reset");
}
ASPxResourceManager = {
 HandlerStr: "DXR.axd?r=",
 InputElements: {},
 ResourceHashes: {},
 SynchronizeResources: function(){
  this.SynchronizeResourcesElements(_aspxGetIncludeScripts(), "src", "DXScript");
 },
 SynchronizeResourcesElements: function(elements, urlAttr, id){
  var s = this.GetResourcesElementsString(elements, urlAttr, id);
  this.UpdateInputElement(id, s);
 },
 GetResourcesElementsString: function(elements, urlAttr, id){
  if(!this.ResourceHashes[id]) 
   this.ResourceHashes[id] = {};
  var hash = this.ResourceHashes[id];
  for(var i = 0; i < elements.length; i++) {
   var resourceUrl = _aspxGetAttribute(elements[i], urlAttr);
   if(resourceUrl) {
    var pos = resourceUrl.indexOf(this.HandlerStr);
    if(pos > -1){
     var list = resourceUrl.substr(pos + this.HandlerStr.length);
     var ampPos = list.lastIndexOf("-");
     if(ampPos > -1)
      list = list.substr(0, ampPos);
     var indexes = list.split(",");
     for(var j = 0; j < indexes.length; j++)
      hash[indexes[j]] = indexes[j];
    }
    else
     hash[resourceUrl] = resourceUrl;
   }
  }
  var array = [];
  for(var key in hash) 
   array.push(key);
  return array.join(",");
 },
 UpdateInputElement: function(typeName, list){
  var inputElement = this.InputElements[typeName];
  if(!_aspxIsExistsElement(inputElement)){
   inputElement = this.CreateInputElement(typeName);
   this.InputElements[typeName] = inputElement;
  }
  if(_aspxIsExistsElement(inputElement))
   inputElement.value = list;
 },
 CreateInputElement: function(typeName){
  var inputElement = _aspxCreateHiddenField(typeName);
  var form = _aspxGetServerForm();
  if(form) {
   form.appendChild(inputElement);
   return inputElement;
  }
  return null;
 }
};
var __aspxIncludeScriptPrefix = "dxis_";
var __aspxStartupScriptPrefix = "dxss_";
var __aspxIncludeScriptsCache = {};
var __aspxCreatedIncludeScripts = [];
var __aspxAppendedScriptsCount = 0;
var __aspxCallbackOwnerNames = [];
var __aspxScriptsRestartHandlers = { };
function _aspxGetScriptCode(script) {
 var text = __aspxWebKitFamily ? script.firstChild.data : script.text;
 var comment = "<!--";
 var pos = text.indexOf(comment);
 if(pos > -1)
  text = text.substr(pos + comment.length);
 return text;
}
function _aspxAppendScript(script) {
 var parent = document.getElementsByTagName("head")[0];
 if(!parent)
  parent = document.body;
 if(parent)
  parent.appendChild(script);
}
function _aspxIsAlphaFilterUsed(img){
 return (__aspxIE && __aspxBrowserVersion < 9 && img.style.filter.indexOf("progid:DXImageTransform.Microsoft.AlphaImageLoader") > -1);
}
function _aspxIsKnownIncludeScript(script) {
 return !!__aspxIncludeScriptsCache[script.src];
}
function _aspxCacheIncludeScript(script) {
 __aspxIncludeScriptsCache[script.src] = 1;
}
function _aspxProcessScriptsAndLinks(ownerName, isCallback) {
 if(!__aspxDocumentLoaded) return; 
 _aspxProcessScripts(ownerName, isCallback);
 _aspxSweepDuplicatedLinks();
 _aspxMoveLinkElements();
 __aspxCachedRules = { };
}
function _aspxGetStartupScripts() {
 return _aspxGetScriptsCore(__aspxStartupScriptPrefix);
}
function _aspxGetIncludeScripts() {
 return _aspxGetScriptsCore(__aspxIncludeScriptPrefix);
}
function _aspxGetScriptsCore(prefix) {
 var result = [];
 var scripts = document.getElementsByTagName("SCRIPT");
 for(var i = 0; i < scripts.length; i++) {
  if (scripts[i].id.indexOf(prefix) == 0)
   result.push(scripts[i]);
 }
 return result;
}
function _aspxGetLinks() {
 var result = [];
 var links = document.getElementsByTagName("LINK");;
 for(var i = 0; i < links.length; i++) 
  result[i] = links[i];
 return result;
}
function _aspxInitializeLinks() {
 var links = _aspxGetLinks();
 for(var i = 0; i < links.length; i++)
  links[i].loaded = true; 
}
function _aspxInitializeScripts() {
 var scripts = _aspxGetIncludeScripts();
 for(var i = 0; i < scripts.length; i++)
  _aspxCacheIncludeScript(scripts[i]);   
 var startupScripts = _aspxGetStartupScripts();
 for(var i = 0; i < startupScripts.length; i++)
  startupScripts[i].executed = true; 
}
function _aspxSweepDuplicatedLinks() {
 if((__aspxIE && __aspxBrowserVersion < 7) || __aspxOpera)
  return;
 var hash = { };
 var links = _aspxGetLinks();
 for(var i = 0; i < links.length; i++) {
  var href = links[i].href;
  if(!href)
   continue;
  if(hash[href]){
   if(!hash[href].loaded && links[i].loaded){
    _aspxRemoveElement(hash[href]);
    hash[href] = links[i];
   }
   else
    _aspxRemoveElement(links[i]);
  }
  else
   hash[href] = links[i];
 }
}
function _aspxSweepDuplicatedScripts() {
 var hash = { };
 var scripts = _aspxGetIncludeScripts();
 for(var i = 0; i < scripts.length; i++) {
  var src = scripts[i].src;
  if(!src) continue;
  if(hash[src])
   _aspxRemoveElement(scripts[i]);
  else
   hash[src] = scripts[i];
 }
}
function _aspxProcessScripts(ownerName, isCallback) {
 var scripts = _aspxGetIncludeScripts();
 var previousCreatedScript = null;
 var firstCreatedScript = null;
 for(var i = 0; i < scripts.length; i++) {
  var script = scripts[i];
  if(script.src == "") continue; 
  if(_aspxIsKnownIncludeScript(script))
   continue;
  var createdScript = document.createElement("script");
  createdScript.type = "text/javascript";
  createdScript.src = script.src;
  createdScript.id = script.id;
  function AreScriptsEqual(script1, script2) {
   return script1.src == script2.src;
  }
  if(_aspxArrayIndexOf(__aspxCreatedIncludeScripts, createdScript, AreScriptsEqual) >= 0)
   continue;
  __aspxCreatedIncludeScripts.push(createdScript);
  _aspxRemoveElement(script);
  if(__aspxIE && __aspxBrowserVersion < 9) {
   createdScript.onreadystatechange = new Function("_aspxOnScriptReadyStateChangedCallback(this, \"" + ownerName + "\");");
  } else if(__aspxWebKitFamily || (__aspxFirefox && __aspxBrowserVersion >= 4)) {
   createdScript.onload = new Function("_aspxOnScriptLoadCallback(this, \"" + ownerName + "\");");
   if(firstCreatedScript == null)
    firstCreatedScript = createdScript;
   createdScript.nextCreatedScript = null;
   if(previousCreatedScript != null)
    previousCreatedScript.nextCreatedScript = createdScript;
   previousCreatedScript = createdScript;
  } else {
   createdScript.onload = new Function("_aspxOnScriptLoadCallback(this, \"" + ownerName + "\");");
   _aspxAppendScript(createdScript);
   _aspxCacheIncludeScript(createdScript);
  }
 }
 if(firstCreatedScript != null) {
  _aspxAppendScript(firstCreatedScript);
  _aspxCacheIncludeScript(firstCreatedScript);
 }
 __aspxCallbackOwnerNames.push(ownerName);
 if(__aspxCreatedIncludeScripts.length == 0)
  _aspxFinalizeScriptProcessing(ownerName, isCallback);
}
function _aspxFinalizeScriptProcessing(ownerName, isCallback) {
 __aspxCreatedIncludeScripts = [];
 __aspxAppendedScriptsCount = 0;
 _aspxSweepDuplicatedScripts();
 _aspxRunStartupScripts(isCallback);
 ASPxResourceManager.SynchronizeResources();
 while(__aspxCallbackOwnerNames.length > 0) {
  var callbackOwnerName = __aspxCallbackOwnerNames.pop();
  var callbackOwner = aspxGetControlCollection().Get(callbackOwnerName);
  if(callbackOwner)
   callbackOwner.DoEndCallback();
 }
}
function _aspxRunStartupScripts(isCallback) {
 var scripts = _aspxGetStartupScripts();
 var code;
 for(var i = 0; i < scripts.length; i++){
  if(!scripts[i].executed) {
   code = _aspxGetScriptCode(scripts[i]);
   eval(code);
   scripts[i].executed = true;
  }
 }
 if(__aspxDocumentLoaded) 
  aspxGetControlCollection().InitializeElements(isCallback);
 for(var key in __aspxScriptsRestartHandlers)
  __aspxScriptsRestartHandlers[key]();
}
function _aspxOnScriptReadyStateChangedCallback(scriptElement, ownerName) {
 if(scriptElement.readyState == "loaded") {
  _aspxCacheIncludeScript(scriptElement);
  for(var i = 0; i < __aspxCreatedIncludeScripts.length; i++) {
   var script = __aspxCreatedIncludeScripts[i];
   if(_aspxIsKnownIncludeScript(script)) {
    if(!script.executed) {
     script.executed = true;
     _aspxAppendScript(script);
     __aspxAppendedScriptsCount++;
    }
   } else
    break;
  }
  if(__aspxCreatedIncludeScripts.length == __aspxAppendedScriptsCount)
   _aspxFinalizeScriptProcessing(ownerName);
 }
}
function _aspxOnScriptLoadCallback(scriptElement, ownerName) {
 __aspxAppendedScriptsCount++;
 if(scriptElement.nextCreatedScript) {
  _aspxAppendScript(scriptElement.nextCreatedScript);
  _aspxCacheIncludeScript(scriptElement.nextCreatedScript);
 }
 if(__aspxCreatedIncludeScripts.length == __aspxAppendedScriptsCount)
  _aspxFinalizeScriptProcessing(ownerName);
}
function _aspxAddScriptsRestartHandler(objectName, handler) {
 __aspxScriptsRestartHandlers[objectName] = handler;
}
function _aspxMoveLinkElements() {
 if(__aspxIE)
  return;
 var head = _aspxGetElementsByTagName(document, "head")[0];
 var bodyLinks = _aspxGetElementsByTagName(document.body, "link");
 for(var i = 0; i < bodyLinks.length; i++)
  head.appendChild(bodyLinks[i]);
}
_aspxToJson = function(param){
 var paramType = typeof(param);
 if((paramType == "undefined") || (param == null))
  return null;
 if((paramType == "object") && (typeof(param.__toJson) == "function"))
  return param.__toJson();
 if((paramType == "number") || (paramType == "boolean"))
  return param;
 if(param.constructor == Date)
  return "\"" + _aspxGetInvariantDateTimeString(param) + "\"";
 if(paramType == "string") {
  var result = param.replace(/\\/g, "\\\\");
  result = result.replace(/"/g, "\\\"");
  result = result.replace(/</g, "\\u003c");
  result = result.replace(/>/g, "\\u003e");
  return "\"" + result + "\"";
 }
 if(param.constructor == Array){
  var values = [];
  for(var i = 0; i < param.length; i++)
   values.push(_aspxToJson(param[i]));
  return "[" + values.join(",") + "]";
 }
 var exceptKeys = {};
 if(ASPxIdent.IsArray(param.__toJsonExceptKeys))
  exceptKeys = _aspxCreateHashTableFromArray(param.__toJsonExceptKeys);
 exceptKeys["__toJsonExceptKeys"] = 1;
 var values = [];
 for(var key in param){
  if(_aspxIsFunction(param[key]))
   continue;
  if(exceptKeys[key] == 1)
   continue;
  values.push(_aspxToJson(key) + ":" + _aspxToJson(param[key]));
 }
 return "{" + values.join(",") + "}";
}
function _aspxEmulateDocumentOnMouseDown(evt) {
 _aspxEmulateOnMouseDown(document, evt);
}
function _aspxEmulateOnMouseDown(element, evt) {
 if(__aspxIE && __aspxBrowserVersion < 9)
  element.fireEvent("onmousedown", evt);
 else if(!__aspxWebKitFamily){
  var emulatedEvt = document.createEvent("MouseEvents");
  emulatedEvt.initMouseEvent("mousedown", true, true, window, 0, evt.screenX, evt.screenY, 
   evt.clientX, evt.clientY, evt.ctrlKey, evt.altKey, evt.shiftKey, false, 0, null);
  element.dispatchEvent(emulatedEvt);
 }
}
function _aspxCreateHtmlElementFromString(str) {
 var dummy = document.createElement("DIV");
 dummy.innerHTML = str;
 return dummy.firstChild;
}
ASPxIFrame = _aspxCreateClass(null, {
 constructor: function(params) {
  this.params = params || {};
  this.params.src = this.params.src || "";
  this.CreateElements();
 },
 CreateElements: function() {
  var elements = ASPxIFrame.Create(this.params);
  this.containerElement = elements.container;
  this.iframeElement = elements.iframe;
  this.AttachOnLoadHandler(this, this.iframeElement);
  this.SetLoading(true);
  if(this.params.onCreate)
   this.params.onCreate(this.containerElement, this.iframeElement);
 },
 AttachOnLoadHandler: function(instance, element) {
  _aspxAttachEventToElement(element, "load", function() {
   instance.OnLoad(element);
  });
 },
 OnLoad: function(element) {
  this.SetLoading(false, element);
 },
 IsLoading: function(element) {
  element = element || this.iframeElement;
  if(element)
   return element.loading;
  return false;
 },
 SetLoading: function(value, element) {
  element = element || this.iframeElement;
  if(element)
   element.loading = value;
 },
 GetContentUrl: function() {
  return this.params.src;
 },
 SetContentUrl: function(url, preventBrowserCaching) {
  if(url) {
   this.params.src = url;
   if(preventBrowserCaching)
    url = ASPxIFrame.AddRandomParamToUrl(url);
   this.SetLoading(true);
   this.iframeElement.src = url;
  }
 },
 RefreshContentUrl: function() {
  if(this.IsLoading())
   return;
  this.SetLoading(true);
  var oldContainerElement = this.containerElement;
  var oldIframeElement = this.iframeElement;
  var postfix = "_del" + Math.floor(Math.random()*100000).toString();
  if(this.params.id)
   oldIframeElement.id = this.params.id + postfix;
  if(this.params.name)
   oldIframeElement.name = this.params.name + postfix;
  oldContainerElement.style.height = "0px";
  this.CreateElements();
  oldIframeElement.src = "about:blank";
  window.setTimeout(function() {
   oldContainerElement.parentNode.removeChild(oldContainerElement);
  }, 10000); 
 }
});
ASPxIFrame.Create = function(params) {
 var iframeHtmlStringParts = [ "<iframe frameborder='0'" ];
 if(params) {
  if(params.id)
   iframeHtmlStringParts.push(" id='", params.id, "'");
  if(params.name)
   iframeHtmlStringParts.push(" name='", params.name, "'");
  if(params.title)
   iframeHtmlStringParts.push(" title='", params.title, "'");
  if(params.scrolling)
   iframeHtmlStringParts.push(" scrolling='", params.scrolling, "'");
  if(params.src)
   iframeHtmlStringParts.push(" src='", params.src, "'");
 }
 iframeHtmlStringParts.push("></iframe>");
 var containerElement = _aspxCreateHtmlElementFromString("<div style='border-width: 0px; padding: 0px; margin: 0px'></div>");
 var iframeElement = _aspxCreateHtmlElementFromString(iframeHtmlStringParts.join(""));
 containerElement.appendChild(iframeElement);
 return {
  container: containerElement,
  iframe: iframeElement
 };
};
ASPxIFrame.AddRandomParamToUrl = function(url) {
 var prefix = url.indexOf("?") > -1
  ? "&"
  : "?";
 var param = prefix + Math.floor(Math.random()*100000).toString();
 var anchorIndex = url.indexOf("#");
 return anchorIndex == -1
  ? url + param
  : url.substr(0, anchorIndex) + param + url.substr(anchorIndex);
};
ASPxKbdHelper = _aspxCreateClass(null, {
 constructor: function(control) {
  this.control = control;
 },
 Init: function() {
  ASPxKbdHelper.GlobalInit();
  var element = this.GetFocusableElement();
  element.tabIndex = Math.max(element.tabIndex, 0);
  var instance = this;
  _aspxAttachEventToElement(element, "click", function(e) {
   instance.HandleClick(e);
  });  
  _aspxAttachEventToElement(element, "focus", function(e) {    
   if(!instance.CanFocus(e))
    return true;
   ASPxKbdHelper.active = instance;
  });
  _aspxAttachEventToElement(element, "blur", function() {
   delete ASPxKbdHelper.active;
  });    
 },
 GetFocusableElement: function() { return this.control.GetMainElement(); },
 CanFocus: function(e) {
  var tag = _aspxGetEventSource(e).tagName;
  if(tag == "A" || tag == "TEXTAREA" || tag == "INPUT" || tag == "SELECT")
   return false; 
  return true;
 },
 HandleClick: function(e) {
  if(!this.CanFocus(e))
   return;
  this.Focus();
 },
 Focus: function() {
  this.GetFocusableElement().focus();   
 },
 HandleKeyDown: function(e) { }, 
 HandleKeyPress: function(e) { }, 
 HandleKeyUp: function(e) { }
});
ASPxKbdHelper.GlobalInit = function() {
 if(ASPxKbdHelper.ready)
  return;
 _aspxAttachEventToDocument("keydown", ASPxKbdHelper.OnKeyDown);
 _aspxAttachEventToDocument("keypress", ASPxKbdHelper.OnKeyPress);
 _aspxAttachEventToDocument("keyup", ASPxKbdHelper.OnKeyUp);
 ASPxKbdHelper.ready = true; 
};
ASPxKbdHelper.swallowKey = false;
ASPxKbdHelper.accessKeys = { };
ASPxKbdHelper.ProcessKey = function(e, actionName) {
 if(!ASPxKbdHelper.active) 
  return;
 if(!ASPxKbdHelper.swallowKey) 
  ASPxKbdHelper.swallowKey = ASPxKbdHelper.active[actionName](e);
 if(ASPxKbdHelper.swallowKey)
  _aspxPreventEvent(e);
};
ASPxKbdHelper.OnKeyDown = function(e) {
 ASPxKbdHelper.swallowKey = false; 
 if(e.ctrlKey && e.shiftKey && ASPxKbdHelper.TryAccessKey(_aspxGetKeyCode(e)))
  _aspxPreventEvent(e);  
 else 
  ASPxKbdHelper.ProcessKey(e, "HandleKeyDown"); 
};
ASPxKbdHelper.OnKeyPress = function(e) { ASPxKbdHelper.ProcessKey(e, "HandleKeyPress"); };
ASPxKbdHelper.OnKeyUp = function(e) { ASPxKbdHelper.ProcessKey(e, "HandleKeyUp"); };
ASPxKbdHelper.RegisterAccessKey = function(obj) {
 var key = obj.accessKey;
 if(!key) return;
 ASPxKbdHelper.accessKeys[key.toLowerCase()] = obj.name;
};
ASPxKbdHelper.TryAccessKey = function(code) {
 var name = ASPxKbdHelper.accessKeys[String.fromCharCode(code).toLowerCase()];
 if(!name) return false;
 var obj = aspxGetControlCollection().Get(name);
 if(!obj) return false;
 var el = obj.GetMainElement();
 if(!el) return false;
 el.focus();
 return true;
};
function _aspxDelayedFunctionCall(object, functionName) {
 var callTimerIdPropertyName = "delayed" + functionName + "CallTimerId";
 var additionalCallRequiredPropertyName = "delayed" + functionName + "AdditionalCallRequired";
 if(!object[callTimerIdPropertyName] || object[callTimerIdPropertyName] == -1) {
  var timeoutFunction = function() {
   object[functionName]();
   object[callTimerIdPropertyName] = _aspxClearTimer(object[callTimerIdPropertyName]);
   if(object[additionalCallRequiredPropertyName]) {
    object[additionalCallRequiredPropertyName] = false;
    object[callTimerIdPropertyName] = _aspxSetTimeout(timeoutFunction, 0);
   }
  };
  object[callTimerIdPropertyName] = _aspxSetTimeout(timeoutFunction, 0);
 }
 else
  object[additionalCallRequiredPropertyName] = true;
}
var __aspxFocusedElement = null;
function aspxOnElementFocused(evt) {
 evt = _aspxGetEvent(evt);
 if(evt && evt.target)
  __aspxFocusedElement = evt.target;
}
function _aspxInitializeFocus() {
 if(!document.activeElement)
  _aspxAttachEventToDocument("focus", aspxOnElementFocused);
}
function _aspxGetFocusedElement() {
 var activeElement = _aspxGetActiveElement();
 return activeElement ? activeElement : __aspxFocusedElement;
}
function _aspxChangeElementContainer(element, container, savePreviousContainer) {
 if(element.parentNode != container) {
  var parentNode = element.parentNode;
  parentNode.removeChild(element);
  container.appendChild(element);
  if(savePreviousContainer)
   element.previousContainer = parentNode;
 }
}
function _aspxRestoreElementContainer(element) {
 if(element.previousContainer) {
  _aspxChangeElementContainer(element, element.previousContainer, false);
  element.previousContainer = null;
 }
}
var ASPxCacheHelper = {};
ASPxCacheHelper.GetCachedValue = function(obj, cacheName, func, cacheObj) {
 if(!cacheObj)
  cacheObj = obj;
 if(!cacheObj.cache)
  cacheObj.cache = {};
 if(!_aspxIsExists(cacheObj.cache[cacheName]))
  cacheObj.cache[cacheName] = func.apply(obj, []);
 return cacheObj.cache[cacheName];
};
ASPxCacheHelper.DropCachedValue = function(cacheObj, cacheName) {
 cacheObj.cache[cacheName] = null;
};  
ASPxClientUtils = {};
ASPxClientUtils.agent = __aspxUserAgent;
ASPxClientUtils.opera = __aspxOpera;
ASPxClientUtils.opera9 = __aspxOpera && __aspxBrowserMajorVersion == 9;
ASPxClientUtils.safari = __aspxSafari;
ASPxClientUtils.safari3 = __aspxSafari && __aspxBrowserMajorVersion == 3;
ASPxClientUtils.safariMacOS = __aspxSafari && __aspxMacOSPlatform;
ASPxClientUtils.chrome = __aspxChrome;
ASPxClientUtils.ie = __aspxIE;
ASPxClientUtils.ie55 = __aspxIE && __aspxBrowserVersion == 5.5;
;
ASPxClientUtils.ie7 = __aspxIE && __aspxBrowserMajorVersion == 7;
ASPxClientUtils.firefox = __aspxFirefox;
ASPxClientUtils.firefox3 = __aspxFirefox && __aspxBrowserMajorVersion == 3;
ASPxClientUtils.mozilla = __aspxMozilla;
ASPxClientUtils.netscape = __aspxNetscape;
ASPxClientUtils.browserVersion = __aspxBrowserVersion;
ASPxClientUtils.browserMajorVersion = __aspxBrowserMajorVersion;
ASPxClientUtils.macOSPlatform = __aspxMacOSPlatform;
ASPxClientUtils.windowsPlatform = __aspxWindowsPlatform;
ASPxClientUtils.webKitFamily = __aspxWebKitFamily;
ASPxClientUtils.netscapeFamily = __aspxNetscapeFamily;
ASPxClientUtils.ArrayInsert = _aspxArrayInsert;
ASPxClientUtils.ArrayRemove = _aspxArrayRemove;
ASPxClientUtils.ArrayRemoveAt = _aspxArrayRemoveAt;
ASPxClientUtils.ArrayClear = _aspxArrayClear;
ASPxClientUtils.ArrayIndexOf = _aspxArrayIndexOf;
ASPxClientUtils.AttachEventToElement = _aspxAttachEventToElement;
ASPxClientUtils.DetachEventFromElement = _aspxDetachEventFromElement;
ASPxClientUtils.GetEventSource = _aspxGetEventSource;
ASPxClientUtils.GetEventX = _aspxGetEventX;
ASPxClientUtils.GetEventY = _aspxGetEventY;
ASPxClientUtils.GetKeyCode = _aspxGetKeyCode;
ASPxClientUtils.PreventEvent = _aspxPreventEvent;
ASPxClientUtils.PreventEventAndBubble = _aspxPreventEventAndBubble;
ASPxClientUtils.PreventDragStart = _aspxPreventDragStart;
ASPxClientUtils.ClearSelection = _aspxClearSelection;
ASPxClientUtils.IsExists = _aspxIsExists;
ASPxClientUtils.IsFunction = _aspxIsFunction;
ASPxClientUtils.GetAbsoluteX = _aspxGetAbsoluteX;
ASPxClientUtils.GetAbsoluteY = _aspxGetAbsoluteY;
ASPxClientUtils.SetAbsoluteX = _aspxSetAbsoluteX;
ASPxClientUtils.SetAbsoluteY = _aspxSetAbsoluteY;
ASPxClientUtils.GetDocumentScrollTop = _aspxGetDocumentScrollTop;
ASPxClientUtils.GetDocumentScrollLeft = _aspxGetDocumentScrollLeft;
ASPxClientUtils.GetDocumentClientWidth = _aspxGetDocumentClientWidth;
ASPxClientUtils.GetDocumentClientHeight = _aspxGetDocumentClientHeight;
ASPxClientUtils.GetIsParent = _aspxGetIsParent;
ASPxClientUtils.GetParentById = _aspxGetParentById;
ASPxClientUtils.GetParentByTagName = _aspxGetParentByTagName;
ASPxClientUtils.GetParentByClassName = _aspxGetParentByPartialClassName;
ASPxClientUtils.GetChildById = _aspxGetChildById;
ASPxClientUtils.GetChildByTagName = _aspxGetChildByTagName;
ASPxClientUtils.SetCookie = _aspxSetCookie;
ASPxClientUtils.GetCookie = _aspxGetCookie;
ASPxClientUtils.DeleteCookie = _aspxDelCookie;
ASPxClientUtils.GetShortcutCode = _aspxGetShortcutCode; 
ASPxClientUtils.GetShortcutCodeByEvent = _aspxGetShortcutCodeByEvent;
ASPxClientUtils.StringToShortcutCode = _aspxParseShortcutString;
ASPxClientUtils.Trim = _aspxTrim; 
ASPxClientUtils.TrimStart = _aspxTrimStart;
ASPxClientUtils.TrimEnd = _aspxTrimEnd;
__aspxClassesScriptParsed = true;

var __aspxStateItemsExist = false;
var __aspxHoverStyleSheet = null;
var __aspxPressedStyleSheet = null;
var __aspxSelectedStyleSheet = null;
var __aspxDisabledStyleSheet = null;
var __aspxFocusedItemKind = "FocusedStateItem";
var __aspxHoverItemKind = "HoverStateItem";
var __aspxPressedItemKind = "PressedStateItem";
var __aspxSelectedItemKind = "SelectedStateItem";
var __aspxDisabledItemKind = "DisabledStateItem";
var __aspxCachedStatePrefix = "cached";
ASPxStateItem = _aspxCreateClass(null, {
 constructor: function(name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes, kind){
  this.name = name;
  this.classNames = classNames;
  this.customClassNames = [];
  this.resultClassNames = [];
  this.cssTexts = cssTexts;
  this.postfixes = postfixes;
  this.imageObjs = imageObjs;
  this.imagePostfixes = imagePostfixes;
  this.kind = kind;
  this.enabled = true;
  this.needRefreshBetweenElements = false;
  this.elements = null;
  this.images = null;
  this.linkColor = null;
  this.lintTextDecoration = null;
 },
 GetCssText: function(index){
  if(_aspxIsExists(this.cssTexts[index]))
   return this.cssTexts[index];
  return this.cssTexts[0];
 },
 CreateStyleRule: function(index){
  if(this.GetCssText(index) == "") return "";
  var styleSheet = this.GetStyleSheet();
  if(styleSheet)
   return _aspxCreateImportantStyleRule(styleSheet, this.GetCssText(index));  
  return ""; 
 },
 GetClassName: function(index){
  if(_aspxIsExists(this.classNames[index]))
   return this.classNames[index];
  return this.classNames[0];
 },
 GetResultClassName: function(index){
  if(!_aspxIsExists(this.resultClassNames[index])) {
   if(!_aspxIsExists(this.customClassNames[index]))
    this.customClassNames[index] = this.CreateStyleRule(index);
   if(this.GetClassName(index) != "" && this.customClassNames[index] != "")
    this.resultClassNames[index] = this.GetClassName(index) + " " + this.customClassNames[index];
   else if(this.GetClassName(index) != "")
    this.resultClassNames[index] = this.GetClassName(index);
   else if(this.customClassNames[index] != "")
    this.resultClassNames[index] = this.customClassNames[index];
   else
    this.resultClassNames[index] = "";
  }
  return this.resultClassNames[index];
 },
 GetStyleSheet: function(){
  if(!__aspxDisabledStyleSheet)
   __aspxDisabledStyleSheet = _aspxCreateStyleSheet();
  if(!__aspxSelectedStyleSheet)
   __aspxSelectedStyleSheet = _aspxCreateStyleSheet();
  if(!__aspxHoverStyleSheet)
   __aspxHoverStyleSheet = _aspxCreateStyleSheet();
  if(!__aspxPressedStyleSheet)
   __aspxPressedStyleSheet = _aspxCreateStyleSheet();
  switch(this.kind){
   case __aspxDisabledItemKind:
    return __aspxDisabledStyleSheet;
   case __aspxHoverItemKind:
    return __aspxHoverStyleSheet;
   case __aspxPressedItemKind:
    return __aspxPressedStyleSheet;
   case __aspxSelectedItemKind:
    return __aspxSelectedStyleSheet;
  }
  return null;
 },
 GetElements: function(element){
  if(!this.elements || !_aspxIsValidElements(this.elements)){
   if(this.postfixes && this.postfixes.length > 0){
    this.elements = [ ];
    var parentNode = element.parentNode;
    if(parentNode){
     for(var i = 0; i < this.postfixes.length; i++){
      var id = this.name + this.postfixes[i];
      this.elements[i] = _aspxGetChildById(parentNode, id);
      if(!this.elements[i])
       this.elements[i] = _aspxGetElementById(id);
     }
    }
   }
   else
    this.elements = [element];
  }
  return this.elements;
 },
 GetImages: function(element){
  if(!this.images || !_aspxIsValidElements(this.images)){
   this.images = [ ];
   if(this.imagePostfixes && this.imagePostfixes.length > 0){
    var elements = this.GetElements(element);
    for(var i = 0; i < this.imagePostfixes.length; i++){
     var id = this.name + this.imagePostfixes[i];
     for(var j = 0; j < elements.length; j++){
      if(!elements[j]) continue;
      if(elements[j].id == id)
       this.images[i] = elements[j];
      else
       this.images[i] = _aspxGetChildById(elements[j], id);
      if(this.images[i])
       break;
     }
    }
   }
  }
  return this.images;
 },
 Apply: function(element){
  if(!this.enabled) return;
  try{
   this.ApplyStyle(element);
   if(this.imageObjs && this.imageObjs.length > 0)
    this.ApplyImage(element);
  }
  catch(e){
  }
 },
 ApplyStyle: function(element){
  var elements = this.GetElements(element);
  for(var i = 0; i < elements.length; i++){
   if(!elements[i]) continue;
   var className = elements[i].className.replace(this.GetResultClassName(i), "");
   elements[i].className = _aspxTrim(className) + " " + this.GetResultClassName(i);
   if(!__aspxOpera || __aspxBrowserVersion >= 9)
    this.ApplyStyleToLinks(elements, i);
  }
 },
 ApplyStyleToLinks: function(elements, index){
  var linkCount = 0;
  var savedLinkCount = -1;
  if(_aspxIsExists(elements[index]["savedLinkCount"]))
   savedLinkCount = parseInt(elements[index]["savedLinkCount"]);
  do{
   if(savedLinkCount > -1 && savedLinkCount <= linkCount)
    break;
   var link = elements[index]["link" + linkCount];
   if(!link){
    link = _aspxGetChildByTagName(elements[index], "A", linkCount);
    if(!link)
     link = _aspxGetChildByTagName(elements[index], "SPAN", linkCount); 
    if(link)
     elements[index]["link" + linkCount] = link;
   }
   if(link)
    this.ApplyStyleToLinkElement(link, index);
   else
    elements[index]["savedLinkCount"] = linkCount;
   linkCount++;
  }
  while(link != null)
 },
 ApplyStyleToLinkElement: function(link, index){
  if(this.GetLinkColor(index) != "")
   _aspxChangeAttributeExtended(link.style, "color", link, "saved" + this.kind + "Color", this.GetLinkColor(index));
  if(this.GetLinkTextDecoration(index) != "")
   _aspxChangeAttributeExtended(link.style, "textDecoration", link, "saved" + this.kind + "TextDecoration", this.GetLinkTextDecoration(index));
 },
 ApplyImage: function(element){
  var images = this.GetImages(element);
  for(var i = 0; i < images.length; i++){
   if(!images[i] || !this.imageObjs[i]) continue;
   if(_aspxIsAlphaFilterUsed(images[i]))   
    _aspxChangeAttributeExtended(images[i].style, "filter", images[i], "saved" + this.kind + "Filter", 
     "progid:DXImageTransform.Microsoft.AlphaImageLoader(src=" + this.imageObjs[i] + ", sizingMethod=scale)");    
   else{
    var useSpriteImage = typeof(this.imageObjs[i]) != "string";
    var newUrl = "", newCssClass = "", newBackground = "";
    if(useSpriteImage){
     newUrl = __aspxEmptyImageUrl;           
     if(this.imageObjs[i].spriteCssClass) 
      newCssClass = this.imageObjs[i].spriteCssClass;
     if(this.imageObjs[i].spriteBackground)
      newBackground = this.imageObjs[i].spriteBackground;
    }
    else{
     newUrl = this.imageObjs[i];
     if(_aspxIsExistsAttribute(images[i].style, "background"))   
      newBackground = " ";
    }
    if(newUrl != "")
     _aspxChangeAttributeExtended(images[i], "src", images[i], "saved" + this.kind + "Src", newUrl);
    if(newCssClass != "")
     this.ApplyImageClassName(images[i], newCssClass);
    if(newBackground != ""){
     if(__aspxWebKitFamily) {
      var savedBackground = _aspxGetAttribute(images[i].style, "background") + " " + images[i].style["backgroundPosition"];
      _aspxSetAttribute(images[i], "saved" + this.kind + "Background", savedBackground);
      _aspxSetAttribute(images[i].style, "background", newBackground);
     }
     else
      _aspxChangeAttributeExtended(images[i].style, "background", images[i], "saved" + this.kind + "Background", newBackground);
    }     
   }
  }
 },
 ApplyImageClassName: function(element, newClassName){
  var className = element.className.replace(newClassName, "");
  _aspxSetAttribute(element, "saved" + this.kind + "ClassName", className);
  element.className = className + " " + newClassName;
 },
 Cancel: function(element){
  if(!this.enabled) return;
  try{  
   this.CancelStyle(element);
   if(this.imageObjs && this.imageObjs.length > 0)
    this.CancelImage(element);
  }
  catch(e){
  }
 },
 CancelStyle: function(element){
  var elements = this.GetElements(element);
  for(var i = 0; i < elements.length; i++){
   if(!elements[i]) continue;
   var className = _aspxTrim(elements[i].className.replace(this.GetResultClassName(i), ""));
   elements[i].className = className;
   if(!__aspxOpera || __aspxBrowserVersion >= 9)
    this.CancelStyleFromLinks(elements, i);
  }
 },
 CancelStyleFromLinks: function(elements, index){
  var linkCount = 0;
  var savedLinkCount = -1;
  if(_aspxIsExists(elements[index]["savedLinkCount"]))
   savedLinkCount = parseInt(elements[index]["savedLinkCount"]);
  do{
   if(savedLinkCount > -1 && savedLinkCount <= linkCount)
    break;
   var link = elements[index]["link" + linkCount];
   if(!link){
    link = _aspxGetChildByTagName(elements[index], "A", linkCount);
    if(!link)
     link = _aspxGetChildByTagName(elements[index], "SPAN", linkCount); 
    if(link)
     elements[index]["link" + linkCount] = link;
   }
   if(link)
    this.CancelStyleFromLinkElement(link, index);
   else
    elements[index]["savedLinkCount"] = linkCount;
   linkCount++;
  }
  while(link != null)
 },
 CancelStyleFromLinkElement: function(link, index){
  if(this.GetLinkColor(index) != "")
   _aspxRestoreAttributeExtended(link.style, "color", link, "saved" + this.kind + "Color");
  if(this.GetLinkTextDecoration(index) != "")
   _aspxRestoreAttributeExtended(link.style, "textDecoration", link, "saved" + this.kind + "TextDecoration");
 },
 CancelImage: function(element){
  var images = this.GetImages(element);
  for(var i = 0; i < images.length; i++){
   if(!images[i] || !this.imageObjs[i]) continue;
   if(_aspxIsAlphaFilterUsed(images[i]))
    _aspxRestoreAttributeExtended(images[i].style, "filter", images[i], "saved" + this.kind + "Filter");
   else{
    _aspxRestoreAttributeExtended(images[i], "src", images[i], "saved" + this.kind + "Src");
    this.CancelImageClassName(images[i]);
    _aspxRestoreAttributeExtended(images[i].style, "background", images[i], "saved" + this.kind + "Background");
   }
  }
 },
 CancelImageClassName: function(element){
  var savedClassName = _aspxGetAttribute(element, "saved" + this.kind + "ClassName");
  if(_aspxIsExists(savedClassName)) {
   element.className = savedClassName;
   _aspxRemoveAttribute(element, "saved" + this.kind + "ClassName");
  }
 },
 Clone: function(){
  return new ASPxStateItem(this.name, this.classNames, this.cssTexts, this.postfixes, 
   this.imageObjs, this.imagePostfixes, this.kind);
 },
 IsChildElement: function(element){
  if(element != null){
   var elements = this.GetElements(element);
   for(var i = 0; i < elements.length; i++){
    if(!elements[i]) continue;
    if(_aspxGetIsParent(elements[i], element)) 
     return true;
   }
  }
  return false;
 },
 GetLinkColor: function(index){
  if(!_aspxIsExists(this.linkColor)){
   var rule = _aspxGetStyleSheetRule(this.customClassNames[index]);
   this.linkColor = rule ? rule.style.color : null;
   if(!_aspxIsExists(this.linkColor)){
    var rule = _aspxGetStyleSheetRule(this.GetClassName(index));
    this.linkColor = rule ? rule.style.color : null;
   }
   if(this.linkColor == null) 
    this.linkColor = "";
  }
  return this.linkColor;
 },
 GetLinkTextDecoration: function(index){
  if(!_aspxIsExists(this.linkTextDecoration)){
   var rule = _aspxGetStyleSheetRule(this.customClassNames[index]);
   this.linkTextDecoration = rule ? rule.style.textDecoration : null;
   if(!_aspxIsExists(this.linkTextDecoration)){
    var rule = _aspxGetStyleSheetRule(this.GetClassName(index));
    this.linkTextDecoration = rule ? rule.style.textDecoration : null;
   }
   if(this.linkTextDecoration == null) 
    this.linkTextDecoration = "";
  }
  return this.linkTextDecoration;
 }
});
ASPxClientStateEventArgs = _aspxCreateClass(null, {
 constructor: function(item, element){
  this.item = item;
  this.element = element;
  this.toElement = null;
  this.fromElement = null;
  this.htmlEvent = null;
 }
});
ASPxStateController = _aspxCreateClass(null, {
 constructor: function(){
  this.focusedItems = { };
  this.hoverItems = { };
  this.pressedItems = { };
  this.selectedItems = { };
  this.disabledItems = { };
  this.currentFocusedElement = null;
  this.currentFocusedItemName = null;
  this.currentHoverElement = null;
  this.currentHoverItemName = null;
  this.currentPressedElement = null;
  this.currentPressedItemName = null;
  this.savedCurrentPressedElement = null;
  this.savedCurrentMouseMoveSrcElement = null;
  this.AfterSetFocusedState = new ASPxClientEvent();
  this.AfterClearFocusedState = new ASPxClientEvent();
  this.AfterSetHoverState = new ASPxClientEvent();
  this.AfterClearHoverState = new ASPxClientEvent();
  this.AfterSetPressedState = new ASPxClientEvent();
  this.AfterClearPressedState = new ASPxClientEvent();
  this.AfterDisabled = new ASPxClientEvent();
  this.AfterEnabled = new ASPxClientEvent();
  this.BeforeSetFocusedState = new ASPxClientEvent();
  this.BeforeClearFocusedState = new ASPxClientEvent();
  this.BeforeSetHoverState = new ASPxClientEvent();
  this.BeforeClearHoverState = new ASPxClientEvent();
  this.BeforeSetPressedState = new ASPxClientEvent();
  this.BeforeClearPressedState = new ASPxClientEvent();
  this.BeforeDisabled = new ASPxClientEvent();
  this.BeforeEnabled = new ASPxClientEvent();
  this.FocusedItemKeyDown = new ASPxClientEvent();
 }, 
 AddHoverItem: function(name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes){
  this.AddItem(this.hoverItems, name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes, __aspxHoverItemKind);
  this.AddItem(this.focusedItems, name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes, __aspxFocusedItemKind);
 },
 AddPressedItem: function(name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes){
  this.AddItem(this.pressedItems, name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes, __aspxPressedItemKind);
 },
 AddSelectedItem: function(name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes){
  this.AddItem(this.selectedItems, name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes, __aspxSelectedItemKind);
 },
 AddDisabledItem: function(name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes){
  this.AddItem(this.disabledItems, name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes, __aspxDisabledItemKind);
 },
 AddItem: function(items, name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes, kind){
  var stateItem = new ASPxStateItem(name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes, kind);
  if(postfixes && postfixes.length > 0){
   for(var i = 0; i < postfixes.length; i ++){
    items[name + postfixes[i]] = stateItem;
   }
  }
  else
   items[name] = stateItem;
  __aspxStateItemsExist = true;
 },
 RemoveHoverItem: function(name){
  this.RemoveItem(this.hoverItems, name);
  this.RemoveItem(this.focusedItems, name);
 },
 RemovePressedItem: function(name){
  this.RemoveItem(this.pressedItems, name);
 },
 RemoveSelectedItem: function(name){
  this.RemoveItem(this.selectedItems, name);
 },
 RemoveDisabledItem: function(name){
  this.RemoveItem(this.disabledItems, name);
 },
 RemoveItem: function(items, name){
  delete items[name];
 },
 GetFocusedElement: function(srcElement){
  return this.GetItemElement(srcElement, this.focusedItems, __aspxFocusedItemKind);
 },
 GetHoverElement: function(srcElement){
  return this.GetItemElement(srcElement, this.hoverItems, __aspxHoverItemKind);
 },
 GetPressedElement: function(srcElement){
  return this.GetItemElement(srcElement, this.pressedItems, __aspxPressedItemKind);
 },
 GetSelectedElement: function(srcElement){
  return this.GetItemElement(srcElement, this.selectedItems, __aspxSelectedItemKind);
 },
 GetDisabledElement: function(srcElement){
  return this.GetItemElement(srcElement, this.disabledItems, __aspxDisabledItemKind);
 },
 GetItemElement: function(srcElement, items, kind){
  if(srcElement && srcElement[__aspxCachedStatePrefix + kind]){
   var cachedElement = srcElement[__aspxCachedStatePrefix + kind];
   if(cachedElement != __aspxEmptyCachedValue)
    return cachedElement;
   return null;
  }
  var element = srcElement;
  while(element != null) {
   var item = items[element.id];
   if(item){
    this.CacheItemElement(srcElement, kind, element);
    element[kind] = item;
    return element;
   }
   element = element.parentNode;
  }
  this.CacheItemElement(srcElement, kind, __aspxEmptyCachedValue);
  return null;
 },
 CacheItemElement: function(srcElement, kind, value){
  if(srcElement && !srcElement[__aspxCachedStatePrefix + kind])
   srcElement[__aspxCachedStatePrefix + kind] = value;
 },
 DoSetFocusedState: function(element, fromElement){
  var item = element[__aspxFocusedItemKind];
  if(item){
   var args = new ASPxClientStateEventArgs(item, element);
   args.fromElement = fromElement;
   this.BeforeSetFocusedState.FireEvent(this, args);
   item.Apply(element);
   this.AfterSetFocusedState.FireEvent(this, args);
  }
 },
 DoClearFocusedState: function(element, toElement){
  var item = element[__aspxFocusedItemKind];
  if(item){
   var args = new ASPxClientStateEventArgs(item, element);
   args.toElement = toElement;
   this.BeforeClearFocusedState.FireEvent(this, args);
   item.Cancel(element);
   this.AfterClearFocusedState.FireEvent(this, args);
  }
 },
 DoSetHoverState: function(element, fromElement){
  var item = element[__aspxHoverItemKind];
  if(item){
   var args = new ASPxClientStateEventArgs(item, element);
   args.fromElement = fromElement;
   this.BeforeSetHoverState.FireEvent(this, args);
   item.Apply(element);
   this.AfterSetHoverState.FireEvent(this, args);
  }
 },
 DoClearHoverState: function(element, toElement){
  var item = element[__aspxHoverItemKind];
  if(item){
   var args = new ASPxClientStateEventArgs(item, element);
   args.toElement = toElement;
   this.BeforeClearHoverState.FireEvent(this, args);
   item.Cancel(element);
   this.AfterClearHoverState.FireEvent(this, args);
  }
 },
 DoSetPressedState: function(element){
  var item = element[__aspxPressedItemKind];
  if(item){
   var args = new ASPxClientStateEventArgs(item, element);
   this.BeforeSetPressedState.FireEvent(this, args);
   item.Apply(element);
   this.AfterSetPressedState.FireEvent(this, args);
  }
 },
 DoClearPressedState: function(element){
  var item = element[__aspxPressedItemKind];
  if(item){
   var args = new ASPxClientStateEventArgs(item, element);
   this.BeforeClearPressedState.FireEvent(this, args);
   item.Cancel(element);
   this.AfterClearPressedState.FireEvent(this, args);
  }
 },
 SetCurrentFocusedElement: function(element){
  if(this.currentFocusedElement && !_aspxIsValidElement(this.currentFocusedElement)){
   this.currentFocusedElement = null;
   this.currentFocusedItemName = "";
  }
  if(this.currentFocusedElement != element){
   var oldCurrentFocusedElement = this.currentFocusedElement;
   var item = (element != null) ? element[__aspxFocusedItemKind] : null;
   var itemName = (item != null) ? item.name : "";
   if(this.currentFocusedItemName != itemName){
    if(this.currentHoverItemName != "")
     this.SetCurrentHoverElement(null);
    if(this.currentFocusedElement != null)
     this.DoClearFocusedState(this.currentFocusedElement, element);
    this.currentFocusedElement = element;
    item = (element != null) ? element[__aspxFocusedItemKind] : null;
    this.currentFocusedItemName = (item != null) ? item.name : "";
    if(this.currentFocusedElement != null)
     this.DoSetFocusedState(this.currentFocusedElement, oldCurrentFocusedElement);
   }
  }
 },
 SetCurrentHoverElement: function(element){
  if(this.currentHoverElement && !_aspxIsValidElement(this.currentHoverElement)){
   this.currentHoverElement = null;
   this.currentHoverItemName = "";
  }
  if(this.currentHoverElement != element){
   var oldCurrentHoverElement = this.currentHoverElement;
   var item = (element != null) ? element[__aspxHoverItemKind] : null;
   var itemName = (item != null) ? item.name : "";
   if(this.currentHoverItemName != itemName || (item != null && item.needRefreshBetweenElements)){
    if(this.currentFocusedItemName != "")
     this.SetCurrentFocusedElement(null);
    if(this.currentHoverElement != null)
     this.DoClearHoverState(this.currentHoverElement, element);
    item = (element != null) ? element[__aspxHoverItemKind] : null;
    if(item == null || item.enabled){
     this.currentHoverElement = element;
     this.currentHoverItemName = (item != null) ? item.name : "";
     if(this.currentHoverElement != null)
      this.DoSetHoverState(this.currentHoverElement, oldCurrentHoverElement);
    }
   }
  }
 },
 SetCurrentPressedElement: function(element){
  if(this.currentPressedElement && !_aspxIsValidElement(this.currentPressedElement)){
   this.currentPressedElement = null;
   this.currentPressedItemName = "";
  }
  if(this.currentPressedElement != element){
   if(this.currentPressedElement != null)
    this.DoClearPressedState(this.currentPressedElement);
   var item = (element != null) ? element[__aspxPressedItemKind] : null;
   if(item == null || item.enabled){
    this.currentPressedElement = element;
    this.currentPressedItemName = (item != null) ? item.name : "";
    if(this.currentPressedElement != null)
     this.DoSetPressedState(this.currentPressedElement);
   }
  }
 },
 SetCurrentFocusedElementBySrcElement: function(srcElement){
  var element = this.GetFocusedElement(srcElement);
  this.SetCurrentFocusedElement(element);
 },
 SetCurrentHoverElementBySrcElement: function(srcElement){
  var element = this.GetHoverElement(srcElement);
  this.SetCurrentHoverElement(element);
 },
 SetCurrentPressedElementBySrcElement: function(srcElement){
  var element = this.GetPressedElement(srcElement);
  this.SetCurrentPressedElement(element);
 },
 SelectElement: function(element){
  var item = element[__aspxSelectedItemKind];
  if(item)
   item.Apply(element);
 }, 
 SelectElementBySrcElement: function(srcElement){
  var element = this.GetSelectedElement(srcElement);
  if(element != null) this.SelectElement(element);
 }, 
 DeselectElement: function(element){
  var item = element[__aspxSelectedItemKind];
  if(item)
   item.Cancel(element);
 }, 
 DeselectElementBySrcElement: function(srcElement){
  var element = this.GetSelectedElement(srcElement);
  if(element != null) this.DeselectElement(element);
 },
 SetElementEnabled: function(element, enable){
  if(enable)
   this.EnableElement(element);
  else
   this.DisableElement(element);
 },
 DisableElement: function(element){
  var element = this.GetDisabledElement(element);
  if(element != null) {
   var item = element[__aspxDisabledItemKind];
   if(item){
    var args = new ASPxClientStateEventArgs(item, element);
    this.BeforeDisabled.FireEvent(this, args);
    if(item.name == this.currentPressedItemName)
     this.SetCurrentPressedElement(null);
    if(item.name == this.currentHoverItemName)
     this.SetCurrentHoverElement(null);
    item.Apply(element);
    this.SetMouseStateItemsEnabled(item.name, item.postfixes, false);
    this.AfterDisabled.FireEvent(this, args);
   }
  }
 }, 
 EnableElement: function(element){
  var element = this.GetDisabledElement(element);
  if(element != null) {
   var item = element[__aspxDisabledItemKind];
   if(item){
    var args = new ASPxClientStateEventArgs(item, element);
    this.BeforeEnabled.FireEvent(this, args);
    item.Cancel(element);
    this.SetMouseStateItemsEnabled(item.name, item.postfixes, true);
    this.AfterEnabled.FireEvent(this, args);
   }
  }
 }, 
 SetMouseStateItemsEnabled: function(name, postfixes, enabled){   
  if(postfixes && postfixes.length > 0){
   for(var i = 0; i < postfixes.length; i ++){
    this.SetItemsEnabled(this.hoverItems, name + postfixes[i], enabled);
    this.SetItemsEnabled(this.pressedItems, name + postfixes[i], enabled);
   }
  }
  else{
   this.SetItemsEnabled(this.hoverItems, name, enabled);
   this.SetItemsEnabled(this.pressedItems, name, enabled);
  }  
 },
 SetItemsEnabled: function(items, name, enabled){   
  if(items[name])
   items[name].enabled = enabled;
 },
 OnFocusMove: function(evt){
  var element = _aspxGetEventSource(evt);
  aspxGetStateController().SetCurrentFocusedElementBySrcElement(element);
 },
 OnMouseMove: function(evt, checkElementChanged){
  var srcElement = _aspxGetEventSource(evt);
  if(checkElementChanged && srcElement == this.savedCurrentMouseMoveSrcElement) return;
  this.savedCurrentMouseMoveSrcElement = srcElement;
  if(__aspxIE && !_aspxGetIsLeftButtonPressed(evt) && this.savedCurrentPressedElement != null)
   this.ClearSavedCurrentPressedElement();
  if(this.savedCurrentPressedElement == null)
   this.SetCurrentHoverElementBySrcElement(srcElement);
  else{
   var element = this.GetPressedElement(srcElement);
   if(element != this.currentPressedElement){
    if(element == this.savedCurrentPressedElement)
     this.SetCurrentPressedElement(this.savedCurrentPressedElement);
    else
     this.SetCurrentPressedElement(null);
   }
  }
 },
 OnMouseDown: function(evt){
  if(!_aspxGetIsLeftButtonPressed(evt)) return;
  var srcElement = _aspxGetEventSource(evt);
  this.OnMouseDownOnElement(srcElement);
 },
 OnMouseDownOnElement: function(element){
  if(this.GetPressedElement(element) == null) return;
  this.SetCurrentHoverElement(null);
  this.SetCurrentPressedElementBySrcElement(element);
  this.savedCurrentPressedElement = this.currentPressedElement;
 },
 OnMouseUp: function(evt){
  var srcElement = _aspxGetEventSource(evt);
  this.OnMouseUpOnElement(srcElement);
 },
 OnMouseUpOnElement: function(element){
  if(this.savedCurrentPressedElement == null) return;
  this.ClearSavedCurrentPressedElement();
  this.SetCurrentHoverElementBySrcElement(element);
 },
 OnMouseOver: function(evt){
  var element = _aspxGetEventSource(evt);
  if (element && element.tagName == "IFRAME")
   this.OnMouseMove(evt, true);
 },
 OnKeyDown: function(evt){
  var element = this.GetFocusedElement(_aspxGetEventSource(evt));
  if(element != null && element == this.currentFocusedElement) {
   var item = element[__aspxFocusedItemKind];
   if(item){
    var args = new ASPxClientStateEventArgs(item, element);
    args.htmlEvent = evt;
    this.FocusedItemKeyDown.FireEvent(this, args);
   }
  }
 },
 OnSelectStart: function(evt){
  if(this.savedCurrentPressedElement) {
   _aspxClearSelection();
   return false;
  }
 },
 ClearSavedCurrentPressedElement: function() {
  this.savedCurrentPressedElement = null;
  this.SetCurrentPressedElement(null);
 },
 ClearCache: function(srcElement, kind) {
  if(srcElement[__aspxCachedStatePrefix + kind])
   srcElement[__aspxCachedStatePrefix + kind] = null;
 },
 ClearElementCache: function(srcElement) {
  this.ClearCache(srcElement, __aspxFocusedItemKind);
  this.ClearCache(srcElement, __aspxHoverItemKind);
  this.ClearCache(srcElement, __aspxPressedItemKind);
  this.ClearCache(srcElement, __aspxSelectedItemKind);
  this.ClearCache(srcElement, __aspxDisabledItemKind);
 }
});
var __aspxStateController = null;
function aspxGetStateController(){
 if(__aspxStateController == null)
  __aspxStateController = new ASPxStateController();
 return __aspxStateController;
}
function aspxAddStateItems(method, namePrefix, classes){
 for(var i = 0; i < classes.length; i ++){
  for(var j = 0; j < classes[i][2].length; j ++) {
   var name = namePrefix;
   if(classes[i][2][j])
    name += "_" + classes[i][2][j];
   var postfixes = classes[i][3] || null;
   var imageObjs = (classes[i][4] && classes[i][4][j]) || null;
   var imagePostfixes = classes[i][5] || null;
   method.call(aspxGetStateController(), name, classes[i][0], classes[i][1], postfixes, imageObjs, imagePostfixes);
  }
 }
}
function aspxAddHoverItems(namePrefix, classes){
 aspxAddStateItems(aspxGetStateController().AddHoverItem, namePrefix, classes);
}
function aspxAddPressedItems(namePrefix, classes){
 aspxAddStateItems(aspxGetStateController().AddPressedItem, namePrefix, classes);
}
function aspxAddSelectedItems(namePrefix, classes){
 aspxAddStateItems(aspxGetStateController().AddSelectedItem, namePrefix, classes);
}
function aspxAddDisabledItems(namePrefix, classes){
 aspxAddStateItems(aspxGetStateController().AddDisabledItem, namePrefix, classes);
}
function aspxRemoveStateItems(method, namePrefix, classes){
 for(var i = 0; i < classes.length; i ++){
  for(var j = 0; j < classes[i][0].length; j ++) {
   var name = namePrefix;
   if(classes[i][0][j])
    name += "_" + classes[i][0][j];
   method.call(aspxGetStateController(), name);
  }
 }
}
function aspxRemoveHoverItems(namePrefix, classes){
 aspxRemoveStateItems(aspxGetStateController().RemoveHoverItem, namePrefix, classes);
}
function aspxRemovePressedItems(namePrefix, classes){
 aspxRemoveStateItems(aspxGetStateController().RemovePressedItem, namePrefix, classes);
}
function aspxRemoveSelectedItems(namePrefix, classes){
 aspxRemoveStateItems(aspxGetStateController().RemoveSelectedItem, namePrefix, classes);
}
function aspxRemoveDisabledItems(namePrefix, classes){
 aspxRemoveStateItems(aspxGetStateController().RemoveDisabledItem, namePrefix, classes);
}
function aspxAddAfterClearFocusedState(handler){
 aspxGetStateController().AfterClearFocusedState.AddHandler(handler);
}
function aspxAddAfterSetFocusedState(handler){
 aspxGetStateController().AfterSetFocusedState.AddHandler(handler);
}
function aspxAddAfterClearHoverState(handler){
 aspxGetStateController().AfterClearHoverState.AddHandler(handler);
}
function aspxAddAfterSetHoverState(handler){
 aspxGetStateController().AfterSetHoverState.AddHandler(handler);
}
function aspxAddAfterClearPressedState(handler){
 aspxGetStateController().AfterClearPressedState.AddHandler(handler);
}
function aspxAddAfterSetPressedState(handler){
 aspxGetStateController().AfterSetPressedState.AddHandler(handler);
}
function aspxAddAfterDisabled(handler){
 aspxGetStateController().AfterDisabled.AddHandler(handler);
}
function aspxAddAfterEnabled(handler){
 aspxGetStateController().AfterEnabled.AddHandler(handler);
}
function aspxAddBeforeClearFocusedState(handler){
 aspxGetStateController().BeforeClearFocusedState.AddHandler(handler);
}
function aspxAddBeforeSetFocusedState(handler){
 aspxGetStateController().BeforeSetFocusedState.AddHandler(handler);
}
function aspxAddBeforeClearHoverState(handler){
 aspxGetStateController().BeforeClearHoverState.AddHandler(handler);
}
function aspxAddBeforeSetHoverState(handler){
 aspxGetStateController().BeforeSetHoverState.AddHandler(handler);
}
function aspxAddBeforeClearPressedState(handler){
 aspxGetStateController().BeforeClearPressedState.AddHandler(handler);
}
function aspxAddBeforeSetPressedState(handler){
 aspxGetStateController().BeforeSetPressedState.AddHandler(handler);
}
function aspxAddBeforeDisabled(handler){
 aspxGetStateController().BeforeDisabled.AddHandler(handler);
}
function aspxAddBeforeEnabled(handler){
 aspxGetStateController().BeforeEnabled.AddHandler(handler);
}
function aspxAddFocusedItemKeyDown(handler){
 aspxGetStateController().FocusedItemKeyDown.AddHandler(handler);
}
function aspxSetHoverState(element){
 aspxGetStateController().SetCurrentHoverElementBySrcElement(element);
}
function aspxClearHoverState(evt){
 aspxGetStateController().SetCurrentHoverElementBySrcElement(null);
}
function aspxUpdateHoverState(evt){
 aspxGetStateController().OnMouseMove(evt, false);
}
function aspxSetFocusedState(element){
 aspxGetStateController().SetCurrentFocusedElementBySrcElement(element);
}
function aspxClearFocusedState(evt){
 aspxGetStateController().SetCurrentFocusedElementBySrcElement(null);
}
function aspxUpdateFocusedState(evt){
 aspxGetStateController().OnFocusMove(evt);
}
_aspxAttachEventToDocument("mousemove", aspxClassesDocumentMouseMove);
function aspxClassesDocumentMouseMove(evt){
 if(__aspxClassesScriptParsed && __aspxStateItemsExist)
  aspxGetStateController().OnMouseMove(evt, true);
}
_aspxAttachEventToDocument("mousedown", aspxClassesDocumentMouseDown);
function aspxClassesDocumentMouseDown(evt){
 if(__aspxClassesScriptParsed && __aspxStateItemsExist)
  aspxGetStateController().OnMouseDown(evt);
}
_aspxAttachEventToDocument("mouseup", aspxClassesDocumentMouseUp);
function aspxClassesDocumentMouseUp(evt){
 if(__aspxClassesScriptParsed && __aspxStateItemsExist)
  aspxGetStateController().OnMouseUp(evt);
}
_aspxAttachEventToDocument("mouseover", aspxClassesDocumentMouseOver);
function aspxClassesDocumentMouseOver(evt){
 if(__aspxClassesScriptParsed && __aspxStateItemsExist)
  aspxGetStateController().OnMouseOver(evt);
}
_aspxAttachEventToDocument("keydown", aspxClassesDocumentKeyDown);
function aspxClassesDocumentKeyDown(evt){
 if(__aspxClassesScriptParsed && __aspxStateItemsExist)
  aspxGetStateController().OnKeyDown(evt);
}
_aspxAttachEventToDocument("selectstart", aspxClassesDocumentSelectStart);
function aspxClassesDocumentSelectStart(evt){
 if(__aspxClassesScriptParsed && __aspxStateItemsExist)
  return aspxGetStateController().OnSelectStart(evt); 
}

var __aspxMenuAnimationAccelerator = 1/10;
var __aspxPCAnimationAccelerator = 1/3;
var __aspxAnimationDiscardPixels = 3;
var __aspxNotSetAlignIndicator = "NotSet";
var __aspxInnerAlignIndicator = "Sides";
function _aspxIsAlignNotSet(align){
 return align == __aspxNotSetAlignIndicator;
}
function _aspxIsInnerAlign(align){
 return align.indexOf(__aspxInnerAlignIndicator) != -1;
}
function _aspxIsOuterAlign(align){
 return (!this.IsInnerAlign(align)) && (!_aspxIsAlignNotSet(align));
}
function _aspxPopupPosition(position, isInverted){
 this.position = position;
 this.isInverted = isInverted;
}
function _aspxSegment(pos, len){
 this.pos = pos;
 this.len = len;
}
function _aspxRect(left, top, width, height){
 this.left = left;
 this.top = top;
 this.width = width;
 this.height = height;
}
function _aspxSize(width, height){
 this.width = width;
 this.height = height;
}
function _aspxFindPopupElementById(id){
 if(id == "") return null; 
 var popupElement = _aspxGetElementById(id);
 if(!_aspxIsExistsElement(popupElement)){
  var idParts = id.split("_");
  var uniqueId = idParts.join("$");
  popupElement = _aspxGetElementById(uniqueId);
 }
 return popupElement;
}
function _aspxFindEventSourceParentByTestFunc(evt, testFunc){
 return _aspxFindParentByTestFunc(_aspxGetEventSource(evt), testFunc);
}
function _aspxPreventContextMenu(evt){
 if (__aspxWebKitFamily){
  if(evt.stopPropagation)
   evt.stopPropagation();
  evt.returnValue = false;
  if(evt.preventDefault)
   evt.preventDefault();
 } else if (__aspxNetscapeFamily || (__aspxIE && __aspxBrowserVersion > 8))
  evt.preventDefault();
}
function _aspxIsExistsAbsolutePosParent(element){
 return _aspxIsExistsParentWithSpecPosition(element, ["absolute"]);
}
function _aspxIsExistsAbsoluteOrRelativePosParent(element){
 return _aspxIsExistsParentWithSpecPosition(element, ["absolute", "relative"]);
}
function _aspxIsExistsParentWithSpecPosition(element, positions){
 var curEl = element.offsetParent;
 while(curEl != null) {
  for(var i = 0; i < positions.length; i ++){
   if (_aspxGetCurrentStyle(curEl).position == positions[i])
    return true;
  }
  curEl = curEl.offsetParent;
 }
 return false;
}
function _aspxAdjustPositionToClientScreen(element, shadowSize, pos, isX){
 var min = isX ? _aspxGetDocumentScrollLeft() : _aspxGetDocumentScrollTop();
 var max = min + (isX ? _aspxGetDocumentClientWidth() : _aspxGetDocumentClientHeight());
 max -= (isX ? element.offsetWidth + shadowSize : element.offsetHeight + shadowSize);
 if (pos > max) pos = max;
 if (pos < min) pos = min;
 return pos;
}
function _aspxGetPopupAbsoluteX(element, shadowWidth, popupElement, hAlign, hOffset, x, left, rtl){
 var width = element.offsetWidth;
 var bodyWidth = _aspxGetDocumentClientWidth();
 var elementX = _aspxGetAbsoluteX(popupElement);
 var scrollX = _aspxGetDocumentScrollLeft();
 if (hAlign == "WindowCenter"){
  var showAtPos = x != __aspxInvalidPosition && !popupElement;
  if(showAtPos)
   hAlign = "";
  else
   return new _aspxPopupPosition(Math.ceil(bodyWidth / 2 - width / 2) + scrollX + hOffset, false);
 }
 if (popupElement) {
  var leftX = elementX - width;
  var rightX = elementX + popupElement.offsetWidth;
  var innerLeftX = elementX;
  var innerRightX = elementX + popupElement.offsetWidth - width;
  var isMoreFreeSpaceLeft = bodyWidth - (rightX + width) < leftX - 2 * scrollX;
 }
 else
  hAlign = "";
 var isInverted = false; 
 if (hAlign == "OutsideLeft"){
  isInverted = !(leftX - scrollX > 0 || isMoreFreeSpaceLeft);
  if(isInverted)
   x = rightX - hOffset;
  else
   x = leftX + hOffset;
 }
 else if (hAlign == "LeftSides"){
  x =  innerLeftX + hOffset;
  x = _aspxAdjustPositionToClientScreen(element, shadowWidth, x, true);
 }
 else if (hAlign == "Center"){
  x =  elementX + Math.round((popupElement.offsetWidth  - width) / 2) + hOffset;
 }
 else if (hAlign == "RightSides"){
  x = innerRightX + hOffset;
  x = _aspxAdjustPositionToClientScreen(element, shadowWidth, x, true);
 }
 else if (hAlign == "OutsideRight"){
  isInverted = !(rightX + width < bodyWidth + scrollX || !isMoreFreeSpaceLeft);
  if(isInverted)
   x = leftX - hOffset;
  else
   x = rightX + hOffset;
 }
 else{
  if(rtl){
   if(!_aspxGetIsValidPosition(x))
    x = popupElement ? innerRightX : left;
   else
    x -= width;
   isInverted = x < scrollX && x - scrollX < bodyWidth / 2;
   if(isInverted)
    x = x + width + hOffset;
   else
    x = x - hOffset;
  } else {
   if (!_aspxGetIsValidPosition(x))
    x = popupElement ? elementX : left;
   isInverted = x - scrollX + width > bodyWidth && x - scrollX > bodyWidth / 2;
   if(isInverted)
    x = x - width - hOffset;
   else
    x = x + hOffset;
  }
 }
 return new _aspxPopupPosition(x, isInverted);
}
function _aspxGetPopupAbsoluteY(element, shadowHeight, popupElement, vAlign, vOffset, y, top){
 var height = element.offsetHeight;
 var bodyHeight = _aspxGetDocumentClientHeight(); 
 var elementY = _aspxGetAbsoluteY(popupElement);
 var scrollY = _aspxGetDocumentScrollTop();
 if (vAlign == "WindowCenter"){
  var showAtPos = y != __aspxInvalidPosition && !popupElement;
  if(showAtPos)
   hAlign = "";
  else
   return new _aspxPopupPosition(Math.ceil(bodyHeight / 2 - height / 2) + scrollY + vOffset, false);
 }
 if (popupElement) {
  var bottomY = elementY + popupElement.offsetHeight;
  var topY = elementY - height;
  var innerBottomY = elementY + popupElement.offsetHeight - height;
  var innerTopY = elementY;
  var isMoreFreeSpaceAbove = bodyHeight - (bottomY + height) < topY - 2 * scrollY;
 }
 else
  vAlign = "";
 var isInverted = false;
 if (vAlign == "Above"){
  isInverted = !(topY - scrollY > 0 || isMoreFreeSpaceAbove);
  if(isInverted)
   y = bottomY - vOffset;
  else
   y = topY + vOffset;
 }
 else if (vAlign == "TopSides"){
  y = innerTopY + vOffset;
  y = _aspxAdjustPositionToClientScreen(element, shadowHeight, y, false);
 }
 else if (vAlign == "Middle"){
  y =  elementY + Math.round((popupElement.offsetHeight  - height) / 2) + vOffset;
 }
 else if (vAlign == "BottomSides"){
  y = innerBottomY + vOffset;
  y = _aspxAdjustPositionToClientScreen(element, shadowHeight, y, false);
 }
 else if (vAlign == "Below"){
  isInverted = !(bottomY + height < bodyHeight + scrollY || !isMoreFreeSpaceAbove);
  if(isInverted)
   y = topY - vOffset;
  else
   y = bottomY + vOffset;
 }
 else{
  if (!_aspxGetIsValidPosition(y))
   y = popupElement ? _aspxGetAbsoluteY(popupElement) : top;
  isInverted = y - _aspxGetDocumentScrollTop() + height > bodyHeight && y - _aspxGetDocumentScrollTop() > bodyHeight / 2;
  if(isInverted)
   y = y - height - vOffset;
  else
   y = y + vOffset;
 }
 return new _aspxPopupPosition(y, isInverted);
}
function _aspxGetIntersectionRect(left1, top1, left2, top2, width, height){
 var segment1 = _aspxGetIntersectionSegment(left1, left2, width);
 var segment2 = _aspxGetIntersectionSegment(top1, top2, height);
 if (segment1 != null && segment2 != null){
  var left = segment1.pos;
  var top = segment2.pos;
  var width = segment1.len;
  var height = segment2.len;
  return new _aspxRect(left, top, width, height);
 }
 return null;
}
function _aspxGetIntersectionSegment(pos1, pos2, len){
 var posDifferense = Math.abs(pos1 - pos2);
 if (posDifferense <= len){
  var pos = pos1 > pos2 ? pos1 : pos2;
  var len = len - posDifferense;
  return new _aspxSegment(pos, len);
 }
 return null;
}
function _aspxRemoveFocus(parent){
 var input = document.createElement('div');
 _aspxConcealInputElement(input);
 parent.appendChild(input);
 input.focus();
 _aspxRemoveElement(input);
} 
function _aspxConcealInputElement(input){
 input.style.position = "absolute";
 input.style.left = 0;
 input.style.top = 0;
 if(__aspxWebKitFamily) {
    input.style.opacity = 0;
    input.style.width = 1;
    input.style.height = 1;
 } else {
  input.style.border = 0;
  input.style.width = 0;
  input.style.height = 0;
   }
}
function _aspxInitAnimationDiv(element, x, y, onTimerString, onAnimStopCallString){
 element.animationStart = new Date();
 element.absoluteLeft = x;
 element.absoluteTop = y;
 element.popuping = true;
 element.onTimerString = onTimerString;
 element.onAnimStopCallString = onAnimStopCallString;
 element.style.overflow = "hidden";
 element.style.position = "absolute";  
 _aspxSetStyleSize(element, element.offsetWidth, element.offsetHeight);
 _aspxSetStylePosition(element, x, y);
}
function _aspxOnAnimationTimer(animationDivElement, element, mainCell, iframeElement, animationDelay, animationMaxDelay, animationAccelerator){
 animationDivElement.timerID = _aspxClearTimer(element.timerID);
 var timeExpired = new Date() - animationDivElement.animationStart > animationMaxDelay;
 var left = !timeExpired ? _aspxGetNextAnimationPosInternal(element.offsetLeft, animationAccelerator) : 0;
 var top = !timeExpired ? _aspxGetNextAnimationPosInternal(element.offsetTop, animationAccelerator) : 0;
 element.style.top = top + "px";
 element.style.left = left + "px";
 var rect = _aspxGetIntersectionRect(animationDivElement.offsetLeft, animationDivElement.offsetTop, 
  element.offsetLeft + animationDivElement.offsetLeft, element.offsetTop + animationDivElement.offsetTop,
  mainCell.offsetWidth, mainCell.offsetHeight);
 if (rect && iframeElement){
  _aspxSetStylePosition(iframeElement, rect.left, rect.top);
  _aspxSetStyleSize(iframeElement, rect.width, rect.height);
 }
 if(timeExpired || (left == 0 && top == 0))
  _aspxAnimationFinished(animationDivElement);
 else 
  animationDivElement.timerID = window.setTimeout(animationDivElement.onTimerString, animationDelay);
}
function _aspxGetNextAnimationPosInternal(pos, animationAccelerator){
 pos = Math.round(pos * animationAccelerator);
 if (Math.abs(pos) < __aspxAnimationDiscardPixels)
  pos = 0;
 return pos;
}
function _aspxAnimationFinished(element){
 if(_aspxStopAnimation(element) && _aspxIsExists(element.onAnimStopCallString) && 
  element.onAnimStopCallString !== ""){
  window.setTimeout(element.onAnimStopCallString, 0);
 }
}
function _aspxStopAnimation(element){
 if(element.popuping){
  element.popuping = false;
  element.onTimerString = "";
  element.style.overflow = "visible";
  return true;
 }
 return false;
}
function _aspxGetAnimationHorizontalDirection(popupPosition, horizontalAlign, verticalAlign, rtl){
 if (_aspxIsInnerAlign(horizontalAlign) 
  && !_aspxIsInnerAlign(verticalAlign) 
  && !_aspxIsAlignNotSet(verticalAlign))
  return 0;
 var toTheLeft = (horizontalAlign == "OutsideLeft" || horizontalAlign == "RightSides" || (horizontalAlign == "NotSet" && rtl)) ^ popupPosition.isInverted;
 return toTheLeft ? 1 : -1;
}
function _aspxGetAnimationVerticalDirection(popupPosition, horizontalAlign, verticalAlign){
 if (_aspxIsInnerAlign(verticalAlign) 
  && !_aspxIsInnerAlign(horizontalAlign) 
  && !_aspxIsAlignNotSet(horizontalAlign))
  return 0;
 var toTheTop = (verticalAlign == "Above" || verticalAlign == "BottomSides") ^ popupPosition.isInverted;
 return toTheTop ? 1 : -1;
}
var __aspxHideBodyScrollCount = 0;
function _aspxHideBodyScroll(){
 __aspxHideBodyScrollCount++;
 if(__aspxHideBodyScrollCount > 1) 
  return;
 if(__aspxIE){
  _aspxChangeAttribute(document.body, "scroll", "no");
  _aspxChangeStyleAttribute(document.documentElement, "overflow", "hidden");
 } else if(__aspxFirefox && __aspxBrowserVersion < 3) { 
  var scrollTop = document.documentElement.scrollTop;
  _aspxChangeStyleAttribute(document.body, "overflow", "hidden");
  document.documentElement.scrollTop = scrollTop;
 } else
  _aspxChangeStyleAttribute(document.body, "overflow", "hidden");
 _aspxChangeStyleAttribute(document.body, "marginRight", "16px");
 if(__aspxIE && __aspxBrowserVersion == 7)
  _aspxWindowResizedByBodyScrollToggle();
}
function _aspxRestoreBodyScroll(){
 __aspxHideBodyScrollCount--;
 if(__aspxHideBodyScrollCount > 0) 
  return;
 if(__aspxIE){
  _aspxRestoreAttribute(document.body, "scroll");
  _aspxRestoreStyleAttribute(document.documentElement, "overflow");
 }
 else
  _aspxRestoreStyleAttribute(document.body, "overflow");
 _aspxRestoreStyleAttribute(document.body, "marginRight");
 if(__aspxWebKitFamily){ 
  var scrollTop = document.body.scrollTop;
  var scrollLeft = document.body.scrollLeft;
  document.body.scrollTop ++;
  document.body.scrollTop --;
  document.body.scrollLeft ++;
  document.body.scrollLeft --;
  document.body.scrollLeft = scrollLeft;
  document.body.scrollTop = scrollTop;
 }
 if(__aspxIE && __aspxBrowserVersion == 7)
  _aspxWindowResizedByBodyScrollToggle();
}
function _aspxWindowResizedByBodyScrollToggle() { 
 if(aspxGetPopupControlCollection)
  aspxGetPopupControlCollection().LockWindowResizeByBodyScrollVisibilityChanging();
 var docWidth = document.documentElement.clientWidth; 
 if(aspxGetPopupControlCollection)
  aspxGetPopupControlCollection().UnlockWindowResizeByBodyScrollVisibilityChanging();
}
function _aspxCoordinatesInDocumentRect(x, y){
 var docScrollLeft = _aspxGetDocumentScrollLeft();
 var docScrollTop = _aspxGetDocumentScrollTop();
 return (x > docScrollLeft && y > docScrollTop && 
  x < _aspxGetDocumentClientWidth() + docScrollLeft && 
  y < _aspxGetDocumentClientHeight() + docScrollTop);
}
function _aspxGetElementZIndexArray(element){  
 var currentElement = element;
 var zIndexesArray = [0];
 while(currentElement && currentElement.tagName != "BODY") {
  if(currentElement.style) {
   if(typeof(currentElement.style.zIndex) != "undefined" && currentElement.style.zIndex != "")
    zIndexesArray.unshift(currentElement.style.zIndex);
  }
  currentElement = currentElement.parentNode;
 }
 return zIndexesArray;   
}
function _aspxIsHigher(higherZIndexArrat, zIndexArray){
 if (zIndexArray == null) return true;
 var count = (higherZIndexArrat.length >= zIndexArray.length) ? higherZIndexArrat.length : zIndexArray.length;
 for (var i = 0; i < count; i++) 
    if(typeof(higherZIndexArrat[i]) != "undefined" && typeof(zIndexArray[i]) != "undefined"){
    if (higherZIndexArrat[i] != zIndexArray[i]) return higherZIndexArrat[i] > zIndexArray[i];   
    } else return typeof(zIndexArray[i]) == "undefined";  
 return true;   
}
function _aspxTestIsPopupElement(element) {
 return !!element.DXPopupElementControl;
}
var _aspxClientOverControlUtils = {
 GetPopupElementByEvt: function(evt) {
  return _aspxFindEventSourceParentByTestFunc(evt, _aspxTestIsPopupElement);
 },
 OnMouseEvent: function (evt, mouseOver) {
  var popupElement = _aspxClientOverControlUtils.GetPopupElementByEvt(evt);
  if (mouseOver) 
   popupElement.DXPopupElementControl.OnPopupElementMouseOver(evt, popupElement);
  else 
   popupElement.DXPopupElementControl.OnPopupElementMouseOut(evt, popupElement);
 },
 OnMouseOut: function(evt) {
  _aspxClientOverControlUtils.OnMouseEvent(evt, false);
 },
 OnMouseOver: function(evt) {
  _aspxClientOverControlUtils.OnMouseEvent(evt, true);
 }
}
ASPxScrollingManager = _aspxCreateClass(null, {
 constructor: function(owner, scrollableArea, orientation, onBeforeScrolling, onAfterScrolling) {
  this.owner = owner;
  this.scrollableArea = scrollableArea;
  this.orientation = orientation;
  this.animationDelay = 1;
  this.animationStep = 2;
  this.animationOffset = 5;
  this.animationAcceleration = 0;
  this.scrollSessionInterval = 10;
  this.stopScrolling = true;
  this.busy = false;
  this.currentAcceleration = 0;
  this.startPos;
  this.onBeforeScrolling = onBeforeScrolling;
  this.onAfterScrolling = onAfterScrolling;
 },
 GetScrolledAreaPosition: function() {
  return _aspxPxToInt(this.scrollableArea.style.left) * this.orientation[0]
   + _aspxPxToInt(this.scrollableArea.style.top) * this.orientation[1];
 },
 SetScrolledAreaPosition: function(pos) {
  this.scrollableArea.style.left = pos * this.orientation[0] + "px";
  this.scrollableArea.style.top = pos * this.orientation[1] + "px";  
 },
 PrepareForScrollAnimation: function() {
  if(!this.scrollableArea)
   return;  
  this.currentAcceleration = 0;
  this.startPos = this.GetScrolledAreaPosition();
  this.busy = false;
 },
 GetAnimationStep: function(dir) {
  var step = dir * (this.animationStep + this.currentAcceleration);
  var newPos = this.GetScrolledAreaPosition() + step;
  var requiredPos = this.startPos + dir * this.animationOffset;
  if((dir == 1 && newPos >= requiredPos) || (dir == -1 && newPos <= requiredPos)) {
   step = requiredPos - this.GetScrolledAreaPosition();
  } 
  return step;
 },
 DoScrollSessionAnimation: function(direction) {
  if(!this.scrollableArea)
   return;
  this.SetScrolledAreaPosition(this.GetScrolledAreaPosition() + this.GetAnimationStep(direction));
  var self = this;
  if(!this.ShouldStopScrollSessionAnimation()) {
   this.busy = true;
   this.currentAcceleration += this.animationAcceleration;
   _aspxSetTimeout(function() { self.DoScrollSessionAnimation(direction); }, this.animationDelay);
  } else {
   if(this.onAfterScrolling)
    this.onAfterScrolling(this, -direction);   
   this.busy = false;
   this.currentAcceleration = 0;
   _aspxSetTimeout(function() { self.DoScroll(direction); }, this.scrollSessionInterval);
  }    
 },
 ShouldStopScrollSessionAnimation: function() {
  return (Math.abs(this.GetScrolledAreaPosition() - this.startPos) >= Math.abs(this.animationOffset));
 },
 DoScroll: function(direction) {
  if(!this.scrollableArea)
   return; 
  if(!this.busy && !this.stopScrolling) {
   if(this.onBeforeScrolling)
    this.onBeforeScrolling(this, -direction);
   if(this.stopScrolling) return;
   this.PrepareForScrollAnimation();
   this.DoScrollSessionAnimation(direction);
  } 
 },
 StartScrolling: function(direction, delay, step) {
  this.stopScrolling = false;
  this.animationDelay = delay;
  this.animationStep = step;
  this.DoScroll(-direction);
 },
 StopScrolling: function() {
  this.stopScrolling = true;
 },
 IsStopped: function() {
  return this.stopScrolling;
 }
});

var __aspxMIIdSuffix = "_DXI";
var __aspxMMIdSuffix = "_DXM";
var __aspxSBIdSuffix = "_DXSB";
var __aspxSBUIdEnd = "_U";
var __aspxSBDIdEnd = "_D";
ASPxClientMenuItemInfo = _aspxCreateClass(null, {
 constructor: function(menu, indexPath){
  if(menu.liteRender) {
   var itemElement = menu.GetItemElement(indexPath);
   this.clientHeight = itemElement.clientHeight;
   this.clientWidth = itemElement.clientWidth;
   this.clientTop = _aspxGetClientTop(itemElement);
   this.clientLeft = _aspxGetClientLeft(itemElement);
   this.offsetHeight = itemElement.offsetHeight;
   this.offsetWidth = itemElement.offsetWidth;
   this.offsetTop = 0;
   this.offsetLeft = 0;
  }
  else {
   this.clientHeight = 0;
   this.clientWidth = 0;
   this.clientTop = 0;
   this.clientLeft = 0;
   this.offsetHeight = 0;
   this.offsetWidth = 0;
   this.offsetTop = 0;
   this.offsetLeft = __aspxAbsoluteRightPosition;
   var imageElement = (indexPath != "") ? menu.GetItemImageCell(indexPath) : null;
   if(imageElement != null){
    this.clientWidth += imageElement.clientWidth;
    this.offsetWidth += imageElement.offsetWidth;
    if(this.clientLeft == 0) 
     this.clientLeft = _aspxGetClientLeft(imageElement);
    if(this.offsetLeft > imageElement.offsetLeft)
     this.offsetLeft = imageElement.offsetLeft;
   }
   var indentElement = (indexPath != "") ? menu.GetItemIndentCell(indexPath) : null;
   if(indentElement != null){
    this.clientWidth += indentElement.clientWidth;
    this.offsetWidth += indentElement.offsetWidth;
   }
   var textElement = (indexPath != "") ? menu.GetItemTextCell(indexPath) : null;
   if(textElement != null){ 
    this.clientWidth += textElement.clientWidth;
    this.offsetWidth += textElement.offsetWidth;
    if(this.clientLeft == 0) 
     this.clientLeft = _aspxGetClientLeft(textElement);
    if(this.offsetLeft > textElement.offsetLeft)
     this.offsetLeft = textElement.offsetLeft;
    this.clientTop = _aspxGetClientTop(textElement);
    this.offsetHeight += textElement.offsetHeight;
    this.offsetTop = textElement.offsetTop;
    this.clientHeight = textElement.clientHeight;
    if(__aspxSafari && __aspxBrowserVersion >= 3 || __aspxChrome){ 
     if(!menu.IsVertical(indexPath))
      this.clientHeight = _aspxWebKit3TDRealInfo.GetClientHeight(textElement);
     if(imageElement != null && this.clientHeight < imageElement.clientHeight) 
      this.clientHeight = imageElement.clientHeight;
    }
   }
   var popOutImageElement = (indexPath != "") ? menu.GetItemPopOutImageCell(indexPath) : null;
   if(popOutImageElement != null){
    this.clientWidth += popOutImageElement.clientWidth;
    this.offsetWidth += popOutImageElement.offsetWidth;
    if(this.clientLeft == 0) 
     this.clientLeft = _aspxGetClientLeft(popOutImageElement);
    if(this.offsetLeft > popOutImageElement.offsetLeft)
     this.offsetLeft = popOutImageElement.offsetLeft;
   }
  }
 }
});
ASPxClientMenuCssClasses = {};
ASPxClientMenuCssClasses.Prefix = "dxm-";
ASPxClientMenuCssClasses.Menu = "dxmLite";
ASPxClientMenuCssClasses.BorderCorrector = "dxmBC";
ASPxClientMenuCssClasses.Disabled = ASPxClientMenuCssClasses.Prefix + "disabled";
ASPxClientMenuCssClasses.MainMenu = ASPxClientMenuCssClasses.Prefix + "main";
ASPxClientMenuCssClasses.PopupMenu = ASPxClientMenuCssClasses.Prefix + "popup";
ASPxClientMenuCssClasses.IE7 = ASPxClientMenuCssClasses.Prefix + "ie7";
ASPxClientMenuCssClasses.HorizontalMenu = ASPxClientMenuCssClasses.Prefix + "horizontal";
ASPxClientMenuCssClasses.VerticalMenu = ASPxClientMenuCssClasses.Prefix + "vertical";
ASPxClientMenuCssClasses.DX = "dx";
ASPxClientMenuCssClasses.Separator = ASPxClientMenuCssClasses.Prefix + "separator";
ASPxClientMenuCssClasses.Spacing = ASPxClientMenuCssClasses.Prefix + "spacing";
ASPxClientMenuCssClasses.Gutter = ASPxClientMenuCssClasses.Prefix + "gutter";
ASPxClientMenuCssClasses.WithoutImages = ASPxClientMenuCssClasses.Prefix + "noImages";
ASPxClientMenuCssClasses.Item = ASPxClientMenuCssClasses.Prefix + "item";
ASPxClientMenuCssClasses.ItemHovered = ASPxClientMenuCssClasses.Prefix + "hovered";
ASPxClientMenuCssClasses.ItemSelected = ASPxClientMenuCssClasses.Prefix + "selected";
ASPxClientMenuCssClasses.ItemChecked = ASPxClientMenuCssClasses.Prefix + "checked";
ASPxClientMenuCssClasses.ItemWithoutImage = ASPxClientMenuCssClasses.Prefix + "noImage";
ASPxClientMenuCssClasses.ItemWithSubMenu = ASPxClientMenuCssClasses.Prefix + "subMenu";
ASPxClientMenuCssClasses.ItemDropDownMode = ASPxClientMenuCssClasses.Prefix + "dropDownMode";
ASPxClientMenuCssClasses.ItemWithoutSubMenu = ASPxClientMenuCssClasses.Prefix + "noPopOut";
ASPxClientMenuCssClasses.HorizontalAlignCenter = ASPxClientMenuCssClasses.Prefix + "haCenter";
ASPxClientMenuCssClasses.HorizontalAlignCenterWrapper = ASPxClientMenuCssClasses.Prefix + "haWrapper";
ASPxClientMenuCssClasses.ContentContainer = ASPxClientMenuCssClasses.Prefix + "content";
ASPxClientMenuCssClasses.Image = ASPxClientMenuCssClasses.Prefix + "image";
ASPxClientMenuCssClasses.PopOutContainer = ASPxClientMenuCssClasses.Prefix + "popOut";
ASPxClientMenuCssClasses.PopOutImage = ASPxClientMenuCssClasses.Prefix + "pImage";
ASPxClientMenuCssClasses.ImageLeft = ASPxClientMenuCssClasses.Prefix + "image-l";
ASPxClientMenuCssClasses.ImageRight = ASPxClientMenuCssClasses.Prefix + "image-r";
ASPxClientMenuCssClasses.ImageTop = ASPxClientMenuCssClasses.Prefix + "image-t";
ASPxClientMenuCssClasses.ImageBottom = ASPxClientMenuCssClasses.Prefix + "image-b";
ASPxClientMenuCssClasses.ScrollArea = ASPxClientMenuCssClasses.Prefix + "scrollArea";
ASPxClientMenuCssClasses.ScrollUpButton = ASPxClientMenuCssClasses.Prefix + "scrollUpBtn";
ASPxClientMenuCssClasses.ScrollDownButton = ASPxClientMenuCssClasses.Prefix + "scrollDownBtn";
ASPxClientMenuLiteRenderHelper = {};
ASPxClientMenuLiteRenderHelper.InlineInitializeElements = function(menu) {
 if(!menu.isPopupMenu)
  this.InlineInitializeMainMenuElements(menu, menu.GetMainElement());
 var commonContainer = menu.GetMainElement().parentNode;
 if(!menu.isPopupMenu && __aspxIE && __aspxBrowserMajorVersion == 7)
  commonContainer = commonContainer.parentNode;
 var subMenuElements = this.GetNodesByTagName(commonContainer, "DIV");
 for(var i = 0; i < subMenuElements.length; i++) {
  if(!menu.isPopupMenu) {
   if(__aspxIE && __aspxBrowserMajorVersion == 7) {
    if(subMenuElements[i] == menu.GetMainElement().parentNode)
     continue;
   }
   else if(subMenuElements[i] == menu.GetMainElement())
    continue;
  }
  this.InlineInitializeSubMenuElements(menu, subMenuElements[i]);
 }
};
ASPxClientMenuLiteRenderHelper.FindNodes = function(node, match) {
 var result = [];
 for(var i = 0; i < node.childNodes.length; i++) {
  var childNode = node.childNodes[i];
  if(!childNode.tagName)
   continue;
  if(match(childNode))
   result.push(childNode);
 }
 return result;
};
ASPxClientMenuLiteRenderHelper.GetNodesByTagName = function(node, tagName) {
 return this.FindNodes(node, function(childNode) {
  return childNode.tagName == tagName;
 });
};
ASPxClientMenuLiteRenderHelper.GetNodesByClassName = function(node, className) {
 return this.FindNodes(node, function(childNode) {
  return _aspxElementCssClassContains(childNode, className);
 });
};
ASPxClientMenuLiteRenderHelper.GetNodeByClassName = function(node, childNodeClassName) {
 var nodes = this.GetNodesByClassName(node, childNodeClassName);
 return nodes.length > 0 ? nodes[0] : null;
};
ASPxClientMenuLiteRenderHelper.InlineInitializeScrollElements = function(menu, indexPath, menuElement) {
 var scrollArea = this.GetNodeByClassName(menuElement, ASPxClientMenuCssClasses.ScrollArea);
 if(scrollArea) scrollArea.id = menu.GetScrollAreaId(indexPath);
 var scrollUpButton = this.GetNodeByClassName(menuElement, ASPxClientMenuCssClasses.ScrollUpButton);
 if(scrollUpButton) scrollUpButton.id = menu.GetScrollUpButtonId(indexPath);
 var scrollDownButton = this.GetNodeByClassName(menuElement, ASPxClientMenuCssClasses.ScrollDownButton);
 if(scrollDownButton) scrollDownButton.id = menu.GetScrollDownButtonId(indexPath);
};
ASPxClientMenuLiteRenderHelper.InlineInitializeMainMenuElements = function(menu, menuElement) {
 var contentElement = _aspxGetChildByTagName(menuElement, "UL", 0);
 var itemElements = this.GetNodesByClassName(contentElement, ASPxClientMenuCssClasses.Item);
 for(var i = 0; i < itemElements.length; i++)
  this.InlineInitializeItemElement(menu, itemElements[i], "", i);
 this.InlineInitializeScrollElements(menu, "", menuElement);
};
ASPxClientMenuLiteRenderHelper.PrepareSpacingAndSeparators = function(menu, menuElement) {
 if(!menu.IsVisible()) return;
 var indexPath = menu.GetMenuIndexPathById(menuElement.id);
 if(menu.IsVertical(indexPath)) return;
 var contentElement = _aspxGetChildByTagName(menuElement, "UL", 0);
 var itemElements = this.GetNodesByClassName(contentElement, ASPxClientMenuCssClasses.Item);
 if(!itemElements[0]) return;
 var spaceElements = this.GetNodesByClassName(contentElement, ASPxClientMenuCssClasses.Separator);
 spaceElements = spaceElements.concat(
  this.GetNodesByClassName(contentElement, ASPxClientMenuCssClasses.Spacing)
 );
 for(var i = 0; i < spaceElements.length; i++)
  spaceElements[i].style.height = itemElements[0].offsetHeight + "px";
};
ASPxClientMenuLiteRenderHelper.ProsessRightFloatElements = function(contentElement, action) {
 var raw = _aspxGetChildrenByPartialClassName(contentElement, ASPxClientMenuCssClasses.Prefix).concat([ contentElement ]);
 var list = [ ];
 for(var i = 0; i < raw.length; i++) {
  if(raw[i].offsetWidth < 1 || _aspxGetElementFloat(raw[i]) != "right")
   continue;
  list.push(raw[i]);
 }
 var directionChanged;
 if(contentElement.className == ASPxClientMenuCssClasses.DX && 
  contentElement.tagName.toUpperCase() == "DIV" && _aspxGetElementDirection(contentElement) == "rtl") {
  _aspxSetElementDirection(contentElement, "ltr");
  directionChanged = true;
 }
 for(var i = 0; i < list.length; i++)  
  _aspxSetElementFloat(list[i], "left");   
 action(list);
 for(var i = 0; i < list.length; i++)
  _aspxSetElementFloat(list[i], "");
 if(directionChanged)
  _aspxSetElementDirection(contentElement, "rtl");
};
ASPxClientMenuLiteRenderHelper.FreezeElementSizes = function(elements) {
 for(var i = 0; i < elements.length; i++)
  elements[i].style.width = elements[i].offsetWidth - _aspxGetLeftRightBordersAndPaddingsSummaryValue(elements[i]) + "px";
};
ASPxClientMenuLiteRenderHelper.InlineInitializeSubMenuElements = function(menu, parentElement) {
 parentElement.style.position = "absolute";
 var indexPath = menu.GetMenuIndexPathById(parentElement.id);
 var borderCorrectorElement = this.GetNodeByClassName(parentElement, ASPxClientMenuCssClasses.BorderCorrector);
 if(borderCorrectorElement != null) {
  borderCorrectorElement.id = menu.GetMenuBorderCorrectorElementId(indexPath);
  borderCorrectorElement.style.position = "absolute";
  parentElement.removeChild(borderCorrectorElement);
  parentElement.parentNode.appendChild(borderCorrectorElement);
 }
 this.InlineInitializeSubMenuMenuElement(menu, parentElement);
};
ASPxClientMenuLiteRenderHelper.InlineInitializeSubMenuMenuElement = function(menu, parentElement) {
 var menuElement = this.GetNodeByClassName(parentElement, ASPxClientMenuCssClasses.PopupMenu);
 var indexPath = menu.GetMenuIndexPathById(parentElement.id);
 menuElement.id = menu.GetMenuMainElementId(indexPath);
 var contentElement = _aspxGetChildByTagName(menuElement, "UL", 0); 
 if(contentElement != null) {
  var itemElements = this.GetNodesByClassName(contentElement, ASPxClientMenuCssClasses.Item);
  var parentIndexPath = parentElement == menu.GetMainElement() ? "" : indexPath;
  for(var i = 0; i < itemElements.length; i++)
   this.InlineInitializeItemElement(menu, itemElements[i], parentIndexPath, i);
 }
 this.InlineInitializeScrollElements(menu, indexPath, menuElement);
};
ASPxClientMenuLiteRenderHelper.PrepareSubMenuSize = function(menu, parentElement) {
 var widthPrepared = _aspxGetAttribute(parentElement, "widthPrepared") == "true"; 
 var menuElement = menu.GetMenuMainCell(parentElement); 
 var contentElement = this.GetContentElement(menuElement);
 _aspxSetStylePosition(parentElement, __aspxAbsoluteLeftPosition, __aspxInvalidPosition);
 var savedDisplay = parentElement.style.display;
 parentElement.style.display = "";
 parentElement.style.width = "";
 parentElement.style.height = "";
 if(widthPrepared)
  menuElement.style.width = "";
 var itemElements = this.GetNodesByClassName(contentElement, ASPxClientMenuCssClasses.Item);
 var contentWidth;
 if(__aspxIE && __aspxBrowserVersion < 8) {  
  this.ProsessRightFloatElements(contentElement, function(elements) {
   if(menu.rtl)
    ASPxClientMenuLiteRenderHelper.FreezeElementSizes(elements);   
   contentWidth = contentElement.offsetWidth;
  });
  if(contentElement.tagName == "UL") {
   contentElement.style.height = "";
   contentElement.style.height = contentElement.offsetHeight + "px";
  }
 }
 menuElement.style.width = (contentWidth || contentElement.offsetWidth) + "px";
 parentElement.style.display = savedDisplay;
 if(!widthPrepared)
  _aspxSetAttribute(parentElement, "widthPrepared", "true");
};
ASPxClientMenuLiteRenderHelper.GetContentElement = function(menuElement) {
 var contentElement = _aspxGetChildByTagName(menuElement, "DIV", 0); 
 if( contentElement &&
  contentElement.className == ASPxClientMenuCssClasses.DX &&
  contentElement.parentNode == menuElement)
  return contentElement;
 contentElement = _aspxGetChildByTagName(menuElement, "UL", 0);
 if(contentElement)
  return contentElement;
 return _aspxGetChildByTagName(menuElement, "TABLE", 0);
};
ASPxClientMenuLiteRenderHelper.InlineInitializeItemElement = function(menu, itemElement, parentIndexPath, visibleIndex) {
 var parentItemData = menu.liteRenderData[parentIndexPath];
 var itemData = parentItemData[visibleIndex];
 var itemIndex = itemData;
 var prepareItemOnClick = false;
 if(itemData.constructor == Array) {
  itemIndex = itemData[0];
  prepareItemOnClick = true;
 }
 var indexPath = parentIndexPath + (parentIndexPath != "" ? __aspxItemIndexSeparator : "") +  itemIndex;
 itemElement.id = menu.GetItemElementId(indexPath);
 var separatorElement = itemElement.previousSibling;
 if(separatorElement && separatorElement.className) {
  if(_aspxElementCssClassContains(separatorElement, ASPxClientMenuCssClasses.Spacing))
   separatorElement.id = menu.GetItemSeparatorElementId(indexPath);
  else if(_aspxElementCssClassContains(separatorElement, ASPxClientMenuCssClasses.Separator))
   separatorElement.id = menu.GetItemSeparatorElementId(indexPath);
 }
 var contentElementParent = itemElement;
 if(_aspxElementCssClassContains(itemElement, ASPxClientMenuCssClasses.HorizontalAlignCenter))
  contentElementParent = this.GetNodeByClassName(itemElement, ASPxClientMenuCssClasses.HorizontalAlignCenterWrapper);
 var contentElement = this.GetNodeByClassName(contentElementParent, ASPxClientMenuCssClasses.ContentContainer);
 if(contentElement != null) {
  contentElement.id = menu.GetItemTextCellId(indexPath);
  var imageElement = this.GetNodeByClassName(contentElement, ASPxClientMenuCssClasses.Image);
  if(imageElement == null) {
   var hyperLinkElement = this.GetNodeByClassName(contentElement, ASPxClientMenuCssClasses.DX);
   if(hyperLinkElement != null)
    imageElement = this.GetNodeByClassName(hyperLinkElement, ASPxClientMenuCssClasses.Image);
  }
  if(imageElement != null)
   imageElement.id = menu.GetItemImageId(indexPath);
 }
 else
  prepareItemOnClick = false;
 var popOutElement = this.GetNodeByClassName(itemElement, ASPxClientMenuCssClasses.PopOutContainer);
 if(popOutElement != null) {
  popOutElement.id = menu.GetItemPopOutImageCellId(indexPath);
  var popOutImageElement = this.GetNodeByClassName(popOutElement, ASPxClientMenuCssClasses.PopOutImage);
  if(popOutImageElement != null)
   popOutImageElement.id = menu.GetItemPopOutImageId(indexPath);
 }
 if(prepareItemOnClick)
  this.InlineInitializeItemOnClick(menu, itemElement, indexPath);
};
ASPxClientMenuLiteRenderHelper.InlineInitializeItemOnClick = function(menu, itemElement, indexPath) {
 var name = menu.name;
 var onclick = function(e) {
  if(!itemElement.clientDisabled)
   aspxMIClick(e, name, indexPath);
 };
 if(menu.IsDropDownItem(indexPath)) {
  var contentElement = menu.GetItemTextCell(indexPath);
  var dropDownElement = menu.GetItemPopOutImageCell(indexPath);
  var dropDownOnclick = function(e) {
   if(!itemElement.clientDisabled)
    aspxMIDDClick(e, name, indexPath);
  };
  _aspxAttachEventToElement(contentElement, "click", onclick);
  _aspxAttachEventToElement(dropDownElement, "click", dropDownOnclick);
 }
 else
  _aspxAttachEventToElement(itemElement, "click", onclick);
 if(itemElement.style.cursor == "")
  itemElement.style.cursor = "pointer";
};
ASPxClientMenuLiteRenderHelper.ChangeItemEnabledAttributes = function(itemElement, enabled) {
 if(itemElement) {
  itemElement.clientDisabled = !enabled;
  _aspxChangeStyleAttributesMethod(enabled)(itemElement, "cursor");
  var hyperLink = _aspxGetChildByTagName(itemElement, "A", 0);
  if(hyperLink)
   _aspxChangeAttributesMethod(enabled)(hyperLink, "href");
 }
};
ASPxClientMenuScrollHelper = _aspxCreateClass(null, {
 constructor: function(menu, indexPath) {
  this.menu = menu;
  this.indexPath = indexPath;
  this.scrollingAreaElement = null;
  this.manager = null;
  this.initialized = false;
  this.visibleItems = [];
  this.itemsHeight = 0;
  this.scrollHeight = 0;
  this.scrollUpButtonHeight = 0;
  this.scrollDownButtonHeight = 0;
  this.scrollAreaHeight = null;
  this.scrollUpButtonVisible = false;
  this.scrollDownButtonVisible = false;
 },
 Initialize: function(){
  if(this.initialized) return;
  this.scrollingAreaElement = this.menu.GetScrollContentItemsOuterContainer(this.indexPath);
  var vector = [ 0, 1 ];
  this.manager = new ASPxScrollingManager(this, this.scrollingAreaElement, vector, 
   function(manager, direction){
    manager.owner.OnBeforeScrolling(direction);
   }, 
   function(manager, direction){
    manager.owner.OnAfterScrolling(direction);
   }
  );
  this.ShowScrollButtons();
  var scrollUpButton = this.menu.GetScrollUpButtonElement(this.indexPath);
  if(scrollUpButton){
   this.scrollUpButtonHeight = this.GetScrollButtonHeight(scrollUpButton)
   _aspxSetElementSelectionEnabled(scrollUpButton, false);
  }
  var scrollDownButton = this.menu.GetScrollDownButtonElement(this.indexPath);
  if(scrollDownButton){
   this.scrollDownButtonHeight = this.GetScrollButtonHeight(scrollDownButton);
   _aspxSetElementSelectionEnabled(scrollDownButton, false);
  }
  this.HideScrollButtons();
  this.initialized = true;  
 },
 GetScrollButtonHeight: function(button) {
  var style = _aspxGetCurrentStyle(button);
  return button.offsetHeight + _aspxPxToInt(style.marginTop) + _aspxPxToInt(style.marginBottom);
 },
 FillVisibleItemsList: function(){
  var index = 0;
  this.visibleItems = [];
  while(true){
   var childIndexPath = (this.indexPath != "" ? this.indexPath + __aspxItemIndexSeparator : "") + index;
   var itemElement = this.menu.GetItemElement(childIndexPath);
   if(itemElement == null)
    break;
   if(_aspxGetElementDisplay(itemElement))
    this.visibleItems.push(itemElement);
   index++;
  }
 },
 CanCalculate: function(){
  return this.scrollingAreaElement && _aspxElementIsDisplayed(this.scrollingAreaElement);
 },
 Calculate: function(scrollHeight){
  if(!this.CanCalculate()) return;
  this.FillVisibleItemsList();
  this.itemsHeight = 0;
  this.scrollHeight = scrollHeight;
  var itemsContainer = this.menu.GetScrollContentItemsContainer(this.indexPath);
  if(itemsContainer) this.itemsHeight = itemsContainer.offsetHeight;
  this.SetPosition(0);
  this.CalculateScrollingElements(-1);
 },
 GetPosition: function(){
  return -this.manager.GetScrolledAreaPosition();
 },
 SetPosition: function(pos){
  this.manager.SetScrolledAreaPosition(-pos);
 },
 CalculateScrollingElements: function(direction){
  if(this.itemsHeight <= this.scrollHeight){
   this.scrollUpButtonVisible = false;
   this.scrollDownButtonVisible = false;
   this.scrollAreaHeight = null;
   this.SetPosition(0);
  }
  else{
   var scrollTop = this.GetPosition();
   this.scrollAreaHeight = this.scrollHeight;
   if(direction > 0){
    var showScrollUpButton = !this.scrollUpButtonVisible;
    this.scrollUpButtonVisible = true;
    this.scrollAreaHeight -= this.scrollUpButtonHeight;
    this.scrollDownButtonVisible = this.itemsHeight - this.scrollAreaHeight - scrollTop > this.scrollDownButtonHeight;
    if(this.scrollDownButtonVisible) {
     this.scrollAreaHeight -= this.scrollDownButtonHeight;
     if(showScrollUpButton)
      this.SetPosition(this.GetPosition() + this.scrollUpButtonHeight);
    }
    else {
     this.SetPosition(this.itemsHeight - this.scrollAreaHeight);
    }
   }
   else{
    this.scrollDownButtonVisible = true;
    this.scrollAreaHeight -= this.scrollDownButtonHeight;    
    this.scrollUpButtonVisible = scrollTop > this.scrollUpButtonHeight;
    if(this.scrollUpButtonVisible)
     this.scrollAreaHeight -= this.scrollUpButtonHeight;
    else
     this.SetPosition(0);
   }
   if(this.scrollAreaHeight < 1) this.scrollAreaHeight = 1;
  }
  this.UpdateScrollingElements();
 },
 UpdateScrollingElements: function(){
  this.UpdateScrollAreaHeight();
  this.UpdateScrollButtonsVisibility();
 },
 UpdateScrollAreaHeight: function() {
  var scrollAreaElement = this.menu.GetScrollAreaElement(this.indexPath);
  if(scrollAreaElement) 
   scrollAreaElement.style.height = (this.scrollAreaHeight) ? (this.scrollAreaHeight + "px") : "";
 },
 UpdateScrollButtonsVisibility: function() {
  var scrollUpButton = this.menu.GetScrollUpButtonElement(this.indexPath);
  if(scrollUpButton) _aspxSetElementDisplay(scrollUpButton, this.scrollUpButtonVisible);
  var scrollDownButton = this.menu.GetScrollDownButtonElement(this.indexPath);
  if(scrollDownButton) _aspxSetElementDisplay(scrollDownButton, this.scrollDownButtonVisible);
 },
 ChangeScrollButtonsVisibility: function(visible) {
  this.scrollUpButtonVisible = visible;
  this.scrollDownButtonVisible = visible;
  this.UpdateScrollButtonsVisibility();
 },
 ShowScrollButtons: function() {
  this.ChangeScrollButtonsVisibility(true);
 },
 HideScrollButtons: function() {
  this.ChangeScrollButtonsVisibility(false);
 },
 ResetScrolling: function() {
  this.HideScrollButtons();
  this.SetPosition(0);
  this.scrollAreaHeight = null;
  this.UpdateScrollAreaHeight();
 },
 GetScrollAreaHeight: function() {
  var scrollAreaElement = this.menu.GetScrollAreaElement(this.indexPath);
  if(scrollAreaElement)
   return scrollAreaElement.offsetHeight;
  return 0;
 },
 OnAfterScrolling: function(direction){
  this.CalculateScrollingElements(direction);
 },
 OnBeforeScrolling: function(direction){
  var scrollButton = (direction > 0) ? this.menu.GetScrollDownButtonElement(this.indexPath) :
   this.menu.GetScrollUpButtonElement(this.indexPath);
  if(!scrollButton || !_aspxGetElementDisplay(scrollButton))
   this.manager.StopScrolling();
 },
 StartScrolling: function(direction, delay, step) {
  this.manager.StartScrolling(direction, delay, step);
 },
 StopScrolling: function() {
  this.manager.StopScrolling();
 }
});
ASPxClientMenuBase = _aspxCreateClass(ASPxClientControl, {
 constructor: function(name){
  this.constructor.prototype.constructor.call(this, name);
  this.liteRender = false;
  this.createIFrames = false;
  this.liteRenderData = null;
  this.allowSelectItem = false;
  this.allowCheckItems = false;
  this.allowMultipleCallbacks = false;
  this.appearAfter = 300;
  this.animationDelay = 30;
  this.animationMaxDelay = 400;
  this.disappearAfter = 500;
  this.enableAnimation = true;
  this.checkedItems = [ ];
  this.itemCheckedGroups = [ ];
  this.lockHoverEvents = false;
  this.popupToLeft = false;
  this.popupCount = 0;
  this.rootItem = null;
  this.showSubMenus = false;
  this.savedCallbackHoverItem = null;
  this.savedCallbackHoverElement = null;
  this.scrollInfo = [];
  this.scrollHelpers = {};
  this.scrollVertOffset = 1;
  this.rootSubMenuFIXOffset = 0;
  this.rootSubMenuFIYOffset = 0;
  this.rootSubMenuLIXOffset = 0;
  this.rootSubMenuLIYOffset = 0;
  this.rootSubMenuXOffset = 0;
  this.rootSubMenuYOffset = 0;
  this.subMenuFIXOffset = 0;
  this.subMenuFIYOffset = 0;
  this.subMenuLIXOffset = 0;
  this.subMenuLIYOffset = 0;
  this.subMenuXOffset = 0;
  this.subMenuYOffset = 0;
  this.sizingConfig.allowSetHeight = false;
  this.shadowVisible = true;
  this.ItemClick = new ASPxClientEvent();
  this.ItemMouseOver = new ASPxClientEvent();
  this.ItemMouseOut = new ASPxClientEvent();
  this.PopUp = new ASPxClientEvent();
  this.CloseUp = new ASPxClientEvent();
  aspxGetMenuCollection().Add(this);
 }, 
 Initialize: function(){
  this.constructor.prototype.Initialize.call(this);
  if(this.liteRender) {
   var main = this.GetMainElement();
   if(__aspxIE && __aspxBrowserMajorVersion < 8 && this.rtl && _aspxElementCssClassContains(main, ASPxClientMenuCssClasses.HorizontalMenu))
    ASPxClientMenuLiteRenderHelper.ProsessRightFloatElements(main, ASPxClientMenuLiteRenderHelper.FreezeElementSizes);
   ASPxClientMenuLiteRenderHelper.PrepareSpacingAndSeparators(this, main);
  }
 },   
 InlineInitialize: function(){
  if (this.liteRender) { 
   ASPxClientMenuLiteRenderHelper.InlineInitializeElements(this);
   var mainElement = this.GetMainElement();
   var width = _aspxPxToInt(mainElement.style.width);
   if(width > 0) {
    var currentStyle = _aspxGetCurrentStyle(mainElement);
    width -= _aspxPxToInt(currentStyle.paddingLeft) + _aspxPxToInt(currentStyle.paddingRight);
    width -= _aspxPxToInt(currentStyle.borderLeftWidth) + _aspxPxToInt(currentStyle.borderRightWidth);
    if(width > 0)
     mainElement.style.width = width + "px";
   }
  }
  this.InitializeInternal(true);
  if(this.IsCallbacksEnabled()){
   this.showSubMenus = this.GetLoadingPanelElement() != null;
   this.CreateCallback("DXMENUCONTENT");
  }
  else 
   this.showSubMenus = true;
  this.popupToLeft = this.rtl;
 },
 InitializeInternal: function(inline) {
  this.InitializeCheckedItems();
  this.InitializeSelectedItem();
  this.InitializeEnabledAndVisible(!inline || !this.IsCallbacksEnabled());
  if(!this.IsCallbacksEnabled())
   this.InitializeScrollableMenus();
 },
 InitializeEnabledAndVisible: function(recursive){
  if(this.rootItem == null) return;
  for(var i = 0; i < this.rootItem.items.length; i++)
   this.rootItem.items[i].InitializeEnabledAndVisible(recursive);
 },
 InitializeScrollableMenus: function() {
  var info = eval(this.scrollInfo);
  this.scrollHelpers = {};
  for(var i = 0; i < info.length; i++)
   this.scrollHelpers[info[i]] = new ASPxClientMenuScrollHelper(this, info[i]);
 },
 IsCallbacksEnabled: function(){
  return _aspxIsFunction(this.callBack);
 },
 ShouldHideExistingLoadingPanel: function() {
  return false;
 }, 
 GetMenuElementId: function(indexPath) {
  return this.name + __aspxMMIdSuffix + indexPath + "_";
 },
 GetMenuMainElementId: function(indexPath) {
  return this.name + (this.liteRender ? "_DXME" : "_DXMST") + indexPath + "_";
 },
 GetMenuBorderCorrectorElementId: function(indexPath) {
  return this.name + "_DXMBC" + indexPath + "_";
 },
 GetMenuIFrameElementId: function(indexPath) {
  return this.name + "_DXMIF" + this.GetMenuLevel(indexPath);
 },
 GetScrollAreaId: function(indexPath) {
  return this.name + "_DXSA" + indexPath;
 },
 GetMenuTemplateContainerID: function(indexPath) {
  return this.name + "_MTCNT" + indexPath;
 },
 GetScrollUpButtonId: function(indexPath) {
  return this.name + __aspxSBIdSuffix + indexPath + __aspxSBUIdEnd;
 },
 GetScrollDownButtonId: function(indexPath) {
  return this.name + __aspxSBIdSuffix + indexPath + __aspxSBDIdEnd;
 },
 GetItemElementId: function(indexPath) {
  return this.name + __aspxMIIdSuffix + indexPath + "_";
 },
 GetItemTextCellId: function(indexPath) {
  return this.GetItemElementId(indexPath) + "T";
 },
 GetItemPopOutImageCellId: function(indexPath){
  return this.GetItemElementId(indexPath) + "P";
 },
 GetItemImageId: function(indexPath) {
  return this.GetItemElementId(indexPath) + "Img";
 },
 GetItemPopOutImageId: function(indexPath) {
  return this.GetItemElementId(indexPath) + "PImg";
 },
 GetItemIndentElementId: function(indexPath) {
  return this.GetItemElementId(indexPath) + "II";
 },
 GetItemSeparatorElementId: function(indexPath) {
  return this.GetItemElementId(indexPath) + "IS";
 },
 GetMenuElement: function(indexPath){
  return _aspxGetElementById(this.GetMenuElementId(indexPath));
 },
 GetMenuIFrameElement: function(indexPath){
  var elementId = this.GetMenuIFrameElementId(indexPath);
  var element = _aspxGetElementById(elementId);
  if(!element && this.createIFrames)
   return this.CreateIFrameElement(elementId);
  return element;
 },
 CreateIFrameElement: function(elementId) {
  var element = document.createElement("IFRAME");
  _aspxSetAttribute(element, "id", elementId);
  _aspxSetAttribute(element, "src", "javascript:false");
  _aspxSetAttribute(element, "scrolling", "no");
  _aspxSetAttribute(element, "frameborder", "0");
  element.style.position = "absolute";
  element.style.display = "none";
  element.style.zIndex = "19997";
  element.style.filter = "progid:DXImageTransform.Microsoft.Alpha(Style=0, Opacity=0)";
  _aspxInsertElementAfter(element, this.GetMainElement());
  return element;
 },
 GetMenuBorderCorrectorElement: function(indexPath){
  return _aspxGetElementById(this.GetMenuBorderCorrectorElementId(indexPath));
 },
 GetMenuMainCell: function(element){
  var menuMainTable = this.GetMenuMainTable(element);
  if(this.liteRender)
   return menuMainTable;
  return this.liteRender ? menuMainTable : menuMainTable.rows[0].cells[this.rtl && this.shadowVisible ? 1 : 0];
 },
 GetMenuMainTable: function(element){
  var indexPath = this.GetIndexPathById(element.id, true);
  var shadowTable = _aspxGetElementById(this.GetMenuMainElementId(indexPath));
  return shadowTable != null ? shadowTable : element;
 },
 GetScrollAreaElement: function(indexPath){
  return _aspxGetElementById(this.GetScrollAreaId(indexPath));
 },
 GetScrollContentItemsOuterContainer: function(indexPath){
  return this.liteRender ? _aspxGetChildByTagName(this.GetScrollAreaElement(indexPath), "UL", 0) : 
   _aspxGetChildByTagName(this.GetScrollAreaElement(indexPath), "TABLE", 0);
 },
 GetScrollContentItemsContainer: function(indexPath){
  return this.liteRender ? _aspxGetChildByTagName(this.GetScrollAreaElement(indexPath), "UL", 0) : 
   _aspxGetChildByTagName(this.GetScrollAreaElement(indexPath), "TBODY", 0);
 },
 GetScrollUpButtonElement: function(indexPath){
  return _aspxGetElementById(this.GetScrollUpButtonId(indexPath));
 },
 GetScrollDownButtonElement: function(indexPath){
  return _aspxGetElementById(this.GetScrollDownButtonId(indexPath));
 },
 GetItemElement: function(indexPath){
  return _aspxGetElementById(this.GetItemElementId(indexPath));
 },
 GetItemTemplateCell: function(indexPath){ 
  return this.GetItemTextTemplateContainer(indexPath);
 },
 GetItemTemplateContainer: function(indexPath) {
  return this.liteRender
   ? this.GetItemElement(indexPath)
   : this.GetItemTextCell(indexPath);
 },
 GetItemTextTemplateContainer: function(indexPath) {
  return this.liteRender
   ? this.GetItemTextCell(indexPath)
   : _aspxGetElementById(this.GetItemElementId(indexPath) + "ITC");
 },
 GetItemImageCell: function(indexPath){
  if(!this.liteRender)
   return _aspxGetElementById(this.GetItemElementId(indexPath) + "I");
  else
   return this.GetItemTextCell(indexPath);
 },
 GetItemIndentCell: function(indexPath){
  return _aspxGetElementById(this.GetItemElementId(indexPath) + "N");
 },
 GetItemTextCell: function(indexPath){
  return _aspxGetElementById(this.GetItemTextCellId(indexPath));
 },
 GetItemPopOutImageCell: function(indexPath){
  return _aspxGetElementById(this.GetItemPopOutImageCellId(indexPath));
 },
 GetItemTextOrImageCell: function(indexPath){
  var element = this.GetItemTextCell(indexPath);
  if(element == null)
   element = this.GetItemImageCell(indexPath);
  return element;
 },
 GetSelectedItemInputElement: function(){
  return _aspxGetElementById(this.name + "SI");
 },
 GetCheckedItemsInputElement: function(){
  return _aspxGetElementById(this.name + "CI");
 },
 GetSubMenuXPosition: function(indexPath) {
  var pos = this.liteRender ? 
   this.GetLiteSubMenuXPosition(indexPath) :
   this.GetClassicSubMenuXPosition(indexPath);
  if(__aspxWebKitFamily && !this.IsParentElementPositionStatic(indexPath))
   pos -= document.body.offsetLeft;
  return pos;
 },
 GetClassicSubMenuXPosition: function(indexPath){
  var position = 0;
  var imageElement = this.GetItemImageCell(indexPath);
  var textElement = this.GetItemTextCell(indexPath);
  var popOutImageElement = this.GetItemPopOutImageCell(indexPath);
  var imagePos = _aspxGetAbsoluteX(imageElement);
  var textPos = _aspxGetAbsoluteX(textElement);
  var popOutImagePos = _aspxGetAbsoluteX(popOutImageElement);
  if(imageElement != null || textElement != null || popOutImageElement != null){
   var element = null;
   var updatePositionFunc;
   if(this.IsVertical(indexPath)) {
    position = __aspxAbsoluteLeftPosition;
    updatePositionFunc = function(element_, elementPos) {
     if(element_ != null && elementPos > position) {
      position = elementPos;
      element = element_;
     }
    };
   }
   else {
    position = __aspxAbsoluteRightPosition;
    updatePositionFunc = function(element_, elementPos) {
     if(element_ != null && elementPos < position ) {
      position = elementPos;
      element = element_;
     }
    };
   }
   updatePositionFunc(imageElement, imagePos);
   updatePositionFunc(textElement, textPos);
   updatePositionFunc(popOutImageElement, popOutImagePos);
   if(this.IsVertical(indexPath))
    position += element.clientWidth;
  }
  return position;
 },
 GetLiteSubMenuXPosition: function(indexPath) {
  var itemElement = this.GetItemElement(indexPath);
  return _aspxGetAbsoluteX(itemElement)
   + (this.IsVertical(indexPath) ? itemElement.clientWidth + itemElement.clientLeft : 0);
 },
 GetSubMenuYPosition: function(indexPath){
  var position = 0;
  var element = this.liteRender
   ? this.GetItemElement(indexPath)
   : this.GetItemTextOrImageCell(indexPath);
  if(element != null){
   if(this.IsVertical(indexPath)){
    position = _aspxGetAbsoluteY(element); 
   }
   else{
    if(__aspxNetscapeFamily || __aspxOpera && __aspxBrowserVersion >= 9 || __aspxSafari && __aspxBrowserVersion >= 3 || __aspxChrome)
     position = _aspxGetAbsoluteY(element) + element.offsetHeight - _aspxGetClientTop(element);
    else if(__aspxWebKitFamily)
     position = _aspxGetAbsoluteY(element) + element.offsetHeight + element.offsetTop - _aspxGetClientTop(element);
    else
     position = _aspxGetAbsoluteY(element) + element.clientHeight + _aspxGetClientTop(element);
   }
  }
  if(__aspxWebKitFamily && !this.IsParentElementPositionStatic(indexPath))
   position -= document.body.offsetTop;
  return position;
 },
 GetClientSubMenuXPosition: function(element, x, indexPath){
  var itemInfo = new ASPxClientMenuItemInfo(this, indexPath);
  var itemWidth = itemInfo.clientWidth;
  var itemOffsetWidth = itemInfo.offsetWidth;
  var subMenuWidth = this.GetMenuMainCell(element).offsetWidth;
  var docClientWidth = _aspxGetDocumentClientWidth();
  if(this.IsVertical(indexPath)){
   var left = x - _aspxGetDocumentScrollLeft();
   var right = left + subMenuWidth;
   var toLeftX = x - subMenuWidth - itemWidth;
   var toLeftLeft = left - subMenuWidth - itemWidth;
   var toLeftRight = right - subMenuWidth - itemWidth;
   if(this.popupToLeft){
    if(toLeftLeft < 0 && toLeftLeft < docClientWidth - right){
     this.popupToLeft = false;
     return x;
    }
    else
     return toLeftX;
   }
   else{
    if(docClientWidth - right < 0 && docClientWidth - right < toLeftLeft){
     this.popupToLeft = true;
     return toLeftX;
    }
    else
     return x;
   }
  }
  else{
   var left = x - _aspxGetDocumentScrollLeft();
   var right = left + subMenuWidth + this.GetShadowWidth();
   var toLeftX = x - subMenuWidth + itemOffsetWidth;
   var toLeftLeft = left - subMenuWidth + itemOffsetWidth;
   var toLeftRight = right - subMenuWidth + itemOffsetWidth;
   if(this.popupToLeft){
    if(toLeftLeft < 0 && toLeftLeft < docClientWidth - right){
     this.popupToLeft = false;
     return x;
    }
    else
     return toLeftX;
   }
   else{
    if(docClientWidth - right < 0 && docClientWidth - right < toLeftLeft){
     this.popupToLeft = true;
     return toLeftX;
     }
     else
     return x;
   }
  }
 },
 GetClientSubMenuYPosition: function(element, y, indexPath){
  var itemInfo = new ASPxClientMenuItemInfo(this, indexPath);
  var itemHeight = itemInfo.clientHeight;
  var itemOffsetHeight = itemInfo.offsetHeight;
  var subMenuHeight = this.GetMenuMainCell(element).offsetHeight;
  var menuItemTop = y - _aspxGetDocumentScrollTop();
  var subMenuBottom = menuItemTop + subMenuHeight;
  var docClientHeight = _aspxGetDocumentClientHeight();
  var clientSubMenuYPos = y;  
  if(this.IsVertical(indexPath)){
   var notEnoughSpaceToShowDown = subMenuBottom > docClientHeight;
   var menuItemBottom = menuItemTop + itemHeight;
   if(menuItemBottom > docClientHeight) {
    menuItemBottom = docClientHeight;
    itemHeight = menuItemBottom - menuItemTop;
   }
   var notEnoughSpaceToShowUp = menuItemBottom < subMenuHeight;
   var subMenuIsFitToDisplayFrames = docClientHeight >= subMenuHeight;  
   if (!subMenuIsFitToDisplayFrames) clientSubMenuYPos = y - menuItemTop;
   else if(notEnoughSpaceToShowDown){
    if (notEnoughSpaceToShowUp){   
     var docClientBottom = _aspxGetDocumentScrollTop() + docClientHeight;
     clientSubMenuYPos = docClientBottom - this.GetShadowHeight() - subMenuHeight; 
    } else 
     clientSubMenuYPos =  y + itemHeight - subMenuHeight - this.GetShadowHeight();
   }   
  }
  else{
   if(subMenuBottom > docClientHeight && menuItemTop - subMenuHeight - itemHeight > docClientHeight - subMenuBottom)
    clientSubMenuYPos = y - subMenuHeight - itemHeight;
  }
  return clientSubMenuYPos;
 },
 GetShadowWidth: function(){
  return this.shadowVisible ? __aspxPopupShadowWidth : 0;
 },
 GetShadowHeight: function(){
  return this.shadowVisible ? __aspxPopupShadowHeight : 0;
 },
 HasChildren: function(indexPath){
  return (this.GetMenuElement(indexPath) != null);
 },
 IsVertical: function(indexPath){
  return true;
 },
 IsRootItem: function(indexPath){
  return this.GetMenuLevel(indexPath) <= 1;
 },
 IsParentElementPositionStatic: function(indexPath){
  return this.IsRootItem(indexPath);
 },
 GetItemIndexPath: function(indexes){
  return aspxGetMenuCollection().GetItemIndexPath(indexes);
 },
 GetItemIndexes: function(indexPath){
  return aspxGetMenuCollection().GetItemIndexes(indexPath);
 },
 GetItemIndexPathById: function(id){
  return aspxGetMenuCollection().GetIndexPathById(id, __aspxMIIdSuffix);
 },
 GetMenuIndexPathById: function(id){
  return aspxGetMenuCollection().GetIndexPathById(id, __aspxMMIdSuffix);
 },
 GetScrollButtonIndexPathById: function(id){
  return aspxGetMenuCollection().GetIndexPathById(id, __aspxSBIdSuffix);
 },
 GetIndexPathById: function(id, checkMenu){
  var indexPath = this.GetItemIndexPathById(id);
  if(indexPath == "" && checkMenu) 
   indexPath = this.GetMenuIndexPathById(id);
  return indexPath;
 },
 GetMenuLevel: function(indexPath){
  return aspxGetMenuCollection().GetMenuLevel(indexPath);
 },
 GetParentIndexPath: function(indexPath){
  var indexes = this.GetItemIndexes(indexPath);
  indexes.length --;
  return (indexes.length > 0) ? this.GetItemIndexPath(indexes) : ""; 
 },
 GetFirstChildIndexPath: function(indexPath){
  var indexes = this.GetItemIndexes(indexPath);
  indexes[indexes.length] = 0;
  var newIndexPath = this.GetItemIndexPath(indexes); 
  return this.GetFirstSiblingIndexPath(newIndexPath);
 },
 GetFirstSiblingIndexPath: function(indexPath){
  var indexes = this.GetItemIndexes(indexPath);
  var i = 0;
  while(true){
   indexes[indexes.length - 1] = i;
   var newIndexPath = this.GetItemIndexPath(indexes); 
   if(!this.IsItemExist(newIndexPath))
    return null;
   if(this.IsItemExistAndEnabled(newIndexPath))
    return newIndexPath;
   i++;
  }
  return null;
 },
 GetLastSiblingIndexPath: function(indexPath){
  var indexes = this.GetItemIndexes(indexPath);
  var newIndexPath = null;
  var i = indexes[indexes.length - 1] + 1;
  while(true){  
   indexes[indexes.length - 1] = i;
   var nextIndexPath = this.GetItemIndexPath(indexes); 
   if(!this.IsItemExist(nextIndexPath))
    return newIndexPath;
   if(this.IsItemExistAndEnabled(nextIndexPath))
    newIndexPath = nextIndexPath;
   i++;
  }
  return null;
 },
 GetNextSiblingIndexPath: function(indexPath){
  if(this.IsLastItem(indexPath)) return null;
  var indexes = this.GetItemIndexes(indexPath);
  var i = indexes[indexes.length - 1] + 1;
  while(true){  
   indexes[indexes.length - 1] = i;
   var newIndexPath = this.GetItemIndexPath(indexes); 
   if(!this.IsItemExist(newIndexPath))
    return null;
   if(this.IsItemExistAndEnabled(newIndexPath))
    return newIndexPath;
   i++;
  }
  return null;
 },
 GetPrevSiblingIndexPath: function(indexPath){
  if(this.IsFirstItem(indexPath)) return null;
  var indexes = this.GetItemIndexes(indexPath);
  var i = indexes[indexes.length - 1] - 1;
  while(true){  
   indexes[indexes.length - 1] = i;
   var newIndexPath = this.GetItemIndexPath(indexes); 
   if(!this.IsItemExist(newIndexPath))
    return null;
   if(this.IsItemExistAndEnabled(newIndexPath))
    return newIndexPath;
   i--;
  }
  return null;
 },
 IsLastElement: function(element){
  return element && (!element.nextSibling || !element.nextSibling.tagName);
 },
 IsLastItem: function(indexPath){
  if(this.IsVertical(indexPath) || this.liteRender){
   var itemElement = this.GetItemElement(indexPath);
   return this.IsLastElement(itemElement);
  } 
  else{
   var imageCell = this.GetItemImageCell(indexPath);
   if(this.IsLastElement(imageCell))
    return true;
   var textCell = this.GetItemTextCell(indexPath);
   if(this.IsLastElement(textCell))
    return true;
   var popOutImageCell = this.GetItemPopOutImageCell(indexPath);
   if(this.IsLastElement(popOutImageCell))
    return true;
   return false;
  }
 },
 IsFirstElement: function(element){
  return element && (!element.previousSibling || !element.previousSibling.tagName);
 },
 IsFirstItem: function(indexPath){
  if(this.IsVertical(indexPath) || this.liteRender){
   var itemElement = this.GetItemElement(indexPath);
   return this.IsFirstElement(itemElement);
  } 
  else{
   var imageCell = this.GetItemImageCell(indexPath);
   if(this.IsFirstElement(imageCell))
    return true;
   var textCell = this.GetItemTextCell(indexPath);
   if(this.IsFirstElement(textCell))
    return true;
   var popOutImageCell = this.GetItemPopOutImageCell(indexPath);
   if(this.IsFirstElement(popOutImageCell))
    return true;
   return false;
  }
 },
 IsItemExist: function(indexPath){
  return !!this.GetItemTextOrImageCell(indexPath);
 },
 IsItemExistAndEnabled: function(indexPath){
  if(this.liteRender) {
   var itemElement = this.GetItemElement(indexPath);
   return itemElement && !itemElement.clientDisabled;
  }
  else {
   var cell = this.GetItemTextOrImageCell(indexPath);
   if(cell){
    var link = _aspxGetChildByTagName(cell, "A", 0);
    if(link)
     return !_aspxIsExists(cell.enabled) || cell.enabled;
   }
   return false;
  }
 },
 GetClientSubMenuPos: function(element, indexPath, pos, isXPos){
  if (!_aspxGetIsValidPosition(pos)){
   pos = isXPos ? this.GetSubMenuXPosition(indexPath) : 
    this.GetSubMenuYPosition(indexPath);
  }
  var clientPos = isXPos ? this.GetClientSubMenuXPosition(element, pos, indexPath) :
   this.GetClientSubMenuYPosition(element, pos, indexPath);
  var isInverted = pos != clientPos;
  var offset = isXPos ? this.GetSubMenuXOffset(indexPath) : this.GetSubMenuYOffset(indexPath);
  clientPos += isInverted ? - offset : offset;
  clientPos -= _aspxGetPositionElementOffset(this.GetMenuElement(indexPath), isXPos);
  return new _aspxPopupPosition(clientPos, isInverted);
 },
 GetSubMenuXOffset: function(indexPath){
  if(indexPath == "")
   return 0;
  else if(this.IsRootItem(indexPath)){
   if(this.IsFirstItem(indexPath))
    return this.rootSubMenuFIXOffset;
   else if(this.IsLastItem(indexPath))
    return this.rootSubMenuLIXOffset;
   else
    return this.rootSubMenuXOffset;
  }
  else{
   if(this.IsFirstItem(indexPath))
    return this.subMenuFIXOffset;
   else if(this.IsLastItem(indexPath))
    return this.subMenuLIXOffset;
   else
    return this.subMenuXOffset;
  }
 },
 GetSubMenuYOffset: function(indexPath){
  if(indexPath == "")
   return 0;
  else if(this.IsRootItem(indexPath)){
   if(this.IsFirstItem(indexPath))
    return this.rootSubMenuFIYOffset;
   else if(this.IsLastItem(indexPath))
    return this.rootSubMenuLIYOffset;
   else
    return this.rootSubMenuYOffset;
  }
  else{
   if(this.IsFirstItem(indexPath))
    return this.subMenuFIYOffset;
   else if(this.IsLastItem(indexPath))
    return this.subMenuLIYOffset;
   else
    return this.subMenuYOffset;
  }
 },
 StartScrolling: function(buttonId, delay, step) {
  var indexPath = this.GetScrollButtonIndexPathById(buttonId);
  var level = this.GetMenuLevel(indexPath);
  aspxGetMenuCollection().DoHidePopupMenus(null, level, this.name, false, "");
  var direction = (buttonId.lastIndexOf(__aspxSBDIdEnd) == buttonId.length - __aspxSBDIdEnd.length) ? 1 : -1;
  var scrollHelper = this.scrollHelpers[indexPath];
  if(scrollHelper) scrollHelper.StartScrolling(direction, delay, step);
 },
 StopScrolling: function(buttonId) {
  var indexPath = this.GetScrollButtonIndexPathById(buttonId);
  var scrollHelper = this.scrollHelpers[indexPath];
  if(scrollHelper) scrollHelper.StopScrolling();
 },
 ClearAppearTimer: function(){
  aspxGetMenuCollection().ClearAppearTimer();
 },
 ClearDisappearTimer: function(){
  aspxGetMenuCollection().ClearDisappearTimer();
 },
 IsAppearTimerActive: function(){
  return aspxGetMenuCollection().IsAppearTimerActive();
 },
 IsDisappearTimerActive: function(){
  return aspxGetMenuCollection().IsDisappearTimerActive();
 },
 SetAppearTimer: function(indexPath){
  aspxGetMenuCollection().SetAppearTimer(this.name, indexPath, this.appearAfter);
 },
 SetDisappearTimer: function(){
  aspxGetMenuCollection().SetDisappearTimer(this.name, this.disappearAfter);
 },
 IsDropDownItem: function(indexPath){
  if(this.liteRender)
   return _aspxElementCssClassContains(this.GetItemElement(indexPath), ASPxClientMenuCssClasses.ItemDropDownMode);
  else {
   var element = this.GetItemPopOutImageCell(indexPath);
   if(element && element.onclick)
    return element.onclick.toString().indexOf("aspxMIDDClick") > -1;
   return false;
  }
 },
 DoItemClick: function(indexPath, hasItemLink, htmlEvent){
  var processOnServer = this.RaiseItemClick(indexPath, htmlEvent);
  if(processOnServer && !hasItemLink)
   this.SendPostBack("CLICK:" + indexPath);
  else{
   this.ClearDisappearTimer();
   this.ClearAppearTimer();
   if(!this.HasChildren(indexPath) || this.IsDropDownItem(indexPath))
    aspxGetMenuCollection().DoHidePopupMenus(null, -1, this.name, false, "");
   else if(this.IsItemEnabled(indexPath) && !this.IsDropDownItem(indexPath))
    this.ShowSubMenu(indexPath);
  }
 },
 HasContent: function(mainCell) {
  for(var i = 0; i < mainCell.childNodes.length; i++)
   if(mainCell.childNodes[i].tagName)
    return true;
  return false;
 },
 DoShowPopupMenu: function(element, x, y, indexPath){
  if(element && this.IsCallbacksEnabled()){
   var mainCell = this.GetMenuMainCell(element);
   if(mainCell && !this.HasContent(mainCell))
    this.CreateLoadingPanelInsideContainer(mainCell);
  }
  if(this.liteRender)
   ASPxClientMenuLiteRenderHelper.PrepareSubMenuSize(this, element);
  _aspxSetStylePosition(element, __aspxInvalidPosition, __aspxInvalidPosition);
  _aspxSetElementDisplay(element, true);
  if(this.popupCount == 0) this.popupToLeft = this.rtl;
  var horizontalPopupPosition = this.GetClientSubMenuPos(element, indexPath, x, true);
  var verticalPopupPosition = this.GetClientSubMenuPos(element, indexPath, y, false);
  var clientX = horizontalPopupPosition.position;
  var clientY = verticalPopupPosition.position;
  var toTheLeft = horizontalPopupPosition.isInverted;
  var toTheTop = verticalPopupPosition.isInverted;
  var scrollHelper = this.scrollHelpers[indexPath];
  if(scrollHelper) {
   var yClientCorrection = this.GetScrollSubMenuYCorrection(element, scrollHelper, clientY);
   if(yClientCorrection > 0) {
    clientY += yClientCorrection;
    verticalPopupPosition.position = clientY;
   }
  }
  var parentElement = this.GetItemTextOrImageCell(indexPath);
  var prevParentPos = _aspxGetAbsoluteX(parentElement);
  _aspxSetStylePosition(element, clientX, clientY);
  if(__aspxIE && __aspxBrowserMajorVersion > 7 && _aspxIsElementRightToLeft(document.body)) {
   _aspxSetElementDisplay(element, false);   
   _aspxSetElementDisplay(element, true);   
  }  
  clientX += _aspxGetAbsoluteX(parentElement) - prevParentPos;
  if (this.enableAnimation){
   this.StartAnimation(element, indexPath, horizontalPopupPosition, verticalPopupPosition);
  }
  else{
   _aspxSetStylePosition(element, clientX, clientY);
   _aspxSetElementVisibility(element, true);
   this.DoShowPopupMenuIFrame(element, clientX, clientY, __aspxInvalidDimension, __aspxInvalidDimension, indexPath);
   this.DoShowPopupMenuBorderCorrector(element, clientX, clientY, indexPath, toTheLeft, toTheTop);
  }
  aspxGetMenuCollection().RegisterVisiblePopupMenu(this.name, element.id);
  this.popupCount ++;
  aspxGetControlCollection().AdjustControls(element);
  this.RaisePopUp(indexPath);
 },
 GetScrollSubMenuYCorrection: function(element, scrollHelper, clientY) {
  var absoluteClientY = clientY + _aspxGetPositionElementOffset(element);
  var excessTop = this.GetScrollExcessTop(absoluteClientY);
  var excessBottom = this.GetScrollExcessBottom(element, absoluteClientY);
  var correction = 0;
  if(excessTop > 0)
   correction += excessTop + this.scrollVertOffset;
  if(excessBottom > 0 && (absoluteClientY + correction == _aspxGetDocumentScrollTop())) {
   excessBottom += this.scrollVertOffset;
   correction += this.scrollVertOffset;
  }
  this.PrepareScrolling(element, scrollHelper, excessTop, excessBottom);
  return correction;
 },
 GetScrollExcessTop: function(clientY) {
  return _aspxGetDocumentScrollTop() - clientY;
 },
 GetScrollExcessBottom: function(element, clientY) {
  _aspxSetElementDisplay(element, false);
  var docHeight = _aspxGetDocumentClientHeight();
  _aspxSetElementDisplay(element, true);
  return clientY + element.offsetHeight - _aspxGetDocumentScrollTop() - docHeight;  
 },
 PrepareScrolling: function(element, scrollHelper, excessTop, excessBottom) {  
  scrollHelper.Initialize();
  var corrector = element.offsetHeight - scrollHelper.GetScrollAreaHeight() + this.scrollVertOffset;
  if(excessTop > 0)
   scrollHelper.Calculate(element.offsetHeight - excessTop - corrector);
  if(excessBottom > 0)
   scrollHelper.Calculate(element.offsetHeight - excessBottom - corrector);
 },
 DoShowPopupMenuIFrame: function(element, x, y, width, height, indexPath){
  if (!this.renderIFrameForPopupElements) return;
  var iFrame = element.overflowElement;
  if(!iFrame) {
   iFrame = this.GetMenuIFrameElement(indexPath);
   element.overflowElement = iFrame;
  }
  if(iFrame) {
   var cell = this.GetMenuMainCell(element);
   if (width < 0)
    width = cell.offsetWidth;
   if (height < 0)
    height = cell.offsetHeight;
   _aspxSetStyleSize(iFrame, width, height);
   _aspxSetStylePosition(iFrame, x, y);
   _aspxSetElementDisplay(iFrame, true);
  }
 },
 DoShowPopupMenuBorderCorrector: function(element, x, y, indexPath, toTheLeft, toTheTop){
  var borderCorrectorElement = this.GetMenuBorderCorrectorElement(indexPath);
  if(borderCorrectorElement) {
   var params = this.GetPopupMenuBorderCorrectorPositionAndSize(element, x, y, indexPath, toTheLeft, toTheTop);
   _aspxSetStyleSize(borderCorrectorElement, params.width, params.height);
   _aspxSetStylePosition(borderCorrectorElement, params.left, params.top);
   _aspxSetElementVisibility(borderCorrectorElement, true);
   _aspxSetElementDisplay(borderCorrectorElement, true);
   element.borderCorrectorElement = borderCorrectorElement;
  }
 },
 GetPopupMenuBorderCorrectorPositionAndSize: function(element, x, y, indexPath, toTheLeft, toTheTop) {
  var result = {};
  var itemInfo = new ASPxClientMenuItemInfo(this, indexPath);
  var menuXOffset = _aspxGetClientLeft(this.GetMenuMainCell(element));
  var menuYOffset = _aspxGetClientTop(this.GetMenuMainCell(element));
  var mainCell = this.GetMenuMainCell(element);
  var menuClientWidth = mainCell.clientWidth;
  var menuClientHeight = mainCell.clientHeight;
  if(this.IsVertical(indexPath)){
   var commonClientHeight = itemInfo.clientHeight < menuClientHeight
    ? itemInfo.clientHeight
    : menuClientHeight;
   result.width = menuXOffset;
   result.height = commonClientHeight + itemInfo.clientTop - menuYOffset;
   result.left = x;
   if(toTheLeft)
    result.left += menuClientWidth + menuXOffset;
   result.top = y + menuYOffset;
   if(toTheTop)
    result.top += menuClientHeight - result.height;
  }
  else{
   var itemWidth = itemInfo.clientWidth;
   if(this.IsDropDownItem(indexPath)){
    if(this.liteRender)
     itemWidth = this.GetItemTextCell(indexPath).clientWidth;
    else {
     var popOutImageElement = this.GetItemPopOutImageCell(indexPath);
     if(popOutImageElement != null)
      itemWidth -= popOutImageElement.clientWidth;
    }
   }
   var commonClientWidth = itemWidth < menuClientWidth
    ? itemWidth
    : menuClientWidth;
   result.width = commonClientWidth + itemInfo.clientLeft - menuXOffset;
   result.height = menuYOffset;
   result.left = x + menuXOffset;
   if(toTheLeft)
    result.left += menuClientWidth - result.width;
   result.top = y;
   if(toTheTop)
    result.top += menuClientHeight + menuYOffset;
   if(!this.liteRender && __aspxWebKitFamily && itemInfo.offsetLeft > 0)
    result.width += itemInfo.clientLeft;
  }
  return result;
 },
 DoHidePopupMenu: function(evt, element){
  this.DoHidePopupMenuBorderCorrector(element);
  this.DoHidePopupMenuIFrame(element);
  _aspxStopAnimation(element);
  _aspxSetElementVisibility(element, false);
  _aspxSetElementDisplay(element, false);
  this.CancelSubMenuItemHoverItem(element);
  aspxGetMenuCollection().UnregisterVisiblePopupMenu(this.name, element.id);
  this.popupCount --;
  var indexPath = this.GetIndexPathById(element.id, true);
  var scrollHelper = this.scrollHelpers[indexPath];
  if(scrollHelper) {
   element.style.height = "";
   scrollHelper.ResetScrolling();
  }
  this.RaiseCloseUp(indexPath);
 },
 DoHidePopupMenuIFrame: function(element){
  if (!this.renderIFrameForPopupElements) return;
  var iFrame = element.overflowElement;
  if(iFrame)
   _aspxSetElementDisplay(iFrame, false);  
 },
 DoHidePopupMenuBorderCorrector: function(element){
  var borderCorrectorElement = element.borderCorrectorElement;
  if(borderCorrectorElement) {
   _aspxSetElementVisibility(borderCorrectorElement, false);
   _aspxSetElementDisplay(borderCorrectorElement, false);
   element.borderCorrectorElement = null;
  }
 },
 SetHoverElement: function(element){
  this.lockHoverEvents = true;
  aspxGetStateController().SetCurrentHoverElementBySrcElement(element);
  this.lockHoverEvents = false;
 },
 ApplySubMenuItemHoverItem: function(element, hoverItem, hoverElement){
  if(!element.hoverItem && _aspxGetElementDisplay(element)) {
   var newHoverItem = hoverItem.Clone();
   element.hoverItem = newHoverItem;
   element.hoverElement = hoverElement;
   newHoverItem.Apply(hoverElement);
  }
 },
 CancelSubMenuItemHoverItem: function(element){
  if(element.hoverItem) {
   element.hoverItem.Cancel(element.hoverElement);
   element.hoverItem = null;
   element.hoverElement = null;
  }
 },
 ShowSubMenu: function(indexPath){
  var element = this.GetMenuElement(indexPath);
  if(element != null){
   var level = this.GetMenuLevel(indexPath);
   aspxGetMenuCollection().DoHidePopupMenus(null, level - 1, this.name, false,  element.id);
   if (!_aspxGetElementDisplay(element))
    this.DoShowPopupMenu(element, __aspxInvalidPosition, __aspxInvalidPosition, indexPath);
  } 
  this.ClearAppearTimer();
 },
 SelectItem: function(indexPath){
  var element = this.GetItemTextOrImageCell(indexPath);
  if(element != null)
   aspxGetStateController().SelectElementBySrcElement(element);
 },
 DeselectItem: function(indexPath){
  var element = this.GetItemTextOrImageCell(indexPath);
  if(element != null){
   var hoverItem = null;
   var hoverElement = null;
   var menuElement = this.GetMenuElement(indexPath);
   if (menuElement && menuElement.hoverItem) {
    hoverItem = menuElement.hoverItem;
    hoverElement = menuElement.hoverElement;
    this.CancelSubMenuItemHoverItem(menuElement);
   }
   aspxGetStateController().DeselectElementBySrcElement(element);
   if(menuElement != null && hoverItem != null)
    this.ApplySubMenuItemHoverItem(menuElement, hoverItem, hoverElement);
  }
 },
 InitializeSelectedItem: function(){
  if(!this.allowSelectItem) return;
  this.SelectItem(this.GetSelectedItemIndexPath());
 },
 GetSelectedItemIndexPath: function(){
  var inputElement = this.GetSelectedItemInputElement();
  if(inputElement != null)
   return inputElement.value;
  return ""; 
 },
 SetSelectedItemInternal: function(indexPath, modifyHotTrackSelection){
  if(modifyHotTrackSelection)
   this.SetHoverElement(null);
  var inputElement = this.GetSelectedItemInputElement();
  if(inputElement != null){
   this.DeselectItem(inputElement.value);
   inputElement.value = indexPath;
   var item = this.GetItemByIndexPath(indexPath);
   if(item == null || item.GetEnabled())
    this.SelectItem(inputElement.value);
  }
  if(modifyHotTrackSelection){
   var element = this.GetItemTextOrImageCell(indexPath);
   if(element != null) 
    this.SetHoverElement(element);
  }
 },
 InitializeCheckedItems: function(){
  if(!this.allowCheckItems) return;
  var inputElement = this.GetCheckedItemsInputElement();
  if(inputElement != null){
   var indexPathes = inputElement.value.split(";");
   for(var i = 0; i < indexPathes.length; i ++){
    if(indexPathes[i] != ""){
     this.checkedItems.push(indexPathes[i]);
     this.SelectItem(indexPathes[i]);
    }
   }
  }
 },
 ChangeCheckedItem: function(indexPath){
  this.SetHoverElement(null);
  var inputElement = this.GetCheckedItemsInputElement();
  if(inputElement != null){
   var itemsGroup = this.GetItemsGroup(indexPath);
   if(itemsGroup != null){
    if(itemsGroup.length > 1){
     if(!this.IsCheckedItem(indexPath)){
      for(var i = 0; i < itemsGroup.length; i ++){
       if(itemsGroup[i] == indexPath) continue;
       if(this.IsCheckedItem(itemsGroup[i])){
        _aspxArrayRemove(this.checkedItems, itemsGroup[i]);
        this.DeselectItem(itemsGroup[i]);
       }
      }
      this.SelectItem(indexPath);
      this.checkedItems.push(indexPath);
     }
    }
    else{
     if(this.IsCheckedItem(indexPath)){
      _aspxArrayRemove(this.checkedItems, indexPath);
      this.DeselectItem(indexPath);
     }
     else{
      this.SelectItem(indexPath);
      this.checkedItems.push(indexPath);
     }
    }
    this.UpdateCheckedInputElement(inputElement);
   }
  }
  var element = this.GetItemTextOrImageCell(indexPath);
  if(element != null) 
   this.SetHoverElement(element);
 },
 GetItemsGroup: function(indexPath){
  for(var i = 0; i < this.itemCheckedGroups.length; i ++){
   if(_aspxArrayIndexOf(this.itemCheckedGroups[i], indexPath) > -1)
    return this.itemCheckedGroups[i];
  }
  return null;
 },
 IsCheckedItem: function(indexPath){
  return _aspxArrayIndexOf(this.checkedItems, indexPath) > -1;
 },
 UpdateCheckedInputElement: function(inputElement){
  var state = "";
  for(var i = 0; i < this.checkedItems.length; i ++){
   state += this.checkedItems[i];
   if(i < this.checkedItems.length - 1)
    state += ";";
  }
  inputElement.value = state;
 },
 GetAnimationVerticalDirection: function(indexPath, popupPosition){
  var verticalDirection = (this.IsRootItem(indexPath) && !this.IsVertical(indexPath)) ? -1 : 0;
  if (popupPosition.isInverted) verticalDirection *= -1;
  return verticalDirection;
 },
 GetAnimationHorizontalDirection: function(indexPath, popupPosition){
  var horizontalDirection = (this.IsRootItem(indexPath) && !this.IsVertical(indexPath)) ? 0 : -1;
  if (popupPosition.isInverted) horizontalDirection *= -1;
  return horizontalDirection;
 },
 StartAnimation: function(animationDivElement, indexPath, horizontalPopupPosition, verticalPopupPosition){
  var element = this.GetMenuMainTable(animationDivElement);
  var clientX = horizontalPopupPosition.position;
  var clientY = verticalPopupPosition.position;
  _aspxInitAnimationDiv(animationDivElement, clientX, clientY, "aspxMATimer(\"" + this.name + "\", " + "\"" + indexPath + "\")", "");
  var verticalDirection = this.GetAnimationVerticalDirection(indexPath, verticalPopupPosition);
  var horizontalDirection = this.GetAnimationHorizontalDirection(indexPath, horizontalPopupPosition);
  var yPos = verticalDirection * element.offsetHeight;
  var xPos = horizontalDirection * element.offsetWidth;
  _aspxSetStylePosition(element, xPos, yPos);
  _aspxSetElementVisibility(animationDivElement, true);
  this.DoShowPopupMenuIFrame(animationDivElement, clientX, clientY, 0, 0, indexPath);
  this.DoShowPopupMenuBorderCorrector(animationDivElement, clientX, clientY, indexPath, 
   horizontalPopupPosition.isInverted, verticalPopupPosition.isInverted);
  animationDivElement.timerID = window.setTimeout(animationDivElement.onTimerString, this.animationDelay);
 },
 OnAnimationTimer: function(indexPath){  
  var animationDivElement = this.GetMenuElement(indexPath);
  if(animationDivElement) {
   var element = this.GetMenuMainTable(animationDivElement);
   var mainCell = this.GetMenuMainCell(element);   
   var iframeElement = this.GetMenuIFrameElement(indexPath);
   _aspxOnAnimationTimer(animationDivElement, element, mainCell, iframeElement, this.animationDelay, this.animationMaxDelay, __aspxMenuAnimationAccelerator);
  }
 },
 OnItemClick: function(indexPath, evt){
  var sourceElement = _aspxGetEventSource(evt);
  var clickedLinkElement = _aspxGetParentByTagName(sourceElement, "A");
  var isLinkClicked = (clickedLinkElement != null && clickedLinkElement.href != __aspxAccessibilityEmptyUrl);
  var element = this.GetItemTextOrImageCell(indexPath);
  var linkElement = (element != null) ? _aspxGetChildByTagName(element, "A", 0) : null;
  if(linkElement != null && linkElement.href == __aspxAccessibilityEmptyUrl)
   linkElement = null;
  if(this.allowSelectItem)
   this.SetSelectedItemInternal(indexPath, true); 
  if(this.allowCheckItems)
   this.ChangeCheckedItem(indexPath); 
  this.DoItemClick(indexPath, isLinkClicked || (linkElement != null), evt);
  if(!isLinkClicked && linkElement != null) 
   _aspxNavigateUrl(linkElement.href, linkElement.target);
 },
 OnItemDropDownClick: function(indexPath, evt){
  if(this.IsItemEnabled(indexPath))
   this.ShowSubMenu(indexPath);
 },
 AfterItemOverAllowed: function(hoverItem) {
  return hoverItem.name != "" && !this.lockHoverEvents;
 },
 OnAfterItemOver: function(hoverItem, hoverElement){
  if(!this.AfterItemOverAllowed(hoverItem)) return;
  if(!this.showSubMenus) {
   this.savedCallbackHoverItem = hoverItem;
   this.savedCallbackHoverElement = hoverElement;
   return;
  }
  this.ClearDisappearTimer();
  this.ClearAppearTimer();
  var indexPath = this.GetMenuIndexPathById(hoverItem.name);
  if(indexPath == ""){
   indexPath = this.GetItemIndexPathById(hoverItem.name);
   var canShowSubMenu = true;
   if(this.IsDropDownItem(indexPath)){
    var popOutImageElement = this.GetItemPopOutImageCell(indexPath);
    if(popOutImageElement != null && popOutImageElement != hoverElement){
     hoverItem.needRefreshBetweenElements = true;
     canShowSubMenu = false;
    }
   }
   if(canShowSubMenu){
    if(hoverItem.enabled && hoverItem.kind == __aspxHoverItemKind){
     this.SetAppearTimer(indexPath);
     this.RaiseItemMouseOver(indexPath);
    }
   }
  }
 },
 OnBeforeItemOver: function(hoverItem, hoverElement){
  if (__aspxNetscapeFamily && _aspxIsExists(hoverElement.offsetParent) && 
    hoverElement.offsetParent.style.borderCollapse == "collapse") {
   hoverElement.offsetParent.style.borderCollapse = "separate";
   hoverElement.offsetParent.style.borderCollapse = "collapse";
  }
  var indexPath = this.GetItemIndexPathById(hoverItem.name);
  var element = this.GetMenuElement(indexPath);
  if(element) this.CancelSubMenuItemHoverItem(element);  
 },
 OnItemOverTimer: function(indexPath){
  var element = this.GetMenuElement(indexPath);
  if(element == null){  
   var level = this.GetMenuLevel(indexPath);
   aspxGetMenuCollection().DoHidePopupMenus(null, level - 1, this.name, false, "");
  }   
  if(this.IsAppearTimerActive()){
   this.ClearAppearTimer();
   if(this.GetItemImageCell(indexPath) != null || this.GetItemIndentCell(indexPath) != null ||
    this.GetItemTextCell(indexPath) != null || this.GetItemPopOutImageCell(indexPath) != null){
    this.ShowSubMenu(indexPath);
   }
  }
 },
 OnBeforeItemDisabled: function(disabledItem, disabledElement){
  this.ClearAppearTimer();
  var indexPath = this.GetItemIndexPathById(disabledElement.id);
  if(indexPath != ""){
   var element = this.GetMenuElement(indexPath);
   if(element != null) this.DoHidePopupMenu(null, element);
  }
 },
 OnAfterItemOut: function(hoverItem, hoverElement, newHoverElement){
  if(!this.showSubMenus) {
   this.savedCallbackHoverItem = null;
   this.savedCallbackHoverElement = null;
  }
  if(hoverItem.name == "" || this.lockHoverEvents) return;
  if(hoverItem.IsChildElement(newHoverElement)) return;
  var indexPath = this.GetItemIndexPathById(hoverItem.name);
  var element = this.GetMenuElement(indexPath);
  this.ClearDisappearTimer();
  this.ClearAppearTimer();
  if(element == null || !_aspxGetIsParent(element, newHoverElement)) 
   this.SetDisappearTimer();
  if(element != null) 
   this.ApplySubMenuItemHoverItem(element, hoverItem, hoverElement);
  if(indexPath != "")
   this.RaiseItemMouseOut(indexPath);
 },
 OnItemOutTimer: function(){
  if(this.IsDisappearTimerActive()){
   this.ClearDisappearTimer();
   if(aspxGetMenuCollection().CheckFocusedElement())
    this.SetDisappearTimer();
   else
    this.OnHideByItemOut();
  }
 },
 OnHideByItemOut: function(){
  aspxGetMenuCollection().DoHidePopupMenus(null, 0, this.name, true, "");
 },
 OnFocusedItemKeyDown: function(evt, focusedItem, focusedElement){
  var handled = false;
  var indexPath = this.GetItemIndexPathById(focusedItem.name);
  switch(evt.keyCode){
   case ASPxKey.Tab: {
    handled = this.FocusNextTabItem(indexPath, evt.shiftKey);
    break;
   }
   case ASPxKey.Down: {
    if(this.IsVertical(indexPath)){
     this.FocusNextItem(indexPath);
    }
    else{
     this.ShowSubMenu(indexPath);
     this.FocusItemByIndexPath(this.GetFirstChildIndexPath(indexPath));
    }
    handled = true;
    break;
   }
   case ASPxKey.Up: {
    if(this.IsVertical(indexPath)){
     this.FocusPrevItem(indexPath);
    }
    else{
     this.ShowSubMenu(indexPath);
     this.FocusItemByIndexPath(this.GetFirstChildIndexPath(indexPath));
    }
    handled = true;
    break;
   }
   case ASPxKey.Left: {
    if(this.IsVertical(indexPath)){
     var parentIndexPath = this.GetParentIndexPath(indexPath);
     if(this.IsVertical(parentIndexPath)){
      this.FocusItemByIndexPath(parentIndexPath);
     }
     else{
      this.FocusPrevItem(parentIndexPath);
     }
    }
    else{
     this.FocusPrevItem(indexPath);
    }
    handled = true;
    break;
   }
   case ASPxKey.Right: {
    if(this.IsVertical(indexPath)){
     if(this.HasChildren(indexPath)){
      this.ShowSubMenu(indexPath);
      this.FocusItemByIndexPath(this.GetFirstChildIndexPath(indexPath));
     }
     else{
      while(!this.IsRootItem(indexPath))
       indexPath = this.GetParentIndexPath(indexPath);
      this.FocusNextItem(indexPath);
     }
    }
    else{
     this.FocusNextItem(indexPath);
    }
    handled = true;
    break;
   }
   case ASPxKey.Esc: {
    var parentIndexPath = this.GetParentIndexPath(indexPath);
    this.FocusItemByIndexPath(parentIndexPath);
    var element = this.GetMenuElement(parentIndexPath);
    if(element != null) {
     this.DoHidePopupMenu(null, element);
     handled = true;
    }
   }
  }
  if(handled)
   _aspxPreventEventAndBubble(evt);
 },
 FocusItemByIndexPath: function(indexPath){
  var element = this.GetItemTextOrImageCell(indexPath);
  var link = _aspxGetChildByTagName(element, "A", 0);
  if(link != null) _aspxSetFocus(link);
 },
 FocusNextTabItem: function(indexPath, shiftKey){
  if(this.IsRootItem(indexPath)) return false;
  while(true){
   if(this.IsRootItem(indexPath)) {
    if(!shiftKey){
     if(this.GetNextSiblingIndexPath(indexPath) != null){
      this.FocusNextItem(indexPath);
      return true;
     }
    }
    else{
     if(this.GetPrevSiblingIndexPath(indexPath) != null){
      this.FocusPrevItem(indexPath);
      return true;
     }
    }
    break;
   }
   else {
    if(!shiftKey){
     if(this.GetNextSiblingIndexPath(indexPath) == null)
      indexPath = this.GetParentIndexPath(indexPath);
     else{
      this.FocusNextItem(indexPath);
      return true;
     }
    }
    else{
     if(this.GetPrevSiblingIndexPath(indexPath) == null)
      indexPath = this.GetParentIndexPath(indexPath);
     else{
      this.FocusPrevItem(indexPath);
      return true;
     }
    }
   }
  }
  return false;
 },
 FocusNextItem: function(indexPath){
  var newIndexPath = this.GetNextSiblingIndexPath(indexPath);
  if(newIndexPath == null)
   newIndexPath = this.GetFirstSiblingIndexPath(indexPath);
  if(indexPath != newIndexPath)
   this.FocusItemByIndexPath(newIndexPath);
 },
 FocusPrevItem: function(indexPath){
  var newIndexPath = this.GetPrevSiblingIndexPath(indexPath);
  if(newIndexPath == null)
   newIndexPath = this.GetLastSiblingIndexPath(indexPath);
  if(indexPath != newIndexPath)
   this.FocusItemByIndexPath(newIndexPath);
 },
 TryFocusItem: function(itemIndex){
  var item = this.GetItem(itemIndex);
  if(item.GetVisible()) {
   this.FocusItemByIndexPath(item.GetIndexPath());
   return true;
  }
  return false;
 },
 Focus: function(){
  if(this.rootItem != null) { 
   for(var i = 0; i < this.GetItemCount(); i++) {
    if(this.TryFocusItem(i))
     return true;
   }
  }
  else
   this.FocusNextItem("-1");
 },
 FocusLastItem: function(){
  if(this.rootItem != null) { 
   for(var i = this.GetItemCount() - 1; i >= 0; i--) {
    if(this.TryFocusItem(i))
     return true;
   }
  }
  else
   this.FocusPrevItem(this.GetItemCount() - 1);
 },
 OnCallback: function(result){
  _aspxInitializeScripts(); 
  this.InitializeScrollableMenus();
  for(var indexPath in result){
   var menuElement = this.GetMenuElement(indexPath);
   if(menuElement) {
    if(aspxGetMenuCollection().IsSubMenuVisible(menuElement.id)) {
     this.ShowPopupSubMenuAfterCallback(menuElement, result[indexPath]);
    } else {
     this.SetSubMenuInnerHtml(menuElement, result[indexPath]);
    }
   }
  }
  this.InitializeInternal(false);
  if(!this.showSubMenus){
   this.showSubMenus = true;
   if(this.savedCallbackHoverItem != null && this.savedCallbackHoverElement != null)
    this.OnAfterItemOver(this.savedCallbackHoverItem, this.savedCallbackHoverElement);
   this.savedCallbackHoverItem = null;
   this.savedCallbackHoverElement = null;
  }
 },
 SetSubMenuInnerHtml: function(menuElement, html) {
  _aspxSetInnerHtml(this.GetMenuMainCell(menuElement), html);
  if(this.liteRender) {
   ASPxClientMenuLiteRenderHelper.InlineInitializeSubMenuMenuElement(this, menuElement);
   ASPxClientMenuLiteRenderHelper.PrepareSubMenuSize(this, menuElement);
  }
 },
 ShowPopupSubMenuAfterCallback: function(element, callbackResult) {
  var indexPath = this.GetIndexPathById(element.id, true);
  var currentX = _aspxPxToInt(element.style.left);
  var currentY = _aspxPxToInt(element.style.top);
  var showedToTheTop = this.ShowedToTheTop(element, indexPath);
  var showedToTheLeft = this.ShowedToTheLeft(element, indexPath);
  _aspxSetStylePosition(element, __aspxInvalidPosition, __aspxInvalidPosition);
  this.SetSubMenuInnerHtml(element, callbackResult);
  var vertPos = this.GetClientSubMenuPos(element, indexPath, __aspxInvalidPosition, false);
  var clientY = vertPos.position;
  var toTheTop = vertPos.isInverted;
  if(!this.IsVertical(indexPath) && showedToTheTop != toTheTop) {
   clientY = currentY;
   toTheTop = showedToTheTop;
  }
  var scrollHelper = this.scrollHelpers[indexPath];
  if(scrollHelper) {
   var yClientCorrection = this.GetScrollSubMenuYCorrection(element, scrollHelper, clientY);
   if(yClientCorrection > 0)
    clientY += yClientCorrection;
  }
  _aspxSetStylePosition(element, currentX, clientY);
  this.DoShowPopupMenuIFrame(element, currentX, clientY, __aspxInvalidDimension, __aspxInvalidDimension, indexPath);
  this.DoShowPopupMenuBorderCorrector(element, currentX, clientY, indexPath, showedToTheLeft, toTheTop);
  aspxGetControlCollection().AdjustControls(element);
 },
 ShowedToTheTop: function(element, indexPath) {
  var currentY = _aspxPxToInt(element.style.top);
  var parentBottomY = this.GetSubMenuYPosition(indexPath);
  return currentY < parentBottomY;
 },
 ShowedToTheLeft: function(element, indexPath) {
  var currentX = _aspxPxToInt(element.style.left);
  var parentX = this.GetSubMenuXPosition(indexPath);
  return currentX < parentX;
 },
 CreateItems: function(itemsProperties){
  var itemType = this.GetClientItemType();
  this.rootItem = new itemType(this, null, 0, "");
  this.rootItem.CreateItems(itemsProperties);
 },
 GetClientItemType: function(){
  return ASPxClientMenuItem;
 },
 GetItemByIndexPath: function(indexPath){
  var item = this.rootItem;
  if(indexPath != "" && item != null){
   var indexes = this.GetItemIndexes(indexPath);
   for(var i = 0; i < indexes.length; i ++)
    item = item.GetItem(indexes[i]);
  }
  return item;
 },
 SetItemChecked: function(indexPath, checked){
  var inputElement = this.GetCheckedItemsInputElement();
  if(inputElement != null){
   var itemsGroup = this.GetItemsGroup(indexPath);
   if(itemsGroup != null){
    if(!checked && this.IsCheckedItem(indexPath)){
     _aspxArrayRemove(this.checkedItems, indexPath);
     this.DeselectItem(indexPath);
    }
    else if(checked && !this.IsCheckedItem(indexPath)){
     if(itemsGroup.length > 1){
      for(var i = 0; i < itemsGroup.length; i ++){
       if(itemsGroup[i] == indexPath) continue;
       if(this.IsCheckedItem(itemsGroup[i])){
        _aspxArrayRemove(this.checkedItems, itemsGroup[i]);
        this.DeselectItem(itemsGroup[i]);
       }
      }
     }
     this.SelectItem(indexPath);
     this.checkedItems.push(indexPath);
    }
    this.UpdateCheckedInputElement(inputElement);
   }
  }
 },
 ChangeItemEnabledAttributes: function(indexPath, enabled){
  if(this.liteRender)
   ASPxClientMenuLiteRenderHelper.ChangeItemEnabledAttributes(this.GetItemElement(indexPath), enabled);
  else {
   var textOrImageCell = this.GetItemTextOrImageCell(indexPath);
   if(!textOrImageCell)
    return;
   textOrImageCell.enabled = enabled;
   var method = _aspxChangeAttributesMethod(enabled);
   var styleMethod = _aspxChangeStyleAttributesMethod(enabled);
   var itemElement = this.IsVertical(indexPath) ? this.GetItemElement(indexPath) : null;
   if(itemElement)
    method(itemElement, "onclick");
   var templateElement = this.GetItemTemplateCell(indexPath);
   if(templateElement)
    method(templateElement, "onclick");
   var imageElement = this.GetItemImageCell(indexPath);
   if(imageElement){
    method(imageElement, "onclick");
    styleMethod(imageElement, "cursor");
       var link = this.GetInternalHyperlinkElement(imageElement, 0);
       if(link){
        method(link, "onclick");
        method(link, "href");
        styleMethod(link, "cursor");
    }
   }
   var textElement = this.GetItemTextCell(indexPath);
   if(textElement){
    method(textElement, "onclick");
    styleMethod(textElement, "cursor");
       var link = this.GetInternalHyperlinkElement(textElement, 0);
       if(link){
        method(link, "onclick");
        method(link, "href");
        styleMethod(link, "cursor");
     link = this.GetInternalHyperlinkElement(textElement, 1);
     if(link){
      method(link, "onclick");
      method(link, "href");
      styleMethod(link, "cursor");
     }
    }
   }
   var popOutImageElement = this.GetItemPopOutImageCell(indexPath);
   if(popOutImageElement){
    method(popOutImageElement, "onclick");
    styleMethod(popOutImageElement, "cursor");
   }
   var indentElement = this.GetItemIndentCell(indexPath);
   if(indentElement){
    method(indentElement, "onclick");
    styleMethod(indentElement, "cursor");
   }
  }
 },
 IsItemEnabled: function(indexPath){
  var item = this.GetItemByIndexPath(indexPath);
  return (item != null) ? item.GetEnabled() : true;
 },
 SetItemEnabled: function(indexPath, enabled, initialization){
  if(indexPath == "" || !this.GetItemByIndexPath(indexPath).enabled) return;
  if(!enabled){
   if(this.GetSelectedItemIndexPath() == indexPath)
    this.DeselectItem(indexPath);
  }
  if(!initialization || !enabled)
   this.ChangeItemEnabledStateItems(indexPath, enabled);
  this.ChangeItemEnabledAttributes(indexPath, enabled);
  if(enabled){
   if(this.GetSelectedItemIndexPath() == indexPath)
    this.SelectItem(indexPath);
  }
 },
 ChangeItemEnabledStateItems: function(indexPath, enabled){
  var element = this.liteRender
   ? this.GetItemElement(indexPath)
   : this.GetItemTextOrImageCell(indexPath);
  if(element)
   aspxGetStateController().SetElementEnabled(element, enabled);
 },
 GetItemImageUrl: function(indexPath){
  var image = this.GetItemImage(indexPath);
  if(image)
   return image.src;
  return "";
 },
 SetItemImageUrl: function(indexPath, url){
  var image = this.GetItemImage(indexPath);
  if(image)
   image.src = url;
 },
 GetItemImage: function(indexPath) {
  var element = this.GetItemImageCell(indexPath);
  if(element != null){
   var img = _aspxGetChildByTagName(element, "IMG", 0);
   if(img != null)
    return img;
  }
  element = this.GetItemTextCell(indexPath);
  if(element != null){
   var img = _aspxGetChildByTagName(element, "IMG", 0);
   if(img != null)
    return img;
  }
 },
 GetItemNavigateUrl: function(indexPath){
  var element = this.GetItemTextCell(indexPath);
  if(element != null){
   var link = _aspxGetChildByTagName(element, "A", 0);
   if(link != null)
    return link.href;
  }
  element = this.GetItemImageCell(indexPath);
  if(element != null){
   var link = _aspxGetChildByTagName(element, "A", 0);
   if(link != null)
    return link.href;
  }
  return "";
 },
 SetItemNavigateUrl: function(indexPath, url){
  var element = this.GetItemTextCell(indexPath);
  if(element != null){
   var link = _aspxGetChildByTagName(element, "A", 0);
   if(link != null)
    link.href = url;
   link = _aspxGetChildByTagName(element, "A", 1);
   if(link != null)
    link.href = url;
  }
  element = this.GetItemImageCell(indexPath);
  if(element != null){
   var link = _aspxGetChildByTagName(element, "A", 0);
   if(link != null)
    link.href = url;
  }
 },
 FindTextNode: function(indexPath) {
  var element = this.GetItemTextCell(indexPath);
  if(element) {
   if(this.liteRender) {
    var link = _aspxGetChildByTagName(element, "A", 0); 
    if(link)
     return _aspxGetChildTextNode(link, 0);
    for(var i = 0; i < element.childNodes.length; i++) { 
     var child = element.childNodes[i];
     if(child.nodeValue && (child.nodeValue.replace(/(^\s+)|(\s+$)/g, "") != ""))
      return child;
    }
   }
   return _aspxGetChildTextNode(element, 0);
  }
  return null;
 },
 GetItemText: function(indexPath){
  var textNode = this.FindTextNode(indexPath);
  return textNode
   ? textNode.nodeValue
   : "";
 },
 SetItemText: function(indexPath, text){
  var textNode = this.FindTextNode(indexPath);
  if(textNode)
   textNode.nodeValue = text;
 },
 SetItemVisible: function(indexPath, visible, initialization){
  if(indexPath == "" || !this.GetItemByIndexPath(indexPath).visible) return;
  if(visible && initialization) return;
  var element = null;
  if(this.liteRender || this.IsVertical(indexPath)){
   element = this.GetItemElement(indexPath);
   if(element != null)
    _aspxSetElementDisplay(element, visible);
  }
  else{
   element = this.GetItemTextTemplateContainer(indexPath);
   if(element != null)
    _aspxSetElementDisplay(element, visible);
   element = this.GetItemImageCell(indexPath);
   if(element != null)
    _aspxSetElementDisplay(element, visible);
   element = this.GetItemTextCell(indexPath);
   if(element != null)
    _aspxSetElementDisplay(element, visible);
   element = this.GetItemPopOutImageCell(indexPath);
   if(element != null)
    _aspxSetElementDisplay(element, visible);
  }
  this.SetIndentsVisiblility(indexPath);
  this.SetSeparatorsVisiblility(indexPath);
 },
 SetIndentsVisiblility: function(indexPath){
  var parent = this.GetItemByIndexPath(indexPath).parent;
  for(var i = 0; i < parent.GetItemCount(); i++){
   var item = parent.GetItem(i);
   var separatorVisible = item.GetVisible() && this.HasNextVisibleItems(parent, i);
   var element = this.GetItemIndentElement(item.GetIndexPath());
   if(element != null) _aspxSetElementDisplay(element, separatorVisible);
  }
 },
 SetSeparatorsVisiblility: function(indexPath){
  var parent = this.GetItemByIndexPath(indexPath).parent;
  for(var i = 0; i < parent.GetItemCount(); i++){
   var item = parent.GetItem(i);
   var separatorVisible = item.GetVisible() && this.HasPrevVisibleItems(parent, i);
   var element = this.GetItemSeparatorElement(item.GetIndexPath());
   if(element != null) _aspxSetElementDisplay(element, separatorVisible);
   element = this.GetItemSeparatorIndentElement(item.GetIndexPath());
   if(element != null) _aspxSetElementDisplay(element, separatorVisible);
  }
 },
 HasNextVisibleItems: function(parent, index){
  for(var i = index + 1; i < parent.GetItemCount(); i++){
   if(parent.GetItem(i).GetVisible())
    return true;
  }
  return false;
 },
 HasPrevVisibleItems: function(parent, index){
  for(var i = index - 1; i >= 0; i--){
   if(parent.GetItem(i).GetVisible())
    return true;
  }
  return false;
 },
 GetItemIndentElement: function(indexPath){
  return _aspxGetElementById(this.GetItemIndentElementId(indexPath));
 },
 GetItemSeparatorElement: function(indexPath){
  if(this.liteRender)
   return _aspxGetElementById(this.GetItemSeparatorElementId(indexPath));
  else {
   var separator1 = _aspxGetElementById(this.GetItemSeparatorElementId(indexPath));
   var separator2 = _aspxGetElementById(this.GetItemSeparatorElementId(indexPath) + "F");
   if(separator1 == null)
    return separator2;
   else if(separator2 == null)
    return separator1;
   else {
    if(separator1.style.display != "")
     return separator1;
    else if(separator2.style.display != "")
     return separator2;
    else {
     if(_aspxGetCurrentStyle(separator1).display == "none")
      return separator2;
     else
      return separator1;
    }
   }
  }
 },
 GetItemSeparatorIndentElement: function(indexPath){
  return _aspxGetElementById(this.name + __aspxMIIdSuffix + indexPath + "_ISI");
 },
 RaiseItemClick: function(indexPath, htmlEvent){
  var processOnServer = this.autoPostBack || this.IsServerEventAssigned("ItemClick");
  if(!this.ItemClick.IsEmpty()){
   var item = this.GetItemByIndexPath(indexPath);
   var htmlElement = this.GetItemTextOrImageCell(indexPath);
   var args = new ASPxClientMenuItemClickEventArgs(processOnServer, item, htmlElement, htmlEvent);
   this.ItemClick.FireEvent(this, args);
   processOnServer = args.processOnServer;
  }
  return processOnServer;
 }, 
 RaiseItemMouseOver: function(indexPath){
  if(!this.ItemMouseOver.IsEmpty()){
   var item = this.GetItemByIndexPath(indexPath);
   var htmlElement = this.GetItemTextOrImageCell(indexPath);
   var args = new ASPxClientMenuItemMouseEventArgs(item, htmlElement);
   this.ItemMouseOver.FireEvent(this, args);
  }
 },
 RaiseItemMouseOut: function(indexPath){
  if(!this.ItemMouseOut.IsEmpty()){
   var item = this.GetItemByIndexPath(indexPath);
   var htmlElement = this.GetItemTextOrImageCell(indexPath);
   var args = new ASPxClientMenuItemMouseEventArgs(item, htmlElement);
   this.ItemMouseOut.FireEvent(this, args);
  }
 },
 RaisePopUp: function(indexPath){
  var item = this.GetItemByIndexPath(indexPath);
  if(!this.PopUp.IsEmpty()){
   var args = new ASPxClientMenuItemEventArgs(item);
   this.PopUp.FireEvent(this, args);
  }
 },
 RaiseCloseUp: function(indexPath){
  var item = this.GetItemByIndexPath(indexPath);
  if(!this.CloseUp.IsEmpty()){
   var args = new ASPxClientMenuItemEventArgs(item);
   this.CloseUp.FireEvent(this, args);
  }
 },
 SetEnabled: function(enabled) {
  for(var i = this.GetItemCount() - 1; i >= 0; i--) {
   var item = this.GetItem(i);
   item.SetEnabled(enabled);
  }
 },
 GetItemCount: function(){
  return (this.rootItem != null) ? this.rootItem.GetItemCount() : 0;
 },
 GetItem: function(index){
  return (this.rootItem != null) ? this.rootItem.GetItem(index) : null;
 },
 GetItemByName: function(name){
  return (this.rootItem != null) ? this.rootItem.GetItemByName(name) : null;
 },
 GetSelectedItem: function(){
  var indexPath = this.GetSelectedItemIndexPath();
  if(indexPath != "")
   return this.GetItemByIndexPath(indexPath);
  return null;
 },
 SetSelectedItem: function(item){
  var indexPath = (item != null) ? item.GetIndexPath() : "";
  this.SetSelectedItemInternal(indexPath, false);
 },
 GetRootItem: function(){
  return this.rootItem;
 }
});
function GetMenuByScrollButtonId(id){
 var menuName = aspxGetMenuCollection().GetMenuNameBySuffixes(id, [__aspxSBIdSuffix]);
 return aspxGetMenuCollection().Get(menuName);
}
aspxAddAfterSetPressedState(function(source, args) {
 var menu = GetMenuByScrollButtonId(args.element.id);
 if(menu) menu.StartScrolling(args.element.id, 1, 4);
});
aspxAddAfterClearPressedState(function(source, args) {
 var menu = GetMenuByScrollButtonId(args.element.id);
 if(menu) menu.StopScrolling(args.element.id);
});
aspxAddAfterSetHoverState(function(source, args) {
 var menu = GetMenuByScrollButtonId(args.element.id);
 if(menu) menu.StartScrolling(args.element.id, 15, 1);
});
aspxAddAfterClearHoverState(function(source, args) {
 var menu = GetMenuByScrollButtonId(args.element.id);
 if(menu) menu.StopScrolling(args.element.id);
});
ASPxClientMenuBase.GetMenuCollection = function(){
 return aspxGetMenuCollection();
}
ASPxClientMenuCollection = _aspxCreateClass(ASPxClientControlCollection, {
 constructor: function(){
  this.constructor.prototype.constructor.call(this);
  this.appearTimerID = -1;
  this.disappearTimerID = -1;
  this.currentShowingPopupMenuName = null;
  this.visibleSubMenusMenuName = "";
  this.visibleSubMenuIds = [ ];
  this.overXPos = -1;
  this.overYPos = -1;
 },
 RegisterVisiblePopupMenu: function(name, id){
  this.visibleSubMenuIds.push(id);
  this.visibleSubMenusMenuName = name;
 },
 UnregisterVisiblePopupMenu: function(name, id){
  _aspxArrayRemove(this.visibleSubMenuIds, id);
  if(this.visibleSubMenuIds.length == 0)
   this.visibleSubMenusMenuName = "";
 },
 IsSubMenuVisible: function(subMenuId) {
  for(var i = 0; i < this.visibleSubMenuIds.length; i++) {
   if(this.visibleSubMenuIds[i] == subMenuId)
    return true;
  }
  return false;
 },
 GetMenu: function(id){
  return this.Get(this.GetMenuName(id));
 },
 GetMenuName: function(id){
  return this.GetMenuNameBySuffixes(id, [__aspxMMIdSuffix, __aspxMIIdSuffix]);
 },
 GetMenuNameBySuffixes: function(id, idSuffixes){
  for(var i = 0; i < idSuffixes.length; i++){
   var pos = id.lastIndexOf(idSuffixes[i]);
   if(pos > -1) 
    return id.substring(0, pos);
  }
  return id;
 },
 ClearCurrentShowingPopupMenuName: function() {
  this.SetCurrentShowingPopupMenuName(null);
 },
 SetCurrentShowingPopupMenuName: function(value) {
  this.currentShowingPopupMenuName = value;
 },
 NowPopupMenuIsShowing: function() {
  return this.currentShowingPopupMenuName != null;
 },
 GetMenuLevel: function(indexPath){
  if(indexPath == "")
   return 0;
  else{
   var indexes = this.GetItemIndexes(indexPath);
   return indexes.length;
  }
 },
 GetMenuLevelById: function(id){ 
  var indexPath = this.GetIndexPathById(id, __aspxMMIdSuffix);
  return this.GetMenuLevel(indexPath);
 },
 GetIndexPathById: function(id, idSuffix){
  var pos = id.lastIndexOf(idSuffix);
  if(pos > -1){
   id = id.substring(pos + idSuffix.length);
   pos = id.lastIndexOf("_");
   if(pos > -1) 
    return id.substring(0, pos);
  }
  return "";
 },
 GetItemIndexPath: function(indexes){
  var indexPath = "";
  for(var i = 0; i < indexes.length; i ++){
   indexPath += indexes[i];
   if(i < indexes.length - 1)
    indexPath += __aspxItemIndexSeparator;
  }
  return indexPath;
 },
 GetItemIndexes: function(indexPath){
  var indexes = indexPath.split(__aspxItemIndexSeparator);
  for(var i = 0; i < indexes.length; i ++)
   indexes[i] = parseInt(indexes[i]);
  return indexes;
 },
 ClearAppearTimer: function(){
  this.appearTimerID = _aspxClearTimer(this.appearTimerID);
 },
 ClearDisappearTimer: function(){
  this.disappearTimerID = _aspxClearTimer(this.disappearTimerID);
 },
 IsAppearTimerActive: function(){
  return this.appearTimerID > -1;
 },
 IsDisappearTimerActive: function(){
  return this.disappearTimerID > -1;
 },
 SetAppearTimer: function(name, indexPath, timeout){
  this.appearTimerID = _aspxSetTimeout("aspxMIMOverTimer(\"" + name + "\", \"" + indexPath + "\")", timeout);
 },
 SetDisappearTimer: function(name, timeout){
  this.disappearTimerID = _aspxSetTimeout("aspxMIMOutTimer(\"" + name + "\")", timeout);
 },
 GetMouseDownMenuLevel: function(evt){
  var srcElement = _aspxGetEventSource(evt);
  if(this.visibleSubMenusMenuName != ""){
   var element = _aspxGetParentById(srcElement, this.visibleSubMenusMenuName);
   if(element != null) return 1;
  }
  for(var i = 0; i < this.visibleSubMenuIds.length; i ++){
   var element = _aspxGetParentById(srcElement, this.visibleSubMenuIds[i]);
   if(element != null)
    return this.GetMenuLevelById(this.visibleSubMenuIds[i]) + 1;
  }
  return -1;
 },
 CheckFocusedElement: function(){
  try {
   if(document.activeElement != null) {
    for(var i = 0; i < this.visibleSubMenuIds.length; i ++) {
     var menuElement = _aspxGetElementById(this.visibleSubMenuIds[i]);
     if(menuElement != null && _aspxGetIsParent(menuElement, document.activeElement)) {
      var tagName = document.activeElement.tagName;
      if (!__aspxIE || tagName == "INPUT" || tagName == "TEXTAREA" || tagName == "SELECT")
       return true;    
     }
    }
   }
  } catch(e) {
  }
  return false;
 },
 DoHidePopupMenus: function(evt, level, name, leavePopups, exceptId){
  for(var i = this.visibleSubMenuIds.length - 1; i >=0 ; i --){
   var menu = this.GetMenu(this.visibleSubMenuIds[i]);
   if(menu != null){
    var menuLevel = this.GetMenuLevelById(this.visibleSubMenuIds[i]);
    if((!leavePopups || menuLevel > 0) && exceptId != this.visibleSubMenuIds[i]){
     if(menuLevel > level || (menu.name != name && name != "")){
      var element = _aspxGetElementById(this.visibleSubMenuIds[i]);
      if(element != null)
       menu.DoHidePopupMenu(evt, element);
     }
    }
   }
  }
 },
 DoShowAtCurrentPos: function(name, indexPath){
  var pc = this.Get(name);
  var element = pc.GetMainElement();
  if(pc != null && !_aspxGetElementDisplay(element))
   pc.DoShowPopupMenu(element, this.overXPos, this.overYPos, indexPath);
 },
 SaveCurrentMouseOverPos: function(evt, popupElement){
  if (!this.NowPopupMenuIsShowing()) return;
  var currentShowingPopupMenu = this.Get(this.currentShowingPopupMenuName);
  if(currentShowingPopupMenu.popupElement == popupElement) 
   if(!currentShowingPopupMenu.IsMenuVisible()) {
    this.overXPos = _aspxGetEventX(evt);
    this.overYPos = _aspxGetEventY(evt);
   }
 },
 OnMouseDown: function(evt){
  var menuLevel = this.GetMouseDownMenuLevel(evt);
  this.DoHidePopupMenus(evt, menuLevel, "", false, "");
 },
 HideAll: function(){
  this.DoHidePopupMenus(null, -1, "", false, "");
 },
 IsAnyMenuVisible: function() {
  return this.visibleSubMenuIds.length != 0;
 }
});
var __aspxMCollection = null;
function aspxGetMenuCollection(){
 if(__aspxMCollection == null)
  __aspxMCollection = new ASPxClientMenuCollection();
 return __aspxMCollection;
}
ASPxClientMenuItem = _aspxCreateClass(null, {
 constructor: function(menu, parent, index, name){
  this.menu = menu;
  this.parent = parent;
  this.index = index;
  this.name = name;
  this.enabled = true;
  this.clientEnabled = true;
  this.visible = true;
  this.clientVisible = true;
  this.items = []; 
  this.indexPath = null; 
 },
 CreateItems: function(itemsProperties){
  var itemType = this.menu.GetClientItemType();
  for(var i = 0; i < itemsProperties.length; i ++){
   var itemName = itemsProperties[i][0] || "";
   var item = new itemType(this.menu, this, i, itemName);
   if(_aspxIsExists(itemsProperties[i][1]))
    item.enabled = itemsProperties[i][1];
   if(_aspxIsExists(itemsProperties[i][2]))    
    item.clientEnabled = itemsProperties[i][2];
   if(_aspxIsExists(itemsProperties[i][3]))
    item.visible = itemsProperties[i][3];
   if(_aspxIsExists(itemsProperties[i][4]))
    item.clientVisible = itemsProperties[i][4];
   this.items.push(item);
   item.CreateItems(itemsProperties[i][5]);
  }
 },
 GetIndexPath: function(){
  if(this.indexPath == null){
   this.indexPath = "";
   var item = this;
   while(item.parent != null){
    this.indexPath = (this.indexPath != "") ? item.index.toString() + __aspxItemIndexSeparator + this.indexPath : item.index.toString();
    item = item.parent;
   }
  }
  return this.indexPath;
 },
 GetItemCount: function(){
  return this.items.length;
 },
 GetItem: function(index){
  return (0 <= index && index < this.items.length) ? this.items[index] : null;
 },
 GetItemByName: function(name){
  for(var i = 0; i < this.items.length; i ++)
   if(this.items[i].name == name) return this.items[i];
  for(var i = 0; i < this.items.length; i ++){
   var item = this.items[i].GetItemByName(name);
   if(item != null) return item;
  }
  return null;
 },
 GetChecked: function(){
  var indexPath = this.GetIndexPath();
  return this.menu.IsCheckedItem(indexPath);
 },
 SetChecked: function(value){
  var indexPath = this.GetIndexPath();
  this.menu.SetItemChecked(indexPath, value);
 },
 GetEnabled: function(){
  return this.enabled && this.clientEnabled;
 },
 SetEnabled: function(value){
  if (this.clientEnabled != value) {
   this.clientEnabled = value;
   this.menu.SetItemEnabled(this.GetIndexPath(), value, false);
  }
 },
 GetImageUrl: function(){
  var indexPath = this.GetIndexPath();
  return this.menu.GetItemImageUrl(indexPath);
 },
 SetImageUrl: function(value){
  var indexPath = this.GetIndexPath();
  this.menu.SetItemImageUrl(indexPath, value);
 },
 GetNavigateUrl: function(){
  var indexPath = this.GetIndexPath();
  return this.menu.GetItemNavigateUrl(indexPath);
 },
 SetNavigateUrl: function(value){
  var indexPath = this.GetIndexPath();
  this.menu.SetItemNavigateUrl(indexPath, value);
 },
 GetText: function(){
  var indexPath = this.GetIndexPath();
  return this.menu.GetItemText(indexPath);
 },
 SetText: function(value){
  var indexPath = this.GetIndexPath();
  this.menu.SetItemText(indexPath, value);
 },
 GetVisible: function(){
  return this.visible && this.clientVisible;
 },
 SetVisible: function(value){
  if (this.clientVisible != value) {
   this.clientVisible = value;
   this.menu.SetItemVisible(this.GetIndexPath(), value, false);
  }
 },
 InitializeEnabledAndVisible: function(recursive){
  this.menu.SetItemEnabled(this.GetIndexPath(), this.clientEnabled, true);
  this.menu.SetItemVisible(this.GetIndexPath(), this.clientVisible, true);
  if(recursive) {
   for(var i = 0; i < this.items.length; i++)
    this.items[i].InitializeEnabledAndVisible(recursive);
  }
 }
});
ASPxClientMenu = _aspxCreateClass(ASPxClientMenuBase, {
 constructor: function(name){
  this.constructor.prototype.constructor.call(this, name);
  this.isVertical = false;
 },
 InlineInitialize: function() {
  ASPxClientMenuBase.prototype.InlineInitialize.call(this);
  if(this.liteRender)
   this.SetLightweightMenuHeightInIE7IfDisplayed();
 },
 IsVertical: function(indexPath){
  return this.isVertical || (indexPath.indexOf(__aspxItemIndexSeparator) > -1);
 },
 AdjustControlCore: function() {
  if(this.liteRender) {
   ASPxClientMenuLiteRenderHelper.PrepareSpacingAndSeparators(this, this.GetMainElement());
   this.SetLightweightMenuHeightInIE7IfDisplayed();
  }
  else
   this.CalculateClassicMenuHeight();
 },
 CalculateClassicMenuHeight: function() {
  if(!this.isVertical) {
   var mainCell = _aspxGetChildByTagName(this.GetMainElement(), "TD", 0);
   var table = mainCell.childNodes[0];
   _aspxSetOffsetHeight(table, _aspxGetClearClientHeight(mainCell));
  }
 },
 SetLightweightMenuHeightInIE7IfDisplayed: function() { 
  if(!__aspxIE || __aspxBrowserMajorVersion != 7)
   return;
  if(this.lightweightMenuHeightIE7Set || !this.IsDisplayed()) 
   return;
  var mainElement = this.GetMainElement();
  var commonContainer = mainElement.parentNode;
  if(!this.isPopupMenu && __aspxIE && __aspxBrowserMajorVersion == 7)
   commonContainer = commonContainer.parentNode;
  var _this = this;
  window.setTimeout(function() {
   if(mainElement.offsetHeight != 0) 
    commonContainer.style.height = mainElement.offsetHeight + "px";
   else
    _this.lightweightMenuHeightIE7Set = false;
  }, 0);
  this.lightweightMenuHeightIE7Set = true;
 }
});
ASPxClientMenu.Cast = ASPxClientControl.Cast;
ASPxClientMenuItemEventArgs = _aspxCreateClass(ASPxClientEventArgs, {
 constructor: function(item) {
  this.constructor.prototype.constructor.call(this);
  this.item = item;
 }
});
ASPxClientMenuItemMouseEventArgs = _aspxCreateClass(ASPxClientMenuItemEventArgs, {
 constructor: function(item, htmlElement) {
  this.constructor.prototype.constructor.call(this, item);
  this.htmlElement = htmlElement;
 }
});
ASPxClientMenuItemClickEventArgs = _aspxCreateClass(ASPxClientProcessingModeEventArgs, {
 constructor: function(processOnServer, item, htmlElement, htmlEvent) {
  this.constructor.prototype.constructor.call(this, processOnServer);
  this.item = item;
  this.htmlElement = htmlElement;
  this.htmlEvent = htmlEvent;  
 }
});
function aspxMIClick(evt, name, indexPath){
 var menu = aspxGetMenuCollection().Get(name);
 if(menu != null) menu.OnItemClick(indexPath, evt);
 if(!__aspxNetscapeFamily)
  evt.cancelBubble = true;
}
function aspxMIDDClick(evt, name, indexPath){
 var menu = aspxGetMenuCollection().Get(name);
 if(menu != null) menu.OnItemDropDownClick(indexPath, evt);
 if(!__aspxNetscapeFamily)
  evt.cancelBubble = true;
}
function aspxAMIMOver(source, args){
 var menu = aspxGetMenuCollection().GetMenu(args.item.name);
 if(menu != null) menu.OnAfterItemOver(args.item, args.element);
}
function aspxBMIMOver(source, args){
 var menu = aspxGetMenuCollection().GetMenu(args.item.name);
 if(menu != null) menu.OnBeforeItemOver(args.item, args.element);
}
function aspxMIMOverTimer(name, indexPath){
 var menu = aspxGetMenuCollection().Get(name);
 if(menu != null) menu.OnItemOverTimer(indexPath);
}
function aspxBIDisabled(source, args){
 var menu = aspxGetMenuCollection().GetMenu(args.item.name);
 if(menu != null) menu.OnBeforeItemDisabled(args.item, args.element);
}
function aspxFIKeyDown(source, args){
 var menu = aspxGetMenuCollection().GetMenu(args.item.name);
 if(menu != null) menu.OnFocusedItemKeyDown(args.htmlEvent, args.item, args.element);
}
function aspxAMIMOut(source, args){
 var menu = aspxGetMenuCollection().GetMenu(args.item.name);
 if(menu != null) menu.OnAfterItemOut(args.item, args.element, args.toElement);
}
function aspxMIMOutTimer(name){
 var menu = aspxGetMenuCollection().Get(name);
 if(menu != null) menu.OnItemOutTimer();
}
function aspxMContextMenu(evt){
 return _aspxCancelBubble(evt);
}
function aspxMSBOver(source, args) {
 var menu = GetMenuByScrollButtonId(args.element.id)
 if(menu != null) menu.ClearDisappearTimer();
}
function aspxMSBOut(source, args) {
 var menu = GetMenuByScrollButtonId(args.element.id)
 if(menu != null) menu.SetDisappearTimer();
}
_aspxAttachEventToDocument("mousedown", aspxMenuDocumentMouseDown);
function aspxMenuDocumentMouseDown(evt){
 return aspxGetMenuCollection().OnMouseDown(evt); 
}
function aspxMATimer(name, indexPath){
 var menu = aspxGetMenuCollection().Get(name);
 if(menu != null) menu.OnAnimationTimer(indexPath);
}
aspxAddAfterSetFocusedState(aspxAMIMOver);
aspxAddAfterClearFocusedState(aspxAMIMOut);
aspxAddAfterSetHoverState(aspxAMIMOver);
aspxAddAfterClearHoverState(aspxAMIMOut);
aspxAddBeforeSetFocusedState(aspxBMIMOver);
aspxAddBeforeSetHoverState(aspxBMIMOver);
aspxAddBeforeDisabled(aspxBIDisabled);
aspxAddFocusedItemKeyDown(aspxFIKeyDown);
aspxAddAfterSetHoverState(aspxMSBOver);
aspxAddAfterSetPressedState(aspxMSBOver);
aspxAddAfterClearHoverState(aspxMSBOut);

