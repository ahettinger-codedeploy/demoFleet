(function ($) {

  "use strict";

/* =============================================================
   Helpers
   ============================================================= */

  $.fn.exists = function() {
    return $(this).length>0;
  };

  //Initiate placeholder polyfill for browsers that don't support it.
  $('input, textarea').placeholder();

  // A better <select>

  $("select").chosen();

/* ============================================================
   Mobile navigation
   ============================================================ */

  var $menu = $('#menu'),
      $menulink = $('.menu-link');

  $menulink.on("click", function(e) {
    $menulink.toggleClass('active');
    $menu.toggleClass('active');
    e.preventDefault();
  });

  // Initiate hero slider

  $(".home-slider").owlCarousel({
    autoPlay : 10000,
    navigation : true, // Show next and prev buttons
    pagination: false,
    slideSpeed : 800,
    paginationSpeed: 800,
    singleItem:true,
    navigationText: ["&#xf053", "&#xf054"]
    // "singleItem:true" is a shortcut for:
    // items : 1,
    // itemsDesktop : false,
    // itemsDesktopSmall : false,
    // itemsTablet: false,
    // itemsMobile : false
  });

  $('.main-content iframe').wrap('<div class="embed-container">');

})(jQuery);