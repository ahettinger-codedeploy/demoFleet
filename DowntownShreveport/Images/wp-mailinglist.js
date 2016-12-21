jQuery(document).ready(function(){
	jQuery("input[id*=checkboxall]").click(function() {
		var checked_status = this.checked;
		jQuery("input[id*=checklist]").each(function() {
			this.checked = checked_status;
		});
	});
	
	jQuery("input[id*=checkinvert]").click(function() {
		//this.checked = false;
	
		jQuery("input[id*=checklist]").each(function() {
			var status = this.checked;
			
			if (status == true) {
				this.checked = false;
			} else {
				this.checked = true;
			}
		});
	});
});

function wpml_submitserial(form) {
	jQuery('#wpml_submitserial_loading').show();
	var formdata = jQuery(form).serialize();

	// since 2.8 ajaxurl is always defined in the admin header and points to admin-ajax.php
	jQuery.post(ajaxurl + '?action=wpmlserialkey', formdata, function(response) {
		jQuery('#wpmlsubmitserial').html(response);
		jQuery.colorbox.resize();
	});
}

function jqCheckAll(checker, formid, name) {					
	jQuery('input:checkbox[name="' + name + '[]"]').each(function() {
		jQuery(this).attr("checked", checker.checked);
	});
}

function wpml_scroll(selector) {
	var targetOffset = jQuery(selector).offset().top;
    jQuery('html,body').animate({scrollTop: targetOffset}, 500);
}

function wpml_getlistfields(list_id, wpoptinid, divid, poststring, getpost, tabi) {
	if (getpost == "N") { var poststring = jQuery("#optinform" + wpoptinid).serialize(); }	
	jQuery("#widget_loading" + wpoptinid).show();
	
	jQuery.post(wpmlAjax + "?cmd=get_list_fields&id=" + list_id + "&wpoptinid=" + wpoptinid + "&tabi=" + tabi + "", poststring, function(data) {
		jQuery("#widget_loading" + wpoptinid).hide();
		jQuery("#" + divid).html(data).show();
	});
}

function wpml_subscribe(wpoptinid, form) {
	var formvalues = jQuery("#optinform" + wpoptinid).serialize();
	//var updatediv = "wpmlwidget-" + wpoptinid;
	var updatediv = "optinform" + wpoptinid;
	var mytime = new Date().getTime();
	
	jQuery("#widget_loading" + wpoptinid).show();
	jQuery.post(wpmlAjax + "?cmd=subscribe&mytime=" + mytime + "&divid=" + wpoptinid + "&id=" + wpoptinid, formvalues, function(data) {
		jQuery("#" + updatediv).html(data);
		
		if (wpmlScroll == "Y") {
			wpml_scroll(jQuery('#' + updatediv));
		}
	});
}

function wpml_titletoslug(title) {
	var title = title.toLowerCase();
	var slug = title.replace(/[^0-9a-z]+/g, "");
	jQuery('#Field_slug').val(slug);	
}

function wpml_tinymcetag(tag) {
	if (window.tinyMCE && tag != "") {
		window.tinyMCE.execInstanceCommand('content', 'mceInsertContent', false, tag);
		//tinyMCEPopup.editor.execCommand('mceRepaint');	
	}
	
	wpml_scroll('#editorcontainer');
}