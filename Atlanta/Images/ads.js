/* This file requires htmlParser.js and postscribe.min.js */

// Define a random group number
if (window.adgroupid == undefined) { window.adgroupid = Math.round(Math.random() * 1000); }

/*
 * ADTECH.loadAd - Asynchronously loads an ad into a specified html target.
 * (c) 2012 AOL Advertising. 
 * @param id ID value of the container where ad will be displayed.
 * @param url ADTECH addyn tag URL.
 */

var ADTECH = ADTECH || {};
ADTECH.loadAd = function (id, url) {
    var el = document.getElementById(id);
    postscribe(el, '<script type="text/javascript" src="' + url + '"><\/script>');
};

function adChecker(ad, interval) {
    var img = ad.find('img');
    if (img.length) {
        if (img.attr('alt') == 'AdTech Ad') {
            if (ad.is(':visible')) {
                ad.hide();
                ad.closest(".widget--adtech").hide();
            }
        }
        clearInterval(interval);
    }
}

//Does not check if ad is visible
function navAdChecker(ad, interval) {
    var img = ad.find('img');
    if (img.length) {
        if (img.attr('alt').trim() == 'AdTech Ad') {
                ad.hide();
                ad.closest(".widget--adtech").hide();
        }
        clearInterval(interval);
    }
}

// define and load navigation ads
jQuery(window).ready(function () {
    var placementIDs = ["3168807", "3168810", "3168811", "3168808", "3168812"];
    var checkad1, checkad2, checkad3, checkad4, checkad5;
    var networkID = "5430";
    var sizeID = "1";
    var adSpots = jQuery('.nav-advert');
    var load = true;

    for (var i = 0; i < placementIDs.length; i++)
    {
        var alias = 'alias=';
        var currentSpot = adSpots[i];
        var currentID = placementIDs[i];

        $(currentSpot).attr('id', 'placement_' + currentID);

        if ($(window).width() < 970) {
            alias += currentID + '-mobile';
            load = false;
        }

        if (load) {
            ADTECH.loadAd('placement_' + currentID, 'http://adserver.adtechus.com/addyn/3.0/' + networkID + '.1/' + currentID + '/0/' + sizeID + '/ADTECH;loc=100;target=_blank;key=key1+key2+key3+key4;' + alias + ';grp= ' + window.adgroupid + ';misc=' + new Date().getTime());
        }
    }

    checkad1 = setInterval(function () { navAdChecker($('#placement_' + placementIDs[0]), checkad1); }, 250);
    checkad2 = setInterval(function () { navAdChecker($('#placement_' + placementIDs[1]), checkad2); }, 250);
    checkad3 = setInterval(function () { navAdChecker($('#placement_' + placementIDs[2]), checkad3); }, 250);
    checkad4 = setInterval(function () { navAdChecker($('#placement_' + placementIDs[3]), checkad4); }, 250);
    checkad5 = setInterval(function () { navAdChecker($('#placement_' + placementIDs[4]), checkad5); }, 250);
});