var map;
var geocoder;
var gc_title;
var bounds; 
var pointsCarson = Array();

pointsCarson[0] = new PVGeoMarker('<div style="color: #000;">Carson Valley Inn', null, '<p>1627 Hwy 395 N,<br> Minden, NV 89423<br>Tel. 775.782.9711<br>Reservations 800.321.6983</p>', -119.767532,38.955711 );

function PVGeoMarker(title, address, info, lon, lat) {
	
	this.title = title;
	this.info = info;
	if(address)
		this.address = address;
	else
		this.address = lat + ', ' + lon;
	
	this.lat = lat;
	this.lon = lon;
	this.marker = null;
	this.infohtml = '<b>' + this.title + '    </b><br/>' + this.info + '<div align="left"><a style="text-align: left; color: #000; font-size: 11px;" target="_blank" href="http://maps.google.com/maps?f=d&geocode=&daddr='+escape(this.address)+'&z=13">Get Driving Directions</a></div></span></div>';
	
}	

PVGeoMarker.prototype.createMarker = function() {
	/* var ico = new GIcon(G_DEFAULT_ICON, 'http://maps.google.com/mapfiles/ms/micons/blue-dot.png');
	ico.iconSize = new GSize(32, 32); */

	this.marker = new GMarker(this.coords);
	this.marker.bindInfoWindowHtml( this.infohtml );
	return this.marker;	
}

PVGeoMarker.prototype.popup = function() {
	this.marker.openInfoWindowHtml(this.infohtml);
}

PVGeoMarker.prototype.show = function() {
	map.clearOverlays();
	this.createMarker();
	map.addOverlay(this.marker);
	this.marker.openInfoWindowHtml(this.infohtml);
}

function AddressCache() {
	GGeocodeCache.apply(this);
}

function createMap( elementid ) {
	map = new google.maps.Map2(document.getElementById( elementid ));
    // map.enableScrollWheelZoom();
    map.enableContinuousZoom();
    // map.addControl(new GSmallMapControl());
    map.addControl(new GLargeMapControl());
	// map.addControl(new GMapTypeControl());
    var point = new GLatLng(0, 0);
	map.setCenter( point , 4 );
	
	AddressCache.prototype = new GGeocodeCache();

    geocoder = new GClientGeocoder();
    geocoder.setCache(new AddressCache());	
}

function loadMarkersLayerCarson() {
	bounds = new GLatLngBounds();
	map.clearOverlays();   	
	if(typeof(showpoint) != 'undefined') {
		
		var pt = pointsCarson[showpoint];
		if(pt != null) {
			pt.coords = new GLatLng(pt.lat,pt.lon);
			map.addOverlay(pt.createMarker());
			
			map.setCenter(pt.coords, 15);
			pt.popup();
		}
		else
			alert('map-api error: point id is invalid!');
	}
	else {
		for (var i = 0; i < pointsCarson.length; i++) {
			var pt = pointsCarson[i];
			if(pt != null) {
				pt.coords = new GLatLng(pt.lat,pt.lon);
				map.addOverlay(pt.createMarker());
				bounds.extend(pt.coords);
			}
		}
		
		if(pointsCarson.length == 1) {
			map.setCenter(pointsCarson[0].coords, 10);
			pointsCarson[0].popup();
			map.panDirection(1,1);
			map.panDirection(1,1);
		}
		
		else if (!bounds.isEmpty()) {
			boundzoom = map.getBoundsZoomLevel(bounds);
			map.setCenter(bounds.getCenter(), --boundzoom);
		}
	}
}

function loadGoogleMapCarson() {
	
	createMap( 'googlemapCarson' );
	loadMarkersLayerCarson();

}

google.load("maps", "2.x");
google.setOnLoadCallback(loadGoogleMapCarson);