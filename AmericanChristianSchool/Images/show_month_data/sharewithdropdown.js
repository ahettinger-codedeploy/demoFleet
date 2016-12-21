/* sharewithdropdown.js
 * Implementation of a drop-down list for the "share with" username boxes
 *
 * Requirements:
 *     the prototype library must be loaded before this script is loaded
 */

// From modalbox.js
if (typeof Prototype.Browser.Version === 'undefined') {
	if (Prototype.Browser.IE) {
		var ua = new String(navigator.userAgent);
		var offset = ua.indexOf("MSIE ");
		Prototype.Browser.Version = parseFloat(ua.substring(offset + 5, ua.indexOf(";", offset)));
	}
}

var ModalBoxShading = Class.create({
	_setSize: function() {
		var dim = document.viewport.getDimensions();
		if (Prototype.Browser.WebKit) {
			dim.width = document.body.scrollWidth;
			dim.height = document.body.scrollHeight;
		}
		else if (Prototype.Browser.IE && Prototype.Browser.Version < 7.0) {
			dim.width = Math.max(document.documentElement.clientWidth, document.body.clientWidth);
			dim.height = Math.max(document.documentElement.scrollHeight, document.body.scrollHeight);
		}
		else {
			dim.width = Math.max(dim.width, document.documentElement.offsetWidth);
			dim.height = Math.max(dim.height, document.documentElement.offsetHeight);
		}
		if (this._element.offsetHeight != dim.height) {
			this._element.style.height = dim.height + 'px';
		}
		if (this._element.offsetWidth != dim.width) {
			this._element.style.width = dim.width + 'px';
		}
	},
	_eventOnResize: function(e) {
		this._setSize();
		return;
	},
	_eventOnLoad: function(e) {
		document.body.appendChild(this._element);
		this._loaded = true;
		if (this._showOnLoad === true) {
			this._showOnLoad = false;
			this.show();
		}
	},
	setZIndex: function(zIndex) {
		if (typeof zIndex !== 'undefined') {
			this._element.style.zIndex = zIndex;
		}
		else {
			this._element.style.zIndex = 100000;
		}
	},
	initialize: function(zIndex) {
		this._loaded = false;
		this._showOnLoad = false;
		
		this._element = new Element('div');
		this._element.style.backgroundColor = '#000';
		this._element.setOpacity(0.3);
		this.setZIndex(zIndex);
		if (Prototype.Browser.IE && Prototype.Browser.Version < 7.0) {
			this._element.style.position = 'absolute';
		}
		else {
			this._element.style.position = 'fixed';
		}
		this._element.style.display = 'none';
		this._element.style.margin = '0px';
		this._element.style.padding = '0px';
		this._element.style.top = '0px';
		this._element.style.left = '0px';
		this._element.style.bottom = '0px';
		this._element.style.right = '0px';
		
		Event.observe(window, 'resize', this._eventOnResize.bindAsEventListener(this));
		if (document.loaded) {
			this._eventOnLoad.bind(this).defer();
		}
		else {
			Event.observe(window, 'load', this._eventOnLoad.bindAsEventListener(this));
		}
	},
	show: function() {
		if (this._loaded === false) {
			this._showOnLoad = true;
		}
		else {
			this._setSize();
			this._element.show();
		}
	},
	hide: function() {
		if (this._loaded === false) {
			this._showOnLoad = false;
		}
		else {
			this._element.hide();
		}
	}
});

var ModalBox = Class.create({
	_setPosition: function() {
		var dim = this._element.getDimensions();
		this._element.style.top = (typeof this._top !== 'undefined') ? this._top : Math.max(0, document.body.parentNode.clientHeight / 2 - dim.height / 2) + 'px';
		this._element.style.left = (typeof this._left !== 'undefined') ? this._left: Math.max(0, document.body.parentNode.clientWidth / 2 - dim.width / 2) + 'px';
	},
	_eventOnResize: function(e) {
		this._setPosition();
	},
	_eventOnLoad: function(e) {
		document.body.appendChild(this._element);
		this._element.appendChild(this._content);
		this._loaded = true;
		if (this._showOnLoad === true) {
			this._showOnLoad = false;
			this.show();
		}
	},
	initialize: function(content, top, left) {
		this._loaded = false;
		this._showOnLoad = false;
		
		this._element = new Element('div');
		this._element.style.zIndex = 1000001;
		if (Prototype.Browser.IE && Prototype.Browser.Version < 7.0) {
			this._element.style.position = 'absolute';
		}
		else {
			this._element.style.position = 'fixed';
		}
		this._element.style.display = 'none';
		this._element.style.margin = '0px';
		this._element.style.padding = '0px';
		
		this._content = content;
		this._content.show();
		
		this._top = top;
		this._left = left;
		
		this._shading = new ModalBoxShading();

		Event.observe(window, 'resize', this._eventOnResize.bindAsEventListener(this));
		if (document.loaded) {
			this._eventOnLoad.bind(this).defer();
		}
		else {
			Event.observe(window, 'load', this._eventOnLoad.bindAsEventListener(this));
		}
	},
	show: function() {
		if (this._loaded === false) {
			this._showOnLoad = true;
		}
		else {
			this._setPosition();
			this._shading.show();
			this._element.show();
		}
	},
	hide: function() {
		if (this._loaded === false) {
			this._showOnLoad = false;
		}
		else {
			this._element.hide();
			this._shading.hide();
		}
	}
});

// "firebug" fake code for when we are not running under firebug or a browser
// than emulates firebug's console.log() function
if (!("console" in window) || !("log" in console)) {
	if (!("console" in window)) {
		window.console = {};
	}
	if (!("log" in console)) {
		window.console["log"] = function(){};
	}
}

// This is a base class that implements most of the "common"
// case ajax code for all of our share with ajax requests.
var ShareWithAjaxRequestCommon = Class.create(Ajax.Request, {
	addReadyCallback: function(callback) {
		if (!Object.isFunction(callback)) {
			return;
		}
		this.readycallbacklist.push(callback);
	},
	deleteReadyCallback: function(callback) {
		if (!Object.isFunction(callback)) {
			return;
		}
		if (typeof this.readycallbacklist != "undefined") {
			this.readycallbacklist = this.readycallbacklist.without(callback);
		}
	},
	ready: function() {
		return (this.requestInProgress === false);
	},
	callReadyCallbacks: function(success) {
		this.readycallbacklist.each(function(f) { f(this, success); }, this);
	},
	handleResponse: function(response) {
	},
	onsuccess: function(transport) {
		this.requestInProgress = false;
		if (transport && transport.responseJSON && transport.responseJSON.result && transport.responseJSON.result == "OK") {
			this.handleResponse(transport.responseJSON);
			this.callReadyCallbacks(true);
		}
		else {
			this.callReadyCallbacks(false);
		}
	},
	onfailure: function() {
		this.requestInProgress = false;
		this.callReadyCallbacks(false);
	},
	onexception: function(requestor, exception) {
		this.requestInProgress = false;
		console.log("ShareWithAjaxRequestCommon::onexception: " + requestor + ", " + exception);
	},
	initialize: function($super, url, params, callback) {
		this.readycallbacklist = new Array();
		this.addReadyCallback(callback);
		this.requestInProgress = true;
		this.params = params;
		$super(url, {
			parameters: this.params,
			onSuccess: this.onsuccess.bind(this),
			onFailure: this.onfailure.bind(this),
			onException: this.onexception.bind(this)
		});
	}
});

// Main share with drop down search array class, which is part AJAX request class
// and part data manager for all data related to friends/visited/sharedwith/and 
// found people.
var ShareWithDropDownSearchArray = Class.create(ShareWithAjaxRequestCommon, {
	ready: function($super) {
		return ($super() && this.list !== null);
	},
	callReadyCallbacks: function($super, success) {
		if (success) {
			$super(success);
		}
	},
	addChangeCallback: function(callback) {
		if (!Object.isFunction(callback)) {
			return;
		}
		this.changecallbacklist.push(callback);
	},
	callChangeCallbacks: function() {
		this.changecallbacklist.each(function(f) { f(this); }, this);
	},
	_createInternalDataStructures: function() {
		// Create internal data structures
		this.idhash = new Hash();
		this.usernamehash = new Hash();
		this.friendlist = new Array();
		this.visitedlist = new Array();
		this.sharedwithlist = new Array();
		this.list = new Array();
		this._groupidhash = new Hash();
		this.grouplist = new Array();
		this.readycallbacklist = new Array();
		this.changecallbacklist = new Array();
		this.friendlistgroupid = 0;
	},
	_addEntry: function(entry) {
		if (typeof this.idhash.get(entry.id) == 'undefined') {
			entry.viewergroups = new Array();
			entry.editorgroups = new Array();
			entry.vieweruser = 0;
			entry.editoruser = 0;
			if (typeof entry.groups == 'undefined') {
				entry.groups = new Array();
			}

			this.idhash.set(entry.id, entry);
			this.usernamehash.set(entry.username, entry);
			this.list.push(entry);

			if (entry.type == 'friend') {
				this.friendlist.push(entry);
			}
			else if (entry.type == 'visited') {
				this.visitedlist.push(entry);
			}
			else if (entry.type == 'sharedwith') {
				this.sharedwithlist.push(entry);
			}

			for (var i = 0; i < entry.groups.length; i++) {
				var group = this._groupidhash.get(entry.groups[i]);
				if (typeof group == "undefined") {
					// This shouldn't happen
					console.log("Bad groupid (" + entry.groups[i] + ") detected in entry record (id=" + entry.id + ", username=\"" + entry.username + "\")", entry);
					continue;
				}
//				if (typeof group.members == "undefined") {
//					group.members = new Array();
//				}
				group.members.push(entry);
			}
		}
		else {
			var curEntry = this.idhash.get(entry.id);
			var keys = Object.keys(entry);
			for (var i = 0; i < keys.length; i++) {
				if (keys[i] == 'groups') {
					for (var j = 0; j < entry.groups.length; j++) {
						var group = this._groupidhash.get(entry.groups[j]);
						if (typeof group == "undefined") {
							// This shouldn't happen
							console.log("Bad groupid (" + entry.groups[j] + ") detected in entry record (id=" + entry.id + ", username=\"" + entry.username + "\")", entry);
							continue;
						}
//						if (typeof group.members == "undefined") {
//							group.members = new Array();
//						}
						if (group.members.indexOf(entry.groups[j]) < 0) {
							group.members.push(curEntry);
						}
					}
					for (var j = 0; j < curEntry.groups.length; j++) {
						if (entry.groups.indexOf(curEntry.groups[j]) < 0) {
							var group = this._groupidhash.get(curEntry.groups[j]);
							if (group.members.indexOf(curEntry) >= 0) {
								group.members.splice(group.members.indexOf(curEntry), 1);
							}
						}
					}
				}
				if (keys[i] == 'username') {
					if (curEntry[keys[i]] != entry[keys[i]]) {
						this.usernamehash.unset(curEntry[keys[i]]);
						this.usernamehash.set(entry[keys[i]], curEntry);
					}											
				}
				if (keys[i] == 'type') {
					if (curEntry[keys[i]] != entry[keys[i]]) {
						var removeList = null, addList = null;
						if (typeof curEntry[keys[i]] !== "undefined") {
							if (curEntry[keys[i]] == 'friend') {
								removeList = this.friendlist;
							}
							if (curEntry[keys[i]] == 'visited') {
								removeList = this.visitedlist;
							}
							if (curEntry[keys[i]] == 'sharedwith') {
								removeList = this.sharedwithlist;
							}
						}
						if (typeof entry[keys[i]] !== "undefined") {
							if (entry[keys[i]] == 'friend') {
								addList = this.friendlist;
							}
							if (entry[keys[i]] == 'visited') {
								addList = this.visitedlist;
							}
							if (entry[keys[i]] == 'sharedwith') {
								addList = this.sharedwithlist;
							}
						}
						if (removeList != null) {
							index = removeList.indexOf(curEntry);
							if (index >= 0) {
								removeList.splice(index, 1);
							}
						}
						if (addList != null) {
							addList.push(curEntry);
						}
					}
				}
				curEntry[keys[i]] = entry[keys[i]];
			}
		}
	},
	addEntry: function(entry) {
		this._addEntry(entry);
		this.callChangeCallbacks();
	},
	deleteEntryById: function(id) {
		var entry = this.idhash.get(id);
		if (typeof entry === 'undefined') {
			return;
		}
		
		// Remove from the hashes
		this.idhash.unset(id);
		this.usernamehash.unset(entry.username);

		// Remove from the master list
		var index = this.list.indexOf(entry);
		if (index >= 0) {
			this.list.splice(index, 1);
		}
		
		// Remove from any type-based list
		var removeList = null;
		if (entry.type == "friend") {
			removeList = this.friendlist;
		}
		if (entry.type == "visited") {
			removeList = this.visitedlist;
		}
		if (entry.type == "sharedwith") {
			removeList = this.sharedwithlist;
		}
		if (removeList !== null) {
			index = removeList.indexOf(entry);
			if (index >= 0) {
				removeList.splice(index, 1);
			}
		}
		
		// Remove from any group membership lists
		for (var i = 0; i < entry.groups.length; i++) {
			var group = this._groupidhash.get(entry.groups[i]);
			if (typeof group == "undefined") {
				// This shouldn't happen
				console.log("Bad groupid (" + entry.groups[i] + ") detected in entry record (id=" + entry.id + ", username=\"" + entry.username + "\")", entry);
				continue;
			}
			if (typeof group.members != "undefined") {
				index = group.members.indexOf(entry);
				if (index >= 0) {
					group.members.splice(index, 1);
				}
			}
		}

		// Lastly, update any records.
		this.callChangeCallbacks();
	},
	_addGroup: function(group) {
		if (typeof group.members == 'undefined') {
			group.members = new Array();
		}
		if (typeof this._groupidhash.get(group.value) == 'undefined') {
			this._groupidhash.set(group.value, group);
			this.grouplist.push(group);
		}
	},
	addGroup: function(group) {
		this._addGroup(group);
		this.callChangeCallbacks();
	},
	deleteGroupById: function(groupid) {
		var group = this._groupidhash.get(groupid);
		if (typeof group == 'undefined') {
			return;
		}
		
		// Remove the group from each member's list of groups
		group.members.each(function(member) {
			var index = member.groups.indexOf(group.value);
			if (index >= 0) {
				member.groups.splice(index, 1);
			}
		});
		
		// Empty out the groups array
		group.members.splice(0, group.members.length);
		
		// Remove the group from the internal data structures
		this._groupidhash.unset(groupid);
		var index = this.grouplist.indexOf(group);
		if (index >= 0) {
			this.grouplist.splice(index, 1);
		}

		// Call the change callbacks
		this.callChangeCallbacks();
	},
	findId: function(id) {
		var result;
		result = this.idhash.get(id);
		if (typeof result == "undefined") {
			return null;
		}
		return result;
	},
	findUsername: function(username) {
		var result;
		result = this.usernamehash.get(username);
		if (typeof result == "undefined") {
			return null;
		}
		return result;
	},
	friends: function() {
		return this.friendlist;
	},
	visited: function() {
		return this.visitedlist;
	},
	sharedwith: function() {
		return this.sharedwithlist;
	},
	groups: function() {
		return this.grouplist;
	},
	setFriendListGroupId: function(friendlistgroupid) {
		this.friendlistgroupid = friendlistgroupid;
	},
	getFriendListGroupId: function() {
		return this.friendlistgroupid;
	},
	handleResponse: function(response) {
		if (typeof response.friendlistgroupid !== 'undefined') {
			this.friendlistgroupid = response.friendlistgroupid;
		}
		if (self.location.search.indexOf("debugNoFriends=1") < 0) {
			if (typeof response.groups !== 'undefined') {
				for (var j = 0; j < response.groups.length; j++) {
					this._addGroup(response.groups[j]);
				}
			}
			for (var i = 0; i < response.results.length; i++) {
				this._addEntry(response.results[i]);
			}
		}
		this.callChangeCallbacks();
	},
	initialize: function($super, app) {
		this._createInternalDataStructures();
		var params = {};
		if (typeof app !== 'undefined') {
			params = { app: app };
		}
		$super('/global/sharewithdropdown/sharewithdropdownsearcharray.php', params);
	},
	changeGroupName: function(index, newName) {
		this.grouplist[index].sharegroupname = newName;
		this.callChangeCallbacks();
	},
	searchCheck: function(value, needles, needlematches) {
		var result = { match: "", score: 0 };
		var matchedPositions = new Array();
		
		// Error checking to guard against bad data
		if (typeof value == 'undefined' || value == null)
			return result;

		// Check value agains all the needles
		var haystack = value.toLowerCase();
		needles.each(function (needle, index) {
			var index1 = haystack.indexOf(needle);
			if (index1 >= 0) {
				needlematches[index] = 1;
				var score = (needle.length * 10.0 ) / value.length +
							(100.0 * (value.length - index1)) / value.length;
				result.score += score;
				for (var index2 = 0; index2 < needle.length; index2++) {
					matchedPositions[index1 + index2] = 1;
				}
			}
		});
		if (result.score == 0.0) {
			result.match = value;
		}
		else {
			var isBold = false;
			for (var index1 = 0; index1 < value.length; index1++) {
				if (matchedPositions[index1] == 1 && !isBold) {
					result.match += "<b>";
					isBold = true;
				}
				else if (matchedPositions[index1] != 1 && isBold) {
					result.match += "</b>";
					isBold = false;
				}
				result.match += value.substr(index1, 1);
			}
			if (isBold) {
				result.match += "</b>";
			}
		}
		
		return result;
	},
	search: function(needle) {
		var results = [], i, j;

		// Return an empty list under certain conditions
		if (!this.ready() || this.list.length < 1) {
			return [];
		}
			
		// Make needle lower case
		needle = needle.toLowerCase();
		
		// Split needle up into seperate parts... split by commas and spaces
		var myNeedleRegex = /[ ,]/;
		var mySpaceRegex = / /g;
		var needles = needle.split(myNeedleRegex);
		if (needles.length < 1) {
			return [];
		}

		// Make sure any remaining spaces or commas are trimmed from each needle
		// and remove any empty needles
		for (i = 0; i < needles.length && needles.length > 0; ) {
			needles[i] = needles[i].replace(mySpaceRegex, "");
			if (needles[i].length == 0) {
				needles.splice(i, 1);
			}
			else {
				i++;
			}
		}
		
		// If there are no remaining needles, return the empty set.
		if (needles.length == 0)
			return [];

		// Go through every entry in the list looking for matches
		for (i = 0; i < this.list.length; i++) {
			var score = 0.0, needlematches = [];
			
			// Check username agains all the needles
			var usernameResult = this.searchCheck(this.list[i].username, needles, needlematches);
			score = score + usernameResult.score;
			
			// Check fname name
			var fnameResult = this.searchCheck(this.list[i].fname, needles, needlematches);
			score = score + fnameResult.score;
			
			// Check lname name
			var lnameResult = this.searchCheck(this.list[i].lname, needles, needlematches);
			score = score + lnameResult.score;
			
			// If score > 0, we found something.  We must have found ALL the needles as well
			if ( score > 0.0 ) {
				for (j = 0; j < needles.length; j++) {
					if (needlematches[j] != 1) {
						break;
					}
				}
				if (j == needles.length) {
					results[results.length] = { score: score, username: this.list[i].username, usernameMatch: usernameResult.match, fname: this.list[i].fname, fnameMatch: fnameResult.match, lname: this.list[i].lname, lnameMatch: lnameResult.match, id: this.list[i].id, group: false };
				}
			}
		}

		// Go through all of the groups also looking for matches
		for (i = 0; i < this.grouplist.length; i++) {
			var score = 0.0, needlematches = [];
			
			// Check username agains all the needles
			var groupnameResult = this.searchCheck(this.grouplist[i].sharegroupname, needles, needlematches);
			score = groupnameResult.score;
			
			// If score > 0, we found something.  We must have found ALL the needles as well
			if ( score > 0.0 ) {
				for (j = 0; j < needles.length; j++) {
					if (needlematches[j] != 1) {
						break;
					}
				}
				if (j == needles.length) {
					results[results.length] = { score: score, username: this.grouplist[i].sharegroupname, usernameMatch: groupnameResult.match, fname: '', fnameMatch: '(Group)', lname: '', lnameMatch: '', id: this.grouplist[i].value, group: true };
				}
			}
		}

		// Sort the results by score, then by username
		results.sort(function(a, b) {
			if (a.score > b.score) {
				return -1;
			}
			if (a.score < b.score) {
				return 1;
			}
			if (a.username > b.username) {
				return 1;
			}
			if (a.username < b.username) {
				return -1;
			}
			return 0;
		});
		
		// Return the results
		return results;
	}
});

var g_shareWithDropDownSearchArray = null;

var ShareWithAjaxFindFriends = Class.create(ShareWithAjaxRequestCommon, {
	ready: function($super) {
		return ($super() && this.list !== null);
	},
	callReadyCallbacks: function($super, success) {
		if (success) {
			$super(success);
		}
	},
	handleResponse: function(response) {
		this.list = response.results;
		g_shareWithAjaxFindFriendsCache[this.cacheKey] = this.list;
		if (typeof g_shareWithDropDownSearchArray != "undefined" && g_shareWithDropDownSearchArray !== null) {
			this.list.each(function(entry) { g_shareWithDropDownSearchArray.addEntry(entry); });
		}
	},
	initialize: function($super, searchValue, startValue, readyCallback) {
		this.list = null;
		this.searchValue = searchValue;
		this.startValue = startValue;
		this.cacheKey = searchValue + "+" + startValue;
		this.cacheKey = this.cacheKey.toLowerCase();
		if (typeof g_shareWithAjaxFindFriendsCache == "undefined") {
			g_shareWithAjaxFindFriendsCache = new Object();
		}			
		if (typeof g_shareWithAjaxFindFriendsCache[this.cacheKey] != "undefined") {
			this.list = g_shareWithAjaxFindFriendsCache[this.cacheKey];
			this.requestInProgress = false;
			if (Object.isFunction(readyCallback)) {
				readyCallback(this);
			}
		}
		else {
			$super('/global/sharewithdropdown/sharewithajaxfindfriends.php', { searchValue: searchValue, start: startValue }, readyCallback);
		}
	}
});																								

var ShareWithAjaxRenameGroup = Class.create(ShareWithAjaxRequestCommon, {
	initialize: function($super, group, newName, readyCallback) {
		$super('/global/sharewithdropdown/sharewithajaxrenamegroup.php', { group: group, name: newName }, readyCallback);
	}
});																								

var ShareWithAjaxCreateGroup = Class.create(ShareWithAjaxRequestCommon, {
	callReadyCallbacks: function(success) {
		this.readycallbacklist.each(function(f) { f(this, success, this.groupid); }, this);
	},
	handleResponse: function(response) {
		this.groupid = response.groupid;
	},
	initialize: function($super, name, members, readyCallback) {
		$super('/global/sharewithdropdown/sharewithajaxcreategroup.php', { name: name, members: members.join(",") }, readyCallback);
	}
});																								

var ShareWithAjaxDeleteGroup = Class.create(ShareWithAjaxRequestCommon, {
	initialize: function($super, group, readyCallback) {
		$super('/global/sharewithdropdown/sharewithajaxdeletegroup.php', { group: group }, readyCallback);
	}
});																								

var ShareWithAjaxUpdateGroupMembership = Class.create(ShareWithAjaxRequestCommon, {
	initialize: function($super, group, members, readyCallback) {
		$super('/global/sharewithdropdown/sharewithajaxupdategroup.php', { group: group, members: members.join(",") }, readyCallback);
	}
});																								

var ShareWithAjaxAddFriend = Class.create(ShareWithAjaxRequestCommon, {
	callReadyCallbacks: function(success) {
		this.readycallbacklist.each(function(f) { f(this, success, this.groupid); }, this);
	},
	handleResponse: function(response) {
		this.groupid = response.groupid;
	},
	initialize: function($super, params, readyCallback) {
		$super('/global/sharewithdropdown/sharewithajaxaddfriend.php', params, readyCallback);
	}
});																								

var ShareWithAjaxDeleteFriends = Class.create(ShareWithAjaxRequestCommon, {
	initialize: function($super, deleteids, readyCallback) {
		$super('/global/sharewithdropdown/sharewithajaxdeletefriends.php', { deleteids: deleteids.join(",") }, readyCallback);
	}
});																								

var ShareWithAjaxIgnoreSubscription = Class.create(ShareWithAjaxRequestCommon, {
	initialize: function($super, params, readyCallback) {
		$super('/global/sharewithdropdown/sharewithajaxignoresubscription.php', params, readyCallback);
	}
});

var ShareWithAjaxUserLookup = Class.create(ShareWithAjaxRequestCommon, {
	ready: function($super) {
		return ($super() && this.list !== null);
	},
	callReadyCallbacks: function(success) {
		if (success) {
			this.readycallbacklist.each(function(f) { f(this, this.entry); }, this);
		}
	},
	handleResponse: function(response) {
		this.list = response.results;
		g_shareWithAjaxUserLookupCache[this.cacheKey] = this.list;
		if (typeof g_shareWithDropDownSearchArray != "undefined" && g_shareWithDropDownSearchArray !== null) {
			this.list.each(function(entry) { g_shareWithDropDownSearchArray.addEntry(entry); });
		}
	},
	initialize: function($super, searchValue, type, readyCallback, entry) {
		this.list = null;
		this.searchValue = searchValue;
		this.type = type;
		this.entry = entry;
		this.cacheKey = searchValue + "+" + type;
		this.cacheKey = this.cacheKey.toLowerCase();
		if (typeof g_shareWithAjaxUserLookupCache == "undefined") {
			g_shareWithAjaxUserLookupCache = new Object();
		}			
		if (typeof g_shareWithAjaxUserLookupCache[this.cacheKey] != "undefined") {
			this.list = g_shareWithAjaxUserLookupCache[this.cacheKey];
			if (Object.isFunction(readyCallback)) {
				readyCallback(this, this.entry);
			}
		}
		else {
			$super('/global/sharewithdropdown/sharewithajaxuserlookup.php', { searchValue: searchValue, type: type }, readyCallback);
		}
	}
});

var Hint = Class.create({
	initialize: function(element, message, position, autoFade) {
		this.message = message;
		this.attachedElement = $(element);
		if (typeof position != 'undefined') {
			var map = {
				"below": "under",
				"bottom": "under",
				"above": "over",
				"top": "over",
				"left": "left",
				"right": "right"
			};
			this.position = map[position.toLowerCase()];
		}
		if (typeof position == 'undefined') {
			this.position = 'under';
		}
		this.position = this.position.slice(0, 1).toUpperCase() + this.position.slice(1);
		this.autoFade = autoFade;
		
		this.hintElement = new Element('span', { 'class': 'kasHint kasHint' + this.position, 'style': 'display: none;'}).update(this.message);
		this.hintElement.appendChild(new Element('span', { 'class': 'pointer' }));
		
		this.attachedElement.insert({after: this.hintElement});
	},
	show: function() {
		// Hints don't seem to work in IE properly yet
		if (Prototype.Browser.IE)
			return;
		var parentVisible = true;
		for (var parent = this.attachedElement.getOffsetParent();
			 (typeof parent != 'undefined') && parent != null && parent != $(document.body);
			 parent = parent.getOffsetParent()) {
			if (!parent.visible()) {
				parentVisible = false;
				break;
			}
		}
		if (this.attachedElement.visible() && parentVisible && parent != null && (typeof parent != 'undefined')) {
			var position = this.attachedElement.positionedOffset();
			var dimensions = this.attachedElement.getDimensions();
			switch (this.position) {
				case 'Right':
					position[1] += (dimensions.height / 2) - 12;	// top
					position[0] += (dimensions.width + 16);			// left
					break;
				case 'Under':
				default:
					position[1] += (dimensions.height + 16);		// top
					position[0] += (dimensions.width / 2) - 16;		// left
					break;
			}
			this.hintElement.style.top = position[1] + 'px';
			this.hintElement.style.left = position[0] + 'px';
			this.hintElement.style.display = 'inline';
			if (typeof this.autoFade != 'undefined' && parseInt(this.autoFade) > 0) {
				this.autoFadeTimeout = setTimeout(this.hide.bind(this), parseInt(this.autoFade));
			}
		}
		else {
			this.show.bind(this).defer();
		}
	},
	hide: function() {
		this.hintElement.hide();
		if (typeof this.autoFadeTimeout != 'undefined') {
			clearTimeout(this.autoFadeTimeout);
		}
	}
});


var PopUpData = {
	basePosition: { top: 128, left: 160 },
	positionMultiple: { top: 32, left: 16 },
	numberOpen: 0,
	zIndex: 10000,
	shading: null
};

var PopUp = Class.create({
	initialize: function() {
		this.content = null;
		this.buttons = new Array();

		if (PopUpData.shading === null) {
			PopUpData.shading = new ModalBoxShading();
		}
		
		var div = this.divobject = new Element('div', { 'class': 'kasPopUp', 'style': 'display: none;' });
		div.appendChild(div = new Element('div', { 'class': 'topright' }));
		div.appendChild(div = new Element('div', { 'class': 'topleft' }));
		div.appendChild(this.divcontent = new Element('div'));
		div.appendChild(this.divbuttons = new Element('div', { 'class': 'buttons' }));
		this.divobject.appendChild(div = new Element('div',  { 'class': 'bottomright' }));
		div.appendChild(new Element('div', { 'class': 'bottomleft' }));

		// Make sure we are hidden
		this.divobject.hide();
		
		// Make position fixed to deal with scrolling docs...
		if (Prototype.Browser.IE && Prototype.Browser.Version < 7.0) {
			this.divobject.style.position = 'absolute';
		}
		else {
			this.divobject.style.position = 'fixed';
		}

		// Add the divobject to the document body container
		document.body.appendChild(this.divobject);
	},
	setContent: function(content) {
		this.content = content;
		this.divcontent.update(this.content);
	},
	addButton: function(button) {
		this.buttons.push(button);
		this.divbuttons.appendChild(button);
	},
	checkFit: function(e) {
		// This isn't necessary on browser that don't support fixed because the user can scroll the window
		if (this.divobject.style.position != 'fixed')
			return;
		
		// Get the size of the viewport...
		var dimView = document.viewport.getDimensions();
		if (Prototype.Browser.IE && Prototype.Browser.Version < 7.0) {
			dimView.width = Math.max(document.documentElement.clientWidth, document.body.clientWidth);
			dimView.height = Math.max(document.documentElement.scrollHeight, document.body.scrollHeight);
		}
		
		// Get the size of ourself...
		var dimUs = this.divobject.getDimensions();
		var pos = this.divobject.cumulativeOffset();
		
		// Ok, figure out if we are NOT in view in any extent
		if (pos.left + dimUs.width > dimView.width ||
			pos.top + dimUs.height > dimView.height) {
			// Out of view in either the width or height, so re-center us in the view
			var left = Math.max(0, dimView.width / 2 - dimUs.width / 2);
			var top = Math.max(0, dimView.height / 2 - dimUs.height / 2);
			
			// See if we need to change either position
			if (pos.left != left || pos.top != top) {
				this.divobject.style.left = left + 'px';
				this.divobject.style.top = top + 'px';
			}
		}
	},
	show: function() {
		if (this.divobject.visible()) {
			return;
		}

		// Adjust the shading to cover everything below us and our our zIndex to make sure we are on top
		PopUpData.shading.setZIndex(PopUpData.zIndex);
		this.divobject.style.zIndex = PopUpData.zIndex + 1;
		PopUpData.zIndex += 2;
		PopUpData.numberOpen ++;
		PopUpData.shading.show();
		
		// Adjust our position
		var left, top;
		left = (PopUpData.basePosition.left + PopUpData.positionMultiple.left * (PopUpData.numberOpen - 1));
		top = (PopUpData.basePosition.top + PopUpData.positionMultiple.top * (PopUpData.numberOpen - 1));
		
		// Deal with older browsers (IE6 mostly) that don't understand position: fixed
		if (this.divobject.style.position == 'absolute') {
			var scrollPos = document.viewport.getScrollOffsets();
			left += scrollPos.left;
			top += scrollPos.top;
		}
		
		// Set our left, top attributes
		this.divobject.style.left = left + "px";
		this.divobject.style.top = top + "px";

		// Find every drop-down box that has a zIndex less than us that is visible and hide it if we are in IE6
		this.hiddenDropDowns = new Array();
		if (Prototype.Browser.IE && Prototype.Browser.Version < 7.0) {
			var dropdowns = Element.select(document, 'select', '[size="1"]');
			dropdowns.each(function (dropdown) {
				if (dropdown.visible() && dropdown.style.zIndex < this.divobject.style.zIndex) {
					dropdown.hide();
					this.hiddenDropDowns.push(dropdown);
				}
			}, this);
			var mydropdowns = Element.select(this.divobject, 'select', '[size="1"]');
			mydropdowns.each(function (dropdown) {
				if (this.hiddenDropDowns.indexOf(dropdown) >= 0) {
					dropdown.show();
					this.hiddenDropDowns = this.hiddenDropDowns.without(dropdown);
				}
			}, this);
		}
		
		// Show us
		this.divobject.style.visibility = 'visible';
		this.divobject.show();
		
		// Defer a check to make sure we are completely visible in the browser window.
		// Also run the check whenever the document is resized
		this.checkFit.bind(this).defer();
		this.checkFitEventHandler = this.checkFit.bindAsEventListener(this);
		Event.observe(window, 'resize', this.checkFitEventHandler);		
	},
	hide: function() {
		if (!this.divobject.visible()) {
			return;
		}
		this.hiddenDropDowns.each(function(dropdown) {
			dropdown.show();
		});
		delete this.hiddenDropDowns;
		Event.stopObserving(window, 'resize', this.checkFitEventHandler);
		this.divobject.hide();
		PopUpData.numberOpen --;
		PopUpData.zIndex -= 2;
		if (PopUpData.numberOpen == 0)
			PopUpData.shading.hide();
		PopUpData.shading.setZIndex(PopUpData.zIndex - 2);
	}
});

var AlertPopUp = Class.create(PopUp, {
	initialize: function($super, message, callback) {
		$super();
		
		this.callback = (Object.isFunction(callback) ? callback : Prototype.emptyFunction);
		
		this.setContent(message);
		this.divcontent.style.marginTop = "50px";
		this.divcontent.style.marginBottom = "50px";
		this.addButton(this.okbutton = new Element('button', { 'class': 'kasBtn kasBtnGreen' }).update("Ok"));
		Event.observe(this.okbutton, 'click', this.clickOk.bindAsEventListener(this));
		this.divbuttons.style.marginLeft = "auto";
		this.divbuttons.style.marginRight = "auto";
		
		this.show();
		this.okbutton.focus();
	},
	clickOk: function(e) {
		this.hide();
		this.callback();
		this.divobject.remove();
	}
});

var WaitPopUp = Class.create(PopUp, {
	initialize: function($super) {
		$super();
		
		var image = new Element('img', { 'src': '/global/sharewithdropdown/images/gif/ajax-wait.gif' });
		this.setContent(image);
		this.divcontent.style.marginLeft = "auto";
		this.divcontent.style.marginRight = "auto";
		this.divcontent.style.marginTop = "50px";
		this.divcontent.style.marginBottom = "50px";
		this.divcontent.style.width = "16px";
		this.addButton(new Element('div').update("Please wait..."));

		this.timer = null;
		this.delay = 0;
	},
	clearDelayHide: function() {
		this.delay = 0;
	},
	delayShow: function(delay) {
		if (this.timer === null) {
			this.delay = delay;
			this.timer = setTimeout(this.show.bind(this), delay);
		}
	},
	show: function($super) {
		if (this.timer !== null) {
			clearTimeout(this.timer);
			this.timer = setTimeout(this.clearDelayHide.bind(this), this.delay);
		}
		$super();
	},
	delayHide: function(delay) {
		if (this.timer === null) {
			this.timer = setTimeout(this.hide.bind(this), delay);
		}
	},
	hide: function($super) {
		if (this.timer !== null) {
			clearTimeout(this.timer);
			this.timer = null;
			if (this.delay > 0) {
				this.delayHide(this.delay);
				this.clearDelayHide();
				return;
			}
		}
		$super();
	}
});

var Tab = Class.create({
	initialize: function(params, content) {
		if (content) {
			this.content = $(content);
		}
		else {
			this.content = new Element('div', Object.extend({ 'class': 'kasTabContent' }, params));
		}
		this.tab = null;
		this.index = null;
		this.description = null;
		this.manager = null;
		this.callback = this.defaultCallback.bind(this);
	},
	getContent: function() {
		return this.content;
	},
	appendChild: function(element) {
		return this.content.appendChild($(element));
	},
	getCallback: function() {
		return this.callback;
	},
	getTab: function(tab) {
		return this.tab;
	},
	setTabManager: function(manager) {
		this.manager = manager;
	},
	setIndex: function(index) {
		this.index = index;
	},
	setDescription: function(description) {
		if (description !== null) {
			if (this.tab !== null) {
				this.tab.update(description);
			}
			else {
				this.tab = new Element('li').update(element = new Element('a', {'href': '#'}).update(description));
			}
		}
		this.description = description;
	},
	setCallback: function(callback) {
		if (Object.isFunction(callback)) {
			this.callback = callback;
		}
	},
	setActive: function(active) {
		if (this.tab !== null) {
			if (active) {
				this.tab.addClassName('active');
			}
			else {
				this.tab.removeClassName('active');
			}
		}
	},
	defaultCallback: function(what) {
		if (what === "before-show") {
			return this.onBeforeShow();
		}
		else if (what === "show") {
			this.onShow();
		}
		else if (what === "before-hide") {
			return this.onBeforeHide();
		}
		else if (what === "hide") {
			this.onHide();
		}
		else {
			return false;
		}
	},
	show: function() {
		this.content.show();
	},
	hide: function() {
		this.content.hide();
	},
	visible: function() {
		return this.content.visible();
	},
	onBeforeShow: function() {
		return true;
	},
	onShow: function() {
	},
	onBeforeHide: function() {
		return true;
	},
	onHide: function() {
	}
});

var TabbedPopUp = Class.create(PopUp, {
	initialize: function($super) {
		$super();	
		this.tabs = new Array();
		this.divcontent.appendChild(this._tabs_element = new Element('ul', {'class': 'kasTabMenu'}));
		this.currentTab = -1;
	},
	clickTab: function(e, tabdata) {
		e.stop();
		this.showTab(tabdata.index);
	},
	addTab: function(description, content, callback) {
		if (content instanceof Tab) {
			var tabdata = content;
			content = tabdata.getContent();
		}
		else {
			var tabdata = new Tab({}, content);
		}
		tabdata.setTabManager(this);
		tabdata.setIndex(this.tabs.length);
		tabdata.setDescription(description);
		tabdata.setCallback(callback);
		tab = tabdata.getTab();
		if (tab !== null) {
			Event.observe(tab, 'click', this.clickTab.bindAsEventListener(this, tabdata));
			this._tabs_element.appendChild(tab);
		}
		tabdata.setActive(false);
		tabdata.hide();
		this.divcontent.appendChild(tabdata.getContent());
		this.tabs.push(tabdata);
	},
	showTab: function(index) {
		if (typeof index !== "number") {
			if (typeof index === "string") {
				tab = this.tabs.detect(function(tab) { return tab.description === index; });
				if ( typeof tab !== "undefined" ) {
					index = tab.index;
				}
			}
			if (typeof index !== "number") {
				return;
			}
		}
		if (this.currentTab != index) {
			if (this.currentTab >= 0) {
				if (this.tabs[this.currentTab].callback("before-hide") === false) {
					return;
				}
			}
			if (this.tabs[index].callback("before-show") === false) {
				return;
			}
			if (this.currentTab >= 0) {
				this.tabs[this.currentTab].hide();
				this.tabs[this.currentTab].setActive(false);
				this.tabs[this.currentTab].callback("hide");
			}
		}
		else {
			if (this.tabs[index].callback("before-show") === false) {
				return;
			}
		}
		this.tabs[index].setActive(true);
		this.tabs[index].content.show();
		this.tabs[index].callback("show");
		this.currentTab = index;
	}
});

var SortHelpers = {
	sortFriendListByFnameLnameUsername: function(a, b) {
		/*
		if (a.fname > b.fname) {
			return 1;
		}
		if (a.fname < b.fname) {
			return -1;
		}
		if (a.lname > b.lname) {
			return 1;
		}
		if (a.lname < b.lname) {
			return -1;
		}
		if (a.username > b.username) {
			return 1;
		}
		if (a.username < b.username) {
			return -1;
		}
		*/
		var astr = a.fname + " " + a.lname + " " + a.username;
		var bstr = b.fname + " " + b.lname + " " + b.username;
		astr = astr.strip();
		astr = astr.toLowerCase();
		bstr = bstr.strip();
		bstr = bstr.toLowerCase();
		if (astr > bstr)
			return 1;
		if (astr < bstr)
			return -1;
		return 0;
	},
	sortFriendListByGroupMembership: function(groupValue, a, b) {
		var aIndex = a.groups.indexOf(groupValue);
		var bIndex = b.groups.indexOf(groupValue);
		if (aIndex > -1 && bIndex < 0) {
			return -1;
		}
		if (aIndex < 0 && bIndex > -1) {
			return 1;
		}
		return this.sortFriendListByFnameLnameUsername(a, b);
	}
};

var ManageFriendsTab = Class.create(Tab, SortHelpers, {
	initialize: function($super) {
		// Create our layout
		$super({ 'id': 'kasManageFriendsTab' });
		this.managelist = new Array();
		this.appendChild(element = new Element('button', { 'class': 'kasBtn kasBtnGreen' }).update('Find Friends'));
		Event.observe(element, 'click', this.clickOnFindNewFriends.bindAsEventListener(this, element));
		this.findFriendsHint = new Hint(element, "Click here to find friends and add them to your friends list", "below");
		this.appendChild(element = new Element('button', { 'class': 'kasBtn kasBtnRed' }).update('Delete Selected Friends'));
		Event.observe(element, 'click', this.clickOnDeleteSelectedFriends.bindAsEventListener(this, element));
		this.appendChild(this.divfriendlist = new Element('div', { 'id': 'friendList' }));
		
		// Create a popup for finding new friends
		this.findNewFriendsPopup = new FindPeoplePopUp(FindPeopleModes.ADD_TO_FRIENDS);
		
		// Register our "onchange" data callback handler
		if (g_shareWithDropDownSearchArray === null) {
			// What do we do if this happens??
			return;
		}
		g_shareWithDropDownSearchArray.addChangeCallback(this.onChange.bind(this));
		if (g_shareWithDropDownSearchArray.ready()) {
			this.onChange(g_shareWithDropDownSearchArray);
		}
	},
	clickOnFindNewFriends: function(e, element) {
		e.stop();
		this.findNewFriendsPopup.show();
	},
	onDeleteFriendsComplete: function(waitPopUp, request, success) {
		waitPopUp.hide();
		if (success) {
			this.managelist.each(function f(id) { g_shareWithDropDownSearchArray.deleteEntryById(id); });
			this.managelist.clear();
		}
	},
	clickOnDeleteSelectedFriends: function(e, element) {
		e.stop();
		if (this.managelist.length < 1) {
			new AlertPopUp("Select the friend or friends that you would like to delete from the list. Then click \"Delete Selected Friends\".");
			return;
		}
		if (this.managelist.length == 1 ) {
			thisthese = "this";
			friendfriends = "friend";
		}
		else {
			thisthese = "these";
			friendfriends = "friends";
		}
		if (confirm("Are you really sure you want to delete " + thisthese + " " + friendfriends + "?\n\nThe " + friendfriends + " you have selected will be:\n\n* Removed from your friend list, and\n* Removed from your groups they are a member of\n\nReally delete " + thisthese + " " + friendfriends + "?")) {
			var waitPopUp = new WaitPopUp();
			waitPopUp.delayShow(250);
			new ShareWithAjaxDeleteFriends(this.managelist, this.onDeleteFriendsComplete.bind(this, waitPopUp));
		}
	},
	onReady: function(waitPopUp, data) {
		waitPopUp.hide();
		if (this.manager) {
			this.manager.show(this.index);
		}
	},
	clickFriendLink: function(e, friend) {
		var element = e.element();
		if ('A' != element.tagName && 'SPAN' != element.tagName) {
			return;
		}
		e.stop();
		if (typeof this.manager.opener != "undefined" && this.manager.opener !== null) {
			if (typeof this.manager.opener == "object" && this.manager.opener.type == "text") {
				this.manager.opener.value = friend.username;
				this.manager.hide();
			}
			if (Object.isFunction(this.manager.opener)) {
				this.manager.opener(friend.username, friend);
				this.manager.hide();
			}
		}
	},
	clickFriendCheckbox: function(e, friend) {
		if (friend.cbfriend.checked) {
			if (this.managelist.indexOf(friend.id) === -1) {
				this.managelist.push(friend.id);
			}
		}
		else {
			index = this.managelist.indexOf(friend.id);
			if (index !== -1) {
				this.managelist.splice(index, 1);
			}
		}
	},
	onChange: function(data) {
		var friends = data.friends();
		var newDiv = new Element('div', { 'id': 'friendList' });
		friends.sort(this.sortFriendListByFnameLnameUsername);
		friends.each(function(friend) {
			if (typeof friend.divManageFriendsEntry === "undefined") {
				var div, element, cb_friend;
				
				div = new Element('div').update(element = new Element('a', { 'href': '#' }));
				element.appendChild(cb_friend = new Element('input', { 'type': 'checkbox', 'value': friend.username }));
				element.appendChild(new Element('span').update(friend.fname + " " + friend.lname + " (" + friend.username + ")"));
				Event.observe(element, 'click', this.clickFriendLink.bindAsEventListener(this, friend));
				Event.observe(cb_friend, 'click', this.clickFriendCheckbox.bindAsEventListener(this, friend));
				
				friend.cbfriend = cb_friend;
				friend.divManageFriendsEntry = div;
			}
			newDiv.appendChild(friend.divManageFriendsEntry);
		}, this);
		this.divfriendlist.replace(newDiv);
		this.divfriendlist = newDiv;
		if (friends.length == 0 && this.visible()) {
			this.findFriendsHint.show();
		}
		else {
			this.findFriendsHint.hide();
		}
	},
	onBeforeShow: function() {
		this.manager.savebutton.hide();
		this.manager.updatebutton.hide();
		if (!g_shareWithDropDownSearchArray.ready()) {
			var waitPopUp = new WaitPopUp();
			waitPopUp.delayShow(250);
			g_shareWithDropDownSearchArray.addReadyCallback(this.onReady.bind(this, waitPopUp));
			return false;
		}
		return true;
	},
	onShow: function() {
		if (this.divfriendlist && this.divfriendlist.childElements().length == 0) {
			this.findFriendsHint.show();
		}
		else {
			this.findFriendsHint.hide();
		}
	}
});

var ManageGroupsTab = Class.create(Tab, SortHelpers, {
	initialize: function($super) {
		$super({ 'id': 'kasManageGroupsTab' });

		this.appendChild(div = new Element('div', { 'class': 'swpu_colmask swpu_leftmenu' }));
		div.appendChild(div = new Element('div', { 'class': 'swpu_colleft' }));
		div.appendChild(this.divright = new Element('div', { 'class': 'swpu_col1' }));
		div.appendChild(this.divleft = new Element('div', { 'class': 'swpu_col2' }));
		this.appendChild(new Element('br', { 'style': 'clear:both;' }));

		// Create a popup for finding new friends
		this.findNewFriendsPopup = new FindPeoplePopUp(FindPeopleModes.ADD_TO_GROUP);
		
		// Register our "onchange" data callback handler
		if (g_shareWithDropDownSearchArray === null) {
			// What do we do if this happens??
			return;
		}
		g_shareWithDropDownSearchArray.addChangeCallback(this.onChange.bind(this));
		if (g_shareWithDropDownSearchArray.ready()) {
			this.onChange(g_shareWithDropDownSearchArray);
		}
	},
	createGroupManageEntry: function(active, atitle, cbtitle, value, description, index, checkbox) {
		var div, element, cb_viewer, cb_editor;
		
		if (typeof this.groupsManage == 'undefined') {
			this.groupsManage = new Array();
		}
		if (typeof this.groupsManage[index + 2] == 'undefined' || this.groupsManage[index + 2].description != description) {
			div = new Element('div').update(element = new Element('a', { 'class': (active) ? 'active' : '', 'href': '#', 'title': atitle }));
			element.appendChild(new Element('span').update(description));
			Event.observe(element, 'click', this.changeDisplayedGroup.bindAsEventListener(this, index));
		
			this.groupsManage[index + 2] = {
				div: div,
				description: description
			};
		}
		else {
			div = this.groupsManage[index + 2].div;
			
			var child = div.firstDescendant();
			if (child !== null) {
				if (active) {
					child.addClassName('active');
				}
				else {
					child.removeClassName('active');
				}
			}
		}

		return div;
	},
	clickGroupMemberCheckbox: function(e, friend) {
		var element = e.element();
		var groups = g_shareWithDropDownSearchArray.groups();
		var group;
		
		// Use the groups list for defined groups
		if (this.updateFriendList_lastIndex > -1) {
			group = groups[this.updateFriendList_lastIndex];
		}
		// Use a temporary list for "new" groups
		else {
			if (typeof this.temporaryGroup === "undefined") {
				this.temporaryGroup = new Object();
				this.temporaryGroup.value = -1;
				this.temporaryGroup.members = new Array();
			}
			group = this.temporaryGroup;
		}

		// If checkbox is checked, make this friend a member of the group
		if (element.checked) {
			// See if the group is already on this person's list
			if (friend.groups.indexOf(group.value) < 0) {
				// It isn't, so add it
				friend.groups.push(group.value);
				group.members.push(friend);
			}
		}
		// If checkbox is not checked, remove this friend from the group
		else {
			// See if the group has already been removed from this person's list
			index = friend.groups.indexOf(group.value);
			if (index > -1) {
				// It hasn't, so delete it
				friend.groups.splice(index, 1);
				groupIndex = group.members.indexOf(friend);
				if (groupIndex > -1) {
					group.members.splice(groupIndex, 1);
				}
			}
		}
	},
	createListEntry: function(friend, description) {
		var div, element, cb_manage;

		div = new Element('div');
		div.appendChild(cb_member = new Element('input', { 'type': 'checkbox', 'name': 'swpu_groupmember', 'title': 'Check this box to make this person a member of this group', 'value': friend.username }));
		div.appendChild(new Element('span').update(description));
		Event.observe(cb_member, 'click', this.clickGroupMemberCheckbox.bindAsEventListener(this, friend));
		
		friend.cbmember = cb_member;
		friend.divGroupManage = div;
		
		return div;
	},
	clickOnFindNewFriends: function(e, element) {
		e.stop();
		var groups = g_shareWithDropDownSearchArray.groups();
		if (this.updateFriendList_lastIndex >= 0) {
			this.findNewFriendsPopup.setGroup(groups[this.updateFriendList_lastIndex].value);
		}
		else {
			this.findNewFriendsPopup.setGroup(0);
		}
		this.findNewFriendsPopup.show();
	},
	updateList: function(index) {
		if (typeof index == "undefined" || index == null) {
			if (typeof this.updateFriendList_lastIndex != "undefined") {
				return;
			}
			if (typeof this.updateFriendList_forceIndex != "undefined") {
				index = this.updateFriendList_forceIndex;
				delete this.updateFriendList_forceIndex;
			}
			else {
				index = -1;
			}
		}

		var divManage = new Element('div', { 'class': 'swpu_col2' });
		var divListContainer = new Element('div', { 'class': 'swpu_col1' });
		var groups = g_shareWithDropDownSearchArray.groups();
		var friends = g_shareWithDropDownSearchArray.friends();
		var element, div, list = friends;

		// Create 'My Groups:' text
		divManage.update(new Element('div').update('My Groups:'));
		// Create the 'Create New Group' list entry
		divManage.appendChild(this.createGroupManageEntry((-1 == index), 'Click here to create new group', '', 0, '<span class=\"kasGreenPlus\">+</span>New Group', -1, true));
		
		if (groups.length <= 0) {
			divManage.appendChild(new Element('div', { 'class': 'Smaller', 'style': 'font-style: italic; color: #bbbbbb;' }).update('no groups setup'));
		}
		
		// Catch case where deleted group no longer exists 
		if ( index >= groups.length ) {
			index = -1;
		}

		// Create an entry for each group that has members
		for (var i = 0; i < groups.length; i ++) {
			if (groups[i].members || i == index) {
				divManage.appendChild(this.createGroupManageEntry((i == index), groups[i].viewergroup, 'the \'' + groups[i].sharegroupname + '\' group', groups[i].value, groups[i].sharegroupname + '&nbsp;(' + groups[i].members.length + ')', i, true));
			}
			if (i == index) {
				list = groups[i].members;
			}
		}
		divListContainer.update(div = new Element('div').update(new Element('label', { 'for': 'groupnameManage' }).update("Group Name:&nbsp;")));
		div.appendChild(this.groupname = new Element('input', { 'type': 'text', 'name': 'groupnameManage', 'value': (index >= 0 ? groups[index].sharegroupname : "") }));
		divListContainer.appendChild(element = new Element('button', { 'class': 'kasBtn kasBtnGreen' }).update('Add New Friends'));
		Event.observe(element, 'click', this.clickOnFindNewFriends.bindAsEventListener(this, element));
		if (index >= 0) {
			Event.observe(this.groupname, 'change', this.changeGroupName.bindAsEventListener(this, index, this.groupname));
			if (typeof this.manager.opener != "undefined" && this.manager.opener !== null) {
				divListContainer.appendChild(element = new Element('button', { 'class': 'kasBtn kasBtnGreen' }).update("Share With This Group"));
				Event.observe(element, 'click', this.clickOnShareWithThisGroup.bindAsEventListener(this, element));
			}
			divListContainer.appendChild(element = new Element('button', { 'class': 'kasBtn kasBtnRed' }).update("Delete Group"));
			Event.observe(element, 'click', this.clickOnDeleteGroup.bindAsEventListener(this, element));
		}
		divListContainer.appendChild(new Element('div').update("Check the people you want in this group below, then click update."));
		var divList = new Element('div', { 'id': 'kasManageGroupsMemberList' });
		divListContainer.appendChild(divList);
		if (index >= -1) {
			list = friends;
			if (index >= 0) {
				list.sort(this.sortFriendListByGroupMembership.bind(this, groups[index].value));
			}
			else {
				list.sort(this.sortFriendListByFnameLnameUsername);
			}
			for (var i = 0; i < list.length; i++) {
				if (typeof list[i].divGroupManage == 'undefined') {
					list[i].divGroupManage = this.createListEntry(list[i], list[i].fname + " " + list[i].lname + " (" + list[i].username + ")");
				}
				divList.appendChild(list[i].divGroupManage);
				if (index >= 0) {
					if (list[i].groups.indexOf(groups[index].value) > -1) {
						list[i].cbmember.checked = true;
					}
					else {
						list[i].cbmember.checked = false;
					}
				}
				else {
					list[i].cbmember.checked = false;
				}
			}
		}
		
		// Replace the left and right divs with the new ones
		this.divleft.replace(divManage);
		this.divright.replace(divListContainer);
		this.divleft = divManage;
		this.divright = divListContainer;
		
		this.updateFriendList_lastIndex = index;
	},
	createGroupComplete: function(index, value, tabIndex, waitPopUp, request, success, groupid) {
		if (success) {
			var group = this.temporaryGroup;
			delete this.temporaryGroup;
			
			group.value = groupid;
			group.members.each(function(member) {
				var index = member.groups.indexOf(-1);
				if (index >= 0) {
					member.groups.splice(index, 1, group.value);
				}
			});
			
			g_shareWithDropDownSearchArray.addGroup(group);
			
			var groups = g_shareWithDropDownSearchArray.groups();
			var groupIndex = groups.indexOf(group);
			if (groupIndex >= 0)
				this.updateFriendList_forceIndex = groupIndex;
		}
		delete this.updateFriendList_lastIndex;
		this.updateList();
		waitPopUp.hide();
	},
	deleteGroupComplete: function(index, value, tabIndex, waitPopUp, request, success) {
		if (success) {
			// Delete the group's data structure
			g_shareWithDropDownSearchArray.deleteGroupById(value);
			
			// Switch to the next previous group...
			index--;
			this.updateFriendList_forceIndex = index;
		}
		delete this.updateFriendList_lastIndex;
		this.updateList();
		waitPopUp.hide();
	},
	updateGroupMembersComplete: function(index, value, tabIndex, waitPopUp, request, success) {
		delete this.updateFriendList_lastIndex;
		this.updateFriendList_forceIndex = index;
		this.updateList();
		waitPopUp.hide();
	},
	changeGroupNameComplete: function(index, value, tabIndex, waitPopUp, request, success) {
		if (success) {
			g_shareWithDropDownSearchArray.changeGroupName(index, value);
		}
		delete this.updateFriendList_lastIndex;
		this.updateFriendList_forceIndex = index;
		this.updateList();
		waitPopUp.hide();
	},
	changeGroupName: function(e, index, element) {
		var groups = g_shareWithDropDownSearchArray.groups();
		e.stop();
		if (element.value != "") {
			var waitPopUp = new WaitPopUp();
			waitPopUp.delayShow(250);
			var changeGroupNameRequest = new ShareWithAjaxRenameGroup(groups[index].value, element.value, this.changeGroupNameComplete.bind(this, index, element.value, 1, waitPopUp));
		}
		else {
			element.value = groups[index].sharegroupname;
		}
	},
	changeDisplayedGroup: function(e, index) {
		var element = e.element();
		if ('A' != element.tagName && 'SPAN' != element.tagName) {
			return;
		}
		e.stop();
		this.updateList(index);
	},
	onChange: function(data) {
		this.updateList(this.updateFriendList_lastIndex);
	},
	clickOnDeleteGroup: function(e) {
		e.stop();
		var groups = g_shareWithDropDownSearchArray.groups();
		var group = groups[this.updateFriendList_lastIndex];

		if (confirm("Are you sure you want to delete this group?\n\nThis action cannot be undone and will remove\nthis group permanently from your account.")) {
			var waitPopUp = new WaitPopUp();
			waitPopUp.delayShow(250);
			var deleteGroupRequest = new ShareWithAjaxDeleteGroup(group.value, this.deleteGroupComplete.bind(this, this.updateFriendList_lastIndex, group.value, 1, waitPopUp));
		}
	},
	clickOnShareWithThisGroup: function(e, group) {
		e.stop();
		var groups = g_shareWithDropDownSearchArray.groups();
		var group = groups[this.updateFriendList_lastIndex];
		if (typeof this.manager.opener != "undefined" && this.manager.opener !== null) {
			if (Object.isFunction(this.manager.opener)) {
				this.manager.opener(group.sharegroupname, { username: group.sharegroupname, fname: '', lname: '', id: group.value, group: true });
				this.manager.hide();
			}
		}
	},
	onBeforeShow: function() {
		this.onChange();
		return true;
	},
	onShow: function(change) {
		if (this.manager.savebutton) {
			this.manager.savebutton.hide();
			this.manager.updatebutton.show();
		}
		return true;
	},
	clickUpdate: function() {
		// Is it a new group?
		if (this.updateFriendList_lastIndex < 0) {
			// Verify there are group members
			if (typeof this.temporaryGroup === "undefined" ||
				this.temporaryGroup.members.length < 1) {
				new AlertPopUp("Before you create your group, please select some people to be members by checking the boxes in the list.");
				return;
			}
			
			// Verify the group name has been set
			if (this.groupname.value.length < 1) {
				new AlertPopUp("Before you create your group, please give it a name\nby typing it into the group name box.", this.groupname.focus.bind(this.groupname));
				return;
			}
			
			// Submit an ajax request for a new group
			this.temporaryGroup.sharegroupname = this.groupname.value;
			this.temporaryGroup.viewergroup = "";
			var memberlist = new Array();
			this.temporaryGroup.members.each(function(friend) { memberlist.push(friend.id); });
			
			// Put up our "please wait" div send generate the ajax request
			var waitPopUp = new WaitPopUp();
			waitPopUp.delayShow(250);
			var createGroupRequest = new ShareWithAjaxCreateGroup(this.temporaryGroup.sharegroupname, memberlist, this.createGroupComplete.bind(this, this.updateFriendList_lastIndex, this.temporaryGroup.value, 1, waitPopUp));
		}
		
		// Its an existing group being updated
		else {
			// Group name changes are handled by separate code, so just make a list of members and send it
			// via an ajax request
			var groups = g_shareWithDropDownSearchArray.groups();
			var group = groups[this.updateFriendList_lastIndex];
			var memberlist = new Array();
			group.members.each(function(friend) { memberlist.push(friend.id); });
			
			// Verify there are group members
			if (memberlist.length < 1) {
				if (confirm("All of the group members have been unselected.\n\nDo you want to delete this group?")) {
					var waitPopUp = new WaitPopUp();
					waitPopUp.delayShow(250);
					var deleteGroupRequest = new ShareWithAjaxDeleteGroup(group.value, this.deleteGroupComplete.bind(this, this.updateFriendList_lastIndex, group.value, 1, waitPopUp));
					return;
				}
			}
			
// Put up our "please wait" div send generate the ajax request
			var waitPopUp = new WaitPopUp();
			waitPopUp.delayShow(250);
			var updateGroupMembersRequest = new ShareWithAjaxUpdateGroupMembership(group.value, memberlist, this.updateGroupMembersComplete.bind(this, this.updateFriendList_lastIndex, group.value, 1, waitPopUp));
		}
	}
});

var FindPeopleModes = {
	ADD_TO_FRIENDS: 0,
	ADD_TO_GROUP: 1,
	ADD_TO_SHARE: 2
};

var AddFriendTab = Class.create(Tab, {
	initialize: function($super, fname, lname, username, peopleid, addCallback) {
		// Remember who we are going to add
		this.fname = fname;
		this.lname = lname;
		this.username = username;
		this.peopleid = peopleid;
		if (Object.isFunction(addCallback)) {
			this.addCallback = addCallback;
		}
		else {
			this.addCallback = Prototype.emptyFunction;
		}
		
		// Call the super class
		$super({ 'id': 'kasAddFriendTab' });
		
		// Build the layout
		this.appendChild(div = new Element('div', { 'class': 'findBody' }));
		div.appendChild(this.divresults = new Element('div', { 'class': 'findResults' }));
		this.appendChild(this.divfooter = new Element('div', { 'class': 'footer' }));
		this.divfooter.appendChild(this.addtogroupcheckbox = new Element('input', { 'type': 'checkbox', 'name': 'swpu_findtabaddtogroupcheckbox', 'value': '1'}));
		Event.observe(this.addtogroupcheckbox, 'click', this.onAddToGroupCheckboxClick.bindAsEventListener(this));
		this.divfooter.appendChild(new Element('label', { 'for': 'swpu_findtabaddtogroupcheckbox' }).update("Also add <b>" + this.username + "</b> to this group: "));
		this.divfooter.appendChild(this.addtogroupdropdown = new Element('select', { 'name': 'swpu_findtabaddtogroupdropdown', 'size': '1' }));
		Event.observe(this.addtogroupdropdown, 'change', this.onAddToGroupDropdownChange.bindAsEventListener(this));
		this.divfooter.appendChild(new Element('span', {'style': 'width: 8px;'}).update("&nbsp;"));
		this.divfooter.appendChild(this.addtogroupnewedit = new Element('input', { 'type': 'text', 'name': 'swpu_findtabaddtogroupnewedit', 'value': '', 'size': '15', 'disabled': '1' }));
		Event.observe(this.addtogroupnewedit, 'focus', this.onAddToGroupNewEditFocus.bindAsEventListener(this));
		this.addtogroupnewedit.hide();
		var descr;
		if (this.fname == "" && this.lname == "") {
			descr = this.username;
		}
		else {
			descr = this.fname + " " + this.lname;
			descr = descr.strip();
			descr = descr + "(" + this.username + ")";
		}
		this.divresults.update(new Element('div', {'class': 'message'}).update("Would you like to add<br /><b>" + descr + "</b><br /> to your friends list?"));
		
		// Register to get sharing changes.
		if (g_shareWithDropDownSearchArray === null) {
			// What do we do if this happens??
			return;
		}
		g_shareWithDropDownSearchArray.addChangeCallback(this.onChange.bind(this));
		if (g_shareWithDropDownSearchArray.ready()) {
			this.onChange(g_shareWithDropDownSearchArray);
		}
	},
	onChange: function(data) {
		// Reset the dropdown list
		var groups = data.groups();
		this.addtogroupdropdown.update("");
		
		// Create an entry for "no group selected"
		this.addtogroupdropdown.appendChild(new Element('option', {'value': '-1'}).update("Select Group..."));

		// Create an entry for each group that has members
		groups.each(function(group) {
			if (group.members && group.members.length > 0) {
				this.addtogroupdropdown.appendChild(new Element('option', {'value': group.value}).update(group.sharegroupname));
			}
		}, this);
		
		// Create an entry for "create new group"
		this.addtogroupdropdown.appendChild(new Element('option', {'value': '0'}).update("Create new group..."));
	},
	onAddToGroupCheckboxClick: function(e) {
		if (this.addtogroupcheckbox.checked) {
			this.addtogroupdropdown.disabled = false;
			this.addtogroupdropdown.selectedIndex = 1;
			this.onAddToGroupDropdownChange(e);
			this.addtogroupdropdown.focus();
		}
		else {
			this.addtogroupdropdown.disabled = false;
			this.addtogroupdropdown.selectedIndex = 0;
			this.addtogroupnewedit.disabled = true;
			this.addtogroupnewedit.hide();
		}
	},
	onAddToGroupDropdownChange: function(e) {
		if (this.addtogroupdropdown.selectedIndex > 0) {
			this.addtogroupcheckbox.checked = true;
		}
		else {
			this.addtogroupcheckbox.checked = false;
		}
		if (this.addtogroupdropdown.selectedIndex >= 0 &&
				this.addtogroupdropdown.options[this.addtogroupdropdown.selectedIndex].value == 0) {
			this.addtogroupnewedit.disabled = false;
			this.addtogroupnewedit.value = "New group name";
			this.addtogroupnewedit.show();
			this.addtogroupnewedit.focus();
			this.addtogroupnewedit.select();
		}
		else {
			this.addtogroupnewedit.disabled = true;
			this.addtogroupnewedit.hide();
		}
	},
	onAddToGroupNewEditFocus: function(e) {
		this.addtogroupnewedit.select();
	},
	onAddFriendRequestComplete: function(obj, waitPopUp, request, success, groupid) {
		if (success) {
			var friend_new = new Object();
			
			// Add required fields that make this a friend record
			Object.extend(friend_new, obj);
			Object.extend(friend_new, { groups: new Array() });
			Object.extend(friend_new, { type: "friend" });
			
			// If added to a group, make sure we create proper entries in friend record
			if (groupid > 0) {
				// If a new group was created, add it to the search array
				if (this.addtogroupdropdown.selectedIndex >= 0 &&
					this.addtogroupdropdown.options[this.addtogroupdropdown.selectedIndex].value == 0) {
					g_shareWithDropDownSearchArray.addGroup({ value: groupid, sharegroupname: this.addtogroupnewedit.value, viewergroup: ""});
				}
				
				// Add the group id to the list of member groups for this new friend
				friend_new.groups.push(groupid);
			}
			
			// Add the new friend entry
			g_shareWithDropDownSearchArray.addEntry(friend_new);
			
			// Then call the user callback and hide our box
			this.addCallback(this._userData, friend_new);
			delete this._userData;
			this.manager.hide();
			waitPopUp.hide();
		}
		else {
			waitPopUp.hide();
			new AlertPopUp("Failed to add the friend to your friend list");
		}
	},
	onClickOk: function(e) {
		e.stop();
		
		// Build the parameters to be sent in the ajax request
		var params = { id: this.peopleid };
		if (this.addtogroupcheckbox.checked && this.addtogroupdropdown.selectedIndex > 0) {
			if (this.addtogroupdropdown.options[this.addtogroupdropdown.selectedIndex].value == 0) {
				// Add to new group option
				if (this.addtogroupnewedit.value === "New group name" ||
					this.addtogroupnewedit.value.length === 0) {
					new AlertPopUp("Please enter a name for your new group", this.addtogroupnewedit.focus.bind(this.addtogroupnewedit));
					return;
				}
				Object.extend(params, { newgroup: this.addtogroupnewedit.value });
			}
			else {
				// Add to existing group option
				Object.extend(params, { group: this.addtogroupdropdown.options[this.addtogroupdropdown.selectedIndex].value });
			}
		}
		
		var obj = {
			id: this.peopleid,
			username: this.username,
			fname: this.fname,
			lname: this.lname
		};
		
		// Build the ajax request
		var waitPopUp = new WaitPopUp();
		waitPopUp.delayShow(250);
		new ShareWithAjaxAddFriend(params, this.onAddFriendRequestComplete.bind(this, obj, waitPopUp));
	}
});

var AddFriendPopUp = Class.create(TabbedPopUp, {
	initialize: function($super, fname, lname, username, peopleid, callback) {
		// Call the parent constructor
		$super();

		// Then create the find people tab
		this.divaddtab = new AddFriendTab(fname, lname, username, peopleid, callback);

		// Create our buttons
		var element;
		element = new Element('button', { 'class': 'kasBtn kasBtnRed' }).update("No, Do Not Add Friend");
		Event.observe(element, 'click', this.clickCancel.bindAsEventListener(this));
		this.addButton(element);
		element = new Element('button', { 'class': 'kasBtn kasBtnGreen' }).update("Yes, Add Friend");
		Event.observe(element, 'click', this.clickOk.bindAsEventListener(this));
		this.addButton(element);

		// Add the tabs to the tab manager
		this.addTab("Add Friend", this.divaddtab);
		
		// By default we "show" ourselves
		this.show();
	},
	show: function($super) {
		this.showTab(0);
		$super();
	},
	clickCancel: function() {
		this.hide();
	},
	clickOk: function(e) {
		this.divaddtab.onClickOk(e);
	}
});

var FindPeopleTab = Class.create(Tab, SortHelpers, {
	initialize: function($super, mode, clickCallback) {
		// Initialize a few internal variables
		this.resultusernames = new Hash();
		if (typeof mode === "number") {
			this.mode = mode;
		}
		else {
			this.mode = FindPeopleModes.ADD_TO_SHARE;
		}
		if (Object.isFunction(clickCallback)) {
			this.clickCallback = clickCallback;
		}
		else {
			this.clickCallback = Prototype.emptyFunction;
		}
		this.group = 0;
		
		// Few helper variables for the constructor
		var modeDescription = new Array();
		modeDescription[FindPeopleModes.ADD_TO_FRIENDS] = 'Click the name of the person you want to add to your friends list.';
		modeDescription[FindPeopleModes.ADD_TO_GROUP] = 'Click the name of the person you want to add to the group.  This person will also be added to your friends list.';
		modeDescription[FindPeopleModes.ADD_TO_SHARE] = 'Click the name of the person you want to share with.';
		
		// Call the super class
		$super({ 'id': 'kasFindPeopleTab' });
		
		// Build the layout
		this.appendChild(div = new Element('div', { 'class': 'findBody' }));
		div.appendChild(this.divinput = new Element('div', { 'class': 'findInput' }));
		this.divinput.appendChild(new Element('label', { 'for': 'swpu_findinput' }).update("Search:&nbsp;"));
		this.divinput.appendChild(this.input = new Element('input', { 'type': 'text', 'name': 'swpu_findinput', 'size': '30' }));
		Event.observe(this.input, 'focus', this.onInputFocus.bindAsEventListener(this));
		Event.observe(this.input, 'keyup', this.onInputKeyUp.bindAsEventListener(this));
		Event.observe(this.input, 'keydown', this.onInputKeyDown.bindAsEventListener(this));
		this.divinput.appendChild(this.searchButton = new Element('button', { 'class': 'kasBtn', 'disabled': 'disabled' }).update('Search'));
		Event.observe(this.searchButton, 'click', this.onClickSearch.bindAsEventListener(this));
		this.divinput.appendChild(this.spinner = new Element('img', { 'style': 'display: none;', 'src': '/global/sharewithdropdown/images/gif/ajax-spinner.gif' }));
		this.divinput.appendChild(this.resultscount = new Element('div', { 'class': 'swpu_findtabresultscount' }));
		div.appendChild(this.divresults = new Element('div', { 'class': 'swpu_find_results' }));
		this.appendChild(this.divfooter = new Element('div', { 'id': 'swpu_footer', 'style': 'display: none;' }));
		this.divfooter.appendChild(new Element('span').update(modeDescription[this.mode]));
		this.divfooter.appendChild(new Element('br'));
		if (this.mode == FindPeopleModes.ADD_TO_SHARE) {
			this.divfooter.appendChild(this.addtofriendscheckbox = new Element('input', { 'type': 'checkbox', 'name': 'swpu_findtabaddtofriendscheckbox', 'value': '1', 'checked': '1' }));
			Event.observe(this.addtofriendscheckbox, 'click', this.onAddToFriendsCheckboxClick.bindAsEventListener(this));
			this.divfooter.appendChild(new Element('label', { 'for': 'swpu_findtabaddtofriendscheckbox' }).update("Add the person I choose to my friends list, too."));
			this.divfooter.appendChild(new Element('br'));
		}
		if (this.mode != FindPeopleModes.ADD_TO_GROUP) {
			this.divfooter.appendChild(this.addtogroupcheckbox = new Element('input', { 'type': 'checkbox', 'name': 'swpu_findtabaddtogroupcheckbox', 'value': '1'}));
			Event.observe(this.addtogroupcheckbox, 'click', this.onAddToGroupCheckboxClick.bindAsEventListener(this));
			this.divfooter.appendChild(new Element('label', { 'for': 'swpu_findtabaddtogroupcheckbox' }).update("Also add to this group: "));
			this.divfooter.appendChild(this.addtogroupdropdown = new Element('select', { 'name': 'swpu_findtabaddtogroupdropdown', 'size': '1' }));
			Event.observe(this.addtogroupdropdown, 'change', this.onAddToGroupDropdownChange.bindAsEventListener(this));
			this.divfooter.appendChild(new Element('span', {'style': 'width: 8px;'}).update("&nbsp;"));
			this.divfooter.appendChild(this.addtogroupnewedit = new Element('input', { 'type': 'text', 'name': 'swpu_findtabaddtogroupnewedit', 'value': '', 'size': '15', 'disabled': '1' }));
			Event.observe(this.addtogroupnewedit, 'focus', this.onAddToGroupNewEditFocus.bindAsEventListener(this));
			this.addtogroupnewedit.hide();
		}
		if (g_shareWithDropDownSearchArray === null) {
			// What do we do if this happens??
			return;
		}
		g_shareWithDropDownSearchArray.addChangeCallback(this.onChange.bind(this));
		if (g_shareWithDropDownSearchArray.ready()) {
			this.onChange(g_shareWithDropDownSearchArray);
		}
	},
	setGroup: function(group) {
		this.group = group;
	},
	onChange: function(data) {
		// Go through our internal results cache and update any divs for people that have 'gone away'
		var updateList = new Array();
		this.resultusernames.each(function f(pair) {
			var friend = g_shareWithDropDownSearchArray.findId(pair.value.id);
			if (friend === null || !friend.type || friend.type != "friend") {
				updateList.push(pair.key);
			}
		});
		updateList.each(function f(username) {
			var friend = this.resultusernames.get(username);
			this.createResultListEntry(friend, this.formatResultString(friend));
		}, this);
		
		// The rest is only done for non-add to group mode
		if (this.mode === FindPeopleModes.ADD_TO_GROUP) {
			return;
		}

		// Reset the dropdown list
		var groups = data.groups();
		this.addtogroupdropdown.update("");
		
		// Create an entry for "no group selected"
		this.addtogroupdropdown.appendChild(new Element('option', {'value': '-1'}).update("Select Group..."));

		// Create an entry for each group that has members
		groups.each(function(group) {
			if (group.members && group.members.length > 0) {
				this.addtogroupdropdown.appendChild(new Element('option', {'value': group.value}).update(group.sharegroupname));
			}
		}, this);
		
		// Create an entry for "create new group"
		this.addtogroupdropdown.appendChild(new Element('option', {'value': '0'}).update("Create new group..."));
	},
	onAddToFriendsCheckboxClick: function(e) {
		if (this.addtofriendscheckbox.checked) {
			if (this.mode != FindPeopleModes.ADD_TO_GROUP) {
				this.addtogroupcheckbox.disabled = false;
				this.onAddToGroupCheckboxClick(e);
			}
		}
		else {
			if (this.mode != FindPeopleModes.ADD_TO_GROUP) {
				this.addtogroupcheckbox.disabled = true;
				this.addtogroupdropdown.disabled = true;
				this.addtogroupnewedit.disabled = true;
				this.addtogroupnewedit.hide();
			}
		}
	},
	onAddToGroupCheckboxClick: function(e) {
		if (this.addtogroupcheckbox.checked) {
			this.addtogroupdropdown.disabled = false;
			this.addtogroupdropdown.selectedIndex = 1;
			this.onAddToGroupDropdownChange(e);
			this.addtogroupdropdown.focus();
		}
		else {
			this.addtogroupdropdown.disabled = false;
			this.addtogroupdropdown.selectedIndex = 0;
			this.addtogroupnewedit.disabled = true;
			this.addtogroupnewedit.hide();
		}
	},
	onAddToGroupDropdownChange: function(e) {
		if (this.addtogroupdropdown.selectedIndex > 0) {
			this.addtogroupcheckbox.checked = true;
		}
		else {
			this.addtogroupcheckbox.checked = false;
		}
		if (this.addtogroupdropdown.selectedIndex >= 0 &&
				this.addtogroupdropdown.options[this.addtogroupdropdown.selectedIndex].value == 0) {
			this.addtogroupnewedit.disabled = false;
			this.addtogroupnewedit.value = "New group name";
			this.addtogroupnewedit.show();
			this.addtogroupnewedit.focus();
			this.addtogroupnewedit.select();
		}
		else {
			this.addtogroupnewedit.disabled = true;
			this.addtogroupnewedit.hide();
		}
	},
	onAddToGroupNewEditFocus: function(e) {
		this.addtogroupnewedit.select();
	},
	onInputFocus: function(e) {
		this.input.select();
	},
	onInputKeyDown: function(e) {
		if (e.keyCode == Event.KEY_RETURN) {
			e.stop();
		}
	},
	onInputKeyUp: function(e) {
		var element = e.element();

		// Drop out if the field is too short
		if (element.value.length < 2) {
			this.searchButton.disabled = true;
			return;
		}

		// Search immediately if key is enter
		if (e.keyCode == Event.KEY_RETURN) {
			e.stop();
			this.startSearch(element.value, 0);
		}
		
		// Anything else enable the search button
		else {
			this.searchButton.disabled = false;
		}
	},
	onClickSearch: function(e) {
		this.startSearch(this.input.value, 0);
	},
	startSearch: function(value, fromTimer, data) {
		this._userData = data;
		if (this.input.value != value) {
			this.input.value = value;
		}
		this.boundSearchFinished = this.searchFinished.bind(this);
		this.request = new ShareWithAjaxFindFriends(value, 0, this.boundSearchFinished);
		if (!this.request.ready()) {
			this.input.disabled = true;
			this.searchButton.disabled = true;
			this.spinner.show();
		}
	},
	formatResultString: function(obj) {
		var string, from;
		string = obj.fname + " " + obj.lname + " (" + obj.username + ")";
		if (obj.city.length || obj.state.length || obj.zip.length || (obj.country.length && obj.country != "?")) {
			string += " [From: ";
			from = "";
			if (obj.city.length) {
				from += obj.city;
			}
			if (obj.state.length) {
				if (from.length) {
					from += ", ";
				}
				from += obj.state;
			}
			if (obj.zip.length) {
				if (from.length) {
					from += ", ";
				}
				from += obj.zip;
			}
			if (obj.country.length && obj.country != "?") {
				if (from.length) {
					from += ", ";
				}
				from += obj.country;
			}
			string += from + "]";
		}
		return string;
	},
	searchFinished: function(request) {
		// Turn off the ajax spinner and re-enable the input field
		this.input.disabled = false;
		this.searchButton.disabled = false;
		this.spinner.hide();
		
		// Format the search results here
		if (request.list.length == 0) {
			this.divfooter.hide();
			this.resultscount.update("No People Found");
			this.divresults.update(new Element('div', {'class': 'swpu_message'}).update("Please try your search again."));
			return;
		}
		else if (request.list.length == 1) {
			this.divfooter.show();
			this.resultscount.update(request.list.length + " Person Found");
		}
		else {
			this.divfooter.show();
			this.resultscount.update(request.list.length + " People Found");
		}
		
		request.list.sort(this.sortFriendListByFnameLnameUsername);
		
		var divresults = new Element('div', { 'class': 'swpu_find_results' });
		request.list.each(function(obj) {
			var setIt = false;
			if (typeof this.resultusernames.get(obj.username) == 'undefined') {
				setIt = true;
			}
			else {
				// Detect change from friend-to-non-friend and non-friend-to-friend
				var objStored = this.resultusernames.get(obj.username);
				if (objStored.divFindPeopleEntry.firstChild == null) {
					// IE messes up the divFindPeopleEntry somehow and we end up with firstChild being null
					// so just rebuild the list entry to be safe.
					setIt = true;
				}
				else {
					var tagName = objStored.divFindPeopleEntry.firstDescendant().tagName;
					if ((tagName == 'SPAN' && objStored.type != 'friend') ||
						(tagName == 'A' && objStored.type == 'friend')) {
						setIt = true;
					}
				}
			}
			if (setIt) {
				var string = this.formatResultString(obj);
				obj.string = string;
				this.resultusernames.set(obj.username, this.createResultListEntry(obj, string));
			}
			divresults.appendChild(this.resultusernames.get(obj.username).divFindPeopleEntry);
		}, this);
		this.divresults.replace(divresults);
		this.divresults = divresults;
	},
	createResultListEntry: function(obj, description) {
		var div, element, cb_viewer, cb_editor;

		div = new Element('div');
		var friendEntry = g_shareWithDropDownSearchArray.findId(obj.id);
		if (friendEntry !== null && friendEntry.type == 'friend') {
			div.update(new Element('span').update(description + " (already a friend)"));
		}
		else {
			if (friendEntry === null) {
				friendEntry = obj;
			}
			div.update(element = new Element('a', { 'href': '#' }));
			element.appendChild(new Element('span').update(description));
			Event.observe(element, 'click', this.onClickFriendLink.bindAsEventListener(this, obj));
		}
		if (typeof friendEntry.divFindPeopleEntry != 'undefined') {
			if (friendEntry.divFindPeopleEntry.up() != null) {
				friendEntry.divFindPeopleEntry.replace(div);
			}
		}
		friendEntry.divFindPeopleEntry = div;

		return friendEntry;
	},
	onAddFriendRequestComplete: function(obj, waitPopUp, request, success, groupid) {
		if (success) {
			var friend_new = new Object();
			
			// Add required fields that make this a friend record
			Object.extend(friend_new, obj);
			Object.extend(friend_new, { groups: new Array() });
			Object.extend(friend_new, { type: "friend" });
			
			// If added to a group, make sure we create proper entries in friend record
			if (groupid > 0) {
				// If a new group was created, add it to the search array
				if (this.mode !== FindPeopleModes.ADD_TO_GROUP) {
					if (this.addtogroupdropdown.selectedIndex >= 0 &&
						this.addtogroupdropdown.options[this.addtogroupdropdown.selectedIndex].value == 0) {
						g_shareWithDropDownSearchArray.addGroup({ value: groupid, sharegroupname: this.addtogroupnewedit.value, viewergroup: ""});
					}
				}
				
				// Add the group id to the list of member groups for this new friend
				friend_new.groups.push(groupid);
			}
			
			// Add the new friend entry
			g_shareWithDropDownSearchArray.addEntry(friend_new);
			
			// Then call the user callback and hide our box
			this.clickCallback(this._userData, obj); // Why not friend_new??  Because of how addEntry works above...
			delete this._userData;
			this.manager.hide();
			waitPopUp.hide();
		}
		else {
			waitPopUp.hide();
			new AlertPopUp("Failed to add the friend to your friend list");
		}
	},
	onClickFriendLink: function(e, obj) {
		e.stop();
		if ((this.mode === FindPeopleModes.ADD_TO_SHARE &&
			this.addtofriendscheckbox.checked) ||
			this.mode === FindPeopleModes.ADD_TO_FRIENDS ||
			this.mode === FindPeopleModes.ADD_TO_GROUP) {
			// Build the parameters to be sent in the ajax request
			var params = { id: obj.id };
			if (this.mode === FindPeopleModes.ADD_TO_GROUP) {
				if (this.group > 0) {
					Object.extend(params, { group: this.group });
				}
			}
			else {
				if (this.addtogroupcheckbox.checked && this.addtogroupdropdown.selectedIndex > 0) {
					if (this.addtogroupdropdown.options[this.addtogroupdropdown.selectedIndex].value == 0) {
						// Add to new group option
						if (this.addtogroupnewedit.value === "New group name" ||
							this.addtogroupnewedit.value.length === 0) {
							new AlertPopUp("Please enter a name for your new group", this.addtogroupnewedit.focus.bind(this.addtogroupnewedit));
							return;
						}
						Object.extend(params, { newgroup: this.addtogroupnewedit.value });
					}
					else {
						// Add to existing group option
						Object.extend(params, { group: this.addtogroupdropdown.options[this.addtogroupdropdown.selectedIndex].value });
					}
				}
			}
			
			// Build the ajax request
			var waitPopUp = new WaitPopUp();
			waitPopUp.delayShow(250);
			new ShareWithAjaxAddFriend(params, this.onAddFriendRequestComplete.bind(this, obj, waitPopUp));
		}
		else {
			this.clickCallback(this._userData, obj);
			delete this._userData;
			this.manager.hide();
		}
	},
	onBeforeShow: function() {
		if (this.manager.updatebutton) {
			this.manager.updatebutton.hide();
			this.manager.savebutton.hide();
		}
		if (typeof this.request != 'undefined' && this.request != null) {
			this.request.deleteReadyCallback(this.boundSearchFinished);
		}
		this.input.disabled = false;
		this.spinner.hide();
		this.input.value="";
		this.divresults.update(new Element('div', {'class': 'swpu_message'}).update("Type the first few letters of a name or username"));
//		this.divresults.appendChild(new Element('div', {'class': 'swpu_message'}).update("Or type in your friend\'s e-mail address"));
		this.divfooter.hide();
		this.resultscount.update("");
		return true;
	},
	setFocus: function() {
		this.input.focus();
		this.input.select();
	},
	onShow: function() {
		setTimeout(this.setFocus.bind(this), 100);
	}
});

var FindPeoplePopUp = Class.create(TabbedPopUp, SortHelpers, {
	initialize: function($super, mode, callback) {
		// Call the parent constructor
		$super();

		// Then create the find people tab
		this.divfindtab = new FindPeopleTab(mode, callback);

		// Create our buttons
		var element;
		element = new Element('button', { 'class': 'kasBtn kasBtnRed' }).update("Close");
		Event.observe(element, 'click', this.clickClose.bindAsEventListener(this));
		this.addButton(element);

		// Add the tabs to the tab manager
		this.addTab("Find Friends", this.divfindtab);
	},
	setGroup: function(group) {
		this.divfindtab.setGroup(group);
	},
	search: function(what, data) {
		this.show();
		this.divfindtab.startSearch(what, 0, data);
	},
	show: function($super) {
		this.showTab(0);
		$super();
	},
	clickClose: function() {
		this.hide();
	}
});

var ShareWithPopUp = Class.create(TabbedPopUp, SortHelpers, {
	initialize: function($super, opener) {
		// Call the parent constructor
		$super();

		// The opener is only used for "edit mode"
		if (typeof opener != "undefined" && opener !== null) {
			this.opener = opener;
		}

		// Then the manage friends tab
		this.divmanagefriendstab = new ManageFriendsTab();
		
		// Then the manage groups tab
		this.divmanagetab = new ManageGroupsTab();
		
		// Create our buttons
		var element;
		element = new Element('button', { 'class': 'kasBtn kasBtnRed' }).update("Close");
		Event.observe(element, 'click', this.clickCancel.bindAsEventListener(this));
		this.addButton(element);
		this.savebutton = element = new Element('button', { 'class': 'kasBtn kasBtnGreen' }).update("Save");
		Event.observe(element, 'click', this.clickSave.bindAsEventListener(this));
		this.addButton(element);
		this.updatebutton = element = new Element('button', { 'class': 'kasBtn kasBtnGreen' }).update("Update");
		Event.observe(element, 'click', this.clickUpdate.bindAsEventListener(this));
		this.addButton(element);
				
		// Add the tabs to the tab manager
		this.addTab("Friends", this.divmanagefriendstab);
		this.addTab("Groups", this.divmanagetab);
	},
	dataReady: function(waitPopUp, index) {
		waitPopUp.hide();
		this.show(index);
	},
	show: function($super, index) {
		if (g_shareWithDropDownSearchArray === null) {
			return;
		}
		if (!g_shareWithDropDownSearchArray.ready()) {
			if (!this.callbackregistered) {
				var waitPopUp = new WaitPopUp();
				waitPopUp.show();
				g_shareWithDropDownSearchArray.addReadyCallback(this.dataReady.bind(this, waitPopUp, index));
				this.callbackregistered = 1;
			}
		}
		else {
			this.showTab(index);
		}
		$super();
	},
	clickCancel: function() {
		this.hide();
	},
	clickSave: function() {
		this.hide();
	},
	clickUpdate: function() {
		if (this.divmanagetab.visible()) {
			this.divmanagetab.clickUpdate();
		}
	},
	showFriends: function(opener) {
		this.show("Friends");
	},
	showManageGroups: function(opener) {
		if (g_shareWithDropDownSearchArray.friends().length == 0) 
			this.show("Friends");
		else
			this.show("Groups");
	}
});

var g_shareWithPopUp = null;

var ShareWithDropDown = Class.create({
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

var ShareWithInputBox = Class.create({
	_sharedWith: null,
	_sharingIsOn: false,
	_dropdown: null,

	// This special event handler is used to implement firing the 'change' handler when the user presses the return key in
	// the input box text field for the IE browser.  Apparantly IE does not fire the change handler when a user presses
	// return--instead only when the control loses focus.
	_keyPressHandlerShareWithInputBox: function(event) {
		if (event.keyCode == Event.KEY_RETURN) {
			Event.stop(event);
			return false;
		}
	},
	
	// Stop the enter key from submitting a form when the share with box is inside a form
	_keyDownHandlerShareWithInputBox: function(event) {
		var element = $(Event.element(event));
		if (event.keyCode == Event.KEY_RETURN) {
			if (element.value != "" && this._dropdown !== null && !this._dropdown.visible() && !this._showingAlertBox) {
				this._shareWithInputBoxDropDownCallback(element.identify());
			}
			Event.stop(event);
			return false;
		}
	},

	_changeShareWithInputBox: function(event) {
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
		this._updateSharingIsImage();
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
		this._updateSharingIsImage();
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
		this._updateSharingIsImage();
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
		else {
			divElement.style.fontWeight = 'bold';
			var editElement = new Element('input', { 'type': 'checkbox', name: 'edit', value: '1', 'style': 'float: left; margin: 3px 0px 3px 4px; padding: 0px; width: 12px; height: 12px; display: inline;', 'title': ('Let \'' + entry.value + '\' make changes') });
			Event.observe(editElement, 'click', this._clickEditShareWithEntry.bindAsEventListener(this));
			element.appendChild(editElement);
			if (entry.type == 'group') {
				titleAttr.value = entry.value;
			}
			else {
				titleAttr.value = entry.value + " (" + entry.fname + " " + entry.lname + ")";
			}
			if (typeof entry.edit !== 'undefined' && entry.edit === true) {
				editElement.checked = true;
				editElement.defaultChecked = true;
			}
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
	//		isEmail = validateEmail(value, false, false); // global/javascript/email_validate.js
	//		if (isEmail) {
	//			user = g_shareWithDropDownSearchArray.findEmail(value);
	//			if (user !== null) {
	//				entry = { 'type': 'username', 'value': user.username, 'id': user.id, 'fname': user.fname, 'lname': user.lname };
	//			}
	//			if (entry === null) {
	//				entry = { 'type': 'email', 'value': value };
	//			}
	//		}
	//		else {
				var user = g_shareWithDropDownSearchArray.findUsername(value);
				if (user !== null) {
					entry = { 'type': 'username', 'value': user.username, 'id': user.id, 'fname': user.fname, 'lname': user.lname };
				}
				else {
					entry = { 'type': 'username', 'value': value };
				}
	//		}
	
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
		this._updateSharingIsImage();
	},

	_showShareWithInputBoxPopupInstructionsTimer: null,

	_showShareWithInputBoxPopupInstructions: function() {
		// style.display = 'inline';
		if ($('sharewithinputfield').value == '') {
			this._instructionsHint.show();
		}
		else {
			this._delayShowShareWithInputBoxPopupInstructions();
		}
	},
	
	_delayShowShareWithInputBoxPopupInstructions: function() {
		if (this._showShareWithInputBoxPopupInstructionsTimer !== null) {
			window.clearTimeout(this._showShareWithInputBoxPopupInstructionsTimer);
		}
		this._showShareWithInputBoxPopupInstructionsTimer = window.setTimeout(this._showShareWithInputBoxPopupInstructions.bind(this), '2000');
	},
	
	_focusSetToShareWithInputBox: function(event) {
		// Show popup instruction box
		this._delayShowShareWithInputBoxPopupInstructions();
	},
	
	_hideShareWithInputBoxPopupInstructions: function() {
		if (this._showShareWithInputBoxPopupInstructionsTimer !== null) {
			window.clearTimeout(this._showShareWithInputBoxPopupInstructionsTimer);
			this._showShareWithInputBoxPopupInstructionsTimer = null;
		}
		this._instructionsHint.hide();
	},
	
	_focusRemovedFromShareWithInputBox: function(event) {
		// Hide popup instruction box
		this._hideShareWithInputBoxPopupInstructions();
	},
	
	_shareWithPopupCallbackForInputBox: function(username, result) {
		var inputElement = $('sharewithinputfield');
		inputElement.value = result.username;
		this._shareWithInputBoxDropDownCallback(inputElement.identify(), result);
	},
	
	_clickShowFriends: function(event) {
		g_shareWithPopUp.showFriends();
	},
	
	_clickShowManageGroups: function(event) {
		g_shareWithPopUp.showManageGroups();
	},
	
	_clickShowFindPeople: function(event) {
		var inputElement = $('sharewithinputfield');
		this._findPeoplePopUp.show();
		if (inputElement.value != "") {
				this._findPeoplePopUp.search(inputElement.value);
		}
	},
	
	_updateSharingIsImage: function() {
		var imgElement = $('sharewithmode').childElements()[0];
		if (typeof this._sharedWith.get("U" + 123) !== 'undefined') {
			imgElement.src = '/global/sharewithdropdown/images/sharing_is_public_48.png';
		}
		else if (this._sharedWith.keys().length > 0) {
			imgElement.src = '/global/sharewithdropdown/images/sharing_is_private_48.png';
		}
		else {
			imgElement.src = '/global/sharewithdropdown/images/sharing_is_not_set_48.png';
		}
	},
	
	_setPublicView: function(on) {
		if (on === false) {
			this._sharedWith.unset("U" + 123);
		}
		else {
			this._sharedWith.set("U" + 123, { 'type': 'username', 'value': 'Anyone (Public)', 'id': 123, 'fname': '', 'lname': '' });
		}
	},
	
	_publicViewCheckboxClicked: function(event) {
		var element = $(Event.element(event));
		var publicEditElement = element.siblings()[1];
		if (! element.checked) {
			publicEditElement.checked = false;
			this._setPublicView(false);
		}
		else {
			this._setPublicView(true);
		}
		this._updateSharingIsImage();
	},
	
	_setPublicEdit: function(on) {
		if (on === false) {
			if (typeof this._sharedWith.get("U" + 123) !== 'undefined') {
				delete this._sharedWith.get("U" + 123).edit;
			}
		}
		else {
			if (typeof this._sharedWith.get("U" + 123) !== 'undefined') {
				this._sharedWith.get("U" + 123).edit = true;
			}
			else {
				this._sharedWith.set("U" + 123, { 'type': 'username', 'value': 'Anyone (Public)', 'id': 123, 'fname': '', 'lname': '', 'edit': true });
			}
		}
	},
	
	_publicEditCheckboxClicked: function(event) {
		var element = $(Event.element(event));
		var publicViewElement = element.siblings()[0];
		if (element.checked) {
			publicViewElement.checked = true;
			this._setPublicEdit(true);
		}
		else {
			this._setPublicEdit(false);
		}
		this._updateSharingIsImage();
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
		var friendEditElement = element.siblings()[1];
		if (! element.checked) {
			friendEditElement.checked = false;
			this._setFriendView(false);
		}
		else {
			this._setFriendView(true);
		}
		this._updateSharingIsImage();
	},
	
	_setFriendEdit: function(on) {
		if (on === false) {
			if (typeof this._sharedWith.get("G" + g_shareWithDropDownSearchArray.getFriendListGroupId()) !== 'undefined') {
				delete this._sharedWith.get("G" + g_shareWithDropDownSearchArray.getFriendListGroupId()).edit;
			}
		}
		else {
			if (typeof this._sharedWith.get("G" + g_shareWithDropDownSearchArray.getFriendListGroupId()) !== 'undefined') {
				this._sharedWith.get("G" + g_shareWithDropDownSearchArray.getFriendListGroupId()).edit = true;
			}
			else {
				this._sharedWith.set("G" + g_shareWithDropDownSearchArray.getFriendListGroupId(), { 'type': 'group', 'value': 'All My Friends', 'id': g_shareWithDropDownSearchArray.getFriendListGroupId(), 'edit': true });
			}
		}
	},
	
	_friendEditCheckboxClicked: function(event) {
		var element = $(Event.element(event));
		var friendViewElement = element.siblings()[0];
		if (element.checked) {
			friendViewElement.checked = true;
			this._setFriendEdit(true);
		}
		else {
			this._setFriendEdit(false);
		}
		this._updateSharingIsImage();
	},

	_createShareWithInputBox: function() {
		var linkElement;
		var inputElement = new Element('input', { 'type': 'text', 'value': '', 'id': 'sharewithinputfield', 'size': '14', 'style': 'position: relative;', 'autocomplete': 'off' });
		var imgElement = new Element('img', { 'src': '/global/sharewithdropdown/images/sharing_is_private_48.png', 'alt': 'Sharing is ON', 'style': 'padding: 4px 4px;' });
		//var spanElement = new Element('span', { 'class': 'hint', 'style': 'display: none;'}).update("Type a name, email, or username;<br>&nbsp;&nbsp;or click \'More..\' for all sharing options.");
		//var spanElement = new Element('span', { 'class': 'kasHint', 'style': 'display: none;'}).update("Type a friend\'s name, a group name, or a username.");
		//spanElement.appendChild(new Element('span', { 'class': 'pointer-left' }));
		Event.observe(inputElement, 'change', this._changeShareWithInputBox.bindAsEventListener(this));
		Event.observe(inputElement, 'focus', this._focusSetToShareWithInputBox.bindAsEventListener(this));
		Event.observe(inputElement, 'blur', this._focusRemovedFromShareWithInputBox.bindAsEventListener(this));
		Event.observe(inputElement, 'keydown', this._keyDownHandlerShareWithInputBox.bindAsEventListener(this));
		Event.observe(inputElement, 'keypress', this._keyPressHandlerShareWithInputBox.bindAsEventListener(this));
	
		$('sharewithmode').update(imgElement);
		$('sharewithheader').update(new Element('br'));
		$('sharewithheader').appendChild(new Element('div', { 'class': 'Smaller', 'style': 'clear: both; width: 40px; text-align: left; float: left;' }).update("Share<br />With"));
		$('sharewithheader').appendChild(new Element('div', { 'class': 'Smaller', 'style': 'width: 40px; text-align: right; float: right;' }).update('Allow<br />Edit'));
	
		$('sharewithsettings').show();
		if ($('sharewithsettings').childElements().length < 2) {
			var divElement;
		
			divElement = new Element('div', { 'style': 'width: 128px; margin: 3px 0px 0px 0px; text-align: left; float: left; display: inline;' });
			divElement.style.width = '128px';
			divElement.style.fontWeight = 'bold';
			divElement.update('Anyone (Public)');
			var element = new Element('div', { 'class': 'Smaller', 'style': 'margin: 0px 0px 0px 0px;  overflow: hidden; display: block;' });
			element.appendChild(this._publicView = new Element('input', { 'type': 'checkbox', 'id': 'publicview', 'name': 'view', 'value': '1', 'style': 'float: left; margin: 3px 4px 3px 0px; padding: 0px; width: 12px; height: 12px; display: inline;', 'title': '' }));
			element.appendChild(divElement);
			var titleAttr = document.createAttribute("title");
			this._publicEdit = new Element('input', { 'type': 'checkbox', 'id': 'publicedit', 'name': 'edit', 'value': '1', 'style': 'float: left; margin: 3px 0px 3px 4px; padding: 0px; width: 12px; height: 12px; display: inline;', 'title': ('Let \'Anyone (Public)\' make changes') });
			element.appendChild(this._publicEdit);
			divElement.style.overflow = 'hidden';
			divElement.setAttributeNode(titleAttr);
			$('sharewithsettings').appendChild(element);
			if (this._publicView.offsetWidth != 12) {
				divElement.style.width = (128 - ((this._publicView.offsetWidth - 12) * 2)) + 'px';
				this._checkboxWidth = this._publicView.offsetWidth;
			}
			else {
				this._checkboxWidth = 12;
			}
			Event.observe(this._publicView, 'click', this._publicViewCheckboxClicked.bindAsEventListener(this));
			Event.observe(this._publicEdit, 'click', this._publicEditCheckboxClicked.bindAsEventListener(this));
		
			divElement = new Element('div', { 'style': 'width: 128px; margin: 3px 0px 0px 0px; text-align: left; float: left; display: inline;' });
			divElement.style.width = '128px';
			divElement.style.fontWeight = 'bold';
			divElement.update('All My Friends');
			var element = new Element('div', { 'class': 'Smaller', 'style': 'margin: 0px 0px 0px 0px;  overflow: hidden; display: block;' });
			element.appendChild(this._friendView = new Element('input', { 'type': 'checkbox', 'id': 'friendview', 'name': 'view', 'value': '1', 'style': 'float: left; margin: 3px 4px 3px 0px; padding: 0px; width: 12px; height: 12px; display: inline;', 'title': '' }));
			element.appendChild(divElement);
			var titleAttr = document.createAttribute("title");
			this._friendEdit = new Element('input', { 'type': 'checkbox', 'id': 'friendedit', 'name': 'edit', 'value': '1', 'style': 'float: left; margin: 3px 0px 3px 4px; padding: 0px; width: 12px; height: 12px; display: inline;', 'title': ('Let \'All My Friends\' make changes') });
			element.appendChild(this._friendEdit);
			divElement.style.overflow = 'hidden';
			divElement.setAttributeNode(titleAttr);
			$('sharewithsettings').appendChild(element);
			Event.observe(this._friendView, 'click', this._friendViewCheckboxClicked.bindAsEventListener(this));
			Event.observe(this._friendEdit, 'click', this._friendEditCheckboxClicked.bindAsEventListener(this));
			if (this._publicView.offsetWidth != 12) {
				divElement.style.width = (128 - ((this._publicView.offsetWidth - 12) * 2)) + 'px';
			}
		}
	
		this._updateSharingIsImage();

		$('sharewithinput').hide();
		$('sharewithinput').appendChild(inputElement);
		this._instructionsHint = new Hint(inputElement, "Type a friend\'s name, a group name, or a username.", "right");
		//$('sharewithinput').appendChild(spanElement);
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
	
		$('sharewithtitle').update("Sharing");
	
		this._dropdown = new ShareWithDropDown(inputElement.identify(), this._shareWithInputBoxDropDownCallback.bind(this), this._clickShowFindPeople.bind(this));
		this._dropdown.onShow = this._hideShareWithInputBoxPopupInstructions.bind(this);
		this._dropdown.onHide = this._delayShowShareWithInputBoxPopupInstructions.bind(this);
		this._sharingIsOn = true;
	},

	loadShareSettings: function(string) {
		while ($('sharewithsettings').childElements().length > 2) {
			$('sharewithsettings').childElements()[$('sharewithsettings').childElements().length - 1].remove();
		}
		this._sharedWith.each(function(pair) {
			this._sharedWith.unset(pair.key);
		}.bind(this));
		if (string !== null && string != '' && string != '{}' && string != '[]') {
			var input = new Hash(string.evalJSON());
			if (input.keys().length > 0) {
				this._createShareWithInputBox();
				var publicSeen = false;
				var friendSeen = false;
				input.each(function(pair) {
					if (pair.key == "U123") {
						publicSeen = true;
						this._setPublicView(true);
						if (typeof this._publicView !== 'undefined') {
							this._publicView.checked = true;
						}
						if (typeof pair.value.edit !== 'undefined' && pair.value.edit === true) {
							this._setPublicEdit(true);
							if (typeof this._publicEdit !== 'undefined') {
								this._publicEdit.checked = true;
							}
							else {
								this._publicEdit.checked = false;
							}
						}
					}
					else if (pair.value.type === 'group' && typeof pair.value.friendlistgroup !== 'undefined' && pair.value.friendlistgroup === true) {
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
				if (publicSeen === false) {
					if (typeof this._publicView !== 'undefined') {
						this._publicView.checked = false;
					}
					if (typeof this._publicEdit !== 'undefined') {
						this._publicEdit.checked = false;
					}
				}
				if (friendSeen === false) {
					if (typeof this._friendView !== 'undefined') {
						this._friendView.checked = false;
					}
					if (typeof this._friendEdit !== 'undefined') {
						this._friendEdit.checked = false;
					}
				}
				if (typeof this._publicView !== 'undefined') {
					this._updateSharingIsImage(this._publicView);
				}
			}
		}
		else {
			this._createShareWithInputBox();
		}
	},
	
	saveShareSettings: function() {
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
		
		if (g_shareWithPopUp === null) {
			g_shareWithPopUp = new ShareWithPopUp(this._shareWithPopupCallbackForInputBox.bind(this));
		}
		
		var divElement = new Element('div', {'id': 'sharewith', 'style': 'margin: 0 auto; width:160px; padding: 4px 2px; position: relative;'});
		divElement.insert(new Element('div', {'id': 'sharewithmode', 'style': 'float: left; position: relative;'}));
		divElement.insert(new Element('div', {'id': 'sharewithtitle', 'class': 'label-2', 'style': 'text-align: center; position: relative;'}));
		divElement.insert(new Element('div', {'id': 'sharewithheader', 'style': 'text-align: center; position: relative;'}));
		divElement.insert(new Element('div', {'id': 'sharewithsettings', 'style': 'position: relative; clear: both;'}));
		divElement.insert(new Element('div', {'id': 'sharewithinput', 'style': 'text-align: center; position: relative; display: block; clear: both;'}));
		elementToReplace.replace(divElement);
		
		if (typeof shareSettings !== 'undefined') {
			this.loadShareSettings(shareSettings);
		}
		else {
			this._createShareWithInputBox();
		}
	}
});

function initShareWithDropDown(hooktome1, hooktome2, callback, app) {
	if (hooktome2) {
		var dropdown2 = new ShareWithDropDown(hooktome2, callback);
	}
	if (hooktome1) {
		var dropdown1 = new ShareWithDropDown(hooktome1, callback);
	}
	if (g_shareWithDropDownSearchArray === null) {
		g_shareWithDropDownSearchArray = new ShareWithDropDownSearchArray(app);
	}
}

// create CSS element on the fly
function __setCSS_Helper(css) {
	try {
		// append stylesheet to alter
		document.getElementsByTagName("head")[0].appendChild(css);
	} catch (e) {
		setTimeout(function(){__setCSS_Helper(css)}, 100);
	}
}

function _setCSS() {
	var css = new Element('link', { 'href': '/global/sharewithdropdown/sharewithdropdown.css', 'rel': 'stylesheet', 'type': 'text/css' });
	
	// attempt to add the css and then keep trying till we do
	__setCSS_Helper(css);
	css = null;
}

_setCSS();
