(function($){
  Drupal.behaviors.brookwoodTheme = {
    attach: function(context, settings) {
    if ($('body').hasClass('page-game-schedule')) {
      $('.change-status').each(function(index) {
        var status = $(this);
        var statustext = status.text();
        var row = status.parents('tr');


        if (statustext == "Show as changed") {
          //alert(statustext);
          row.addClass('sports-update');
          }
        });
      }
    }
  }
})(jQuery);