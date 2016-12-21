// this script was provided to us from Telerik
// as a fix for Chrome 37 causing Aw Snap errors 
// when RadEditors were on the page
//
// it's been lightly modified in response to QA
// noticing that $telerik wasn't always defined
// which happens either when this script fires 
// before their code is ready, or the page doesnt
// have a Telerik control on it (rare)
//

jQuery(document).ready(function() {
	// don't blindly attach the handler -- make sure Telerik is actually
	// loaded and running
	if (typeof $telerik === "undefined" || typeof Telerik.Web.UI.Editor === "undefined") {
		console.log('ENC-18167 Telerik fix NOT active');
	} else {
		console.log('ENC-18167 Telerik fix active');

		(function($, $E, undefined) {
			$.extend($E._PopupController.prototype, {
				_registerGlobalBodyEventHandlers: function() {
					var configureFrameHandlers = function(toAttach, popupController) {
						//Attach a listener to all frame elements on the page
						var windowFrames = window.frames;

						for (var i = 0; i < windowFrames.length; i++) {
							var windowDocument = null;

							try {
								windowDocument = windowFrames[i].document;
							} catch (e) {
							}

							if (!windowDocument) {
								continue;
							}

							//this try catch is needed because of security problems with Firefox and other iframes on the page
							try {
								if (toAttach !== false) {
									popupController.attachToDocument(windowDocument);
								} else {
									popupController.detachFromDocument(windowDocument);
								}
							} catch (e) {
							}
						}
					}

					//ESC handler      
					var escHandler = Function.createDelegate(null, function(e) {
						if (e.keyCode == 27) {
							Telerik.Web.UI.Editor.PopupController.hideActivePopup();
						}
					});

					//the $addHandler method was replaced with $telerik.addExternalHandler because it 
					//causes a problem with disabled elements (especially the mousedown handler in this specific case)
					$telerik.addExternalHandler(document.body, 'keydown', escHandler);
					$telerik.addExternalHandler(document.body, 'mousedown', this._hideHandler);

					//Dispose the global event handlers         
					Sys.Application.add_unload(function() {
						$telerik.removeExternalHandler(document.body, 'mousedown', Telerik.Web.UI.Editor.PopupController._hideHandler);
						$telerik.removeExternalHandler(document.body, 'keydown', escHandler);
						configureFrameHandlers(false, Telerik.Web.UI.Editor.PopupController); //Supply instance
					});

					configureFrameHandlers(true, this);
				},
			});
		})($telerik.$, Telerik.Web.UI.Editor);

	}
});