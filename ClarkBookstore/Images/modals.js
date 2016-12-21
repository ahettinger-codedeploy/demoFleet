jQuery.fn.closeModal = function() {
	$(this).jqmHide();
}

jQuery.fn.openModal = function () {

	var obj = $(this);

	var content = obj.find('.jqm-content');
	obj.css({ position: "absolute", visibility: "hidden", display: "block" });
	obj.find('.jqm-top-center').width(content.outerWidth());
	obj.find('.jqm-bottom-center').width(content.outerWidth());
	obj.find('.jqm-middle-left').height(content.outerHeight());
	obj.find('.jqm-middle-right').height(content.outerHeight());
	obj.css({ position: "", visibility: "visible", display: "none" });

	obj.jqmShow();

}

jQuery.fn.createModal = function (args) {
	var default_args = {
		'title': "&nbsp;",
		'width': "auto",
		'height': "auto",
		'closeButton': true,
		'modal': false,
		'maxHeight': "auto"
	}

	for (var index in default_args) {
		if (typeof args[index] == "undefined") {
			args[index] = default_args[index];
		}
	}

	var obj = $(this);

	var prependHtml = '<div><div class="jqm-top-left"></div><div class="jqm-top-center"></div><div class="jqm-top-right"></div></div>';
	prependHtml = prependHtml + '<div><div class="jqm-middle-left"></div><div class="jqm-content">';
	prependHtml = prependHtml + '<div class="jqm-title">';
	if (args['closeButton']) {
		prependHtml = prependHtml + '<a href="#" class="close-jqm"></a>';
	}
	prependHtml = prependHtml + args["title"] + '</div>';
	var appendHtml = '</div><div class="jqm-middle-right"></div></div>';
	appendHtml = appendHtml + '<div><div class="jqm-bottom-left"></div><div class="jqm-bottom-center"></div><div class="jqm-bottom-right"></div></div><div style="clear: both"></div>';

	obj.html(prependHtml + $(this).html() + appendHtml);

	var content = obj.find('.jqm-content');
	obj.css({ position: "absolute", visibility: "hidden", display: "block" });


	if (!minMaxAutoSupport(content, args))
		args["maxHeight"] = "400px";

	//if ($.browser.msie)
	//	args["maxHeight"] = "400px";

	content.css({ height: args["height"], width: args["width"], overflow: "auto", maxHeight: args["maxHeight"] });


	obj.find('.jqm-top-center').width(content.outerWidth());
	obj.find('.jqm-bottom-center').width(content.outerWidth());
	obj.find('.jqm-middle-left').height(content.outerHeight());
	obj.find('.jqm-middle-right').height(content.outerHeight());
	obj.css({ position: "", visibility: "visible", display: "none" });
	if (args['modal']) {
		obj.jqm({ modal: true });
	}
	else {
		obj.jqm();
	}

	obj.find('a.close-jqm').click(function () { obj.jqmHide(); return false; });

}

function minMaxAutoSupport (obj, args) {

	// IE chokes when maxHeight, minHeight, maxWidth or minWidth set to auto
	// This checks to see if maxHeight can be set to auto. If not then returns false.

	try {
		obj.css({ maxHeight: args["maxHeight"] });
		return true;
	} catch (e) {
		return false;
	}	
}