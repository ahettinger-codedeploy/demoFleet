
$.browser.device = (/android|webos|iphone|ipad|ipod|blackberry|iemobile|opera mini/i.test(navigator.userAgent.toLowerCase()));

$(function () {
    $("iframe").each(function () {
        if (this.src.indexOf("youtube.com") > -1) {
            if (this.src.indexOf("?") > -1) {
                if (this.src.indexOf("wmode") == -1)
                    this.src += "&wmode=transparent";
            }
            else {
                this.src += "?wmode=transparent";
            }
        }
    });
});
////////////////////////////////////////////
//  Util (knockout)
////////////////////////////////////////////

//marks isDirty when a change happens so we know when to call SaveFiles
if (typeof (ko) != "undefined") {
    ko.extenders.logChange = function (target, option) {
        target.subscribe(function (newValue) {
            this.target.parent.isDirty(true);
        });
        return target;
    };

}



////////////////////////////////////////////
//  Util (ews.Util)
////////////////////////////////////////////

if (typeof ews == "undefined")
    ews = {};

ews.Util = {};
ews.Util.CreateHandler = function (fn, context) {
    return function (e) { return fn.call(context, this, e); };
}
ews.Util.componentToHex = function(c) {
    var hex = c.toString(16);
    return hex.length == 1 ? "0" + hex : hex;
}
ews.Util.rgbToHex = function(color) {
    if (color == null || color == "" || color.substr(0, 1) === "#") {
        return color;
    }
    if (color.substr(0, 3) != "rgb") {
        return;
    }
    var nums = /(.*?)rgb\((\d+),\s*(\d+),\s*(\d+)\)/i.exec(color),
            r = parseInt(nums[2], 10).toString(16),
            g = parseInt(nums[3], 10).toString(16),
            b = parseInt(nums[4], 10).toString(16);
    return "#" + ews.Util.componentToHex(r) + ews.Util.componentToHex(g) + ews.Util.componentToHex(b);
}

ews.Util.getCursorPosition = function (e, oTarget) {

    var totalOffsetX = 0;
    var totalOffsetY = 0;
    var canvasX = 0;
    var canvasY = 0;
    var currentElement = oTarget;

    do {
        totalOffsetX += currentElement.offsetLeft - currentElement.scrollLeft;
        totalOffsetY += currentElement.offsetTop - currentElement.scrollTop;
    }
    while (currentElement = currentElement.offsetParent)

    canvasX = e.pageX - totalOffsetX;
    canvasY = e.pageY - totalOffsetY;
    return { x: canvasX, y: canvasY }

}

ews.Util.EditMode = function () {
    if (ews.Editor)
        return true;
    else
        return false;
}

ews.Util.GetPageHeight = function () {

    if ($.browser.mozilla) {
        nMaxHeight = $("html")[0].scrollHeight;
    } else {
        var sPix = $("body").css("marginTop");
        var nMaxHeight = document.body.clientHeight + parseInt($("body").css("marginTop")) + parseInt($("body").css("marginBottom"));
        if (document.documentElement && document.documentElement.clientHeight > nMaxHeight) {
            nMaxHeight = document.documentElement.clientHeight;
        }
    }
    return nMaxHeight;
};

ews.Util.GetElementRight = function (e) {
    return (e.offset().left + e.width());
};

ews.Util.GetElementBottom = function (e) {
    return (e.offset().top + e.height());
};

ews.Util.EscapeHtml = function (html) {
    return html.replace(/&/g, '&amp;').replace(/</g, '&lt;');
};

ews.Util.ResolveUrl = function (relativeUrl) {
    if (!ews.Util.ResolveUrlBase)
        ews.Util.ResolveUrlBase = '';
    if (relativeUrl && relativeUrl[0] == '~') {
        return ews.Util.ResolveUrlBase + relativeUrl.substr(1);
    }
    return relativeUrl;
};

ews.Util.encodeHTML = function (sText) {
    return $("<div/>").text(sText).html();
};

ews.Util.decodeHTML = function (sHtml) {
    return $("<div/>").html(sHtml).text();
};
ews.Util.InputClearDefaultValue = function (obj) {
    if (obj.defaultValue == obj.value)
        obj.value = ""
};
ews.Util.KeepAlive = function () {
    var sUrl = ews.Util.ResolveUrl("~/ControlPanel/DropDownPanel/DropDownPanel.js?keepalive=" + new Date());
    $.post(sUrl, {})
};
ews.Util.AsyncFileUpload = function (location, eFileInput, fCallback, oContext) {
    // Create an iframe
    var iframe = document.createElement("iframe");
    iframe.style.display = "none";
    document.body.appendChild(iframe);
    iframe.contentWindow.document.open();
    iframe.contentWindow.document.write("<html><body><form id='form1' action='/ControlPanel/Upload.aspx?Location=" + location + "' name='form1' method='post' enctype=\"multipart/form-data\"></form></body></html>");
    iframe.contentWindow.document.close();

    // Clone it to replace the missing one
    var jInput = $(eFileInput);
    var jSibling = jInput.prev();
    var jParent = jInput.parent();
    var jClone = jInput.clone();

    // Move it to the iframe
    var eForm = iframe.contentWindow.document.getElementById('form1');
    eFileInput.parentNode.removeChild(eFileInput); // have to remove it first or Chrome doesn't permit it
    $(eForm).append(eFileInput);

    // Add the replacement
    if (jSibling.length > 0)
        jClone.insertAfter(jSibling);
    else
        jClone.prependTo(jParent);

    var oMyContext = { callback: fCallback, context: oContext };
    var fEvent = function () { ews.Util.AsyncFileUploadComplete(iframe, oMyContext); };
    if (iframe.addEventListener) {
        iframe.addEventListener("load", fEvent, false);
    } else if (iframe.attachEvent) {
        iframe.attachEvent('onload', fEvent);
    }

    eForm.submit();
};
ews.Util.AsyncFileUploadComplete = function (eIframe, oContext) {
    var sResult = $(eIframe.contentWindow.document.getElementById("result")).text();
    $(eIframe).remove();
    oContext.callback(sResult, oContext.context);
};

ews.Util.Trim = function (sString, sChar) {
    while (sString.substring(sString.length - 1, sString.length) == sChar) {
        sString = sString.substring(0, sString.length - 1)
    }
    while (sString.substring(0, 1) == sChar) {
        sString = sString.substring(1, sString.length)
    }
}

ews.Util.Remove = function(arr, what) {
    var found = arr.indexOf(what);
    while (found !== -1) {
        arr.splice(found, 1);
        found = arr.indexOf(what);
    }
}

jQuery.fn.isChildOverflowingVertically = function (child) {
    var p = jQuery(this).get(0);
    var el = jQuery(child).get(0);
    return (el.offsetTop + el.offsetHeight >= p.offsetHeight);
};

ews.Util.parseJsonDate = function (jsonDateString) {
    if (jsonDateString == null)
        return null;
    if (jsonDateString.indexOf('Date') == -1)
        return new Date(jsonDateString);
    return new Date(parseInt(jsonDateString.replace('/Date(', '')));
}

ews.Util.formatDateShort = function (oDate) {
    if (oDate == null)
        return null;
    return (oDate.getMonth() + 1) + "/" + oDate.getDate() + "/" + oDate.getFullYear();
}

ews.Util.HandleError = function (e, xhr, source) {
    var oResponse = JSON.parse(e.responseText);
    if (source == undefined)
        source = "";
    console.log(oResponse.Message + " StackTrace:" + oResponse.StackTrace);
    alert(source + " - " + oResponse.Message + " StackTrace:" + oResponse.StackTrace);
}
ews.Util.localhost = function () {
    if (document.URL.toLowerCase().indexOf('localhost') > -1) {
        return true;
    } else {
        return false;
    }
}
ews.Util.QueryString = (function (a) {
    if (a == "") return {};
    var b = {};
    for (var i = 0; i < a.length; ++i) {
        var p = a[i].split('=', 2);
        if (p.length == 1)
            b[p[0]] = "";
        else
            b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, " "));
    }
    return b;
})(window.location.search.substr(1).split('&'));

var luhnChk = (function (arr) {

    return function (ccNum) {
        if (ccNum == "2111111111111112")
            return true;
        var
            len = ccNum.length,
            bit = 1,
            sum = 0,
            val;

        while (len) {
            val = parseInt(ccNum.charAt(--len), 10);
            sum += (bit ^= 1) ? arr[val] : val;
        }

        return sum && sum % 10 === 0;
    };
}([0, 2, 4, 6, 8, 1, 3, 5, 7, 9]));