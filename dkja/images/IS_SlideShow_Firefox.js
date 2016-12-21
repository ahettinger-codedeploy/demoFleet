function IS_SlideShow() {
    /* debug
    this.debug = 'enter the debug value';

    this.S4 = function ()
    {
    return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
    }

    this.GUID = function ()
    {
    return (this.S4() + this.S4() + "-" + this.S4() + "-" + this.S4() + "-" + this.S4() + "-" + this.S4() + this.S4() + this.S4());
    }*/

    //properties
    this.animation = new IS_SlideShow_Animation()
    this.autoplay = new IS_SlideShow_Autoplay();
    this.caption = new IS_SlideShow_Caption();
    this.controls = new IS_SlideShow_Controls();
    this.imageOptions = new IS_SlideShow_ImageOptions();
    this.images = new Array();
    this.resizeImages = false; // true;false
    this.resizeOptions = new IS_SlideShow_ResizeOptions();
    this.slideShowApplyedCSSRules = new IS_SlideShow_ApplyedCSSRules();
    this.slideshowComputedStyle = new IS_SlideShow_ComputedStyle();
    this.slideshowCssPrefix = '';
    this.slideshowHeight = 0;
    this.slideshowID = '';
    this.slideshowWidth = 0;
    this.thumbnails = new IS_SlideShow_Thumbnails();

    //slideshow's system properties
    this.imageControls = new IS_SlideShow_ImageControls()
    this.loadingMessageControlID = '';
    this.previousImageIndex = 0;
    this.slideShowMainContainerID = '';
    this.shownImageIndex = 0;

    //Initialization methods
    //initializeSlideShow
    this.InitializeSlideShow = function () {
        var ISSlideShow = this;

        var ISSlideShowImage = this.images[0];

        var DummyImage = new Image();
        DummyImage.src = IS_SlideShow_GetDynamicImageURL(ISSlideShowImage.imageURL, this.slideshowComputedStyle.imageComputedStyle.imageContentWidth, this.slideshowComputedStyle.imageComputedStyle.imageContentHeight);
        if (DummyImage.complete) {
            ISSlideShow.PreloadFirstImage(DummyImage);
        }
        else {
            $telerik.$(DummyImage).load(function () { ISSlideShow.PreloadFirstImage(DummyImage) });
        }
    }

    // PreloadCurrentImage
    this.PreloadFirstImage = function (DummyImage) {
        var ISSlideShowImage = this.images[0];
        ISSlideShowImage.imageRealWidth = DummyImage.naturalWidth;
        ISSlideShowImage.imageRealHeight = DummyImage.naturalHeight;
        DummyImage = null;

        this.FirstImageLoaded_InitializeSlideShow();
    }

    // FirstImageLoaded_InitializeSlideShow
    this.FirstImageLoaded_InitializeSlideShow = function () {
        var ISSlideShow = this;

        this.InitializeApplyedCSSRules();

        this.InitializeComputedStyle();

        this.InitializeControls()

        var slideshowImageContainer = document.getElementById(this.imageControls.imageContainerID);
        var loadingMessageContainer = document.getElementById(this.loadingMessageControlID);

        // Resize
        if (this.resizeOptions.resize) {
            var slideshowMainContainer = document.getElementById(this.slideShowMainContainerID);
            var parentElement = slideshowMainContainer.parentNode;
           // $telerik.$(window).resize(function () { ISSlideShow.Resize() });
        }

        if (this.resizeOptions.CenterHorizontally) {
            //$telerik.$(window).resize(function () { ISSlideShow.CenterHorizontally() });
        }

        if (this.resizeOptions.CenterVertically) {
            //$telerik.$(window).resize(function () { ISSlideShow.CenterVertically() });
        }

        slideshowImageContainer.style.display = 'none';
        slideshowImageContainer.style.visibility = '';

        $telerik.$(slideshowImageContainer).fadeIn(1000, function () { ISSlideShow.Play() });

        if (this.caption.displayCaption) {
            var slideshowCaptionContainer = document.getElementById(this.caption.captionContainerID);

            slideshowCaptionContainer.style.display = 'none';
            slideshowCaptionContainer.style.visibility = '';

            $telerik.$(slideshowCaptionContainer).fadeIn(1000);
        }

        if (this.thumbnails.displayThumbnails) {
            var thumbnailsContainer = document.getElementById(this.thumbnails.thumbnailsContainerID);

            thumbnailsContainer.style.display = 'none';
            thumbnailsContainer.style.visibility = '';

            $telerik.$(thumbnailsContainer).fadeIn(1000);
        }

        if (this.controls.displayControls) {
            if (this.controls.nextImageButton) {
                var NextImageButton = document.getElementById(this.controls.nextImageButtonID);
                NextImageButton.style.display = 'none';
                NextImageButton.style.visibility = '';
                $telerik.$(NextImageButton).fadeIn(1000);
            }

            if (this.controls.previousImageButton) {
                var PreviousImageButton = document.getElementById(this.controls.previousImageButtonID);
                PreviousImageButton.style.display = 'none';
                PreviousImageButton.style.visibility = '';
                $telerik.$(PreviousImageButton).fadeIn(1000);
            }
        }

        $telerik.$(loadingMessageContainer).fadeOut(1000);
    }

    //Start: Init Applyed CSS Rules
    //Start: Init Applyed CSS Rules
    this.InitializeApplyedCSSRules = function () {
        for (CSSStyleSheetIndex = 0; CSSStyleSheetIndex <= document.styleSheets.length - 1; CSSStyleSheetIndex++) {
            var LoopCSSStyleSheet = document.styleSheets[CSSStyleSheetIndex];
            if ((LoopCSSStyleSheet != null) && (LoopCSSStyleSheet.href != null) && (LoopCSSStyleSheet.href.indexOf('IS_SlideShow') != -1)) {
                for (CSSRuleIndex = 0; CSSRuleIndex <= LoopCSSStyleSheet.cssRules.length - 1; CSSRuleIndex++) {
                    var LoopCSSRule = LoopCSSStyleSheet.cssRules[CSSRuleIndex];
                    if (LoopCSSRule.selectorText.toLowerCase() == '.' + this.slideshowCssPrefix.toLowerCase() + 'is_slideshow_maincontainer') {
                        this.slideShowApplyedCSSRules.IS_SlideShow_MainContainer = LoopCSSRule;
                    }
                    else if (LoopCSSRule.selectorText.toLowerCase() == '.' + this.slideshowCssPrefix.toLowerCase() + 'is_slideshow_imagescontainer') {
                        this.slideShowApplyedCSSRules.IS_SlideShow_ImagesContainer = LoopCSSRule;
                    }
                    else if (LoopCSSRule.selectorText.toLowerCase() == '.' + this.slideshowCssPrefix.toLowerCase() + 'is_slideshow_captioncontainer') {
                        this.slideShowApplyedCSSRules.IS_SlideShow_CaptionContainer = LoopCSSRule;
                    }
                    else if (LoopCSSRule.selectorText.toLowerCase() == '.' + this.slideshowCssPrefix.toLowerCase() + 'is_slideshow_caption') {
                        this.slideShowApplyedCSSRules.IS_SlideShow_Caption = LoopCSSRule;
                    }
                    else if (LoopCSSRule.selectorText.toLowerCase() == '.' + this.slideshowCssPrefix.toLowerCase() + 'is_slideshow_thumbnailscontainer') {
                        this.slideShowApplyedCSSRules.IS_SlideShow_ThumbnailsContainer = LoopCSSRule;
                    }
                    else if (LoopCSSRule.selectorText.toLowerCase() == '.' + this.slideshowCssPrefix.toLowerCase() + 'is_slideshow_thumbnailslist') {
                        this.slideShowApplyedCSSRules.IS_SlideShow_ThumbnailsList = LoopCSSRule;
                    }
                    else if (LoopCSSRule.selectorText.toLowerCase() == '.' + this.slideshowCssPrefix.toLowerCase() + 'is_slideshow_thumbnailslistitem') {
                        this.slideShowApplyedCSSRules.IS_SlideShow_ThumbnailsListItem = LoopCSSRule;
                    }
                    else if (LoopCSSRule.selectorText.toLowerCase() == '.' + this.slideshowCssPrefix.toLowerCase() + 'is_slideshow_thumbnailslistitem_hover') {
                        this.slideShowApplyedCSSRules.IS_SlideShow_ThumbnailsListItem_Hover = LoopCSSRule;
                    }
                    else if (LoopCSSRule.selectorText.toLowerCase() == '.' + this.slideshowCssPrefix.toLowerCase() + 'is_slideshow_controls_firstimagebutton') {
                        this.slideShowApplyedCSSRules.IS_SlideShow_Controls_FirstImageButton = LoopCSSRule;
                    }
                    else if (LoopCSSRule.selectorText.toLowerCase() == '.' + this.slideshowCssPrefix.toLowerCase() + 'is_slideshow_controls_previousimagebutton') {
                        this.slideShowApplyedCSSRules.IS_SlideShow_Controls_PreviousImageButton = LoopCSSRule;
                    }
                    else if (LoopCSSRule.selectorText.toLowerCase() == '.' + this.slideshowCssPrefix.toLowerCase() + 'is_slideshow_controls_playpauseimagebutton') {
                        this.slideShowApplyedCSSRules.IS_SlideShow_Controls_PlayPauseImageButton = LoopCSSRule;
                    }
                    else if (LoopCSSRule.selectorText.toLowerCase() == '.' + this.slideshowCssPrefix.toLowerCase() + 'is_slideshow_controls_nextimagebutton') {
                        this.slideShowApplyedCSSRules.IS_SlideShow_Controls_NextImageButton = LoopCSSRule;
                    }
                    else if (LoopCSSRule.selectorText.toLowerCase() == '.' + this.slideshowCssPrefix.toLowerCase() + 'is_slideshow_controls_lastimagebutton') {
                        this.slideShowApplyedCSSRules.IS_SlideShow_Controls_LastImageButton = LoopCSSRule;
                    }
                    else if (LoopCSSRule.selectorText.toLowerCase() == '.' + this.slideshowCssPrefix.toLowerCase() + 'slideshow_loadingmessage') {
                        this.slideShowApplyedCSSRules.SlideShow_LoadingMessage = LoopCSSRule;
                    }
                }
            }
        }
    }
    //End: Init Applyed CSS Rules

    // Start: Computed Styles Initialization
    //InitializeComputedStyle
    this.InitializeComputedStyle = function () {
        if (this.resizeOptions.resize) {
            this.InitializeResizeComputedStyle();
        }

        this.InitializeMainContainerComputedStyle();

        // initialize computed styles for the rest of the controls
        if (this.thumbnails.displayThumbnails) {
            this.InitializeThumbnailsComputedStyle();
        }

        this.InitializeImageComputedStyle();

        if (this.caption.displayCaption) {
            this.InitializeCaptionComputedStyle();
        }

        if (this.controls.displayControls != '') {
            this.InitializeControlsComputedStyle();
        }
    }

    // InitializeResizeComputedStyle
    this.InitializeResizeComputedStyle = function () {
        var slideshowMainContainer = document.getElementById(this.slideShowMainContainerID);
        var parentElement = slideshowMainContainer.parentNode;

        // reading computed styles
        var parentElementComputedStyle = getComputedStyle(parentElement);

        // width & heigh
        var parentElementWidth = IS_SlideShow_RemoveCssUnits(parentElementComputedStyle.width);
        if ((parentElementWidth != '') && (!isNaN(parentElementWidth))) {
            this.slideshowComputedStyle.resizeComputedStyle.resizeWidth = parseInt(parentElementWidth);
        }

        var parentElementHeight = IS_SlideShow_RemoveCssUnits(parentElementComputedStyle.height);
        if ((parentElementHeight != '') && (!isNaN(parentElementHeight))) {
            this.slideshowComputedStyle.resizeComputedStyle.resizeHeight = parseInt(parentElementHeight);
        }

        // margin
        var parentElementMarginLeft = IS_SlideShow_RemoveCssUnits(parentElementComputedStyle.marginLeft);
        if ((parentElementMarginLeft != '') && (!isNaN(parentElementMarginLeft))) {
            this.slideshowComputedStyle.resizeComputedStyle.resizeMarginLeft = parseInt(parentElementMarginLeft);
        }

        var parentElementMarginRight = IS_SlideShow_RemoveCssUnits(parentElementComputedStyle.marginRight);
        if ((parentElementMarginRight != '') && (!isNaN(parentElementMarginRight))) {
            this.slideshowComputedStyle.resizeComputedStyle.resizeBorderRight = parseInt(parentElementMarginRight);
        }

        var parentElementMarginTop = IS_SlideShow_RemoveCssUnits(parentElementComputedStyle.marginTop);
        if ((parentElementMarginTop != '') && (!isNaN(parentElementMarginTop))) {
            this.slideshowComputedStyle.resizeComputedStyle.resizeMarginTop = parseInt(parentElementMarginTop);
        }

        var parentElementMarginBottom = IS_SlideShow_RemoveCssUnits(parentElementComputedStyle.marginBottom);
        if ((parentElementMarginBottom != '') && (!isNaN(parentElementMarginBottom))) {
            this.slideshowComputedStyle.resizeComputedStyle.resizeMarginBottom = parseInt(parentElementMarginBottom);
        }

        // padding
        var parentElementPaddingLeft = IS_SlideShow_RemoveCssUnits(parentElementComputedStyle.paddingLeft);
        if ((parentElementPaddingLeft != '') && (!isNaN(parentElementPaddingLeft))) {
            this.slideshowComputedStyle.resizeComputedStyle.resizePaddingLeft = parseInt(parentElementPaddingLeft);
        }

        var parentElementPaddingRight = IS_SlideShow_RemoveCssUnits(parentElementComputedStyle.paddingRight);
        if ((parentElementPaddingRight != '') && (!isNaN(parentElementPaddingRight))) {
            this.slideshowComputedStyle.resizeComputedStyle.resizePaddingRight = parseInt(parentElementPaddingRight);
        }

        var parentElementPaddingTop = IS_SlideShow_RemoveCssUnits(parentElementComputedStyle.paddingTop);
        if ((parentElementPaddingTop != '') && (!isNaN(parentElementPaddingTop))) {
            this.slideshowComputedStyle.resizeComputedStyle.resizePaddingTop = parseInt(parentElementPaddingTop);
        }

        var parentElementPaddingBottom = IS_SlideShow_RemoveCssUnits(parentElementComputedStyle.paddingBottom);
        if ((parentElementPaddingBottom != '') && (!isNaN(parentElementPaddingBottom))) {
            this.slideshowComputedStyle.resizeComputedStyle.resizePaddingBottom = parseInt(parentElementPaddingBottom);
        }

        // border
        var parentElementBorderLeft = IS_SlideShow_RemoveCssUnits(parentElementComputedStyle.borderLeftWidth);
        if ((parentElementBorderLeft != '') && (!isNaN(parentElementBorderLeft))) {
            this.slideshowComputedStyle.resizeComputedStyle.resizeBorderLeft = parseInt(parentElementBorderLeft);
        }

        var parentElementBorderRight = IS_SlideShow_RemoveCssUnits(parentElementComputedStyle.borderRightWidth);
        if ((parentElementBorderRight != '') && (!isNaN(parentElementBorderRight))) {
            this.slideshowComputedStyle.resizeComputedStyle.resizeBorderRight = parseInt(parentElementBorderRight);
        }

        var parentElementBorderTop = IS_SlideShow_RemoveCssUnits(parentElementComputedStyle.borderTopWidth);
        if ((parentElementBorderTop != '') && (!isNaN(parentElementBorderTop))) {
            this.slideshowComputedStyle.resizeComputedStyle.resizeBorderTop = parseInt(parentElementBorderTop);
        }

        var parentElementBorderBottom = IS_SlideShow_RemoveCssUnits(parentElementComputedStyle.borderBottomWidth);
        if ((parentElementBorderBottom != '') && (!isNaN(parentElementBorderBottom))) {
            this.slideshowComputedStyle.resizeComputedStyle.resizeBorderBottom = parseInt(parentElementBorderBottom);
        }
    }

    // InitializeMainContainerComputedStyle
    this.InitializeMainContainerComputedStyle = function () {
        var slideshowMainContainer = document.getElementById(this.slideShowMainContainerID);

        this.slideshowComputedStyle.slideshowWidth = this.slideshowWidth;
        this.slideshowComputedStyle.slideshowHeight = this.slideshowHeight;

        // reading applyed css rules
        if (this.slideShowApplyedCSSRules.IS_SlideShow_MainContainer != null) {
            // width & height
            var MainContainerWidth = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_MainContainer.style.width);
            if ((MainContainerWidth != '') && (!isNaN(MainContainerWidth))) {
                this.slideshowComputedStyle.slideshowWidth = parseInt(MainContainerWidth);
            }

            var MainContainerHeight = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_MainContainer.style.height);
            if ((MainContainerHeight != '') && (!isNaN(MainContainerHeight))) {
                this.slideshowComputedStyle.slideshowHeight = parseInt(MainContainerHeight);
            }
        }

        this.slideshowComputedStyle.slideshowOriginalWidth = this.slideshowComputedStyle.slideshowWidth;
        this.slideshowComputedStyle.slideshowOriginalHeight = this.slideshowComputedStyle.slideshowHeight;

        // reading computed styles
        var slideShowMainContainerComputedStyle = getComputedStyle(slideshowMainContainer);

        // margin
        var MainContainerMarginLeft = IS_SlideShow_RemoveCssUnits(slideShowMainContainerComputedStyle.marginLeft);
        if ((MainContainerMarginLeft != '') && (!isNaN(MainContainerMarginLeft))) {
            this.slideshowComputedStyle.slideshowMarginLeft = parseInt(MainContainerMarginLeft);
        }

        var MainContainerMarginRight = IS_SlideShow_RemoveCssUnits(slideShowMainContainerComputedStyle.marginRight);
        if ((MainContainerMarginRight != '') && (!isNaN(MainContainerMarginRight))) {
            this.slideshowComputedStyle.slideshowMarginRight = parseInt(MainContainerMarginRight);
        }

        var MainContainerMarginTop = IS_SlideShow_RemoveCssUnits(slideShowMainContainerComputedStyle.marginTop);
        if ((MainContainerMarginTop != '') && (!isNaN(MainContainerMarginTop))) {
            this.slideshowComputedStyle.slideshowMarginTop = parseInt(MainContainerMarginTop);
        }

        var MainContainerMarginBottom = IS_SlideShow_RemoveCssUnits(slideShowMainContainerComputedStyle.marginBottom);
        if ((MainContainerMarginBottom != '') && (!isNaN(MainContainerMarginBottom))) {
            this.slideshowComputedStyle.slideshowMarginBottom = parseInt(MainContainerMarginBottom);
        }

        // padding
        var MainContainerPaddingLeft = IS_SlideShow_RemoveCssUnits(slideShowMainContainerComputedStyle.paddingLeft);
        if ((MainContainerPaddingLeft != '') && (!isNaN(MainContainerPaddingLeft))) {
            this.slideshowComputedStyle.slideshowPaddingLeft = parseInt(MainContainerPaddingLeft);
        }

        var MainContainerPaddingRight = IS_SlideShow_RemoveCssUnits(slideShowMainContainerComputedStyle.paddingRight);
        if ((MainContainerPaddingRight != '') && (!isNaN(MainContainerPaddingRight))) {
            this.slideshowComputedStyle.slideshowPaddingRight = parseInt(MainContainerPaddingRight);
        }

        var MainContainerPaddingTop = IS_SlideShow_RemoveCssUnits(slideShowMainContainerComputedStyle.paddingTop);
        if ((MainContainerPaddingTop != '') && (!isNaN(MainContainerPaddingTop))) {
            this.slideshowComputedStyle.slideshowPaddingTop = parseInt(MainContainerPaddingTop);
        }

        var MainContainerPaddingBottom = IS_SlideShow_RemoveCssUnits(slideShowMainContainerComputedStyle.paddingBottom);
        if ((MainContainerPaddingBottom != '') && (!isNaN(MainContainerPaddingBottom))) {
            this.slideshowComputedStyle.slideshowPaddingBottom = parseInt(MainContainerPaddingBottom);
        }

        // border
        var MainContainerBorderLeft = IS_SlideShow_RemoveCssUnits(slideShowMainContainerComputedStyle.borderLeftWidth);
        if ((MainContainerBorderLeft != '') && (!isNaN(MainContainerBorderLeft))) {
            this.slideshowComputedStyle.slideshowBorderLeft = parseInt(MainContainerBorderLeft);
        }

        var MainContainerBorderRight = IS_SlideShow_RemoveCssUnits(slideShowMainContainerComputedStyle.borderRightWidth);
        if ((MainContainerBorderRight != '') && (!isNaN(MainContainerBorderRight))) {
            this.slideshowComputedStyle.slideshowBorderRight = parseInt(MainContainerBorderRight);
        }

        var MainContainerBorderTop = IS_SlideShow_RemoveCssUnits(slideShowMainContainerComputedStyle.borderTopWidth);
        if ((MainContainerBorderTop != '') && (!isNaN(MainContainerBorderTop))) {
            this.slideshowComputedStyle.slideshowBorderTop = parseInt(MainContainerBorderTop);
        }

        var MainContainerBorderBottom = IS_SlideShow_RemoveCssUnits(slideShowMainContainerComputedStyle.borderBottomWidth);
        if ((MainContainerBorderBottom != '') && (!isNaN(MainContainerBorderBottom))) {
            this.slideshowComputedStyle.slideshowBorderBottom = parseInt(MainContainerBorderBottom);
        }

        // computing dimensions
        if (this.resizeOptions.resize) {
            this.slideshowComputedStyle.slideshowWidth = this.slideshowComputedStyle.resizeComputedStyle.resizeWidth
                                                         - this.slideshowComputedStyle.slideshowMarginLeft
                                                         - this.slideshowComputedStyle.slideshowMarginRight
                                                         - this.slideshowComputedStyle.slideshowBorderLeft
                                                         - this.slideshowComputedStyle.slideshowBorderRight
                                                         - this.slideshowComputedStyle.slideshowPaddingLeft
                                                         - this.slideshowComputedStyle.slideshowPaddingRight;

            this.slideshowComputedStyle.slideshowHeight = this.slideshowComputedStyle.resizeComputedStyle.resizeHeight
                                                          - this.slideshowComputedStyle.slideshowMarginTop
                                                          - this.slideshowComputedStyle.slideshowMarginBottom
                                                          - this.slideshowComputedStyle.slideshowBorderTop
                                                          - this.slideshowComputedStyle.slideshowBorderBottom
                                                          - this.slideshowComputedStyle.slideshowPaddingTop
                                                          - this.slideshowComputedStyle.slideshowPaddingBottom;
        }
    }

    //InitializeThumbnailsComputedStyle
    this.InitializeThumbnailsComputedStyle = function () {
        var thumbnailsContainer = document.getElementById(this.thumbnails.thumbnailsContainerID);

        // reading assigned styles
        if (this.slideShowApplyedCSSRules.IS_SlideShow_ThumbnailsContainer != null) {
            // width & height
            var ThumbnailsContainerWidth = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_ThumbnailsContainer.style.width);
            if ((ThumbnailsContainerWidth != '') && (!isNaN(ThumbnailsContainerWidth))) {
                this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsWidth = parseInt(ThumbnailsContainerWidth);
            }

            var ThumbnailsContainerHeight = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_ThumbnailsContainer.style.height);
            if ((ThumbnailsContainerHeight != '') && (!isNaN(ThumbnailsContainerHeight))) {
                this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsHeight = parseInt(ThumbnailsContainerHeight);
            }

            // top, left, right, and bottom
            var ThumbnailsContainerTop = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_ThumbnailsContainer.style.top);
            if ((ThumbnailsContainerTop != '') && (!isNaN(ThumbnailsContainerTop))) {
                this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsTop = parseInt(ThumbnailsContainerTop);
            }

            var ThumbnailsContainerLeft = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_ThumbnailsContainer.style.left);
            if ((ThumbnailsContainerLeft != '') && (!isNaN(ThumbnailsContainerLeft))) {
                this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsLeft = parseInt(ThumbnailsContainerLeft);
            }

            var ThumbnailsContainerRight = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_ThumbnailsContainer.style.right);
            if ((ThumbnailsContainerRight != '') && (!isNaN(ThumbnailsContainerRight))) {
                this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsRight = parseInt(ThumbnailsContainerRight);
            }

            var ThumbnailsContainerBottom = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_ThumbnailsContainer.style.bottom);
            if ((ThumbnailsContainerBottom != '') && (!isNaN(ThumbnailsContainerBottom))) {
                this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsBottom = parseInt(ThumbnailsContainerBottom);
            }
        }

        // reading computed styles
        var thumbnailsContainerComputedStyle = getComputedStyle(thumbnailsContainer);

        // margin
        var ThumbnailsContainerMarginLeft = IS_SlideShow_RemoveCssUnits(thumbnailsContainerComputedStyle.marginLeft);
        if ((ThumbnailsContainerMarginLeft != '') && (!isNaN(ThumbnailsContainerMarginLeft))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsMarginLeft = parseInt(ThumbnailsContainerMarginLeft);
        }

        var ThumbnailsContainerMarginRight = IS_SlideShow_RemoveCssUnits(thumbnailsContainerComputedStyle.marginRight);
        if ((ThumbnailsContainerMarginRight != '') && (!isNaN(ThumbnailsContainerMarginRight))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsMarginRight = parseInt(ThumbnailsContainerMarginRight);
        }

        var ThumbnailsContainerMarginTop = IS_SlideShow_RemoveCssUnits(thumbnailsContainerComputedStyle.marginTop);
        if ((ThumbnailsContainerMarginTop != '') && (!isNaN(ThumbnailsContainerMarginTop))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsMarginTop = parseInt(ThumbnailsContainerMarginTop);
        }

        var ThumbnailsContainerMarginBottom = IS_SlideShow_RemoveCssUnits(thumbnailsContainerComputedStyle.marginBottom);
        if ((ThumbnailsContainerMarginBottom != '') && (!isNaN(ThumbnailsContainerMarginBottom))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsMarginBottom = parseInt(ThumbnailsContainerMarginBottom);
        }

        // padding
        var ThumbnailsContainerPaddingLeft = IS_SlideShow_RemoveCssUnits(thumbnailsContainerComputedStyle.paddingLeft);
        if ((ThumbnailsContainerPaddingLeft != '') && (!isNaN(ThumbnailsContainerPaddingLeft))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsPaddingLeft = parseInt(ThumbnailsContainerPaddingLeft);
        }

        var ThumbnailsContainerPaddingRight = IS_SlideShow_RemoveCssUnits(thumbnailsContainerComputedStyle.paddingRight);
        if ((ThumbnailsContainerPaddingRight != '') && (!isNaN(ThumbnailsContainerPaddingRight))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsPaddingRight = parseInt(ThumbnailsContainerPaddingRight);
        }

        var ThumbnailsContainerPaddingTop = IS_SlideShow_RemoveCssUnits(thumbnailsContainerComputedStyle.paddingTop);
        if ((ThumbnailsContainerPaddingTop != '') && (!isNaN(ThumbnailsContainerPaddingTop))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsPaddingTop = parseInt(ThumbnailsContainerPaddingTop);
        }

        var ThumbnailsContainerPaddingBottom = IS_SlideShow_RemoveCssUnits(thumbnailsContainerComputedStyle.paddingBottom);
        if ((ThumbnailsContainerPaddingBottom != '') && (!isNaN(ThumbnailsContainerPaddingBottom))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsPaddingBottom = parseInt(ThumbnailsContainerPaddingBottom);
        }

        // border
        var ThumbnailsContainerBorderLeft = IS_SlideShow_RemoveCssUnits(thumbnailsContainerComputedStyle.borderLeftWidth);
        if ((ThumbnailsContainerBorderLeft != '') && (!isNaN(ThumbnailsContainerBorderLeft))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsBorderLeft = parseInt(ThumbnailsContainerBorderLeft);
        }

        var ThumbnailsContainerBorderRight = IS_SlideShow_RemoveCssUnits(thumbnailsContainerComputedStyle.borderRightWidth);
        if ((ThumbnailsContainerBorderRight != '') && (!isNaN(ThumbnailsContainerBorderRight))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsBorderRight = parseInt(ThumbnailsContainerBorderRight);
        }

        var ThumbnailsContainerBorderTop = IS_SlideShow_RemoveCssUnits(thumbnailsContainerComputedStyle.borderTopWidth);
        if ((ThumbnailsContainerBorderTop != '') && (!isNaN(ThumbnailsContainerBorderTop))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsBorderTop = parseInt(ThumbnailsContainerBorderTop);
        }

        var ThumbnailsContainerBorderBottom = IS_SlideShow_RemoveCssUnits(thumbnailsContainerComputedStyle.borderBottomWidth);
        if ((ThumbnailsContainerBorderBottom != '') && (!isNaN(ThumbnailsContainerBorderBottom))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsBorderBottom = parseInt(ThumbnailsContainerBorderBottom);
        }

        this.InitializeThumbnailsListControlComputedStyle();

        // computing dimensions
        if (this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsHeight <= 0) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsHeight = this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlHeight;
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsHeight += this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlMarginTop
                                                                                    + this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlMarginBottom
                                                                                    + this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlBorderTop
                                                                                    + this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlBorderBottom
                                                                                    + this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlPaddingTop
                                                                                    + this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlPaddingBottom;
        }

        if (this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsWidth <= 0) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsWidth = this.slideshowComputedStyle.slideshowWidth;
        }
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsWidth -= (this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsBorderLeft
                                                                               + this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsBorderRight
                                                                               + this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsPaddingLeft
                                                                               + this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsPaddingRight);

        if ((this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsTop == null) && (this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsBottom == null)) {
            if (this.thumbnails.thumbnailsPosition == 'bottom') {
                this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsTop =
                    (this.slideshowComputedStyle.slideshowHeight + this.slideshowComputedStyle.slideshowPaddingTop) -
                    (this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsHeight
                    + this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsMarginTop
                    + this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsMarginBottom
                    + this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsBorderTop
                    + this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsBorderBottom
                    + this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsPaddingTop
                    + this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsPaddingBottom)
                    + 1;
            }
            else {
                this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsTop = this.slideshowComputedStyle.slideshowPaddingTop;
            }
        }
        else if (this.resizeOptions.resize) {
            var SlideShowOriginalHeight = 0;

            var MainContainerHeight = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_MainContainer.style.height);
            if ((MainContainerHeight != '') && (!isNaN(MainContainerHeight))) {
                SlideShowOriginalHeight = parseInt(MainContainerHeight);
            }

            if ((SlideShowOriginalHeight != 0)) {
                this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsTop =
                    this.slideshowComputedStyle.slideshowHeight - (SlideShowOriginalHeight - this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsTop);
            }
        }

        if ((this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsLeft == null) && (this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsRight == null)) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsLeft = this.slideshowComputedStyle.slideshowPaddingLeft;
        }
        else if (this.resizeOptions.resize) {
            var SlideShowOriginalWidth = 0;

            var MainContainerWidth = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_MainContainer.style.width);
            if ((MainContainerWidth != '') && (!isNaN(MainContainerWidth))) {
                SlideShowOriginalWidth = parseInt(MainContainerWidth);
            }

            var ThumbnailsOriginalWidth = 0;

            var ThumbnailsContainerWidth = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_ThumbnailsContainer.style.width);
            if ((ThumbnailsContainerWidth != '') && (!isNaN(ThumbnailsContainerWidth))) {
                ThumbnailsOriginalWidth = parseInt(ThumbnailsContainerWidth);
            }

            if ((SlideShowOriginalWidth != 0) && (ThumbnailsOriginalWidth != 0)) {
                var OriginalSpacing = SlideShowOriginalWidth - ThumbnailsOriginalWidth;
                var LeftSpacing = this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsLeft;
                var LeftRation = LeftSpacing / OriginalSpacing;

                var CurrentSpacing = this.slideshowComputedStyle.slideshowWidth - this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsWidth;
                var CurrentLeftSpacing = parseInt(LeftRation * CurrentSpacing);

                this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsLeft = CurrentLeftSpacing;
            }
        }
    }

    //InitializeThumbnailsListControlComputedStyle
    this.InitializeThumbnailsListControlComputedStyle = function () {
        var thumbnailsListControl = document.getElementById(this.thumbnails.thumbnailsListControlID);

        // reading applyed css rules
        // height, width
        if (this.slideShowApplyedCSSRules.IS_SlideShow_ThumbnailsList != null) {
            // width & height
            var ListControlWidth = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_ThumbnailsList.style.width);
            if ((ListControlWidth != '') && (!isNaN(ListControlWidth))) {
                this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlWidth = parseInt(ListControlWidth);
            }

            var ListControlHeight = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_ThumbnailsList.style.height);
            if ((ListControlHeight != '') && (!isNaN(ListControlHeight))) {
                this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlHeight = parseInt(ListControlHeight);
            }

            // top & left
            var ListControlTop = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_ThumbnailsList.style.top);
            if ((ListControlTop != '') && (!isNaN(ListControlTop))) {
                this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlTop = parseInt(ListControlTop);
            }

            var ListControlLeft = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_ThumbnailsList.style.left);
            if ((ListControlLeft != '') && (!isNaN(ListControlLeft))) {
                this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlLeft = parseInt(ListControlLeft);
            }
        }

        // reading computed styles
        // margin
        var listControlComputedStyle = getComputedStyle(thumbnailsListControl);

        var listControlMarginLeft = IS_SlideShow_RemoveCssUnits(listControlComputedStyle.marginLeft);
        if ((listControlMarginLeft != '') && (!isNaN(listControlMarginLeft))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlMarginLeft = parseInt(listControlMarginLeft);
        }

        var listControlMarginRight = IS_SlideShow_RemoveCssUnits(listControlComputedStyle.marginRight);
        if ((listControlMarginRight != '') && (!isNaN(listControlMarginRight))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlMarginRight = parseInt(listControlMarginRight);
        }

        var listControlMarginTop = IS_SlideShow_RemoveCssUnits(listControlComputedStyle.marginTop);
        if ((listControlMarginTop != '') && (!isNaN(listControlMarginTop))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlMarginTop = parseInt(listControlMarginTop);
        }

        var listControlMarginBottom = IS_SlideShow_RemoveCssUnits(listControlComputedStyle.marginBottom);
        if ((listControlMarginBottom != '') && (!isNaN(listControlMarginBottom))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlMarginBottom = parseInt(listControlMarginBottom);
        }

        // padding
        var listControlPaddingLeft = IS_SlideShow_RemoveCssUnits(listControlComputedStyle.paddingLeft);
        if ((listControlMarginLeft != '') && (!isNaN(listControlMarginLeft))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlPaddingLeft = parseInt(listControlMarginLeft);
        }

        var listControlPaddingRight = IS_SlideShow_RemoveCssUnits(listControlComputedStyle.paddingRight);
        if ((listControlPaddingRight != '') && (!isNaN(listControlPaddingRight))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlPaddingRight = parseInt(listControlPaddingRight);
        }

        var listControlPaddingTop = IS_SlideShow_RemoveCssUnits(listControlComputedStyle.paddingTop);
        if ((listControlPaddingTop != '') && (!isNaN(listControlPaddingTop))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlPaddingTop = parseInt(listControlPaddingTop);
        }

        var listControlPaddingBottom = IS_SlideShow_RemoveCssUnits(listControlComputedStyle.paddingBottom);
        if ((listControlPaddingBottom != '') && (!isNaN(listControlPaddingBottom))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlPaddingBottom = parseInt(listControlPaddingBottom);
        }

        // border
        var listControlBorderLeft = IS_SlideShow_RemoveCssUnits(listControlComputedStyle.borderLeftWidth);
        if ((listControlBorderLeft != '') && (!isNaN(listControlBorderLeft))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlBorderLeft = parseInt(listControlBorderLeft);
        }

        var listControlBorderRight = IS_SlideShow_RemoveCssUnits(listControlComputedStyle.borderRightWidth);
        if ((listControlBorderRight != '') && (!isNaN(listControlBorderRight))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlBorderRight = parseInt(listControlBorderRight);
        }

        var listControlBorderTop = IS_SlideShow_RemoveCssUnits(listControlComputedStyle.borderTopWidth);
        if ((listControlBorderTop != '') && (!isNaN(listControlBorderTop))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlBorderTop = parseInt(listControlBorderTop);
        }

        var listControlBorderBottom = IS_SlideShow_RemoveCssUnits(listControlComputedStyle.borderBottomWidth);
        if ((listControlBorderBottom != '') && (!isNaN(listControlBorderBottom))) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlBorderBottom = parseInt(listControlBorderBottom);
        }

        // computing dimensions
        // width & height
        var listControlWidth = 0;
        var listControlHeight = 0
        for (childIndex = 0; childIndex <= thumbnailsListControl.children.length - 1; childIndex++) {
            var LIchild = thumbnailsListControl.children[childIndex];
            listControlWidth += LIchild.offsetWidth;

            var LIchildComputedStyle = getComputedStyle(LIchild);
            var LIchildMarginLeft = IS_SlideShow_RemoveCssUnits(LIchildComputedStyle.marginLeft);
            if ((LIchildMarginLeft != '') && (!isNaN(LIchildMarginLeft))) { listControlWidth += parseInt(LIchildMarginLeft); }
            var LIchildMarginRight = IS_SlideShow_RemoveCssUnits(LIchildComputedStyle.marginRight);
            if ((LIchildMarginRight != '') && (!isNaN(LIchildMarginRight))) { listControlWidth += parseInt(LIchildMarginRight); }

            if (LIchild.offsetHeight > listControlHeight) { listControlHeight = LIchild.offsetHeight }
        }

        if (this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlWidth <= 0) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlWidth = listControlWidth;
        }

        if (this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlHeight <= 0) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlHeight = listControlHeight;
        }

        // top & left
        if (this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlTop == null) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlTop = this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsBorderTop
                                                                                                       + this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsPaddingTop;
        }

        if (this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlLeft == null) {
            this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlLeft = this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsBorderLeft
                                                                                                        + this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsPaddingLeft;
        }
    }

    //InitializeImageComputedStyle
    this.InitializeImageComputedStyle = function () {
        var imageContainer = document.getElementById(this.imageControls.imageContainerID);

        // reading applyed css rules
        if (this.slideShowApplyedCSSRules.IS_SlideShow_ImagesContainer) {
            // width & height
            var imageContainerWidth = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_ImagesContainer.style.width);
            if ((imageContainerWidth != '') && (!isNaN(imageContainerWidth))) {
                this.slideshowComputedStyle.imageComputedStyle.imageContentWidth = parseInt(imageContainerWidth);
            }

            var imageContainerHeight = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_ImagesContainer.style.height);
            if ((imageContainerHeight != '') && (!isNaN(imageContainerHeight))) {
                this.slideshowComputedStyle.imageComputedStyle.imageContentHeight = parseInt(imageContainerHeight);
            }

            // top
            var imageContainerTop = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_ImagesContainer.style.top);
            if ((imageContainerTop != '') && (!isNaN(imageContainerTop))) {
                this.slideshowComputedStyle.imageComputedStyle.imageTop = parseInt(imageContainerTop);
            }

            var imageContainerLeft = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_ImagesContainer.style.left);
            if ((imageContainerLeft != '') && (!isNaN(imageContainerLeft))) {
                this.slideshowComputedStyle.imageComputedStyle.imageTop = parseInt(imageContainerLeft);
            }
        }

        // computed styles
        if (this.resizeOptions.resize) {
            if (this.resizeOptions.Resize_LockDimensions) {
                // width
                if ((this.resizeOptions.Resize_MinWidth > 0) && (this.slideshowComputedStyle.slideshowWidth < this.resizeOptions.Resize_MinWidth)) {
                    this.slideshowComputedStyle.imageComputedStyle.imageContentWidth = this.resizeOptions.Resize_MinWidth;
                }
                else { this.slideshowComputedStyle.imageComputedStyle.imageContentWidth = this.slideshowComputedStyle.slideshowWidth; }

                // height
                if (this.slideshowComputedStyle.imageComputedStyle.imageContentWidth != this.slideshowComputedStyle.slideshowOriginalWidth) {
                    var DimensionsRation = (this.slideshowComputedStyle.imageComputedStyle.imageContentWidth / this.slideshowComputedStyle.slideshowOriginalWidth);
                    this.slideshowComputedStyle.imageComputedStyle.imageContentHeight = parseInt(this.slideshowComputedStyle.slideshowOriginalHeight * DimensionsRation);
                }
                else { this.slideshowComputedStyle.imageComputedStyle.imageContentHeight = this.slideshowComputedStyle.slideshowOriginalHeight; }

                if (this.slideshowComputedStyle.imageComputedStyle.imageContentHeight < this.slideshowComputedStyle.slideshowHeight) {
                    // height
                    if ((this.resizeOptions.Resize_MinHeight > 0) && (this.slideshowComputedStyle.slideshowHeight < this.resizeOptions.Resize_MinHeight)) {
                        this.slideshowComputedStyle.imageComputedStyle.imageContentHeight = this.resizeOptions.Resize_MinHeight;
                    }
                    else { this.slideshowComputedStyle.imageComputedStyle.imageContentHeight = this.slideshowComputedStyle.slideshowHeight; }

                    // width
                    if (this.slideshowComputedStyle.imageComputedStyle.imageContentHeight != this.slideshowComputedStyle.slideshowOriginalHeight) {
                        var DimensionsRation = (this.slideshowComputedStyle.imageComputedStyle.imageContentHeight / this.slideshowComputedStyle.slideshowOriginalHeight);
                        this.slideshowComputedStyle.imageComputedStyle.imageContentWidth = parseInt(this.slideshowComputedStyle.slideshowOriginalWidth * DimensionsRation);
                    }
                    else { this.slideshowComputedStyle.imageComputedStyle.imageContentWidth = this.slideshowComputedStyle.slideshowOriginalWidth; }
                }
            }
            else {
                // width
                if ((this.resizeOptions.Resize_MinWidth > 0) && (this.slideshowComputedStyle.slideshowWidth < this.resizeOptions.Resize_MinWidth)) {
                    this.slideshowComputedStyle.imageComputedStyle.imageContentWidth = this.resizeOptions.Resize_MinWidth;
                }
                else { this.slideshowComputedStyle.imageComputedStyle.imageContentWidth = this.slideshowComputedStyle.slideshowWidth; }

                // height
                if ((this.resizeOptions.Resize_MinHeight > 0) && (this.slideshowComputedStyle.slideshowHeight < this.resizeOptions.Resize_MinHeight)) {
                    this.slideshowComputedStyle.imageComputedStyle.imageContentHeight = this.resizeOptions.Resize_MinHeight;
                }
                else { this.slideshowComputedStyle.imageComputedStyle.imageContentHeight = this.slideshowComputedStyle.slideshowHeight; }
            }
        }

        // width
        if (this.slideshowComputedStyle.imageComputedStyle.imageContentWidth <= 0) {
            this.slideshowComputedStyle.imageComputedStyle.imageContentWidth = this.slideshowComputedStyle.slideshowWidth;
            if (this.slideshowComputedStyle.imageComputedStyle.imageLeft <= 0) {
                this.slideshowComputedStyle.imageComputedStyle.imageLeft =
                    this.slideshowComputedStyle.slideshowBorderLeft +
                    this.slideshowComputedStyle.slideshowPaddingLeft;
            }
        }

        // height
        if (this.slideshowComputedStyle.imageComputedStyle.imageContentHeight <= 0) {
            this.slideshowComputedStyle.imageComputedStyle.imageContentHeight = this.slideshowComputedStyle.slideshowHeight;
            if (this.slideshowComputedStyle.imageComputedStyle.imageTop <= 0) {
                this.slideshowComputedStyle.imageComputedStyle.imageTop =
                    this.slideshowComputedStyle.slideshowBorderTop +
                    this.slideshowComputedStyle.slideshowPaddingTop;
            }
        }
    }

    //InitializeCaptionComputedStyle
    this.InitializeCaptionComputedStyle = function () {
        var captionContainer = document.getElementById(this.caption.captionContainerID);

        // reading applyed css rules
        if (this.slideShowApplyedCSSRules.IS_SlideShow_CaptionContainer != null) {
            // width & height
            var captionContainerWidth = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_CaptionContainer.style.width);
            if ((captionContainerWidth != '') && (!isNaN(captionContainerWidth))) {
                this.slideshowComputedStyle.captionComputedStyle.captionWidth = parseInt(captionContainerWidth);
            }

            var captionContainerHeight = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_CaptionContainer.style.height);
            if ((captionContainerHeight != '') && (!isNaN(captionContainerHeight))) {

                try {
                    CustomVerticalCaptionHandler(this);
                }
                catch (ex) {
                    //alert(ex);                
                    this.slideshowComputedStyle.captionComputedStyle.captionHeight = parseInt(captionContainerHeight);
                }
            }

            // top & left
            var captionContainerTop = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_CaptionContainer.style.top);
            if ((captionContainerTop != '') && (!isNaN(captionContainerTop))) {
                this.slideshowComputedStyle.captionComputedStyle.captionTop = parseInt(captionContainerTop);
            }

            var captionContainerLeft = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_CaptionContainer.style.left);
            if ((captionContainerLeft != '') && (!isNaN(captionContainerLeft))) {
                this.slideshowComputedStyle.captionComputedStyle.captionLeft = parseInt(captionContainerLeft);
            }
        }

        // reading computed styles
        var captionContainerComputedStyle = getComputedStyle(captionContainer);

        // margin
        var CaptionMarginLeft = IS_SlideShow_RemoveCssUnits(captionContainerComputedStyle.marginLeft);
        if ((CaptionMarginLeft != '') && (!isNaN(CaptionMarginLeft))) {
            this.slideshowComputedStyle.captionComputedStyle.captionMarginLeft = parseInt(CaptionMarginLeft);
        }

        var CaptionMarginRight = IS_SlideShow_RemoveCssUnits(captionContainerComputedStyle.marginRight);
        if ((CaptionMarginRight != '') && (!isNaN(CaptionMarginRight))) {
            this.slideshowComputedStyle.captionComputedStyle.captionMarginRight = parseInt(CaptionMarginRight);
        }

        var CaptionMarginTop = IS_SlideShow_RemoveCssUnits(captionContainerComputedStyle.marginTop);
        if ((CaptionMarginTop != '') && (!isNaN(CaptionMarginTop))) {
            this.slideshowComputedStyle.captionComputedStyle.captionMarginTop = parseInt(CaptionMarginTop);
        }

        var CaptionMarginBottom = IS_SlideShow_RemoveCssUnits(captionContainerComputedStyle.marginBottom);
        if ((CaptionMarginBottom != '') && (!isNaN(CaptionMarginBottom))) {
            this.slideshowComputedStyle.captionComputedStyle.captionMarginBottom = parseInt(CaptionMarginBottom);
        }

        // padding
        var CaptionPaddingLeft = IS_SlideShow_RemoveCssUnits(captionContainerComputedStyle.paddingLeft);
        if ((CaptionPaddingLeft != '') && (!isNaN(CaptionPaddingLeft))) {
            this.slideshowComputedStyle.captionComputedStyle.captionPaddingLeft = parseInt(CaptionPaddingLeft);
        }

        var CaptionPaddingRight = IS_SlideShow_RemoveCssUnits(captionContainerComputedStyle.paddingRight);
        if ((CaptionPaddingRight != '') && (!isNaN(CaptionPaddingRight))) {
            this.slideshowComputedStyle.captionComputedStyle.captionPaddingRight = parseInt(CaptionPaddingRight);
        }

        var CaptionPaddingTop = IS_SlideShow_RemoveCssUnits(captionContainerComputedStyle.paddingTop);
        if ((CaptionPaddingTop != '') && (!isNaN(CaptionPaddingTop))) {
            this.slideshowComputedStyle.captionComputedStyle.captionPaddingTop = parseInt(CaptionPaddingTop);
        }

        var CaptionPaddingBottom = IS_SlideShow_RemoveCssUnits(captionContainerComputedStyle.paddingBottom);
        if ((CaptionPaddingBottom != '') && (!isNaN(CaptionPaddingBottom))) {
            this.slideshowComputedStyle.captionComputedStyle.captionPaddingBottom = parseInt(CaptionPaddingBottom);
        }

        // border
        var CaptionBorderLeft = IS_SlideShow_RemoveCssUnits(captionContainerComputedStyle.borderLeftWidth);
        if ((CaptionBorderLeft != '') && (!isNaN(CaptionBorderLeft))) {
            this.slideshowComputedStyle.captionComputedStyle.captionBorderLeft = parseInt(CaptionBorderLeft);
        }

        var CaptionBorderRight = IS_SlideShow_RemoveCssUnits(captionContainerComputedStyle.borderRightWidth);
        if ((CaptionBorderRight != '') && (!isNaN(CaptionBorderRight))) {
            this.slideshowComputedStyle.captionComputedStyle.captionBorderRight = parseInt(CaptionBorderRight);
        }

        var CaptionBorderTop = IS_SlideShow_RemoveCssUnits(captionContainerComputedStyle.borderTopWidth);
        if ((CaptionBorderTop != '') && (!isNaN(CaptionBorderTop))) {
            this.slideshowComputedStyle.captionComputedStyle.captionBorderTop = parseInt(CaptionBorderTop);
        }

        var CaptionBorderBottom = IS_SlideShow_RemoveCssUnits(captionContainerComputedStyle.borderBottomWidth);
        if ((CaptionBorderBottom != '') && (!isNaN(CaptionBorderBottom))) {
            this.slideshowComputedStyle.captionComputedStyle.captionBorderBottom = parseInt(CaptionBorderBottom);
        }




        // computing dimensions
        if (this.slideshowComputedStyle.captionComputedStyle.captionHeight <= 0) {
            this.slideshowComputedStyle.captionComputedStyle.captionHeight = parseInt(this.slideshowComputedStyle.slideshowHeight * 0.2);
            this.slideshowComputedStyle.captionComputedStyle.captionHeight -= (this.slideshowComputedStyle.captionComputedStyle.captionPaddingTop + this.slideshowComputedStyle.captionComputedStyle.captionPaddingBottom);
        }

        if (this.slideshowComputedStyle.captionComputedStyle.captionWidth <= 0) {
            this.slideshowComputedStyle.captionComputedStyle.captionWidth = this.slideshowComputedStyle.slideshowWidth;
            this.slideshowComputedStyle.captionComputedStyle.captionWidth -= (this.slideshowComputedStyle.captionComputedStyle.captionPaddingLeft
                                                                              + this.slideshowComputedStyle.captionComputedStyle.captionPaddingRight
                                                                              + this.slideshowComputedStyle.captionComputedStyle.captionBorderLeft
                                                                              + this.slideshowComputedStyle.captionComputedStyle.captionBorderRight);
        }

        if (this.slideshowComputedStyle.captionComputedStyle.captionTop == null) {
            if (this.caption.captionPosition == 'bottom') {
                var captionTop = this.slideshowComputedStyle.slideshowHeight - this.slideshowComputedStyle.captionComputedStyle.captionHeight + this.slideshowComputedStyle.slideshowPaddingTop + 1;
                /* if ((this.thumbnails.displayThumbnails) && (this.thumbnails.thumbnailsPosition == 'bottom')) {
                captionTop -= this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsHeight;
                captionTop -= (this.slideshowComputedStyle.captionComputedStyle.captionPaddingTop + this.slideshowComputedStyle.captionComputedStyle.captionPaddingBottom);
                }*/
                this.slideshowComputedStyle.captionComputedStyle.captionTop = captionTop;
            }
            else if ((this.caption.captionPosition == 'middle') || (this.caption.captionPosition == 'middleright')) {
                var captionOffsetHeight = this.slideshowComputedStyle.captionComputedStyle.captionHeight
                                          + this.slideshowComputedStyle.captionComputedStyle.captionMarginTop
                                          + this.slideshowComputedStyle.captionComputedStyle.captionPaddingTop
                                          + this.slideshowComputedStyle.captionComputedStyle.captionBorderTop
                                          + this.slideshowComputedStyle.captionComputedStyle.captionMarginBottom
                                          + this.slideshowComputedStyle.captionComputedStyle.captionPaddingBottom
                                          + this.slideshowComputedStyle.captionComputedStyle.captionBorderBottom;

                var captionTop = parseInt(this.slideshowComputedStyle.slideshowHeight / 2) - parseInt(captionOffsetHeight / 2);

                this.slideshowComputedStyle.captionComputedStyle.captionTop = captionTop;
            }
            else {
                if ((this.thumbnails.displayThumbnails) && (this.thumbnails.thumbnailsPosition == 'top')) {
                    this.slideshowComputedStyle.captionComputedStyle.captionTop = this.slideshowComputedStyle.slideshowPaddingTop + this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsHeight;
                    this.slideshowComputedStyle.captionComputedStyle.captionTop += (this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsPaddingTop + this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsPaddingBottom);
                }
                else {
                    this.slideshowComputedStyle.captionComputedStyle.captionTop = this.slideshowComputedStyle.slideshowPaddingTop;
                }
            }
        }

        if (this.slideshowComputedStyle.captionComputedStyle.captionLeft == null) {
            if (this.caption.captionPosition == 'middle') {
                var captionOffsetWidth = this.slideshowComputedStyle.captionComputedStyle.captionWidth
                                         + this.slideshowComputedStyle.captionComputedStyle.captionMarginLeft
                                         + this.slideshowComputedStyle.captionComputedStyle.captionPaddingLeft
                                         + this.slideshowComputedStyle.captionComputedStyle.captionBorderLeft
                                         + this.slideshowComputedStyle.captionComputedStyle.captionMarginRight
                                         + this.slideshowComputedStyle.captionComputedStyle.captionPaddingRight
                                         + this.slideshowComputedStyle.captionComputedStyle.captionBorderRight;

                var captionWidth = parseInt(this.slideshowComputedStyle.slideshowWidth / 2) - parseInt(captionOffsetWidth / 2);

                this.slideshowComputedStyle.captionComputedStyle.captionLeft = captionWidth;
            }
            else if (this.caption.captionPosition == 'middleright') {
                var captionOffsetWidth = this.slideshowComputedStyle.captionComputedStyle.captionWidth
                                         + this.slideshowComputedStyle.captionComputedStyle.captionMarginLeft
                                         + this.slideshowComputedStyle.captionComputedStyle.captionPaddingLeft
                                         + this.slideshowComputedStyle.captionComputedStyle.captionBorderLeft
                                         + this.slideshowComputedStyle.captionComputedStyle.captionMarginRight
                                         + this.slideshowComputedStyle.captionComputedStyle.captionPaddingRight
                                         + this.slideshowComputedStyle.captionComputedStyle.captionBorderRight;

                var slideshowRightEdge = this.slideshowComputedStyle.slideshowMarginRight
                                         + this.slideshowComputedStyle.slideshowPaddingRight
                                         + this.slideshowComputedStyle.slideshowBorderRight;

                var captionLeft = this.slideshowComputedStyle.slideshowWidth - slideshowRightEdge - captionOffsetWidth;

                this.slideshowComputedStyle.captionComputedStyle.captionLeft = captionLeft;
            }
            else {
                this.slideshowComputedStyle.captionComputedStyle.captionLeft = this.slideshowComputedStyle.slideshowPaddingLeft;
            }
        }
    }

    // InitializeControlsComputedStyle
    this.InitializeControlsComputedStyle = function () {
        if (this.controls.nextImageButton) {
            this.Initialize_Controls_NextImageButton_ComputedStyle();
        }

        if (this.controls.previousImageButton) {
            this.Initialize_Controls_PreviousImageButton_ComputedStyle();
        }
    }

    // Initialize_Controls_NextImageButton_ComputedStyle
    this.Initialize_Controls_NextImageButton_ComputedStyle = function () {
        var NextImageButton = document.getElementById(this.controls.nextImageButtonID);

        // reading applyed css rules
        if (this.slideShowApplyedCSSRules.IS_SlideShow_Controls_NextImageButton != null) {
            // width & height
            var NextImageButtonWidth = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_Controls_NextImageButton.style.width);
            if ((NextImageButtonWidth != '') && (!isNaN(NextImageButtonWidth))) {
                this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonWidth = parseInt(NextImageButtonWidth);
            }

            var NextImageButtonHeight = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_Controls_NextImageButton.style.height);
            if ((NextImageButtonHeight != '') && (!isNaN(NextImageButtonHeight))) {
                this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonHeight = parseInt(NextImageButtonHeight);
            }

            var avoidButtonTopLeft = false;
            try { avoidButtonTopLeft = isAvoidButtonTopLeft; } catch (ex) { }

            if (!avoidButtonTopLeft) {
                // top & left
                var NextImageButtonTop = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_Controls_NextImageButton.style.top);
                if ((NextImageButtonTop != '') && (!isNaN(NextImageButtonTop))) {
                    this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonTop = parseInt(NextImageButtonTop);
                }

                var NextImageButtonLeft = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_Controls_NextImageButton.style.left);
                if ((NextImageButtonLeft != '') && (!isNaN(NextImageButtonLeft))) {
                    this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonLeft = parseInt(NextImageButtonLeft);
                }
            }
        }

        // reading computed styles
        var NextImageButtonComputedStyle = getComputedStyle(NextImageButton);

        // margin
        var NextImageButtonMarginLeft = IS_SlideShow_RemoveCssUnits(NextImageButtonComputedStyle.marginLeft);
        if ((NextImageButtonMarginLeft != '') && (!isNaN(NextImageButtonMarginLeft))) {
            this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonMarginLeft = parseInt(NextImageButtonMarginLeft);
        }

        var NextImageButtonMarginRight = IS_SlideShow_RemoveCssUnits(NextImageButtonComputedStyle.marginRight);
        if ((NextImageButtonMarginRight != '') && (!isNaN(NextImageButtonMarginRight))) {
            this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonMarginRight = parseInt(NextImageButtonMarginRight);
        }

        var NextImageButtonMarginTop = IS_SlideShow_RemoveCssUnits(NextImageButtonComputedStyle.marginTop);
        if ((NextImageButtonMarginTop != '') && (!isNaN(NextImageButtonMarginTop))) {
            this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonMarginTop = parseInt(NextImageButtonMarginTop);
        }

        var NextImageButtonMarginBottom = IS_SlideShow_RemoveCssUnits(NextImageButtonComputedStyle.marginBottom);
        if ((NextImageButtonMarginBottom != '') && (!isNaN(NextImageButtonMarginBottom))) {
            this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonMarginBottom = parseInt(NextImageButtonMarginBottom);
        }

        // padding
        var NextImageButtonPaddingLeft = IS_SlideShow_RemoveCssUnits(NextImageButtonComputedStyle.paddingLeft);
        if ((NextImageButtonPaddingLeft != '') && (!isNaN(NextImageButtonPaddingLeft))) {
            this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonPaddingLeft = parseInt(NextImageButtonPaddingLeft);
        }

        var NextImageButtonPaddingRight = IS_SlideShow_RemoveCssUnits(NextImageButtonComputedStyle.paddingRight);
        if ((NextImageButtonPaddingRight != '') && (!isNaN(NextImageButtonPaddingRight))) {
            this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonPaddingRight = parseInt(NextImageButtonPaddingRight);
        }

        var NextImageButtonPaddingTop = IS_SlideShow_RemoveCssUnits(NextImageButtonComputedStyle.paddingTop);
        if ((NextImageButtonPaddingTop != '') && (!isNaN(NextImageButtonPaddingTop))) {
            this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonPaddingTop = parseInt(NextImageButtonPaddingTop);
        }

        var NextImageButtonPaddingBottom = IS_SlideShow_RemoveCssUnits(NextImageButtonComputedStyle.paddingBottom);
        if ((NextImageButtonPaddingBottom != '') && (!isNaN(NextImageButtonPaddingBottom))) {
            this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonPaddingBottom = parseInt(NextImageButtonPaddingBottom);
        }

        // border
        var NextImageButtonBorderLeft = IS_SlideShow_RemoveCssUnits(NextImageButtonComputedStyle.borderLeftWidth);
        if ((NextImageButtonBorderLeft != '') && (!isNaN(NextImageButtonBorderLeft))) {
            this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonBorderLeft = parseInt(NextImageButtonBorderLeft);
        }

        var NextImageButtonBorderRight = IS_SlideShow_RemoveCssUnits(NextImageButtonComputedStyle.borderRightWidth);
        if ((NextImageButtonBorderRight != '') && (!isNaN(NextImageButtonBorderRight))) {
            this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonBorderRight = parseInt(NextImageButtonBorderRight);
        }

        var NextImageButtonBorderTop = IS_SlideShow_RemoveCssUnits(NextImageButtonComputedStyle.borderTopWidth);
        if ((NextImageButtonBorderTop != '') && (!isNaN(NextImageButtonBorderTop))) {
            this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonBorderTop = parseInt(NextImageButtonBorderTop);
        }

        var NextImageButtonBorderBottom = IS_SlideShow_RemoveCssUnits(NextImageButtonComputedStyle.borderBottomWidth);
        if ((NextImageButtonBorderBottom != '') && (!isNaN(NextImageButtonBorderBottom))) {
            this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonBorderBottom = parseInt(NextImageButtonBorderBottom);
        }

        // computing dimensions
        if (this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonTop == null) {
            this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonTop =
                parseInt(this.slideshowComputedStyle.imageComputedStyle.imageContentHeight / 2)
                - parseInt(this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonHeight / 2);
        }

        if (this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonLeft == null) {
            this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonLeft =
                (this.slideshowComputedStyle.imageComputedStyle.imageContentWidth
                + this.slideshowComputedStyle.slideshowMarginLeft
                + this.slideshowComputedStyle.slideshowBorderLeft
                + this.slideshowComputedStyle.slideshowPaddingLeft)
                -
                (this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonWidth
                + this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonMarginRight
                + this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonPaddingRight
                + this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonBorderRight);
        }
    }

    // Initialize_Controls_PreviousImageButton_ComputedStyle
    this.Initialize_Controls_PreviousImageButton_ComputedStyle = function () {
        var PreviousImageButton = document.getElementById(this.controls.previousImageButtonID);

        // reading applyed css rules
        if (this.slideShowApplyedCSSRules.IS_SlideShow_Controls_NextImageButton != null) {
            // width & height
            var PreviousImageButtonWidth = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_Controls_NextImageButton.style.width);
            if ((PreviousImageButtonWidth != '') && (!isNaN(PreviousImageButtonWidth))) {
                this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonWidth = parseInt(PreviousImageButtonWidth);
            }

            var PreviousImageButtonHeight = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_Controls_NextImageButton.style.height);
            if ((PreviousImageButtonHeight != '') && (!isNaN(PreviousImageButtonHeight))) {
                this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonHeight = parseInt(PreviousImageButtonHeight);
            }

            var avoidButtonTopLeft = false;
            try { avoidButtonTopLeft = isAvoidButtonTopLeft; } catch (ex) { }

            if (!avoidButtonTopLeft) {
                // top & left
                var PreviousImageButtonTop = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_Controls_NextImageButton.style.top);
                if ((PreviousImageButtonTop != '') && (!isNaN(PreviousImageButtonTop))) {
                    this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonTop = parseInt(PreviousImageButtonTop);
                }

                var PreviousImageButtonLeft = IS_SlideShow_RemoveCssUnits(this.slideShowApplyedCSSRules.IS_SlideShow_Controls_NextImageButton.style.left);
                if ((PreviousImageButtonLeft != '') && (!isNaN(PreviousImageButtonLeft))) {
                    this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonTop = parseInt(PreviousImageButtonLeft);
                }
            }
        }

        // reading computed styles
        var PreviousImageButtonComputedStyle = getComputedStyle(PreviousImageButton);

        // margin
        var PreviousImageButtonMarginLeft = IS_SlideShow_RemoveCssUnits(PreviousImageButtonComputedStyle.marginLeft);
        if ((PreviousImageButtonMarginLeft != '') && (!isNaN(PreviousImageButtonMarginLeft))) {
            this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonMarginLeft = parseInt(PreviousImageButtonMarginLeft);
        }

        var PreviousImageButtonMarginRight = IS_SlideShow_RemoveCssUnits(PreviousImageButtonComputedStyle.marginRight);
        if ((PreviousImageButtonMarginRight != '') && (!isNaN(PreviousImageButtonMarginRight))) {
            this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonMarginRight = parseInt(PreviousImageButtonMarginRight);
        }

        var PreviousImageButtonMarginTop = IS_SlideShow_RemoveCssUnits(PreviousImageButtonComputedStyle.marginTop);
        if ((PreviousImageButtonMarginTop != '') && (!isNaN(PreviousImageButtonMarginTop))) {
            this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonMarginTop = parseInt(PreviousImageButtonMarginTop);
        }

        var PreviousImageButtonMarginBottom = IS_SlideShow_RemoveCssUnits(PreviousImageButtonComputedStyle.marginBottom);
        if ((PreviousImageButtonMarginBottom != '') && (!isNaN(PreviousImageButtonMarginBottom))) {
            this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonMarginBottom = parseInt(PreviousImageButtonMarginBottom);
        }

        // padding
        var PreviousImageButtonPaddingLeft = IS_SlideShow_RemoveCssUnits(PreviousImageButtonComputedStyle.paddingLeft);
        if ((PreviousImageButtonPaddingLeft != '') && (!isNaN(PreviousImageButtonPaddingLeft))) {
            this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonPaddingLeft = parseInt(PreviousImageButtonPaddingLeft);
        }

        var PreviousImageButtonPaddingRight = IS_SlideShow_RemoveCssUnits(PreviousImageButtonComputedStyle.paddingRight);
        if ((PreviousImageButtonPaddingRight != '') && (!isNaN(PreviousImageButtonPaddingRight))) {
            this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonPaddingRight = parseInt(PreviousImageButtonPaddingRight);
        }

        var PreviousImageButtonPaddingTop = IS_SlideShow_RemoveCssUnits(PreviousImageButtonComputedStyle.paddingTop);
        if ((PreviousImageButtonPaddingTop != '') && (!isNaN(PreviousImageButtonPaddingTop))) {
            this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonPaddingTop = parseInt(PreviousImageButtonPaddingTop);
        }

        var PreviousImageButtonPaddingBottom = IS_SlideShow_RemoveCssUnits(PreviousImageButtonComputedStyle.paddingBottom);
        if ((PreviousImageButtonPaddingBottom != '') && (!isNaN(PreviousImageButtonPaddingBottom))) {
            this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonPaddingBottom = parseInt(PreviousImageButtonPaddingBottom);
        }

        // border
        var PreviousImageButtonBorderLeft = IS_SlideShow_RemoveCssUnits(PreviousImageButtonComputedStyle.borderLeftWidth);
        if ((PreviousImageButtonBorderLeft != '') && (!isNaN(PreviousImageButtonBorderLeft))) {
            this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonBorderLeft = parseInt(PreviousImageButtonBorderLeft);
        }

        var PreviousImageButtonBorderRight = IS_SlideShow_RemoveCssUnits(PreviousImageButtonComputedStyle.borderRightWidth);
        if ((PreviousImageButtonBorderRight != '') && (!isNaN(PreviousImageButtonBorderRight))) {
            this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonBorderRight = parseInt(PreviousImageButtonBorderRight);
        }

        var PreviousImageButtonBorderTop = IS_SlideShow_RemoveCssUnits(PreviousImageButtonComputedStyle.borderTopWidth);
        if ((PreviousImageButtonBorderTop != '') && (!isNaN(PreviousImageButtonBorderTop))) {
            this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonBorderTop = parseInt(PreviousImageButtonBorderTop);
        }

        var PreviousImageButtonBorderBottom = IS_SlideShow_RemoveCssUnits(PreviousImageButtonComputedStyle.borderBottomWidth);
        if ((PreviousImageButtonBorderBottom != '') && (!isNaN(PreviousImageButtonBorderBottom))) {
            this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonPaddingBottom = parseInt(PreviousImageButtonBorderBottom);
        }

        // computing dimensions
        if (this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonTop == null) {
            this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonTop =
                parseInt(this.slideshowComputedStyle.imageComputedStyle.imageContentHeight / 2)
                - parseInt(this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonHeight / 2);
        }

        if (this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonLeft == null) {
            this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonLeft =
                this.slideshowComputedStyle.slideshowMarginLeft
                + this.slideshowComputedStyle.slideshowBorderLeft
                + this.slideshowComputedStyle.slideshowPaddingLeft;
        }
    }
    // End: Computed Styles Initialization

    // Start: Clean Computed Styles

    this.CleanComputedStyles = function () {
        // Main Container Computed Styles
        this.slideshowComputedStyle.slideshowBorderBottom = 0;
        this.slideshowComputedStyle.slideshowBorderLeft = 0;
        this.slideshowComputedStyle.slideshowBorderRight = 0;
        this.slideshowComputedStyle.slideshowBorderTop = 0;
        this.slideshowComputedStyle.slideshowHeight = 0;
        this.slideshowComputedStyle.slideshowPaddingBottom = 0;
        this.slideshowComputedStyle.slideshowPaddingLeft = 0;
        this.slideshowComputedStyle.slideshowPaddingRight = 0;
        this.slideshowComputedStyle.slideshowPaddingTop = 0;
        this.slideshowComputedStyle.slideshowWidth = 0;

        // Caption Computed Styles
        this.slideshowComputedStyle.captionComputedStyle.captionBorderBottom = 0;
        this.slideshowComputedStyle.captionComputedStyle.captionBorderLeft = 0;
        this.slideshowComputedStyle.captionComputedStyle.captionBorderRight = 0;
        this.slideshowComputedStyle.captionComputedStyle.captionBorderTop = 0;
        this.slideshowComputedStyle.captionComputedStyle.captionHeight = 0;
        this.slideshowComputedStyle.captionComputedStyle.captionLeft = null;
        this.slideshowComputedStyle.captionComputedStyle.captionMarginBottom = 0;
        this.slideshowComputedStyle.captionComputedStyle.captionMarginLeft = 0;
        this.slideshowComputedStyle.captionComputedStyle.captionMarginRight = 0;
        this.slideshowComputedStyle.captionComputedStyle.captionMarginTop = 0;
        this.slideshowComputedStyle.captionComputedStyle.captionPaddingBottom = 0;
        this.slideshowComputedStyle.captionComputedStyle.captionPaddingLeft = 0;
        this.slideshowComputedStyle.captionComputedStyle.captionPaddingRight = 0;
        this.slideshowComputedStyle.captionComputedStyle.captionPaddingTop = 0;
        this.slideshowComputedStyle.captionComputedStyle.captionTop = null;
        this.slideshowComputedStyle.captionComputedStyle.captionWidth = 0;

        // Controls Computed Styles

        // Next Image Button Styles
        this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonBorderBottom = 0;
        this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonBorderLeft = 0;
        this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonBorderRight = 0;
        this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonBorderTop = 0;
        this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonHeight = 0;
        this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonLeft = null;
        this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonMarginBottom = 0;
        this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonMarginLeft = 0;
        this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonMarginRight = 0;
        this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonMarginTop = 0;
        this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonPaddingBottom = 0;
        this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonPaddingLeft = 0;
        this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonPaddingRight = 0;
        this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonPaddingTop = 0;
        this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonTop = null;
        this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonWidth = 0;

        // Next Image Button Styles
        this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonBorderBottom = 0;
        this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonBorderLeft = 0;
        this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonBorderRight = 0;
        this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonBorderTop = 0;
        this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonHeight = 0;
        this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonLeft = null;
        this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonMarginBottom = 0;
        this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonMarginLeft = 0;
        this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonMarginRight = 0;
        this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonMarginTop = 0;
        this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonPaddingBottom = 0;
        this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonPaddingLeft = 0;
        this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonPaddingRight = 0;
        this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonPaddingTop = 0;
        this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonTop = null;
        this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonWidth = 0;

        // Image Content Computed Styles
        this.slideshowComputedStyle.imageComputedStyle.imageContentHeight = 0;
        this.slideshowComputedStyle.imageComputedStyle.imageContentWidth = 0;
        this.slideshowComputedStyle.imageComputedStyle.imageLeft = 0;
        this.slideshowComputedStyle.imageComputedStyle.imageTop = 0;

        // Resize Computed Styles
        this.slideshowComputedStyle.resizeComputedStyle.resizeBorderBottom = 0;
        this.slideshowComputedStyle.resizeComputedStyle.resizeBorderLeft = 0;
        this.slideshowComputedStyle.resizeComputedStyle.resizeBorderRight = 0;
        this.slideshowComputedStyle.resizeComputedStyle.resizeBorderTop = 0;
        this.slideshowComputedStyle.resizeComputedStyle.resizeHeight = 0;
        this.slideshowComputedStyle.resizeComputedStyle.resizeMarginBottom = 0;
        this.slideshowComputedStyle.resizeComputedStyle.resizeMarginLeft = 0;
        this.slideshowComputedStyle.resizeComputedStyle.resizeMarginRight = 0;
        this.slideshowComputedStyle.resizeComputedStyle.resizeMarginTop = 0;
        this.slideshowComputedStyle.resizeComputedStyle.resizePaddingBottom = 0;
        this.slideshowComputedStyle.resizeComputedStyle.resizePaddingLeft = 0;
        this.slideshowComputedStyle.resizeComputedStyle.resizePaddingRight = 0;
        this.slideshowComputedStyle.resizeComputedStyle.resizePaddingTop = 0;
        this.slideshowComputedStyle.resizeComputedStyle.resizeWidth = 0;

        // Thumbnails Computed Styles
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsBorderBottom = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsBorderLeft = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsBorderRight = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsBorderTop = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsBottom = null;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsHeight = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsLeft = null;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsPaddingBottom = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsPaddingLeft = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsPaddingRight = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsPaddingTop = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsRight = null;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsTop = null;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsWidth = 0;

        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlBorderBottom = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlBorderLeft = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlBorderRight = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlBorderTop = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlHeight = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlLeft = null;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlMarginBottom = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlMarginLeft = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlMarginRight = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlMarginTop = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlPaddingBottom = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlPaddingLeft = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlPaddingRight = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlPaddingTop = 0;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlTop = null;
        this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlWidth = 0;
    }

    // End: Clean Computed Styles

    // Start: Initialize Controls
    //InitializeControls
    this.InitializeControls = function () {
        var ISSlideShowImage = this.images[0];

        this.InitializeSlideShowContainer();

        if (this.thumbnails.displayThumbnails) {
            this.InitializeThumbnails();
        }

        if (this.caption.displayCaption) {
            this.InitializeCaption();
            this.animation.CaptionToEnter.children[0].innerHTML = ISSlideShowImage.imageCaption;
        }

        this.InitializeImageContainer();

        var image1 = document.getElementById(this.imageControls.image1ID);
        if (this.imageOptions.imageRender == 'HtmlImage') {
            image1.src = IS_SlideShow_GetDynamicImageURL(ISSlideShowImage.imageURL, this.slideshowComputedStyle.imageComputedStyle.imageContentWidth, this.slideshowComputedStyle.imageComputedStyle.imageContentHeight);
        }
        else {
            image1.style.backgroundImage = "url('" + IS_SlideShow_GetDynamicImageURL(ISSlideShowImage.imageURL, this.slideshowComputedStyle.imageComputedStyle.imageContentWidth, this.slideshowComputedStyle.imageComputedStyle.imageContentHeight) + "')";
        }
        this.InitializeImage(image1, ISSlideShowImage);

        this.InitializeVideoPanels();

        if (this.controls.displayControls) {
            this.InitializeControlsButtons()
        }
    }

    //InitializeImageContainer
    this.InitializeImageContainer = function () {
        var imageContainer = document.getElementById(this.imageControls.imageContainerID);


        try {
            ExternalSetupImageContainer(this, imageContainer);
        } catch (ex) {
            //alert(ex);
            imageContainer.style.top = this.slideshowComputedStyle.imageComputedStyle.imageTop + 'px';
            imageContainer.style.width = this.slideshowComputedStyle.imageComputedStyle.imageContentWidth + 'px';
            imageContainer.style.height = this.slideshowComputedStyle.imageComputedStyle.imageContentHeight + 'px';

            if (this.resizeOptions.CenterHorizontally) {
                var ParentWidth = window.innerWidth;
                if (this.slideshowComputedStyle.resizeComputedStyle.resizeWidth > 0) { ParentWidth = this.slideshowComputedStyle.resizeComputedStyle.resizeWidth }
                imageContainer.style.left = -((this.slideshowComputedStyle.imageComputedStyle.imageContentWidth - ParentWidth) / 2) + 'px';
            }

            if (this.resizeOptions.CenterVertically) {
                var ParentHeight = window.innerHeight;
                if (this.slideshowComputedStyle.resizeComputedStyle.resizeHeight > 0) { ParentHeight = this.slideshowComputedStyle.resizeComputedStyle.resizeHeight }
                imageContainer.style.top = -((this.slideshowComputedStyle.imageComputedStyle.imageContentHeight - ParentHeight) / 2) + 'px';
            }
        }
    }

    //InitializeCaption
    this.InitializeCaption = function () {
        var captionContainer = document.getElementById(this.caption.captionContainerID);
        var caption1 = document.getElementById(this.caption.caption1ID);
        var caption2 = document.getElementById(this.caption.caption2ID);

        captionContainer.style.height = this.slideshowComputedStyle.captionComputedStyle.captionHeight + 'px';
        captionContainer.style.width = this.slideshowComputedStyle.captionComputedStyle.captionWidth + 'px';
        captionContainer.style.top = this.slideshowComputedStyle.captionComputedStyle.captionTop + 'px';
        captionContainer.style.left = this.slideshowComputedStyle.captionComputedStyle.captionLeft + 'px';

        caption1.style.height = this.slideshowComputedStyle.captionComputedStyle.captionHeight -
                                (this.slideshowComputedStyle.captionComputedStyle.captionPaddingTop
                                 + this.slideshowComputedStyle.captionComputedStyle.captionPaddingBottom) + 'px';
        caption1.style.width = this.slideshowComputedStyle.captionComputedStyle.captionWidth -
                               (this.slideshowComputedStyle.captionComputedStyle.captionPaddingLeft
                                + this.slideshowComputedStyle.captionComputedStyle.captionPaddingRight) + 'px';
        caption1.style.top = this.slideshowComputedStyle.captionComputedStyle.captionMarginTop
                             + this.slideshowComputedStyle.captionComputedStyle.captionBorderTop
                             + this.slideshowComputedStyle.captionComputedStyle.captionPaddingTop
        caption1.style.left = this.slideshowComputedStyle.captionComputedStyle.captionMarginLeft
                              + this.slideshowComputedStyle.captionComputedStyle.captionBorderLeft
                              + this.slideshowComputedStyle.captionComputedStyle.captionPaddingLeft;


        caption2.style.width = caption1.style.width;
        caption2.style.height = caption1.style.height;
        caption2.style.top = caption1.style.top;
        if (this.caption.CaptionAnimation == 'fading') {
            caption2.style.left = caption1.style.left;
        }
        else if (this.caption.CaptionAnimation == 'sliding') {
            caption2.style.left = -this.slideshowComputedStyle.captionComputedStyle.captionWidth + 'px';
        }

        if (!this.animation.CaptionToEnter) {
            this.animation.CaptionToEnter = caption1;
            this.animation.CaptionToLeave = caption2;
        }
    }

    // InitializeControlsButtons
    this.InitializeControlsButtons = function () {
        if (this.controls.nextImageButton) {
            var NextImageButton = document.getElementById(this.controls.nextImageButtonID);

            NextImageButton.style.width = this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonWidth + 'px';
            NextImageButton.style.height = this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonHeight + 'px';
            var avoidButtonTopLeft = false;
            try { avoidButtonTopLeft = isAvoidButtonTopLeft; } catch (ex) { }

            if (!avoidButtonTopLeft) {
                NextImageButton.style.top = this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonTop + 'px';
                NextImageButton.style.left = this.slideshowComputedStyle.controlsComputedStyle.NextImageButton.NextImageButtonLeft + 'px';
            }
        }

        if (this.controls.previousImageButton) {
            var PreviousImageButton = document.getElementById(this.controls.previousImageButtonID);

            PreviousImageButton.style.width = this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonWidth + 'px';
            PreviousImageButton.style.height = this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonHeight + 'px';
            var avoidButtonTopLeft = false;
            try { avoidButtonTopLeft = isAvoidButtonTopLeft; } catch (ex) { }

            if (!avoidButtonTopLeft) {
                PreviousImageButton.style.top = this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonTop + 'px';
                PreviousImageButton.style.left = this.slideshowComputedStyle.controlsComputedStyle.PreviousImageButton.PreviousImageButtonLeft + 'px';
            }
        }
    }

    //InitializeImage
    this.InitializeImage = function (imageToSize, ISSlideShowImage) {
        var slideShowMainContainer = document.getElementById(this.slideShowMainContainerID);

        if (ISSlideShowImage.imageLink != '') {
            imageToSize.onclick = function () { window.location = ISSlideShowImage.imageLink; }
            imageToSize.style.cursor = 'pointer';
        }
        else {
            imageToSize.onclick = null;
            imageToSize.style.cursor = 'default';
        }

        var imageContentWidth = this.slideshowComputedStyle.imageComputedStyle.imageContentWidth;
        var imageContentHeight = this.slideshowComputedStyle.imageComputedStyle.imageContentHeight;
        try {
            ExternalInitializeImage(this, imageToSize, imageContentWidth, imageContentHeight);
        } catch (ex) {
            if (this.resizeImages) {
                //alert(ex);
                imageToSize.style.width = imageContentWidth + 'px';
                imageToSize.style.height = imageContentHeight + 'px';
                imageToSize.style.top = '0px';
                imageToSize.style.left = '0px';
            }
            else {
                if ((ISSlideShowImage.imageRealWidth >= ISSlideShowImage.imageRealHeight) && (ISSlideShowImage.imageRealWidth > imageContentWidth)) {
                    var ResizeRatio = (imageContentWidth / ISSlideShowImage.imageRealWidth);
                    var ImageNewWidth = imageContentWidth;
                    var ImageNewHeight = parseInt(ISSlideShowImage.imageRealHeight * ResizeRatio);

                    if (ImageNewHeight > imageContentHeight) {
                        ResizeRatio = imageContentHeight / ImageNewHeight;
                        ImageNewHeight = imageContentHeight;
                        ImageNewWidth = parseInt(ImageNewWidth * ResizeRatio);
                    }

                    imageToSize.style.width = ImageNewWidth + 'px';
                    imageToSize.style.height = ImageNewHeight + 'px';

                    imageToSize.style.top = parseInt((imageContentHeight / 2) - (ImageNewHeight / 2)) + 'px';
                    imageToSize.style.left = parseInt(imageContentWidth / 2) - (ImageNewWidth / 2) + 'px';
                }
                else if (ISSlideShowImage.imageRealHeight > imageContentHeight) {
                    var ResizeRatio = (imageContentHeight / ISSlideShowImage.imageRealHeight);
                    var ImageNewWidth = parseInt(ISSlideShowImage.imageRealWidth * ResizeRatio);
                    var ImageNewHeight = imageContentHeight;

                    if (ImageNewWidth > imageContentWidth) {
                        ResizeRatio = imageContentWidth / ImageNewWidth;
                        ImageNewHeight = parseInt(ImageNewHeight * ResizeRatio);
                        ImageNewWidth = imageContentWidth;
                    }

                    imageToSize.style.width = ImageNewWidth + 'px';
                    imageToSize.style.height = ImageNewHeight + 'px';

                    imageToSize.style.top = parseInt((imageContentHeight / 2) - (ImageNewHeight / 2)) + 'px';
                    imageToSize.style.left = parseInt(imageContentWidth / 2) - (ImageNewWidth / 2) + 'px';
                }
                else {
                    imageToSize.style.width = ISSlideShowImage.imageRealWidth + 'px';
                    imageToSize.style.height = ISSlideShowImage.imageRealHeight + 'px';
    
                    imageToSize.style.top = parseInt((imageContentHeight / 2) - (ISSlideShowImage.imageRealHeight / 2)) + 'px';
                    imageToSize.style.left = parseInt((imageContentWidth / 2) - (ISSlideShowImage.imageRealWidth / 2)) + 'px';
                }
            }
        }
    }

    // InitializeVideoPanels
    this.InitializeVideoPanels = function () {
        var VideoPanel1 = document.getElementById(this.imageControls.videoPanel1ID);
        var VideoPanel2 = document.getElementById(this.imageControls.videoPanel2ID);

        VideoPanel1.style.width = this.slideshowComputedStyle.imageComputedStyle.imageContentWidth + 'px';
        VideoPanel1.style.height = this.slideshowComputedStyle.imageComputedStyle.imageContentHeight + 'px';

        VideoPanel2.style.width = this.slideshowComputedStyle.imageComputedStyle.imageContentWidth + 'px';
        VideoPanel2.style.height = this.slideshowComputedStyle.imageComputedStyle.imageContentHeight + 'px';
    }

    // InitializeSlideShow
    this.InitializeSlideShowContainer = function () {
        var slideShow = document.getElementById(this.slideshowID);
        slideShow.style.width = this.slideshowComputedStyle.slideshowWidth + 'px';
        slideShow.style.height = this.slideshowComputedStyle.slideshowHeight + 'px';
    }

    // InitializeThumbnails
    this.InitializeThumbnails = function () {
        var thumbnailsContainer = document.getElementById(this.thumbnails.thumbnailsContainerID);
        var thumbnailsListControl = document.getElementById(this.thumbnails.thumbnailsListControlID);

        thumbnailsContainer.style.width = this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsWidth + 'px';
        thumbnailsContainer.style.height = this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsHeight + 'px';

        var avoidThumbsTopLeft = false;
        try { avoidThumbsTopLeft = isAvoidThumbsTopLeft; } catch (ex) { }

        if (!avoidThumbsTopLeft) {

            // top, bottom
            if (this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsTop != null) {
                thumbnailsContainer.style.top = this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsTop + 'px';
            }
            else {
                thumbnailsContainer.style.bottom = this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsBottom + 'px';
            }

            // left, right
            if (this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsLeft != null) {
                thumbnailsContainer.style.left = this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsLeft + 'px';
            }
            else {
                thumbnailsContainer.style.right = this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsRight + 'px';
            }
        }
        thumbnailsListControl.style.width = this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlWidth + 'px';
        thumbnailsListControl.style.height = this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlHeight + 'px';
        if (!avoidThumbsTopLeft) {
            thumbnailsListControl.style.top = this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlTop + 'px';
            thumbnailsListControl.style.left = this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsListControl.listControlLeft + 'px';
        }
        if (this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsWidth < thumbnailsListControl.offsetWidth) {
            var ISSlideShow = this;
            thumbnailsContainer.onmousemove = function (event) { ISSlideShow.ThumbnailsScroll(event); }
        }
        else {
            thumbnailsContainer.onmousemove = null;
        }
    }
    // End: Initialize Controls

    //Methods

    // CenterHorizontally
    this.CenterHorizontally = function () {
        var ParentWidth = window.innerWidth;
        if (this.slideshowComputedStyle.resizeComputedStyle.resizeWidth > 0) { ParentWidth = this.slideshowComputedStyle.resizeComputedStyle.resizeWidth }
        var ImageContainer = document.getElementById(this.imageControls.imageContainerID);
        ImageContainer.style.left = -((this.slideshowComputedStyle.imageComputedStyle.imageContentWidth - ParentWidth) / 2) + 'px';
    }

    // CenterVertically
    this.CenterVertically = function () {
        var ParentHeight = window.innerHeight;
        if (this.slideshowComputedStyle.resizeComputedStyle.resizeHeight > 0) { ParentHeight = this.slideshowComputedStyle.resizeComputedStyle.resizeHeight }
        var ImageContainer = document.getElementById(this.imageControls.imageContainerID);
        ImageContainer.style.top = -((this.slideshowComputedStyle.imageComputedStyle.imageContentHeight - ParentHeight) / 2) + 'px';
    }

    //FirstImage method
    this.FirstImage = function () { };

    //GoToImage method
    this.GoToImage = function (imageIndex) {
        if (imageIndex > this.images.length - 1) { return }

        if ((this.autoplay.autoplay) && (this.autoplay.play)) { clearTimeout(this.autoplay.slideshowTimer) }

        if (this.shownImageIndex == imageIndex) { return }

        var image1 = document.getElementById(this.imageControls.image1ID);
        if ($telerik.$(image1).queue().length > 0) { return }

        this.previousImageIndex = this.shownImageIndex;
        this.shownImageIndex = imageIndex;

        this.ShowCurrentImage();
    }

    // HideControlsBox
    this.HideControlsBox = function (functionEvent) {
        var controlBox = document.getElementById(this.controlsBox.controlsBoxContainerID);

        var imageContainer = document.getElementById(this.imageControls.imageContainerID);
        var image1 = document.getElementById(this.imageControls.image1ID);
        var image2 = document.getElementById(this.imageControls.image2ID);

        var captionContainer = document.getElementById(this.caption.captionContainerID);
        var caption1 = document.getElementById(this.caption.caption1ID);
        var caption2 = document.getElementById(this.caption.caption2ID);

        var notImagesControls = (functionEvent.toElement != imageContainer) && (functionEvent.toElement != image1) && (functionEvent.toElement != image2);
        var notCaptionsControls = (functionEvent.toElement != captionContainer) && (functionEvent.toElement != caption1) && (functionEvent.toElement != caption2)
                                    && (functionEvent.toElement != caption1.children[0]) && (functionEvent.toElement != caption2.children[0])

        var notControlBoxControls = (functionEvent.toElement != controlBox);

        if (this.controlsBox.firstImageButton) {
            var firstImageButton = document.getElementById(this.controlsBox.firstImageButtonID);
            notControlBoxControls = (notControlBoxControls && (functionEvent.toElement != firstImageButton));
        }

        if (this.controlsBox.lastImageButton) {
            var lastImageButton = document.getElementById(this.controlsBox.lastImageButtonID);
            notControlBoxControls = (notControlBoxControls && (functionEvent.toElement != lastImageButton));
        }

        if (this.controlsBox.nextImageButton) {
            var nextImageButton = document.getElementById(this.controlsBox.nextImageButtonID);
            notControlBoxControls = (notControlBoxControls && (functionEvent.toElement != nextImageButton));
        }

        if (this.controlsBox.playPauseButton) {
            var playPauseImageButton = document.getElementById(this.controlsBox.playPauseButtonID);
            notControlBoxControls = (notControlBoxControls && (functionEvent.toElement != playPauseImageButton));
        }

        if (this.controlsBox.previousImageButton) {
            var previousImageButton = document.getElementById(this.controlsBox.previousImageButtonID);
            notControlBoxControls = (notControlBoxControls && (functionEvent.toElement != previousImageButton));
        }

        if (notImagesControls && notCaptionsControls && notControlBoxControls) {
            $telerik.$(controlBox).stop(true);
            $telerik.$(controlBox).animate({ opacity: 0 }, 500, null, function () { controlBox.style.display = 'none' });
        }
    }

    //LastImage method
    this.LastImage = function () { };

    //NextImage method
    this.NextImage = function () {
        if (this.animation.animationInProgress) { return }

        this.animation.animationInProgress = true;

        if ((this.autoplay.autoplay) && (this.autoplay.play)) {
            clearTimeout(this.autoplay.slideshowTimer);
        }

        this.previousImageIndex = this.shownImageIndex;

        if (this.shownImageIndex >= this.images.length - 1) {
            this.shownImageIndex = 0;
        }
        else {
            this.shownImageIndex++;
        }

        this.ShowCurrentImage();
    };

    //Pause method
    this.Pause = function () {
        clearTimeout(this.autoplay.slideshowTimer);
        this.autoplay.play = false;
    };

    //Play method
    this.Play = function () {
        if ((this.autoplay.autoplay) && (this.autoplay.play) && (this.images.length > 1)) {
            var ISSlideShow = this;
            this.autoplay.slideshowTimer = setTimeout(function () { ISSlideShow.PlayNextImage() }, this.autoplay.autoplaySpeed);
        }
    };

    // PlayNextImage
    this.PlayNextImage = function () {
        if (this.animation.animationInProgress) { return }

        this.animation.animationInProgress = true;

        if ((this.autoplay.autoplay) && (this.autoplay.play)) {
            clearTimeout(this.autoplay.slideshowTimer);
        }

        this.previousImageIndex = this.shownImageIndex;

        if (this.shownImageIndex >= this.images.length - 1) {
            this.shownImageIndex = 0;
        }
        else {
            this.shownImageIndex++;
        }

        this.ShowCurrentImage();
    }

    // PreviousImage method
    this.PreviousImage = function () {
        if (this.animation.animationInProgress) { return }

        this.animation.animationInProgress = true;

        if ((this.autoplay.autoplay) && (this.autoplay.play)) {
            clearTimeout(this.autoplay.slideshowTimer);
        }

        this.previousImageIndex = this.shownImageIndex;

        if (this.shownImageIndex <= 0) {
            this.shownImageIndex = this.images.length - 1;
        }
        else {
            this.shownImageIndex--;
        }

        this.ShowCurrentImage();
    };

    // Resize
    this.Resize = function () {
        this.CleanComputedStyles();

        this.InitializeComputedStyle();

        this.InitializeSlideShowContainer();

        if (this.thumbnails.displayThumbnails) {
            this.InitializeThumbnails();
        }

        if (this.caption.displayCaption) {
            this.InitializeCaption();
        }

        this.InitializeImageContainer();

        if (this.controls.displayControls) {
            this.InitializeControlsButtons();
        }

        var ISSlideShowImage = this.images[this.shownImageIndex];
        var ISSlidePreviousImage = this.images[this.previousImageIndex];
        var image1 = document.getElementById(this.imageControls.image1ID);
        var image2 = document.getElementById(this.imageControls.image2ID);

        this.InitializeImage(image1, ISSlideShowImage);
        this.InitializeImage(image2, ISSlidePreviousImage);
    }

    // ShowControlsBox
    this.ShowControlsBox = function (functionEvent) {
        var controlBox = document.getElementById(this.controlsBox.controlsBoxContainerID);

        var fromElement = functionEvent.relatedTarget;

        var imageContainer = document.getElementById(this.imageControls.imageContainerID);
        var image1 = document.getElementById(this.imageControls.image1ID);
        var image2 = document.getElementById(this.imageControls.image2ID);

        var captionContainer = document.getElementById(this.caption.captionContainerID);
        var caption1 = document.getElementById(this.caption.caption1ID);
        var caption2 = document.getElementById(this.caption.caption2ID);

        var notImageControls = (functionEvent.fromElement != imageContainer) && (functionEvent.fromElement != image1) && (functionEvent.fromElement != image2);
        var notCaptionControls = (functionEvent.fromElement != captionContainer) && (functionEvent.fromElement != caption1) && (functionEvent.fromElement != caption2);

        var notControlBoxControls = (functionEvent.fromElement != controlBox);

        if (this.controlsBox.firstImageButton) {
            var firstImageButton = document.getElementById(this.controlsBox.firstImageButtonID);
            notControlBoxControls = (notControlBoxControls && (functionEvent.fromElement != firstImageButton));
        }

        if (this.controlsBox.lastImageButton) {
            var lastImageButton = document.getElementById(this.controlsBox.lastImageButtonID);
            notControlBoxControls = (notControlBoxControls && (functionEvent.fromElement != lastImageButton));
        }

        if (this.controlsBox.nextImageButton) {
            var nextImageButton = document.getElementById(this.controlsBox.nextImageButtonID);
            notControlBoxControls = (notControlBoxControls && (functionEvent.fromElement != nextImageButton));
        }

        if (this.controlsBox.playPauseButton) {
            var playPauseImageButton = document.getElementById(this.controlsBox.playPauseButtonID);
            notControlBoxControls = (notControlBoxControls && (functionEvent.fromElement != playPauseImageButton));
        }

        if (this.controlsBox.previousImageButton) {
            var previousImageButton = document.getElementById(this.controlsBox.previousImageButtonID);
            notControlBoxControls = (notControlBoxControls && (functionEvent.fromElement != previousImageButton));
        }

        if (notImageControls && notCaptionControls && notControlBoxControls) {
            $telerik.$(controlBox).stop(true);

            controlBox.style.display = 'block';
            $telerik.$(controlBox).animate({ opacity: 1 }, 500);
        }
    }

    // ShowCurrentImage method
    this.ShowCurrentImage = function () {
        this.PrepareAnimationObjects();
    }

    // PrepareAnimationObjects
    this.PrepareAnimationObjects = function () {
        var ISSlideShow = this;

        var ISSlideShowPreviousImage = this.images[this.previousImageIndex];
        var ISSlideShowImage = this.images[this.shownImageIndex];

        // Start: Preparing images for animation
        var image1 = document.getElementById(this.imageControls.image1ID);
        var image2 = document.getElementById(this.imageControls.image2ID);
        var videoPanel1 = document.getElementById(this.imageControls.videoPanel1ID);
        var videoPanel2 = document.getElementById(this.imageControls.videoPanel2ID);

        // Finding currently displayed image or video element
        if (ISSlideShowPreviousImage.imageType == 'image') {
            if ($telerik.$(image1).css('opacity') == 1) { this.animation.ImageToFadeOut = image1 }
            else { this.animation.ImageToFadeOut = image2 }
        }
        else {
            if ($telerik.$(videoPanel1).css('display') == 'block') { this.animation.ImageToFadeOut = videoPanel1 }
            else { this.animation.ImageToFadeOut = videoPanel2 }
        }

        // Finding available image or video element to display next
        if (ISSlideShowImage.imageType == 'image') {
            if (ISSlideShowPreviousImage.imageType == 'image') {
                if (this.animation.ImageToFadeOut == image1) { this.animation.ImageToFadeIn = image2; }
                else { this.animation.ImageToFadeIn = image1 }
            }
            else { this.animation.ImageToFadeIn = image1; }
        }
        else {
            if (ISSlideShowPreviousImage.imageType == 'image') { this.animation.ImageToFadeIn = videoPanel1; }
            else {
                if (this.animation.ImageToFadeOut == videoPanel1) { this.animation.ImageToFadeIn = videoPanel2; }
                else { this.animation.ImageToFadeIn = videoPanel1 }
            }
        }
        // End: Preparing images for animation

        // Start: Preparing captions for animation
        if (this.caption.displayCaption) {
            var HTMLElement_CurrentCaption = document.createElement('div');
            HTMLElement_CurrentCaption.innerHTML = ISSlideShowImage.imageCaption;

            var HTMLElement_PreviousCaption = document.createElement('div');
            HTMLElement_PreviousCaption.innerHTML = ISSlideShowPreviousImage.imageCaption;

            var captionContainer = document.getElementById(this.caption.captionContainerID);
            var caption1 = document.getElementById(this.caption.caption1ID);
            var caption2 = document.getElementById(this.caption.caption2ID);

            if (this.animation.CaptionToEnter.children[0].innerHTML != HTMLElement_CurrentCaption.innerHTML) {
                //if (caption1.children[0].innerHTML != HTMLTestElement.innerHTML)
                if (Math.round($telerik.$(caption1).css('opacity')) == 0) {
                    this.animation.CaptionToEnter = caption1;
                    this.animation.CaptionToLeave = caption2;
                }
                else {
                    this.animation.CaptionToEnter = caption2;
                    this.animation.CaptionToLeave = caption1
                }
                this.animation.CaptionToEnter.children[0].innerHTML = ISSlideShowImage.imageCaption;
            }
        }
        // Start: Preparing captions for animation

        // Start: Calculating thumbnails scrolling
        this.animation.ThumbnailsNewPosition = null;
        if ((this.thumbnails.displayThumbnails) && (!this.thumbnails.thumbnailsAreManualyScrolled)) {
            var thumbnailsList = document.getElementById(this.thumbnails.thumbnailsListControlID);
            var imageThumbnailControl = document.getElementById(ISSlideShowImage.imageThumbnail.imageThumbnailControlID);

            var thumbnailsListWidth = thumbnailsList.offsetWidth;
            var thumbnailsWidth = this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsWidth;
            var thumbnailsPosition = parseInt(thumbnailsList.style.left.replace('px', ''));

            var imageThumbnailControlPositionX = imageThumbnailControl.offsetLeft;
            var thumbnailInContainerPosition = parseInt((thumbnailsWidth / 2) - 35);

            if ((imageThumbnailControlPositionX > thumbnailInContainerPosition) &&
                ((imageThumbnailControlPositionX - thumbnailInContainerPosition) <= (thumbnailsListWidth - thumbnailsWidth))) {
                this.animation.ThumbnailsNewPosition = imageThumbnailControlPositionX - thumbnailInContainerPosition;
            }

            if ((imageThumbnailControlPositionX <= thumbnailInContainerPosition) && (-thumbnailsPosition > imageThumbnailControlPositionX)) {
                this.animation.ThumbnailsNewPosition = 0;
            }

            if (((imageThumbnailControlPositionX - thumbnailInContainerPosition) > (thumbnailsListWidth - thumbnailsWidth)) &&
                ((thumbnailsPosition + imageThumbnailControlPositionX + 70) > thumbnailsWidth)) {
                this.animation.ThumbnailsNewPosition = thumbnailsListWidth - thumbnailsWidth;
            }

            this.animation.ThumbnailToFadeIn = document.getElementById(ISSlideShowImage.imageThumbnail.imageThumbnailControlID);
            if (ISSlideShowImage.imageThumbnail.activeImageURL != '') {
                this.animation.ThumbnailToFadeIn = this.animation.ThumbnailToFadeIn.children[0].children[1];
            }

            if (this.shownImageIndex != this.previousImageIndex) {
                this.animation.ThumbnailToFadeOut = document.getElementById(this.images[this.previousImageIndex].imageThumbnail.imageThumbnailControlID);
                if (ISSlideShowPreviousImage.imageThumbnail.activeImageURL != '') {
                    this.animation.ThumbnailToFadeOut = this.animation.ThumbnailToFadeOut.children[0].children[1];
                }
            }
        }
        // End: Calculating thumbnails scrolling

        if (ISSlideShowImage.imageType == 'image') {
            var DummyImage = new Image();
            DummyImage.src = IS_SlideShow_GetDynamicImageURL(ISSlideShowImage.imageURL, this.slideshowComputedStyle.imageComputedStyle.imageContentWidth, this.slideshowComputedStyle.imageComputedStyle.imageContentHeight);
            if (this.imageOptions.imageRender == 'HtmlImage') {
                if (DummyImage.complete) {
                    ISSlideShow.PreloadCurrentImage(DummyImage);
                }
                else {
                    $telerik.$(DummyImage).load(function () { ISSlideShow.PreloadCurrentImage(DummyImage) });
                }
            }
            else {
                this.animation.ImageToFadeIn.style.backgroundImage = "url('" + IS_SlideShow_GetDynamicImageURL(ISSlideShowImage.imageURL, this.slideshowComputedStyle.imageComputedStyle.imageContentWidth, this.slideshowComputedStyle.imageComputedStyle.imageContentHeight) + "')";
                $telerik.$(DummyImage).load(function () { ISSlideShow.PreloadDummyImage(DummyImage) });
            }
        }
        else {
            while (this.animation.ImageToFadeIn.childNodes[0]) {
                this.animation.ImageToFadeIn.removeChild(this.animation.ImageToFadeIn.childNodes[0]);
            }

            this.animation.ImageToFadeIn.innerHTML = decodeURIComponent(ISSlideShowImage.imageURL);
            var VideoFrame = this.animation.ImageToFadeIn.children[0];
            VideoFrame.style.width = this.slideshowComputedStyle.imageComputedStyle.imageContentWidth + 'px';
            VideoFrame.style.height = this.slideshowComputedStyle.imageComputedStyle.imageContentHeight + 'px';
            if (VideoFrame.src.indexOf('youtube') != -1) {
                VideoFrame.src += '?wmode=transparent&controls=0&modestbranding=1;&showinfo=0';
            }
            else if (VideoFrame.src.indexOf('vimeo') != -1) {
                VideoFrame.src += '?title=0&byline=0&portrait=1;&showinfo=0';
            }
            $telerik.$(VideoFrame).load(function () { ISSlideShow.animation.animationTimer = 0; ISSlideShow.SwitchImages() });
        }
    }

    // PreloadCurrentImage
    this.PreloadCurrentImage = function (DummyImage) {
        var ISSlideShowImage = this.images[this.shownImageIndex];
        ISSlideShowImage.imageRealWidth = DummyImage.naturalWidth;
        ISSlideShowImage.imageRealHeight = DummyImage.naturalHeight;
        DummyImage = null;

        var ISSlideShow = this;
        this.animation.ImageToFadeIn.src = IS_SlideShow_GetDynamicImageURL(ISSlideShowImage.imageURL, this.slideshowComputedStyle.imageComputedStyle.imageContentWidth, this.slideshowComputedStyle.imageComputedStyle.imageContentHeight);

        //this.animation.ImageToFadeIn.onload = function () { ISSlideShow.SwitchImages() }; ## changed by assaf - onLoad event was not firing
        this.SwitchImages();
    }

    // PreloadDummyImage
    this.PreloadDummyImage = function (DummyImage) {
        var ISSlideShowImage = this.images[this.shownImageIndex];
        ISSlideShowImage.imageRealWidth = DummyImage.naturalWidth;
        ISSlideShowImage.imageRealHeight = DummyImage.naturalHeight;
        this.SwitchImages();
    }

    // SwitchImages
    this.SwitchImages = function () {
        var ISSlideShow = this;

        var ISSlideShowPreviousImage = this.images[this.previousImageIndex];
        var ISSlideShowImage = this.images[this.shownImageIndex];

        // Start: Preparing images for animation
        if (ISSlideShowImage.imageType == 'image') { this.InitializeImage(this.animation.ImageToFadeIn, ISSlideShowImage); }

        this.animation.ImageToFadeOut.onclick = null;
        // End: Preparing images for animation

        // Start: animation
        $telerik.$(this.animation.ImageToFadeOut).stop(true);
        if (this.caption.displayCaption) { $telerik.$(this.animation.CaptionToLeave).stop(true); }

        if (this.thumbnails.displayThumbnails) {
            if (!this.thumbnails.thumbnailsAreManualyScrolled) { $telerik.$("#" + this.thumbnails.thumbnailsListControlID).stop(true); }

            if (ISSlideShowImage.imageThumbnail.activeImageURL != '') {
                var ThumbnailImageToStopAnimation = document.getElementById(this.images[this.previousImageIndex].imageThumbnail.imageThumbnailControlID).children[0].children[1];
                $telerik.$(ThumbnailImageToStopAnimation).stop(true)
            }
            else {
                $telerik.$("#" + this.images[this.previousImageIndex].imageThumbnail.imageThumbnailControlID).stop(true);
            }
        }

        // Start: Images Animation
        if ((ISSlideShowImage.imageType == 'image') && (ISSlideShowPreviousImage.imageType == 'image')) {
            $telerik.$(this.animation.ImageToFadeIn).animate({ opacity: 1 }, this.animation.animationSpeed, function () { ISSlideShow.ImageToFadeInAfterAnimation() });
            $telerik.$(this.animation.ImageToFadeOut).animate({ opacity: 0 }, this.animation.animationSpeed, function () { ISSlideShow.ImageToFadeOutAfterAnimation(); });
        }
        else if ((ISSlideShowImage.imageType == 'image') && (ISSlideShowPreviousImage.imageType == 'video')) {
            $telerik.$(this.animation.ImageToFadeIn).animate({ opacity: 1 }, this.animation.animationSpeed, function () { ISSlideShow.ImageToFadeInAfterAnimation() });
            $telerik.$(this.animation.ImageToFadeOut).css('display', 'none');
            $telerik.$(this.animation.ImageToFadeOut).css('z-index', 0);

            while (this.animation.ImageToFadeOut.childNodes[0]) {
                this.animation.ImageToFadeOut.removeChild(this.animation.ImageToFadeOut.childNodes[0]);
            }
        }
        else if ((ISSlideShowImage.imageType == 'video') && (ISSlideShowPreviousImage.imageType == 'image')) {
            $telerik.$(this.animation.ImageToFadeIn).css('display', 'block');
            $telerik.$(this.animation.ImageToFadeIn).css('z-index', 1);
            $telerik.$(this.animation.ImageToFadeOut).css('opacity', '0');
            $telerik.$(this.animation.ImageToFadeOut).css('z-index', 0);
            //$telerik.$(this.animation.ImageToFadeOut).animate({ opacity: 0 }, this.animation.animationSpeed, function () { ISSlideShow.ImageToFadeOutAfterAnimation(); });
        }
        else {
            $telerik.$(this.animation.ImageToFadeIn).css('display', 'block');
            $telerik.$(this.animation.ImageToFadeIn).css('z-index', 1);
            $telerik.$(this.animation.ImageToFadeOut).css('display', 'none');
            $telerik.$(this.animation.ImageToFadeOut).css('z-index', 0);

            while (this.animation.ImageToFadeOut.childNodes[0]) {
                this.animation.ImageToFadeOut.removeChild(this.animation.ImageToFadeOut.childNodes[0]);
            }
            // setTimeout(function () { ISSlideShow.Play() }, this.animation.animationSpeed);
        }
        // End: Images Animation

        // Start: Caption Animation
        if (this.caption.displayCaption) {
            if (this.caption.CaptionAnimation == 'fading') {
                $telerik.$(this.animation.CaptionToEnter).animate({ opacity: 1 }, this.animation.animationSpeed, function () { $telerik.$(ISSlideShow.animation.CaptionToEnter).css('z-index', 1); });
                $telerik.$(this.animation.CaptionToLeave).animate({ opacity: 0 }, this.animation.animationSpeed, function () { $telerik.$(ISSlideShow.animation.CaptionToLeave).css('z-index', 0); });
            }
            //$telerik.$(this.animation.CaptionToLeave).animate({ left: -this.slideshowComputedStyle.captionComputedStyle.captionWidth }, parseInt(this.animation.animationSpeed/2), function () { ISSlideShow.CaptionToLeaveAfterAnimationAdjustments() } );
        }
        // End: Caption Animation

        if (this.thumbnails.displayThumbnails) {
            if (this.animation.ThumbnailToFadeIn != null) {
                $telerik.$(this.animation.ThumbnailToFadeIn).animate({ opacity: 1 }, this.animation.animationSpeed, function () { ISSlideShow.ThumbnailsToFadeInAfterAnimation(); });
            }

            if (this.animation.ThumbnailToFadeOut != null) {
                if (this.thumbnails.thumbnailsStyle == 'numbers') {
                    var ThumbnailToFadeOut = ISSlideShow.animation.ThumbnailToFadeOut;
                    this.animation.ThumbnailToFadeOut.className = this.slideshowCssPrefix + 'IS_SlideShow_ThumbnailsListItem';
                    this.animation.ThumbnailToFadeOut.onmouseout = function () { ThumbnailToFadeOut.className = ISSlideShow.slideshowCssPrefix + 'IS_SlideShow_ThumbnailsListItem'; };
                    this.animation.ThumbnailToFadeOut.onmouseover = function () { ThumbnailToFadeOut.className = ISSlideShow.slideshowCssPrefix + 'IS_SlideShow_ThumbnailsListItem_Hover'; };
                }

                if (this.animation.ThumbnailToFadeOut.nodeName == 'LI') {
                    $telerik.$(this.animation.ThumbnailToFadeOut).animate({ opacity: 0.5 }, this.animation.animationSpeed, function () { ISSlideShow.ThumbnailsToFadeOutAfterAnimation(); });
                }
                else {
                    $telerik.$(this.animation.ThumbnailToFadeOut).animate({ opacity: 0 }, this.animation.animationSpeed);
                }

            }

            if (this.animation.ThumbnailsNewPosition != null && !this.thumbnails.thumbnailsAreManualyScrolled) {
                $telerik.$("#" + this.thumbnails.thumbnailsListControlID).animate({ left: -this.animation.ThumbnailsNewPosition + 'px' }, this.animation.animationSpeed);
            }
        }

        this.animation.animationInProgress = false;
        // End: animation
    }

    // ImageToFadeInAfterAnimation
    this.ImageToFadeInAfterAnimation = function () {
        var ISSlideShow = this;

        if (this.caption.displayCaption) {
            if (this.caption.CaptionAnimation == 'sliding') {
                this.animation.CaptionToLeave.style.display = 'none';
                this.animation.CaptionToLeave.style.left = -this.slideshowComputedStyle.captionComputedStyle.captionWidth + 'px';
                this.animation.CaptionToEnter.style.display = 'block';

                var CpationLeft = this.slideshowComputedStyle.captionComputedStyle.captionMarginLeft
                                  + this.slideshowComputedStyle.captionComputedStyle.captionBorderLeft
                                  + this.slideshowComputedStyle.captionComputedStyle.captionPaddingLeft;

                $telerik.$(this.animation.CaptionToEnter).animate({ left: CpationLeft }, 500, function () { ISSlideShow.CaptionToEnterAfterAnimationAdjustments(); });
            }
        }

        ISSlideShow.Play();
        $telerik.$(ISSlideShow.animation.ImageToFadeIn).css('z-index', 1);
    }

    // ImageToFadeOutAfterAnimation
    this.ImageToFadeOutAfterAnimation = function () {
        var ISSlideShow = this;

        var ISSlideShowPreviousImage = this.images[this.previousImageIndex];
        var ISSlideShowImage = this.images[this.shownImageIndex];

        if (ISSlideShowPreviousImage.imageType == 'image') { $telerik.$(ISSlideShow.animation.ImageToFadeOut).css('z-index', 0); }
        if (ISSlideShowImage.imageType == 'video') {
            $telerik.$(ISSlideShow.animation.ImageToFadeIn).css('display', 'block');
            $telerik.$(ISSlideShow.animation.ImageToFadeIn).css('z-index', 1);
            // ISSlideShow.Play();
        }
    }

    // CaptionToEnterAfterAnimationAdjustments
    this.CaptionToEnterAfterAnimationAdjustments = function () { }

    // CaptionToLeaveAfterAnimationAdjustments
    this.CaptionToLeaveAfterAnimationAdjustments = function () {
        //$telerik.$(this.animation.CaptionToLeave).css('z-index', 0);
        this.animation.CaptionToLeave.style.display = 'none';
    }

    // ThumbnailsToFadeInAfterAnimation
    this.ThumbnailsToFadeInAfterAnimation = function () {
        var ISSlideShow = this;
        var ThumbnailToFadeIn = this.animation.ThumbnailToFadeIn;
        if (this.thumbnails.thumbnailsStyle == 'numbers') {
            this.animation.ThumbnailToFadeIn.className = this.slideshowCssPrefix + 'IS_SlideShow_ThumbnailsListItem_Active';
            this.animation.ThumbnailToFadeIn.onmouseover = null;
            this.animation.ThumbnailToFadeIn.onmouseout = function () { ThumbnailToFadeIn.className = ISSlideShow.slideshowCssPrefix + 'IS_SlideShow_ThumbnailsListItem_Active'; };
        }
    }

    // ThumbnailsToFadeOutAfterAnimation
    this.ThumbnailsToFadeOutAfterAnimation = function () { }

    // ThumbnailHover
    this.ThumbnailHover = function (ImageIndex) {
        if (this.images.length <= ImageIndex) { ImageIndex = this.images.length - 1; }
        var ThumbnailLI = document.getElementById(this.images[ImageIndex].imageThumbnail.imageThumbnailControlID);
        var ThumbnailAnchor = ThumbnailLI.children[0];

        var ThumbnailImage = null;
        for (ChildrenIndex = 0; ChildrenIndex <= ThumbnailAnchor.children.length - 1; ChildrenIndex++) {
            if (ThumbnailAnchor.children[ChildrenIndex].id.toLowerCase().indexOf('thumbnailimagehover') > -1) {
                ThumbnailImage = ThumbnailAnchor.children[ChildrenIndex];
            }
        }

        if (ThumbnailImage != null) {
            ThumbnailImage.style.display = 'block';
        }
    }

    // ThumbnailHoverOut
    this.ThumbnailHoverOut = function (ImageIndex) {
        if (this.images.length <= ImageIndex) { ImageIndex = this.images.length - 1; }
        var ThumbnailLI = document.getElementById(this.images[ImageIndex].imageThumbnail.imageThumbnailControlID);
        var ThumbnailAnchor = ThumbnailLI.children[0];

        var ThumbnailImage = null;
        for (ChildrenIndex = 0; ChildrenIndex <= ThumbnailAnchor.children.length - 1; ChildrenIndex++) {
            if (ThumbnailAnchor.children[ChildrenIndex].id.toLowerCase().indexOf('thumbnailimagehover') > -1) {
                ThumbnailImage = ThumbnailAnchor.children[ChildrenIndex];
            }
        }

        if (ThumbnailImage != null) {
            ThumbnailImage.style.display = 'none';
        }
    }

    //ThumbnailsScroll method
    this.ThumbnailsScroll = function (functionEvent) {
        var scrollAreaWidth = parseInt((this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsWidth / 2) * 0.5);

        var thumbnailsContainer = document.getElementById(this.thumbnails.thumbnailsContainerID);
        var thumbnailsList = document.getElementById(this.thumbnails.thumbnailsListControlID);

        var thumbnailsLeftPosition = parseInt(thumbnailsList.style.left.replace('px', ''));

        var mouseOffsetX = functionEvent.layerX;
        var parentElement = functionEvent.target;

        while (parentElement != thumbnailsContainer) {
            mouseOffsetX += parentElement.offsetLeft;
            parentElement = parentElement.parentNode;
        }

        if (mouseOffsetX <= scrollAreaWidth) {
            var scrollSpeed = this.Thumbnails_GetScrollSpeedLeft(mouseOffsetX);
            if ((this.thumbnails.mouseOffsetX != mouseOffsetX)
                && (this.thumbnails.scrollSpeed != scrollSpeed)) {
                this.thumbnails.mouseOffsetX = mouseOffsetX;
                this.thumbnails.scrollSpeed = scrollSpeed;
                this.thumbnails.thumbnailsAreManualyScrolled = true;
                this.ThumbnailsScrollLeft(scrollSpeed);
            }
        }
        else if (mouseOffsetX > (thumbnailsContainer.offsetWidth - scrollAreaWidth)) {
            var scrollSpeed = this.Thumbnails_GetScrollSpeedRight(mouseOffsetX);
            if ((this.thumbnails.mouseOffsetX != mouseOffsetX)
                && (this.thumbnails.scrollSpeed != scrollSpeed)) {
                this.thumbnails.mouseOffsetX = mouseOffsetX;
                this.thumbnails.scrollSpeed = scrollSpeed;
                this.thumbnails.thumbnailsAreManualyScrolled = true;
                this.ThumbnailsScrollRight(scrollSpeed);
            }
        }
        else {
            clearTimeout(this.thumbnails.thumbnailsTimer);
            this.thumbnails.mouseOffsetX = 0;
            this.thumbnails.scrollSpeed = 0;
            this.thumbnails.thumbnailsAreManualyScrolled = false;
        }
    }

    //Thumbnails_GetScrollLeftSpeed
    this.Thumbnails_GetScrollSpeedLeft = function (mouseOffsetX) {
        var scrollAreaWidth = parseInt((this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsWidth / 2) * 0.5);
        var scrollRation = parseInt(scrollAreaWidth / 5);

        var scrollSpeed = parseInt((scrollAreaWidth - mouseOffsetX) / scrollRation);
        scrollSpeed += 1;

        return scrollSpeed;
    }

    //ThumbnailsScrollLeft method
    this.ThumbnailsScrollLeft = function (scrollSpeed) {
        clearTimeout(this.thumbnails.thumbnailsTimer);

        var thumbnailsList = document.getElementById(this.thumbnails.thumbnailsListControlID);
        var thumbnailsLeftPosition = parseInt(thumbnailsList.style.left.replace('px', ''));

        var thumbnailsNewPosition = (thumbnailsLeftPosition + scrollSpeed);

        if (thumbnailsNewPosition >= 0) {
            thumbnailsList.style.left = '0px';
            this.thumbnails.thumbnailsAreManualyScrolled = false;
            return;
        }

        $telerik.$(thumbnailsList).clearQueue();

        thumbnailsList.style.left = thumbnailsNewPosition + 'px';

        var ISSlideShow = this;
        this.thumbnails.thumbnailsTimer = setTimeout(function () { ISSlideShow.ThumbnailsScrollLeft(scrollSpeed) }, 10);
    }

    //Thumbnails_GetScrollLeftSpeed
    this.Thumbnails_GetScrollSpeedRight = function (mouseOffsetX) {
        var thumbnailsWidth = this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsWidth;
        var scrollAreaWidth = parseInt((thumbnailsWidth / 2) * 0.5);
        var scrollRation = parseInt(scrollAreaWidth / 5);
        var adjustedLayerX = mouseOffsetX - (thumbnailsWidth - scrollAreaWidth);
        var scrollSpeed = parseInt(adjustedLayerX / scrollRation);
        scrollSpeed += 1;

        return scrollSpeed;
    }

    //ThumbnailsScrollRight method
    this.ThumbnailsScrollRight = function (scrollSpeed) {
        clearTimeout(this.thumbnails.thumbnailsTimer);

        var thumbnailsWidth = this.slideshowComputedStyle.thumbnailsComputedStyle.thumbnailsWidth;
        var thumbnailsList = document.getElementById(this.thumbnails.thumbnailsListControlID);
        var thumbnailsLeftPosition = parseInt(thumbnailsList.style.left.replace('px', ''));
        var thumbnailsListWidth = parseInt(thumbnailsList.offsetWidth);

        var thumbnailsNewPosition = (thumbnailsLeftPosition - scrollSpeed);

        if (thumbnailsNewPosition <= thumbnailsWidth - thumbnailsListWidth) {
            thumbnailsList.style.left = (thumbnailsWidth - thumbnailsListWidth) + 'px';
            this.thumbnails.thumbnailsAreManualyScrolled = false;
            return;
        }

        $telerik.$(thumbnailsList).clearQueue();

        thumbnailsList.style.left = thumbnailsNewPosition + 'px';

        var ISSlideShow = this;
        this.thumbnails.thumbnailsTimer = setTimeout(function () { ISSlideShow.ThumbnailsScrollRight(scrollSpeed) }, 10);
    }

    //ThumbnailsScrollStop method
    this.ThumbnailsScrollStop = function (functionEvent) {
        var thumbnailsContainer = document.getElementById(this.thumbnails.thumbnailsContainerID);

        var IsThumbnailsControl = (functionEvent.relatedTarget == thumbnailsContainer);

        var thumbnailsList = thumbnailsContainer.children[0];

        IsThumbnailsControl = IsThumbnailsControl || (functionEvent.relatedTarget == thumbnailsList);

        for (childIndex = 0; childIndex <= thumbnailsList.children.length - 1; childIndex++) {
            var thumbnailListItem = thumbnailsList.children[childIndex];
            IsThumbnailsControl = IsThumbnailsControl || (functionEvent.relatedTarget == thumbnailListItem);
            IsThumbnailsControl = IsThumbnailsControl || (functionEvent.relatedTarget == thumbnailListItem.children[0]);
            IsThumbnailsControl = IsThumbnailsControl || (functionEvent.relatedTarget == thumbnailListItem.children[0].children[0]);
        }

        if (!IsThumbnailsControl) {
            clearTimeout(this.thumbnails.thumbnailsTimer);
            this.thumbnails.thumbnailsAreManualyScrolled = false;
        }
    }
}

function IS_SlideShow_Animation() {
    this.animation = 'fade in'; // fade in;
    this.animationSpeed = 1000;
    this.animationInProgress = false;
    // Animation Objects
    this.CaptionToFadeIn = null;
    this.CaptionToFadeOut = null;
    this.CaptionToEnter = null;
    this.CaptionToLeave = null;
    this.ThumbnailToFadeIn = null;
    this.ThumbnailToFadeOut = null;
    this.ThumbnailsNewPosition = null;
}

function IS_SlideShow_Autoplay() {
    this.autoplay = true; // true;false
    this.autoplaySpeed = 3000; // in miliseconds
    this.play = true;
    this.slideshowTimer = null;
}

function IS_SlideShow_Caption() {
    this.CaptionAnimation = 'fading'; // fading, sliding
    this.displayCaption = true; // true; false
    this.caption1ID = '';
    this.caption2ID = '';
    this.captionContainerID = '';
    this.captionPosition = 'bottom'; // bottom; top
}

function IS_SlideShow_Controls() {
    this.displayControls = false;
    this.firstImageButton = false; // true; false
    this.firstImageButtonID = '';
    this.lastImageButton = false; // true; false
    this.lastImageButtonID = '';
    this.nextImageButton = false; // true; false
    this.nextImageButtonID = '';
    this.playPauseButton = false; // true; false
    this.playPauseButtonID = '';
    this.previousImageButton = false; // true; false
    this.previousImageButtonID = '';
}

function IS_SlideShow_Image() {
    this.imageCaption = ''; // caption to display in the caption container when image is shown
    this.imageLink = ''; // URL for the image's target when image is clicked
    this.imageLink_ButtonImageURL = ''; // If imageLinkOption = 'Button' this URL is used for the image displayed in the button that on click redirect to URL specified in imageLink
    this.imageRealHeight = 0; // original height of the image as in file
    this.imageRealWidth = 0; // original width of the image as in file
    this.imageType = 'image' // image; video
    this.imageURL = ''; // URL to the image
    this.imageThumbnail = new IS_SlideShow_ImageThumbnail();
}

function IS_SlideShow_ImageControls() {
    this.imageContainerID = '';
    this.image1ID = '';
    this.image2ID = '';
    this.videoPanel1ID = '';
    this.videoPanel2ID = '';
}

function IS_SlideShow_ImageLinkOptions() {
    this.useButton = false; // true - image is not clickable and special button is rendered to redirect to URL specified for the image;
    // false - image is clickable and on click redirects to URL specified for the image
    this.linkButtonID = ''; // id of the button element that is used to redirect to the URL specified for the image shown at current time
}

function IS_SlideShow_ImageOptions() {
    this.imageLinkOptions = new IS_SlideShow_ImageLinkOptions();
    this.imageRender = 'HtmlImage'; // HtmlImage; BackGround
}

function IS_SlideShow_ImageThumbnail() {
    this.activeImageURL = '';
    this.hoverImageURL = '';
    this.imageURL = '';
    this.imageThumbnailControlID = '';
}

function IS_SlideShow_ResizeOptions() {
    this.CenterHorizontally = false;
    this.CenterVertically = false;
    this.resize = false;
    this.Resize_MinWidth = 0;
    this.Resize_MinHeight = 0;
    this.Resize_LockDimensions = false;
}

function IS_SlideShow_Thumbnails() {
    this.displayThumbnails = true; // true; false
    this.mouseOffsetX = 0;
    this.scrollSpeed = 0;
    this.thumbnailsAreManualyScrolled = false;
    this.thumbnailsContainerID = '';
    this.thumbnailsListControlID = '';
    this.thumbnailsPosition = 'bottom'; // bottom; top; middle
    this.thumbnailsTimer = null;
    this.thumbnailsStyle = 'images'; // images; numbers
}

//Start: Applyed CSS Rules

function IS_SlideShow_ApplyedCSSRules() {
    this.IS_SlideShow_MainContainer = null;
    this.IS_SlideShow_ImagesContainer = null;
    this.IS_SlideShow_CaptionContainer = null;
    this.IS_SlideShow_Caption = null;
    this.IS_SlideShow_ThumbnailsContainer = null;
    this.IS_SlideShow_ThumbnailsList = null;
    this.IS_SlideShow_ThumbnailsListItem = null;
    this.IS_SlideShow_ThumbnailsListItem_Hover = null;
    this.IS_SlideShow_Controls_FirstImageButton = null;
    this.IS_SlideShow_Controls_PreviousImageButton = null;
    this.IS_SlideShow_Controls_PlayPauseImageButton = null;
    this.IS_SlideShow_Controls_NextImageButton = null;
    this.IS_SlideShow_Controls_LastImageButton = null;
    this.SlideShow_LoadingMessage = null;
}

//End: Applyed CSS Rules

// Start: Computed Style

function IS_SlideShow_ComputedStyle() {
    this.slideshowBorderBottom = 0;
    this.slideshowBorderLeft = 0;
    this.slideshowBorderRight = 0;
    this.slideshowBorderTop = 0;
    this.captionComputedStyle = new IS_SlideShow_CaptionComputedStyle()
    this.controlsComputedStyle = new IS_SlideShow_Controls_ComputedStyle();
    this.imageComputedStyle = new IS_SlideShow_ImageComputedStyle();
    this.resizeComputedStyle = new IS_SlideShow_ResizeComputedStyle();
    this.slideshowHeight = 0;
    this.slideshowMarginBottom = 0;
    this.slideshowMarginLeft = 0;
    this.slideshowMarginRight = 0;
    this.slideshowMarginTop = 0;
    this.slideshowOriginalWidth = 0;
    this.slideshowOriginalHeight = 0;
    this.slideshowPaddingBottom = 0;
    this.slideshowPaddingLeft = 0;
    this.slideshowPaddingRight = 0;
    this.slideshowPaddingTop = 0;
    this.slideshowWidth = 0;
    this.thumbnailsComputedStyle = new IS_SlideShow_ThumbnailsComputedStyle();
}

function IS_SlideShow_CaptionComputedStyle() {
    this.captionBorderBottom = 0;
    this.captionBorderLeft = 0;
    this.captionBorderRight = 0;
    this.captionBorderTop = 0;
    this.captionHeight = 0;
    this.captionLeft = null
    this.captionMarginBottom = 0;
    this.captionMarginLeft = 0;
    this.captionMarginRight = 0;
    this.captionMarginTop = 0; ;
    this.captionPaddingBottom = 0;
    this.captionPaddingLeft = 0;
    this.captionPaddingRight = 0;
    this.captionPaddingTop = 0;
    this.captionTop = null;
    this.captionWidth = 0;
}

function IS_SlideShow_ImageComputedStyle() {
    this.imageContentHeight = 0;
    this.imageContentWidth = 0;
    this.imageLeft = 0;
    this.imageTop = 0;
}

function IS_SlideShow_ResizeComputedStyle() {
    this.resizeBorderBottom = 0;
    this.resizeBorderLeft = 0;
    this.resizeBorderRight = 0;
    this.resizeBorderTop = 0;
    this.resizeHeight = 0;
    this.resizeMarginBottom = 0;
    this.resizeMarginLeft = 0;
    this.resizeMarginRight = 0;
    this.resizeMarginTop = 0; ;
    this.resizePaddingBottom = 0;
    this.resizePaddingLeft = 0;
    this.resizePaddingRight = 0;
    this.resizePaddingTop = 0;
    this.resizeWidth = 0;
}

function IS_SlideShow_ThumbnailsComputedStyle() {
    this.thumbnailsBorderBottom = 0;
    this.thumbnailsBorderLeft = 0;
    this.thumbnailsBorderRight = 0;
    this.thumbnailsBorderTop = 0;
    this.thumbnailsBottom = null;
    this.thumbnailsHeight = 0;
    this.thumbnailsLeft = null;
    this.thumbnailsListControl = new IS_SlideShow_ThumbnailsListControl_ComputedStyle();
    this.thumbnailsMarginBottom = 0;
    this.thumbnailsMarginLeft = 0;
    this.thumbnailsMarginRight = 0;
    this.thumbnailsMarginTop = 0; ;
    this.thumbnailsPaddingBottom = 0;
    this.thumbnailsPaddingLeft = 0;
    this.thumbnailsPaddingRight = 0;
    this.thumbnailsPaddingTop = 0;
    this.thumbnailsRight = null;
    this.thumbnailsTop = null;
    this.thumbnailsWidth = 0;
}

function IS_SlideShow_ThumbnailsListControl_ComputedStyle() {
    this.listControlBorderBottom = 0;
    this.listControlBorderLeft = 0;
    this.listControlBorderRight = 0;
    this.listControlBorderTop = 0;
    this.listControlHeight = 0;
    this.listControlLeft = null;
    this.listControlMarginBottom = 0;
    this.listControlMarginLeft = 0;
    this.listControlMarginRight = 0;
    this.listControlMarginTop = 0;
    this.listControlPaddingBottom = 0;
    this.listControlPaddingLeft = 0;
    this.listControlPaddingRight = 0;
    this.listControlPaddingTop = 0;
    this.listControlTop = null;
    this.listControlWidth = 0;
}

function IS_SlideShow_Controls_ComputedStyle() {
    this.NextImageButton = new IS_SlideShow_Controls_NextImageButton_ComputedStyle();
    this.PreviousImageButton = new IS_SlideShow_Controls_PreviousImageButton_ComputedStyle();
}

function IS_SlideShow_Controls_NextImageButton_ComputedStyle() {
    this.NextImageButtonBorderBottom = 0;
    this.NextImageButtonBorderLeft = 0;
    this.NextImageButtonBorderRight = 0;
    this.NextImageButtonBorderTop = 0;
    this.NextImageButtonHeight = 0;
    this.NextImageButtonLeft = null;
    this.NextImageButtonMarginBottom = 0;
    this.NextImageButtonMarginLeft = 0;
    this.NextImageButtonMarginRight = 0;
    this.NextImageButtonMarginTop = 0;
    this.NextImageButtonPaddingBottom = 0;
    this.NextImageButtonPaddingLeft = 0;
    this.NextImageButtonPaddingRight = 0;
    this.NextImageButtonPaddingTop = 0;
    this.NextImageButtonTop = null;
    this.NextImageButtonWidth = 0;
}

function IS_SlideShow_Controls_PreviousImageButton_ComputedStyle() {
    this.PreviousImageButtonBorderBottom = 0;
    this.PreviousImageButtonBorderLeft = 0;
    this.PreviousImageButtonBorderRight = 0;
    this.PreviousImageButtonBorderTop = 0;
    this.PreviousImageButtonHeight = 0;
    this.PreviousImageButtonLeft = null;
    this.PreviousImageButtonMarginBottom = 0;
    this.PreviousImageButtonMarginLeft = 0;
    this.PreviousImageButtonMarginRight = 0;
    this.PreviousImageButtonMarginTop = 0;
    this.PreviousImageButtonPaddingBottom = 0;
    this.PreviousImageButtonPaddingLeft = 0;
    this.PreviousImageButtonPaddingRight = 0;
    this.PreviousImageButtonPaddingTop = 0;
    this.PreviousImageButtonTop = null;
    this.PreviousImageButtonWidth = 0;
}

// End: Computed Style

// Start: Helpers

function IS_SlideShow_RemoveCssUnits(cssValue) {
    if (cssValue == null) return '';
    return cssValue.replace('%', '').replace('in', '').replace('cm', '').replace('mm', '').replace('em', '').replace('ex', '').replace('pt', '').replace('pc', '').replace('px', '');
}

function IS_SlideShow_GetDynamicImageURL(ImageURL, Width, Height) {
    ImageURL = ImageURL.replace('+', '[plus]');
    if (ImageURL.replace(/ /g, '') == '') { return ''; }
    if (ImageURL[0] == '/') { ImageURL = ImageURL.substring(1, ImageURL.length); }
    if (window.location.host == 'localhost') {
        return '/infoservenet/D_images/' + Width + '/' + Height + '/x/x/' + ImageURL;
    }
    else {
        return '/D_images/' + Width + '/' + Height + '/x/x/' + ImageURL;
    }
}

// End: Helpers