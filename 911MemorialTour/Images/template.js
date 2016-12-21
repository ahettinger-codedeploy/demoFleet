/* Copyright (C) 2007 - 2010 YOOtheme GmbH, YOOtheme Proprietary Use License (http://www.yootheme.com/license) */

var WarpTemplate = {
		
	start: function() {
		
		/* Accordion menu */
		new Warp.AccordionMenu('div#middle ul.menu li.toggler', 'ul.accordion', { accordion: 'slide' });

		/* Dropdown menu */
		var dropdown = new Warp.Menu('menu', { mode: 'slide', dropdownSelector: 'div.dropdown', transition: Fx.Transitions.Expo.easeOut });
		//dropdown.matchHeight();
		
		/* Smoothscroll */
		new SmoothScroll({ duration: 500, transition: Fx.Transitions.Expo.easeOut });
		
		/* Spotlight */
		Warp.Spotlight.attach(".spotlight", {fade: 100}); 
		
		WarpTemplate.matchHeight();
		
	},
	
	matchHeight: function() {
		
		/* Match height of div tags */
		Warp.Base.matchHeight('div.headerbox div.deepest', 20);
		Warp.Base.matchHeight('div.topbox div.deepest', 20);
		Warp.Base.matchHeight('#bottom div.bottombox div.deepest', 20);
		Warp.Base.matchHeight('div.maintopbox div.deepest', 20);
		Warp.Base.matchHeight('div.mainbottombox div.deepest', 20);
		Warp.Base.matchHeight('div.contenttopbox div.deepest', 20);
		Warp.Base.matchHeight('div.contentbottombox div.deepest', 20);
		Warp.Base.matchHeight('#middle, #left, #right', 20);
		Warp.Base.matchHeight('#mainmiddle, #contentleft, #contentright', 20);
		
	}
};

/* Add functions on window load */
window.addEvent('domready', WarpTemplate.start);
window.addEvent('load', WarpTemplate.matchHeight);