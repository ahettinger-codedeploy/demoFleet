// Shared between EventCalendar.ascx.vb, EventCalendarDisplay.ascx.vb, and EventCalendarFilterControl.ascx.vb
// Attached from the file EventCalendarDisplay.ascx.vb

var sFilterSettings = '';
var EVTCAL_DELIM = '~';
var HID_CALID = 'hidCalID';
var HID_CATGID_V = 'hidCategoryIDV';
var HID_CATGID = 'hidCategoryID';
var CHKBOX_CATG = 'chkCategory';
var CHKBOX_CATG_V = 'chkCategoryV';
var CHKBOX_CAL = 'chkCalNameV';

window.onload = FilterControl_OnLoad; 

//********* when the calendar page first loaded **********
function FilterControl_OnLoad(){
    if (window.ATTR_IS_FILTER_DIV){
        var o = document.getElementsByTagName('div');
        for (iDiv=0;iDiv<o.length;iDiv++){ 
            if (attributeFound(o[iDiv], ATTR_IS_FILTER_DIV)){ 
                switch(parseInt(o[iDiv].getAttribute(ATTR_IS_FILTER_DIV))){
                    case NOT_CALENDAR_GROUP:
                        FilterControl_divCal_Onload(o[iDiv]);
                        break;
                    case IS_CALENDAR_GROUP:
                        FilterControl_divCalView_Onload(o[iDiv]);
                        break;
                }
            }
        }
    }
}

function attributeFound(elem, attr){ 
    if (elem.hasAttribute && elem.hasAttribute(attr)){ return true; } //mozilla
    if (elem.getAttribute(attr) != null){ return true; } //IE
    return false;
}

function FilterControl_divCalView_Onload(o){
    /* based on the calendar-category filter options, show/hide the events */
    var sCalId="";
    var sCatgId="";
    var aInputs = o.getElementsByTagName('input');
    var sPrefix = o.id.substring(0, o.id.indexOf('_'));
    var iInListView = parseInt(o.getAttribute(ATTR_IN_LISTVIEW_DISPLAY));
    
    for (iLoad=0;iLoad<aInputs.length;iLoad++){
        if (aInputs[iLoad].type == 'hidden'){
            if (aInputs[iLoad].id.indexOf(HID_CALID) > 0){
                sCalId = aInputs[iLoad].value;
            }else if(aInputs[iLoad].id.indexOf(HID_CATGID) > 0){
                sCatgId = aInputs[iLoad].value;
            }
        }else if(aInputs[iLoad].type == 'checkbox'){
            var evtdivs = new Array();
            if (aInputs[iLoad].id.indexOf(CHKBOX_CAL) > 0){ // a calendar checkbox
                evtdivs = document.getElementsByName('evt' + sCalId + '_');
            }else if (aInputs[iLoad].id.indexOf(CHKBOX_CATG_V) > 0){ // a category checkbox
                evtdivs = document.getElementsByName('evt' + sCalId + '_' + sCatgId);
            }
            if (evtdivs.length > 0){ 
                HideShowEvents(aInputs[iLoad].checked, evtdivs, sPrefix, iInListView); 
            }
        }
    }
}

function FilterControl_divCal_Onload(o){
    /* based on the category filter options, show/hide the events */
    var sCatgId="";
    var sCalId = o.getAttribute(ATTR_CAL_ID);
    var aInputs = o.getElementsByTagName('input');
    var sPrefix = o.id.substring(0, o.id.indexOf('_'));
    var iInListView = parseInt(o.getAttribute(ATTR_IN_LISTVIEW_DISPLAY));
    
    for (iLoad=0;iLoad<aInputs.length;iLoad++){
        if (aInputs[iLoad].type == 'hidden'){
            if (aInputs[iLoad].id.indexOf(HID_CATGID) > 0){
                sCatgId = aInputs[iLoad].value; 
            }
        }else if(aInputs[iLoad].type == 'checkbox'){
            if (aInputs[iLoad].id.indexOf(CHKBOX_CATG) > 0){
                var evtdivs = new Array();
                evtdivs = document.getElementsByName('evt' + sCalId + '_' + sCatgId);
                if (evtdivs.length > 0){ 
                    HideShowEvents(aInputs[iLoad].checked, evtdivs, sPrefix, iInListView); 
                }
            }                
        }
    }
}


//****** selection changed in Date Range DropDown *******
//cwc - jquerified
function OnDateRangeSelectionChange(oValue, sBeginID, sEndID) 
{

    $('#' + sBeginID).hide();
    $('#' + sEndID).hide();
        
    if(oValue == ENUM_SPECIFICDATE){
        $('#' + sBeginID).show();
        $('#' + sBeginID + ' > label').text("Date:");
    }

    if(oValue == ENUM_DATERANGE){
        $('#' + sBeginID).show();
        $('#' + sEndID).show();
        $('#' + sBeginID + ' > label').text("Begin:");
    }
    
    return true;
}

//****** the Filter image button "Filter Events" / "Closed Filter" is clicked *******
function OnFilterEvtClick(lblID, catgDivID){   
    var oCategoryDiv = document.getElementById(catgDivID);
    var oLbl = document.getElementById(lblID); 
    if ((oLbl.innerHTML.indexOf('Show') >= 0)){ 
        oLbl.innerHTML = 'Hide Event Filter';
        document.poppedLayer1 = oCategoryDiv;
        document.poppedLayer1.className = "EventCalFilter_Show CalendarFilterContainer";
    }else{
        oLbl.innerHTML = 'Show Event Filter';
        document.poppedLayer1 = oCategoryDiv;
        document.poppedLayer1.className = "EventCalFilter_Hide CalendarFilterContainer";
    }
}

function OnFilterEvtTextClick(o, catgDivID){
    var oCategoryDiv = document.getElementById(catgDivID);
    if (o.innerHTML.indexOf('Show') >= 0){
        o.innerHTML = 'Hide Event Filter';
        document.poppedLayer1 = oCategoryDiv;
        document.poppedLayer1.className = "EventCalFilter_Show CalendarFilterContainer";
    }else{
        o.innerHTML = 'Show Event Filter';
        document.poppedLayer1 = oCategoryDiv;
        document.poppedLayer1.className = "EventCalFilter_Hide CalendarFilterContainer";
    }    
}

//****** in the FILTER CONTROL, a Calendar checkbox is clicked **********
function OnCalendarClick(oCheckbox, bChecked, calid, catgids, catgchkboxids, iInListView){
    var array_IDs_catg = new Array();
    array_IDs_catg = catgids.split(',');
    
    var array_IDs_catgChkbox = new Array();
    array_IDs_catgChkbox = catgchkboxids.split(',');
    
    var array_divs_cal = new Array();
    var array_boxes_catg = new Array();
    var catg;
    var box;
    
    /* if a calendar checkbox is checked, show all the events of this calendar; otherwise, hide them.
    A little problem to solve... say we have two cal group parts on the same page. Both group parts contain the "Golf calendar".
    The page, given the same category filter settings and view date in both parts, displays the same set of golf events.
    The element name of an event does not tell us which group part it belongs to. 
    
    Tell HideShowEvents() the server-side generated id prefix of oCheckbox. Let it figure out which part the user is filtering on.
    */
    var sPrefix = oCheckbox.id.substring(0, oCheckbox.id.indexOf('_'));
    for (catg in array_IDs_catg){
        array_divs_cal = document.getElementsByName('evt' + calid + '_' + array_IDs_catg[catg]);
        HideShowEvents(bChecked, array_divs_cal, sPrefix, iInListView);
    }
 
    // if a calendar checkbox is checked, check all the categories checkboxes of this calendar; otherwise, unchecked them.
    for (box in array_IDs_catgChkbox){
        array_boxes_catg = document.getElementsByName(array_IDs_catgChkbox[box]);
        ToggleCheckbox(bChecked, array_boxes_catg);
    }
 
    return false;
}

//****** in the FILTER CONTROL, a Category checkbox is clicked **********
function OnCategoryClick(oCheckbox, bChecked, catg, calid, iInListView){

    var categoryid = document.getElementById(catg).value;
    var evtdivs = new Array();
    evtdivs = document.getElementsByName('evt' + calid + '_' + categoryid);
    
    // Tell HideShowEvents() the server-side generated id prefix of oCheckbox. Let it figure out which part the user is filtering on.
    var sPrefix = oCheckbox.id.substring(0, oCheckbox.id.indexOf('_'));
    HideShowEvents(bChecked, evtdivs, sPrefix, iInListView);
    
    return false;
}

function HideShowEvents(bChecked, myarray, sCheckboxIdPrefix, iInListView){
    if (bChecked){
        for (i=0;i<myarray.length;i++){
            if (ContinueHideShow(myarray[i], sCheckboxIdPrefix, iInListView)){
                myarray[i].style.display = 'block';
                myarray[i].style.visibility = 'visible';
            }
        }
    }else{
        for (i=0;i<myarray.length;i++){
            if (ContinueHideShow(myarray[i], sCheckboxIdPrefix, iInListView)){
                myarray[i].style.display = 'none';
                myarray[i].style.visibility = 'hidden';
            }
        }
    }

    if (iInListView) {
        //Hide any days that have no events associated with them.
        //CWC - pretty fragile way of doing this, but short of refactoring the entire
        // filter control this is the best way (I think) to do this.
        $('.ListViewEventDate').each(function() {
            var Walker = $(this).next();
            var vis = false;
            var walk = true;
            while (walk) {
                if (Walker[0].tagName != 'SPAN') { //not a span, so we are looking at an event
                    if (Walker.css("display") != "none") { //an event on this day is visible, show the day
                        vis = true;
                        walk = false;
                    } else if (Walker.next().length != 0) { //invisible event, if there are more events, keep walking
                        Walker = Walker.next();
                    } else { //no more events, stop
                        walk = false;
                    }
                } else { //we hit a span, stop walking
                    walk = false;
                }
            }
            if (!vis) { $(this).hide(); }
            else { $(this).show(); }
        });
    }
}

function ContinueHideShow(o, sCheckboxIdPrefix, iInListView){
    var sIdPrefixToCheck;
    if (iInListView == 1){
        sIdPrefixToCheck = o.parentNode.parentNode.id;
    }else{
        sIdPrefixToCheck = o.parentNode.parentNode.parentNode.parentNode.parentNode.id;
    }
    sIdPrefixToCheck = sIdPrefixToCheck.substring(0,sIdPrefixToCheck.indexOf('_'));
    return (sIdPrefixToCheck == sCheckboxIdPrefix);
}

function ToggleCheckbox(bChecked, myarray){
    if (bChecked){
        for (i=0;i<myarray.length;i++){
            myarray[i].checked = true;
        }
    }else{
        for (i=0;i<myarray.length;i++){
            myarray[i].checked = false;
        }
    }
}


//ICallbackEventHandler events
//****** in the FILTER CONTROL, the "Save" button is clicked *******
function OnSaveFilterControlClick(sDivID, bIsCalGroup)
{
    sFilterSettings = GatherFilterSelections(sDivID, bIsCalGroup);
}

function OnFilterControlCallback(Result,Context) {
    // Result gives us the client id of the "Saved" message span control.
    var oSpan = document.getElementById(Result);
    if (oSpan){
        oSpan.style.display='inline';
        oSpan.style.visibility='visible';
        self.setTimeout('hideSavedSpan(\''+Result+'\')' , 2000);
    }
}

function hideSavedSpan(s){
    var oSpan = document.getElementById(s);
    if (oSpan){
        oSpan.style.display='none';
	    oSpan.style.visibility='hidden';
    }
}

function GatherFilterSelections(sDivID, bIsCalGroup)
{
    var s='';
    if (!sDivID) { return s; }
    var oDiv = document.getElementById(sDivID);
    var aInputs = oDiv.getElementsByTagName('input');
    
    if ((bIsCalGroup == 'false') || (bIsCalGroup == 0)) {
        for (i=0;i<aInputs.length;i++){
            if (aInputs[i].type == 'hidden'){
                if (aInputs[i].id.indexOf(HID_CATGID) > 0){
                    s += PARAM_CATG + aInputs[i].value + EVTCAL_DELIM;  // CATG:xxxx-xxxx-xxxxxx-xxxx~1~        
                }
            }else if(aInputs[i].type == 'checkbox'){
                if (aInputs[i].id.indexOf(CHKBOX_CATG) > 0){
                    if (aInputs[i].checked){
                        s += '1' + EVTCAL_DELIM;
                    }else{
                        s += '0' + EVTCAL_DELIM;
                    }
                }                
            }
        }
    }else{
        for (i=0;i<aInputs.length;i++){
            if (aInputs[i].type == 'hidden'){
                if (aInputs[i].id.indexOf(HID_CALID) > 0){
                    s += PARAM_CAL + aInputs[i].value + EVTCAL_DELIM;  // CAL:8~1~        
                }else if (aInputs[i].id.indexOf(HID_CATGID_V) > 0){
                    s += PARAM_CATG + aInputs[i].value + EVTCAL_DELIM;  // CATG:xxxx-xxxx-xxxxxx-xxxx~1~       
                }
            }else if(aInputs[i].type == 'checkbox'){ 
                if ( (aInputs[i].id.indexOf(CHKBOX_CAL) > 0) || (aInputs[i].id.indexOf(CHKBOX_CATG_V) > 0) ){
                    if (aInputs[i].checked){
                        s += '1' + EVTCAL_DELIM;
                    }else{
                        s += '0' + EVTCAL_DELIM;
                    }
                }                
            }
        }
    }
    return s;
}



// v5.5 ical export: collect current filter selections
function OnExportEventClicked(o)
{
    var s = GatherFilterSelections(o.getAttribute('filter_div'), o.getAttribute('is_calgroup').toLowerCase());   
    document.getElementById(o.getAttribute('hid_filter_info')).value = s;
}