/**
 * Scripts for common functions
 */

function CopyField()
{
  var SourceField
  var TargetField
  SourceField = document.getElementById(CopyField.arguments[0]);
  TargetField = document.getElementById(CopyField.arguments[1]);
  TargetField.value = SourceField.value;
}

function SetComboIndex()
{
  var SourceField
  var TargetField
  SourceField = document.getElementById(SetComboIndex.arguments[0]);
  TargetField = document.getElementById(SetComboIndex.arguments[1]);
  if (SourceField.options.selectedIndex < SourceField.options.length - 1)
  {
	TargetField.options.selectedIndex = SourceField.options.selectedIndex + 1;
  }
  else
  {
	TargetField.options.selectedIndex = 0;
  }
}
function SetAllDayEvent()
{
  var StartDate
  var EndDate
  var AllDayEvent
  
  AllDayEvent = document.getElementById(SetAllDayEvent.arguments[0]);
  StartDate = document.getElementById(SetAllDayEvent.arguments[1]);
  EndDate = document.getElementById(SetAllDayEvent.arguments[2]);
  
  if (AllDayEvent.checked == true)
  {
    StartDate.style.visibility = 'hidden';
    EndDate.style.visibility = 'hidden';
  }
  else
  {
    StartDate.style.visibility =  'visible';
    EndDate.style.visibility =  'visible';
  }
}

function CopyVenue()
{
  var SourceField
  var TargetField
  SourceField = document.getElementById(CopyVenue.arguments[0]);
  TargetField = document.getElementById(CopyVenue.arguments[1]);
  
  TargetField.value = SourceField.options[SourceField.options.selectedIndex].text;
  SourceField.options.selectedIndex = 0;
  TargetField.select();
}

function byid(eID){
	if (document.getElementById) 
		return document.getElementById(eID);
	else if (document.all)
		return document.all(eID);
	else
		return null;
}
function selIndex(eID){
    return byid(eID).options[byid(eID).selectedIndex].value;
}
function setselIndex(eID, v) {
    for ( var i = 0; i < byid(eID).options.length; i++ ) {
        if ( byid(eID).options[i].value == v ) {
            byid(eID).options[i].selected = true;
            return;
        }
    }
}


function DisableOnClick()
{
  var ctl  
  ctl = document.getElementById(DisableOnClick.arguments[0]);  
  ctl.disabled = true;
}