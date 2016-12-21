/* ****************************** */
/* FEATURE */

// Zone titles
var Zone_Feature_Titles = new Array();
Zone_Feature_Titles[0] = "Aramark Corporation";
Zone_Feature_Titles[1] = "WPVI-TV Channel 6";
// Zone image names
var Zone_Feature_Images = new Array();
Zone_Feature_Images[0] = "http://www.musikfest.org/images/ads/side_aramark.jpg";
Zone_Feature_Images[1] = "http://www.musikfest.org/images/ads/side_wpvi6.jpg";
// Zone links
var Zone_Feature_Links = new Array();
Zone_Feature_Links[0] = "http://www.aramark.com";
Zone_Feature_Links[1] = "http://abclocal.go.com/wpvi";
// Zone weights
var Zone_Feature_Weights = new Array();
Zone_Feature_Weights[0] = 1;
Zone_Feature_Weights[1] = 1;

// Zone constants
var Zone_Feature_Current_Ads = new Array();
var zone_feature_weighedads = new Array();
var zone_feature_execute = 1;
var zone_feature_totalweight = eval(Zone_Feature_Weights.join("+"));
var zone_feature_currentad = 0;

// Weigh the ads
while (zone_feature_currentad<Zone_Feature_Titles.length){
for (i=0; i<Zone_Feature_Weights[zone_feature_currentad]; i++)
zone_feature_weighedads[zone_feature_weighedads.length]=zone_feature_currentad;
zone_feature_currentad++;
}

// Generates one random weighed ad
function featurePickAd ()
{
	var string_current_ads = Zone_Feature_Current_Ads.join(",");
	var feature_randomad = zone_feature_weighedads[Math.floor(Math.random()*zone_feature_totalweight)];
	if (string_current_ads.indexOf(feature_randomad) == -1)
	{
		Zone_Feature_Current_Ads.push(feature_randomad);
	}
	else
	{
		featurePickAd();
	}
}

// Generates the ads
function featureDisplayAds (passed_execute)
{
	// Pick the ads
	for (i=0; i<passed_execute; i++)
	{
		featurePickAd();
	}
	// Display the ads
	for (i=0; i<Zone_Feature_Current_Ads.length; i++)
	{
		document.write("<div class=\"ad_side\"><a href=\"" + Zone_Feature_Links[Zone_Feature_Current_Ads[i]] + "\" target=\"_blank\"><img src=\"" + Zone_Feature_Images[Zone_Feature_Current_Ads[i]] + "\" border=\"0\" alt=\"" + Zone_Feature_Titles[Zone_Feature_Current_Ads[i]] + "\"></a></div>");
	}
}


/* ****************************** */
/* SIDE */

// Zone titles
var Zone_Side_Titles = new Array();
Zone_Side_Titles[0] = "Aramark Corporation";
Zone_Side_Titles[1] = "WPVI-TV Channel 6";
Zone_Side_Titles[2] = "Coca-Cola Bottling Co. of the Lehigh Valley";
Zone_Side_Titles[3] = "Lehigh Valley Hospital &amp; Health Network";
Zone_Side_Titles[4] = "PNC Bank";
// Zone image names
var Zone_Side_Images = new Array();
Zone_Side_Images[0] = "http://www.musikfest.org/images/ads/side_aramark.jpg";
Zone_Side_Images[1] = "http://www.musikfest.org/images/ads/side_wpvi6.jpg";
Zone_Side_Images[2] = "http://www.musikfest.org/images/ads/side_coke.jpg";
Zone_Side_Images[3] = "http://www.musikfest.org/images/ads/side_lvhhn.jpg";
Zone_Side_Images[4] = "http://www.musikfest.org/images/ads/side_pncbank.jpg";
// Zone links
var Zone_Side_Links = new Array();
Zone_Side_Links[0] = "http://www.aramark.com";
Zone_Side_Links[1] = "http://abclocal.go.com/wpvi";
Zone_Side_Links[2] = "http://www.coca-cola.com";
Zone_Side_Links[3] = "http://www.lvhhn.org";
Zone_Side_Links[4] = "http://www.pncbank.com";
// Zone weights
var Zone_Side_Weights = new Array();
Zone_Side_Weights[0] = 1;
Zone_Side_Weights[1] = 1;
Zone_Side_Weights[2] = 1;
Zone_Side_Weights[3] = 1;
Zone_Side_Weights[4] = 1;

// Zone constants
var Zone_Side_Current_Ads = new Array();
var zone_side_weighedads = new Array();
var zone_side_execute = 2;
var zone_side_totalweight = eval(Zone_Side_Weights.join("+"));
var zone_side_currentad = 0;

// Weigh the ads
while (zone_side_currentad<Zone_Side_Titles.length){
for (i=0; i<Zone_Side_Weights[zone_side_currentad]; i++)
zone_side_weighedads[zone_side_weighedads.length]=zone_side_currentad;
zone_side_currentad++;
}

// Generates one random weighed ad
function sidePickAd ()
{
	var string_current_ads = Zone_Side_Current_Ads.join(",");
	var side_randomad = zone_side_weighedads[Math.floor(Math.random()*zone_side_totalweight)];
	if (string_current_ads.indexOf(side_randomad) == -1 && Zone_Side_Titles[side_randomad] != Zone_Feature_Titles[Zone_Feature_Current_Ads])
	{
		Zone_Side_Current_Ads.push(side_randomad);
	}
	else
	{
		sidePickAd();
	}
}

// Generates the ads
function sideDisplayAds (passed_execute)
{
	// Pick the ads
	for (i=0; i<passed_execute; i++)
	{
		sidePickAd();
	}
	// Display the ads
	for (i=0; i<Zone_Side_Current_Ads.length; i++)
	{
		document.write("<div class=\"ad_side\"><a href=\"" + Zone_Side_Links[Zone_Side_Current_Ads[i]] + "\" target=\"_blank\"><img src=\"" + Zone_Side_Images[Zone_Side_Current_Ads[i]] + "\" border=\"0\" alt=\"" + Zone_Side_Titles[Zone_Side_Current_Ads[i]] + "\"></a></div>");
	}
}


/* ****************************** */
/* FULL */

// Zone titles
var Zone_Full_Titles = new Array();
Zone_Full_Titles[0] = "Adams Outdoor Advertising";
Zone_Full_Titles[1] = "Coca-Cola Bottling Co of the Lehigh Valley";
Zone_Full_Titles[2] = "Lehigh Valley Hospital & Health Network";
Zone_Full_Titles[3] = "MRK Networks, Inc.";
Zone_Full_Titles[4] = "Northampton Community College";
Zone_Full_Titles[5] = "Plantique, Inc.";
Zone_Full_Titles[6] = "PNC Bank";
// Zone image names
var Zone_Full_Images = new Array();
Zone_Full_Images[0] = "http://www.musikfest.org/images/ads/full_adamsoutdoor.jpg";
Zone_Full_Images[1] = "http://www.musikfest.org/images/ads/full_coke.jpg";
Zone_Full_Images[2] = "http://www.musikfest.org/images/ads/full_lvhhn.jpg";
Zone_Full_Images[3] = "http://www.musikfest.org/images/ads/full_mrk.jpg";
Zone_Full_Images[4] = "http://www.musikfest.org/images/ads/full_northampton.jpg";
Zone_Full_Images[5] = "http://www.musikfest.org/images/ads/full_plantique.jpg";
Zone_Full_Images[6] = "http://www.musikfest.org/images/ads/full_pncbank.jpg";
// Zone links
var Zone_Full_Links = new Array();
Zone_Full_Links[0] = "http://www.adamsoutdoor.com";
Zone_Full_Links[1] = "http://www.coca-cola.com";
Zone_Full_Links[2] = "http://www.lvhhn.org";
Zone_Full_Links[3] = "http://www.mrkhostwindow.com";
Zone_Full_Links[4] = "http://www.northampton.edu";
Zone_Full_Links[5] = "http://www.plantique.com";
Zone_Full_Links[6] = "http://www.pncbank.com";
// Zone weights
var Zone_Full_Weights = new Array();
Zone_Full_Weights[0] = 2;
Zone_Full_Weights[1] = 1;
Zone_Full_Weights[2] = 1;
Zone_Full_Weights[3] = 2;
Zone_Full_Weights[4] = 1;
Zone_Full_Weights[5] = 2;
Zone_Full_Weights[6] = 1;

// Zone constants
var Zone_Full_Current_Ads = new Array();
var zone_full_weighedads = new Array();
var zone_full_execute = 2;
var zone_full_totalweight = eval(Zone_Full_Weights.join("+"));
var zone_full_currentad = 0;

// Weigh the ads
while (zone_full_currentad<Zone_Full_Titles.length){
for (i=0; i<Zone_Full_Weights[zone_full_currentad]; i++)
zone_full_weighedads[zone_full_weighedads.length]=zone_full_currentad;
zone_full_currentad++;
}

// Generates one random weighed ad
function fullPickAd ()
{
	var string_current_ads = Zone_Full_Current_Ads.join(",");
	var full_randomad = zone_full_weighedads[Math.floor(Math.random()*zone_full_totalweight)];
	if (string_current_ads.indexOf(full_randomad) == -1)
	{
		Zone_Full_Current_Ads.push(full_randomad);
	}
	else
	{
		fullPickAd();
	}
}

// Generates the ads
function fullDisplayAds (passed_execute)
{
	// Pick the ads
	for (i=0; i<passed_execute; i++)
	{
		fullPickAd();
	}
	// Display the ads
	for (i=0; i<Zone_Full_Current_Ads.length; i++)
	{
		document.write("<td><div class=\"ad_footer\"><a href=\"" + Zone_Full_Links[Zone_Full_Current_Ads[i]] + "\" target=\"_blank\"><img src=\"" + Zone_Full_Images[Zone_Full_Current_Ads[i]] + "\" border=\"0\" alt=\"" + Zone_Full_Titles[Zone_Full_Current_Ads[i]] + "\"></a></div></td>");
	}
}