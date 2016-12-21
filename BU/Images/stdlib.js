/* stdlib stuff */

/**
 * Trims whitespace from the left side of a string
 * @return String string with left side trimmed
 */
function strltrim() 
{
  return this.replace(/^\s+/,'');
}

/**
 * Trims whitespace from the right side of a string
 * @return String string with right side trimmed
 */
function strrtrim() 
{
  return this.replace(/\s+$/,'');
}

/**
 * Trims whitespace from beginning and end of string
 * @return String string with leading and trailing whitespace trimmed
 */
function strtrim() 
{
  return this.replace(/^\s+/,'').replace(/\s+$/,'');
}

/**
 * Checks to see if a value exists in a non-associative array
 * @return boolean true if value exists in array
 */
function arrinArray(value)
{
  var rc = false;
  
  for (var n=0; n < this.length; n++) {
    if (this[n] == value) {
      rc = true;
    }
  }
  
  return rc;
}

/**
 * Removes a single non-associative array item by value
 * @param value value to remove from array
 * @return 1 if an item was removed, false if no items removed
 */
function arrremove(value)
{
  var removed = -1;
  
  for (var n=0; n < this.length; n++) {
    if (this[n] == value) {
      removed = n;
    }    
  }
  
  if (removed > -1) {
    this.splice(removed, 1);
  } else {
    removed = false;
  }
  
  return removed;
}

/**
 * Implodes a non-associative array seperating each value
 * with the specified seperator
 * @param sep seperator to use between values
 * @return String string containing array values
 */
function arrimplode(sep)
{
  var values = new String(this.toString());
  return values.replace(/,/g,sep);
}

String.prototype.ltrim = strltrim;
String.prototype.rtrim = strrtrim;
String.prototype.trim = strtrim;
Array.prototype.inArray = arrinArray;
Array.prototype.remove = arrremove;
Array.prototype.implode = arrimplode;

/* END stdlib */
