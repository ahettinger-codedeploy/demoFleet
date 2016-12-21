
// Site title positioning
function refreshSiteTitlePosition() {

  var bannerImageEl = document.querySelector('#bannerImage'),
      headerEl = document.querySelector('#logo'),
      logoImage = document.querySelector('#logo img'),
      newTop;

  if (logoImage) {
    if (!Y.UA.ie && !logoImage.complete) {
      logoImage.style.opacity = '0';
      logoImage.addEventListener('load', refreshSiteTitlePosition);
      return;
    } else {
      logoImage.style.opacity = '1';
    }
  }

  if (document.querySelector('body.site-title-position-top')) {
    newTop = 0;
  } else if (document.querySelector('body.site-title-position-bottom')) {
    newTop = bannerImageEl.offsetHeight - headerEl.offsetHeight/2;
  } else if (document.querySelector('body.site-title-position-center')) {
    newTop = bannerImageEl.offsetHeight/2 - headerEl.offsetHeight/2;
  }
  headerEl.style.top = newTop + 'px';

  bannerImageEl.style.marginBottom = document.querySelector('body.site-title-position-bottom') ? headerEl.offsetHeight/2 + 'px' : 0;
}

if(document.addEventListener) {
  document.addEventListener && document.addEventListener('DOMContentLoaded', refreshSiteTitlePosition);
} else {  
  document.attachEvent('onreadystatechange', refreshSiteTitlePosition); // IE8
} 


Y.use('node', function(Y) {
  Y.on('domready', function() {

    function heroImage() {
      var heroImage = Y.one('#bannerImage img[data-src]');
      new Y.Squarespace.Loader({
        img: heroImage
      });
    }

    // Global vars
    var body = Y.one('body');

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

    // Center align dropdown menus
    Y.all('#topNav .subnav').each( function(n){
      n.setStyle('marginLeft', -(parseInt(n.getComputedStyle('width'),10)/2) + 'px');
    });

    // Load hero image
    heroImage();

    // Resize image on window resize
    Y.on('resize', function() {
      heroImage();

      // Remove Position
      var bannerImage = Y.one('#bannerImage');
      if (bannerImage) {
        bannerImage.setStyle('backgroundPosition', null);
      }

    }, Y.config.win);

    // run on page load
    setPageHeight();

    // run when sidebar width is tweaked
    if (Y.Squarespace.Management) {
      Y.Squarespace.Management.on('tweak', function(f){
        if (f.getName() === 'blogSidebarWidth' ) {
          setPageHeight();
        }
      });
    }

    // blog events
    if (body.hasClass('collection-type-blog')) {
      Y.one('#page').delegate('click', function(event) {
        event.currentTarget.ancestor('article').one('.sidebar').toggleClass('shown');
      }, '.show-meta a');
    }


    // Mobile Nav ///////////////////////////////////

    if (Y.one('#mobileMenuLink a')) {
      Y.one('#mobileMenuLink a').on('click', function(e){
        var mobileMenuHeight = parseInt(Y.one('#mobileNav .wrapper').get('offsetHeight'),10);
        if (Y.one('#mobileNav').hasClass('menu-open')) {
          new Y.Anim({ node: Y.one('#mobileNav'), to: { height: 0 }, duration: 0.5, easing: 'easeBoth' }).run();
        } else {
          new Y.Anim({ node: Y.one('#mobileNav'), to: { height: mobileMenuHeight }, duration: 0.5, easing: 'easeBoth' }).run();
        }

        Y.one('#mobileNav').toggleClass('menu-open');
      });
    }


    if (Y.Global) {
      Y.Global.on('tweak:change', refreshSiteTitlePosition);
    }

    // Ready
    // Y.all('#canvas').setStyle('opacity', 1);

  });
});

