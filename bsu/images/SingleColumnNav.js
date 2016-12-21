$fn = jQuery.noConflict();
var columnHolder = '#column2';
var contentHolder = '#column1';
var billboardImage = '#billBoard div.single-column-banner img';
var billboardContainer = '#billboardContainer';

$fn(function () {
    // check to see if the billboard height syncs with the default height for the feature nav, if not, adjust
    if ($fn(billboardImage).length > 0) {
        $fn(billboardContainer).css('height', $fn(billboardImage).height() + 'px');

        /*  Account for these possible ids and classes if found 
        *   #prevBtn, #nextBtn, #slider1next, #slider1prev 
        */
        if ($fn('#prevBtn').length > 0) {
            $fn('#prevBtn').css('height', $fn(billboardImage).height() + 'px');
            $fn('#nextBtn').css('height', $fn(billboardImage).height() + 'px');
            $fn('#slider1next').css('height', $fn(billboardImage).height() + 'px');
            $fn('#slider1prev').css('height', $fn(billboardImage).height() + 'px');
        }

        $fn(columnHolder).css('marginTop', '-' + $fn(billboardImage).height() + 'px');
        $fn(contentHolder).css('marginTop', '0px');
    }
    else {
        $fn(billboardContainer).css('height', '0px');
        $fn(columnHolder).css('marginTop', '0px');
        $fn(contentHolder).css('marginTop', '0px');
    }


});