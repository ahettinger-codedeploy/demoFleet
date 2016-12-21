var WebCom_Components_MapQuest_Default_Template  = {
  getMarkupText : function(component)  {
  
    var v = component.getFormattingValues();
  
    var fullAddress = '${address} ${address_2}, ${city}, ${state} ${zip}, ${country}';
    var src = "${mapBaseURL}&zoom=${mapZoom}&q=" + fullAddress + '&center=' + fullAddress;
    
    if(v.mapFormat == 'static') {
      src = src + '&format=' + v.mapFormat + '&width=' + v.mapWidth + '&height=' + v.mapHeight + '';
    }
          
		var style = "width:" + v.mapWidth + "px;height:" + v.mapHeight + "px;";
	
		
		var embedHTML = '    <iframe src="'+src+'" style="' + style + '" frameborder="0"${onload}>' + '</iframe>';
		if(v.mapFormat == 'static') {
		  //onerror="this.className=\'map-error\'"   //Does not work within builder in FF
		  embedHTML = '    <img class="${imgClass}" src="'+src+'" style="' + style + '"${onload}/>';
		}
		
		var directions = '';

		if(v.mapShowDirections == true) {
      directions = '<a target="_blank" href="http://www.mapquest.com/?le=t&q1=&q2='+fullAddress+'&maptype=map&icid=mqdist_webcom" class="directions-button ${mapDirectionsAlign}"></a>';
		}
		
		return '<div class="map-container">' +
		       '  <div class="inner-map-container ${mapAlign}" style="' + style + '">${editOverlay}' +
		       '    <div class="map-address">' +
		       '      <span>${address} ${address_2}</span>' +
		       '      <span>${city}, ${state} ${zip} ${country}</span>' +
		       '    </div>' +
		       '    <div class="map-source">' +
		            embedHTML + directions +
		       '    </div>' +
		       '  </div>' +
		       '</div>';
  }
};
//Defaults
var WebCom_Components_MapQuest_Template_MasterTemplate_Publish = WebCom_Components_MapQuest_Default_Template;
var WebCom_Components_MapQuest_Template_MasterTemplate_Preview = WebCom_Components_MapQuest_Default_Template;
var WebCom_Components_MapQuest_Template_MasterTemplate_Edit    = WebCom_Components_MapQuest_Default_Template;
