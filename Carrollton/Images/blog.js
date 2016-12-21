


/*
 	Title: javascript.js

	About:
		Created - 2008-09-19
		Author - Susan Kelly

		Updated - 2010-12-1
		Author - Alex Wack

	Description:
		This file contains the javascript functions to support the asynchronus update of blog categories

	Methods:

		function addRow()
			Displays the input box, enabling a user to add a category.  Also hides the edit and "save" buttons.

		updateCategories(pid,eid)
			By clicking "done", the changes (adds/changes/deletes) to categories will be saved to the db and
			the new category list will be re-saved.
			Inputs: pid = pageid and eid = entryid

		insertCategory(isInEdit)
			Purpose: When the user clicks "add" when to add a new category, the row is inserted with either
			a check box when in the default view or the delete icon when in the edit view.
			Inputs: isInEdit = true or false based on where insertCategory() is called from.

		cancelChanges(pid,eid)
			Purpose: cancels and changes to the list of categories and re-displays the original list.
			Inputs: pid = pageid and eid = entryid

		editCategories(pid)
			Purpose: Displays the categories in the edit view where users may add, delete, or change categories.
			Inputs: pid = pageid and eid = entryid

		markForDeletion(catId)
			Purpose: Markes the specific category for deletion (marks in red)
			Inputs: catId = categoryID

		markChanged(catId)
			Purpose: Markes the specific category as changed (marks in yellow)
			Inputs: catId = categoryID
 */


/*
** If DOMParser isn't defined, then roll our own.  This is to support IE
*/
      if(typeof(DOMParser) == 'undefined') {
       DOMParser = function() {}
       DOMParser.prototype.parseFromString = function(str, contentType) {
        if(typeof(ActiveXObject) != 'undefined') {
         var xmldata = new ActiveXObject('MSXML.DomDocument');
         xmldata.async = false;
         xmldata.loadXML(str);
         return xmldata;
        } else if(typeof(XMLHttpRequest) != 'undefined') {
         var xmldata = new XMLHttpRequest;
         if(!contentType) {
          contentType = 'application/xml';
         }
         xmldata.open('GET', 'data:' + contentType + ';charset=utf-8,' + encodeURIComponent(str), false);
         if(xmldata.overrideMimeType) {
          xmldata.overrideMimeType(contentType);
         }
         xmldata.send(null);
         return xmldata.responseXML;
        }
       }
      }

/*
** Need to create this method 'cuz the built in method doesn't seem to work. RW - It apparently also isn't being used

Array.prototype.myIndexOf = function(obj){
	for(var i=0; i<this.length; i++){
		if(this[i]==obj){
			return i;
		}
	}
	return -1;
}
*/
/* if only javascript had trim functions ... */
String.prototype.trim = function() {
	return this.replace(/^\s+|\s+$/g,"");
}
String.prototype.ltrim = function() {
	return this.replace(/^\s+/,"");
}
String.prototype.rtrim = function() {
	return this.replace(/\s+$/,"");
}

/* encode special characters so when they are passed as a URL in ajax call they are passed properly */
String.prototype.myEncode = function() {
	//alert('this = ' + this);  // handy for debugging
	var tmp = this.replace(/%/g,'%25');
	tmp = tmp.replace(/,/g, '~~~');  // since commas are used as a list separator, turn an "in category" comman in ~~~
	tmp = tmp.replace(/"/g, '%22');  // double quote
	tmp = tmp.replace(/'/g, '%27');  // single quote
	tmp = tmp.replace(/&/g, '%26');	 // ampersand (&)

	tmp = tmp.replace(/&quot;/g,'%22');  // double quote
	tmp = tmp.replace(/&#39;/g, '%27');  // single quote
	tmp = tmp.replace(/&#44;/g, '~~~');  // since commas are used as a list separator, turn an "in category" comman in ~~~
	tmp = tmp.replace(/&amp;/g,'%26');   // ampersand (&)

	//alert('tmp = ' + tmp);  // handy for debugging
	return tmp;
}

/* Convert special characters to HTML codes so the js elements and array's will handle them correctly. */
String.prototype.myHTMLConvert = function() {
	var tmp = this.replace(/&/g,'&amp;');
	tmp = tmp.replace(/"/g, '&quot;');
	tmp = tmp.replace(/'/g, '&#39;');
	tmp = tmp.replace(/,/g, '&#44;');

	return tmp;
}


/* Path to file containing blog methods used in the ajax calls */
var cfcPath = 'cf_blog/include/blog.cfc';

/* sadly, a global needs to be used to keep track of checked Ids */
var checkedIds = new Array();

function stopRKey(evt) {
  var evt = (evt) ? evt : ((event) ? event : null);
  var node = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
  if ((evt.keyCode == 13) && (node.type=="text"))  {return false;}
}


/*
** Unhides rows required to add new categories
*/
function addRow() {

	document.getElementById('addCategory').style.display='block';  		// display input for adding a category
	document.getElementById('updateCategory').style.display='block'; 	// display done and cancelled buttons
	document.getElementById('showInput').style.display='none'; 			// hide add row link
	document.getElementById('saveButtons').style.display='none'; 		// hide cancel, save draft, and publish buttons
	document.getElementById('categoryEdit').style.display='none'; 		// hide category edit link

	// Hide tag buttons
	$j('#tagEditButton, #tagAddButton').hide();

	// the state of "checked" categories needs to be preserved in case the user cancels the add row operation
	checkedIds.length = 0;

	var checkElem = document.getElementsByName('category');

	if (checkElem != null) {
		for (i=0; i<checkElem.length; i++) {
			if (checkElem[i].checked == true) {
				checkedIds.push(checkElem[i].value);
			}
		}
	}


	document.onkeypress = stopRKey;
	$j('#input_newRow').focus();

}


/*
** Updates all changes to the list of categories:
*/
function updateCategories(pid,eid) {


	// Get the new string values for the changed IDs and create an array to pass to the updateCategories method.
	var changedNames = new Array();
	var myChangedIds = new Array();



	$j('.yellowBackground').each(function(){
		var inputId = $j(this).attr('id').replace(/input_/,"");
		if (! isNaN(inputId) ) {
			changedNames.push($j(this).val());
			myChangedIds.push(inputId);
		}
	});

	// Get the new string values for the changed IDs and create an array to pass to the updateCategories method.
	var delIds = new Array();

	$j('.redBackground').each(function(){
		var delId = $j(this).attr('id').replace(/input_/,"");
		if (! isNaN(delId) ) {
			delIds.push(delId);
		}
	});

	/*
		If in the edit view, use the preserved checkbox values, otherwise, use the current checkbox values
		If there are elements with the name 'category', then it's the checkbox view.
	*/
	checkedIds.length = 0;		// clear out the preserved values as

	$j('.categoryRow > input:checked').each(function(){
			checkedIds.push($j('#name_'+$j(this).val()+'').text());
	});

	/* get the new categories that have been added via the "add" input box in "check box mod"*/
	var newCatCheckedArray = Array();
	var newCatArray = Array();

	var isMarkedForDeletion = false;

	$j('.newCategoryName').each(function() {
		isMarkedForDeletion = $j(this).hasClass('redBackground');
		if (! isMarkedForDeletion) {
			newCatArray.push($j(this).text());
			if ($j(this).checked) {
				newCatCheckedArray.push($j(this).text());
			}
		}
	});


	/* get the new items added in the edit view */
	$j('.newAddCategory').each(function() {
		isMarkedForDeletion = $j(this).hasClass('redBackground');
		if (! isMarkedForDeletion) {
			newCatArray.push($j(this).val());
		}
	});

	// if there is a new category, pass that along and ... it was already encoded
	var newCategory = $j('#input_newRow').val();

	// the category in the input box won't have a check, so add it to the end of the newCatArray
	if (newCategory.length > 0) {
		newCatArray.push(newCategory);
	}

	//alert(params);  // handy for debugging
	$j.ajax({
		type: "GET",
		url: cfcPath+'?method=updateCategories',
		data: ({
			pageID: pid,
			entryID: eid,
			DeleteIDList: delIds.toString(),
			ChangeIDList: myChangedIds.toString(),
			ChangeNameList: changedNames.toString(),
			CheckedIDList: checkedIds,
			newCatList: newCatArray.toString(),
			newCatIsCheckedList: newCatCheckedArray.toString()
		}),
		success: function(xmlString) {

			// convert wddxPacket to an XML string
			var parser=new DOMParser();
			try {
				var xmlDoc=parser.parseFromString(xmlString,"text/xml");
			} catch(err) {
				var xmlDoc=$j(xmlString);
			}
			// get the elements with "string" tags (should only be one).  The string contains the HTML to display
			//xString=xmlDoc.getElementsByTagName('string');

			// delete all of the divs in "container"
			var container = document.getElementById('container');

			if (container.hasChildNodes()) {
				while (container.childNodes.length >= 1) {
					container.removeChild(container.firstChild);
				}
			}

			var myHTML;
			// iterate through the xml elements to get the ID and name and revert the HTML to be in non-edit view

			startPos = xmlString.indexOf('<CONTENT>',0);
			endPos = xmlString.indexOf('</CONTENT>',0);

			myHTML = xmlString.slice(startPos,endPos).replace('<CONTENT>','').trim();
			container.innerHTML = myHTML;

			// change the display back to "add category""
			if (document.getElementById('addCategory') != null) {
				document.getElementById('addCategory').style.display='none';
				var rplStr = document.getElementById('addCategory').innerHTML.replace(/insertCategory\(1\)/g, "insertCategory\(0\)");
				document.getElementById('addCategory').innerHTML = rplStr;
			}
			if (document.getElementById('updateCategory') != null) {
				document.getElementById('updateCategory').style.display='none';
			}
			if (document.getElementById('showInput') != null) {
				document.getElementById('showInput').style.display='block';
			}

			if (document.getElementById('saveButtons') != null) {
				document.getElementById('saveButtons').style.display='block';
			}

			if (document.getElementById('categoryEdit') != null) {
				document.getElementById('categoryEdit').style.display='block';
			}

			// clear the input box for next itme
			if (document.getElementById('input_newRow') != null) {
				document.getElementById('input_newRow').value = '';
			}


			// clear globals
			checkedIds.length = 0;

			// Show tag buttons
			$j('#tagEditButton, #tagAddButton').show();

			return true;
		},

		error:function(xml){
			// Failure handler
			alert('There was an error updating the categories.');
			return false;
		}
	});
}


/*
** inserts a new category row, but doesn't save it to the DB
*/
function insertCategory(isInEdit) {

	var newCategory = document.getElementById('input_newRow').value.trim().myHTMLConvert();
	if (newCategory.length == 0) {
		return;
	}

	var container = document.getElementById('container');
	var row = document.createElement("DIV");


	// if added a row in edit view, then display delete and input box.
	if (isInEdit) {

		row.className = 'categoryRow categoryEdit';
		row.innerHTML = '<a href="javascript:markForDeletion(\'' + newCategory+ '\')">' +
		'<img id="delImg_' + newCategory + '" src="images/cross.png" border="0" align="absmiddle" alt="Delete Category"></a> ' +
		'<input id="input_' + newCategory + '" class="categoryEdit newAddCategory" name="newCategory" type="text" onchange="markChanged(\'' + newCategory +'\')" value="' + newCategory + '">' +
		'<div style="clear: both;"><div>';
	// else, show the checkbox and category name
	} else {
		row.className = 'categoryRow';
		row.innerHTML = '<input class="checkbox" type="checkbox" name="newCategoryCheckBox" value="1">' +
		'<span class="newCategoryName">' + newCategory + '</span>' + '<div style="clear: both;"></div>';
	}

	// append new row
	container.appendChild(row);

	// Clear input field
	document.getElementById('input_newRow').value = '';
	$j('#input_newRow').focus();

}


/*
** cancel and changes made to the categories
*/
function cancelChanges(pid,eid) {

	$j.ajax({
		type: "GET",
		url: cfcPath+'?method=getCategoryCheckboxHTML',
		data: ({
			pageID: pid,
			entryID: eid,
			checkedIds: checkedIds
		}),
		success: function(xmlString){


			// convert wddxPacket to an XML string
			var parser=new DOMParser();
			try {
				var xmlDoc=parser.parseFromString(xmlString,"text/xml");
			} catch(err) {
				var xmlDoc=$j(xmlString);
			}

			// get the elements with "string" tags (should only be one).  The string contains the HTML to display
			xString=xmlDoc.getElementsByTagName('string');

			// delete all of the divs in "container"
			var container = document.getElementById('container');

			if (container.hasChildNodes()) {
				while (container.childNodes.length >= 1) {
					container.removeChild(container.firstChild);
				}
			}

			var myHTML;
			// iterate through the xml elements to get the ID and name and revert the HTML to be in non-edit view

			startPos = xmlString.indexOf('<CONTENT>',0);
			endPos = xmlString.indexOf('</CONTENT>',0);

			myHTML = xmlString.slice(startPos,endPos).replace('<CONTENT>','');
			container.innerHTML = myHTML;

			// change the display back to "add category""
			if (document.getElementById('addCategory') != null) {
				document.getElementById('addCategory').style.display='none';
				var rplStr = document.getElementById('addCategory').innerHTML.replace(/insertCategory\(1\)/g, "insertCategory\(0\)");
				document.getElementById('addCategory').innerHTML = rplStr;
			}
			if (document.getElementById('updateCategory') != null) {
				document.getElementById('updateCategory').style.display='none';
			}
			if (document.getElementById('showInput') != null) {
				document.getElementById('showInput').style.display='block';
			}

			if (document.getElementById('saveButtons') != null) {
				document.getElementById('saveButtons').style.display='block';
			}

			if (document.getElementById('categoryEdit') != null) {
				document.getElementById('categoryEdit').style.display='block';
			}

			// clear the input box for next itme
			if (document.getElementById('input_newRow') != null) {
				document.getElementById('input_newRow').value = '';
			}

			// clear globals
			checkedIds.length = 0;

			// Show tag buttons
			$j('#tagEditButton, #tagAddButton').show();

			return true;
		},

		error:function(xml){
			// Failure handler
			alert('There was an error canceling the changes the categories.');
			return false;
		}
	});

}


/*
** displays the "edit" screen to modify categories and delete 'em
*/
function editCategories(pid) {

	var checkElem = document.getElementsByName('category');
	// preserve the status of the checked values
	checkedIds.length = 0;

	for (i=0; i<checkElem.length; i++) {
		if (checkElem[i].checked == true) {
			checkedIds.push(checkElem[i].value);
		}
	}

	$j.ajax({
		type: "GET",
		url: cfcPath+'?method=editCategoriesHTML',
		data: ({
			pageID: pid
		}),
		success: function(xmlString){
			// Response is in the format: <wddxPacket version='1.0'><header/><data><number>35.0</number></data></wddxPacket>
			// Parse out the XML and get the number
			// convert wddxPacket to an XML string
			var parser=new DOMParser();
			try {
				var xmlDoc=parser.parseFromString(xmlString,"text/xml");
			} catch(err) {
				var xmlDoc=$j(xmlString);
			}

			// delete all of the divs in "container"
			var container = document.getElementById('container');

			if (container.hasChildNodes()) {
				while (container.childNodes.length >= 1) {
					container.removeChild(container.firstChild);
				}
			}

			var myHTML;
			// iterate through the xml elements to get the ID and name and revert the HTML to be in non-edit view

			startPos = xmlString.indexOf('<CONTENT>',0);
			endPos = xmlString.indexOf('</CONTENT>',0);

			myHTML = xmlString.slice(startPos,endPos).replace('<CONTENT>','').trim();
			container.innerHTML = myHTML;

			// make the add category input box element and "done" element visible
			document.getElementById('addCategory').style.display='block';  		// display input for adding a category
			document.getElementById('updateCategory').style.display='block'; 	// display done and cancelled buttons
			document.getElementById('showInput').style.display='none'; 			// hide add row link
			document.getElementById('saveButtons').style.display='none'; 		// hide cancel, save draft, and publish buttons
			document.getElementById('categoryEdit').style.display='none'; 		// hide category edit link

			// Hide tag buttons
			$j('#tagEditButton, #tagAddButton').hide();

			// change the insertCategory param to "isInEdit"
			var rplStr = document.getElementById('addCategory').innerHTML.replace(/insertCategory\(0\)/g, "insertCategory\(1\)")
			document.getElementById('addCategory').innerHTML = rplStr;

			return true;
		},
		error:function(o){
			// Failure handler
			alert('There was an error editing the categories.');
			//console.log(o);
			return false;
		}
	});
}


/*
** Mark a categorie for deletion.  Warns user if there are topics associated with the category before marking it for deletion.
*/
function markForDeletion(catID) {

	// if the ID to be deleted is already in the list of ID's to delete, then this really must be an "un-delete" operation

	var i = 0;
	var markForDeletion = true;

	// if the element has a red background, then un-delete it (remove redBackgroun class) and change the image

	var inputElemId = 'input_'+catID;

	if ($j('#'+inputElemId+'').hasClass('redBackground')) {
		$j('#'+inputElemId+'').removeClass('redBackground');
		var imgElemId = 'delImg_' + catID;
		document.getElementById(imgElemId).src = "images/cross.png";

	} else if (markForDeletion && isNaN(catID)) {

		$j('#'+inputElemId+'').addClass('redBackground');
		$j('#'+inputElemId+'').removeClass('yellowBackground');
		var imgElemId = 'delImg_' + catID;
		document.getElementById(imgElemId).src = "images/cross_gray.png";


	} else if (markForDeletion) {

		$j.ajax({
			type: "POST",
			url: cfcPath+'?method=getNumEntries',
			data: ({
				Blog_CategoryID: catID
			}),
			success: function(xmlString){

				startPos = xmlString.indexOf('<number>',0);
				endPos = xmlString.indexOf('</number>',0);

				numberPart = xmlString.slice(startPos,endPos).replace('<number>','');

				var numEntries = Number(numberPart);
				var confirmText = '';


				var okToDelete = true;

				// If there are topic entries associated with the category, then confirm deletetion, otherwise
				// it is OK to go ahead and delete.
				if (numEntries > 0) {
					if (numEntries == 1) {
						confirmText = 'There is 1 topic associated with this category.  ';
					} else {
						confirmText = 'There are ' + numEntries + ' topics associated with this category. ';
					}
					confirmText = confirmText + 'Deleting the category will not delete the topic.  Do you still want to delete the category?';

					okToDelete = confirm(confirmText);

				}

				if (okToDelete) {
					var inputElemId = 'input_'+catID;
					$j('#'+inputElemId+'').addClass('redBackground');
					$j('#'+inputElemId+'').removeClass('yellowBackground');
					var imgElemId = 'delImg_' + catID;
					document.getElementById(imgElemId).src = 'images/cross_gray.png';

				}

				return true;
			},
			error:function(o){
				// Failure handler
				alert('There was an error deleting the category.');
				return false;
			}
		});
	}
}


/*
** Marks the field yellow
*/
function markChanged(catID) {

	var inputElemId = 'input_'+catID;
	$j('#'+inputElemId+'').addClass('yellowBackground');
	$j('#'+inputElemId+'').removeClass('redBackground');

}

function checkFileType(fileName) {

	var suffixPos = fileName.lastIndexOf('.') + 1;
	var suffix = fileName.substring(suffixPos).toLowerCase();
	var fileOK = false;

	switch (suffix) {
		case 'jpg':
		case 'gif':
		case 'jpeg':
		case 'png':
			fileOK = true;
			break;
		default:
			alert('The file ' + fileName + ' is not a valid type.  Only files of type GIF, JPG, JPEG, and PNG may be uploaded.');
			break;

	}

	return fileOK;
}

/*
** submits the topic
*/
function updateTopic() {

	var okToProceed = true;

	// if the imagefile field is defined, make sure it is of the right type if the user selected a file
	if (document.update.imagefile != null) {

		if (document.update.imagefile.value.length > 0) {
			okToProceed = checkFileType(document.update.imagefile.value);

			// if the file is of the right type, then make sure the consent checkbox is checked.
			if (okToProceed && document.update.consent.checked == false) {
				alert('In order to upload an image, please check the box consenting its use.');
				okToProceed = false;
			}
		}
	}


	if (okToProceed) {
		document.update.submit();
	} else {
		return false;
	}

}

/*
** submits the post/comment
*/
function updatepost(button)
{
	var $button = $j(button);

	if (!$button.hasClass('fsInactive')) {
		$button.addClass('fsInactive');
		document.update.submit();
	}
	
	return false;
}

/*
** Cancel's the new post/comment
*/
function cancelPost() {
	document.update.cancel.value = 1;
	document.update.submit();
}


/*
** Cancel's the new topic or changes
*/
function cancelMyTopic() {
	document.update.cancelTopic.value = 1;
	document.update.submit();
}

/*
** saves the topic as a draft
*/
function savedraft(isPublished)
{
	var okToProceed = true;

	// if the imagefile field is defined, make sure it is of the right type if the user selected a file
	if (document.update.imagefile != null) {

		if (document.update.imagefile.value.length > 0) {
			okToProceed = checkFileType(document.update.imagefile.value);

			// if the file is of the right type, then make sure the consent checkbox is checked.
			if (okToProceed && document.update.consent.checked == false) {
				alert('In order to upload an image, please check the box consenting its use.');
				okToProceed = false;
			}
		}

	}

	if (isPublished) {
		okToProceed = confirm('Are you sure you want to un-publish this post.  Un-publishing this post will remove it from the front end until it is published.');
	}

	if (okToProceed) {
		document.update.publish.value = 0;
		document.update.submit();
	} else {
		return false;
	}
}

var blview = '';

/*
** toggles the expanded category view
*/
function toggleview(){
	if (blview == '') {
		try {
			var checkView = $j.cookie("categoryview");
			if (checkView == 'hide') {
				blview = 'display';
			} else {
				blview = 'hide';
			}
		} catch (e) {
			blview = 'display';
		}

	}

	if (blview == 'hide') {
		document.getElementById('show_bl').style.display = 'block';
		blview='display';
		document.getElementById('viewbllink').innerHTML = 'hide';
		createCookie('categoryview','',180);
	} else {
		document.getElementById('show_bl').style.display = 'none';
		blview='hide';
		document.getElementById('viewbllink').innerHTML = 'display';
		createCookie('categoryview','hide',180);
	}
}


/*
 * Used by "link to" to open blog topic in new window/tab for admin session or
 * in the same window for an end user session.
 */
function showLink (title,linkText,modalWidth,modalHeight,modalHeader,modalFooter) {
	$j('body').append('<div id="modal" style="padding:5px"></div>');
	$j('#modal').dialog({
		autoOpen:false,
		modal:true,
		resizable:false,
		minheight:modalHeight,
		zIndex:9999,
		width: modalWidth,
		title:'Link to <strong>'+title+'</strong>',
		buttons : { 'OK' : function(){ $j(this).dialog('close'); }}
	});
	$j('#modal').html('');
	$j('#modal').append('<br><a href="'+linkText+'">'+linkText+'</a><br>');

	$j('#modal').dialog('open');
	$j('#blogLink').focus().select();
}


function deletePost(id,eid) {

	var okToDelete1, okToDelete2;

	okToDelete1 = confirm('Are you sure you want to delete this topic and all its comments?');
	if (okToDelete1) {
		okToDelete2 = confirm('Are you really sure you want to delete this topic and all its comments?');
		if (okToDelete2) {

			document.location.href = 'page.cfm?p='+id+'&eid='+eid+'&do=deletetopic' ;
		}
	}
	return;

}

// ==========================================================================
// ! jQuery plugin gently breaks long, unwrappable strings to assist layout
// ==========================================================================
$j(document).ready(function(){
	// every 38th character we'll add a zero-length space character
	$j(".blogpost h2, .blogpost p, .blogtopic p, .commentContent p, .blogcomment p").not("#tinymce, body.mceContentBody, #message_ifr, a").fsBreakly(38);

	initModal( false );

	// in the LMS case, we want to give them an option to post now or schedule the post
	$j("#saveButtonPublishLMS").click( function() {

		// open the modal
		initModal( true );

	} );

	// add the date picker
	$j("input[name='dateposted'], input[name='dateExpires']").datepicker( {
		minDate: new Date(),
    showOn: 'both',
    buttonImage: 'admin_ui/1.0/images/calendar.png',
    buttonImageOnly: true
	} );

	// add the date picker
	$j("#blogpage_dateposted").datepicker( {
		maxDate: new Date(),
    showOn: 'both',
    buttonImage: 'admin_ui/1.0/images/calendar.png',
    buttonImageOnly: true
	});

	// in the LMS case, we want to give them an option to post now or schedule the post
	$j(".blogtopic").on('click','.copyBlogBtn',function() {
		var entryID = $j(this).data('eid');
		var pageID = $j(this).data('pid');
		copyBlogPost(pageID,entryID);
	});
	/* 
		add a listener to create a blog 
		from publish dialog in LMS
	*/
	$j('#clonePicker,#clonePickerOnly').on('click','a.activateBlogBtn',function(){
		var pageid = $j(this).attr('data-pageid');
		createStatus = createBlog(pageid);
		if(createStatus >= 1) {
			$j(this).parent('label.clonePickerOption').find('input[name="cloneTo"]').removeAttr('disabled').val(createStatus);
			$j(this).parent('label.clonePickerOption').find('span.fsInactive').removeClass('fsInactive');
			$j(this).parent('label.clonePickerOption').find('a.activateBlogBtn').remove();
		} else {
			alert('Sorry, there was an error creating this blog.');
		}
	});

	$j('#saveButtons .buttons').on('click', function() {
		$j('#saveButtons .buttons').prop('disabled', true).addClass('blogInactive');
	})

});

// create a blog from groups pageid
function createBlog(pageid) {
	var createStatus = '0';

	try {
		$j.ajax({
			type: "GET",
			url: 'cf_group/adminblog.cfm',
			async: false,
			data: ({
				grouppageid: pageid,
				'do': 'createblog',
				lmsAjaxRequest: 1
			}),
			success: function(callbackString) {
				var callbackString = $j.trim(callbackString);
				var tempDiv = document.createElement('div');
				tempDiv.innerHTML = callbackString;
				var success = $j(tempDiv).find('#lmsAjaxRequest');
				if($j(success).length >= 0 && $j(success).html() == 'success') {
					var blogid = $j(tempDiv).find('#lmsAjaxRequest').attr('data-blogid');
					createStatus = blogid;
				}
			},error:function(){
				// Failure handler
				createStatus = '0';
			}
		});
	} catch(err) {
		createStatus = '0';
	}

	return createStatus;
}



// create our modal
function initModal( autoOpen ) {

	// a publish dialog for LMS
	$j("#publishModal").dialog( {
		autoOpen: autoOpen,
		modal: true,
		title: "Publish Settings",
		close: function() {

			// when we close this modal, we will actually destroy the modal so we can attach it back to the form scope
			$j(this).hide().dialog("destroy").appendTo("#blog_topic_edit_form");
		},
		buttons: [
			{
				text: "Publish",
				click: function() {

					$j(this).hide().dialog("destroy").appendTo("#blog_topic_edit_form").attr( "data-void", updateTopic() );
				}
			},
			{
				text: "Cancel",
				click: function() {
					$j('#saveButtons .buttons').prop('disabled', false).removeClass('blogInactive');
					$j("#publishModal").dialog( "close" );
				}
			}
		]
	} );

}

// create our modal
function copyBlogPost(pageID,entryID) {
	// a copy post dialog for LMS
	$j("#copyBlogPostModal").dialog( {
		autoOpen: true,
		modal: true,
		title: "Clone Post to Other Groups",
		close: function() {
			$j(this).find('.groupPicker').html('');
		},
		open: function(){
			$j(this).find('.alertMsg').hide();
			
			// load in the groups 
			$j(this).find('.groupPicker').html('Loading&hellip;<br><img src="images/loadingbar.gif">');
			$j.ajax({
        type: "POST",
        url: 'cf_blog/ajax/blog.cfm',
        data: {'do':"getGroupsToCopyTo", id:pageID},
        success: function(responseText){
		      var rObj = $j.parseJSON(responseText);
		      var rStr = '';
		              
		      if(rObj.DATA.length > 0){
		        // build picker
		        $j(rObj.DATA).each( function() {
		          /* NAME","PAGEID","PERIOD","HASBLOG
		          [0] "NAME",        
		          [1] "PAGEID",
		          [2] "PERIOD",      
		          [3] "HASBLOG"
		          */
		          //rStr += '<li><a data-authID="' + $j(this)[0] + '" data-authType="' + escape($j(this)[1]) + '" href="javascript:void 0">' + $j(this)[2] + '</a></li>';
							rStr += '<label class="clonePickerOption">';
							if($j(this)[3] == 0) {
								rStr += '<input class="grpsToCloneTo" type="checkbox" name="cloneTo" value="'+ $j(this)[1] +'" disabled="disabled"> <span class="fsInactive">'+ $j(this)[0] + '</span> <a class="activateBlogBtn" data-pageid="'+ $j(this)[1] +'" href="javascript:void 0">create blog</a>';
							} else {
								rStr += '<input class="grpsToCloneTo" type="checkbox" name="cloneTo" value="'+ $j(this)[1] +'"> '+ $j(this)[0];
							}
							rStr += '</label>';
        		});
					} else {
						$j(this).find('.alertMsg').html('No available groups found.').show();
					};
					$j("#copyBlogPostModal").find('.groupPicker').html(rStr);
        },
        error: function() {
          // An error occuredrStr += '<p class="alertMsg">There was an error loading groups.</p>';
					$j(this).find('.alertMsg').html('There was an error loading groups.').show();
				}
      });
		},
		buttons: [{
			text: "Clone",
			click: function() {
				$j(this).find('.alertMsg').hide();

        var checkedVals = $j('.grpsToCloneTo:checkbox:checked').map(function() {
					return this.value;
				}).get();

				if(!checkedVals.length > 0){
					$j(this).find('.alertMsg').html('Please select at least one group below to clone the blog post to.').show();
					return false;
				}
				checkedVals = checkedVals.join(",");
				
				$j(this).find('.groupPicker').html('Cloning in progress&hellip;<br><img src="images/loadingbar.gif">');
			
				// begin clone request
				$j.ajax({
	        type: "POST",
	        url: 'cf_blog/ajax/blog.cfm',
	        data: {'do':"clonePostTo", pageID:pageID, entryID:entryID, cloneTo:checkedVals},
	        success: function(responseText){
			      if(responseText == 'success'){
			        // it worked
			        $j("#copyBlogPostModal").dialog( "close" );
			        $j("#cloneSuccess"+entryID).html('successfully cloned to other groups').show();
						} else {
							$j("#copyBlogPostModal").find('.groupPicker').html('');
							$j("#copyBlogPostModal").find('.alertMsg').html('There was an error during the cloning process.').show();
						};
	        },
	        error: function() {
	          // An error occuredr
						$j("#copyBlogPostModal").find('.groupPicker').html('');
						$j("#copyBlogPostModal").find('.alertMsg').html('There was an error during the cloning process.').show();
					}
	      });
			}
		},{
			text: "Cancel",
			click: function() {
				$j(this).dialog( "close" );
			}
		}]
	});

}