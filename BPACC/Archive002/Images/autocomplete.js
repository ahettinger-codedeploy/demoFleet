function AutoComplete(txtID, url, minChars, maxResults) {
	this.txtField = document.getElementById(txtID);
	this.txtResultsDiv = document.getElementById(txtID + "_pop");
	this.txtHTTPRequestURL = url;
	this.minChars = minChars;
	this.maxResults = maxResults;
	this.ownVariable = txtID + "_AutoCompleteObj";
	this.curIndex = -1;
	this.numResults = 0;
	this.timeoutVal = 0;
	this.oldValue = '';

	// write out the css that we need for this to work.
	document.write("<style type=\"text/css\">");
	document.write("	#" + txtID + "_popParent { position: relative; }");
	document.write("	#" + txtID + "_pop { display: none; position: absolute; top: -3px; background: #FFFFFF; border: 1px solid #000000; padding: 3px; z-index: 10; font-family: Arial; font-size: 9pt; color: #000000; }");
	document.write("	#" + txtID + "_pop ul { list-style-type: none; margin: 0px; padding: 0px; }");
	document.write("	#" + txtID + "_pop ul li { margin: 0px; cursor: default; }");
	document.write("	#" + txtID + "_pop ul li:hover, #" + txtID + "_pop ul li.selected { background: #EEEEEE; }");
	document.write("</style>");

	// handle the keyup events on the text area we are watching.
	this.AutoCompleteKeyUp = function(evt) {
		var newValue = this.txtField.value;
		var prevValue = this.oldValue;
		this.oldValue = newValue;
		if(newValue.length < this.minChars) {
			this.AutoCompleteHideResults();
			return true;
		}

		switch((window.clipboardData) ? evt.keyCode : evt.which) {
			case 13: { //return key
				this.AutoCompleteSetValue();
				break;
			}
			case 27: { //esc
				this.AutoCompleteHideResults();
				break;
			}
			case 38: { //up arrow
				this.AutoCompleteChangeSelection(true);
				break;
			}
			case 40: { //down arrow
				this.AutoCompleteChangeSelection(false);
				break;
			}
			default: {
				//value did not change, so we're done
				if(prevValue == this.oldValue) return true;

				this.AutoCompleteAjaxCall(this.maxResults, newValue);
				break;
			}
		}
	
		return true;
	}

	//hide the results list and reset the index
	this.AutoCompleteHideResults = function() {
		this.txtResultsDiv.style.display = "none";
		this.curIndex = -1;
		this.txtField.focus();

		//from MouseOverMenuFloatingStatic.js
		if(isie6) showSelect();
	}
	
	//set the value to the current item and hide the results list	
	this.AutoCompleteSetValue = function() {
		var curLetter = TrimString(this.txtField.value.substring(0,1)).toUpperCase();
		var resultsList = this.txtResultsDiv.childNodes[0];
		var selectedResult = resultsList.childNodes[this.curIndex];
		var newValue = selectedResult.firstChild.nodeValue;
	
		if(newValue == "View All " + curLetter + "\'s") {
//			this.AutoCompleteAjaxCall(0, curLetter);
//			need to open a pseudo-modal window to allow better picking of addresses
			this.AutoCompleteHideResults();
			this.AutoCompleteViewAllWindow(curLetter);
			return;
		}
	
		this.txtField.value = newValue;
		this.oldValue = newValue;
		this.AutoCompleteHideResults();
	}

	//move the selection up or down.  wrap around to the top or bottom of the list if necessary
	this.AutoCompleteChangeSelection = function(ysnUp) {
		if(this.numResults < 0) return;
	
		var newIndex = (ysnUp) ? this.curIndex-1 : this.curIndex+1;
		var resultsList = this.txtResultsDiv.childNodes[0];
	
		if(newIndex < 0) newIndex = this.numResults-1;
		if(newIndex >= this.numResults) newIndex = 0;
	
		//remove the selected attribute
		if(this.curIndex >= 0) resultsList.childNodes[this.curIndex].className = "";
	
		//give the selected attribute to the newIndex
		resultsList.childNodes[newIndex].className = "selected";
		this.curIndex = newIndex;
	}

	//makes the ajax call to do autocomplete
	this.AutoCompleteAjaxCall = function(maxResults, searchString) {
		this.curIndex = -1;
		var callback_function = this.ownVariable + ".AutoCompleteAjaxResponse(''";

		makeHttpRequest("http://" + window.location.hostname + "/" + this.txtHTTPRequestURL + "?S="+escape(searchString)+"&M="+maxResults, callback_function, false);
	}

	//handle a click on a <li>
	this.AutoCompleteOnClick = function(index) {
		this.curIndex = index;
		this.AutoCompleteSetValue();
	}

	//handle the mouseout event
	this.AutoCompleteOnMouseOut = function() {
		var tmp = this.ownVariable + ".AutoCompleteHideResults()";
		this.timeoutVal = setTimeout(tmp, 500);
	}

	//handle the ajax response and tweak the html we get back to make things work
	this.AutoCompleteAjaxResponse = function(unuused, txtResponse) {
		//no results, so we're done.
		if(txtResponse.indexOf("<li>") < 0) {
			this.AutoCompleteHideResults();
			return;
		}
		this.numResults = txtResponse.split("</li>").length - 1;
	
		//trim out tabs and newlines that causes problems in firefox
		txtResponse = txtResponse.replace(/\t/gi, "").replace(/\n/gi, "").replace(/\r/gi, "");
	
		//add the onClick handler for the <li>'s
		var i = 0;
		while(txtResponse.indexOf("<li>") > 0) {
			txtResponse = txtResponse.replace("<li>", "<li onClick='"+this.ownVariable+".AutoCompleteOnClick("+i+");'>");
			i++;
		}
	
		//add the onMouseOut and onMouseOver handlers for the <ul>
		txtResponse = txtResponse.replace("<ul>", "<ul onMouseOut='"+this.ownVariable+".AutoCompleteOnMouseOut();' onMouseOver='clearTimeout("+this.ownVariable+".timeoutVal);'>");
	
		this.txtResultsDiv.innerHTML = txtResponse;
		this.txtResultsDiv.style.width = (this.txtField.offsetWidth-9) + "px";
		this.txtResultsDiv.style.display = "block";
		
		//from MouseOverMenuFloatingStatic.js
		if(isie6) hideSelect();
	}

	this.AutoCompleteViewAllWindow = function(curLetter) {
		var userPickerWindow;
		var url='/common/AutoCompleteViewAll.aspx?V=' + this.ownVariable + '&S=' + curLetter + '&F=' + this.txtHTTPRequestURL;
		if (window.showModalDialog)
			userPickerWindow = showModalDialog(url, self, "dialogWidth:600px;dialogHeight:400px;scroll:yes;resizable:yes;help:no;edge:raised;status:no;");
		else {
			userPickerWindow = window.open(url,"Streets","scrollbars,width=600,height=400,resizable=yes");
			userPickerWindow.creator = self;
		}
	}

	this.setViewAllValue = function(val) {
		this.txtField.value = val;
	}
}
