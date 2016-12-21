function isValidEmail( in_email ) 
{
	var filter  = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
	if (filter.test(in_email)) return true;
	else return false;

}

var isLoaded = false;

function image_swap(in_name,in_state) {
	if (!isLoaded) {
		return true;
	}
	document.images[in_name].src = eval(in_name + "_" + in_state + ".src");
}

function check_form( in_name, in_field )
{
	if ( !isValidEmail(document.forms[in_name].elements[in_field].value) )
	{
		alert("Please enter a valid email address.");
		return false;
	}
	document.forms[in_name].submit();
	return true;
}

ln_home_off = new Image;
ln_home_on = new Image;
ln_home_off.src = "images/ln_home_off.gif";
ln_home_on.src = "images/ln_home_on.gif";

ln_press_off = new Image;
ln_press_on = new Image;
ln_press_off.src = "images/ln_press_off.gif";
ln_press_on.src =  "images/ln_press_on.gif";

ln_retailer_information_off = new Image;
ln_retailer_information_on = new Image;
ln_retailer_information_off.src = "images/ln_retailer_information_off.gif";
ln_retailer_information_on.src =  "images/ln_retailer_information_on.gif";

ln_travel_off = new Image;
ln_travel_on = new Image;
ln_travel_off.src = "images/ln_travel_off.gif";
ln_travel_on.src =  "images/ln_travel_on.gif";

ln_partners_off = new Image;
ln_partners_on = new Image;
ln_partners_off.src = "images/ln_partners_off.gif";
ln_partners_on.src =  "images/ln_partners_on.gif";

ln_basketry_off = new Image;
ln_basketry_on = new Image;
ln_basketry_off.src = "images/ln_basketry_off.gif";
ln_basketry_on.src =  "images/ln_basketry_on.gif";

ln_ceramics_off = new Image;
ln_ceramics_on = new Image;
ln_ceramics_off.src = "images/ln_ceramics_off.gif";
ln_ceramics_on.src =  "images/ln_ceramics_on.gif";

ln_fashion_wearable_off = new Image;
ln_fashion_wearable_on = new Image;
ln_fashion_wearable_off.src = "images/ln_fashion_wearable_off.gif";
ln_fashion_wearable_on.src =  "images/ln_fashion_wearable_on.gif";

ln_fiber_decorative_off = new Image;
ln_fiber_decorative_on = new Image;
ln_fiber_decorative_off.src = "images/ln_fiber_decorative_off.gif";
ln_fiber_decorative_on.src =  "images/ln_fiber_decorative_on.gif";

ln_furniture_off = new Image;
ln_furniture_on = new Image;
ln_furniture_off.src = "images/ln_furniture_off.gif";
ln_furniture_on.src =  "images/ln_furniture_on.gif";

ln_glass_off = new Image;
ln_glass_on = new Image;
ln_glass_off.src = "images/ln_glass_off.gif";
ln_glass_on.src =  "images/ln_glass_on.gif";

ln_jewelry_off = new Image;
ln_jewelry_on = new Image;
ln_jewelry_off.src = "images/ln_jewelry_off.gif";
ln_jewelry_on.src =  "images/ln_jewelry_on.gif";

ln_leather_off = new Image;
ln_leather_on = new Image;
ln_leather_off.src = "images/ln_leather_off.gif";
ln_leather_on.src =  "images/ln_leather_on.gif";

ln_metal_off = new Image;
ln_metal_on = new Image;
ln_metal_off.src = "images/ln_metal_off.gif";
ln_metal_on.src =  "images/ln_metal_on.gif";

ln_mixed_off = new Image;
ln_mixed_on = new Image;
ln_mixed_off.src = "images/ln_mixed_off.gif";
ln_mixed_on.src =  "images/ln_mixed_on.gif";

ln_new_off = new Image;
ln_new_on = new Image;
ln_new_off.src = "images/ln_new_off.gif";
ln_new_on.src =  "images/ln_new_on.gif";

ln_wood_off = new Image;
ln_wood_on = new Image;
ln_wood_off.src = "images/ln_wood_off.gif";
ln_wood_on.src =  "images/ln_wood_on.gif";

ln_searchlight_artists_off = new Image;
ln_searchlight_artists_on = new Image;
ln_searchlight_artists_off.src = "images/ln_searchlight_artists_off.gif";
ln_searchlight_artists_on.src =  "images/ln_searchlight_artists_on.gif";

//footer images
footer_about_craft_off = new Image;
footer_about_craft_on = new Image;
footer_about_craft_off.src = "images/footer_about_craft_off.gif";
footer_about_craft_on.src =  "images/footer_about_craft_on.gif";

footer_american_craft_off = new Image;
footer_american_craft_on = new Image;
footer_american_craft_off.src = "images/footer_american_craft_off.gif";
footer_american_craft_on.src =  "images/footer_american_craft_on.gif";

footer_craft_calendar_off = new Image;
footer_craft_calendar_on = new Image;
footer_craft_calendar_off.src = "images/footer_craft_calendar_off.gif";
footer_craft_calendar_on.src =  "images/footer_craft_calendar_on.gif";

footer_join_the_council_off = new Image;
footer_join_the_council_on = new Image;
footer_join_the_council_off.src = "images/footer_join_the_council_off.gif";
footer_join_the_council_on.src =  "images/footer_join_the_council_on.gif";

footer_library_resources_off = new Image;
footer_library_resources_on = new Image;
footer_library_resources_off.src = "images/footer_library_resources_off.gif";
footer_library_resources_on.src =  "images/footer_library_resources_on.gif";

footer_shows_markets_off = new Image;
footer_shows_markets_on = new Image;
footer_shows_markets_off.src = "images/footer_shows_markets_off.gif";
footer_shows_markets_on.src =  "images/footer_shows_markets_on.gif";

footer_support_the_council_off = new Image;
footer_support_the_council_on = new Image;
footer_support_the_council_off.src = "images/footer_support_the_council_off.gif";
footer_support_the_council_on.src =  "images/footer_support_the_council_on.gif";

footer_the_council_off = new Image;
footer_the_council_on = new Image;
footer_the_council_off.src = "images/footer_the_council_off.gif";
footer_the_council_on.src =  "images/footer_the_council_on.gif";



isLoaded = true;