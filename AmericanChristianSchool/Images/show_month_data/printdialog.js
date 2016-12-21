
var KasPrintDialogClass = Class.create(PopUp, {
	initialize: function($super, dowStart) {
		$super();
		this.saveDowStart = dowStart;
		var myContent = new Element('div', { 'id': 'myblock' });
		myContent.appendChild(new Element('h1', { 'style': 'padding: 3px 0 0 6px;' }).update("Print"));
		var topRow = myContent.appendChild(new Element('div', {'id': 'toprow'}));
		var column1 = topRow.appendChild(new Element('div', {'id': 'column1', 'style': 'float: left;'}));
		var layoutContent = column1.appendChild(new Element('div', {'style': 'padding: 3px 0 6px 0;'}).update("Layout: "));
		this.layoutSelect = new Element('select');
		layoutContent.appendChild(this.layoutSelect);
		this.layoutSelect.appendChild(new Element('option', {'value': '0'}).update("Month"));
		this.layoutSelect.appendChild(new Element('option', {'value': '1'}).update("Week"));
		this.layoutSelect.appendChild(new Element('option', {'value': '5'}).update("Week (column)"));
		this.layoutSelect.appendChild(new Element('option', {'value': '2'}).update("Day"));
		this.layoutSelect.appendChild(new Element('option', {'value': '3'}).update("Event"));
		this.layoutSelect.appendChild(new Element('option', {'value': '4'}).update("Year"));
		Event.observe(this.layoutSelect, 'change', this.setNewLayout.bindAsEventListener(this));
		
		var startContent = column1.appendChild(new Element('div', {'style': 'padding: 3px 0 6px 0;'}).update("Starting on "));
		this.beginDateDisplay = startContent.appendChild(new Element('span', {'id': 'BeginDate'}).update("&nbsp;"));
		this.mySelectedDate = startContent.appendChild(new Element('input', {'id': 'printDlgSelectedDate', 'type': 'hidden'}));
		startContent.appendChild(new Element('span').update("&nbsp;&nbsp;"));
		this.calImg = startContent.appendChild(new Element('img', {'src': '../../calendar/repeatingdialog/images/calendar-pulldown.png',
			'alt': 'Calendar', 'title': 'Select start date', 'id': 'printDlgStartdateicon'}));
		var forContent = column1.appendChild(new Element('div', {'style': 'padding: 3px 0 6px 0;'}).update("For: "));
		this.forLengthInput = forContent.appendChild(new Element('input', { 'type': 'text', 'id': 'ForLength', 'size': '3', 'height': '8pt'}));
		Event.observe(this.forLengthInput, 'keyup', this.changeForUnits.bindAsEventListener(this));
//		Event.observe(this.forLengthInput, 'keydown', this.validateNumeric.bindAsEventListener(this));
		forContent.appendChild(new Element('span').update("&nbsp;&nbsp;"));
		this.forPeriodUnits = forContent.appendChild(new Element('span').update("&nbsp;&nbsp;"));

		weekendsContent = column1.appendChild(new Element('div', {'style': 'padding: 3px 0 6px 0;'}));
		this.includeWeekends = weekendsContent.appendChild(new Element('input', {'id': 'weekends', 'type': 'checkbox',
			'title': 'Include weekends in the printout'}));
		weekendsContent.appendChild(new Element('span').update("Include Weekends"));
		Event.observe(this.includeWeekends, 'click', this.includeWeekendToggle.bindAsEventListener(this));
		
		var column2 = topRow.appendChild(new Element('div', {'id': 'column2', 'style': 'padding: 0 19px 0 14px; float: left;' }));
		var orientContent = column2.appendChild(new Element('div', {'style': 'padding: 3px 0 6px 0;'}).update("Orientation: "));
		this.orientationSelect = new Element('select');
		orientContent.appendChild(this.orientationSelect);
		this.orientationSelect.appendChild(new Element('option', {'value': '0'}).update("Landscape"));
		this.orientationSelect.appendChild(new Element('option', {'value': '1'}).update("Portrait"));
		var fontContent = column2.appendChild(new Element('div', {'style': 'padding: 3px 0 6px 0;'}).update("Font: "));
		this.fontSelect = new Element('select');
		fontContent.appendChild(this.fontSelect);
		this.fontSelect.appendChild(new Element('option', {'value': '0'}).update("Arial"));
		this.fontSelect.appendChild(new Element('option', {'value': '1'}).update("Serif"));
		this.fontSelect.appendChild(new Element('option', {'value': '2'}).update("Sans Serif"));
		var fontSizeContent = column2.appendChild(new Element('div', {'style': 'padding: 3px 0 6px 0;'}).update("Font Size: "));
		this.fontSizeSelect = new Element('select');
		fontSizeContent.appendChild(this.fontSizeSelect);
		this.fontSizeSelect.appendChild(new Element('option', {'value': '0'}).update("Smaller"));
		this.fontSizeSelect.appendChild(new Element('option', {'value': '1'}).update("Small"));
		this.fontSizeSelect.appendChild(new Element('option', {'value': '2'}).update("Normal"));
		this.fontSizeSelect.appendChild(new Element('option', {'value': '3'}).update("Large"));
		this.fontSizeSelect.appendChild(new Element('option', {'value': '4'}).update("Larger"));

		var headerFooterRow = myContent.appendChild(new Element('div', {'id': 'headerFooterRow', 
				'style': 'clear: both; border-top: 1px #bec6cc solid; padding: 0 10px 0 6px;'}));
		var headerContent = headerFooterRow.appendChild(new Element('div', {'style': 'padding: 8px 0 6px 0;'}));
		this.headerCheckBox = headerContent.appendChild(new Element('input', {'id': 'headerBox', 'type': 'checkbox',
			'title': 'Include a header in the printout'}));
		headerContent.appendChild(new Element('span').update("Header"));
		headerContent.appendChild(new Element('span').update("&nbsp;&nbsp;"));
		this.headerInput = headerContent.appendChild(new Element('input', { 'type': 'text', 'id': 'headerText', 'size': '50' }));
		var footerContent = headerFooterRow.appendChild(new Element('div', {'style': 'padding: 3px 0 6px 0;'}));
		this.footerCheckBox = footerContent.appendChild(new Element('input', {'id': 'footerBox', 'type': 'checkbox',
			'title': 'Include a footer in the printout'}));
		footerContent.appendChild(new Element('span').update("Footer"));
		footerContent.appendChild(new Element('span').update("&nbsp;&nbsp;"));
		this.footerInput = footerContent.appendChild(new Element('input', { 'type': 'text', 'id': 'footerText', 'size': '50' }));

 		this.setContent(myContent);
		var closeButton = new Element('button', { 'class': 'kasBtn kasBtnRed' }).update("Cancel");
		this.addButton(closeButton);
		Event.observe(closeButton, 'click', this.closeButtonClick.bindAsEventListener(this));

		var helpButton = new Element('span')
		var spacer = new Element('span').update("&nbsp;&nbsp;");
		helpButton.appendChild(spacer);
		helpButton.appendChild(new Element('a', {'href': 'http://www.keepandshare.com/htm/help3/calendar/help3_05.php', 
					'target': '_blank'}).update("Help"));
		helpButton.appendChild(spacer);
		this.addButton(helpButton);
		
		var betaButton = new Element('span');
		this.betaCheckBox = betaButton.appendChild(new Element('input', {'id': 'betaCheckBox', 'type': 'checkbox',
			'title': 'Print using the beta print engine'}));
		betaButton.appendChild(new Element('span').update("Beta Print"));
//		this.addButton(betaButton);
		var pdfButton = new Element('span');
		pdfButton.appendChild(new Element('em', {'style': 'font-size:small'}).update("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A PDF will be generated.&nbsp;&nbsp;"));
		this.addButton(pdfButton);
		var okButton = new Element('button', { 'class': 'kasBtn kasBtnGreen', 'align': 'right' }).update("OK");
		this.addButton(okButton);
		Event.observe(okButton, 'click', this.okButtonClick.bindAsEventListener(this));
		
//		this.content.show();

		Calendar.setup({
			inputField : "printDlgSelectedDate", // ID of the input field
			ifFormat : "%m/%d/%y", // the date format
			button : "printDlgStartdateicon", // ID of the button
			align		: 'bc',
			singleClick	: true,
			step         :    1,            // display every year in the drop-down boxes
			weekNumbers  :  false,          // turn off week numbers
			firstDay     :  dowStart,    // 0 == Sunday is 1st day, 1 == Monday is first day
//			firstDay		: 0,
			onUpdate		: this.startDateChanged.bind(this)});
	},
	initPrintDialog: function(startDate, layoutNumber, includeWeekends, orientationPortrait, fontNumber, fontSizeNumber, headerOn, headerText,
			footerOn, footerText, useBeta) {

		this.layoutSelect.selectedIndex = layoutNumber;
		this.includeWeekends.checked = includeWeekends;
		this.savedWeekendState = includeWeekends;
		this.orientationSelect.selectedIndex = (orientationPortrait ? 1 : 0);
		this.fontSelect.selectedIndex = fontNumber;
		this.fontSizeSelect.selectedIndex = fontSizeNumber;
		this.headerCheckBox.checked = headerOn;
		this.headerInput.value = headerText;
		this.footerCheckBox.checked = footerOn;
		this.footerInput.value = footerText;
		this.betaCheckBox.checked = useBeta;
		this.savedBetaState = useBeta;
		var year = startDate.getFullYear();
		var month = startDate.getMonth();
		var day = startDate.getDate();
		var dateStr = twoDigitDateStr(month+1)+"/"+twoDigitDateStr(day)+"/"+twoDigitDateStr(year);
		this.mySelectedDate.value = dateStr;
		this.setNewLayout();  // set forLengthInput & forPeriodUnits & newStartDate
		this.content.show();
	},
	initPrintDialogStartDate: function(startDate, layoutNumber){

		this.layoutSelect.selectedIndex = layoutNumber;

		var year = startDate.getFullYear();
		var month = startDate.getMonth();
		var day = startDate.getDate();
		var dateStr = twoDigitDateStr(month+1)+"/"+twoDigitDateStr(day)+"/"+twoDigitDateStr(year);
		this.mySelectedDate.value = dateStr;
		this.setNewLayout();  // set forLengthInput & forPeriodUnits & newStartDate
		this.content.show();
	},
	validateNumeric: function(evt) {
		var theEvent = evt || window.event;
		var key = theEvent.keyCode || theEvent.which;
		key = String.fromCharCode( key );
		var regex = /[0-9]|\./;
		if( (!regex.test(key)) && (!((key >= 35) && (key <= 40))) && (!((key >= 48) && (key <= 57))) && (!((key >= 96) && (key <= 105))) &&
					(key != 8) && (key != 46) ){
			theEvent.returnValue = false;
			theEvent.preventDefault();
		}
	},
	startDateChanged: function(calendar){
			this.setNewStartDate();
	},
	okButtonClick: function(e) {
//            new AlertPopUp(this.generateRequest());
            var winObject = window.open(this.generateRequest(), 'pdfwindow');
			if(winObject==null){
				new AlertPopUp("Your web browser blocked the pop-up\nthat contains your printable Calendar.\n\nPlease turn off pop-up blocking for\nkeepandshare.com to fix this.");
			}
            this.hide();
	},
	closeButtonClick: function(e) {
		this.hide();
	},
	setNewStartDate: function () {
		var baseDate = parseDate(this.mySelectedDate.value);
		var month = baseDate.getMonth();
		var year = baseDate.getFullYear();
		var date = baseDate.getDate();
		// massage the start date depending on the current mode
		// Which Layout is currectly selected?
		var whichOne = this.layoutSelect.selectedIndex;
		var whichLayout = this.layoutSelect.options[whichOne].value;
		//Massage the date accordingly
		switch (whichLayout) {
			case "0": // Month
				date = 1;	// set to the first of the month
				break;
			case "1": //Week - adjust to Sunday
			case "5": // Week (column)
				baseDayAjust = baseDate.getDay();
				if (this.saveDowStart == 0) { // week starts on Sunday
					date -= baseDayAjust;
					if (!this.includeWeekends.checked)  // We are now on Sunday, if excluding weekends reset to Monday
						date += 1;
				} else { // week starts on Monday
					baseDayAjust -= 1;
					if (baseDayAjust < 0)
						baseDayAjust = 6;
					date -= baseDayAjust;
				}
				break;
			case "2": // Day
			case "3": // Events
				// Day and Event don't need to be adjusted
//				new AlertPopUp((month+1)+"/"+day+"/"+year);
				break;
			case "4": // Year on a page
				// set to January 1st
				month = 0;	// months are zero based
				date = 1;
				break;
		}
		// The week layout might cause month & even year to change - the beginning of the week might be in the
		// prev month or year
		var newDate = new Date(year, month, date, 0, 0, 0);
		month = newDate.getMonth();	// datetime stores month as 0 .. 11
		year = newDate.getFullYear();
		date = newDate.getDate();
		var dateStr = twoDigitDateStr(month+1)+"/"+twoDigitDateStr(date)+"/"+twoDigitDateStr(year);
		this.putObjInnerText(this.beginDateDisplay, dateStr);
	},
	includeWeekendToggle: function(){
		this.setNewStartDate();
	},
	setNewLayout: function(){
		var whichOne = this.layoutSelect.selectedIndex;
		var whichLayout = this.layoutSelect.options[whichOne].value;
	
		switch (whichLayout) {
			case "0": // Month
				this.forLengthInput.value = 1;
				this.putObjInnerText(this.forPeriodUnits, 'Month');
				if (this.includeWeekends.disabled) {
					this.includeWeekends.checked = this.savedWeekendState;
					this.includeWeekends.disabled = false;
				}
				if (this.betaCheckBox.disabled) {
					this.betaCheckBox.checked = this.savedBetaState;
					this.betaCheckBox.disabled = false;
				}
				break;
			case "1": //Week
			case "5": // Week (column)
				this.forLengthInput.value = 1;
				this.putObjInnerText(this.forPeriodUnits, 'Week');
				if (this.includeWeekends.disabled) {
					this.includeWeekends.checked = this.savedWeekendState;
					this.includeWeekends.disabled = false;
				}
				if (this.betaCheckBox.disabled) {
					this.betaCheckBox.checked = this.savedBetaState;
					this.betaCheckBox.disabled = false;
				}
				break;
			case "2": // Day
				this.forLengthInput.value = 1;
				this.putObjInnerText(this.forPeriodUnits, 'Day');
				if (!this.includeWeekends.disabled) {
					this.savedWeekendState = this.includeWeekends.checked;
					this.includeWeekends.checked = true;
					this.includeWeekends.disabled = true;
				}
				if (this.betaCheckBox.disabled) {
					this.betaCheckBox.checked = this.savedBetaState;
					this.betaCheckBox.disabled = false;
				}
				break;
			case "3": // Events
				this.forLengthInput.value = 14;
				this.putObjInnerText(this.forPeriodUnits, 'Days');
				if (!this.includeWeekends.disabled) {
					this.savedWeekendState = this.includeWeekends.checked;
					this.includeWeekends.checked = true;
					this.includeWeekends.disabled = true;
				}
				if (!this.betaCheckBox.disabled) {
					this.savedBetaState = this.betaCheckBox.checked;
					this.betaCheckBox.checked = true;
					this.betaCheckBox.disabled = true;
				}
				break;
			case "4": // Year on a page
				this.forLengthInput.value = 1;
				this.putObjInnerText(this.forPeriodUnits, 'Year');
				if (this.includeWeekends.disabled) {
					this.includeWeekends.checked = this.savedWeekendState;
					this.includeWeekends.disabled = false;
				}
				if (this.betaCheckBox.disabled) {
					this.betaCheckBox.checked = this.savedBetaState;
					this.betaCheckBox.disabled = false;
				}
				break;
		}
		this.setNewStartDate();
	},
	changeForUnits: function(){
		var whichOne = this.layoutSelect.selectedIndex;
		var whichLayout = this.layoutSelect.options[whichOne].value;
		var unitText;
	
		switch (whichLayout) {
			case "0": // Month
				unitText = 'Month';
				break;
			case "1": //Week
			case "5": // Week (column)
				unitText = 'Week';
				break;
			case "2": // Day
				unitText = 'Day';
				break;
			case "3": // Events
				unitText = 'Day';
				break;
			case "4": // Year on a page
				unitText = 'Year';
				break;
		}
		this.putObjInnerText(this.forPeriodUnits, unitText+(this.forLengthInput.value>1?'s':''));
	},
	putObjInnerText: function(obj, text){
		if (document.all) { // IE;
			obj.innerText = text;
		} else {
			obj.textContent = text;
		}
	},
	getObjInnerText: function(obj){
		if (document.all) { // IE;
			return obj.innerText;
		} else {
			return obj.textContent;
		}
	},
	layoutName: function() {
		var whichOne = this.layoutSelect.selectedIndex;
		switch (this.layoutSelect.options[whichOne].value) {
			case "0": // Month
				return 'Month1';
				break;
			case "1": //Week
				return 'Week1';
				break;
			case "2": // Day
				return 'Day0';
				break;
			case "3": // Events
				return 'Event0';
				break;
			case "4": // Year on a page
				return 'Year1';
				break;
			case "5": // Week (column)
				return 'Week0';
				break;
		}
	},
	generateRequest: function (){
		var string = '../calendar/printpdf.php?';
		var headerText = (this.headerCheckBox.checked ? escape(this.headerInput.value) : '');
		var footerText = (this.footerCheckBox.checked ? escape(this.footerInput.value) : '');
		
		// Going to have to convert dates to appropriate form
//		var dates = this.genDatesList(this.forLengthInput.value);
		var dates = this.forLengthInput.value;
		// Also, need to map Layout appropriately
		var layout = this.layoutName();

		var font = this.fontSelect.selectedIndex;
		var fontSize = this.fontSizeSelect.selectedIndex;
		var portrait = this.orientationSelect.selectedIndex;
		var baseDate = this.getObjInnerText(this.beginDateDisplay);
		
		var args = new Array('basedate='+baseDate,
							 'dates='+dates,
							 'i='+peopleid,
							 //'layout='+(prefs.yearonapageb[0] ? 'Year' : mode)+prefs.layoutb,
							 'layout='+layout,
							 'font='+font,
							 'size='+fontSize,
							 'pdftype='+(this.betaCheckBox.checked?'tcpdf':'oldpdf'),
							 'calendartable='+calendartable,
							 'customtitle='+headerText,
							 'footer='+footerText,
							 'portrait='+portrait,
							 'blackandwhite=0');
		if(mode != 'Day'){
			args.push('includeWeekends='+(this.includeWeekends.checked ? '1' : '0'));
		} else {
			args.push('includeWeekends=1');
		}
		string += args.join('&');
		return string;
	},
        genDatesList: function(numDates) {
            var retStr = '0';
            for (i = 1; i < numDates; i++) {
                retStr = retStr + ',' + i;
            }
            return retStr;
        }

});
