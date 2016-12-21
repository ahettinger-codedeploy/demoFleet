function setUpExpandoNav() {
    $(document).trigger('expandonav.setup')
    // Put a clickable icon at the end of any item that should be expandable.
    $('li.en_flag').append('<span>[+]</span>');
    $('li.en_flag2').append('<span class=\"active\">[-]</span>');

    // Allow only three visible levels at once.  i.e. Remove the expando icon <span> from the third level.
    $('li.expandonav li.expandonav li.expandonav')
        .removeClass('expandonav')
        .removeClass('en_flag')
        .removeClass('en_flag2')
        .children().filter('span').remove();

    // Click handler for expando icon.
    $('li.en_flag > span, li.en_flag2 > span').click(
        function() {
            $(document).trigger('expandonav.click', [this]);
            // If this expando item does NOT already have data filled in...
            var $associatedUls = $(this).siblings().filter('div').children();
            if ($associatedUls.length == 0) {
                $(this).addClass('loading');
                var navUrl = $(this).siblings().filter('a').attr('href').replace(/\s+$/,'');
                if (navUrl.startsWith('http')) {
                    var idx = navUrl.indexOf('/', 8);
                    navUrl = navUrl.substring(idx);
                }
                var thisId = $(this).parent().attr('id');
                var targetId = thisId + '_items';
                var ajaxUrl = '/_layouts/ccf/NavData.aspx?url=' + navUrl + '&navId=' + thisId;
                $(this).parent().append('<div style="display:none;" id="' + targetId + '"/>');
                $('#'+targetId).load(ajaxUrl, '', function() {
                    setUpExpandoNav();

                    // Inside this load() finished handler "this" is the newly added <div>
                    $(this).siblings().filter('span').removeClass('loading');

                    // The new <UL> will be display:none by default.  Slide it open.
                    $(this).css('display', 'block');
                    $(this).children().slideDown('fast', function() {
                        // Inside this handler, "this" is the animated <ul>
                        $(this).parent().siblings().filter('span').addClass('active');  // Make the <span> 'active'.
                    });

                }); // end of load() finished handler

            } else { /* Sub items already downloaded... either hide or show. */
                if ($associatedUls.css('display') == 'none') {
                    $associatedUls.parent().css('display', 'block');  // Show the DIV before showing the UL.
                    $associatedUls.slideDown('fast',  function() {
                        // Inside this handler, 'this' is the animated <ul>
                        $(this).parent().siblings().filter('span').addClass('active');
                    });
                } else {
                    $associatedUls.slideUp('fast',  function() {
                        // Inside this handler, 'this' is the animated <ul>
                        $(this).parent().css('display', 'none');  // Done hiding the UL, hide the DIV.
                        $(this).parent().siblings().filter('span').removeClass('active');
                    });
                }
            }
        } // end of span click() handler
    )
    .hover(
        function() {
            $(this).addClass('hover');
        },  // end of span hoverover handler
        function() {
            $(this).removeClass('hover');
        }   // end of span hoverout handler
    )
    .parent().removeClass('en_flag').removeClass('en_flag2');
}

$(setUpExpandoNav);
