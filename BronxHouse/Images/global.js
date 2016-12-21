
// global variables
if( 'undefined' != typeof of ) {
  var map_id = of.map_id;
  var ajax_url = of.ajax_url;
}
// jQuery JS (compatible) begin

// jQuery JS (compatible) begin

var supportsTouch = 'ontouchstart' in window || navigator.msMaxTouchPoints;
var eventType = supportsTouch ? 'mouseover' : 'click';

;(function($) {

$(document).ready( function() {

  jQuery('input[placeholder], textarea[placeholder]').placeholder();

  if(supportsTouch) {
    $('.mp-menu').addClass('touchable');
  }

  Array.max = function( array ){
    return Math.max.apply( Math, array );
  };
  var menuHeightArray = [];
  $('.mp-menu').show();
  $.each($('.mp-level'), function() {
    menuHeightArray.push($(this).outerHeight());
  });
  $('.mp-level').css('min-height', '100%');
  var maxMenuHeight = Array.max(menuHeightArray);
  $('html, body').css('min-height', maxMenuHeight + 74);
  $('.mp-menu').hide();

  $('.inner-wrapper').css({
    height: $('body').height(),
    'min-height': $('body').height()
  });

  $(window).resize(function() {
    $('.inner-wrapper').css({
      height: $('body').height(),
      'min-height': $('body').height()
    });
  });

  //menu
  $('.mp-pusher').addClass('transition');
  $('.menu-trigger').unbind('click').click(function(e) {
    e.stopPropagation();
    e.preventDefault();
    var trigger = this;
    var target = $(trigger).data('menu');
    $('#' + target).show();
    if($(trigger).hasClass('sub-menu-title')) {
      //trigger by sub page sidebar
      var menu = new mlPushMenu( document.getElementById( target ), trigger, {
        levelSpacing: 40
      } );

      var level = 0;
      var $parentLevel;
      $('#' + target).find('.mp-level').each(function() {
        var $menuLevel = $(this);
        $(this).children('ul').children('li').each(function() {
          if($(this).data('menuid') == $(trigger).data('menuid')) {
            level = $menuLevel.data('level');
            $parentLevel = $(this);
          }
        });
      });

      if($parentLevel) {
        $parentLevel.parents('.mp-level').addClass('mp-level-open');
        $parentLevel.parents('.mp-level').parents('.mp-level').addClass('mp-level-overlay');

        menu.level = level - 1;

        if($parentLevel.closest('.mp-level-overlay').get(0)) {
          var subLevel = $parentLevel.closest('.mp-level-overlay').get(0).querySelector( 'div.mp-level' );
          if( subLevel ) {
            menu._openMenu( subLevel );
          } else {
            menu._openMenu();
          }
        } else {
          menu._openMenu();
        }
      }
      
    } else if($(trigger).hasClass('sub-menu-narrow')) {
      //trigger by sub page narrow sidebar
      var menu = new mlPushMenu( document.getElementById( target ), trigger, {
        levelSpacing: 0
      } );

      var level = 0;
      var $parentLevel;
      $('#' + target).find('.mp-level').each(function() {
        var $menuLevel = $(this);
        $(this).children('ul').children('li').each(function() {
          if($(this).children('a').text().toLowerCase() == $(trigger).text().toLowerCase()) {
            $parentLevel = $(this).children('.mp-level');
            level = $parentLevel.data('level');
          }
        });
      });

      if($parentLevel) {
        $parentLevel.addClass('mp-level-open');
        $parentLevel.parents('.mp-level').addClass('mp-level-open mp-level-overlay');

        menu.level = level - 1;

        if($parentLevel.closest('.mp-level-overlay').get(0)) {
          var subLevel = $parentLevel.closest('.mp-level-overlay').get(0).querySelector( 'div.mp-level' );
          if( subLevel ) {
            menu._openMenu( subLevel );
          } else {
            menu._openMenu();
          }
        } else {
          menu._openMenu();
        }
      }

    } else {
      if(target == 'menu-all') {
        //trigger by home page narrow menu
        new mlPushMenu( document.getElementById( target ), trigger, {
          levelSpacing: 0
        });
      } else {
        //trigger by home page main menu
        new mlPushMenu( document.getElementById( target ), trigger, {
          levelSpacing: 40
        } );
      }
    }
    
  });

  //ie8 nth-child
  if($('html').hasClass('ie8')) {
    $('#programs .fc-event:even').addClass('odd');
  }

  $('.narrow-search .icon-search').click(function(e) {
    e.preventDefault();
    $('.search-box .search').slideToggle('fast');
  });

  //map todo: replace with client's data
  if($('#map').length) {
    var map = L.mapbox.map('map', map_id);
  }

  //programs filter
  $('.filter .dropdown .dropdown-toggle').click(function(e) {
    e.preventDefault();
    $(this).parents('.dropdown').toggleClass('open').find('.dropdown-menu').slideToggle();
  });

  $('.filter .dropdown-menu li a').click(function(e) {
    e.preventDefault();
    var $li = $(this).parent('li');
    if ($li.hasClass('checked')) {
      $li.removeClass('checked');
      //undo filter
    } else {
      $li.addClass('checked');
      //do filter
    }
    if($li.hasClass('all')) {//all programs
      $li.siblings('li').removeClass('checked');
    } else {
      $('.filter .dropdown-menu li.all').removeClass('checked');
    }
  });

  $('html').click(function() {
    $('.dropdown.open').removeClass('open').find('.dropdown-menu').slideUp();
  });

  $('body').on('click', '.filter', function(e) {
    e.stopPropagation();
  });

  $('.filter .filter_btn a').click(function(e) {
    e.preventDefault();
    $('.dropdown.open').removeClass('open').find('.dropdown-menu').hide();
  });

  $('.event-header .pager .prev').click(function(e) {
    e.preventDefault();
    var day = moment($('.event-header h2').text(), 'ddd, MMM D, YYYY');
    var yesterday = day.subtract('days', 1).format('ddd, MMM D, YYYY');
    getDayEvents(yesterday);
  });

  $('.event-header .pager .next').click(function(e) {
    e.preventDefault();
    var day = moment($('.event-header h2').text(), 'ddd, MMM D, YYYY');
    var tomorrow = day.add('days', 1).format('ddd, MMM D, YYYY');
    getDayEvents(tomorrow);
  });

} );

$(window).load( function() {
  $('.flexslider').flexslider({
    controlNav: false,
    directionNav: false
  })
} );
})(jQuery);

