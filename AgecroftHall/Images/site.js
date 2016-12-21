_PFX = 'ctl00_C_';
_PPFX = '#ctl00_C_';

var currentEvents = null;
var ruleHeight = 0;
var vpHeight = 0;

$(function () {
    AutoHover_OnLoad();
    Watermark_OnLoad();
    SetTextSize($.cookie('textSize'));
    ToggleSitemap($.cookie('hideSiteMap'));
    Calendar_OnLoad();
    FormBuilder_OnLoad();
    setInterval('ExtendRules()', 250);
    Fisheye_OnLoad();

    Gallery_OnLoad();

});

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function ExtendRules() {
	if ($(window).height() == vpHeight) return;
	vpHeight = $(window).height();
	if (getParameterByName('page') == 'home') {
	    //if ($('body').hasClass('page-home')) {
	    var bottomHeight = $('.cms-layout-footer').outerHeight() + $('.cms-layout-sitemap').outerHeight();
	    var contentHeight = $('.cms-layout-header').outerHeight() + bottomHeight;
	    $('.cms-layout-body').height(vpHeight - contentHeight - 20);
	    bottomHeight += 60;
	    $('.cms-fisheye-dock').css('bottom', bottomHeight + 'px');
	    bottomHeight -= 30
	    $('.cms-layout-leftside').css('bottom', bottomHeight + 'px');
	}
	else {
	    $('.cms-layout-leftside').height($('.cms-layout-body').height());
	}

}
