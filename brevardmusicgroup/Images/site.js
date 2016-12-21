Y.use('node', 'squarespace-image-loader', function(Y) {

  Y.on('domready', function() {

    var resizer = new Y.Squarespace.ResizeEmitter({timeout: 100});

    var heroImages = Y.all('#hero img');
    resizer.on('resize:end', function() {
      heroImages.each(function(img) { ImageLoader.load(img) });
    });

    // SIDEBAR min-height set

    function setPageHeight() {
      var sidebarHeight;
      if (Y.one('#sidebar')) {
        sidebarHeight = Y.one('#sidebar').getComputedStyle('height');
      }
      if (sidebarHeight) {
        Y.one('#page').setStyle('minHeight', sidebarHeight);
      }
    }

    // run on page load
    setPageHeight();

    // run when sidebar width is tweaked
    if (Y.Global) {
      Y.Global.on('tweak:change', function(f){
        if (f.getName() == 'blogSidebarWidth' ) {
          setPageHeight();
        }
        if (f.getName() == 'page-banner-full-width' ) {
          heroImages.each(function(img) { ImageLoader.load(img) });
        }
      });
    }

  });

});
