if (typeof WXBUnit == 'undefined'){
	var WXBUnit="C";
}
if(WXBUnit=="_F"){ var celsiusf="F";} else { var celsiusf="C"; }
document.write('<iframe marginheight="0" marginwidth="0" name="iframe1" id="iframe1" width="150" height="90" src="http://btn.weather.ca/weatherbuttons/template5.php?placeCode='+LocationID+'&cityNameNeeded=1&celsiusF='+celsiusf+'" align="top" frameborder="0" scrolling="no"></iframe>');
