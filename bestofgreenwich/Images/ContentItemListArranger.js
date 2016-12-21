/* For doing fancy things with contentitemlists 
 * Currently handles showing and hiding of tags based on item width 
 * Also removes floating of images where they take up most of the container
 */


var ContentItemListArranger = (function(rjQuery) {

	return {
		cropItemTags: function cropItemTags() {
			var $itemTags = rjQuery('.article-tags');

			$itemTags.each( function () {
				$this = rjQuery(this);
				var tagsNextToImage = 1;
				if ($this.parents('.content-item-list.vertical-blurb').length || 	//If we are inside a vertical-blurb list (full-width image)
					$this.parents('.content-item-list.grid').length ||  			//or a grid list (full-width image)
					$this.width() - $this.parents('.article-item').find('.article-image').outerWidth(true) < 100) { //Or the image takes most of its container (100px is arbitrary)
					//The image will be big and the tags and other content go below it so we don't want to consider the image in our width calculations.
					tagsNextToImage = 0; 
					$this.parents('.article-item').find('.article-image').css({"margin-bottom":"6px"});
				} else { //Make sure the image is floating left again in case floating was removed previously
					$this.parents('.article-item').find('.article-image').css({"margin-bottom":"0px"});
				}
				var containerWidth = $this.width() - $this.parents('.article-item').find('.article-image').outerWidth(true) * tagsNextToImage;
				var $tags = $this.find('.article-tag').hide();
				var totalWidth = 0;
				$tags.each( function () {
					$this = rjQuery(this);
					if(totalWidth + $this.outerWidth(true) < containerWidth) { // Can we fit the next category here?
						$this.show();
						totalWidth += $this.outerWidth(true);
					} else { // Nope. We can't. Don't show any more categories.
						totalWidth = containerWidth; 
					}
				});
			});
		}

	};

})(rjQuery);






if(rjQuery('.content-item-list.grid').length) { // Grid resizing prevents the tags from cropping properly. On grid view we need to crop tags after the grid settles down.
	window.setTimeout(function () { ContentItemListArranger.cropItemTags(); }, 1000);
}

WindowResizeResponder.register({
	"method": ContentItemListArranger.cropItemTags,
	"when": "ready"
});

