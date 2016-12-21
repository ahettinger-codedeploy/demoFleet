/*
JSTarget function by Roger Johansson, www.456bereastreet.com
*/
var JSTarget = {
	init: function(att,val,warning) {
		if (document.getElementById && document.createElement && document.appendChild) {
			var strAtt = ((typeof att == 'undefined') || (att == null)) ? 'class' : att;
			var strVal = ((typeof val == 'undefined') || (val == null)) ? 'nwindow' : val;//TN changed from "non-html"
			var strWarning = ((typeof warning == 'undefined') || (warning == null)) ? '' : warning;//TN made undefine or no warning value empty by default used to be  (opens in a new window)
			var oWarning;
			var arrLinks = document.getElementsByTagName('a');
			var oLink;
			var oRegExp = new RegExp("(^|\\s)" + strVal + "(\\s|$)");
			for (var i = 0; i < arrLinks.length; i++) {
				oLink = arrLinks[i];
				if ((strAtt == 'class') && (oRegExp.test(oLink.className)) || (oRegExp.test(oLink.getAttribute(strAtt)))) {
					oWarning = document.createElement("em");
					oWarning.appendChild(document.createTextNode(strWarning));
					oLink.appendChild(oWarning);
					oLink.onclick = JSTarget.openWin;
				}
			}
			//TN add support for form
			var forms = document.getElementsByTagName("form");
			var frm;
			for(var i = 0; i < forms.length; i++){
			   frm = forms[i];
				if ((strAtt == 'class') && (oRegExp.test(frm.className)) || (oRegExp.test(frm.getAttribute(strAtt))) && (frm.getAttribute('action').substring(0, 4) == 'http')) {
					//TN has no valu because not link as above: frm.onsubmit = JSTarget.openWin;
					frm.target = '_blank';
				}
			 } 
			//TN EOF
			oWarning = null;
		}
	},
	openWin: function(e) {
		var event = (!e) ? window.event : e;
		if (event.shiftKey || event.altKey || event.ctrlKey || event.metaKey) return true;
		else {
		    var oWin = window.open(this.getAttribute('href'), '_blank');
			if (oWin) {
				if (oWin.focus) oWin.focus();
				return false;
			}
			oWin = null;
			return true;
		}
	}
};
//TN moved to addDOMLoadEvent:JSTarget.addEvent(window, 'load', function(){JSTarget.init();});