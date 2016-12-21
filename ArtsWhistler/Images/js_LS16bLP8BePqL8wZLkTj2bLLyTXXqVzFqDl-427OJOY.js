(function ($) {

Drupal.jQueryUiFilter = Drupal.jQueryUiFilter || {}

/**
 * Custom hash change event handling
 */
var _currentHash = location.hash;
Drupal.jQueryUiFilter.hashChange = function(func) {
  // Handle URL anchor change event in js
  // http://stackoverflow.com/questions/2161906/handle-url-anchor-change-event-in-js
  if ('onhashchange' in window) {
    $(window).bind('hashchange', func);
  }
  else {
    window.setInterval(function () {
      if (location.hash != _currentHash) {
        _currentHash = location.hash;
        func();
      }
    }, 100);
  }
}


/**
 * Apply jQuery UI filter widget options as the global default options.
 */
Drupal.jQueryUiFilter.globalOptions = function(widgetType) {
  Drupal.jQueryUiFilter.cleanupOptions(jQuery.extend(
    $.ui[widgetType].prototype.options,
    Drupal.settings.jQueryUiFilter[widgetType + 'Options'],
    Drupal.jQueryUiFilter[widgetType + 'Options']
  ));
}

/**
 * Get jQuery UI filter widget options.
 */
Drupal.jQueryUiFilter.getOptions = function(widgetType, options) {
  return Drupal.jQueryUiFilter.cleanupOptions(jQuery.extend(
    {}, // Using an empty object insures that new object is created and returned.
    Drupal.settings.jQueryUiFilter[widgetType + 'Options'],
    Drupal.jQueryUiFilter[widgetType + 'Options'],
    options || {}
  ));
}

/**
 * Cleanup jQuery UI filter options by converting 'true' and 'false' strings to native JavaScript Boolean value.
 */
Drupal.jQueryUiFilter.cleanupOptions = function(options) {
  // jQuery UI options that are Booleans must be converted from integers booleans
  for (var name in options) {
    if (typeof(options[name]) == 'string' && options[name] == '') {
      delete options[name];
    }
    else if (options[name] == 'false') {
      options[name] = false;
    }
    else if (options[name] === 'true') {
      options[name] = true;
    }
    else if (name === 'position' && options[name].indexOf(',') != -1) {
      options[name] = options[name].split(/\s*,\s*/);
    }
    else if (typeof(options[name]) == 'object') {
      options[name] = Drupal.jQueryUiFilter.cleanupOptions(options[name]);
    }
  }
  return options;
}

})(jQuery);
;
(function ($) {

Drupal.jQueryUiFilter = Drupal.jQueryUiFilter || {}
Drupal.jQueryUiFilter.accordionOptions = Drupal.jQueryUiFilter.accordionOptions || {}

/**
 * Scroll to an accordion's active element.
 */
Drupal.jQueryUiFilter.accordionScrollTo = function(accordion) {
  var options = $(accordion).data('options') || {}
  if (!options['scrollTo']) {
    return;
  }

  var top = $(accordion).find('.ui-state-active').offset().top;
  if (options['scrollTo']['duration']) {
    $('html, body').animate({scrollTop: top}, options['scrollTo']['duration']);
  }
  else {
    $('html, body').scrollTop(top);
  }
}

/**
 * Accordion change event handler to bookmark active element in location.hash.
 */
Drupal.jQueryUiFilter.accordionChangeStart = function(event, ui) {
  var href = ui.newHeader.find('a').attr('href');
  if (href) {
    location.hash = href;
    return false; // Cancel event and let accordionHashChangeEvent handler activate the element.
  }
  else {
    return true;
  }
}

/**
 * On hash change activate and scroll to an accordion element.
 */
Drupal.jQueryUiFilter.accordionHashChangeEvent = function() {
  // NOTE: Accordion 'Active' property not change'ing http://bugs.jqueryui.com/ticket/4576
  $accordionHeader = $('.ui-accordion > .ui-accordion-header:has(a[href="' + location.hash + '"])')
  $accordion = $accordionHeader.parent();
  var index = $accordionHeader.prevAll('.ui-accordion-header').length;
  $accordion.accordion('activate', index);
}

/**
 * jQuery UI filter accordion behavior.
 */
Drupal.behaviors.jQueryUiFilterAccordion  = {attach: function(context) {
  if (Drupal.settings.jQueryUiFilter.disabled) {
    return;
  }

  var headerTag = Drupal.settings.jQueryUiFilter.accordionHeaderTag;

  $('div.jquery-ui-filter-accordion', context).once('jquery-ui-filter-accordion', function () {
    var options = Drupal.jQueryUiFilter.getOptions('accordion');

    // Look for jQuery UI filter header class.
    options['header'] = '.jquery-ui-filter-accordion-header';

    if ($(this).hasClass('jquery-ui-filter-accordion-collapsed')) { // Set collapsed options
      options['collapsible'] = true;
      options['active'] = false;
    }

    // Convert <h*> to div to remove tag and insure the accordion does not use the existing h3 style.
    // Sets active item based on location.hash.
    var index = 0;
    $(this).find(headerTag + '.jquery-ui-filter-accordion-header').each(function(){
      var id = this.id || $(this).text().toLowerCase().replace(/[^-a-z0-9]+/gm, '-');
      var hash = '#' + id;
      if (hash == location.hash) {
        options['active'] = index;
      }
      index++;

      $(this).replaceWith('<div class="jquery-ui-filter-header jquery-ui-filter-accordion-header"><a href="' + hash + '">' + $(this).html() + '</a></div>');
    });

    // DEBUG:
    // console.log(options);

    // Save options as data and init accordion
    $(this).data('options', options).accordion(options);

    // Scroll to active
    Drupal.jQueryUiFilter.accordionScrollTo(this);

    // Bind accordion change event to record history
    if (options['history']) {
      $(this).bind('accordionchangestart', Drupal.jQueryUiFilter.accordionChangeStart);
    }

    // Init hash change event handling once
    if (!Drupal.jQueryUiFilter.accordionInitialized) {
      Drupal.jQueryUiFilter.hashChange(Drupal.jQueryUiFilter.accordionHashChangeEvent);
    }
    Drupal.jQueryUiFilter.accordionInitialized = true;
  });

}}

})(jQuery);
;
(function ($) {

/**
 * Equal height plugin.
 *
 * From: http://www.problogdesign.com/coding/30-pro-jquery-tips-tricks-and-strategies/
 */
if (jQuery.fn.equalHeight == undefined) {
  jQuery.fn.equalHeight = function () {
    var tallest = 0;
    this.each(function() {
      tallest = ($(this).height() > tallest)? $(this).height() : tallest;
    });
    return this.height(tallest);
  }
}

Drupal.jQueryUiFilter = Drupal.jQueryUiFilter || {}
Drupal.jQueryUiFilter.tabsOptions = Drupal.jQueryUiFilter.tabsOptions || {}

/**
 * Tabs pagings
 *
 * Inspired by : http://css-tricks.com/2361-jquery-ui-tabs-with-nextprevious/
 */
Drupal.jQueryUiFilter.tabsPaging = function(selector, options) {
  options = jQuery.extend({paging: {'back': '&#171; Previous', 'next': 'Next &#187;'}}, options);

  var $tabs = $(selector);
  var numberOfTabs = $tabs.find(".ui-tabs-panel").size() - 1;

  // Add back and next buttons.
  // NOTE: Buttons are not 'themeable' since they should look like a themerolled jQuery UI button.
  $tabs.find('.ui-tabs-panel').each(function(i){
    var html = '';
    if (i != 0) {
      html += '<button type="button" class="ui-tabs-prev" rel="' + (i-1) + '" style="float:left">' + Drupal.t(options.paging.back) + '</button>';
    }
    if (i != numberOfTabs) {
      html += '<button type="button" href="#" class="ui-tabs-next" rel="' + (i+1) + '" style="float:right">' + Drupal.t(options.paging.next) + '</button>';
    }
    $(this).append('<div class="ui-tabs-paging clearfix clear-block">' +  html + '</div>');
  });

  // Init buttons
  $tabs.find('button.ui-tabs-prev, button.ui-tabs-next,').button();

  // Add event handler
  $tabs.find('.ui-tabs-next, .ui-tabs-prev').click(function() {
    $tabs.tabs('select', parseInt($(this).attr("rel")));
    return false;
  });
}

/**
 * Scroll to an accordion's active element.
 */
Drupal.jQueryUiFilter.tabsScrollTo = function(tabs) {
  var options = $(tabs).data('options') || {}
  if (!options['scrollTo']) {
    return;
  }

  var top = $(tabs).offset().top;
  if (options['scrollTo']['duration']) {
    $('html, body').animate({scrollTop: top}, options['scrollTo']['duration']);
  }
  else {
    $('html, body').scrollTop(top);
  }
}


/**
 * Tabs select event handler to bookmark selected tab in location.hash.
 */
Drupal.jQueryUiFilter.tabsSelect = function(event, ui) {
  location.hash = $(ui.tab).attr('href');
}

/**
 * On hash change select tab.
 *
 * Inspired by: http://benalman.com/code/projects/jquery-bbq/examples/fragment-jquery-ui-tabs/
 */
Drupal.jQueryUiFilter.tabsHashChangeEvent = function() {
  var $tab = $('.ui-tabs-nav > li:has(a[href="' + location.hash + '"])');
  $tabs = $tab.parent().parent();

  var selected = $tab.prevAll().length;

  if ($tabs.tabs('option', 'selected') != selected) {
    $tabs.tabs('select', selected);
  }
}

/**
 * jQuery UI filter tabs behavior
 */
Drupal.behaviors.jQueryUiFilterTabs = {attach: function(context) {
  if (Drupal.settings.jQueryUiFilter.disabled) {
    return;
  }

  var headerTag = Drupal.settings.jQueryUiFilter.tabsHeaderTag;

  // Tabs
  $('div.jquery-ui-filter-tabs', context).once('jquery-ui-filter-tabs', function () {
    var options = Drupal.jQueryUiFilter.getOptions('tabs');

    // Get <h*> text and add to tabs.
    // Sets selected tab based on location.hash.
    var scrollTo = false;
    var index = 0;
    var tabs = '<ul>';
    $(this).find(headerTag + '.jquery-ui-filter-tabs-header').each(function(){
      var id = this.id || $(this).text().toLowerCase().replace(/[^-a-z0-9]+/gm, '-');
      var hash = '#' + id;

      if (hash == location.hash) {
        scrollTo = true;
        options['selected'] = index;
      }
      index++;

      tabs += '<li><a href="' + hash + '">' + $(this).html() + '</a></li>';
      $(this).next('div.jquery-ui-filter-tabs-container').attr('id', id);
      $(this).remove();
    });
    tabs += '</ul>';
    $(this).prepend(tabs);

    // DEBUG:
    // console.log(options);

    // Save options as data and init tabs
    $(this).data('options', options).tabs(options);

    // Equal height tab
    $(this).find('.ui-tabs-nav li').equalHeight();

    // Add paging.
    if (options['paging']) {
      Drupal.jQueryUiFilter.tabsPaging(this, options);
    }

    // Bind tabs select event to record history
    if (options['history']) {
      $(this).bind('tabsselect', Drupal.jQueryUiFilter.tabsSelect);
    }

    // Scroll to selected tabs widget
    if (scrollTo) {
      Drupal.jQueryUiFilter.tabsScrollTo(this);
    }

    // Init hash change event handling once
    if (!Drupal.jQueryUiFilter.hashChangeInit) {
      Drupal.jQueryUiFilter.hashChange(Drupal.jQueryUiFilter.tabsHashChangeEvent);
    }
    Drupal.jQueryUiFilter.hashChangeInit = true;
  });
}}

})(jQuery);
;
