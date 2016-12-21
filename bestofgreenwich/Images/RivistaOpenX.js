/**
 * RivistaOpenX
 * @author Jeff Fohl jeff@godengo.com
 * @author Peter Scannell pscannell@gtxcel.com
 * @copyright GTxcel, 2012 - 2014
 * 
 * Dependencies: jQuery, OpenX
 * 
 * OpenX API documentation: http://docs.openx.com/ad_server/adtagguide_tagapi_instancemethods.html
 * 
 * USE:
 * 
 * Initialize and display on page load:
 *     RivistaOpenX.init({"rads":{<associative array of ads>}, "adCategory":<optional category>});
 * 
 *         {<associative array of ads>} = {
 *                                         radKey1:{"instanceid:<OpenX instance ID>, "min":<minWidth>, "max":<maxWidth>},
 *                                         radKey2:{"instanceid:<OpenX instance ID>, "min":<minWidth>, "max":<maxWidth>}
 *                                        }
 * 
 *         radKey - the Position number from the OpenX definition
 *         instanceid - generated; random string if generated on the fly
 *         min - optional; minimum browser width for ad display
 *         max - optional; maximum browser width for ad cisplay
 * 
 * 
 * Initialize and display after page loads (usually called for single OpenX ad unit)
 *     RivistaOpenX.storeAds({<associative array of ads>});
 *     RivistaOpenX.display(<OpenX instance key>);
 *     
 *         <OpenX instance key> = unique string to use as lookup key for generated OX() instance
 * 
 *     The ad unit is registered and displayed in an html div:
 *         <div id="rad_<OpenX instance key>_<radKey>" class="rad"></div>
 * 
 *         The caller is responsible for creating and displaying this div.
 * 
 * 
 * Once loaded, ads on the page can be refreshed (reloaded) through a call to:
 *     RivistaOpenX.refreshAds();
 * 
 *     Certain modules will call this automatically through the updateallads event; for example:
 *     slideshow gallery.
 *     
 *     It is possible to refresh the ad units for only one OpenX Instance, but this will not be common.
 *         RivistaOpenX.refreshAds(<OpenX instance key>);
 * 
 */

var RivistaOpenX = (function(rjQuery, OX) {
	var OXInstances = {};
	var rads = {};
	var adPositions = {};
	var loadedAds = {};
	var slottedAds = {};
	var adcategory = "";

	/**
	 * Call OpenX to register the html id of the OpenX ad div with the OpenX object
	 * for the adPosition.  Checks to see if it was already set before setting.
	 * 
	 * @param radKey string value of the OpenX ad position number
	 */
	function setAdUnitSlot(instanceId, radKey) {
		if (!checkStatus(instanceId, radKey, "slotted")) {
			var slotid = '#rad_'+instanceId+"_"+radKey;
			var innerAdId = "inner_rad_"+instanceId+"_"+radKey;
			var $rad = rjQuery(slotid);
			$rad.append("<div id="+innerAdId+"></div>");
			OXInstances[instanceId].setAdUnitSlotId(radKey, innerAdId);
			storeStatus(instanceId, radKey, "slotted");
		}
	};

	/**
	 * Keep track of whether or not a particular OpenX operation has been performed
	 * for each of the ad positions we need to register.
	 * 
	 * @param instanceId stored key for OX() Instance
	 * @param radKey string value of the OpenX ad position number
	 * @param statusType the particular type of OpenX operation we are tracking
	 */
	function storeStatus(instanceId, radKey, statusType) {
		if (rjQuery.inArray(statusType, ["initialized", "slotted", "loaded"]) == -1) {
			return;
		}
		if (checkStatus(instanceId, radKey, statusType)) {
			return;
		}
		if (statusType == "initialized") {
			if (!RivistaUtils.paramExists(instanceId, adPositions)) {
				adPositions[instanceId] = [];
			}
			adPositions[instanceId].push(radKey);
		} else if (statusType == "slotted") {
			if (!RivistaUtils.paramExists(instanceId, slottedAds)) {
				slottedAds[instanceId] = [];
			}
			slottedAds[instanceId].push(radKey);
		} else if (statusType == "loaded") {
			if (!RivistaUtils.paramExists(instanceId, loadedAds)) {
				loadedAds[instanceId] = [];
			}
			loadedAds[instanceId].push(radKey);
		}
	};

	/**
	 * Check to see if an ad position has been added to any of our status lists.
	 * 
	 * @param instanceId stored key for OX() Instance
	 * @param radKey string value of the OpenX ad position number
	 * @param statusType the particular type of OpenX operation we are tracking
	 */
	function checkStatus(instanceId, radKey, statusType) {
		if (rjQuery.inArray(statusType, ["initialized", "slotted", "loaded"]) == -1) {
			return null;
		}
		if (statusType == "initialized") {
			return (rjQuery.inArray(radKey, adPositions[instanceId]) != -1);
		} else if (statusType == "slotted") {
			return (rjQuery.inArray(radKey, slottedAds[instanceId]) != -1);
		} else if (statusType == "loaded") {
			return (rjQuery.inArray(radKey, loadedAds[instanceId]) != -1);
		}
	};


	return {

		/**
		 * Initialize each set of OpenX ads.
		 * 
		 * Ads that are added when the page is created all go into a
		 * default instance and will all be loaded and displayed through
		 * a call to "displayAll."
		 * 
		 * Ads that have been added on the fly, will (usually) all go into
		 * their own instance, so that there will generally be one ad unit
		 * per OpenX Instance for those ads.  The caller is responsible for
		 * calling "storeAds" and then calling "display" for each ad unit added
		 * on the fly.
		 * 
		 * @param settings
		 *     rads set of OpenX ads to initialize
		 *     adCategory ad category setting
		 */
		init: function(settings) {
			settings = rjQuery.extend(
					{
						"rads": {},
						"adCategory": ""
					},
					settings||{}
			);
			// store global values for later use
			adcategory = settings.adCategory;
			// check ad size, then initialize and store
			RivistaOpenX.storeAds(settings.rads);
		},

		/**
		 * Given an associative array of ad objects, check to see if the ad will fit on
		 * the page given min and max parameters.
		 * If we are going to display the ad, create an OpenX Instance for the ad, or
		 * reuse one that has already been created for the ad and add the ad to the
		 * OpenX Instance (AddAdUnit call).
		 * Then, store the ad object and mark it as "initialized."
		 * 
		 * @param newRads object containing one or more ad objects
		 */
		storeAds: function(newRads) {
			rjQuery.each(newRads, function(radKey, params) {
				var instanceId = params.instanceid;
				rads[instanceId] = RivistaUtils.paramExists(instanceId, rads) ? rads[instanceId] : {};
				rads[instanceId][radKey] = params;

				var radMin = (RivistaUtils.paramExists("min", params) && params['min'] != null) ? params['min'] : false;
				var radMax = (RivistaUtils.paramExists("max", params) && params['max'] != null) ? params['max'] : false;
				var createAd = false;
				if (radMin !== false && radMax !== false) {
					if (radMin <= document.documentElement.clientWidth && radMax >= document.documentElement.clientWidth) {
						createAd = true;
					}
				} else if (radMin !== false) {
					if (radMin <= document.documentElement.clientWidth) {
						createAd = true;
					}
				} else if (radMax !== false) {
					if (radMax >= document.documentElement.clientWidth) {
						createAd = true;
					}
				} else {
					createAd = true;
				}

				if (createAd == true) {
					var instanceId = params.instanceid;
					rads[instanceId] = RivistaUtils.paramExists(instanceId, rads) ? rads[instanceId] : {};
					rads[instanceId][radKey] = params;

					var oxInstance = null;
					if (RivistaUtils.paramExists(instanceId, OXInstances)) {
						oxInstance = OXInstances[instanceId];
					} else {
						// OX() is a global method which creates an instance of the OpenX object
						oxInstance = OX();
						OXInstances[instanceId] = oxInstance;	// store instance
						// if we have an ad category, register it as a "section" variable in this instance
						if (adcategory !== null) {
							oxInstance.addVariable("section", adcategory);	// we use "section" as our variable tag
						}
					}
					if (!checkStatus(instanceId, radKey, "initialized")) {
						// we are registering the ad position with our OpenX instance
						oxInstance.addAdUnit(radKey);
						storeStatus(instanceId, radKey, "initialized");
					}
				} else {
					// remove the display div, since we aren't going to be displaying this ad
					rjQuery('#rad_'+instanceId+'_'+radKey).remove();
				}
			});
		},

		/**
		 * Load and Display the ads for an OX Instance.
		 * 
		 * Init has created an OpenX instance for each group of ad units
		 * that we plan to associate with each other.
		 * Now we set each ad unit into its own slot in the OpenX Instance
		 * and register the html id of the div where the ad unit will be
		 * displayed.
		 * Then we call the "load" method of the instance to actually load and
		 * display the ad in the div.
		 * We store the ad position value in the loadedAds array so we don't try
		 * to load it again and then make sure the ad div is visible.
		 * 
		 * Ads that are added when the page is created all go into the
		 * "default" instance and will all be loaded and displayed through
		 * a call to "displayAll."
		 * 
		 * Ads that have been added on the fly, will (usually) all go into
		 * their own instance, so that there will generally be one ad unit
		 * per OpenX Instance for those ads.  The caller is responsible for
		 * calling init and then calling display for each ad unit added
		 * on the fly.
		 * 
		 * @param instanceId stored key for a particular OX() Instance
		 */
		display: function(instanceId) {
			var displayInstance = false;
			rjQuery.each(rads[instanceId], function(radKey, params) {
				var $radUnit = rjQuery('#rad_'+instanceId+"_"+radKey);
				if (!checkStatus(instanceId, radKey, "loaded") && $radUnit.length > 0) {
					setAdUnitSlot(instanceId, radKey);
					displayInstance = true;
					$radUnit.show();
					storeStatus(instanceId, radKey, "loaded");
				}
			});
			if (displayInstance) {
				OXInstances[instanceId].load();
			}
			
		},

		/**
		 * Load and Display all the ads that are currently visible.
		 * Calls display for each OpenX Instance created to that point.
		 */
		displayAll: function() {
			rjQuery.each(OXInstances, function(instanceId, oxInstance) {
				RivistaOpenX.display(instanceId);
			});
		},

		/**
		 * Refresh the ad on a page for a given OX Instance.  Ads
		 * must be registered to a particular OpenX Instance, and it
		 * is the OpenX Instance that deals with loading/refreshing
		 * the ads for that instance.
		 * 
		 * This means that a particular ad unit, registered to a given
		 * OpenX Instance cannot be refreshed individually.
		 * 
		 * NOTE: It will be rare for this method to be called
		 * from an external source, as we will usually refresh all visible
		 * ads on the page at once.
		 * 
		 * NOTE: We are calling refreshAds to do the refresh, but this method
		 * is not listed in the online API guide (see header for link).
		 * If we find that this stops working, calling load also seems to work.
		 * 
		 * @param instanceId stored key for a particular OX() Instance
		 */
		refreshAd: function(instanceId) {
			if (RivistaUtils.paramExists(instanceId, OXInstances)) {
				OXInstances[instanceId].refreshAds();	// undocumented refresh call
//				OXInstances[instanceId].load();	// might need to switch to this documented call if refreshAds stops working
			}
		},

		/**
		 * Refresh either an array of ad instances or all ads at once, if an array
		 * is not specified.
		 * Calls refreshAd with instanceId for each instance.
		 * 
		 * @params instanceIdArray array of instance Ids to refresh
		 */
		refreshAds: function(instanceIdArray) {
			if (rjQuery.type(instanceIdArray) == "undefined") {
				rjQuery.each(OXInstances, function(instanceId, oxInstance) {
					RivistaOpenX.refreshAd(instanceId);
				});
			} else {
				instanceIdArray = RivistaUtils.checkObject(instanceIdArray, [], "array");
				if (instanceIdArray.length > 0) {
					rjQuery.each(instanceIdArray, function(index, instanceId) {
						RivistaOpenX.refreshAd(instanceId);
					});
				}
			}
		}

	};

})(rjQuery,OX);



/**
 * Manage OpenX ads placed within a mixed content list.
 */
var MCLAdsOpenX = (function(rjQuery) {

	return {
		/**
		 * Check to see if any OpenX ads placed in mixed content lists have the
		 * notdisplayed class tag.  If so, initialize and display those
		 * ads.
		 * 
		 * These ads are created after the initial page load.
		 * Each ad must be created with its own OpenX instance,
		 * so that ads don't interfere with each other and each
		 * ad can be populated and refreshed on the fly.
		 * 
		 * OpenX Instance ID
		 * Create a new OpenX instance Id by appending a
		 * random or semi-random numbr to the module id.  In this
		 * case, we just use the timestamp in milliseconds, since
		 * we won't be creating two at exactly the same time.
		 * 
		 * Ad Key (radKey)
		 * We use the ad position as the radKey.  This is the OpenX
		 * key for the ad to display.  It is paired with the instance ID
		 * in the RivistaOpenX class to form a unique lookup key.
		 * 
		 * HTML Id
		 * We generate the html id from the instanceId and the
		 * radKey.  Since the instanceId should be unique, this
		 * should generate a unique html id.
		 * 
		 * Data values populated and passed in from contentitemsummary.tpl
		 * @param data-moduleid Rivista module id
		 * @param data-position OpenX ad position
		 * @param data-min admin setting for min browser width
		 * @param data-max admin setting for max browser width
		 * 
		 */
		displayNewAds: function() {
			var $openxAds = rjQuery(".rad.openx.notdisplayed");
			$openxAds.each(function(index, openxAd) {
				var $openxAd = rjQuery(openxAd);

				var instanceId = $openxAd.attr("data-moduleid")+"_"+RivistaUtils.generateUUID(8);
				var radKey = $openxAd.attr("data-position");
				var htmlId="rad_"+instanceId+"_"+radKey;
				$openxAd.attr("id", htmlId);

				var rad = {};
				var min = ($openxAd.attr("data-min") != "" && $openxAd.attr("data-min") > 0) ? $openxAd.attr("data-min") : null;
				var max = ($openxAd.attr("data-max") != "" && $openxAd.attr("data-max") > 0) ? $openxAd.attr("data-max") : null;
				rad[radKey] = {
						"instanceid": instanceId,
						"min": min,
						"max": max
				}
				RivistaOpenX.storeAds(rad);
				RivistaOpenX.display(instanceId);
				
				$openxAd.removeClass("notdisplayed");
			});
		},
	};

})(rjQuery);



rjQuery(document).ready(function() {
	RivistaOpenX.displayAll();

	// If there are any MCL ads available at startup, initialize and display any MCL ads that have placeholders
	MCLAdsOpenX.displayNewAds();

	// setup ad refresh
	// so we don't accidentally register more than once
	rjQuery("body").off("updateallads.openx");
	// register this event, thrown when certain modules change content
	rjQuery("body").on("updateallads.openx", function() {
		RivistaOpenX.refreshAds();
	});

});
