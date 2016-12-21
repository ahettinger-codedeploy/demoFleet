jQuery(".button").hover(function(){
			var hoverBg = jQuery('span.buttonhover',this).css('background-color');
			var hoverColor = jQuery('span.buttonhover',this).css('color');
			if(hoverBg!=undefined){
				jQuery(this).css('background-color',hoverBg);
			}
			if(hoverColor!=undefined){
				jQuery('span.bspan',this).css('color',hoverColor);
			}
		},
		function(){
			var bg = jQuery('span.buttonnorm',this).css('background-color');
			var color = jQuery('span.buttonnorm',this).css('color');
			if(bg!=undefined){
				jQuery(this).css('background-color',bg);
			}
			if(color!=undefined){
				jQuery('span.bspan',this).css('color',color);
			}
	});

jQuery("a[rel^='prettyPhoto']").prettyPhoto({animation_speed:'normal',default_width: 900,default_height: 450,theme:upptheme,show_title:false,social_tools:''});
jQuery("a.prettyPhoto").prettyPhoto({animation_speed:'normal',default_width: 900,default_height: 450,theme:upptheme,show_title:false,social_tools:''});


jQuery(".toggle").each(function () {
	var div = jQuery('.toggle_content',this);
	var title = jQuery('h4',this);
	jQuery("h4",this).click(function(){
		div.slideToggle("slow");
		if(title.hasClass("acctogg_active")){
			title.removeClass("acctogg_active");
		} else {
			title.addClass("acctogg_active");
		}
		
	});
  });

jQuery(function() {
	jQuery("ul.tabs").tabs("div.panes > div");
});
jQuery("a.image_zoom").each(function(){
	var image=jQuery(this);
		if (jQuery.browser.msie && parseInt(jQuery.browser.version, 10) < 7) {} else {
			if (jQuery.browser.msie && parseInt(jQuery.browser.version, 10) < 9) {
				image.hover(function(){
					jQuery(".image_overlay",this).css("visibility", "visible");
				},function(){
					jQuery(".image_overlay",this).css("visibility", "hidden");
				}).children('img').after('<span class="image_overlay"></span>');
			}else{
				image.hover(function(){
					jQuery(".image_overlay",this).animate({
						opacity: '0.7'
					},"fast");
				},function(){
					jQuery(".image_overlay",this).animate({
						opacity: '0'
					},"fast");
				}).children('img').after(jQuery('<span class="image_overlay"></span>').css({opacity: '0',visibility:'visible'}));
			}
		}
			
});
jQuery("a.image_play").each(function(){
	var image=jQuery(this);
		if (jQuery.browser.msie && parseInt(jQuery.browser.version, 10) < 7) {} else {
			if (jQuery.browser.msie && parseInt(jQuery.browser.version, 10) < 9) {
				image.hover(function(){
					jQuery(".image_overlay",this).css("visibility", "visible");
				},function(){
					jQuery(".image_overlay",this).css("visibility", "hidden");
				}).children('img').after('<span class="image_overlay"></span>');
			}else{
				image.hover(function(){
					jQuery(".image_overlay",this).animate({
						opacity: '0.7'
					},"fast");
				},function(){
					jQuery(".image_overlay",this).animate({
						opacity: '0'
					},"fast");
				}).children('img').after(jQuery('<span class="image_overlay"></span>').css({opacity: '0',visibility:'visible'}));
			}
		}
			
});
jQuery(".accordion").tabs(".pane", {tabs: 'h4', effect: 'slide'});
jQuery(function() {
	jQuery('a[rel*=external]').click( function() {
        window.open(this.href);
        return false;
    });
});
jQuery(".ultimatum-responsive-menu").each(function () {
	var form = jQuery('.responsive-nav-form select',this);
	jQuery(form).change(function() {
		window.location = jQuery(this).find("option:selected").val();
 });
 
});

