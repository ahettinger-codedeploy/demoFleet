/* Copyright (C) 2007 - 2010 YOOtheme GmbH, YOOtheme Proprietary Use License (http://www.yootheme.com/license) */

var WarpTemplate = {

	start: function() {

		/* Accordion menu */
		new Warp.AccordionMenu('div#middle ul.menu li.toggler', 'ul.accordion', { accordion: 'slide' });
		
		$$('div.mod-line ul.menu').each(function(menu){
			new Warp.Follower(menu, {effect: {transition: Fx.Transitions.linear, duration: 200}})
		});

		/* Smoothscroll */
		new SmoothScroll({ duration: 500, transition: Fx.Transitions.Expo.easeOut });

	},

	onload: function() {
		
		/* Dropdown menu */
		var dropdown = new Warp.Menu('menu', { mode: 'slide', dropdownSelector: 'div.dropdown', transition: Fx.Transitions.Expo.easeOut, fancy:{mode: 'move', transition: Fx.Transitions.Back.easeOut, duration: 500} });
		//dropdown.matchHeight();
		
		/* Match height of div tags */
		Warp.Base.matchHeight('div.topbox div.deepest', 20);
		Warp.Base.matchHeight('div.bottombox div.deepest', 20);
		Warp.Base.matchHeight('.content-wrapper-2, #contentleft, #contentright, #left, #right', window.getHeight()-40);
		
	}

};

/* Add functions on window load */
window.addEvent('domready', WarpTemplate.start);
window.addEvent('load', WarpTemplate.onload);