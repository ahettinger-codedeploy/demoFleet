/// <reference path="_references.js" />
/// <reference path="/jquery/jquery-1.9.1-vsdoc.js" />
/// <reference path="/MicrosoftAjax/3.5/MicrosoftAjax.debug.js" />

//**PUT EVERYTHING AFTER THIS IF STATEMENT**
if (window.imodules_common_loaded == null)
{ //Load first time only
	window.imodules_common_loaded = true;

	// disable writing to the console if we're not in firefox
	if (typeof console === "undefined")
	{
	    console = { log: function () { }, warn: function () { }, error: function () { } };
	}

	window.loaded = false;

	if (!window.imod) var imod = {};
	if (!imod.logger) imod.logger = {};

	imod.logger.LogToService = function (logLevel, message, url, lineNumber) {

	    IModController.debug = false;
	    if (!IModController.debug)
	    {
	    	return;
	    }

	    var currentUrl = new URI(window.location);
	    var qsParams = currentUrl.query(true);
	    var siteId = qsParams.sid;
	    if (IModController.siteId) {
	        siteId = IModController.siteId;
	    }
	    if (!siteId) {
	        return;
	    }

	    var logData = Sys.Serialization.JavaScriptSerializer.serialize({
	        "message": message,
	        "lineNumber": lineNumber ? lineNumber : '',
	        "url": '' + window.location + ''
	    });
	    var logControllerUrl = "/apiservices/system/JsLog/" + logLevel;
	    
	    jQuery.ajax({
	        type: "POST",
	        headers: { SiteInfoId: IModController.siteId, GroupId: IModController.groupId },
	        url: logControllerUrl,
	        data: logData,
	        contentType: "application/json; charset=utf-8"
	    });

	};

	if (Function.prototype.bind) {
	    imod.log = Function.prototype.bind.call(console.log, console);
	    imod.warn = Function.prototype.bind.call(console.warn, console);
	    imod.error = Function.prototype.bind.call(console.error, console);
	}
	else {
	    imod.log = function () {
	        Function.prototype.apply.call(console.log, console, arguments);
	    };
	    imod.warn = function () {
	        Function.prototype.apply.call(console.warn, console, arguments);
	    };
	    imod.error = function () {
	        Function.prototype.apply.call(console.error, console, arguments);
	    };
	}

	var oldOnError = window.onerror;
	window.onerror = function (message, url, lineNumber) {

	    try {
	        imod.error(message, url, lineNumber);
	        imod.logger.LogToService("Error", message, document.location, lineNumber);
	    } catch (e) {
	        // squelch
	    }
	    if (oldOnError) {
	        return oldOnError(message, url, lineNumber);
	    }
	    //return false;
	};

	if (!window.IModController) window.IModController = {};
	if (!imod.Fancy) imod.Fancy = {};
	if (!imod.Fancy.Handlers) imod.Fancy.Handlers = {};
	if (!imod.dom) imod.dom = {}; //DOM manipulation
	if (!imod.Security) imod.Security = {};
    
	IModController.loadedScripts = new Array;
	IModController.debug = false;
	IModController.isCmsMenuShown = false;

	IModController.PageRequestManagerEndRequestHandler = function (sender, args) {
	    if (args.get_error() != undefined) {
	        if (args.get_response().get_statusCode() == '0') {
	            args.set_errorHandled(true);
	        }
	    }
	};

	// the init call is setup server side in the BasePage.cs OnPreRender.
	// If debug == false then do not show console log messages
	IModController.init = function (siteId, groupId, groupName, groupChain, memberId, debug)
	{
	    IModController.siteId = siteId;
	    IModController.groupId = groupId;
		IModController.groupName = groupName;
		IModController.groupChain = groupChain;
		IModController.memberId = memberId;
		IModController.debug = debug;
		IModController.fancyInitialized = false;
		IModController.helpSettings = null;

		if (!IModController.debug)
		{
			//console = { log: function () { } };
		}

		Sys.WebForms.PageRequestManager.getInstance().add_endRequest(IModController.PageRequestManagerEndRequestHandler);

		//imod.log(jQuery.migrateWarnings.length);
		if (jQuery.migrateWarnings.length > 0)
		{
		    var migrateWarningsMessage = "Migrate Warnings: " + jQuery.migrateWarnings.toString();
		    imod.logger.LogToService("Warn", migrateWarningsMessage, document.location, '');
		}
	};

	IModController.scriptLoadedNotification = function (scriptName)
	{
		imod.log(scriptName);
	};
    
	imod.Browser = {}; //browser related stuff like size, cookies, querystring
	imod.Browser.Request = {};
	imod.Form = {};
	imod.Form.Controls = [];
	imod.Element = {};
	imod.General = {};
	imod.RolloutFlags = {};

	imod.WindowUtilities = imod.WindowUtilities || {};
	imod.WindowUtilities.RefreshParentPage = function() {
		if (window.opener === undefined || window.opener === null) {
			return;
		}

		window.opener.location.reload();
	};

	imod.WindowUtilities.CloseAndRefreshParentPage = function () {
		if (window.opener === undefined || window.opener === null) {
			return;
		}

		imod.WindowUtilities.RefreshParentPage();
		window.close();
	};

	imod.WindowUtilities.Close = function () {
		if (window.opener === undefined || window.opener === null) {
			return;
		}
		window.close();
	};

	IModController.diagnostic = {};

	IModController.diagnostic.overrideRolloutFlag = function (rolloutFlagName, rolloutFlagValue) {
	    imod.log(rolloutFlagName);

	    var currentUrl = new URI(window.location);
	    if (currentUrl.hasQuery(rolloutFlagName) === true) {
	        window.location = new URI(window.location).removeQuery(rolloutFlagName).toString();
	    } else {
	        window.location = new URI(window.location).addQuery(rolloutFlagName, rolloutFlagValue).toString();
	    }
	};

	IModController.debugWidgetSettings = { "Position": "TopLeft", "ActiveTabName": "Utilities", "DisplayMode": "Collapsed", "VisibleOnLoad": true, "SelectedTabs": ["Utilities"] };

	IModController.toggleDebugWidget = function () {

	    if (window.console) console.log("DebugWidget Init Called From Bookmarklet.");
	    var debugtriggerCookieName = 'IMOD_DEBUGTRIGGER';
	    var debugtriggerCookieValue = jQuery.cookie(debugtriggerCookieName);
	    if (debugtriggerCookieValue == null) {

	        imod.log('Turning DebugWidget On');
	        jQuery.cookie(debugtriggerCookieName, Sys.Serialization.JavaScriptSerializer.serialize(IModController.debugWidgetSettings));
	        window.location.reload();

	    } else {

	        imod.log('Turning DebugWidget Off');
	        document.cookie = debugtriggerCookieName + "=;path=;domain=;expires=Thu, 01-Jan-1970 00:00:01 GMT";
	        jQuery('#DEBUGWIDGET_Container').hide();

	    }
	};

	imod.cookie = function (name, value, options)
	{
		if (typeof value != 'undefined')
		{ // name and value given, set cookie
			options = options || {};
			if (value === null)
			{
				value = '';
				options.expires = -1;
			}
			var expires = '';
			if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString))
			{
				var date;
				if (typeof options.expires == 'number')
				{
					date = new Date();
					date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
				} else
				{
					date = options.expires;
				}
				expires = '; expires=' + date.toUTCString(); // use expires attribute, max-age is not supported by IE
			}
			// CAUTION: Needed to parenthesize options.path and options.domain
			// in the following expressions, otherwise they evaluate to undefined
			// in the packed version for some reason...
			var path = options.path ? '; path=' + (options.path) : '';
			var domain = options.domain ? '; domain=' + (options.domain) : '';
			var secure = options.secure ? '; secure' : '';
			document.cookie = [name, '=', value, expires, path, domain, secure].join('');
		} else
		{ // only name given, get cookie
			var cookieValue = null;
			if (document.cookie && document.cookie != '')
			{
				var cookies = document.cookie.split(';');
				for (var i = 0; i < cookies.length; i++)
				{
					var cookie = jQuery.trim(cookies[i]);
					// Does this cookie string begin with the name we want?
					if (cookie.substring(0, name.length + 1) == (name + '='))
					{
						cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
						break;
					}
				}
			}
			return cookieValue;
		}
	};

	if (!imod.JqueryAjax) imod.JqueryAjax = {};

	imod.JqueryAjax.JsonPost = function (options)
	{
		var jQueryVersion = jQuery().jquery;
		var isAsync = true;

		if (options.hasOwnProperty('isAsync') && options.isAsync !== null)
		{
			isAsync = options.isAsync;
		}

		if (jQueryVersion == "1.2.6")
		{
			if (window.console) console.log('imod.JqueryAjax.JsonPost jQueryVersion:' + jQueryVersion);

			jQuery.ajax({
				type: "POST",
				headers: { SiteInfoId: IModController.siteId, GroupId: IModController.groupId },
				async: isAsync,
				contentType: "application/json",
				url: options.url,
				data: options.data,
				dataFilter: function (response)
				{
					// This boils the response string down into a proper JavaScript Object().
					var result = eval('(' + response + ')');
					// If the response has a ".d" top-level property, return what's below that instead.
					if (result.hasOwnProperty('d'))
						return result.d;
					else
						return result;
				},
				success: options.success,
				error: options.error,
				complete: options.complete
			});
		}
		else
		{

			jQuery.ajax({
				type: "POST",
				headers: { SiteInfoId: IModController.siteId, GroupId: IModController.groupId },
				async: isAsync,
				contentType: "application/json",
				url: options.url,
				data: options.data,
				converters: {
					"text json": function (response)
					{
						var result = Sys.Serialization.JavaScriptSerializer.deserialize(response);
						return result.hasOwnProperty('d') ? result.d : result;
					}
				},
				success: options.success,
				error: options.error,
				complete: options.complete
			});
		}
	};
    imod.JqueryAjax.JsonGet = function (options)
    {
        var isAsync = true;
        var crossDomain = false;
        var dataType = 'json';

        if (options.hasOwnProperty('isAsync') && options.isAsync !== null) {
            isAsync = options.isAsync;
        }

        if (options.hasOwnProperty('dataType') && options.dataType !== null) {
            dataType = options.dataType;
        }

        if (options.hasOwnProperty('crossDomain') && options.crossDomain !== null) {
            crossDomain = options.crossDomain;
        }

		jQuery.ajax({
		    type: "GET",
		    async: isAsync,
		    crossDomain: crossDomain,
			contentType: "application/json",
			url: options.url,
			data: options.data,
			dataType: dataType,
			converters: {
				"text json": function (response)
				{
					var result = Sys.Serialization.JavaScriptSerializer.deserialize(response);
					return result.hasOwnProperty('d') ? result.d : result;
				}
			},
			success: options.success,
			error: options.error,
			complete: options.complete
		});
	};

	/**
		*	Events. Pub/Sub system for Loosely Coupled logic.
		*	Based on Peter Higgins' port from Dojo to jQuery
		*	https://github.com/phiggins42/bloody-jquery-plugins/blob/master/pubsub.js
		*
		*	Re-adapted to vanilla Javascript
		*
		*	@class Events
	*/
	imod.Events = (function ()
	{
		var cache = {},
		/**
		*	Events.publish
		*	e.g.: Events.publish("/Article/added", [article], this);
		*
		*	@class Events
		*	@method publish
		*	@param topic {String}
		*	@param args	{Array}
		*	@param scope {Object} Optional
		*/
		publish = function (topic, args, scope)
		{
			if (cache[topic])
			{
				var thisTopic = cache[topic],
				i = thisTopic.length - 1;

				for (i; i >= 0; i -= 1)
				{
					thisTopic[i].apply(scope || this, args || []);
				}
			}
		},
		/**
		*	Events.subscribe
		*	e.g.: Events.subscribe("/Article/added", Articles.validate)
		*
		*	@class Events
		*	@method subscribe
		*	@param topic {String}
		*	@param callback {Function}
		*	@return Event handler {Array}
		*/
		subscribe = function (topic, callback)
		{
			if (!cache[topic])
			{
				cache[topic] = [];
			}
			cache[topic].push(callback);
			return [topic, callback];
		},
		/**
		*	Events.unsubscribe
		*	e.g.: var handle = Events.subscribe("/Article/added", Articles.validate);
		*		Events.unsubscribe(handle);
		*
		*	@class Events
		*	@method unsubscribe
		*	@param handle {Array}
		*	@param completly {Boolean}
		*	@return {type description }
		*/
		unsubscribe = function (handle, completly)
		{
			var t = handle[0],
			i = cache[t].length - 1;

			if (cache[t])
			{
				for (i; i >= 0; i -= 1)
				{
					if (cache[t][i] === handle[1])
					{
						cache[t].splice(cache[t][i], 1);
						if (completly) { delete cache[t]; }
					}
				}
			}
		};

		return {
			publish: publish,
			subscribe: subscribe,
			unsubscribe: unsubscribe
		};
	}());
	
	if (!imod.Security) imod.Security = {};

	imod.Security.Logout = function () {

	    var ajaxPostOptions = {

	        url: "/controls/login/AuthenticationService.asmx/Logout",
	        data: Sys.Serialization.JavaScriptSerializer.serialize({ "sid": imod.Security.SiteId, "gid": imod.Security.GroupId }),
	        success: function (result) {

	            if (window.console) console.log(result.ReturnUrl);

	            if (window.parent) {
	                window.parent.location = result.ReturnUrl;
	            }
	            else {
	                window.location = result.ReturnUrl;
	            }
	        },
	        error: function (xhr, textStatus, errorThrown) {
	            if (textStatus !== null) {
	                alert("error: " + textStatus);
	            } else if (errorThrown !== null) {
	                alert("exception: " + errorThrown.message);
	            }
	            else {
	                alert("error");
	            }
	        }
	    };
	    imod.JqueryAjax.JsonPost(ajaxPostOptions);
	};

	imod.Security.Logon = function (username, password, isImodEmployee, successMethod) {
	    var serviceUrl = imod.Security.LoginDomain + "/controls/login/AuthenticationService.asmx/Logon";
	    serviceUrl += isImodEmployee ? "?lmode=esk" : "?lmode=user";

	    var postData = { "sid": imod.Security.SiteId, "gid": imod.Security.GroupId, "username": username, "password": password, "isImodEmployee": isImodEmployee };
	    var ajaxOptions = {
	        url: serviceUrl,
	        crossDomain: true,
	        dataType: "jsonp",
	        data: postData,
	        success: function (result) {
	            if (successMethod) {
	                imod.log('AuthenticationService Logon:' + result.Success);
	                successMethod(result);
	            }

	            if (!result.Success) {
	                imod.log(result.ErrorMessage);
	            }
	        },
	        error: function (xhr, textStatus, errorThrown) {
	            if (textStatus !== null && textStatus.length > 0) {
	                imod.log("error: " + textStatus);
	            } else if (errorThrown !== null) {
	                imod.log("exception: " + errorThrown.message);
	            } else {
	                imod.log("error");
	            }
	        }
	    };

	    imod.JqueryAjax.JsonGet(ajaxOptions);
	};

	imod.Security.ContinueSession = function (successMethod) {
	    var serviceUrl = imod.Security.LoginDomain + "/controls/login/AuthenticationService.asmx/ContinueSession";
	    var postData = { "sid": imod.Security.SiteId, "gid": imod.Security.GroupId };
	    var ajaxOptions = {
	        url: serviceUrl,
	        crossDomain: true,
	        dataType: "jsonp",
	        data: postData,
	        success: function (result) {
	            if (successMethod) {
	                imod.log('AuthenticationService ContinueSession:' + result.Success);
	                successMethod(result);
	            }

	            if (!result.Success) {
	                imod.log('AuthenticationService ContinueSession:' + result.ErrorMessage);
	            }
	        },
	        error: function (xhr, textStatus, errorThrown) {
	            if (textStatus !== null && textStatus.length > 0) {
	                imod.log("error: " + textStatus);
	            } else if (errorThrown !== null) {
	                imod.log("exception: " + errorThrown.message);
	            } else {
	                imod.log("error");
	            }
	        }
	    };

	    imod.JqueryAjax.JsonGet(ajaxOptions);
	}; 

	imod.Security.UpdateMemberSessionTableEntry = function (logoutUrl, authenticationTicket) {

	    if (window.console) console.log('authenticationTicket:' + authenticationTicket);
	    if (window.console) console.log('imod.Security.AuthenticationTimeoutInSeconds:' + imod.Security.AuthenticationTimeoutInSeconds);

	    var ajaxPostOptions = {
	        url: "/controls/login/AuthenticationService.asmx/UpdateMemberSessionTableEntry",
	        data: Sys.Serialization.JavaScriptSerializer.serialize({ "authenticationTicket": authenticationTicket }),
	        success: function (result) {

	            if (window.console) console.log(result);

	        },
	        error: function (xhr, textStatus, errorThrown) {
	            if (textStatus !== null) {
	                alert("error: " + textStatus);
	            } else if (errorThrown !== null) {
	                alert("exception: " + errorThrown.message);
	            } else {
	                alert("error");
	            }
	        }
	    };

	    imod.JqueryAjax.JsonPost(ajaxPostOptions);
	};

	imod.Security.GetRemainingSecondsBeforeSessionEnds = function (successMethod) {

	    var serviceUrl = imod.Security.LoginDomain + "/controls/login/AuthenticationService.asmx/GetRemainingSecondsBeforeSessionEnds";
	    var postData = { 'sid': IModController.siteId, 'gid': IModController.groupId };
	    var ajaxOptions = {
	        url: serviceUrl,
	        crossDomain: true,
	        dataType: "jsonp",
	        data: postData,
	        success: function (result) {
	            if (successMethod) {
	                successMethod(result.AuthenticationTimeoutInSeconds);
	            }
	            else {

	                if (!result.Success) {
	                    imod.log('member session has expired.');
	                }
	                else {
	                    imod.log('member session expires in ' + result.AuthenticationTimeoutInSeconds + ' seconds.');
	                }
	            }
	        },
	        error: function (xhr, textStatus, errorThrown) {
	            if (textStatus != null) {
	                imod.log("error: " + textStatus);
	            } else if (errorThrown != null) {
	                imod.log("exception: " + errorThrown.message);
	            }
	            else {
	                imod.log("error");
	            }
	        }
	    };
	    imod.JqueryAjax.JsonGet(ajaxOptions);
	};

	imod.Security.ShowXdmProgressMessage = function () {

	    var xdmMessageContainer = document.createElement('div');
	    xdmMessageContainer.setAttribute('id', 'xdmMessageContainer');
	    xdmMessageContainer.setAttribute('style', 'font-size:120%;font-weight:bold;display:block;z-index:100001;height:250px;width:400px;');
	    xdmMessageContainer.innerHTML = '<div style="padding:20px;color:black;background-color:#666666;">' + imod.Security.XdmProgressMessage + '</div>';

	    document.getElementsByTagName('body')[0].appendChild(xdmMessageContainer);

	    var rootElm = (document.documentelement && document.compatMode == 'CSS1Compat') ? document.documentelement : document.body;
	    var vpw = self.innerWidth ? self.innerWidth : rootElm.clientWidth; // viewport width 
	    var vph = self.innerHeight ? self.innerHeight : rootElm.clientHeight; // viewport height 

	    xdmMessageContainer.style.position = 'absolute';
	    xdmMessageContainer.style.left = ((vpw - 100) / 2) + 'px';
	    xdmMessageContainer.style.top = (rootElm.scrollTop + (vph - 100) / 2) + 'px';

	    imod.General.DarkScreen(.7, null, 100000);
	};

	imod.Security.HideXdmProgressMessage = function () {

	    var xdmMessageContainer = document.getElementById('xdmMessageContainer');
	    xdmMessageContainer.style.display = 'none';
	    imod.General.NormalScreen();
	};

	imod.Security.OnXdmCallComplete = function (authResult) {

	    imod.log('recieved muid from secure:' + authResult);

	    if (authResult.MemberLoggedIn || authResult.CmsLoggedIn) {

	        if (imod.Security.HasGuestAccessToPageContent) {
	            imod.Security.ShowXdmProgressMessage();
	        }

	        if (authResult.MemberLoggedIn) {

	            imod.cookie(authResult.AuthCookieName, authResult.EncryptedAuthenticationTicket, { path: '/' });
	        }

	        if (authResult.CmsLoggedIn) {

	            imod.cookie(authResult.CmsAdminCookieName, authResult.EncryptedCmsAdminGuid, { path: '/' });
	            imod.cookie(authResult.CmsAdminIdCookieName, authResult.EncryptedCmsAdminIdCookieValue, { path: '/' });
	        }

	        if (window.console) console.log('document.cookie set');
	        location.reload();
	    }
	    else {

	        if (imod.Security.HasGuestAccessToPageContent && imod.Security.SetGuestCookie) {
	            imod.cookie(imod.Security.GuestCookieName, 'true', { path: '/' });
	        }
	        else if (imod.Security.LoginPageUrl && imod.Security.LoginPageUrl != '') {
	            if (window.console) console.log('document.location = ' + imod.Security.LoginPageUrl);
	            document.location = imod.Security.LoginPageUrl;
	        }
	    }
	};

	imod.Security.OnXdmCallError = function (data) {

	    imod.Security.HideXdmProgressMessage();
	    if (window.console) console.log('imod.Security.QueryLoginDomain Error');
	};

	imod.Security.QueryLoginDomain = function () {

	    if (window.console) console.log('imod.Security.QueryLoginDomain');

	    if (!imod.Security.HasGuestAccessToPageContent) {
	        imod.Security.ShowXdmProgressMessage();
	    }

	    var remote = new easyXDM.Rpc({
	        local: "/controls/login/XdmAuthProvider.aspx",
	        swf: "/scripts/easyXDM/2.4.15.118/easyxdm.swf",
	        remote: imod.Security.XdmProvider,
	        onReady: function () {

	            remote.GetEncryptedAuthenticationTicket(imod.Security.OnXdmCallComplete, imod.Security.OnXdmCallError);

	        }
	    }, /** The interface configuration */{
	        remote: {
	            GetEncryptedAuthenticationTicket: {}
	        },
	        local: {
	            alertMessage: function (msg) {
	                alert(msg);
	            }
	        }
	    });

	};

	if (!imod.SessionData) imod.SessionData = {};
	if (!imod.SessionData.Data) imod.SessionData.Data = {};

	imod.SessionData.SiteViewModeEnum = {
		UseFullSiteTemplate: { value: "0", name: "UseFullSiteTemplate" },
		UseDeviceSpecificTemplate: { value: "1", name: "UseDeviceSpecificTemplate" }
	};


	imod.SessionData.OnXdmEnsureSessionCookieCallComplete = function (sessionData)
	{

		imod.log('recieved session data. SessionId=' + sessionData + ' called on:' + document.URL);


		imod.SessionData.Data = sessionData;

		imod.cookie(imod.SessionData.CookieName, imod.SessionData.Data.SessionId, { path: '/' });

		// If the retrieved settingsData requires reloading do so here
		if (imod.Browser.IsMobile && imod.SessionData.Data.SiteViewMode == imod.SessionData.SiteViewModeEnum.UseFullSiteTemplate.value)
		{
			imod.log('Forcing Full Site Template:' + imod.SessionData.Data.SessionId);
			location.reload();
		}
	};

	imod.SessionData.OnXdmSessionCallError = function (data)
	{

		imod.log('imod.Security.EnsureSessionCookie Error');
	};

	imod.SessionData.EnsureSessionCookie = function (loginUrl)
	{

		imod.log('imod.SessionData.EnsureSessionCookie');


		var remote = new easyXDM.Rpc({
			local: "/controls/login/XdmSessionProvider.aspx",
			swf: "/scripts/easyXDM/2.4.15.118/easyxdm.swf",
			remote: loginUrl + '/controls/login/XdmSessionProvider.aspx?sid=' + IModController.siteId + '&gid=' + IModController.groupId,
			onReady: function ()
			{

				remote.EnsureSessionCookie(imod.SessionData.OnXdmEnsureSessionCookieCallComplete, imod.SessionData.OnXdmSessionCallError);

			}
		}, /** The interface configuration */{
			remote: {
				EnsureSessionCookie: {}
			},
			local: {
				alertMessage: function (msg)
				{
					alert(msg);
				}
			}
		});


	};

	imod.SessionData.SetSiteViewMode = function (siteViewMode)
	{

		imod.log('imod.SessionData.SetSiteViewMode:' + siteViewMode);
		imod.SessionData.Data.SiteViewMode = siteViewMode;

		var postData = Sys.Serialization.JavaScriptSerializer.serialize({ 'sessionData': imod.SessionData.Data });

		var ajaxPostOptions = {
			url: "/ApiServices/Personalization.asmx/SaveSessionData",
			data: postData,
			success: function (result)
			{
				if (result.Success)
				{
					imod.log('SaveSessionData Success.');
					location.reload();

				} else
				{
					imod.log('SaveSessionData Failed.');
				}
			},
			error: function (xhr, textStatus, errorThrown)
			{
				if (textStatus != null)
				{
					imod.log("error: " + textStatus);
				} else if (errorThrown != null)
				{
					imod.log("exception: " + errorThrown.message);
				} else
				{
					imod.log("error");
				}
			}
		};
		imod.JqueryAjax.JsonPost(ajaxPostOptions);

	};

	imod.Form.SelectText = function (oPrmContainer, sPrmTextProperty)
	{
		if (oPrmContainer.setSelectionRange != null)
		{
			oPrmContainer.setSelectionRange(0, oPrmContainer[sPrmTextProperty].length);
		}
		else if (oPrmContainer.createTextRange != null)
		{
			var oRange = oPrmContainer.createTextRange();
			oRange.moveStart("character", 0);
			oRange.moveEnd("character", oPrmContainer[sPrmTextProperty].length);
			oRange.select();
		}
		else
		{
			alert("Element does not support selecting text");
		}
	};
    imod.Browser.ScreenWidth = function ()
	{
		return screen.availWidth;
	};
    imod.Browser.ScreenHeight = function ()
	{
		return screen.availHeight;
	};
    imod.Browser.ParseQuerystring = function (queryString)
	{
		var qs = {};
		var s = queryString || window.location.search.replace(/^\?/, "");
		var aryQS = s.split("&");
		for (var i = 0; i < aryQS.length; i++)
		{
			var aryPair = aryQS[i].split("=");
			qs[aryPair[0]] = aryPair[1];
		}
		return qs;
	};
    imod.Browser.Request.Querystring = imod.Browser.ParseQuerystring();
	imod.Browser.Request.QueryString = imod.Browser.Request.Querystring;

	imod.Browser.IE = (window.attachEvent != null);

	imod.Browser.GetWindowScroll = function (frm)
	{
		var oReturn = { "left": 0, "top": 0 };
		var w = (frm || frm == 0) ? window.frames[frm] : window;
		var de = w.document.documentElement;
		var db = w.document.body;

		if (de && de.scrollLeft > 0)
			oReturn.left = de.scrollLeft;
		else
			oReturn.left = db.scrollLeft;
		if (de && de.scrollTop > 0)
			oReturn.top = de.scrollTop;
		else
			oReturn.top = db.scrollTop;

		return oReturn;
	};
    imod.Browser.ScrollWindow = function ()
	{
		var left = null, top = null, frm = null;
		switch (arguments.length)
		{
			case 2:
				left = arguments[0];
				top = arguments[1];
				break;
			case 3:
				frm = arguments[0];
				left = arguments[1];
				top = arguments[2];
				break;
			default:
				var s = "No overload for ScrollWindow(";
				for (var i = 0; i < arguments.length; i++)
				{
					if (i > 0) s += ",";
					s += typeof (arguments[i]);
				}
				s += ")";
				throw new Error(s);
		}

		var w = (frm || frm == 0) ? window.frames[frm] : window;
		var de = w.document.documentElement;
		var db = w.document.body;

		if (left != null)
		{
			if (de) de.scrollLeft = left;
			db.scrollLeft = left;
		}
		if (top != null)
		{
			if (de) de.scrollTop = top;
			db.scrollTop = top;
		}
	};
    imod.Browser.GetWindowSize = function (frm)
	{
		var oReturn = { width: 0, height: 0 };

		var w = (frm) ? window.frames[frm] : window;
		var de = w.document.documentElement;
		var db = w.document.body;

		if (w.innerWidth)
			oReturn.width = w.innerWidth;
		else if (de && de.offsetWidth > 0)
			oReturn.width = de.offsetWidth;
		else
			oReturn.width = db.offsetWidth;

		if (w.innerHeight)
			oReturn.height = w.innerHeight;
		else if (de && de.offsetHeight > 0)
			oReturn.height = de.offsetHeight;
		else
			oReturn.height = db.offsetHeight;

		return oReturn;
	};
    imod.dom.DisableSelect = function (o)
	{
		o.style.MozUserSelect = "none";
		o.onselectstart = function () { return false; };
		o.unselectable = "on";
	};
    imod.dom.ConfirmPageExit = function (sPrmMessage, prmConfirmDelegate)
	{
		var f = function (e)
		{
			if (window.event) e = window.event;
			var bDoIt = true;
			if (prmConfirmDelegate != null)
				bDoIt = prmConfirmDelegate();
			if (bDoIt)
			{
				e.returnValue = sPrmMessage.replace(/<br[^>]*>/gi, "\n");
				e.cancelBubble = true;
			}
		};
        imod.dom.AddHandler(window, "beforeunload", f);
	};
    imod.dom.PreventDefault = function (e)
	{
		if (e && e.preventDefault)
			e.preventDefault();
		else
			window.event.returnValue = false;
	};
    imod.dom.GetSender = function (e)
	{
		if (e && e.target)
			return e.target;
		if (window.event && window.event.srcElement)
			return window.event.srcElement;
		return null;
	};
    imod.dom.InsertAfter = function (oPrmInsert, oPrmAfter)
	{
		if (oPrmAfter.nextSibling)
		{
			oPrmAfter.parentNode.insertBefore(oPrmInsert, oPrmAfter.nextSibling);
		}
		else
		{
			oPrmAfter.parentNode.appendChild(oPrmInsert);
		}
	};
    imod.dom.GenerateId = function (sPrmRoot)
	{
		var sRoot = sPrmRoot;
		var sId = null;
		if (!sRoot)
			sRoot = "element";
		while (sId == null || imod$(sId))
			sId = sRoot + Math.random().toString().replace(/\./gi, "");
		return sId;
	};
    imod.dom.CenterElement = function (o)
	{
		var x = imod.Browser.ClientWidth() - o.offsetWidth;
		var y = imod.Browser.ClientHeight() - o.offsetHeight;
		if (x < 0) x = 0;
		if (y < 0) y = 0;
		var ws = imod.Browser.GetWindowScroll();

		o.style.left = ((x / 2) + ws.left) + "px";
		o.style.top = ((y / 2) + ws.top) + "px";
	}; //Element, x, y
	//Element, point  (where point is any object with an exposed x and y property)
	imod.dom.PositionElement = function ()
	{
		var x = 0;
		var y = 0;
		var o = null;
		var scrollBarWidth = 25;

		switch (arguments.length)
		{
			case 2:
				o = arguments[0];
				x = arguments[1].x;
				y = arguments[1].y;
			case 3:
				o = arguments[0];
				x = arguments[1];
				y = arguments[2];
			case 4:
				o = arguments[0];
				x = arguments[1];
				y = arguments[2];
				break;
		}
		var w = o.offsetWidth;
		var h = o.offsetHeight;
		var winScroll = imod.Browser.GetWindowScroll();

		var edgeLeft = imod.Browser.ClientWidth() + winScroll.left - scrollBarWidth;
		var edgeBottom = imod.Browser.ClientHeight() + winScroll.top - scrollBarWidth;

		if (x + w > edgeLeft)
			x -= (x + w - edgeLeft);
		if (x < winScroll.left)
			x = winScroll.left;

		if (y + h > edgeBottom)
			y -= (y + h - edgeBottom);
		if (y < winScroll.top)
			y = winScroll.top;

		o.style.left = x + "px";
		o.style.top = y + "px";
	};
    imod.Fancy.GlobalFastTitle2 = function (oPrmRoot)
	{
		var oRoot = oPrmRoot;
		if (oRoot == null)
			oRoot = document.body;

		imod.dom.AddHandler(oRoot, "mouseover", imod.Fancy.FastTitleHandler2);
		imod.dom.AddHandler(oRoot, "mouseout", imod.Fancy.FastTitleCloseHandler2);
		imod.dom.AddHandler(oRoot, "mousemove", imod.Fancy.FastTitleMoveHandler2);

		imod.Fancy.BuildFastTitleDiv();
	};
    imod.Fancy.FastTitleMoveHandler2 = function (e)
	{
		if (imod.Fancy.FastTitleOn)
		{
			imod.Fancy.ShowFastTitle(imod.Fancy.FastTitleCurrent, e);
		}
	};
    imod.Fancy.ShowFastTitle = function (sender, e)
	{
		if (sender.FastTitle != null)
		{

			var divFastTitle = imod$("divFastTitle55378008");
			divFastTitle.innerHTML = sender.FastTitle;
			divFastTitle.style.display = "block";
			var iOffsetY = 0;
			var ws = imod.Browser.GetWindowScroll();
			var mouse = imod.Browser.GetMouse(e);
			if (mouse.x + 15 + divFastTitle.offsetWidth > imod.Browser.ClientWidth() + ws.left) iOffsetY = 15;
		    imod.dom.PositionElement(divFastTitle, mouse.x + 15, mouse.y + iOffsetY);
		}
	};
    imod.Fancy.FastTitleHandler2 = function (e)
	{
		var sender = ((e.target != null) ? e.target : window.event.srcElement);

		switch (sender.tagName)
		{
			case "IFRAME":
				return; //skip iframes
		}

		if (!sender.FastTitleCached)
		{
			var oCurrent = sender;
			var bNotFound = true;

			while (bNotFound)
			{
				if (oCurrent == document || oCurrent == document.body)
				{
					sender.FastTitle = null;
					sender.title = "";
					// ENC-5787 per DJ, we are already at the top of the stack and have determined we cannot do anything;
					// break out of the loop so we do not while ourselves to death...
					bNotFound = false;
				}
				else
				{
					if (oCurrent.FastTitle)
						sender.FastTitle = oCurrent.FastTitle;
					else if (oCurrent.title != null && oCurrent.title.length > 0)
						sender.FastTitle = oCurrent.title;
					else if (oCurrent.alt != null && oCurrent.alt.length > 0)
						sender.FastTitle = oCurrent.alt;
					else
					{
						oCurrent = oCurrent.parentNode;
					}
				}
				if (sender.FastTitle != null || oCurrent == null || oCurrent == document.body)
				{
					bNotFound = false;
					if (oCurrent != null && oCurrent != document.body)
						oCurrent.title = "";
				}
			}
			if (sender.FastTitle != null)
				sender.title = "";
			sender.FastTitleCached = true;
		}
		if (imod.Fancy.FastTitle != null)
		{
			imod.Fancy.FastTitleOn = true;
			imod.Fancy.FastTitleCurrent = sender;
			imod.Fancy.ShowFastTitle(sender, e);
		}
	};
    imod.Fancy.FastTitleCloseHandler2 = function (e)
	{
		if (imod.Fancy.FastTitleOn)
		{
			var sender = ((e.target != null) ? this : window.event.srcElement);
			var divFastTitle = imod$("divFastTitle55378008");
			divFastTitle.style.display = "none";
			imod.Fancy.FastTitleOn = false;
			imod.Fancy.FastTitleCurrent = null;
		}
	};
    imod.Fancy.BuildFastTitleDiv = function ()
	{
		var divFastTitle = document.createElement("div");
		divFastTitle.id = "divFastTitle55378008";
		divFastTitle.className = "imod-FastTitle";
		divFastTitle.style.display = "none";
		document.body.appendChild(divFastTitle);
		return divFastTitle;
	};
    imod.Fancy.FastTitle = function (o, s)
	{
		if (!o.FastTitle)
		{
			imod.dom.AddHandler(o, "mousemove", imod.Fancy.FastTitleHandler2);
			imod.dom.AddHandler(o, "mouseout", imod.Fancy.FastTitleCloseHandler2);
		}
		if (!s)
		{
			if (o.title && o.title.length > 0)
				o.FastTitle = o.title;
			else
				o.FastTitle = o.alt;
			o.title = "";
		}
		else
		{
			o.FastTitle = s;
		}
		o.FastTitleEnabled = true;
	}; //All of these should be moved to CSS where possible if we can make the admin template use standards mode
	imod.Fancy.ActivateFancyInputFocus = function () { };
    imod.Fancy.HighlightInput = function (e) { };
    imod.Fancy.UnHighlightInput = function (e) { };
    imod.Fancy.ActivateFancyLabels = function () { };
    imod.Fancy.HighlightInputLabel = function (e) { };
    imod.Fancy.UnHighlightInputLabel = function (e) { };
    imod.Fancy.ActivateFancyCheckBoxes = function () { };
    imod.Fancy.ActivateFancyRadioButtons = function () { };
    imod.Fancy.Handlers.FancyRadioCheckBoxClickHandler = function (e) { };
    imod.Fancy.SelectFancyCheckBox = function (sender) { };

    function imod_GetLabelForInput(o)
	{
		var labels = document.body.getElementsByTagName("label");
		for (var i = 0; i < labels.length; i++)
		{
			if (labels[i].htmlFor == o.id)
				return labels[i];
		}
		return null;

	}

	function imod_ParseInt(sPrmInt)
	{
		if (!isNaN(sPrmInt))
			return parseInt(sPrmInt);
		if (typeof (sPrmInt) == "string" && sPrmInt.length > 0)
		{
			var s = sPrmInt.split("");
			var sValid = "0123456789";
			var sSkip = ",-";
			var sInt = "";
			var bGetting = false;
			for (var i = 0; i < s.length; i++)
			{
				if (sValid.indexOf(s[i]) > -1)
				{
					sInt += s[i];
					bGetting = true;
				}
				else if (sSkip.indexOf(s[i]) > -1)
				{
					//do nothing
				}
				else
				{
					if (bGetting)
						break;
				}
			}
			if (s[0] == "-")
				sInt = "-" + sInt;
			if (!isNaN(sInt))
				return parseInt(sInt);
		}
		return 0;
	}

	// right now we attach this to both oninput and onkeyup,
	// but oninput is preferred since it handles mouse clicks and ctrl-v;
	// once IE10 is minimum requirement for admins, onkeyup can go away
	// (Not for donation drivers, they have their own handler)
function imod_CurrencyTextboxOnInput(target, event) {
	var value = jQuery(target).val();
	var oldvalue = value;
	value = value.replace(/[^0-9\.]+/g, ''); // 0-9 plus .
	var charIndex = String(value).indexOf(".");
	var valueLength = String(value).length;
	if ((charIndex >= 0) && (charIndex < valueLength - 3)) {
		value = value.substr(0, charIndex + 3);
	}
	if (oldvalue != value) {
		jQuery(target).val(value);
	}
}

	function imod_Pixel(i)
	{
		if (isNaN(i) && i.indexOf != null && i.indexOf("px") > -1)
			return i;
		var s = i + "px";
		if (s == "px")
			s = "";

		return s;
	}

	function imod_ASCX(sPrmUniqueId)
	{
		var UniqueId;
		if (sPrmUniqueId) { SetUniqueId(sPrmUniqueId); }
		this.Verbiage = new imod_Verbiage();

		this.$ = GetElement;
		this.O = GetObject;

		this.SetUniqueId = SetUniqueId;

		function SetUniqueId(sPrmUniqueId)
		{
			UniqueId = sPrmUniqueId.replace(/[$:]/gi, "_");
		}

		function GetElement(sPrmId)
		{
			return imod$(UniqueId + "_" + sPrmId);
		}

		function GetObject(sPrmName)
		{
			return window[UniqueId + "_" + sPrmName];
		}
	}

	function imod_Verbiage()
	{
		var Items = {};

		this.Add = Add;
		this.Set = Add;
		this.Get = Get;

		function Add(sPrmKey, sPrmValue)
		{
			Items[sPrmKey] = sPrmValue;
		}

		function Get(sPrmKey)
		{
			if (Items[sPrmKey] == null)
				return sPrmKey;
			return Items[sPrmKey];

		}
	}

	imod.dom.CreateElement = function (sPrmElement, sPrmFrame)
	{
		var dummy = null;
		if (sPrmFrame)
		{
			if (sPrmElement.indexOf("<") > -1)
			{
				dummy = window.frames[sPrmFrame].document.createElement("div");
				dummy.innerHTML = sPrmElement;
				return dummy.firstChild;
			}
			return window.frames[sPrmFrame].document.createElement(sPrmElement);
		}
		else
		{
			if (sPrmElement.indexOf("<") > -1)
			{
				dummy = document.createElement("div");
				dummy.innerHTML = sPrmElement;
				return dummy.firstChild;
			}
			return document.createElement(sPrmElement);
		}
	};
    

	function imod_CreateElement(sPrmElement, sPrmFrame) {
	    var dummy = null;
	    if (sPrmFrame) {
	        if (sPrmElement.indexOf("<") > -1) {
	            dummy = window.frames[sPrmFrame].document.createElement("div");
	            dummy.innerHTML = sPrmElement;
	            return dummy.firstChild;
	        }
	        return window.frames[sPrmFrame].document.createElement(sPrmElement);
	    }
	    else {
	        if (sPrmElement.indexOf("<") > -1) {
	            dummy = document.createElement("div");
	            dummy.innerHTML = sPrmElement;
	            return dummy.firstChild;
	        }
	        return document.createElement(sPrmElement);
	    }
	}


	function imod_GetRadioButtonValue(sPrmName) {
	    var rbs = document.forms["MainForm"].elements[sPrmName];
	    for (var i = 0; i < rbs.length; i++) {
	        if (rbs[i].checked)
	            return rbs[i].value;
	    }
	    return null;
	}

	function imod_SetTableRowBackgroundColors(oPrmTable, sPrmColor, sPrmColorAlt, bPrmSkipHeader) {
	    if (sPrmColor == null)
	        sPrmColor = "#f7f6eb";
	    if (sPrmColorAlt == null)
	        sPrmColorAlt = "#e5e7d8";
	    if (oPrmTable == null) {
	        alert("imod_SetTableRowBackgroundColors::oPrmTable is null");
	        return;
	    }
	    if (oPrmTable.rows == null) {
	        alert("imod_SetTableRowBackgroundColors::oPrmTable is not a table");
	        return;
	    }
	    var iStart = 0;
	    if (bPrmSkipHeader)
	        iStart = 1;
	    for (var i = iStart; i < oPrmTable.rows.length; i++) {
	        if (i % 2 == 0)
	            oPrmTable.rows[i].style.backgroundColor = sPrmColor;
	        else
	            oPrmTable.rows[i].style.backgroundColor = sPrmColorAlt;
	    }
	}

    function imod$()
	{
		if (arguments.length == 0)
			return null;
		if (arguments.length == 1)
		{
			return imod$_getElement(arguments[0]);
		}
		var aryReturn = new Array(arguments.length);
		for (var i = 0; i < arguments.length; i++)
			aryReturn[i] = imod$_getElement(arguments[i]);
		return aryReturn;
	}
	imod.$ = imod$;

	function imod$_getElement(s)
	{
		if (s && s.indexOf && s.indexOf("~") > -1)
		{
			var pair = s.split("~");
			var tag = "*";
			var suffix = pair[1];
			if (pair[0] && pair[0] != "") tag = pair[0];

			var els = document.getElementsByTagName(tag);

			for (var k in els)
			{
				if (els[k].length)
				{
					for (var i = 0; i < els[k].length; i++)
					{
						if (els[k][i].id && els[k][i].id.indexOf(suffix, els[k][i].id.length - suffix.length) != -1)
						{
							return els[k][i];
						}
					}
				}
				else
				{
					if (els[k].id && els[k].id.indexOf(suffix, els[k].id.length - suffix.length) != -1)
					{
						return els[k];
					}
				}
			}
		}
		if (s && s.indexOf && s.indexOf(".") > -1)
		{
			var pair = s.split(".");
			if (pair[0] == null || pair[0] == "") pair[0] = "*";
			var els = document.getElementsByTagName(pair[0]);
			for (var k in els)
			{
				if (els[k].className == pair[1])
				{
					return els[k];
				}
			}
			//return null;
		}
		return document.getElementById(s);
	}

	function imod_ASCX$(sPrmId)
	{
		return imod$(this.UniqueId + "_" + sPrmId);
	}

	//Read .Net compatible cookie
	function imod_GetCookie(sPrmName, sPrmKey)
	{
		var aryCookies = document.cookie.replace(/;\s/gi, ";").split(";");
		for (var i = 0; i < aryCookies.length; i++)
		{
			var sCookie = aryCookies[i];
			if (sCookie.indexOf(sPrmName + "=") == 0)
			{
				if (sPrmKey != null)
				{
					var sNewPairs = "";
					var sValues = sCookie.substring(sPrmName.length + 1, sCookie.length);
					var aryValues = sValues.split("&");
					for (var j = 0; j < aryValues.length; j++)
					{
						var sPair = aryValues[j];
						if (sPair.indexOf(sPrmKey + "=") == 0)
						{
							return window.unescape(sPair.substring(sPrmKey.length + 1, sPair.length));
						}
					}
				}
				else
				{
					return window.unescape(sCookie.substring(sPrmName.length + 1, sCookie.length));
				}
			}
		}
		return null;
	}


	//Write .Net compatible cookie
	//Expiration NYI, Domain NYI
	function imod_SetCookie(sPrmName, sPrmKey, sPrmValue, iPrmDaysToLive, sPrmDomain, cookiePath)
	{
		//var DateExpires = new Date("12/11/2009");
		var sDomain = "domain=" + window.location.host + ";";
		//var sExpires = "expires=" + DateExpires.toGMTString() + ";"; //" expires=;";
		var sPath = ""; //var sCookieFooter = sExpires + sPath + sDomain;
		var sCookieFooter = sDomain;

		if (arguments.length == 6)
		{
			sPath = "path=" + cookiePath + ";";
		}

		var aryCookies = document.cookie.replace(/;\s/gi, ";").split(";");
		for (var i = 0; i < aryCookies.length; i++)
		{
			var sCookie = aryCookies[i];
			if (sCookie.indexOf(sPrmName + "=") == 0)
			{
				var sNewPairs = "";
				var sValues = window.unescape(sCookie.substring(sPrmName.length + 1, sCookie.length));
				var aryValues = sValues.split("&");
				var bExists = false;
				for (var j = 0; j < aryValues.length; j++)
				{
					var sPair = aryValues[j];
					if (sPair.indexOf(sPrmKey + "=") == 0)
					{
						sNewPairs += "&" + sPrmKey + "=" + window.escape(sPrmValue);
						bExists = true;
					}
					else
					{
						sNewPairs += "&" + sPair;
					}
				}
				if (!bExists)
				{
					sNewPairs += "&" + sPrmKey + "=" + window.escape(sPrmValue);
				}
				if (sNewPairs.length > 0 && sNewPairs[0] == "&")
					sNewPairs = sNewPairs.substring(1);
				document.cookie = sPrmName + "=" + sNewPairs + ";" + sCookieFooter + sPath; // + " expires=" + DateExpires.toGMTString() + "; path=/";
				return;
			}
		}
		document.cookie = sPrmName + "=" + sPrmKey + "=" + window.escape(sPrmValue) + ";" + sCookieFooter + sPath; // + ";" + " expires=" + DateExpires.toGMTString() + "; path=/";
	}

	imod.dom.GetElementsByTagNames = function (oPrmTarget)
	{
		var aryReturn = new Array();
		for (var i = 1; i < arguments.length; i++)
		{
			var aryElements = oPrmTarget.getElementsByTagName(arguments[i]);
			for (var j = 0; j < aryElements.length; j++)
				aryReturn.push(aryElements[j]);
		}
		return aryReturn;
	};

    function imod_SetOpacity(o, iPrmOpacity)
	{
		if (iPrmOpacity != null)
		{
			o.style.opacity = iPrmOpacity;
			o.style.MozOpacity = iPrmOpacity;
			o.style.filter = "alpha(opacity=" + iPrmOpacity * 100 + ")";
		}
		else
		{
			o.style.opacity = "";
			o.style.MozOpacity = "";
			o.style.filter = "";
		}
	}

	function imod_StopPropagation(e, sPrmFrameName)
	{
		//Stops events from bubbling up.
		//e: the event object.  Currently needed for Mozilla
		//sPrmFrameName:  If you are stopping propagation of an event in a frame by a method declared outside the frame
		//	this should be set so in IE it knows which event object to use.
		if (e == null)
		{
			if (sPrmFrameName != null)
				e = window.frames[sPrmFrameName].event;
			else
				e = window.event;
		}
		if (e.stopPropagation)
			e.stopPropagation();
		else
			e.cancelBubble = true;
	}

	//iPrmCenterMode: 0 - none, 1 - browser, 2 = screen, null - none, 3 = full screen
	function imod_OpenWindow(sPrmUrl, iPrmWidth, iPrmHeight, sPrmWindowProperties, iPrmCenterMode, iPrmLeft, iPrmTop)
	{
		var sWindowProperties = "";
		if (iPrmCenterMode == 3)
			sWindowProperties = "width=" + imod.Browser.ScreenWidth() + ",height=" + imod.Browser.ScreenHeight();
		else
			sWindowProperties = "width=" + iPrmWidth + ",height=" + iPrmHeight;
		if (sPrmWindowProperties != null && sPrmWindowProperties.length > 0)
			sWindowProperties += "," + sPrmWindowProperties;

		if (iPrmCenterMode != null)
		{
			if (iPrmCenterMode == true)
				iPrmCenterMode = 1;
			else if (iPrmCenterMode == false)
				iPrmCenterMode = 2;
		}
		if (iPrmCenterMode != null && iPrmCenterMode != 0)
		{
			var x = 0;
			var y = 0;
			switch (iPrmCenterMode)
			{
				case 1: //browser
					x = (document.body.clientWidth - iPrmWidth) / 2;
					y = (imod.Browser.ClientHeight() - iPrmHeight) / 2;
					if (window.screenX != null)
					{
						x += window.screenX;
						y += window.screenY;
					}
					else if (window.screenLeft != null)
					{
						x += window.screenLeft;
						y += window.screenTop;
					}
					break;
				case 2: //screen
					x = (screen.availWidth - iPrmWidth) / 2;
					y = (screen.availHeight - iPrmHeight) / 2;
					break;
			}
			if (x < 0)
				x = 0;
			if (y < 0)
				y = 0;
			sWindowProperties += ",left=" + x + ",top=" + y;
		}
		else
		{
			if (iPrmLeft != null)
				sWindowProperties += ",left=" + iPrmLeft;
			if (iPrmTop != null)
				sWindowProperties += ",top=" + iPrmTop;
		}
		sWindowProperties = sWindowProperties.replace(/scrolling=/gi, "scrollbars=");
		if (sWindowProperties.indexOf("scrollbars=") == -1)
		{
			if (sWindowProperties.length > 0) sWindowProperties += ",";
			sWindowProperties += "scrollbars=1";
		}
		if (sWindowProperties.indexOf("resizable=") == -1)
		{
			if (sWindowProperties.length > 0) sWindowProperties += ",";
			sWindowProperties += "resizable=1";
		}
		return window.open(sPrmUrl, "", sWindowProperties);
	}

	imod.Browser.ClientHeight = function ()
	{
		if (window.innerHeight)
			return window.innerHeight;
		if (document.documentElement && document.documentElement.clientHeight) //  && document.documentElement.clientHeight != document.documentElement.scrollHeight)
			return document.documentElement.clientHeight;
		return document.body.clientHeight;
	};
    window.imod_ClientHeight = imod.Browser.ClientHeight;

	imod.Browser.ClientWidth = function ()
	{
		if (window.innerWidth)
			return window.innerWidth;
		if (document.documentElement && document.documentElement.clientWidth) //  && document.documentElement.clientWidth != document.documentElement.scrollWidth)
			return document.documentElement.clientWidth;
		return document.body.clientWidth;
	};
    window.imod_ClientWidth = imod.Browser.ClientWidth;

	function imod_Bool(sPrmBool)
	{
		//Convert sPrmBool to boolean true or false.
		switch (sPrmBool)
		{
			case "true":
			case "True":
			case "T":
			case "t":
			case "1":
			case "-1":
			case true:
			case 1:
			case -1:
				return true;
		}
		return false;
	}

	imod.General.IsValidEmail = function (sEmailAddress)
	{
		var emailPattern = /^[A-Za-z0-9!#$%&*+/=?^_'{|}~-]+(?:\.[A-Za-z0-9!#$%&*+/=?^_'{|}~-]+)*@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,10}|[0-9]{1,3})(\]?)$/;
		return emailPattern.test(sEmailAddress.trim());
	}; //Methods for the pixel location of elements on a page.  These versions attempt to factor in scroll offsets.
	function imod_DocumentScrollTop(iPrmScroll)
	{
		if (iPrmScroll)
		{
			imod.Browser.ScrollWindow(null, iPrmScroll);
		}
		return imod.Browser.GetWindowScroll().top;
	}

	function imod_DocumentScrollLeft(iPrmScroll)
	{
		if (iPrmScroll)
		{
			imod.Browser.ScrollWindow(iPrmScroll, null);
		}
		return imod.Browser.GetWindowScroll().left;
	}

	imod.dom.GetPosition = function (el, CheckScrollOffsets)
	{
		var o = el;
		var x = 0;
		var y = 0;
		var w = o.offsetWidth;
		var h = o.offsetHeight;
		while (o != null)
		{
			x += o.offsetLeft;
			y += o.offsetTop;
			o = o.offsetParent;
		}
		if (CheckScrollOffsets)
		{
			var o = el;
			var OffsetX = 0;
			var OffsetY = 0;
			if (o != null)
			{
				while (o.parentNode)
				{
					if (o.parentNode.scrollTop)
					{
						if (o.parentNode != document.body) //don't factor window scroll bars
						{
							OffsetY += o.parentNode.scrollTop;
						}
					}
					if (o.parentNode.scrollLeft)
					{
						if (o.parentNode != document.body) //don't factor window scroll bars
						{
							OffsetX += o.parentNode.scrollLeft;
						}
					}
					o = o.parentNode;
				}
			}
			if (document.documentElement != null)
			{
				if (document.documentElement.scrollLeft)
					OffsetX -= document.documentElement.scrollLeft;
				if (document.documentElement.scrollTop)
					OffsetY -= document.documentElement.scrollTop;
			}


			x -= OffsetX;
			y -= OffsetY;
		}
		return { "x": x, "y": y, "w": w, "h": h, "x2": x + w, "y2": y + h };
	};

    function imod_OffsetLeft(o)
	{
		//Get the exact left pixel position of element o.
		return imod.dom.GetPosition(o, true).x;
	}

	function imod_OffsetTop(o)
	{
		//Get the exact top pixel position of element o.
		return imod.dom.GetPosition(o, true).y;
	}

	imod.Browser.MouseX = function (e) { return imod.Browser.GetMouse(e).x; };
    imod.Browser.MouseY = function (e) { return imod.Browser.GetMouse(e).y; }; //Return an object with the x and y coords of the mouse (clientX and clientY are added as a bonus if you need them)
	imod.Browser.GetMouse = function (evt, frm)
	{
		var m = {};
		var w = (frm) ? window.frames[frm] : window;
		var e = (w.event) ? w.event : evt;
		m.clientX = e.clientX;
		m.clientY = e.clientY;
		if (e.pageX)
		{
			m.x = e.pageX;
			m.y = e.pageY;
		}
		else
		{
			var ws = imod.Browser.GetWindowScroll(frm);
			m.x = e.clientX + ws.left;
			m.y = e.clientY + ws.top;
		}
		return m;
	}; //Methods to add/remove event handlers
	if (window.EventHandlers == null)
		var EventHandlers = new Array();

	var LogHandlers = true;

	function imod_HandlerCleanUp()
	{
		for (var i = 0; i < EventHandlers.length; i++)
		{
			if (EventHandlers[i].Event != "unload")
			{
				imod_RemoveHandler(EventHandlers[i].Object, EventHandlers[i].Event, EventHandlers[i].Handler);
				EventHandlers[i].Object = null;
				EventHandlers[i].Handler = null;
				EventHandlers[i] = null;
			}
		}
		EventHandlers = null;
		imod_RemoveHandler(window, "unload", imod_HandlerCleanUp);
	}

	function imod_RemoveHandlersOnUnload()
	{
		imod_AddHandler(window, "unload", imod_HandlerCleanUp);
	}

	imod.dom.AddHandler2 = function (o, sPrmEvent, prmMethod, bPrmOnCapture)
	{
		var f = function (e)
		{
			if (window.event != null) e = window.event;
			var target = e.target;
			if (target == null && e.srcElement != null)
				target = e.srcElement;
			prmMethod(o, e, target);
		};
	    imod.dom.AddHandler(o, sPrmEvent, f, bPrmOnCapture);
	};

    function imod_AddHandler(o, sPrmEvent, f, bPrmOnCapture)
	{
		bReturn = false;
		if (o)
		{
			if (o.addEventListener != null)
			{
				var bOnCapture = false;
				if (bPrmOnCapture) bOnCapture = true;
				o.addEventListener(sPrmEvent, f, bOnCapture);
				bReturn = true;
			}
			else if (o.attachEvent)
			{
				o.attachEvent("on" + sPrmEvent, f);
				bReturn = true;
			}
			else
			{
				/*
				o["on" + sPrmEvent] = function(e) {
					if (o["on" + sPrmEvent] != null)
						o["on" + sPrmEvent](e);
					functionDelegate(e);
				}
				*/
			}
		}
		if (LogHandlers)
			EventHandlers[EventHandlers.length++] = { "Object": o, "Event": sPrmEvent, "Handler": f };
		return bReturn;
	}

	function imod_RemoveHandler(o, sPrmEvent, f)
	{
		var bReturn = false;
		if (o == null)
		{
			return bReturn;
		}
		try
		{
			if (o.removeEventListener != null)
			{
				o.removeEventListener(sPrmEvent, f, false);
				bReturn = true;
			}
			else if (o.detachEvent)
			{
				o.detachEvent("on" + sPrmEvent, f);
				bReturn = true;
			}
			else
			{
				//o["on" + sPrmEvent] = null;
			}
		}
		catch (ex)
		{
			//Stop permission errors from breaking IE in cross-frame assignments
		}
		return bReturn;
	}

	//FIXES RadEditor's HTML issues
	function imod_RadEditorIPadFix(clientId)
	{
		setTimeout(
			function ()
			{
				document.getElementById(clientId).style.height = "";
			}, 1000);
	}
	function imod_FixRadEditorHtml(sPrmClientID)
	{
		var bHasFail = true;
		if (window.GetRadEditor != null)
		{
			var RadEditor1 = GetRadEditor(sPrmClientID);
			if (RadEditor1 != null)
			{
				bHasFail = false;
				RadEditor1.FiltersManager.Add(new imod_RadEditorFix_CustomFilter());
			}
		}
		if (bHasFail)
			setTimeout(function () { imod_FixRadEditorHtml(sPrmClientID); }, 100);
	}

	function imod_RadEditorFix_CustomFilter()
	{
		this.GetHtmlContent = imod_RadEditorFix;
	}

	function imod_RadEditorFix(sPrmHtml)
	{
		var sReturn = sPrmHtml;

		sReturn = sReturn.replace(/&amp;/gi, "&");
		sReturn = sReturn.replace(/&gt;/gi, ">");
		sReturn = sReturn.replace(/&lt;$/i, "<");
		sReturn = sReturn.replace(/&lt;([\s"'])/gi, "<$1");
		sReturn = sReturn.replace(/&lt;([<])/gi, "<<");
		sReturn = sReturn.replace(/%5B/gi, "[");
		sReturn = sReturn.replace(/%5D/gi, "]");

		//Fix token spacing
		var reTokens = new Array(/\[[^\]]*\]/gi, /##[^#]*##/gi);
		for (var i = 0; i < reTokens.length; i++)
		{
			var mcToken = sReturn.match(reTokens[i]);
			if (mcToken != null)
			{
				for (var m = 0; m < mcToken.length; m++)
				{
					var mToken = mcToken[m];
					var sFixed = "";
					if (mToken != null)
					{
						sFixed = mToken.replace(/[\s]+/g, " ");
						sReturn = sReturn.replace(mToken, sFixed);
					}
				}
			}
		}
		return sReturn;
	}

	//KD 2006-0808 added common function to show/hide an html element based on the checked status of a checkbox passed in
	function imod_ShowHide(oPrmCheckBox, sPrmElementId)
	{
		var oElement = document.getElementById(sPrmElementId);
		if (oPrmCheckBox && oElement)
		{
			if (oPrmCheckBox.checked)
				oElement.style.display = '';
			else
				oElement.style.display = 'none';
		}
	} //imod_ShowHide

	//KD 2006-0822 added common function to show/hide an html element based on a bool passed in
	function imod_ForceShowHide(bShow, sPrmId)
	{
		var element = document.getElementById(sPrmId);
		if (element && element.style)
		{
			if (bShow)
				element.style.display = '';
			else
				element.style.display = 'none';
		}
	}

	function imod_ToggleDisplay(sPrmId)
	{
		var element = document.getElementById(sPrmId);
		if (element && element.style)
		{
			if (element.style.display == 'none')
				element.style.display = '';
			else
				element.style.display = 'none';
		}
	}


	// KD 2006-0915 - the following 2 functions allow you to add a javascript file or css file to the head tag of the page
	var arLoadedFiles = [];

	function imod_LoadScriptFile(prmFullPath)
	{
		if (!arLoadedFiles[prmFullPath])
		{
			var el = document.createElement("script");
			el.src = prmFullPath;
			el.type = "text/javascript";
			if (document.getElementsByTagName("head") && document.getElementsByTagName("head")[0])
			{
				document.getElementsByTagName("head")[0].appendChild(el);
				arLoadedFiles[prmFullPath] = true;
			}
			el = null;
		}
	}

	function imod_LoadStyleFile(prmFullPath)
	{
		if (!arLoadedFiles[prmFullPath])
		{
			var el = document.createElement("link");
			el.href = prmFullPath;
			el.rel = "stylesheet";
			el.type = "text/css";
			if (document.getElementsByTagName("head") && document.getElementsByTagName("head")[0])
			{
				document.getElementsByTagName("head")[0].appendChild(el);
				arLoadedFiles[prmFullPath] = true;
			}
			el = null;
		}
	}

	imod.General.StringBuilder = function ()
	{
		var Items = new Array();

		this.Append = Append;
		this.ToString = ToString;

		function Append()
		{ //can pass as many strings as you like now
			for (var i = 0; i < arguments.length; i++)
				Items.push(arguments[i]);
		}

		function ToString()
		{
			return Items.join("");
		}
	};
    imod.General.divDarkScreen = null;

	imod.General.DarkScreen = function (iPrmOpacity, sPrmColor, iPrmZIndex)
	{
		if (!imod.General.divDarkScreen)
		{
			imod.General.divDarkScreen = document.createElement("div");
			imod.General.divDarkScreen.style.display = "none";
			imod.General.divDarkScreen.style.background = "#000";
			imod.General.divDarkScreen.style.opacity = .5;
			imod.General.divDarkScreen.style.filter = "alpha(opacity=50)";

			//pdavis 3/4/2011: Added ID to DarkScreen so it can be accessed and resized: ENC-2062
			imod.General.divDarkScreen.setAttribute("id", "divDarkScreen");

			imod.General.divDarkScreen.style.zIndex = 1000;
			imod.General.divDarkScreen.style.position = "absolute";
			imod.General.divDarkScreen.style.left = "0px";
			imod.General.divDarkScreen.style.top = "0px";
			document.body.appendChild(imod.General.divDarkScreen);
		}
		if (iPrmOpacity)
			imod.dom.SetOpacity(imod.General.divDarkScreen, iPrmOpacity);
		if (sPrmColor)
			imod.General.divDarkScreen.style.background = sPrmColor;
		if (iPrmZIndex)
			imod.General.divDarkScreen.style.zIndex = iPrmZIndex;

		imod.General.divDarkScreen.style.width = document.body.scrollWidth + "px";

		//I don't know what this height thing did but removing the check fixed some stuff so if you find something with a weird shaped background div then we will have to come back to this
		//if (document.body.scrollHeight > 1) {
		//	imod.General.divDarkScreen.style.height = document.body.scrollHeight + "px";
		//}
		//else {
		if (imod.Browser.ClientHeight() > document.body.scrollHeight)
			imod.General.divDarkScreen.style.height = imod.Browser.ClientHeight() + "px";
		else
			imod.General.divDarkScreen.style.height = document.body.scrollHeight + "px";
		//}


		imod.General.divDarkScreen.style.display = "block";
	};
    imod.General.DarkScreenOpacity = 0;
	imod.General.DarkScreenThreadPointer = 0;

	imod.General.DarkScreenThread = function ()
	{
		imod.General.DarkScreenOpacity += .01;
		imod.dom.SetOpacity(imod.General.divDarkScreen, imod.General.DarkScreenOpacity);
		if (imod.General.DarkScreenOpacity >= .5)
			clearInterval(imod.General.DarkScreenThreadPointer);

	};
    imod.General.NormalScreen = function ()
	{
		if (imod.General.divDarkScreen)
			imod.General.divDarkScreen.style.display = "none";
	};
    imod.dom.Hide = function (el)
	{
		var o;
		if (el)
		{
			o = (el.style != null) ? el : imod$(el);
			if (o)
				o.style.display = "none";
		}

	};
    imod.dom.Show = function (el, s)
	{
		var o;
		if (el)
		{
			o = (el.style != null) ? el : imod$(el);
			if (o)
				o.style.display = (s != null) ? s : "";
		}
	};
    imod.dom.GetComputedStyle = function (el, p)
	{
		if (window.getComputedStyle)
			return window.getComputedStyle(el, null).getPropertyValue(p);
		if (el.currentStyle)
		{
			return el.currentStyle[p];
		}
		return;

	};
    imod.dom.AddEnterKeyHandler = function (sPrmId, ENTER_Action)
	{
		var fEnter = function (e)
		{
			if (window.event != null) e = window.event;
			if (e.keyCode == 13)
			{
				ENTER_Action(e);
				imod.dom.PreventDefault(e);
			}
		};
        imod.dom.AddHandler(imod$(sPrmId), "keypress", fEnter);
	}; //Adds trim function to the string object
	String.prototype.trim = function () { return this.replace(/^\s+|\s+$/, ''); };

	String.concat = function ()
	{
		var s = new Array(arguments.length);
		for (var i = 0; i < arguments.length; i++)
			s[i] = arguments[i];
		return s.join("");
	};
    imod.dom.AddHandler = imod_AddHandler;
	imod.dom.RemoveHandler = imod_RemoveHandler;
	imod.dom.StopPropagation = imod_StopPropagation;
	imod.dom.OffsetTop = imod_OffsetTop;
	imod.dom.OffsetLeft = imod_OffsetLeft;
	imod.dom.MakePixel = imod_Pixel;
	imod.dom.SetOpacity = imod_SetOpacity;
	imod.dom.CreateElement = imod_CreateElement;
	imod.dom.LoadScriptFile = imod_LoadScriptFile;
	imod.dom.LoadStyleFile = imod_LoadStyleFile;
	imod.Browser.OpenWindow = imod_OpenWindow;

	imod.Browser.OpenFullWindow = function (sPrmUrl)
	{
		imod.Browser.OpenWindow(sPrmUrl, 0, 0, "location=yes,menubar=yes,toolbar=yes,directories=yes,status=yes,scrollbars=yes,resizable=yes", 3);
	};
    imod.Browser.DocumentScrollLeft = imod_DocumentScrollLeft;
	imod.Browser.DocumentScrollTop = imod_DocumentScrollTop;
	imod.Browser.GetCookie = imod_GetCookie;
	imod.Browser.SetCookie = imod_SetCookie;

	imod.General.ParseInt = imod_ParseInt;

	imod.dom.AddHandler(window, "load", function() {
	     window.loaded = true;
	});
    
	imod_RemoveHandlersOnUnload();

	imod.HelpProvider = function ()
	{

		var helpItemContainerElementId = 'HELPPROVIDER_Container';
		var helpItemContainer;

		// This is the JSON representation of IMod.Framework3.Utilities.DebugSystem.WebDebugHelper
		var providerData;
		var initialized = false;

		var settings = {
			helpIconUrl: "/images/icons/v2/context_help.gif"
		};

		var getHelpItem = function (controlClientId)
		{

			for (var i = 0; i < providerData.HelpItems.length; i++)
			{

				var itemElementId = providerData.HelpItems[i].ControlClientId;
				if (itemElementId == controlClientId)
				{

					return providerData.HelpItems[i];
				}
			}

			return null;
		};

		var controlLabel = function (elementId)
		{
			return jQuery('label[for="' + elementId + '"]');
		};

		var showHelpItem = function (elementId, helpItemIconId)
		{

			logInfo('imod.HelpProvider showHelpItem ' + elementId);
			var providerDataHelpItem = getHelpItem(elementId);

			var ajaxPostOptions = {
				url: "/apiservices/Help.asmx/GetHelpContent",
				data: Sys.Serialization.JavaScriptSerializer.serialize({ "verbiageKey": providerDataHelpItem.VerbiageText }),
				success: function (result)
				{

					if (window.console) console.log(result.Data);

					helpItemContainer.html(result.Data);

					jQuery(helpItemContainer).find('a').each(function ()
					{
						jQuery(this).attr('target', '_blank');
					});

					helpItemContainer.show();
					showRadTooltip(helpItemIconId);

				},
				error: function (xhr, textStatus, errorThrown)
				{

				}
			};

			imod.JqueryAjax.JsonPost(ajaxPostOptions);

		};

		var hideHelpItem = function ()
		{

			helpItemContainer.hide();
		};

		var hideRadTooltip = function ()
		{
			var tooltip = Telerik.Web.UI.RadToolTip.getCurrent();
			if (tooltip) tooltip.hide();
		};

		var closeOnDocumentClick = function (e)
		{
			var tooltip = Telerik.Web.UI.RadToolTip.getCurrent();
			if (tooltip && !$telerik.isMouseOverElementEx(tooltip.get_popupElement(), e))
			{
				tooltip.hide();
			}
		};

		var showRadTooltip = function (helpItemIconId)
		{

			logInfo('imod.HelpProvider showRadTooltip ' + helpItemIconId);

			var tooltip = $find("HELPPROVIDER_RadToolTip");
			//tooltip.hide();
			//var helpItemIconElement = jQuery("#" + helpItemIconId);
			tooltip.set_targetControlID(helpItemIconId);

			window.setTimeout(function ()
			{
				tooltip.show();
				logInfo('imod.HelpProvider showRadTooltipsetTimeout ' + helpItemIconId + ' targetControlID=' + tooltip.get_targetControlID());
			}, 20);
		};


		var endsWith = function (str, suffix)
		{

			return str.indexOf(suffix, str.length - suffix.length) !== -1;
		};


		var insertBeforeTag = function (str, helpIconMarkup)
		{

			var endIndex = str.length - '<br>'.length;
			return str.substring(0, endIndex) + helpIconMarkup + '<br>';
		};


		var logInfo = function (message)
		{
			imod.log(message);
		};

		var appendHelpItemMarkUp = function (elementHtml, element, helpIconMarkup)
		{
			if (elementHtml && elementHtml.indexOf(helpIconMarkup) == -1)
			{

				if (endsWith(elementHtml, '<br>'))
				{

					logInfo(element.attr('id') + ' ends with br');

					var newMarkup = insertBeforeTag(elementHtml, helpIconMarkup);

					element.html(newMarkup);
				}
				else
				{

					element.after(helpIconMarkup);
				}
			}
		};

		return {

			HELPDATA: this.providerData,

			init: function (helpData, options)
			{

				if (initialized)
				{
					return;
				}


				logInfo('imod.HelpProvider helpItemData ');
				logInfo(helpData);

				// If options exist, lets merge them
				// with our default settings
				if (options)
				{
					jQuery.extend(settings, options);
				}

				if (helpData)
				{
					providerData = helpData;
				}

				jQuery('<div class="contextualHelpContainer">')
					.attr("id", helpItemContainerElementId)
					.css("display", "none")
					.appendTo("#HELPPROVIDER_RadToolTip_Content");

				helpItemContainer = jQuery('#' + helpItemContainerElementId);

				for (var i = 0; i < providerData.HelpItems.length; i++)
				{

					if (providerData.HelpItems[i].IsVisible)
					{
						var itemElementId = providerData.HelpItems[i].ControlClientId;
						var helpItemIconId = itemElementId + "helpIcon";

						var helpIconMarkup = "&nbsp;<img id='" + helpItemIconId + "' class=\"imod-contextual-help-icon\" onclick=\"imod.HelpProvider.show('" + itemElementId + "','" + helpItemIconId + "')\" src='" + settings.helpIconUrl + "'/>";
						var elementHtml = jQuery("#" + itemElementId).html();
						var elementType = jQuery("#" + itemElementId).get(0);

						if (elementType != null)
						{

							if (elementType.tagName.toLowerCase() == "span")
							{
								appendHelpItemMarkUp(elementHtml, jQuery("#" + itemElementId), helpIconMarkup);
							}
							if (elementType.tagName.toLowerCase() == "input")
							{
								var element = controlLabel(itemElementId);
								appendHelpItemMarkUp(element.html(), element, helpIconMarkup);
							}
						}
					}
				}

				imod.HelpProvider.toggleicons(IModController.helpSettings == null || IModController.helpSettings.ContextualHelpEnabled);

				if ($telerik) {
				    $telerik.$(document).click(closeOnDocumentClick);
				} 

				initialized = true;

				logInfo('imod.HelpProvider init complete');
			},

			toggleicons: function (val)
			{
				for (var i = 0; i < providerData.HelpItems.length; i++)
				{
					var itemElementId = providerData.HelpItems[i].ControlClientId;
					var helpItemIconId = itemElementId + "helpIcon";
					jQuery("#" + helpItemIconId).toggle(val);
				}
			},

			hide: function ()
			{


			},

			show: function (elementId, itemVerbiageText)
			{

				//helpItemContainer.html('called by' + elementId + '');
				showHelpItem(elementId, itemVerbiageText);
			}
		};
	}();
    
	function ShowHideContextualHelp(val) {
	    // Step 1: persist the user setting for next page_load
	    if (IModController.helpSettings != null) {
	        IModController.helpSettings.ContextualHelpEnabled = val;

	        var ajaxPostOptions = {
	            url: '/controls/WebComponents/Services/MemberPersonalizationService.asmx/SaveHelpSettings',
	            data: Sys.Serialization.JavaScriptSerializer.serialize({ 'settings': IModController.helpSettings }),
	            success: function (result) {
	                if (window.console) console.log(result.Success);
	                if (window.console) console.log(result.Data);
	            },
	            error: function () {
	                if (window.console) console.log('Error saving HelpSettings');
	            }
	        };

	        imod.JqueryAjax.JsonPost(ajaxPostOptions);
	    }
	    else {
	        if (window.console) console.log('IModController.helpSettings is null');
	    }

	    // Step 2 - apply real time to any helpitems currently displayed
	    if (imod.HelpProvider != null) {
	        imod.HelpProvider.toggleicons(IModController.helpSettings == null || IModController.helpSettings.ContextualHelpEnabled);
	    }
	}

	imod.TransactionState = function (urlToTransactionStateService, cid, mid, successCallback) {
		this.urlToTransactionStateService = urlToTransactionStateService;
		this.controlId = cid;
		this.memberId = mid;
		this.success = successCallback;
	};

	imod.TransactionState.prototype = function () {
		var checkPendingTransactionState = function () {
			var ajaxPostOptions =
			{
				url: this.urlToTransactionStateService,

				data: Sys.Serialization.JavaScriptSerializer.serialize({ cid: this.controlId, mid: this.memberId }),
				success: this.success
			};

			imod.JqueryAjax.JsonPost(ajaxPostOptions);
		};

		return {
			checkPendingTransactionState: checkPendingTransactionState
		};
	}();

	imod.HtmlScraper = function (urlToHtmlScraperService, controlId, urlToScrape, startToken, endToken, urlToScriptFile, cacheDuration, resultElement, successCallback) {
	    // the URL to the service
	    this.urlToHtmlScraperService = urlToHtmlScraperService;

	    // the current control's ControlId
	    this.controlId = controlId;

	    // the URL that will be scraped
	    this.urlToScrape = urlToScrape;

	    // user-defined starting point to scrape
	    this.startToken = startToken;

	    // user-defined end point to scrape
	    this.endToken = endToken;

	    // script file to be appended to the scraped html
	    this.urlToScriptFile = urlToScriptFile;

	    // the duration of the cache
	    this.cacheDuration = cacheDuration;

	    // the element that holds the result of the scrape
	    this.resultElement = resultElement;

	    // the function that will be called when the service call is successful
	    this.success = successCallback;
	};

	imod.HtmlScraper.prototype = function () {
	    var getHtmlFromUrl = function () {
	        var ajaxPostOptions =
            {
                url: this.urlToHtmlScraperService,

            	/// @author Jeffrey Jones @date 2013-06-25 @ref https://jira.imodules.com/browse/ENC-13093 @comment added sid and gid to the parameter to the service call
				///@author John Rogers @date 2/12/2015 removed site and group id as these are now in the header
                data: Sys.Serialization.JavaScriptSerializer.serialize({ controlId: this.controlId, groupChain: IModController.groupChain, urlToScrape: this.urlToScrape, startToken: this.startToken, endToken: this.endToken, urlToScriptFile: this.urlToScriptFile, cacheDuration: this.cacheDuration }),
                success: this.success
            };

	        imod.JqueryAjax.JsonPost(ajaxPostOptions);
	    };

	    return {
	        getHtmlFromUrl: getHtmlFromUrl
	    };
	}();

	imod.ErrorLevelEnum = {
		Debug: { value: 1, name: "Debug" },
		Error: { value: 2, name: "Error" },
		Information: { value: 3, name: "Information" },
		Warning: { value: 4, name: "Warning" },
		Success: { value: 5, name: "Success" }
	};

	imod.ValidationError = function (level, message)
	{
		this.Level = level === undefined || level === null ? imod.ErrorLevelEnum.Error.value : level;

		this.Message = message === undefined || message === null ? '' : message;
	};

	imod.ValidationError.prototype = function ()
	{
		var toString = function ()
		{
			return this.Message;
		};

		var toHtmlListItem = function ()
		{
			return '<li>' + this.Message + '</li>';
		};

		return {
			ToString: toString,
			ToHtmlListItem: toHtmlListItem
		};

	}();

	imod.ValidationResult = function (success)
	{
		this.Success = success === undefined || success === null ? true : success;

		this.Errors = [];
	};

	imod.ValidationResult.prototype = function ()
	{

		var addDebugMessage = function (message)
		{
			this.Errors.push(new imod.ValidationError(imod.ErrorLevelEnum.Debug.value, message));
		};

		var addErrorMessage = function (message)
		{
			this.Success = false;
			this.Errors.push(new imod.ValidationError(imod.ErrorLevelEnum.Error.value, message));
		};

		var addInformationMessage = function (message)
		{
			this.Errors.push(new imod.ValidationError(imod.ErrorLevelEnum.Information.value, message));
		};

		var addWarningMessage = function (message)
		{
			this.Errors.push(new imod.ValidationError(imod.ErrorLevelEnum.Warning.value, message));
		};

		var toString = function (level, delimiter)
		{
			var messageBuilder = '';

			if (this.Errors.length > 0)
			{
				jQuery.each(this.Errors, function (index, value)
				{
					if (level === undefined || level === null)
					{
						messageBuilder += value.ToString() + (delimiter === undefined || delimiter === null ? '<br />' : delimiter);
					} else
					{
						if (value.Level === level)
						{
							messageBuilder += value.ToString() + (delimiter === undefined || delimiter === null ? '<br />' : delimiter);
						}
					}
				});
			}

			return messageBuilder;
		};

		var toHtmlList = function (level)
		{
			var messageBuilder = '';

			if (this.Errors.length > 0)
			{
				messageBuilder += '<ul>';

				jQuery.each(this.Errors, function (index, value)
				{
					if (level === undefined || level === null)
					{
						messageBuilder += value.ToHtmlListItem();
					} else
					{
						if (value.Level === level)
						{
							messageBuilder += value.ToHtmlListItem();
						}
					}
				});

				messageBuilder += '</ul>';
			}

			return messageBuilder;
		};

		return {
			AddDebugMessage: addDebugMessage,
			AddErrorMessage: addErrorMessage,
			AddInformationMessage: addInformationMessage,
			AddWarningMessage: addWarningMessage,
			ToString: toString,
			ToHtmlList: toHtmlList
		};
	}();

	if (!imod.Date) imod.Date = {};
	imod.Date.DefaultShortDateFormat = "MM/dd/yyyy";
	imod.Date.ToShortDateByFormat = function (date, format){
		if (!format) format = imod.Date.DefaultShortDateFormat;
		var dateToFormat = new Date(date);
		var formatedDate = format;
		formatedDate = formatedDate.replace("MM", ((dateToFormat.getMonth() < 9) ? "0" : "") + (dateToFormat.getMonth() + 1));
		formatedDate = formatedDate.replace("dd", ((dateToFormat.getDate() < 10) ? "0" : "") + dateToFormat.getDate());
		formatedDate = formatedDate.replace("yyyy", dateToFormat.getFullYear());
		formatedDate = formatedDate.replace("M", dateToFormat.getMonth() + 1);
		formatedDate = formatedDate.replace("d", dateToFormat.getDate());
		formatedDate = formatedDate.replace("yy", dateToFormat.getFullYear().toString().substring(2));
		return formatedDate;
	};
	imod.Date.isValid = function (date) {
		if (!date || Object.prototype.toString.call(date) !== "[object Date]") {
			return false;
		}
		// An invalid date object returns NaN for getTime() and NaN is the only
		// object not strictly equal to itself.
		return date.getTime() === date.getTime();
	};

	if (!imod.Accessibility) imod.Accessibility = {};
	imod.Accessibility.Enable508SkipNav = function (target) {

		if (!target) {
			console.warn('Enable508SkipNav - initalized without a valid target');
			return;
		}

		console.log('Enable508SkipNav - adding link to body');
		jQuery('<div id="imod-skip"><a href="#main">Skip to Main Content</a></div>').prependTo('body');
		
		// FOR CONTENT SKIP ACTION
		// bind a click event to the 'skip' link
		
		jQuery("#imod-skip").on('click', 'a', function (e) {

			e.preventDefault();

			console.log('Enable508SkipNav - handling click');

			// prepend the leading hash and declare
			// the content we're skipping to
			var skipTo = (target[0] !== '#' ? "#" : '') + target;
			
			// Setting 'tabindex' to -1 takes an element out of normal
			// tab flow but allows it to be focused via javascript
			jQuery(skipTo).attr('tabindex', -1).on('blur focusout', function() {

				// when focus leaves this element,
				// remove the tabindex attribute
				jQuery(this).removeAttr('tabindex');

			}).focus()				// focus on the content container
			[0].scrollIntoView();	// put it where it goes
		});
	}
	
	String.prototype.IsNullOrEmpty = function () {
		var value = this,
			isNullOrEmpty = false;
		if (value.length === '') {
			isNullOrEmpty = true;
		}
		return isNullOrEmpty;
	};
	String.prototype.Format = function (args) {
		var template = this;
		return template.replace(String.prototype.Format.regex, function (item) {
			var initialValue = parseInt(item.substring(1, item.length - 1));
			var replace;
			if (initialValue >= 0) {
				replace = args[initialValue];
			}
			else if (initialValue === -1) {
				replace = "{";
			}
			else if (initialValue === -2) {
				replace = "}";
			} else {
				replace = "";
			}
			return replace;
		});
	};
	String.prototype.Format.regex = new RegExp("{-?[0-9]+}", "g");

	jQuery(function() {
		jQuery("span.imod-admin-nav-new-email-marketing-reporting").parent().css("text-decoration", "none");
	});

	//**DO NOT PUT ANYTHING BELOW THIS LINE**
}

if (window.IModController) imod.log("imodules_common_1_0_2.js");
