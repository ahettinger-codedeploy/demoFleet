Y.use( 'node', function( Y ) {
  Y.on('domready', function() {

    if (Y.UA.mobile) {
      Y.one(window).on('orientationchange', loadAllImages);
    } else {
      var timeout;

      Y.one(window).on('resize', function () {
        timeout && timeout.cancel();
        timeout = Y.later(300, this, loadAllImages);
      });
    }

    function loadAllImages () {
      Y.all('img[data-src]').each(function (img) {
        ImageLoader.load(img);
      });
    }

    var logo = Y.one('.banner-content-site-title-logo-tagline #banner-area-wrapper #banner'),
        logoParent = Y.one('.banner-content-site-title-logo-tagline #banner-area-wrapper #banner-wrapper');
    if (logo) {

      function logoResize() {
        if (logo.get('clientWidth') > logoParent.get('clientWidth')) {
          logo.setStyles({
            'maxHeight' : logo.getComputedStyle('height'),
            'height' : 'auto',
            'width' : '100%'
          });
        }
      } 
      
      Y.one(window).on('resize', function() {
        logo.setAttribute('style', '');
        logoResize();
      });
      logoResize();     
    }

    // mobile navigation
    var nav = Y.one('#mobile-navigation');
    if (nav) {
      Y.on('click', function(e) {
        nav.toggleClass('sqs-mobile-nav-open');
        Y.one('body').toggleClass('sqs-mobile-nav-open');
      }, '#mobile-navigation');
    }

    // position shopping cart
    if (Y.one('body.top-navigation-alignment-right') && Y.config.win.innerWidth > 640) {
      Y.later(500, this, function() {
        var shoppingCart = Y.one('.absolute-cart-box'),
            topNavHeight = Y.one('#navigation-top').height();
        if (shoppingCart && topNavHeight) {
          shoppingCart.setStyle('top', topNavHeight + 'px');
        }
      });
    }

    // ensure body is at least as long as the sidebar
    function setPageHeight() {
      if (Y.one('body').get('winWidth') <= 768) {
        Y.one('#content-wrapper').setStyle('minHeight', null);
      } else {
        var sidebarHeights = [];
        if (Y.one('#sidebar-one-wrapper')) {
          sidebarHeights.push(parseInt(Y.one('#sidebar-one-wrapper').getComputedStyle('height')));
        }
        if (Y.one('#sidebar-two-wrapper')) {
          sidebarHeights.push(parseInt(Y.one('#sidebar-two-wrapper').getComputedStyle('height')));
        }
        if (sidebarHeights.length) {
          Y.one('#content-wrapper').setStyle('minHeight', Math.max(sidebarHeights[0], sidebarHeights[1]));
        }
      }

    }
    setPageHeight();

    // set page height on resize as well
    Y.one('window').on('resize', function() {
      setPageHeight();
    });

    // make taps work like clicks
    var move;
    Y.all('.subnav a').each(function(a) {
      a.on('touchstart', function() {
        move = false;
      });
      a.on('touchmove', function() {
        move = true;
      });
      a.on('touchend', function() {
        if (move === false) {
          window.location = a.getAttribute('href');
        }
      });
    });

  });
});
