var map;
var geocoder;
var gc_title;
var bounds; 
var points = Array();

points[0] = new PVGeoMarker('From: Reno/Tahoe Intl, Reno, NV 89502 (Reno/Tahoe Intl)', null, '<p></p>', -119.775871,39.504772 );
//points[1] = new PVGeoMarker('Directions to 1627 US Highway 395 North Minden, NV 89423', null, '<p></p>', , );
points[2] = new PVGeoMarker('To: 1627 US Highway 395 North Minden, NV 89423', null, '<p></p>', -119.768547,38.956039 );

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
	this.infohtml = '<b>' + this.title + '    </b><br/>' + this.info + '<div align="right"><a style="color: #000;"target="_blank" href="http://maps.google.com/maps?f=d&geocode=&daddr='+escape(this.address)+'&z=13">Get Driving Directions</a></div></span>';
	
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
	map.setCenter( this.coords, 15 );
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

function loadMarkersLayer() {
	bounds = new GLatLngBounds();
	map.clearOverlays();
	
	var polyline = new GPolyline([	    
	    new GLatLng(39.5047680,	-119.7758710),
	    new GLatLng(39.5063510,	-119.7758180),
	    new GLatLng(39.5069010,	-119.7758640),
	    new GLatLng(39.5078390,	-119.7758410),
	    new GLatLng(39.5081100,	-119.7759020),
	    new GLatLng(39.5082820,	-119.7761230),
	    new GLatLng(39.5083200,	-119.7763820),
	    new GLatLng(39.5083080,	-119.7770610),
	    new GLatLng(39.5082210,	-119.7772980),
	    new GLatLng(39.5080720,	-119.7774810),
	    new GLatLng(39.5078010,	-119.7775730),
	    new GLatLng(39.5071110,	-119.7775730),
	    new GLatLng(39.5066300,	-119.7775120),
	    new GLatLng(39.5066300,	-119.7775120),
	    new GLatLng(39.5061910,	-119.7774120),
	    new GLatLng(39.5060200,	-119.7774280),
	    new GLatLng(39.5058900,	-119.7776410),
	    new GLatLng(39.5059090,	-119.7781680),
	    new GLatLng(39.5059090,	-119.7781680),
	    new GLatLng(39.5059510,	-119.7808840),
	    new GLatLng(39.5059510,	-119.7808840),
	    new GLatLng(39.5058100,	-119.7808990),
	    new GLatLng(39.5058100,	-119.7808990),
	    new GLatLng(39.5051690,	-119.7810900),
	    new GLatLng(39.5039290,	-119.7815780),
	    new GLatLng(39.5012090,	-119.7830580),
	    new GLatLng(39.5009500,	-119.7831120),
	    new GLatLng(39.4999200,	-119.7835310),
	    new GLatLng(39.4991910,	-119.7837300),
	    new GLatLng(39.4963300,	-119.7842480),
	    new GLatLng(39.4952580,	-119.7843700),
	    new GLatLng(39.4873310,	-119.7855990),
	    new GLatLng(39.4848290,	-119.7861100),
	    new GLatLng(39.4842490,	-119.7862930),
	    new GLatLng(39.4831090,	-119.7867970),
	    new GLatLng(39.4817390,	-119.7875210),
	    new GLatLng(39.4808080,	-119.7881470),
	    new GLatLng(39.4781990,	-119.7902530),
	    new GLatLng(39.4776310,	-119.7906040),
	    new GLatLng(39.4771690,	-119.7908100),
	    new GLatLng(39.4765700,	-119.7910000),
	    new GLatLng(39.4756510,	-119.7911910),
	    new GLatLng(39.4749720,	-119.7912060),
	    new GLatLng(39.4741100,	-119.7911220),
	    new GLatLng(39.4733200,	-119.7909160),
	    new GLatLng(39.4711990,	-119.7900770),
	    new GLatLng(39.4703410,	-119.7895430),
	    new GLatLng(39.4575390,	-119.7832490),
	    new GLatLng(39.4544600,	-119.7817080),
	    new GLatLng(39.4537810,	-119.7812880),
	    new GLatLng(39.4532010,	-119.7808610),
	    new GLatLng(39.4523200,	-119.7800220),
	    new GLatLng(39.4513890,	-119.7788160),
	    new GLatLng(39.4509390,	-119.7780910),
	    new GLatLng(39.4480780,	-119.7728500),
	    new GLatLng(39.4475710,	-119.7720030),
	    new GLatLng(39.4465410,	-119.7705310),
	    new GLatLng(39.4454920,	-119.7693630),
	    new GLatLng(39.4443210,	-119.7683110),
	    new GLatLng(39.4430010,	-119.7673490),
	    new GLatLng(39.4422190,	-119.7668990),
	    new GLatLng(39.4397510,	-119.7657090),
	    new GLatLng(39.4380490,	-119.7647320),
	    new GLatLng(39.4263190,	-119.7559200),
	    new GLatLng(39.4255220,	-119.7551730),
	    new GLatLng(39.4247510,	-119.7542420),
	    new GLatLng(39.4229320,	-119.7514420),
	    new GLatLng(39.4222720,	-119.7505040),
	    new GLatLng(39.4215580,	-119.7496570),
	    new GLatLng(39.4209520,	-119.7490690),
	    new GLatLng(39.4198190,	-119.7482220),
	    new GLatLng(39.4192010,	-119.7478710),
	    new GLatLng(39.4184680,	-119.7475590),
	    new GLatLng(39.4168700,	-119.7471080),
	    new GLatLng(39.4154700,	-119.7469860),
	    new GLatLng(39.4147610,	-119.7470400),
	    new GLatLng(39.4134410,	-119.7473530),
	    new GLatLng(39.4120710,	-119.7479320),
	    new GLatLng(39.4114490,	-119.7482680),
	    new GLatLng(39.4101980,	-119.7491990),
	    new GLatLng(39.4093590,	-119.7500690),
	    new GLatLng(39.4093590,	-119.7500690),
	    new GLatLng(39.4086000,	-119.7515790),
	    new GLatLng(39.4085080,	-119.7521210),
	    new GLatLng(39.4085810,	-119.7525410),
	    new GLatLng(39.4088210,	-119.7530290),
	    new GLatLng(39.4091680,	-119.7533260),
	    new GLatLng(39.4092900,	-119.7533800),
	    new GLatLng(39.4096300,	-119.7533870),
	    new GLatLng(39.4098510,	-119.7533420),
	    new GLatLng(39.4100910,	-119.7531660),
	    new GLatLng(39.4103320,	-119.7528530),
	    new GLatLng(39.4104690,	-119.7524720),
	    new GLatLng(39.4104880,	-119.7519000),
	    new GLatLng(39.4104000,	-119.7515560),
	    new GLatLng(39.4102400,	-119.7512510),
	    new GLatLng(39.4099690,	-119.7509610),
	    new GLatLng(39.4091300,	-119.7503280),
	    new GLatLng(39.4027600,	-119.7461930),
	    new GLatLng(39.4018780,	-119.7456670),
	    new GLatLng(39.4016610,	-119.7455060),
	    new GLatLng(39.4016000,	-119.7453690),
	    new GLatLng(39.4000890,	-119.7444760),
	    new GLatLng(39.3983800,	-119.7436680),
	    new GLatLng(39.3970490,	-119.7431790),
	    new GLatLng(39.3873290,	-119.7407070),
	    new GLatLng(39.3859100,	-119.7404100),
	    new GLatLng(39.3854710,	-119.7403720),
	    new GLatLng(39.3842200,	-119.7404020),
	    new GLatLng(39.3834610,	-119.7405400),
	    new GLatLng(39.3818210,	-119.7412190),
	    new GLatLng(39.3806190,	-119.7420270),
	    new GLatLng(39.3780100,	-119.7440720),
	    new GLatLng(39.3771100,	-119.7446370),
	    new GLatLng(39.3765980,	-119.7449040),
	    new GLatLng(39.3730390,	-119.7462620),
	    new GLatLng(39.3725510,	-119.7464830),
	    new GLatLng(39.3714600,	-119.7471080),
	    new GLatLng(39.3703920,	-119.7479170),
	    new GLatLng(39.3677900,	-119.7501910),
	    new GLatLng(39.3674580,	-119.7505420),
	    new GLatLng(39.3661380,	-119.7516330),
	    new GLatLng(39.3652500,	-119.7525630),
	    new GLatLng(39.3647990,	-119.7532120),
	    new GLatLng(39.3642690,	-119.7542040),
	    new GLatLng(39.3621100,	-119.7590180),
	    new GLatLng(39.3618200,	-119.7597500),
	    new GLatLng(39.3615190,	-119.7608800),
	    new GLatLng(39.3610380,	-119.7634430),
	    new GLatLng(39.3607100,	-119.7644880),
	    new GLatLng(39.3604200,	-119.7651290),
	    new GLatLng(39.3569300,	-119.7717130),
	    new GLatLng(39.3564190,	-119.7725680),
	    new GLatLng(39.3554990,	-119.7738190),
	    new GLatLng(39.3548510,	-119.7745510),
	    new GLatLng(39.3542790,	-119.7751080),
	    new GLatLng(39.3532100,	-119.7759700),
	    new GLatLng(39.3493190,	-119.7782820),
	    new GLatLng(39.3485300,	-119.7786330),
	    new GLatLng(39.3476410,	-119.7788310),
	    new GLatLng(39.3466800,	-119.7788310),
	    new GLatLng(39.3458100,	-119.7786640),
	    new GLatLng(39.3456800,	-119.7786790),
	    new GLatLng(39.3432690,	-119.7778400),
	    new GLatLng(39.3423310,	-119.7777330),
	    new GLatLng(39.3414500,	-119.7778320),
	    new GLatLng(39.3410490,	-119.7779310),
	    new GLatLng(39.3375590,	-119.7791670),
	    new GLatLng(39.3372120,	-119.7793430),
	    new GLatLng(39.3366320,	-119.7797090),
	    new GLatLng(39.3361400,	-119.7801130),
	    new GLatLng(39.3354910,	-119.7808070),
	    new GLatLng(39.3351210,	-119.7813190),
	    new GLatLng(39.3346480,	-119.7821730),
	    new GLatLng(39.3342700,	-119.7831270),
	    new GLatLng(39.3325390,	-119.7894210),
	    new GLatLng(39.3304790,	-119.7965620),
	    new GLatLng(39.3300510,	-119.7985080),
	    new GLatLng(39.3294720,	-119.8020400),
	    new GLatLng(39.3293000,	-119.8027730),
	    new GLatLng(39.3290900,	-119.8034360),
	    new GLatLng(39.3284110,	-119.8049010),
	    new GLatLng(39.3282090,	-119.8051220),
	    new GLatLng(39.3280720,	-119.8053820),
	    new GLatLng(39.3232500,	-119.8145290),
	    new GLatLng(39.3228610,	-119.8152010),
	    new GLatLng(39.3223800,	-119.8157880),
	    new GLatLng(39.3219800,	-119.8162000),
	    new GLatLng(39.3173600,	-119.8195500),
	    new GLatLng(39.3156390,	-119.8208690),
	    new GLatLng(39.3128090,	-119.8228530),
	    new GLatLng(39.3119200,	-119.8233800),
	    new GLatLng(39.3108790,	-119.8237380),
	    new GLatLng(39.3104710,	-119.8238220),
	    new GLatLng(39.3082620,	-119.8240810),
	    new GLatLng(39.3070790,	-119.8242800),
	    new GLatLng(39.3050500,	-119.8249440),
	    new GLatLng(39.3041500,	-119.8251800),
	    new GLatLng(39.3032190,	-119.8253170),
	    new GLatLng(39.3022800,	-119.8253480),
	    new GLatLng(39.3013110,	-119.8252870),
	    new GLatLng(39.3003690,	-119.8251270),
	    new GLatLng(39.2576790,	-119.8161390),
	    new GLatLng(39.2295110,	-119.8102720),
	    new GLatLng(39.2215390,	-119.8084560),
	    new GLatLng(39.2134090,	-119.8067930),
	    new GLatLng(39.2108380,	-119.8062130),
	    new GLatLng(39.2102700,	-119.8059620),
	    new GLatLng(39.2097400,	-119.8056490),
	    new GLatLng(39.2093390,	-119.8053510),
	    new GLatLng(39.2086600,	-119.8046260),
	    new GLatLng(39.2079200,	-119.8035810),
	    new GLatLng(39.2076000,	-119.8028490),
	    new GLatLng(39.2073900,	-119.8022380),
	    new GLatLng(39.2072600,	-119.8017730),
	    new GLatLng(39.2071420,	-119.8009260),
	    new GLatLng(39.2069090,	-119.7987140),
	    new GLatLng(39.2067990,	-119.7980880),
	    new GLatLng(39.2058790,	-119.7953030),
	    new GLatLng(39.2056810,	-119.7943880),
	    new GLatLng(39.2052800,	-119.7888720),
	    new GLatLng(39.2052800,	-119.7888720),
	    new GLatLng(39.2049220,	-119.7862700),
	    new GLatLng(39.2046590,	-119.7852630),
	    new GLatLng(39.2041890,	-119.7840420),
	    new GLatLng(39.2028390,	-119.7815090),
	    new GLatLng(39.2023890,	-119.7808070),
	    new GLatLng(39.2020190,	-119.7803800),
	    new GLatLng(39.2013890,	-119.7797700),
	    new GLatLng(39.2008900,	-119.7794270),
	    new GLatLng(39.1817700,	-119.7678070),
	    new GLatLng(39.1808820,	-119.7674030),
	    new GLatLng(39.1799810,	-119.7671130),
	    new GLatLng(39.1790810,	-119.7669600),
	    new GLatLng(39.1790200,	-119.7668910),
	    new GLatLng(39.1704410,	-119.7669370),
	    new GLatLng(39.1704410,	-119.7669370),
	    new GLatLng(39.1665120,	-119.7669680),
	    new GLatLng(39.1661490,	-119.7669830),
	    new GLatLng(39.1658780,	-119.7670520),
	    new GLatLng(39.1600000,	-119.7670520),
	    new GLatLng(39.1492390,	-119.7671740),
	    new GLatLng(39.1482890,	-119.7672580),
	    new GLatLng(39.1451300,	-119.7677920),
	    new GLatLng(39.1422080,	-119.7683490),
	    new GLatLng(39.1362610,	-119.7693410),
	    new GLatLng(39.1334920,	-119.7698900),
	    new GLatLng(39.1298100,	-119.7705310),
	    new GLatLng(39.1205600,	-119.7720110),
	    new GLatLng(39.1132010,	-119.7733690),
	    new GLatLng(39.1132010,	-119.7733690),
	    new GLatLng(39.1061780,	-119.7744900),
	    new GLatLng(39.1048810,	-119.7747420),
	    new GLatLng(39.1042400,	-119.7748110),
	    new GLatLng(39.0924990,	-119.7751310),
	    new GLatLng(39.0910190,	-119.7752530),
	    new GLatLng(39.0893100,	-119.7755740),
	    new GLatLng(39.0724720,	-119.7798460),
	    new GLatLng(39.0714990,	-119.7800060),
	    new GLatLng(39.0707210,	-119.7800830),
	    new GLatLng(39.0404400,	-119.7799680),
	    new GLatLng(39.0303690,	-119.7800060),
	    new GLatLng(39.0244790,	-119.7799300),
	    new GLatLng(39.0165600,	-119.7799380),
	    new GLatLng(39.0119900,	-119.7798230),
	    new GLatLng(39.0061190,	-119.7798310),
	    new GLatLng(39.0047800,	-119.7797700),
	    new GLatLng(39.0008810,	-119.7797620),
	    new GLatLng(38.9994010,	-119.7796940),
	    new GLatLng(38.9962080,	-119.7797390),
	    new GLatLng(38.9758680,	-119.7796480),
	    new GLatLng(38.9735790,	-119.7794720),
	    new GLatLng(38.9724620,	-119.7793200),
	    new GLatLng(38.9705090,	-119.7792130),
	    new GLatLng(38.9622610,	-119.7791980),
	    new GLatLng(38.9617310,	-119.7791140),
	    new GLatLng(38.9609180,	-119.7787700),
	    new GLatLng(38.9600720,	-119.7780840),
	    new GLatLng(38.9595110,	-119.7773510),
	    new GLatLng(38.9594800,	-119.7771530),
	    new GLatLng(38.9587100,	-119.7753980),
	    new GLatLng(38.9560390,	-119.7685470)
	], "#6400CF", 3);
	map.addOverlay(polyline);  	
	
	if(typeof(showpoint) != 'undefined') {
		
		var pt = points[showpoint];
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
		for (var i = 0; i < points.length; i++) {
			var pt = points[i];
			if(pt != null) {
				pt.coords = new GLatLng(pt.lat,pt.lon);
				map.addOverlay(pt.createMarker());
				bounds.extend(pt.coords);
			}
		}
		
		if(points.length == 1) {
			map.setCenter(points[0].coords, 10);
			points[0].popup();
		}
		else if (!bounds.isEmpty()) {
			boundzoom = map.getBoundsZoomLevel(bounds);
			map.setCenter(bounds.getCenter(), --boundzoom);
		}
	}
}

function loadGoogleMap() {
	
	createMap( 'googlemapReno' );
	loadMarkersLayer();

}

google.load("maps", "2.x");
google.setOnLoadCallback(loadGoogleMap);