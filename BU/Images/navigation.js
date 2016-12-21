// <![CDATA[

/* submenu.js (appropriately hide/show/highlight elements of an unordered list
 * used for navigation)
 * 
 * The "algorithm"
 *
 * 0.5. If we're in /dev/, set a base href tag, to /dev/
 * 
 * 1. Figure out which li/anchor corresponds to the page we're on by 
 *    pattern-matching the URL
 * 
 * 2. Expand the ul below that li, if it exists
 *
 * 3. Bounce up the tree, expanding ul's and setting .activelink on *anchors* 
 *    not on li's
 * 
 * 4. Have a beer (results in a beer on every page load)
 *
 */

/* whereAmI()
 * 
 * @param Object node of ul with anchors to search
 * @return Object page_anchor of anchor of the page you're on
 */
function whereAmI(ul){
	//Grab all of the anchor tags from the unordered list
	var all_the_anchors = nodeChildrenByTagName(ul, "a");
	var where_you_are = document.location.href;
	var return_anchor;
	for (var i=0; i<all_the_anchors.length; i++)
	{
		/* The 3 lines below remove '/formlogin' from the URL.
		 *
		 * Reason: if you are behind the formlogin portal, 
		 * '/formlogin' was automatically added to your URL 
		 * by formlogin.js. In order to keep the submenu 
		 * working properly, we must remove the '/formlogin' 
		 * from the temporary variable 'where_you_are'.
		 * - Chrys Bader (cbader@bu.edu)
		 */
		 
		var re = new RegExp ( '/formlogin', 'gi' );
		
		if( where_you_are.indexOf( "formlogin" ) >= 0 )
			where_you_are = where_you_are.replace( re, "" );
		/* end cbader */

		if (normalizeURL(where_you_are) == normalizeURL(all_the_anchors[i].href))
		{
			return_anchor = all_the_anchors[i];
		}

	}

	// if nothing has matched yet, let's try the path alone
	if (null == return_anchor) {
		for (var i=0; i<all_the_anchors.length; i++) {
			if (normalizeURL(where_you_are).indexOf(normalizeURL(all_the_anchors[i].href))>-1) {
				return_anchor = all_the_anchors[i];
			}
		}
	}

	/* If we haven't matched anything, try matching on the title 
	 * before returning false*/
	if (null == return_anchor) {
		//Try to match the page title against the text of the anchors
		var page_title = document.title;
		var link_text;
		for (var i=0; i<all_the_anchors.length; i++)
		{
			link_text = all_the_anchors[i].childNodes[0].nodeValue;
			if (page_title.indexOf(link_text)>-1) {
				return_anchor = all_the_anchors[i];
				return return_anchor;
			}				
		}
		//If we still haven't found an anchor
		if (null == return_anchor) {
			return false;
		}
	} 
	return return_anchor;
}



/* Don't choke if we don't have getElementById*/
if (!document.getElementById)
    document.getElementById = function() { return null; }

/* Initializes (appropriately hides) all of the ul's below the
 * second level ul.
 * @param id string the id of  
 * @return void
 */
function initializeNavTree(tree_id) {
	var nav_tree = document.getElementById(tree_id);
	//hide the nav_tree to prevent flash of unstyled content
	if (nav_tree) { //in case the page doesn't have a nav_tree
	nav_tree.style.display = 'none';
	if (nav_tree) {
		var anchor = whereAmI(nav_tree);
		if (anchor) {
			hideChildUls(nav_tree); 
			//show the menu one below this anchor (if it exists)
			expandChildNavTree(anchor);
			//show the entire menu above this anchor
			expandParentsNavTree(anchor, tree_id);
		} else {
			hideChildUls(nav_tree); 
			//alert('This page is not linked to in the sidenav.');
		}
	}
	//show the nav_tree
	nav_tree.style.display = 'block';
	}
	return;
}


//End menuExpandable

/**
 * Hides all child ul's from a starting ul, descending into
 * child nodes
 * @param Object el node to initialize
 * @return void
 */
function hideChildUls(el)
{
  try {
	var children = el.childNodes;
  }
  catch (er) {
	  return;
  }
  for (var n=0; n < children.length; n++) {
    var item = children[n];
    
    if (String(item.tagName).toUpperCase() == "LI") {

      var nodes = item.childNodes;
	  for (var t=0; t < nodes.length; t++) {
	    if (String(nodes[t].tagName).toUpperCase() == "UL") {
		  nodes[t].style.display = 'none';
		  hideChildUls(nodes[t]);
        }
      }// end for loop
    } 
  }
}

/* Starting from an anchor nested within a UL, displays the UL it's nested in,
 * then all of its parents', grandparents', great-grandparents' ULs
 * stopping only when it gets to a specific id
 * @param Object node ul
 * @param string id ID of node to stop at
 * @return void
 */
function expandParentsNavTree(a, id) {
	//show this ul and all of its parents
	var node = a;
	if (node != null)
	{
		while (node.id != id)
		{
			if (String(node.tagName).toUpperCase() == "LI")
			{
				var children = nodeChildrenByTagName(node, "A", 1);
				if (children[0]) {
					nodeAddClass(children[0], 'current');
				}
			}
			if (String(node.tagName).toUpperCase() == "UL")
			{
				node.style.display = 'block';
			}
			node = node.parentNode;
		}
	}
}

/* Starting from an anchor nested within a ul, displays its li,
 * then all of its parents, grandparents, great-grandparents, etc.
 * stopping only when it gets to a specific id
 * @param Object node ul
 * @param string id ID of node to stop at
 * @return void
 */
function expandChildNavTree(a) {
	var node = a;
	//get the LI that the anchor is nested in
	while (String(node.tagName).toUpperCase() != "LI")
	{
		node = node.parentNode;
	}
	
	//loop through the children of that li, display the ul if it's in there
	var node_children = node.childNodes;
	for (var n=0; n < node_children.length; n++)
	{
		var this_node = node_children.item(n);
		if (String(this_node.tagName).toUpperCase() == "UL" )
		{
			this_node.style.display = 'block';
		}
	}
}

/* chop index.html, index.php, page anchors, and weblogin cruft,
 *  from the end of URLs*/
function normalizeURL(url_string) {
	var file_names = Array('index.html','index.shtml', 'index.htm', 'index.php');
	for (var i=0; i<file_names.length; i++ ){
		if (url_string.toLowerCase().indexOf(file_names[i]) != -1) {
			url_string = url_string.toLowerCase().replace(file_names[i], '');
		}
	}

	//Split on # and disregard everything after the #
	//Gets rid of page anchors
	var url_arr = url_string.split('#');
	url_string = url_arr[0];
	
	//Get rid of weblogin_random=XXXXXX
	var wl_arr = url_string.split('weblogin_random');
	url_string = wl_arr[0];
	//If we need to add back GET variables after the weblogin_random
	if (wl_arr[1]) {
		var query_string = wl_arr[1].split('&');
		if (query_string[1]) {
			url_string = wl_arr[0] + query_string[1];
		}
	}
	
	//Remove trailing question mark
	if (url_string.charAt(url_string.length-1)=='?') {
		url_string = url_string.substring(0,url_string.length-1);
	}
	
	return url_string;
}


// ]]>