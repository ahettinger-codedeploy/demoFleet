(
  function () {
    var VERSION = "1.2";
    var NAME    = "com.web.components.mapquest";
    var scripts = ["js/templates.js"];
    var styles  = ["css/mapquest.css"];

    var MAP_PROVIDER_URL = "http://www.mapquest.com/embed?icid=mqdist_webcom";
    //foreign resources
    var lib = new WebCom.ResourceLoader.Library("WebCom.Components.MapQuest", NAME, VERSION, scripts, styles )    
    WebCom.ResourceLoader.importLib(lib);

    function WebCom_Components_MapQuest() {
    
		    WebCom.Components.Component.apply(this,[lib]);

		    var self = this; // to overcome callback scoping
		
		    this.init = function (id, config) {
			    self.id = id;
			    self.renderMode = config.miscData.renderMode;

			    if (config.listeners) {
				    for (var eventName in config.listeners) {
					    self.on(eventName, config.listeners[eventName].handler, config.listeners[eventName].scope);
				    }
			    }	

			    // if the country is GB (UK) we need to use a different URL
			    formattingValues = {
			      mapBaseURL: config.componentData.location.country === 'GB' ? 'http://www.mapquest.co.uk/embed?icid=mqdist_webcom' : MAP_PROVIDER_URL,
			      address: config.componentData.location.address,
			      address_2: config.componentData.location.address_2,
			      city: config.componentData.location.city,
			      state: config.componentData.location.state,
			      zip: config.componentData.location.zip,
			      country: config.componentData.location.country,
			      mapWidth: config.componentData.displayOptions.mapWidth,
			      mapHeight: config.componentData.displayOptions.mapHeight,
			      mapZoom: config.componentData.displayOptions.mapZoom,
			      mapAlign: config.componentData.displayOptions.mapAlign,
			      mapShowDirections: config.componentData.displayOptions.mapShowDirections,
 			      mapDirectionsAlign: config.componentData.displayOptions.mapDirectionsAlign,
			      mapFormat: config.componentData.displayOptions.mapFormat,
			      onload: '',
			      editOverlay: '',
			      imgClass: ''
			    };

		    };
        
		    this.getMasterTemplate = function(/*RenderMode*/ mode) {
			    return self.getTemplate("MasterTemplate", mode);
		    };
		
		    this.getFormattingValues = function () {
          formattingValues.imgClass = 'map-loading';
          if (self.renderMode == 'Edit') {
        	  formattingValues.onload = ' onload="hideLoading()" ';
        	  formattingValues.editOverlay = '<div class="edit-overlay"></div>';
        	  
        	  //Map format static for edit mode, so we minimize the number of http requests the client has to make
        	  //This does not work at this time with bad addresses: Error constructing static map: Cannot display a static map of an unresolved location
        	  //Firefox and chrome has problems with iframes within iframes
        	  //if(WebCom.Browser.isGecko || WebCom.Browser.isWebKit) {
        	    formattingValues.mapFormat = 'static';
        	  //}
          }
          //Mapquest Iframe not compatible with our builder super iframe stack, so we display a image instead of advanced draggable map (Preview only)
          if (self.renderMode == 'Preview') {
            formattingValues.mapFormat = 'static';
          }
          return formattingValues;
		    };
		
        return this;
    };
	
    WebCom_Components_MapQuest.prototype = new WebCom.Components.Component();
    WebCom.Components.MapQuest = {
      initInstances : function (instances, globalSettings) {
        for (var i=0; i < instances.length; i++) {
          var inst = instances[i];

          if (globalSettings && globalSettings.listeners) {
            if (inst["listeners"] == null) {
              inst["listeners"] = globalSettings.listeners;
            } else {
              var listeners = inst["listeners"];
              for (var eventName in globalSettings.listeners) {
                if (listeners[eventName] == null) {
                  listeners[eventName] = globalSettings.listeners[listenerName];
                }
              }
            }
          }
		  
          var comp = new WebCom_Components_MapQuest();
          comp.init(inst.id, inst);
          comp.render(comp.renderMode);
        }
      }
      
    };

	
  }
)();
