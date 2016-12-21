jQuery(document).ready(function() {
	if(jQuery('#sod-drawer-plugin.top').length >0){
  		if (jQuery("#wpadminbar").length > 0){
			var $sod_drawer = jQuery('#sod-drawer-plugin.top');
			var adminBarHeight = jQuery('#wpadminbar').outerHeight(); 	
	  		$sod_drawer.css({
	  			'top': parseInt($sod_drawer.css('top'), 10)+adminBarHeight,
	  			'z-index':99999
	  		})
  		}
  		var $handle = jQuery('#sod-drawer-handle');
  		$handle.detach().insertAfter('#sod-drawer-plugin.top .content');
  		jQuery('#sod-drawer-plugin').detach().prependTo('body');
  		jQuery('#sod-drawer-plugin.top #sod-drawer-handle').click(function(){
    		jQuery('#sod-drawer-plugin.top .content').slideToggle();
    	});
    }
  	if(jQuery('#sod-drawer-plugin.bottom').length >0){
	  	jQuery('#sod-drawer-plugin.bottom #sod-drawer-handle').click(function(){
	       jQuery('#sod-drawer-plugin.bottom .content').slideToggle();
	    });
   };
   if(jQuery('#sod-drawer-plugin.left').length >0){
   			var $handle = jQuery('#sod-drawer-plugin.left #sod-drawer-handle');
	   		var $plugin = jQuery('#sod-drawer-plugin.left');
	   		var $adjustment = (parseInt($handle.outerWidth())/2)-parseInt($handle.outerHeight())/2;
	   		if (jQuery.browser.msie){
	   			$plugin.css({
						left:parseInt($plugin.css('left'),10) == 0 ? -$plugin.outerWidth():0
				});
				$handle.css({
						left:parseInt($plugin.css('left'),10) == 0 ? parseInt($plugin.outerWidth()-$adjustent):$plugin.outerWidth()
				});
				$handle.click(function(){
					$plugin.animate({
						left:parseInt($plugin.css('left'),10) == 0 ? -$plugin.outerWidth():0
					});
					$handle.animate({
						left:parseInt($plugin.css('left'),10) == 0 ? parseInt($plugin.outerWidth()-$adjustent):$plugin.outerWidth()
					});
				});
	   		}else{
		   		$plugin.css({
						left:parseInt($plugin.css('left'),10) == 0 ? -$plugin.outerWidth():0
				});
				$handle.css({
						left:parseInt($plugin.css('left'),10) == 0 ? parseInt($plugin.outerWidth()-$adjustent):$plugin.outerWidth()-$adjustment
				});
				$handle.click(function(){
					$plugin.animate({
						left:parseInt($plugin.css('left'),10) == 0 ? -$plugin.outerWidth():0
					});
					$handle.animate({
						left:parseInt($plugin.css('left'),10) == 0 ? parseInt($plugin.outerWidth()-$adjustent):$plugin.outerWidth()-$adjustment
					});
				});
			}
   }
   if(jQuery('#sod-drawer-plugin.right').length >0){
   	
   		var $handle = jQuery('#sod-drawer-plugin.right #sod-drawer-handle');
   		var $plugin = jQuery('#sod-drawer-plugin.right');
   		var $adjustment = (parseInt($handle.outerWidth())/2)-parseInt($handle.outerHeight())/2;
   		if (jQuery.browser.msie){
			$plugin.css({
					right:parseInt($plugin.css('right'),10) == 0 ? -$plugin.outerWidth():0
			});
			$handle.css({
					right:parseInt($plugin.css('right'),10) == 0 ? parseInt($plugin.outerWidth())-$adjustment:($plugin.outerWidth())
			})
	   		$handle.click(function(){
				$plugin.animate({
					right:parseInt($plugin.css('right'),10) == 0 ? -$plugin.outerWidth():0
				});
				$handle.animate({
					right:parseInt($plugin.css('right'),10) == 0 ? parseInt($plugin.outerWidth()):($plugin.outerWidth())
				});
			});
   		}else{
	   		$plugin.css({
					right:parseInt($plugin.css('right'),10) == 0 ? -$plugin.outerWidth():0
			});
			$handle.css({
					right:parseInt($plugin.css('right'),10) == 0 ? parseInt($plugin.outerWidth())-$adjustment:($plugin.outerWidth())-$adjustment
			})
	   		$handle.click(function(){
				$plugin.animate({
					right:parseInt($plugin.css('right'),10) == 0 ? -$plugin.outerWidth():0
				});
				$handle.animate({
					right:parseInt($plugin.css('right'),10) == 0 ? parseInt($plugin.outerWidth())-$adjustment:($plugin.outerWidth())-$adjustment
				});
			});
		}
   }
 });
 