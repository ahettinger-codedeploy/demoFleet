$nf = jQuery.noConflict();
var newsSliderHolder = '#newsSlider';

$nf(function () {
    // ensure there is a slider first...
    if ($nf(newsSliderHolder).length > 0) {
        $nf(newsSliderHolder).easySlider({
            auto: false,
            continuous: true,
            prevText: '',
            nextText: '',
            speed: 800,
            pause: 8000,
            activeEffect: 'slide',
            prevId: 		'newsPrevBtn',
            nextId: 		'newsNextBtn'
        });
    }
});