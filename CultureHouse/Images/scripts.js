
function clearDefault(el) {
if (el.defaultValue==el.value) el.value = ""
}

function slideSwitch() {
    var $active = $('#photoPane img.active');

    if ( $active.length == 0 ) $active = $('#photoPane img:last');

    var $next =  $active.next().length ? $active.next()
        : $('#photoPane img:first');

    $active.addClass('last-active');

    $next.css({opacity: 0.0})
        .addClass('active')
        .animate({opacity: 1.0}, 1000, function() {
            $active.removeClass('active last-active');
        });
}


function slideSwitchSchools() {
    var $active = $('#schoolPics img.active');

    if ( $active.length == 0 ) $active = $('#schoolPics img:last');

    var $next =  $active.next().length ? $active.next()
        : $('#schoolPics img:first');

    $active.addClass('last-active');

    $next.css({opacity: 0.0})
        .addClass('active')
        .animate({opacity: 1.0}, 1000, function() {
            $active.removeClass('active last-active');
        });
}

