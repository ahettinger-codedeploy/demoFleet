/**
 * The zoogleNav plugin is used for the front end sites menu system, it assumes the following 
 * HTML structure 
 *		<ul>
 *   		<li>
 *				<a><img /></a>
 *				<ul>
 *					<li></li>
 *        	...
 *      	</ul>
 *			</li>
 *			...
 * 		</ul>
 *
 * Note: It is only designed to handle menus with one sub level.
 *
 * Usage:
 *   jQuery('ul#myMenuUL').zoogleNav();
 * 
 * Additional features: 
 *   For vertical menus give the top level UL a class of 'navMenuVertical'
 * 
 * Dependencies:
 *   jquery.bgiframe (our customised version)
 */
(function($){
	
	// define default options
	var closeTimer  = null;
	var curMenuItem = null;
	var type        = null;
	var config      = {};

	//extend jquery with the plugin
	$.fn.zoogleNav = function(options) {
			config = $.extend({}, $.fn.zoogleNav.defaults, options);
			
			if( $(this).hasClass('navMenuVertical') ) {
				type = $.fn.zoogleNav.TypeVertical;
			} else {
				type = $.fn.zoogleNav.TypeHorizontal;
			}
			
			var isIE6 = ($.browser.msie && navigator.appVersion.indexOf("MSIE 6.0") != -1);

			// iterate and attach the navigation handlers to each menu item
			return this.each(function() {
				var $topLevel = $(this);
				var els = $topLevel.children('li');
				if( type ==  $.fn.zoogleNav.TypeVertical ) {
					// figure	out what direction we need to open for vertical menus
					var openDir = 'right';
					if( $topLevel.closest('.navigation').prev('.header-graphic').length != 0 ) {
						openDir = 'left';
					}
				} else {
					layoutZoogleNav( $topLevel, els );
				}

				$(els).each( function(i,val) {
					$this = $(this);
					
					/* fix the z-index bug for IE on the menu, by giving each top level li a different z-index (but lower than the sub menu li)
					   see: http://nathanostgard.com/archives/2007/5/16/relative_zindex_and_ie/ */
					$this.css( 'zIndex', 100 - i );
					preloadRollOverImage( $this.find('img') );
					
					var ul = $this.find('ul');
					
					// make all the sub-menu items the same width
					var maxWidth = 0;
					$('li', ul)
						.each( function() {
							if( isIE6 ) {
								var $a = $('a', this),
								     w = $a.css('display', 'inline').innerWidth() + 12;
								$a.css('display', 'block');
							} else {
								w = $(this).width();
							}
							if( w > maxWidth ) maxWidth = w;
						})
						.each( function() {
							$(this).width( maxWidth );
						});
					
					ul.width(maxWidth);
					
					if( ul.length != 0 ) {
						ul.bgiframe();
						// calculate & set the position of the sub menu
						if( type == $.fn.zoogleNav.TypeHorizontal ) {
							// horizontal
							// also match the width of the li (if currently smaller) & center underneath
							var ulCurWidth = ul.width();
							if( isIE6 ) {
								// for IE 6 we inspect each of the li's and measure their inline width
								// otherwise they are the full width of the parent menu UL grrrrr
								ulCurWidth = 0;
								$(ul).find('li').each(function() {
									$(this).css('display', 'inline');
									ulCurWidth = Math.max( ulCurWidth, $(this).width() + 25 );
									$(this).css('display', 'block');
								});
							}
							var width = Math.max( $this.innerWidth(), ulCurWidth );
							ul.css({
								'left' : Math.ceil(( $this.innerWidth() - width ) / 2 ) + 'px',
								'top'  : $this.height() + 'px',
								'width': width + 'px'
							});
						} else {
							// vertical
							// offset the sub menu so that the first li will center vertically with the li
							var subLiHeight = $this.find('ul li:first').height();
							var top  = Math.ceil(( $this.height() - subLiHeight ) / 2) + parseInt( $this.find('img').css('margin-top') );
							var left = ( openDir == 'right' ) 
								? $this.width() 
								: ul.width() * -1;
							if( openDir == 'right' && left > $this.closest('ul').width() ) {
								// handle webkit getting positioning wrong
								left = $this.closest('ul').width();
								top  -= subLiHeight;
							}
							ul.css({ 
								'top': top + 'px', 
								'left': left + 'px'
							});
						}
					}
					
					$this.hover(openMenu, startCloseTimer);
				});
			});
			
	};
	
	function preloadRollOverImage(img) {
		$("<img>").attr("src", img.attr('src').replace( '.' + config.imageSuffix, '-over.' + config.imageSuffix) )
			.appendTo('body')
			.css({display: 'none'});
	}
	
	function setNavActivation(isOpen) {
		var ulVis = (isOpen) ? 'visible' : 'hidden';
		setNavImage( curMenuItem.find('img'), isOpen );
		curMenuItem.find('ul').css('visibility', ulVis );
	}
	
	function setNavImage(img, isOpen) {
		var suffix = '.' + config.imageSuffix;
		var swap = [suffix, '-over' + suffix];
		if( !isOpen )	swap.reverse();
		img.attr('src', img.attr('src').replace( swap[0], swap[1] ) );
	};
	
	function openMenu() {
		cancelTimer();
		closeMenu();
		curMenuItem = $(this);
		setNavActivation( true );
	};
	
	function closeMenu() {
		if(curMenuItem) {
			setNavActivation( false );
			curMenuItem = null;
		}
	};
	
	function startCloseTimer() {
		closeTimer = window.setTimeout( closeMenu, config.timeout );
	};
	
	function cancelTimer() {
		if(closeTimer) {
			window.clearTimeout(closeTimer);
			closeTimer = null;
		}
	};
	
	/**
	 * Constants
	 */
	$.fn.zoogleNav.TypeHorizontal = 'horizontal';
	$.fn.zoogleNav.TypeVertical   = 'vertical';
	
	/**
	 * Default options
	 */
	$.fn.zoogleNav.defaults = {
		timeout: 500,
		imageSuffix: 'jpg'
	};
	
})(jQuery);

/**
 * Responsible for laying out (or re-laying out) the zoogle menu
 */
function layoutZoogleNav($topLevel, els) {
	var $ = jQuery;
	if( $topLevel.hasClass('navMenuVertical') ) return;
	if( $topLevel.hasClass('forceNiceRows') || $topLevel.find('li:first').css('float') == 'left' ) {
		// if we're horizontal menu and we want to achieve multiple rows with
		// nice equal number of buttons (has a forceNiceRows class)
		//
		// or if we're a horizontal menu & the top levels are floated then we want to
		// center the menu (for each row)
		var maxWidth = ( $topLevel.css('width') == 'auto' ) ? $topLevel.parent().width() : $topLevel.width();
		var forceNiceRows = $topLevel.hasClass('forceNiceRows');
		if( forceNiceRows ) {
			var wrapAt = $topLevel.attr('className').replace( /.*wrap\-at\-([0-9]+).*/, '$1' );
			if( wrapAt == 0 ) forceNiceRows = false;
			else wrapAt = Math.ceil(els.length / Math.ceil(els.length / wrapAt) );
		} 
		
		var rows = [{width:0,children:[]}];
		var cur = 0;
		
		els.each(function(i) {
			var $li = $(this);
			var tW  = $li.outerWidth(true);
			
			// add a new row when needed
			var addRow = false;
			if( forceNiceRows && i != 0 && i % wrapAt == 0 ) addRow = true;
			if( !forceNiceRows && rows[cur].width + tW > maxWidth ) addRow = true;
			if( addRow ) {
				cur++;
				rows.push({width:0,children:[]});
			}
			
			rows[cur].width += tW;
			rows[cur].children.push( $li );
		});
		
		// make the new rows
		$(rows).each(function() {
			var t = $topLevel.clone().empty();
			$(this.children).each(function() { t.append( this ); } );
			// center them and make sure they clear the previous row (if it has floated li's)
			t.css({
				'padding': '0 ' + Math.max(0, (maxWidth - this.width)/2) + 'px',
				'clear': 'left'
			});
			$topLevel.before( t );
		});
		$topLevel.remove();
	}
}

function relayoutZoogleNav() {
	var $ = jQuery;
	var $lists = $('.navMenu');
	// merge all the uls back into one
	if( $lists.length > 1 ) {
		var len = $lists.length;
		var $firstList = $($lists.get(0));
		var els = [];
		for( var i = 1; i < len; i++ ) {
			$firstList.append( $('>li', $lists[i]) );
			$($lists[i]).remove();
		}
		$lists = $firstList;
	}
	// get rid of previous padding & re-layout
	$lists.css('padding', 0);
	layoutZoogleNav( $lists, $lists.children('li') );
};