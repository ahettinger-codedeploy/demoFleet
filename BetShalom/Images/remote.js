/************************************************************************************

General remote functions

*************************************************************************************/

function getHttpObject() {
  var xmlhttp;
  /*@cc_on
  @if (@_jscript_version >= 5)
    try {
      xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
      try {
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
      } catch (E) {
        xmlhttp = false;
      }
    }
  @else
  xmlhttp = false;
  @end @*/
  if (!xmlhttp && typeof XMLHttpRequest != 'undefined') {
    try {
      xmlhttp = new XMLHttpRequest();
    } catch (e) {
      xmlhttp = false;
    }
  }
  return xmlhttp;
}

// We create the HTTP Object
var http = getHttpObject(); 

function sendHttpRequest(url, callback) {
	busy(true);
	
	http.open("GET", url, true);
	http.onreadystatechange = callback;
	
	// Force IE to not cache the document
	http.setRequestHeader('If-Modified-Since','Wed, 15 Nov 1995 04:58:08 GMT');
	
	// Send the request async
	http.send(null);
}
function postHttpRequest(url, data, callback) {
	busy(true);

	http.open("POST", url, true);
	http.onreadystatechange = callback;
	
	// Force IE to not cache the document
	http.setRequestHeader('If-Modified-Since','Wed, 15 Nov 1995 04:58:08 GMT');
	http.setRequestHeader('Content-Type','application/x-www-form-urlencoded');	
	
	// Send the request async
	http.send(data);
}
function haveHttpResponse() {
	return (http.readyState == 4);
}
function getHttpResponse() {
	notbusy();

    // Split the delimited response into an array
    var response = trim(http.responseText);
    
    if (response.indexOf("|") != -1)
    	return response.split("|");
    else
    	return response;
}

function ltrim(s){
	return s.replace( /^\s*/, "" )
}

function rtrim(s){
	return s.replace( /\s*$/, "" );
}

function trim(s){
	return rtrim(ltrim(s));
}

/************************************************************************************

Remote functions for manipulating user comments.  Handleded by the Comments
program.

*************************************************************************************/

var commentId = "";

function onAddComment(f) {
	if (f.mode.value == 'anonymous') {
		if (!hasValue(f.name,'TEXT') || !hasValue(f.email,'TEXT')) {
			alert('Please enter your name and email address.');
			return false;
		}
	}
	
	if (!hasValue(f.comment,'TEXT')) {
		alert('Please enter your comments.');
		return false;
	}

	var notify = getCheckboxList(f.notify);
	
	if (notify.length == 0)
		notify = 0;
		
    sendHttpRequest(kdSiteRelRoot + "Admin/Remote/index.cfm?section=UserComments&action=Submit" +
    				"&object_type=" + f.objecttype.value +
    				"&object_id=" + f.objectid.value +
    				"&notify=" + notify + 
    				"&comment=" + escape(f.comment.value) + 
    				"&name=" + escape(f.name.value) +
    				"&email=" + escape(f.email.value),  
    				onAddCommentResponse);
	
	// Clear comment form
	f.comment.value = '';
	f.name.value = '';
	f.email.value = '';
	
	return false;
}

function onAddCommentResponse() {
	if (haveHttpResponse()) {
    	// Split the delimited response into an array
    	var results = getHttpResponse();

		if (typeof(results) == "object") {
			if (results[0] == 1) {
				var id = results[1];
				var comments = results[2];
				var info = results[3];
				var notified = results[4];
				
				// Get the comments node
		    	var commentsNde = document.getElementById("comments");
		    	
				var commentboxNde = document.createElement('div');					
				commentboxNde.id = id;
				commentboxNde.className = "CommentBox New";

				var commentNde = document.createElement('div');
				commentNde.className = "Comment";
				commentNde.appendChild(document.createTextNode(comments));
				
				var infoNde = document.createElement('div');
				infoNde.className = "Info";
				infoNde.appendChild(document.createTextNode(info));
				
				commentboxNde.appendChild(commentNde);
				commentboxNde.appendChild(infoNde);
				
				// Add the new comment
				commentsNde.appendChild(commentboxNde);
				
				// If notified then show the subscribed box
				if (notified == 1) {
					// Get and show the unsubscribe box node
			    	document.getElementById("subscribedtocomments").style.display = "block";
				}
				
				// Hide the no comments found message just in case this is the first
		    	document.getElementById("nocommentsfound").style.display = "none";
			}
			else {
				alert(results[1]);
			}
		}
		else
			alert(results);
  	}
}		

function onDeleteComment(id) {
	commentId = id;
	
	if (confirm('Are you sure you want to delete this comment?')) {
		  sendHttpRequest(kdSiteRelRoot + "Admin/Remote/index.cfm?section=UserComments&action=delete&id=" + id, onDeleteCommentResponse)
	}
	
	return false;
}	
function onDeleteCommentResponse() {
	if (haveHttpResponse()) {
    	// Split the delimited response into an array
    	var results = getHttpResponse();

		if (typeof(results) == "object") {
			if (results[0] == 1) {
				// Get the comment node
		    	var e = document.getElementById("comment_" + commentId);
				// Remove the comment
				e.parentNode.removeChild(e);
			}
			//alert(results[1]);
		}
		else
			alert(results);
  	}
}	

function onUnsubscribeComments(type,id) {
	if (confirm('Are you sure you want to stop subscribing to these comments?')) {
		  sendHttpRequest(kdSiteRelRoot + "Admin/Remote/index.cfm?section=UserComments&action=Unsubscribe&object_type=" + type + "&object_id=" + id, onUnsubscribeCommentResponse)
	}
	
	return false;
}	
function onUnsubscribeCommentResponse() {
	if (haveHttpResponse()) {
    	// Split the delimited response into an array
    	var results = getHttpResponse();

		if (typeof(results) == "object") {
			if (results[0] == 1) {
				// Get and hide the unsubscribe box node
		    	document.getElementById("subscribedtocomments").style.display = "none";
			}

			alert(results[1]);
		}
		else
			alert(results);
  	}
}	
	
/************************************************************************************

Remote functions for custom HTML forms.

*************************************************************************************/

function getFormData(f) {
	var data="";
	
	// package up the form data and get it ready to send
	for (var i=0; i<f.elements.length; i++) {
		var e = f.elements[i];
		
		if (e.name.length) {
			switch (e.type) {
				case "checkbox":
				case "radio":
					 if (e.checked)
					 	data = data + "&" + e.name + "=" + escape(e.value);						
					 break;
					 
				default:
					 data = data + "&" + e.name + "=" + escape(e.value);						
			}
		}
	}
	
	return data;
}

var customFormName = "";

function onSubmitCustomForm(f,formId,formName) {
		
    postHttpRequest(kdSiteRelRoot + "Admin/Remote/index.cfm?section=Forms&action=Submit&form_id=" + formId,  
    				getFormData(f),
    				onSubmitCustomFormResponse);
	
	customFormName = formName;
	
	return false;
}
function onSubmitCustomFormResponse() {
	if (haveHttpResponse()) {
    	// Split the delimited response into an array
    	var results = getHttpResponse();

		if (typeof(results) == "object") {
			if (results[0] == 1) {
				// Hide the form and display the thank you message
		    	document.getElementById(customFormName).style.display = "none";

				document.getElementById(customFormName + "Msg").style.display = "block";
				document.getElementById(customFormName + "Msg").innerText = results[1];
			}
			else
				alert(results[1]);
		}
		else
			alert(results);	
	}
}

/************************************************************************************

Remote functions for manipulating page programs when the page is in edit mode.

*************************************************************************************/

function onRemovePageProgram(pgeId, pprId) {

	if (confirm('Are you sure you want to remove this page program?')) {
    	sendHttpRequest(kdSiteRelRoot + "Admin/Remote/index.cfm?section=PagePrograms&action=Remove&pge_id=" + pgeId + "&pge_prg_id=" + pprId,  
	    				onRemovePageProgramResponse);
	}
	
	return false;
}
function onRemovePageProgramResponse() {
	if (haveHttpResponse()) {
    	// Split the delimited response into an array
    	var results = getHttpResponse();

		if (typeof(results) == "object") {
			if (results[0] == 1) {
				// Get the page program root node
		    	var e = document.getElementById("ppr" + results[1]);
				// Remove the page program
				e.parentNode.removeChild(e);
			}
			else
				alert(results[1]);
		}
		else
			alert(results);	
	}
}

function onMinMaxPageProgram(pgeId, pprId) {

	sendHttpRequest(kdSiteRelRoot + "Admin/Remote/index.cfm?section=PagePrograms&action=MinMax&pge_id=" + pgeId + "&pge_prg_id=" + pprId,  
    				onMinMaxPageProgramResponse);
	
	return false;
}
function onMinMaxPageProgramResponse() {
	if (haveHttpResponse()) {
    	// Split the delimited response into an array
    	var results = getHttpResponse();

		if (typeof(results) == "object") {
			if (results[0] == 1) {
				var pprId = results[1];
				var state = results[2];

				// Is minimized?
				if (state == 1) {
					// Get the page program box
			    	var e = document.getElementById("ppr" + pprId + "Content");
			    	
			    	// Build the state box
					var stateboxNde = document.createElement('div');					
					stateboxNde.id = "ppr" + pprId + "State";
					stateboxNde.className = "Minimized";
					stateboxNde.appendChild(document.createTextNode("This program is minimized and will not be displayed to users who are not administrators of this page."));

					e.insertBefore(stateboxNde,e.childNodes[0]);
				}
				else {
					// Get the page program's minimized box
			    	var e = document.getElementById("ppr" + pprId + "State");
			    	
					// Remove the page program
					e.parentNode.removeChild(e);
				}
			}
			else
				alert(results[1]);
		}
		else
			alert(results);	
	}
}

/************************************************************************************

Remote functions for manipulating items

*************************************************************************************/

var itemId = 0;

function onChangeItemOwner(itmId,userId) {
	// Save a ref to the item.
	itemId = itmId;
	
	kdDialog(kdSiteRelRoot + "Admin/dialogs.cfm?dialog=SelectUser&function=onSetItemOwner&user_id=" + userId);
	return false;
}
function onSetItemOwner(userId,userName) {

	sendHttpRequest(kdSiteRelRoot + "Admin/Remote/index.cfm?section=Items&action=SetOwner&item_id=" + itemId + "&user_id=" + userId,  
    				onSetItemOwnerResponse);
	
	return false;
}
function onSetItemOwnerResponse() {
	if (haveHttpResponse()) {
    	// Split the delimited response into an array
    	var results = getHttpResponse();

		if (typeof(results) == "object") {
			if (results[0] == 1) {
				// Get the page program root node
		    	var e = document.getElementById("itemowner");
		    	
		    	e.innerText = results[1];
			}
			else
				alert(results[1]);
		}
		else
			alert(results);	
	}
}

function onDeleteItem(id) {

	if (confirm('Are you sure you want to delete this item?')) {
		sendHttpRequest(kdSiteRelRoot + "Admin/Remote/index.cfm?section=Items&action=Delete&item_id=" + id,  
	    				onDeleteItemResponse);
	}
	return false;
}
function onDeleteItemResponse() {
	if (haveHttpResponse()) {
    	// Split the delimited response into an array
    	var results = getHttpResponse();

		if (typeof(results) == "object") {
			if (results[0] == 1) {
				// The user is still viewing the item that has been deleted.  We need
				// to send them off to another page
				alert('The item has been deleted.');
				// We'll let the server tell us where to go
				window.location=results[1];
			}
			else
				alert(results[1]);
		}
		else
			alert(results);	
	}
}
