$global = jQuery.noConflict();
(function () {
    try {
        $global.colorbox.settings.opacity = 0.6;
    }
    catch(Error) {
        //do nothing
    }

    $global(document).ready(function () {
        InitializeColorBox();
        InitializeCheckBanner();
    });

    // initializes colorbox functionality
    function InitializeColorBox() {
        try {
            $global("a.modalLink").colorbox({
                "scrolling": false,
                "iframe": true,
                "fastIframe": false,
                "innerWidth": 600,
                "innerHeight": 300,
                "maxWidth": "90%",
                "maxHeight": "98%",
                "scalePhotos": true,
                "onComplete": function () {
                    // Do some work to automatically calculate the height and width of the IFRAME's content
                    var iframe = $global("iframe.cboxIframe"),
                    body = iframe.contents().find("body"),
                    floatStyle = body.css("float");
                    // Float the BODY so that it assumes a minimal width
                    body.css("float", "left");
                    // Resize the colorbox
                    $global.colorbox.resize({ "innerHeight": body.height()+20 })
                    // Remove our float style on the BODY
                    body.css("float", floatStyle);
                }
            });

            $global("a.modalLinkResize").colorbox({
                "scrolling": false,
                "iframe": true,
                "fastIframe": false,
                "innerWidth": 600,
                "innerHeight": 300,
                "maxWidth": "90%",
                "maxHeight": "98%",
                "scalePhotos": true,
                "onComplete": function () {
                    // Do some work to automatically calculate the height and width of the IFRAME's content
                    var iframe = $global("iframe.cboxIframe"),
                    body = iframe.contents().find("body"),
                    floatStyle = body.css("float");
                    // Float the BODY so that it assumes a minimal width
                    body.css("float", "left");
                    // Resize the colorbox
                    $global.colorbox.resize({ "innerWidth": body.width()+20, "innerHeight": body.height()+20 })
                    // Remove our float style on the BODY
                    body.css("float", floatStyle);
                }
            });

            $global("a.modalWideContent").colorbox({
                "scrolling": false,
                "iframe": true,
                "fastIframe": false,
                "innerWidth": 960,
                "innerHeight": 680,
                "maxWidth": "90%",
                "maxHeight": "98%",
                "scalePhotos": true,
                "onComplete": function () {
                    // Do some work to automatically calculate the height and width of the IFRAME's content
                    var iframe = $global("iframe.cboxIframe"),
                    body = iframe.contents().find("body"),
                    floatStyle = body.css("float");
                    // Float the BODY so that it assumes a minimal width
                    body.css("float", "left");
                    // Resize the colorbox
                    $global.colorbox.resize({ "innerWidth": body.width() + 20, "innerHeight": body.height() + 20 })
                    // Remove our float style on the BODY
                    body.css("float", floatStyle);
                }
            });

            $global("a.interactiveCardLink").colorbox({
                "scrolling": false,
                "iframe": true,
                "fastIframe": false,
                "innerWidth": 600,
                "innerHeight": 300,
                "maxWidth": "90%",
                "maxHeight": "98%",
                "scalePhotos": true,
                "onComplete": function () {
                    // Do some work to automatically calculate the height and width of the IFRAME's content
                    var iframe = $global("iframe.cboxIframe"),
                    body = iframe.contents().find("body"),
                    floatStyle = body.css("float");
                    // Float the BODY so that it assumes a minimal width
                    body.css("float", "left");
                    // Resize the colorbox
                    $global.colorbox.resize({ "innerWidth": body.width()+20, "innerHeight": body.height()+20 })
                    // Remove our float style on the BODY
                    body.css("float", floatStyle);
                }
            });

            // use for creating colorbox images
            $global("a.modalImage").colorbox({rel:'modalImage'});
            $global("a.imageGroup1").colorbox({rel:'imageGroup1'});
            $global("a.imageGroup2").colorbox({rel:'imageGroup2'});
            $global("a.imageGroup3").colorbox({rel:'imageGroup3'});
            $global("a.imageGroup4").colorbox({rel:'imageGroup4'});
            $global("a.imageGroup5").colorbox({rel:'imageGroup5'});
        }
        catch(Error) {
            // do nothing
        }
    }

    // checks the banner for two-column banner pages that have too small of a banner and makes adjustments
    function InitializeCheckBanner() {
        if ($global("#column2.secondary").length > 0) {
            if ($global(".billboard.two-column-banner img").length > 0) {
                var pos = $global(".billboard.two-column-banner img").height();
                var width = $global(".billboard.two-column-banner img").width();

                // if the banner is too skinny then make the adjustment
                if (width < 665) {
                    $global(".billboard.two-column-banner img").css('borderRight', 'none');
                    $global(".billboard.two-column-banner").css('marginLeft', '0px');
                    $global("#column2.secondary").css('marginTop', '-' + $global(".billboard.two-column-banner img").height() + 'px');
                }
            }
        }
    }
})();