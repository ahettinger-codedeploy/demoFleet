/**
 * Checks/unchecks all tables
 *
 * @param   string   the form name
 * @param   boolean  whether to check or to uncheck the element
 *
 * @return  boolean  always true
 */
function setCheckboxes(the_form, the_field, do_check)
{
    var elts      = document.forms[the_form].elements[the_field];
    if( typeof(elts) == 'undefined' ) {
        return false;
    }
    var elts_cnt  = (typeof(elts.length) != 'undefined')
                  ? elts.length
                  : 0;
    if (elts_cnt) {
        for (var i = 0; i < elts_cnt; i++) {
            elts[i].checked = do_check;
        } // end for
    } else {
        elts.checked        = do_check;
    } // end if... else

    return true;
} // end of the 'setCheckboxes()' function

function anchorPop( anchor, width, height, name ) {
    return popup( anchor.href, width, height, name );
}

function popup( url, width, height, name ) {

        var mylink = url;
        var windowname = name == null ? 'Popup_Window' : name;
        var result = null;
        
        if (! window.focus) return true;
                var href;
        if (typeof(mylink) == "string")
                href = mylink;
        else
                href = mylink.href;
        var newWin = window.open(href, windowname, "width="+width+",height="+height+",scrollbars=yes,resize=yes");
        if (!newWin || !newWin.top) {
            alert('popup window blocked');
        }
        return false;

}

function getCookie(c_name)
{
if (document.cookie.length>0)
{ 
c_start=document.cookie.indexOf(c_name + "=")
if (c_start!=-1)
{ 
c_start=c_start + c_name.length+1 
c_end=document.cookie.indexOf(";",c_start)
if (c_end==-1) c_end=document.cookie.length
return unescape(document.cookie.substring(c_start,c_end))
} 
}
return null
}

function setCookie(c_name,value, path, expiredays)
{
var exdate=new Date()
exdate.setDate(expiredays)
document.cookie=c_name+ "=" +escape(value)+
((expiredays==null) ? "" : "; expires="+exdate) +
((path==null) ? "" : "; path="+path)
}

function in_array(needle, haystack) {
	var n = haystack.length;
	for (var i=0; i<n; i++) {
		if (haystack[i]==needle) {
			return true;
		}
	}
	return false;
}

// JavaScript Document

String.prototype.trim = function() {
	return this.replace(/^[\s\xA0]+|[\s\xA0]+$/g,"");
}
String.prototype.ltrim = function() {
	return this.replace(/^[\s\xA0]+/,"");
}
String.prototype.rtrim = function() {
	return this.replace(/[\s\xA0]+$/,"");
}
String.prototype.fileExt = function( include_dot ) {
	return fileExt( this, include_dot )
}

function trim(stringToTrim) {
	return stringToTrim.replace(/^[\s\xA0]+|[\s\xA0]+$/g,"");
}
function ltrim(stringToTrim) {
	return stringToTrim.replace(/^[\s\xA0]+/,"");
}
function rtrim(stringToTrim) {
	return stringToTrim.replace(/[\s\xA0]+$/,"");
}

function isInt(x) {
   var y=parseInt(x);
   if (isNaN(y)) return false;
   return x==y && x.toString()==y.toString();
}

function fileExt( str_path, include_dot ) {
    include_dot = typeof(include_dot) != 'undefined' ? include_dot : false; 
    
    var shift = include_dot ? 0 : 1;
    
    var dot = str_path.lastIndexOf(".")
    if( dot == -1 ) {
        return '';
    }
    return str_path.substr(dot + shift); 
}

function isNumeric(x) {
    if( x.trim() == "" ) {
        return false;
    }
// I use this function like this: if (isNumeric(myVar)) { }
// regular expression that validates a value is numeric
var RegExp = /^(-)?(\d*)(\.?)(\d*)$/; // Note: this WILL allow a number that ends in a decimal: -452.
// compare the argument to the RegEx
// the 'match' function returns 0 if the value didn't match
var result = x.match(RegExp);
return result;
}
