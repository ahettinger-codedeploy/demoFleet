// $Id: dhtml_menu.js,v 1.18.2.10 2009/01/12 10:13:30 arancaytar Exp $

/**
 * @file dhtml_menu.js
 * The Javascript code for DHTML Menu
 */
 
Drupal.customMenu = {};

/**
 * Initialize the module's JS functions
 */
Drupal.behaviors.customMenu = function() {

  /* Add jQuery effects and listeners to all menu items.
   * The ~ (sibling) selector is unidirectional and selects 
   * only the latter element, so we must use siblings() to get 
   * back to the link element.
   */
   $('#block-menu-menu-main ul:first').children().each(function() {
    var li = this;
	$('<span>').attr('class','expander').click(function(e){
      Drupal.customMenu.toggleMenu($(li));
      return false;		
	}).appendTo(li);
  });
}

/**
 * Toggles the menu's state between open and closed.
 *
 * @param li
 *   Object. The <li> element that will be expanded or collapsed.
 */
Drupal.customMenu.toggleMenu = function(li) {

  // If the menu is expanded, collapse it.
  if($(li).hasClass('active-trail')) {
    $(li).find('ul:first').animate({height: 'hide', opacity: 'hide'}, '500');
	$(li).removeClass('active-trail');
  }
  // Otherwise, expand it.
  else {
  	// hide previously active
  	$('li.active-trail ul:first').animate({height: 'hide', opacity: 'hide'}, '500');
  	$('li.active-trail').removeClass('active-trail');
	// show new active	
    $(li).find('ul:first').animate({height: 'show', opacity: 'show'}, '500'); 
	$(li).addClass('active-trail');  
  }

}


