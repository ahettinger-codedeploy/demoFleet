//Script for header search form
var defaultvalue = "Search by keyword";
function clearme(field) {
  field.setAttribute("class","searchbox_txtinput_highlight");
  if (field.value == defaultvalue) {
	field.value = "";
  }
}
function checkme(field) {
  if(field.value == "") {
	field.value = defaultvalue;
	field.setAttribute("class","searchbox_txtinput");
  }
}