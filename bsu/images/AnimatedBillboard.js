$ab = jQuery.noConflict();
var sliderHolder = '#slider';

$ab(function () {
    // ensure there is a slider first...
    if ($ab(sliderHolder).length > 0) {
        $ab(sliderHolder).easySlider({
            auto: true,
            continuous: true,
            prevText: '',
            nextText: '',
            speed: 800,
            pause: 4000,
            activeEffect: 'fade'
        });

        // Added by BKC 2/25/2014 - deals with slider and button sizes - works best when all images are same size
        if ($ab('#prevBtn').length > 0) {
            if ($ab(".billboard.two-column-banner img").length > 0) {
                var bbImage = '.billboard.two-column-banner img';

                $ab('#slider').css('height', $ab(bbImage).height() + 'px');
                $ab('#prevBtn').css('height', $ab(bbImage).height() + 'px');
                $ab('#nextBtn').css('height', $ab(bbImage).height() + 'px');
                $ab('#slider1next').css('height', $ab(bbImage).height() + 'px');
                $ab('#slider1prev').css('height', $ab(bbImage).height() + 'px');
            }
        }
    }
});