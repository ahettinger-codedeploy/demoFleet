/**
 * Variation of the sharewithdropdown code, altered to provide "choose friends" functionality
**/
var g_friendsWithPopUp = null;

var FriendsWithDropDown = Class.create({
	hookedobjectid: null,
	hookedobject: null,
	divobject: null,
	divobjecthidden: 1,
	results: null,
	selectedIndex: 0,
	initialize: function(hookedobjectid, selectCallback, addToListCallback) {
		this.hookedobjectid = hookedobjectid;
		this.callback = Object.isFunction(selectCallback) ? selectCallback : Prototype.emptyFunction;
		this.addToListCallback = Object.isFunction(addToListCallback) ? addToListCallback : this.addToListCallbackDefault.bind(this);
		if (this.hookedobjectid !== null) {
			this.hookedobject = $(hookedobjectid);
		}
		if (this.hookedobject === null) {
			this.hookedobject = document.body;
		}
		if (this.divobject === null) {
			this.divobject = new Element('div', { 'style': 'position: absolute; width: 250px; height: auto; background: #d3f2f7; z-index: 1000000; border: 1px solid gray; display: none;' });
			document.body.appendChild(this.divobject);
		}
		Event.observe(this.hookedobject, 'keydown', this.onkeydown.bindAsEventListener(this));
		Event.observe(this.hookedobject, 'keypress', this.onkeypress.bindAsEventListener(this));
		Event.observe(this.hookedobject, 'keyup', this.onkeyup.bindAsEventListener(this));
		Event.observe(this.hookedobject, 'dblclick', this.ondoubleclick.bindAsEventListener(this));
		this.boundOnDocumentClick = this.ondocumentclick.bindAsEventListener(this);
	},
	hide: function() {
		if (this.visible()) {
			this.divobjecthidden = 1;
			this.divobject.hide();
			Event.stopObserving(document.body, 'click', this.boundOnDocumentClick);
			if (Object.isFunction(this.onHide)) {
				this.onHide();
			}
		}
	},
	show: function() {
		if (!this.visible()) {
			if (Object.isFunction(this.onShow)) {
				this.onShow();
			}
			var offset = Element.cumulativeOffset(this.hookedobject);
			offset.top += Element.getHeight(this.hookedobject);
			this.divobject.style.top = offset.top + 'px';
			this.divobject.style.left = offset.left + 'px';
			Event.observe(document.body, 'click', this.boundOnDocumentClick);
			this.divobject.show();
			this.divobjecthidden = 0;
		}
	},
	visible: function() {
		return (this.divobjecthidden === 0);
	},
	ondocumentclick: function(e) {
		var element = Event.element(e);
		while (element !== document.body && element !== null) {
			if (element === this.divobject)
				return;
			element = element.up();
		}
		this.hide();
	},
	setResult: function() {
		if (this.callback !== Prototype.emptyFunction) {
			this.callback(this.hookedobjectid, this.results[this.selectedIndex]);
		}
		else {
			if (this.hookedobject.value) {
				this.hookedobject.value = this.results[this.selectedIndex].username;
			}
			else {
				this.hookedobject.innerHTML = this.results[this.selectedIndex].username;
			}
		}
	},
	onkeydown: function(e) {
		if (e.keyCode == Event.KEY_TAB || e.keyCode == Event.KEY_RETURN) {
			if (this.visible()) {
				if (this.selectedIndex >= 0) {
					this.setResult();
					e.stop();
				}
			}
			this.hide();
		}
		else if (e.keyCode == Event.KEY_UP || e.keyCode == Event.KEY_DOWN) {
			var direction = 0;
			if (!this.visible() || this.results === null) {
				return;
			}
			e.stop();
			if (e.keyCode == Event.KEY_UP) {
				direction = -1;
			}
			else {
				direction = 1;
			}
			if (this.selectedIndex >= 0) {
				this.results[this.selectedIndex].div.style.background = '#d3f2f7';
			}
			if (!(this.selectedIndex + direction < -1 || this.selectedIndex + direction >= this.results.length)) {
				this.selectedIndex += direction;
			}
			if (this.selectedIndex >= 0) {
				this.results[this.selectedIndex].div.style.background = '#ace6f0';
			}
		}
	},
	onkeypress: function(e) {
		if (e.keyCode == Event.KEY_ESC) {
			this.hide();
		}
		else if (e.keyCode == Event.KEY_RETURN) {
			if (this.visible()) {
				if (this.selectedIndex >= 0) {
					this.setResult();
					e.stop();
				}
			}
			this.hide();
		}
	},
	onkeyup: function(e) {
		if (e.keyCode == Event.KEY_ESC || e.keyCode == Event.KEY_RETURN || e.keyCode == Event.KEY_TAB ||
				e.keyCode == Event.KEY_UP || e.keyCode == Event.KEY_DOWN) {
			if (this.visible()) {
				e.stop();
			}
		}
		else if (g_shareWithDropDownSearchArray !== null) {
			var oldusername = null, oldusernameindex = -1;
			if (this.results !== null && this.selectedIndex > 0 && this.results[this.selectedIndex]) {
				oldusername = this.results[this.selectedIndex].username;
			}

			// Search here
			this.results = g_shareWithDropDownSearchArray.search(this.hookedobject.value || this.hookedobject.innerHTML);
			
			// If results are returned, we need to display them
			if (this.results !== null && this.results.length > 0) {
				// Create new div container for results
				var content = new Element('div', { 'style': 'position: static; display: block; cursor: pointer;' }), i;
				
				for (i = 0; i < this.results.length && i < 15; i++) {
					// Create a DIV for each result element
					var div = new Element('div', { 'class': 'label-small', 'style': 'padding-left: 2px; padding-right: 2px;' });
					div.appendChild(new Element('div', { 'style': 'float: right;' }).update(this.results[i].fnameMatch + "&nbsp;" + this.results[i].lnameMatch));
					div.appendChild(new Element('div', { 'style': '' }).update(this.results[i].usernameMatch));
					content.appendChild(div);
					this.results[i].div = div;
					if (oldusername !== null && this.results[i].username == oldusername) {
						oldusernameindex = i;
					}
				}
				
				var elem;
				content.appendChild(elem = new Element('div', { 'style': 'text-align: rigt;' }));
				elem.update(elem = new Element('span', { 'class': 'Smaller', 'style': 'cursor: pointer;' }));
				elem.update('Add friends to this list');
				Event.observe(elem, 'click', this.onclickaddfriends.bindAsEventListener(this));
				
				if (oldusername !== null && oldusernameindex >= 0) {
					this.selectedIndex = oldusernameindex;
					this.results[this.selectedIndex].div.style.background = '#ace6f0';
				}
				else {
					this.selectedIndex = 0;
					this.results[this.selectedIndex].div.style.background = '#ace6f0';
				}

				// Update the content div and bind event listeners
				this.divobject.update(content);
				for (i = 0; i < this.results.length && i < 15; i++) {
					Event.observe(this.results[i].div, 'click', this.onclickresult.bindAsEventListener(this, i));
					Event.observe(this.results[i].div, 'mouseover', this.onmouseoverresult.bindAsEventListener(this, i));
				}
				
				// Show results
				this.show();
			}
			
			// If no results returned and we are displayed, we need to hide ourselves
			else if (this.visible()) {
				this.hide();
			}
		}
	},
	onmouseoverresult: function(e, index) {
		if (index < 0 || index > this.results.length - 1 || this.selectedIndex == index) {
			return;
		}
		if (this.selectedIndex >= 0) {
			this.results[this.selectedIndex].div.style.background = '#d3f2f7';
		}
		this.selectedIndex = index;
		this.results[this.selectedIndex].div.style.background = '#ace6f0';
	},
	onclickresult: function(e, index) {
		e.stop();
		if (index < 0 || index > this.results.length - 1) {
			return;
		}
		this.selectedIndex = index;
		this.setResult();
		this.hide();
	},
	addToListCallbackDefault: function(e) {
		window.open('/share/user_list.php', 'pop');
	},
	onclickaddfriends: function(e) {
		e.stop();
		this.hide();
		this.addToListCallback(e);
	},
	ondoubleclick: function(e) {
		e.stop();
	},
	popupCallback: function(value) {
		this.hookedobject.value = value;
		if (Object.isFunction(this.callback)) {
			this.callback(this.hookedobjectid);
		}
	}
});

var FriendsWithInputBox = Class.create({
	_sharedWith: null,
	_sharingIsOn: false,
	_dropdown: null,

	// This special event handler is used to implement firing the 'change' handler when the user presses the return key in
	// the input box text field for the IE browser.  Apparantly IE does not fire the change handler when a user presses
	// return--instead only when the control loses focus.
	_keyPressHandlerFriendsWithInputBox: function(event) {
		if (event.keyCode == Event.KEY_RETURN) {
			Event.stop(event);
			return false;
		}
	},
	
	// Stop the enter key from submitting a form when the share with box is inside a form
	_keyDownHandlerFriendsWithInputBox: function(event) {
		var element = $(Event.element(event));
		if (event.keyCode == Event.KEY_RETURN) {
			if (element.value != "" && this._dropdown !== null && !this._dropdown.visible() && !this._showingAlertBox) {
				this._shareWithInputBoxDropDownCallback(element.identify());
			}
			Event.stop(event);
			return false;
		}
	},

	_changeFriendsWithInputBox: function(event) {
		var element = $(Event.element(event));
		if (element.value != "" && !this._showingAlertBox) {
			Event.stop(event);
			if (this._dropdown !== null && !this._dropdown.visible()) {
				this._shareWithInputBoxDropDownCallback(element.identify());
			}
		}
	},
	
	_closedAlertBox: function() {
		var inputElement = $('sharewithinputfield');
		this._showingAlertBox = false;
		if (inputElement.value != "") {
			inputElement.focus();
			inputElement.select();
		}
	},
	
	_alert: function(message) {
		this._showingAlertBox = true;
		new AlertPopUp(message, this._closedAlertBox.bind(this));
	},

	_clickRemoveShareWithEntry: function(event) {
		var element = $(Event.element(event));
		if (element.up().siblings().length > 1) {
			var valueElement = element.siblings()[1];
			if (valueElement.innerHTML != "") {
				this._sharedWith.unset(valueElement.innerHTML);
				element.up().remove();
			}
		}
		Event.stop(event);
		//this._updateSharingIsImage();
	},

	_clickEditShareWithEntry: function(event) {
		var element = $(Event.element(event));
		if (element.up().siblings().length > 1) {
			var valueElement = element.siblings()[2];
			if (valueElement.innerHTML != "") {
				if (element.checked) {
					if (typeof this._sharedWith.get(valueElement.innerHTML) !== 'undefined') {
						this._sharedWith.get(valueElement.innerHTML).edit = true;
					}
				}
				else {
					if (typeof this._sharedWith.get(valueElement.innerHTML) !== 'undefined') {
						delete this._sharedWith.get(valueElement.innerHTML).edit;
					}
				}
			}
		}
		//this._updateSharingIsImage();
	},
	
	_findPeopleCallback: function(entry, result) {
		var inputElement = $('sharewithinputfield');
		inputElement.value = "";
		
		if (typeof entry !== 'undefined') {
			// Delete any sharedWith entry by value
			if (typeof entry.value !== 'undefined') {
				this._sharedWith.unset(entry.value);
			}
					
			// Check for possible double-entry
			if (typeof this._sharedWith.get("U" + result.id) != 'undefined') {
				if (typeof entry.divElement != 'undefined') {
					this._alert("\'" + entry.value + "\' is already on the share list.");
					entry.divElement.remove();
				}
			}
			// Copy only the first result
			else {
				// Set the new entry values.
				entry.type = 'username';
				entry.value = result.username;
				entry.id = result.id;
				entry.fname = result.fname;
				entry.lname = result.lname;
				
				// If the divElement has been created, need to replace it
				if (typeof entry.divElement != 'undefined') {
					var newElement = this._createShareWithEntryDivElement(entry);
					entry.divElement.update(newElement);
					entry.divElement = newElement;
		
					// Add entry back to sharedWith by id
					this._sharedWith.set("U" + entry.id, entry);	
				}
			}
		}
		else {
			if (this._createShareWithEntry(result.username, result.id, result.group) !== true) {
				this._alert("\'" + result.username + "\' is already on the share list.");
			}
		}
		//this._updateSharingIsImage();
	},

	_clickSearchForUnknownUsername: function(event) {
		var element = $(Event.element(event));
		if (element.up().siblings().length > 1) {
			var valueElement = element.siblings()[1];
			if (valueElement.innerHTML != "") {
				var entry = this._sharedWith.get(valueElement.innerHTML);
				this._findPeoplePopUp.show();
				this._findPeoplePopUp.search(valueElement.innerHTML, entry);
			}
		}
		Event.stop(event);
	},
	
	_userLookupCallback: function(request, entry) {
		// If no results, do nothing
		if (request.list.length < 1) {
			return;
		}
		
		// Delete any sharedWith entry by value
		this._sharedWith.unset(entry.value);
		
		// Check for possible double-entry
		if (typeof this._sharedWith.get("U" + entry.id) != 'undefined') {
			if (typeof entry.divElement != 'undefined') {
				this._alert("\'" + entry.value + "\' is already on the share list.");
				entry.divElement.remove();
			}
		}
		// Copy only the first result
		else {
			// If e-email, preserve the e-mail address for display purposes
			if (entry.type == 'email') {
				entry.value = request.list[0].username + " (" + entry.value + ")";
			}
			else {
				entry.value = request.list[0].username;
			}
			
			// Set the new entry values.
			entry.type = 'username';
			entry.id = request.list[0].id;
			entry.fname = request.list[0].fname;
			entry.lname = request.list[0].lname;
			
			// If the divElement has been created, need to replace it
			if (typeof entry.divElement != 'undefined') {
				var newElement = this._createShareWithEntryDivElement(entry);
				entry.divElement.replace(newElement);
				entry.divElement = newElement;
	
				// Add entry back to sharedWith by id
				this._sharedWith.set("U" + entry.id, entry);	
			}
		}
	},

	_createShareWithEntryDivElement: function(entry) {
		var divElement = new Element('div', { 'style': 'margin: 3px 0px 0px 0px; text-align: left; float: left; display: inline;' }).update(entry.value);
		var idElement = new Element('div', { 'style': 'display: none;' });
		if (typeof entry.id != 'undefined') {
			if (entry.type == 'username') {
				idElement.update("U" + entry.id);
			}
			else if ( entry.type == 'group') {
				idElement.update("G" + entry.id);
			}
			else {
				idElement.update(entry.value);
			}
		}
		else {
			idElement.update(entry.value);
		}
		var width = 128 - ((this._checkboxWidth - 12) * 2);
		var cbElement = new Element('input', { 'type': 'checkbox', 'name': 'view', 'value': '1', 'style': 'float: left; margin: 3px 4px 3px 0px; padding: 0px; width: 12px; height: 12px; display: inline;', 'title': '' });
		Event.observe(cbElement, 'click', this._clickRemoveShareWithEntry.bindAsEventListener(this));
		var element = new Element('div', { 'class': 'Smaller', 'style': 'margin: 0px 0px 0px 0px;  overflow: hidden; display: block; clear: both;' });
		element.appendChild(cbElement);
		element.appendChild(divElement);
		element.appendChild(idElement);
		var titleAttr = document.createAttribute("title");
	
		if (entry.type == 'email') {
			divElement.style.fontStyle = 'italic';
			titleAttr.value = "An e-mail will be sent to \'" + entry.value + "\' when you save your changes";
			var editElement = new Element('input', { 'type': 'checkbox', 'name': 'edit', 'value': '1', 'style': 'float: left; margin: 3px 0px 3px 4px; padding: 0px; width: 12px; height: 12px; display: inline;', 'title': ('Let \'' + entry.value + '\' make changes') });
			Event.observe(editElement, 'click', this._clickEditShareWithEntry.bindAsEventListener(this));
			var emailElement = new Element('img', { 'src': '/global/sharewithdropdown/images/email_will_be_sent.png', 'alt': '', 'title': titleAttr.value, 'style': 'float: left; margin: 3px 0px 3px 4px; display: inline;' });
			element.appendChild(emailElement);
			element.appendChild(editElement);
			width -= 20;
			if (typeof entry.edit !== 'undefined' && entry.edit === true) {
				editElement.checked = true;
				editElement.defaultChecked = true;
			}
		}
		else if (typeof entry.id == 'undefined') {
			divElement.style.color = 'red';
			titleAttr.value = "There is no KeepAndShare user with this username, Click to search KeepAndShare for \'" + entry.value + "\'";
			var questionElement = new Element('img', { 'src': '/global/sharewithdropdown/images/questionmark1.png', 'alt': '', 'style': 'float: left; margin: 3px 0px 3px 4px; display: inline;', 'title': titleAttr.value });
			element.appendChild(questionElement);
			Event.observe(questionElement, 'click', this._clickSearchForUnknownUsername.bindAsEventListener(this));
			Event.observe(divElement, 'click', this._clickSearchForUnknownUsername.bindAsEventListener(this));
			width -= 16;
		}
	
		divElement.style.width = width + 'px';
		divElement.style.overflow = 'hidden';
		divElement.setAttributeNode(titleAttr);
		
		cbElement.checked = true;
		cbElement.defaultChecked = true;
	
		return element;
	},

	_createShareWithEntry: function(value, id, group, edit) {
		var entry = null, isEmail = false;
	
		if (typeof id !== 'undefined') {
			if (typeof group !== 'undefined' && group === true) {
				entry = { 'type': 'group', 'value': value + "&nbsp;(Group)", 'id': id };
				if (typeof this._sharedWith.get("G" + id) !== 'undefined') {
					return false;
				}
			}
			else {
				var user = g_shareWithDropDownSearchArray.findId(id);
				if (user !== null) {
					entry = { 'type': 'username', 'value': user.username, 'id': user.id, 'fname': user.fname, 'lname': user.lname };
				}
				else {
					// This really shouldn't happen... do we need to have a way to lookup by ajax using peopleid??
					// var lookupRequest = new ShareWithAjaxUserLookup(value, 'username', userLookupCallback, entry);
				}
				if (typeof this._sharedWith.get("U" + id) !== 'undefined') {
					return false;
				}
			}
		}
		else {
			isEmail = validateEmail(value, false, false); // global/javascript/email_validate.js
			if (isEmail) {
			user = g_shareWithDropDownSearchArray.findEmail(value);
				if (user !== null) {
					entry = { 'type': 'username', 'value': user.username, 'id': user.id, 'fname': user.fname, 'lname': user.lname };
				}
				if (entry === null) {
					entry = { 'type': 'email', 'value': value };
				}
			}
			else {
				var user = g_shareWithDropDownSearchArray.findUsername(value);
				if (user !== null) {
					entry = { 'type': 'username', 'value': user.username, 'id': user.id, 'fname': user.fname, 'lname': user.lname };
				}
				else {
					entry = { 'type': 'username', 'value': value };
				}
			}
	
			if (entry !== null && typeof entry.id !== 'undefined') {
				if (typeof this._sharedWith.get("U" + entry.id) !== 'undefined') {
					return false;
				}
			}
			else {
				if (typeof this._sharedWith.get(value) !== 'undefined') {
					return false;
				}
				if (isEmail) {
					// Here is where we fire off the ajax request to lookup e-mail address
					var lookupRequest = new ShareWithAjaxUserLookup(value, 'email', this._userLookupCallback.bind(this), entry);
				}
				else {
					// Here is where we fire off the ajax request to lookup username
					var lookupRequest = new ShareWithAjaxUserLookup(value, 'username', this._userLookupCallback.bind(this), entry);
				}
							
				// If ShareWithAjaxUserLookup returns immediately, the entry.id will have been filled in and we will want to check it
				if (typeof entry.id !== 'undefined' && typeof this._sharedWith.get("U" + entry.id) !== 'undefined') {
					return false;
				}
			}
		}
		
		if (typeof edit !== 'undefined' && edit === true) {
			entry.edit = true;
		}
	
		if (typeof entry.id !== 'undefined') {
			if ( entry.type == 'username' ) {
				this._sharedWith.set("U" + entry.id, entry);
			}
			else if ( entry.type == 'group' ) {
				this._sharedWith.set("G" + entry.id, entry);
			}
			else {
				this._sharedWith.set(entry.value, entry);
			}
		}
		else {
			this._sharedWith.set(entry.value, entry);
		}
	
		entry.divElement = this._createShareWithEntryDivElement(entry);
		$('sharewithsettings').appendChild(entry.divElement);
		
		return true;
	},

	_shareWithInputBoxDropDownCallback: function(id, result) {
		var inputElement = $(id);
		if (typeof result === 'undefined') {
			if (this._createShareWithEntry(inputElement.value) !== true) {
				this._alert("\'" + inputElement.value + "\' is already on the share list.");
			}
			else {
				inputElement.value = "";
				setTimeout(function() { inputElement.focus(); }, 0);
			}
		}
		else {
			if (this._createShareWithEntry(result.username, result.id, result.group) !== true) {
				this._alert("\'" + result.username + "\' is already on the share list.");
			}
			else {
				inputElement.value = "";
				setTimeout(function() { inputElement.focus(); }, 0);
			}
		}
	},

	_showFriendsWithInputBoxPopupInstructionsTimer: null,

	_showFriendsWithInputBoxPopupInstructions: function() {
		if ($('sharewithinputfield').value == '') {
			this._instructionsHint.show();
		}
		else {
			this._delayShowFriendsWithInputBoxPopupInstructions();
		}
	},
	
	_delayShowFriendsWithInputBoxPopupInstructions: function() {
		if (this._showFriendsWithInputBoxPopupInstructionsTimer !== null) {
			window.clearTimeout(this._showFriendsWithInputBoxPopupInstructionsTimer);
		}
		this._showFriendsWithInputBoxPopupInstructionsTimer = window.setTimeout(this._showFriendsWithInputBoxPopupInstructions.bind(this), '2000');
	},
	
	_focusSetToFriendsWithInputBox: function(event) {
		// Show popup instruction box
		this._delayShowFriendsWithInputBoxPopupInstructions();
	},
	
	_hideFriendsWithInputBoxPopupInstructions: function() {
		if (this._showFriendsWithInputBoxPopupInstructionsTimer !== null) {
			window.clearTimeout(this._showFriendsWithInputBoxPopupInstructionsTimer);
			this._showFriendsWithInputBoxPopupInstructionsTimer = null;
		}
		this._instructionsHint.hide();
	},
	
	_focusRemovedFromFriendsWithInputBox: function(event) {
		// Hide popup instruction box
		this._hideFriendsWithInputBoxPopupInstructions();
	},
	
	_shareWithPopupCallbackForInputBox: function(username, result) {
		var inputElement = $('sharewithinputfield');
		inputElement.value = result.username;
		this._shareWithInputBoxDropDownCallback(inputElement.identify(), result);
	},
	
	_clickShowFriends: function(event) {
		g_friendsWithPopUp.showFriends();
	},
	
	_clickShowManageGroups: function(event) {
		g_friendsWithPopUp.showManageGroups();
	},
	
	_clickShowFindPeople: function(event) {
		var inputElement = $('sharewithinputfield');
		this._findPeoplePopUp.show();
		if (inputElement.value != "") {
				this._findPeoplePopUp.search(inputElement.value);
		}
	},

	_setFriendView: function(on) {
		if (on === false) {
			this._sharedWith.unset("G" + g_shareWithDropDownSearchArray.getFriendListGroupId());
		}
		else {
			this._sharedWith.set("G" + g_shareWithDropDownSearchArray.getFriendListGroupId(), { 'type': 'group', 'value': 'All My Friends', 'id': g_shareWithDropDownSearchArray.getFriendListGroupId() });
		}
	},
	
	_friendViewCheckboxClicked: function(event) {
		var element = $(Event.element(event));
		if (! element.checked) {
			this._setFriendView(false);
		}
		else {
			this._setFriendView(true);
		}
	},

	_createFriendsWithInputBox: function() {
		var linkElement;
		var inputElement = new Element('input', { 'type': 'text', 'value': '', 'id': 'sharewithinputfield', 'size': '14', 'style': 'position: relative;', 'autocomplete': 'off' });
		Event.observe(inputElement, 'change', this._changeFriendsWithInputBox.bindAsEventListener(this));
		Event.observe(inputElement, 'focus', this._focusSetToFriendsWithInputBox.bindAsEventListener(this));
		Event.observe(inputElement, 'blur', this._focusRemovedFromFriendsWithInputBox.bindAsEventListener(this));
		Event.observe(inputElement, 'keydown', this._keyDownHandlerFriendsWithInputBox.bindAsEventListener(this));
		Event.observe(inputElement, 'keypress', this._keyPressHandlerFriendsWithInputBox.bindAsEventListener(this));
		
		$('sharewithsettings').show();
		if ($('sharewithsettings').childElements().length < 2) {
			var divElement;
		
			divElement = new Element('div', { 'style': 'width: 128px; margin: 3px 0px 0px 0px; text-align: left; float: left; display: inline;' });
			divElement.style.width = '160px';
			divElement.style.fontWeight = 'bold';
			divElement.update('All My Friends');
			var element = new Element('div', { 'class': 'Smaller', 'style': 'margin: 0px 0px 0px 0px;  overflow: hidden; display: block;' });
			element.appendChild(this._friendView = new Element('input', { 'type': 'checkbox', 'id': 'friendview', 'name': 'view', 'value': '1', 'style': 'float: left; margin: 3px 4px 3px 0px; padding: 0px; width: 12px; height: 12px; display: inline;', 'title': '' }));
			element.appendChild(divElement);
			$('sharewithsettings').appendChild(element);
			Event.observe(this._friendView, 'click', this._friendViewCheckboxClicked.bindAsEventListener(this));
		}
	

		$('sharewithinput').hide();
		$('sharewithinput').appendChild(inputElement);
		this._instructionsHint = new Hint(inputElement, "Type a friend\'s name, a group name, or a username.", "right");
		$('sharewithinput').appendChild(new Element('br'));
		$('sharewithinput').appendChild(linkElement = new Element('a', { 'href': '#', 'class': 'Smaller' }).update('Friends'));
		Event.observe(linkElement, 'click', this._clickShowFriends.bindAsEventListener(this));
		$('sharewithinput').appendChild(new Element('span').update('&nbsp;|&nbsp;'));
		$('sharewithinput').appendChild(linkElement = new Element('a', { 'href': '#', 'class': 'Smaller' }).update('Groups'));
		Event.observe(linkElement, 'click', this._clickShowManageGroups.bindAsEventListener(this));
		$('sharewithinput').appendChild(new Element('span').update('&nbsp;|&nbsp;'));
		$('sharewithinput').appendChild(linkElement = new Element('a', { 'href': '#', 'class': 'Smaller' }).update('Find Friends'));
		Event.observe(linkElement, 'click', this._clickShowFindPeople.bindAsEventListener(this));
		$('sharewithinput').show();
	
	
		this._dropdown = new ShareWithDropDown(inputElement.identify(), this._shareWithInputBoxDropDownCallback.bind(this), this._clickShowFindPeople.bind(this));
		this._dropdown.onShow = this._hideFriendsWithInputBoxPopupInstructions.bind(this);
		this._dropdown.onHide = this._delayShowFriendsWithInputBoxPopupInstructions.bind(this);
		this._sharingIsOn = true;
	},

	loadFriendSettings: function(string) {
		while ($('sharewithsettings').childElements().length > 0) {
			$('sharewithsettings').childElements()[$('sharewithsettings').childElements().length - 1].remove();
		}
		while ($('sharewithinput').childElements().length > 0) {
			$('sharewithinput').childElements()[$('sharewithinput').childElements().length - 1].remove();
		}

		this._sharedWith.each(function(pair) {
			this._sharedWith.unset(pair.key);
		}.bind(this));
		if (string !== null && string != '' && string != '{}' && string != '[]') {
			var input = new Hash(string.evalJSON());
			if (input.keys().length > 0) {
				this._createFriendsWithInputBox();
				//var publicSeen = false;
				var friendSeen = false;
				input.each(function(pair) {
					if (pair.value.type === 'group' && typeof pair.value.friendlistgroup !== 'undefined' && pair.value.friendlistgroup === true) {
						friendSeen = true;
						g_shareWithDropDownSearchArray.setFriendListGroupId(pair.value.id);
						this._setFriendView(true);
						if (typeof this._friendView !== 'undefined') {
							this._friendView.checked = true;
						}
						if (typeof pair.value.edit !== 'undefined' && pair.value.edit === true) {
							this._setFriendEdit(true);
							if (typeof this._friendEdit !== 'undefined') {
								this._friendEdit.checked = true;
							}
							else {
								this._friendEdit.checked = false;
							}
						}
					}
					else {
						if (pair.value.type !== 'group') {
							g_shareWithDropDownSearchArray.addEntry( { "id": pair.value.id, "username": pair.value.value, "fname": pair.value.fname, "lname": pair.value.lname } );
						}
						this._createShareWithEntry(pair.value.value, pair.value.id, pair.value.type === 'group', pair.value.edit);
					}
				}.bind(this));
				if (friendSeen === false) {
					if (typeof this._friendView !== 'undefined') {
						this._friendView.checked = false;
					}
				}
			}
		}
		else {
			this._createFriendsWithInputBox();
		}
	},
	
	saveFriendSettings: function() {
		if (this._sharingIsOn === true) {
			return this._sharedWith.toJSON();
		}
		else {
			return '{}';
		}
	},
	
	initialize: function(elementToReplace, shareSettings) {
		this._showingAlertBox = false;
		this._checkboxWidth = 12;
		this._sharedWith = new Hash();
		this._findPeoplePopUp = new FindPeoplePopUp(FindPeopleModes.ADD_TO_SHARE, this._findPeopleCallback.bind(this));
		
		if (g_friendsWithPopUp === null) {
			g_friendsWithPopUp = new ShareWithPopUp(this._shareWithPopupCallbackForInputBox.bind(this));
		}
		
		var divElement = new Element('div', {'id': 'sharewith', 'style': 'textl-align:left;margin: 0 auto; width:240px; padding: 4px 2px; position: relative'});
		divElement.insert(new Element('div', {'id': 'sharewithsettings', 'style': 'text-align: left; position: relative; clear: both;;height:200px;overflow:auto;border:1px solid silver;padding-left:4px;margin-left:20px'}));
		divElement.insert(new Element('div', {'id': 'sharewithinput', 'style': 'text-align: left; position: relative; display: block; clear: both;margin-top:6px;margin-left:20px'}));
		elementToReplace.replace(divElement);
		
		if (typeof shareSettings !== 'undefined') {
			this.loadFriendSettings(shareSettings);
		}
		else {
			this._createFriendsWithInputBox();
		}
	}
});

