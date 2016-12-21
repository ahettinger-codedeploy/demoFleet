$(document).ready(function () {
    if ($("#gallery-form #select-gallery").children().length <= 2) { $("#gallery-form").addClass("none"); $("#gallery-form select").addClass("none"); }

    $(".gallery-attachment").each(function () { 
        if ($("dl.image-list dt", this).length > 1) { $(".gallery-directional", this).removeClass("none"); }

        $("dl.image-list dt:first", this).addClass("active");
        $("dl.image-list dd:first", this).addClass("active");
        $("dl.image-list dt:not(.active)", this).addClass("none");
        $("dl.image-list dd:not(.active)", this).addClass("none");

        var changeButtons = function (context) {
            // Change display state of buttons
            // If not first child or last child: display next and prev
            if (!$("dl.image-list dt:first", context).hasClass("active") && !$("dl.image-list dt:last", context).hasClass("active")) {
                $(".gallery-previous a", context).removeClass("disabled");
                $(".gallery-next a", context).removeClass("disabled");
            }
            // If first child: display next, disable prev
            if ($("dl.image-list dt:first", context).is(".active")) {
                $(".gallery-next a", context).removeClass("disabled");
                $(".gallery-previous a", context).addClass("disabled");
            }
            // If last child: display prev, disable next
            if ($("dl.image-list dt:last", context).is(".active")) {
                $(".gallery-previous a", context).removeClass("disabled");
                $(".gallery-next a", context).addClass("disabled");
            }

            SI_clearFooter();
        }

        var updateImages = function (context) {
            $("dl.image-list dt.active", context).addClass("none");
            $("dl.image-list dd.active", context).addClass("none");
            $("dl.image-list dt.active", context).removeClass("active");
            $("dl.image-list dd.active", context).removeClass("active");
        }

        $(".gallery-next a", this).click(function () {
            if (!$(this).hasClass("disabled")) {
                var nextImg = $("dl.image-list dd.active");
                updateImages($(this).closest(".gallery-attachment"));
                nextImg.next().removeClass("none");
                nextImg.next().next().removeClass("none");
                nextImg.next().addClass("active");
                nextImg.next().next().addClass("active");
                changeButtons($(this).closest(".gallery-attachment"));
            }
        });
        $(".gallery-previous a", this).click(function () {
            if (!$(this).hasClass("disabled")) {
                var prevImg = $("dl dt.active");
                updateImages($(this).closest(".gallery-attachment"));
                prevImg.prev().addClass("active");
                prevImg.prev().prev().addClass("active");
                prevImg.prev().removeClass("none");
                prevImg.prev().prev().removeClass("none");
                changeButtons($(this).closest(".gallery-attachment"));
            }
        });

        /* Add alt class to gallery thumbnails - Not being used yet */
        $(".gallery-thumbnails ul li:odd", this).addClass("alt");
    
    });

});