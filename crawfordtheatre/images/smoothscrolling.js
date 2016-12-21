// JavaScript Document

// Smooth Scrolling - CSS Tricks 
//http://css-tricks.com/snippets/jquery/smooth-scrolling/

jQuery(function() {
  jQuery('a[href*=#]:not([href=#]):not([class="tabLink"])').click(function() {
    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
      var target = jQuery(this.hash);
      target = target.length ? target : jQuery('[name=' + this.hash.slice(1) +']');
      if (target.length) {
        jQuery('html,body').animate({
          scrollTop: target.offset().top
        }, 400);
        return false;
      }
    }
  });
});