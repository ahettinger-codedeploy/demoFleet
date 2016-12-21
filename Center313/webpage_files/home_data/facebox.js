/*
 * Facebox (for jQuery)
 * version: 1.2 (05/05/2008)
 * @requires jQuery v1.2 or later
 *
 * Examples at http://famspam.com/facebox/
 *
 * Licensed under the MIT:
 *   http://www.opensource.org/licenses/mit-license.php
 *
 * Copyright 2007, 2008 Chris Wanstrath [ chris@ozmm.org ]
 *
 * Usage:
 *
 *  jQuery(document).ready(function() {
 *    jQuery('a[rel*=facebox]').facebox()
 *  })
 *
 *  <a href="#terms" rel="facebox">Terms</a>
 *    Loads the #terms div in the box
 *
 *  <a href="terms.html" rel="facebox">Terms</a>
 *    Loads the terms.html page in the box
 *
 *  <a href="terms.png" rel="facebox">Terms</a>
 *    Loads the terms.png image in the box
 *
 *
 *  You can also use it programmatically:
 *
 *    jQuery.facebox('some html')
 *    jQuery.facebox('some html', 'my-groovy-style')
 *
 *  The above will open a facebox with "some html" as the content.
 *
 *    jQuery.facebox(function($) {
 *      $.get('blah.html', function(data) { $.facebox(data) })
 *    })
 *
 *  The above will show a loading screen before the passed function is called,
 *  allowing for a better ajaxy experience.
 *
 *  The facebox function can also display an ajax page, an image, or the contents of a div:
 *
 *    jQuery.facebox({ ajax: 'remote.html' })
 *    jQuery.facebox({ ajax: 'remote.html' }, 'my-groovy-style')
 *    jQuery.facebox({ image: 'stairs.jpg' })
 *    jQuery.facebox({ image: 'stairs.jpg' }, 'my-groovy-style')
 *    jQuery.facebox({ div: '#box' })
 *    jQuery.facebox({ div: '#box' }, 'my-groovy-style')
 *
 *  Want to close the facebox?  Trigger the 'close.facebox' document event:
 *
 *    jQuery(document).trigger('close.facebox')
 *
 *  Facebox also has a bunch of other hooks:
 *
 *    loading.facebox
 *    beforeReveal.facebox
 *    reveal.facebox (aliased as 'afterReveal.facebox')
 *    init.facebox
 *
 *  Simply bind a function to any of these hooks:
 *
 *   $(document).bind('reveal.facebox', function() { ...stuff to do after the facebox and contents are revealed... })
 *
 */
(function($) {
  $.facebox = function(data, klass) {
    $.facebox.loading();

    if (data.ajax) fillFaceboxFromAjax(data.ajax, klass);
    else if (data.image) fillFaceboxFromImage(data.image, klass);
    else if (data.div) fillFaceboxFromHref(data.div, klass);
    else if ($.isFunction(data)) data.call($);
    else $.facebox.reveal(data, klass);
  };

  /*
   * Public, $.facebox methods
   */

  $.extend($.facebox, {
    settings: {
      opacity      : 0,
      overlay      : true,
      loadingImage : 'http://assets.sitezoogle.com/common/js/facebox/loading.gif',
      closeImage   : 'http://assets.sitezoogle.com/common/js/facebox/closelabel.gif',
      imageTypes   : [ 'png', 'jpg', 'jpeg', 'gif' ],
      faceboxHtml  : '\
    <div id="facebox" style="display:none;"> \
      <div class="popup"> \
        <table> \
          <tbody> \
            <tr> \
              <td class="tl"/><td class="b"/><td class="tr"/> \
            </tr> \
            <tr> \
              <td class="b"/> \
              <td class="body"> \
                <div class="cntent"> \
                </div> \
                <div class="footer"> \
                  <a href="#" class="close"> \
                    <img src="http://assets.sitezoogle.com/common/js/facebox/closelabel.gif" title="close" class="close_image" /> \
                  </a> \
                </div> \
              </td> \
              <td class="b"/> \
            </tr> \
            <tr> \
              <td class="bl"/><td class="b"/><td class="br"/> \
            </tr> \
          </tbody> \
        </table> \
      </div> \
    </div>'
    },

    loading: function() {
      init();
      if ($('#facebox .loading').length == 1) return true;
      showOverlay();
      
      $('#facebox .cntent').empty();
      // $('#facebox .body').children().hide()
      $('#facebox .cntent').html('<div class="loading"><img src="'+$.facebox.settings.loadingImage+'"/></div>');
      // $('#facebox .body').children().end().append('<div class="loading"><img src="'+$.facebox.settings.loadingImage+'"/></div>')

      $('#facebox').css({
        left: $(window).width() / 2 - ($('#facebox').width() / 2),
        top: ( ( $(window).height() / 2 ) + $(window).scrollTop() ) - ($('#facebox').height() / 2)
        // top: getPageScroll()[1] + (getPageHeight() / 10),
        // left:  $(window).width() / 2 - 205
      }).show();
      
      $(document).bind('keydown.facebox', function(e) {
        if (e.keyCode == 27) $.facebox.close();
        return true;
      });
      $(document).trigger('loading.facebox');
    },

    reveal: function(data, klass) {
      $(document).trigger('beforeReveal.facebox');
      if (klass) $('#facebox .cntent').addClass(klass);
      $('#facebox .cntent').append(data);
      $('#facebox .loading').remove();
      $('#facebox .body').children().fadeIn('normal');
      var t = ( ( $(window).height() / 2 ) + $(window).scrollTop() ) - ($('#facebox table').height() / 2);
      if (t < 0) t = 0;
      $('#facebox').css({
        left: $(window).width() / 2 - ($('#facebox table').width() / 2),
        top: t
      });
      
      // Hack to keep old height until new content is loaded.
/*      $('#facebox .content').height('');
      var h = $('#facebox .cntent').height();
      $('#facebox .cntent').height(h);
  */    
      $(document).trigger('reveal.facebox').trigger('afterReveal.facebox');
    },

    close: function() {
      $(document).trigger('close.facebox');
      return false;
    }
  });

  /*
   * Public, $.fn methods
   */

  $.fn.facebox = function(settings) {
    if ($(this).length == 0) return;

    init(settings);

    function clickHandler() {
      if (this.rel) {
        $.facebox.loading(true);
        // support for rel="facebox.inline_popup" syntax, to add a class
        // also supports deprecated "facebox[.inline_popup]" syntax
        var klass = this.rel.match(/facebox\[?\.(\w+)\]?/);
        if (klass) klass = klass[1];

        fillFaceboxFromHref(this.href, klass);
      } else {
        fillFaceboxFromForm(this);
      }
      return false;
    }

    return this.bind('click.facebox', clickHandler);
  };

  /*
   * Private methods
   */

  // called one time to setup facebox on this page
  function init(settings) {
    if ($.facebox.settings.inited) return true;
    else $.facebox.settings.inited = true;

    $(document).trigger('init.facebox');
    makeCompatible();

    var imageTypes = $.facebox.settings.imageTypes.join('|');
    $.facebox.settings.imageTypesRegexp = new RegExp('\.(' + imageTypes + ')$', 'i');

    if (settings) $.extend($.facebox.settings, settings);
    $('body').append($.facebox.settings.faceboxHtml);

    var preload = [ new Image(), new Image() ];
    preload[0].src = $.facebox.settings.closeImage;
    preload[1].src = $.facebox.settings.loadingImage;

    $('#facebox').find('.b:first, .bl').each(function() {
      preload.push(new Image());
      preload.slice(-1).src = $(this).css('background-image').replace(/url\((.+)\)/, '$1');
    })

    $('#facebox .close').click($.facebox.close);
    $('#facebox .close_image').attr('src', $.facebox.settings.closeImage);
  };

  // getPageScroll() by quirksmode.com
  function getPageScroll() {
    var xScroll, yScroll;
    if (self.pageYOffset) {
      yScroll = self.pageYOffset;
      xScroll = self.pageXOffset;
    } else if (document.documentElement && document.documentElement.scrollTop) {	 // Explorer 6 Strict
      yScroll = document.documentElement.scrollTop;
      xScroll = document.documentElement.scrollLeft;
    } else if (document.body) {// all other Explorers
      yScroll = document.body.scrollTop;
      xScroll = document.body.scrollLeft;
    }
    return new Array(xScroll,yScroll);
  }

  // Adapted from getPageSize() by quirksmode.com
  function getPageHeight() {
    var windowHeight;
    if (self.innerHeight) {	// all except Explorer
      windowHeight = self.innerHeight;
    } else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
      windowHeight = document.documentElement.clientHeight;
    } else if (document.body) { // other Explorers
      windowHeight = document.body.clientHeight;
    }
    return windowHeight
  }

  // Backwards compatibility
  function makeCompatible() {
    var $s = $.facebox.settings;

    $s.loadingImage = $s.loading_image || $s.loadingImage;
    $s.closeImage = $s.close_image || $s.closeImage;
    $s.imageTypes = $s.image_types || $s.imageTypes;
    $s.faceboxHtml = $s.facebox_html || $s.faceboxHtml;
  }
  
  function fillFaceboxFromForm(button) {
    // button.value('Please wait...')
    $(button).attr('value','Please wait...');
    var url = $('#facebox form').attr('action');
    var params = $('#facebox form').serialize();
    // $.facebox.loading(true);
    $.ajax({
       type: "POST",
       url: url,
       data: params,
       success: function(data, textStatus) {
         $('#facebox .cntent').empty();
         $.facebox.reveal(data);
       },
       error: function(requestObject, textStatus, error){
         var redirect_url = requestObject.getResponseHeader("Location");
         if (redirect_url) {
           window.location = redirect_url;
         } else {
           $('#facebox .cntent').empty();
           $.facebox.reveal('<h2>Sorry!</h2><p>We encountered an error, please close this window and try again.</p>');
         }
       }
     });
  }
  
  // Figures out what you want to display and displays it
  // formats are:
  //     div: #id
  //   image: blah.extension
  //    ajax: anything else
  function fillFaceboxFromHref(href, klass) {
    // div
    if (href.match(/#/)) {
      var url    = window.location.href.split('#')[0];
      var target = href.replace(url,'');
      if (target == '#') return;
      $.facebox.reveal($(target).html(), klass);

    // image
    } else if (href.match($.facebox.settings.imageTypesRegexp)) {
      fillFaceboxFromImage(href, klass);
    // ajax
    } else {
      fillFaceboxFromAjax(href, klass);
    }
  }

  function fillFaceboxFromImage(href, klass) {
    var image = new Image()
    image.onload = function() {
      $.facebox.reveal('<div class="image"><img src="' + image.src + '" /></div>', klass);
    };
    image.src = href;
  }

  function fillFaceboxFromAjax(href, klass) {
    $.ajax({
      type: "GET",
      url: href,
      success: function(data, textStatus) {
        $.facebox.reveal(data, klass);
      },
      error: function(requestObject, textStatus, error){
        var redirect_url = requestObject.getResponseHeader("Location");
        if (redirect_url) {
          window.location = redirect_url;
        } else {
          $.facebox.reveal('<h2>Sorry!</h2><p>We encountered an error, please close this window and try again.</p>');
        }
      }
    });
  }
  
  function skipOverlay() {
    return $.facebox.settings.overlay == false || $.facebox.settings.opacity === null;
  }

  function showOverlay() {
    if (skipOverlay()) return;

    if ($('#facebox_overlay').length == 0)
      $("body").append('<div id="facebox_overlay" class="facebox_hide"></div>');

    $('#facebox_overlay').hide().addClass("facebox_overlayBG")
      .css('opacity', $.facebox.settings.opacity)
      .click(function() { $(document).trigger('close.facebox'); })
      .fadeIn(200);
    return false;
  };

  function hideOverlay() {
    if (skipOverlay()) return;

    $('#facebox_overlay').fadeOut(200, function(){
      $("#facebox_overlay").removeClass("facebox_overlayBG");
      $("#facebox_overlay").addClass("facebox_hide");
      $("#facebox_overlay").remove();
    });

    return false;
  };

  /*
   * Bindings
   */

  $(document).bind('close.facebox', function() {
    $(document).unbind('keydown.facebox');
    $('#facebox').fadeOut(function() {
      $('#facebox .cntent').removeClass().addClass('cntent');
      hideOverlay();
      $('#facebox .loading').remove();
    });
  });

})(jQuery);
