$jq(document).ready(function(){	

if ($jq(window).width() < 886) {
	//move the textbooks nav from the header to the bottom of #GMnav
	$jq("#nav-textbook").insertBefore(".GMmenu");

	//menu trigger click events
	$jq(".menu-trigger").click(function () {
		$jq(this).toggleClass('rotate');
		$jq('#GMnav').slideToggle();
	});

}


if ($jq(window).width() < 760) {
	//home page tabs - auto-scroll to .tabs_content_container
	$jq('#tabs li a').click(function(event) {
		$jq('html, body').animate({
		    scrollTop: $jq('.tabs_content_container').offset().top
		}, 1000);
 	});
 	
 	//change the source order of the paragraph on buy_main
		$jq("#buy-search").insertBefore("#reserve-feature");
		
		//add close button to rental agreement modal
	$jq(".jqmWindow").append('<a class="close-jqm" href="#"></a>');



//change the source order of the product elements on shop_product_detail
	$jq("#product-photo, .product-thumb-group").insertBefore("#product-info");
	$jq(".product-name").insertBefore("#product-photo");

//footer accordion navigation
	$jq("#footer ul lh").click(function () {
		var $jqIcufoot = $jq(this).closest('ul');
		$jq(this).toggleClass('rotate');
		$jq("#footer ul lh").not(this).removeClass('rotate');
		$jqIcufoot.toggleClass('active');
		$jq("#footer ul").not($jqIcufoot).removeClass('active');    
	});
	
//shop area accordion navigation changes
	//change the source order of sub_nav and breadcrumbs
	$jq("#sub-nav").insertBefore("#main > h1:first-of-type");
	$jq("ul.breadcrumbs li:last-child").css("display","none");
	$jq("ul.breadcrumbs li").addClass("crumbs").insertBefore("#sub-nav ul li:first-of-type");
	//insert h3 to be the shop_main menu heading, if one is not already present
	$jq('#sub-nav:not(:has(h3)) ul').before('<h3>Categories</h3>');
	//add trigger-button class to h3
	$jq('#sub-nav h3,#search-nav h3').addClass('trigger-button');
	//add accordion class to ul
	$jq('#sub-nav ul,#search-nav ul').addClass('accordion');
	//trigger accordion
	$jq(".trigger-button").click(function () {
		var $jqIcuhead = $jq(this).next('.accordion');
		$jq(this).toggleClass('rotate');
		$jqIcuhead.toggleClass('active');
		$jq(".accordion").not($jqIcuhead).removeClass('active');    
	});

}

});