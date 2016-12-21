jQuery(document).ready(function() {
	jQuery("[id*=checkboxall]").click(function() {
		var status = this.checked;
		
		jQuery("[id*=checklist]").each(function() {
			this.checked = status;	
		});
	});
});

function wpbrrefresh(pcontroller, options) {
	if (wpbrFadeBanners) {
		jQuery("#" + options.divid + " div.wpbrbannerinside").fadeOut("slow");
	}

	jQuery("#" + options.divid).load(wpbrAjax + "?cmd=refresh", options, function() {
		if (wpbrFadeBanners) {
			jQuery("#" + options.divid + " div.wpbrbannerinside").hide().fadeIn("slow");	
		}
		
		return true;
	});
	
	return false;
}