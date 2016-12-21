
Y.use( 'node', 'event', function() {

  Y.on( 'domready', init );

  function init () {
    console.log('deploy ready');
    textShrink();
    setPageHeight();
    setPageHeight();

    Y.all('#topNav .subnav').each( function(n){
      n.setStyle('marginLeft', -(parseInt(n.getComputedStyle('width'),10)/2) + 'px');
    });

    Y.on( 'resize', function () {
      var bannerImage = Y.one( '#bannerImage' );

      if ( bannerImage ) {
        bannerImage.setStyle( 'backgroundPosition', null );
      }
    } );

    // run when sidebar width is tweaked
    if ( Y.Squarespace.Management ) {
      Y.Squarespace.Management.on( 'tweak', function ( f ) {
        if ( f.getName() === 'blogSidebarWidth' ) {
          setPageHeight();
        }
      } );
    }

    // blog events
    if ( Y.one( 'body' ).hasClass( 'collection-type-blog' ) ) {
      Y.one( '#page' ).delegate( 'click', function( event ) {
        event.currentTarget.ancestor( 'article' ).one( '.sidebar' ).toggleClass( 'shown' );
      }, '.show-meta a' );
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
  }

  function textShrink () {
    // Text shrink.
    Y.all( '.logo a' ).each( function( item ) {
      item.plug( Y.Squarespace.TextShrink, {
        parentEl: item.ancestor( '.logo' )
      } );
    } );
  }

  // SIDEBAR min-height set
  function setPageHeight() {
    var sidebar = Y.one( '#sidebar' );
    var page = Y.one( '#page' );

    if ( sidebar && page ) {
      page.setStyle( 'minHeight', sidebar.get( 'clientHeight' ) );
    }
  }

});
