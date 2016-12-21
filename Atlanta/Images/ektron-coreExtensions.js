$ektron.extend({
    // Left Trim method
    ltrim: function(text) { return (text+"").replace(Ektron.RegExp.ltrim,""); },
    // Right Trim method
    rtrim: function(text) { return (text+"").replace(Ektron.RegExp.rtrim,""); },
    // method to work around bugs in jquery' offset() when element is nested inside relative/absolute elements
    // from: http://www.mail-archive.com/jquery-en@googlegroups.com/msg72499.html
    positionedOffset: function(elem) {
        var offsetParent = elem.offsetParent(), offset = elem.offset(), position = elem.position();
        if ( !/^body|html$/i.test( offsetParent[ 0 ].tagName ) ) {
            return { left : position.left, top : position.top, from : offsetParent }
        } else {
            return { left : offset.left, top : offset.top, from : offsetParent }
        }
    },
    // Method to add new functions to the window.onload event while preserving any existing onload functionality
    addLoadEvent: function(fn)
    {
        var oldOnLoad = window.onload;
        if (typeof window.onload != 'function')
        {
            window.onload = fn;
        }
        else
        {
            window.onload = function()
            {
	            oldOnLoad();
	            fn();
            }
        }
    },
    // See also $ektron.fn.ajaxCallback
	ajaxCallback: function(uniqueId, data, callback, onexception) // or function(options)
	{
		var options = ("object" == typeof uniqueId ? uniqueId :
		{
			uniqueId: uniqueId,
			data: data,
			success: callback,
			onexception: onexception
		});
		var ajaxSettings = $ektron.extend(
		{
			uniqueId: "__Page",
			type: "POST",
			dataType: "html",
			data: "",
			success: function() { },
			onexception: null
		}, options);
		var uniqueId = ajaxSettings.uniqueId;
		var data = ajaxSettings.data;
		if ("object" == typeof data && data != null)
		{
			data = $ektron.param(data);
		}
		var successCallback = ajaxSettings.success;
		var onexception = ajaxSettings.onexception;
		var aryClientManager = [];
		return $ektron.ajax($ektron.extend(ajaxSettings,
		{
			data:
			{
				__CALLBACKID: uniqueId,
				__CALLBACKPARAM: data,
				__VIEWSTATE: "",
				EktronClientManager: $ektron("#EktronClientManager").val()
			},
			success: function(data)
			{
				if ("string" == typeof data)
				{
					var aryMatch = data.match(/^([0-9]+)\|/);
					if (aryMatch && 2 == aryMatch.length)
					{
						var nCount = parseInt(aryMatch[1], 10);
						data = data.substring(aryMatch[0].length + nCount);
					}
					else
					{
						data = data.replace(/^[se]/, "").replace(/0\|$/, "");
					}
				}
				try
				{
					successCallback.apply(this, arguments);
				}
				catch (ex)
				{
					Ektron.OnException(this, onexception, ex, arguments, successCallback);
				}
				$ektron(document).trigger("EktronReady", ["callback"]);
			}
		}));
	},
    isEditableElement: function(elem)
    {
		if (!elem) return false;
		var bEditable = (true == elem.isContentEditable);
		if (elem.ownerDocument)
		{
		    if ("on" == elem.ownerDocument.designMode)
		    {
				bEditable = true;
				var strContentEditable = elem.contentEditable; // FF requires 3.0 and later
				if ("false" == strContentEditable)
				{
					bEditable = false;
				}
				else if (strContentEditable != "true")
				{
					$ektron(elem).parents("[contenteditable]").each(function()
					{
						var strContentEditable = this.contentEditable; // FF requires 3.0 and later
						if ("true" == strContentEditable) return false; // break
						if ("false" == strContentEditable)
						{
							bEditable = false;
							return false; // break
						}
					});
				}
		    }
		    else if ((("INPUT" == elem.tagName && ("text" == elem.type || "" == elem.type)) || "TEXTAREA" == elem.tagName) && !elem.disabled && !elem.readOnly)
		    {
		        bEditable = true;
		    }
		}
		return bEditable;
    }
});

$ektron.fn.extend({
    unwrapInner: function()
    {
        var ret = [];
		this.each(function()
		{
            var eThis = $ektron(this);
            var content = eThis.contents();
            eThis.replaceWith(content);
            ret = ret.concat(content.get());
        });
        return this.pushStack(ret);
    },
    // See also $ektron.ajaxCallback
    ajaxCallback: function (uniqueId, data, callback, onexception) // or function(options)
    {
        var me = this;
        var options = ("object" == typeof uniqueId ? uniqueId :
		{
		    uniqueId: uniqueId,
		    data: data,
		    complete: callback,
		    onexception: onexception
		});
        var ajaxSettings = $ektron.extend(
		{
		    success: function () { },
		    complete: function () { },
		    onexception: null
		}, options);
        var successCallback = ajaxSettings.success;
        var completeCallback = ajaxSettings.complete;
        var onexception = ajaxSettings.onexception;
        $ektron.ajaxCallback($ektron.extend(ajaxSettings,
		{
			success: function(data)
			{
				$ektron.each(me, function()
				{
		            $ektron(this).html(data);
		        });
				try
				{
		            successCallback.apply(me, arguments);
		        }
				catch (ex)
				{
		            Ektron.OnException(me, onexception, ex, arguments, successCallback);
		        }
		    },
			complete: function()
			{
				try
				{
		            completeCallback.apply(me, arguments);
		        }
				catch (ex)
				{
		            Ektron.OnException(me, onexception, ex, arguments, completeCallback);
		        }
		    },
		    onexception: onexception
		}));
        return this;
    },
    // Correct uniqueness for all id attributes and assoc labels.
    // Correct uniqueness for all name attributes.
    makeIdentifiersUnique: function (makeUnique)
    // makeUnique: (optional) function that returns unique identifier given an identifier (string)
    {
        var descendantOrSelf = this.find("*").andSelf();
        var strUniqueSuffix = Math.floor(Math.random() * 1679616).toString(36); // 4 digit alphanum
        // makeUnique must ensure the new unique 'id' continues to match <label for>
        makeUnique = ("function" == typeof makeUnique ? makeUnique : function(id)
        {
            // Remove suffix of "_" 4-digit-alphanum (if it exists), then append new suffix
            return id.replace(/_[0-9a-z]{4}$/, "") + "_" + strUniqueSuffix;
        });
        descendantOrSelf.filter("[id]").each(function()
        {
            this.id = makeUnique(this.id);
        });
        descendantOrSelf.filter("label").each(function()
        {
            this.htmlFor = makeUnique(this.htmlFor);
        });
        // caution: do not split id & name uniqueness code b/c for <a>, id should equal name,
        // which won't be the case if the .random() function is called twice.
        descendantOrSelf.filter("[name]").each(function () {
            try {
                if ($ektron.browser.msie) {
                    // #71104: It was relying on Microsoft JScript previously to update the name attribute in IE runtime. 
                    // HOWEVER, JScript does not seems to work anymore, updated the code with jquery attribute.
                    // tested on INPUT fields. Other fields will fail and trapped in the exception and be ignored.
                    $ektron(this).attr("name", makeUnique(this.name)).prop("name", makeUnique(this.name));
                }
		        else
		        {
                    this.name = makeUnique(this.name);
                }
            }
	        catch (ex)
	        {
                // ignore
            };
        });
        return this;
    }
});

Ektron.Class.overrides("jquery", ["handle"]).call(function(){
    this.handle = function(event){
        try {
            return $ektron.event.jquery_handle.apply(this, arguments); // pass all arguments in case jquery API changes
        } catch (ex) {
    	    Ektron.OnException.diagException(ex, arguments, $ektron.event.jquery_handle);
            return false;
        }
    };
}, $ektron.event);