/* (C) 2008 YOOtheme.com */

var YOOTools = {
		
	start: function() {
		
		/* Match height of div tags */
		YOOTools.setDivHeight();

		/* Accordion menu */
		new YOOAccordionMenu('div#middle ul.menu li.toggler', 'ul.accordion', { accordion: 'slide' });

		/* Fancy menu */
		new YOOFancyMenu($E('ul', 'menu'), { mode: 'move', transition: Fx.Transitions.Expo.easeOut, duration: 500 });

		/* Dropdown menu */
		new YOODropdownMenu('div#menu li.parent', { mode: 'height', transition: Fx.Transitions.Expo.easeOut });

		/* Main menu (tab) color settings */
		var currentColor = '#323232';
		var leaveColor = '#ffffff';

		var menuEnter = { 'color': currentColor };
		var menuLeave = { 'color': leaveColor };
		
		new YOOMorph('div#menu li.level1', menuEnter, menuLeave,
			{ transition: Fx.Transitions.expoOut, duration: 300, ignoreClass: 'active' },
			{ transition: Fx.Transitions.sineIn, duration: 200 }, '.level1');
		
		/* Main menu (sub) color settings */
		var currentColor = '#DCDDDE';
		var leaveColor = '#FEFEFE';

		var menuEnter = { 'background-color': currentColor };
		var menuLeave = { 'background-color': leaveColor };
		
		new YOOMorph('div#menu li.level2 a, div#menu li.level2 span.separator', menuEnter, menuLeave,
			{ transition: Fx.Transitions.expoOut, duration: 300 },
			{ transition: Fx.Transitions.sineIn, duration: 500 });

		/* Sub menu color settings */
		/* color default */
		var currentColor = '#e6e7e8';
		var leaveColor = '#FEFEFE';
		
		/* Sub menu all levels */
		var submenuEnter = { 'background-color': currentColor};
		var submenuLeave = { 'background-color': leaveColor};

		new YOOMorph('div#middle ul.menu a, div#middle ul.menu span.separator', submenuEnter, submenuLeave,
			{ transition: Fx.Transitions.expoOut, duration: 300 },
			{ transition: Fx.Transitions.sineIn, duration: 500 });

		/* Style switcher */
		new YOOStyleSwitcher($ES('.wrapper'), { 
			widthDefault: YtSettings.widthDefault,
			widthThinPx: YtSettings.widthThinPx,
			widthWidePx: YtSettings.widthWidePx,
			widthFluidPx: YtSettings.widthFluidPx,
			afterSwitch: YOOTools.setDivHeight,
			transition: Fx.Transitions.expoOut,
			duration: 500
		});		
		
		/* Smoothscroll */
		new SmoothScroll({ duration: 500, transition: Fx.Transitions.Expo.easeOut });
	},

	/* Include script */
	include: function(library) {
		$ES('script').each(function(s, i){
			var src  = s.getProperty('src');
			var path = '';
			if (src && src.match(/yoo_tools\.js(\?.*)?$/)) path = src.replace(/yoo_tools\.js(\?.*)?$/,'');
			if (src && src.match(/template\.js\.php(\?.*)?$/)) path = src.replace(/template\.js\.php(\?.*)?$/,'');
			if (path != '') document.write('<script language="javascript" src="' + path + library + '" type="text/javascript"></script>');
		});
	},

	/* Match height of div tags */
	setDivHeight: function() {
		YOOBase.matchDivHeight('div.topbox div.deepest', 0, 40);
		YOOBase.matchDivHeight('div.bottombox div.deepest', 0, 40);
		YOOBase.matchDivHeight('div.maintopbox div.deepest', 0, 40);
		YOOBase.matchDivHeight('div.mainbottombox div.deepest', 0, 40);
		YOOBase.matchDivHeight('div.contenttopbox div.deepest', 0, 40);
		YOOBase.matchDivHeight('div.contentbottombox div.deepest', 0, 40);
	}

};

/* Add functions on window load */
window.addEvent('domready', YOOTools.start);

/* Load IE6 fix */
if (window.ie6) {
	YOOTools.include('addons/ie6fix.js');
	YOOTools.include('yoo_ie6fix.js');
}
