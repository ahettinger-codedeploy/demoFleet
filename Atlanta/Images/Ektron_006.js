//bind functions to ready once, and only once
Ektron.ready = function (fn) {
    $ektron(document).one("EktronReady", function () {
        fn.apply(this, arguments);
    });
};

Ektron._ready = {};
Ektron._ready.init = function () {
    $ektron(document).trigger("BeforeEktronReady");
    $ektron(document).trigger("EktronReady");
    $ektron(document).trigger("AfterEktronReady");
};

if (!jQuery.isReady) {
    $ektron(document).ready(function () { Ektron._ready.init(); });
}

// for PageRequestManager
Ektron._ready.endRequestHandler = function (sender, args) {
    var objError = args.get_error();
    if (objError) {
        args.set_errorHandled(true);
    }
    else {
        Ektron.ClientManager.MSAjax.ready = true;
        Ektron.ClientManager.ready({ origin: "ms-ajax" });
    }
};

// for Page.ClientScript.GetCallbackEventReference, which is JavaScript function WebForm_DoCallback
Ektron._ready.ClientScriptCallbackEvent = {
    eventCallback: function (result, context) {
        // note: $ektron.ajaxCallback triggers "EktronReady", ["callback"]
        $ektron(document).trigger("EktronReady", ["callbackEvent", context]);
    },
    errorCallback: function (message, context) {
        if ("undefined" !== typeof (Ektron.OnException)) {
            Ektron.OnException.diagException(new Error("Error during Ajax DoCallback request:\n" + message), arguments);
        }
    }
};

if (typeof Sys != "undefined" && Sys.WebForms && Sys.WebForms.PageRequestManager && Sys.WebForms.PageRequestManager.getInstance() != null) {
    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(Ektron._ready.endRequestHandler);
} else {
    $ektron(document).ready(function () {
        if (typeof Sys != "undefined" && Sys.WebForms && Sys.WebForms.PageRequestManager && Sys.WebForms.PageRequestManager.getInstance() != null) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(Ektron._ready.endRequestHandler);
        }
    });
}

if ("undefined" === typeof (Ektron.ClientManager)) {
    Ektron.ClientManager = {
        add: function (settings) {
            if (Ektron.ClientManager.scripts == null) {
                Ektron.ClientManager.scripts = [];
            }

            //add script to array
            this.scripts.push(settings);

            if (this.scripts.length === 1) {
                //load script immediately
                this.load();
            } else {
                //wait till current script is retrieved
                var intervalId = setInterval(function () {
                    if (Ektron.ClientManager.scripts[0].id === settings.id) {
                        clearInterval(intervalId);
                        Ektron.ClientManager.load();
                    }
                }, 9);
            }
        },
        load: function () {
            //get script from array
            var script = Ektron.ClientManager.scripts[0];
            switch (script.mode) {
                case "postback":
                    $ektron.ajax({
                        url: script.path,
                        dataType: 'script',
                        async: true,
                        complete: function (jqXHR, textStatus) {
                            setTimeout(function () {
                                Ektron.ClientManager.next({ origin: "postback", id: script.id, path: script.path });
                            }, 0);
                        }
                    });
                    break;
                case "callback":
                    setTimeout(function () {
                        Ektron.ClientManager.MSAjax.ready = true;
                        Ektron.ClientManager.next({ origin: "callback", id: script.id, path: script.path });
                    }, 0);
                    break;
                case "css-ajax":
                    setTimeout(function () {
                        Ektron.ClientManager.next({ origin: "css-ajax", id: script.id, path: script.path });
                    }, 0);
                    break;
            }
        },
        next: function (settings) {
            Ektron.ClientManager.scripts.shift();
            if (settings.id !== "callback=proxy") {
                Ektron.ClientManager.updateHiddenField(settings.id);
            }
            Ektron.ClientManager.ready(settings);
        },
        MSAjax: {
            ready: false
        },
        ready: function (settings) {
            //raise Ektron._ready only after all scripts have been loaded
            if ((Ektron.ClientManager.scripts == null || Ektron.ClientManager.scripts.length == 0) && Ektron.ClientManager.MSAjax.ready) {
                Ektron.ClientManager.scripts = null
                Ektron._ready.init();
            }
        },
        updateHiddenField: function (id) {
            var hiddenField = $ektron("#EktronClientManager");
            if (hiddenField.length > 0) {
                var ids = hiddenField.attr("value") + "," + id;
                hiddenField.attr("value", ids);
            }
        }
    };
}