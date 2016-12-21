$(document).ready(function() {
    $(".sf-menu > li").each(function(i) {
        i = i + 1;
        $(this).addClass("list-" + i);

        if ($(this).children('a').text().length > 17) {
            $(this).addClass('longer');
        }
    });

    $(".sf-menu").css('visibility', 'visible');
});