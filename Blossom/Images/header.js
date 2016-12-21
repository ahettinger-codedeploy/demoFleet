

$(function() {
    // run the code in the markup!
    $('table pre code').not('#skip,#skip2').each(function() {
        eval($(this).text());
    });
    
    //hacky hacky hacky!
    $('#cs_PageModeMenuBtnsContainer').prepend('<li id="cs_page_menu_0" class="cs_PageModeMenuBtn"><a href="admin.cfm"><span class="cs_PageModeMenuBtnText">Subsite Admin</span></a></li>');
    
});

function init_header()
{
	window.$jqcache = {
		utilPanel: $("#utility_panels"),
		allPanels: $("#utility_panels > div"),
		ANIMATION_SPEED_CONST: 0.6
	};
}

function setupUtilityPanel(link, panel)
{
	var jqLink = $(link);
	var jqPanel = $(panel);

	$(link).click(function(e) {
		e.preventDefault();
		
		var visiblePanel = $("#utility_panels > div:visible");
		if(visiblePanel.attr("id") == jqPanel.attr("id")) //hide the visible panel
		{
			$jqcache.utilPanel.slideUp("normal", function() { visiblePanel.hide(); });
			jqLink.removeClass("active");
		}
		else if(visiblePanel.length > 0) //fade-in another panel over top of the currently visible one
		{
		$jqcache.allPanels.css("z-index", 1);
		$("#utilities li").removeClass("active");
		visiblePanel.hide();
		jqPanel.css("z-index", 2).fadeIn("normal");
		jqLink.addClass("active"); 
		}
		else //no panels are visible, slide down the clicked one
		{
			jqPanel.show();
			$jqcache.utilPanel.slideDown("normal");
			jqLink.addClass("active");
		}
	});
}

function setupMenu()
{
	var allMenuItems = $("#sf-menu li");
	allMenuItems.hoverIntent(
		function(e) {
			if($(":animated", this).length == 0) //only start if an animation is not already in progress
				$(this).css("z-index", 9999).children("ul").slideDown($(this).children("ul").height()/$jqcache.ANIMATION_SPEED_CONST);
		},
		function(e) {
			$(this).css("z-index", 9998).children("ul").slideUp("fast");
		}
	);
}

$(function() {
	init_header();

	setupUtilityPanel("#utl_flashline", "#panel_flashline");
	setupUtilityPanel("#utl_dir", "#panel_dir");
	setupUtilityPanel("#utl_ask", "#panel_ask");
	setupUtilityPanel("#utl_maps", "#panel_maps");
	
	setupMenu();
});

<!-- this is the javascript for the suckerfish drops -->
	startList = function() {
		if (document.all&&document.getElementById) {
			navRoot = document.getElementById("sf-menu");
			for (i=0; i<navRoot.childNodes.length; i++) {
				node = navRoot.childNodes[i];
				if (node.nodeName=="LI") {
					node.onmouseover=function() {
						this.className+=" sfHover";
			 		}
		  			node.onmouseout=function() {
		 			 this.className=this.className.replace(" sfHover", "");
			   		}
			   	}
			}
		}
	}
	window.onload=startList;
	

jQuery(document).ready(function(){
		document.getElementById("script").style.display = 'block';
		document.getElementById("noscript").style.display = 'none';
	});