/* DOM lib */

/* These should be consts, but IE doesn't like that */
var DOM_ELEMENT_NODE = 1;
var DOM_ATTRIBUTE_NODE = 2;
var DOM_TEXT_NODE = 3;
var DOM_CDATA_SECTION_NODE = 4;
var DOM_ENTITY_REFERENCE_NODE = 5;
var DOM_ENTITY_NODE = 6;
var DOM_PROCESSING_INSTRUCTION_NODE = 7;
var DOM_COMMENT_NODE = 8;
var DOM_DOCUMENT_NODE = 9;
var DOM_DOCUMENT_TYPE_NODE = 10;
var DOM_DOCUMENT_FRAGMENT_NODE = 11;
var DOM_NOTATION_NODE = 12;

/**
 * Attaches an event to a node
 * @param node Object node to attach event to
 * @param eventName String name of event (sans "on", eg. "click" not "onclick")
 * @param functionName Function pointer to function that will handle event
 * @return boolean true if event attached, false otherwise
 */
function nodeAttachEvent(node, eventName, functionName)
{
  if (node.addEventListener) {
    node.addEventListener(eventName, functionName, true);
    return true;
  } else if (node.attachEvent) {
    node.attachEvent("on" + eventName, functionName);
    return true;
  } else {
    return false;
  }
}

/**
 * Detaches an event from a node
 * @param node Object node to deattach event from
 * @param eventName String name of event (sans "on", eg. "click" not "onclick")
 * @param functionName Function pointer to function that is handling event
 * @return boolean true if event deattached, false otherwise
 */
function nodeDetachEvent(node, eventName, functionName)
{
  if (node.removeEventListener) {
    node.removeEventListener(eventName, functionName, true);
  } else if (node.detachEvent) {
    node.detachEvent("on" + eventName, functionName);
  } else {
    return false;
  }
}

/**
 * Get CSS classes applied to a node
 * @param object node node to get classes for
 * @return Array array containing a list of classes
 */
function nodeClasses(node)
{
  var classes = new Array();
  
  if (typeof(node) == "string") {
    node = document.getElementById(node);
  }
  
  if (node) {
    classes = String(node.className).split(" ");
  }

  return classes;
}

/**
 * Determines if a node has a specific CSS class applied
 * @param String className name of class
 * @return Boolean true if class is applied, false otherwise
 */
function nodeHasClass(node, className)
{
  var hasClass = false;
  
  if (typeof(node) == "string") {
    node = document.getElementById(node);
  }
  
  if (node) {
    var classes = nodeClasses(node);

    if (classes.inArray(className)) {
      hasClass = true;
    }
  }
  return hasClass;
}

/**
 * Applies a CSS class to a node (if it is not
 * already applied)
 * @param Object node node to apply class to
 * @param String className name of class to apply
 * @return Boolean true
 */
function nodeAddClass(node, className)
{
  if (!nodeHasClass(node, className)) {
    var classes = nodeClasses(node);
    classes.push(className);

    var newClass = classes.implode(" ");
    node.className = newClass;
  }
  
  return true;
}

/**
 * Removes a CSS class from a node
 * @param Object node node to remove class from
 * @param String className name of class to remove
 * @return Boolean true
 */
function nodeRemoveClass(node, className)
{
  if (nodeHasClass(node, className)) {
    var classes = nodeClasses(node);
    classes.remove(className);
    
    var newClass = classes.implode(" ");
    node.className = newClass;
  }
  
  return true;
}

/**
 * Gets first ancestor node by tag name
 * @param Object node node to get ancestor for
 * @param String tagName tag name of ancestor
 * @param String className optional class name that must be applied to ancestor
 * @return Object ancestor node that meets criteria or false if none
 */
function nodeGetAncestorByTagName(node, tagName, className)
{
  var ancestor = false;
  var parent = node.parentNode;
  
  while ((parent) && (!ancestor)) {
    if (parent.tagName == tagName) {
      if (className) {
        if (nodeHasClass(parent, "tree")) {
	  ancestor = parent;
	}
      } else {
        ancestor = parent;
      }
    }
  
    parent = parent.parentNode;
  }
  
  return ancestor;
}

/**
 * Get children of node by tag name
 * @param node Object node to get children from
 * @param tagName String tag name of children to obtain
 * @param depth Number how far to descend into node tree, empty or zero for all
 * @return Array array of child nodes meeting criteria
 */
function nodeChildrenByTagName(node, tagName, depth)
{
  var children = Array();
  
  if (node) {
  
    if (depth > 0) {
      var childNodes = node.childNodes;
    
      for (var n=0; n < childNodes.length; n++) {
        if (String(childNodes[n].tagName).toUpperCase() == String(tagName).toUpperCase()) {
          children.push(childNodes[n]);
        }
      }
    
    } else {
      children = node.getElementsByTagName(tagName);
    }
  }

  return children;
}

/**
 * Determines if a node has a particular attribute set
 * Internet explorer sometimes chokes using normal DOM methods
 * @param node Object node to check
 * @param attributeName String name of attribute to check for
 * @return Boolean true if node has attribute defined
 */
function nodeHasAttribute(node, attributeName)
{
  if (node.hasAttribute) {
    return node.hasAttribute(attributeName);
  } else if (node.attributes.length > 0) {
    var rc = false;
    for (var n=0; n < node.attributes.length; n++) {
      if (node.attributes[n].nodeName == attributeName) {
        if (node.attributes[n].nodeValue) {
          rc = true;
	}
      }
    }
    return rc;
  } else {
    return false;
  }
}
/* END DOM lib */
