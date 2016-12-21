(function ($) {
  Drupal.behaviors.holygrailTheme = {
  attach: function(context, settings) {
    if ($('div.messages')) {
      $('div.messages:not(.processed)')
        .addClass('processed')
        .each(function () {
          if ($('a', this).size() || $(this).is('.error') || $(this).is('.warning') || $(this).text().length > 100) {
            $(this).prepend("<div class='close-this'>x</span>");
            $('div.close-this', this).click(function() {
              $(this).parent().slideUp('fast');
            });
          }
          else {
          // Adds a 4 second pause before hiding the message.
            $(this).delay(4000).slideUp('fast');
          }
        });
      }
    }
  }
})(jQuery);;
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
})(jQuery);;
