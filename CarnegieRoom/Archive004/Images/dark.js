(function ($) {

  $(document)
    .ready(function () {
	
	// -------------------------------------------------------------------------------------------------------
    // First Word
    // -------------------------------------------------------------------------------------------------------
	
	 $('h3')
      .each(function () {
      var h = $(this)
        .html();
      var index = h.indexOf(' ');
      if (index == -1) {
        index = h.length;
      }
      $(this)
        .html('<span style="color:#fff;">' + h.substring(0, index) + '</span>' + h.substring(index, h.length));
    });
	
	});

})(window.jQuery);