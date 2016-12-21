function getElement(element) {
	if (document.all) return document.all[element];
	else if (document.getElementById) return document.getElementById(element);
	else return null;
}
function display_code(code,divname){
	var div = getElement(divname);
	// div will be null if the browser is not IE or not W3C DOM compliant
	if (div != null)
		div.innerHTML = code;
}
