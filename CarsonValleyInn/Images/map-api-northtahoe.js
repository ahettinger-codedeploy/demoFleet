var map;
var geocoder;
var gc_title;
var bounds; 
var pointsNorthTahoe = Array();

pointsNorthTahoe[0] = new PVGeoMarker('From: 8611 North Lake Boulevard, Kings Beach, CA 96143 (North Shore Chiropractic)', null, '<p></p>', -120.021599,39.235752 );
//points[1] = new PVGeoMarker('Directions to 1627 US Highway 395 North, Minden, NV 89423 (Carson Valley Inn)', null, '<p></p>', , );
pointsNorthTahoe[2] = new PVGeoMarker('To: 1627 US Highway 395 North, Minden, NV 89423 (Carson Valley Inn)', null, '<p></p>', -119.767548,38.955685 );

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

function loadMarkersLayerNorthTahoe() {
	bounds = new GLatLngBounds();
	map.clearOverlays();   	
	
	var polyline = new GPolyline([
		    new GLatLng(39.2357480,	-120.0215990),
		    new GLatLng(39.2350620,	-120.0192870),
		    new GLatLng(39.2343220,	-120.0173420),
		    new GLatLng(39.2340810,	-120.0168300),
		    new GLatLng(39.2337190,	-120.0162430),
		    new GLatLng(39.2332800,	-120.0158230),
		    new GLatLng(39.2327920,	-120.0154500),
		    new GLatLng(39.2297780,	-120.0137100),
		    new GLatLng(39.2293510,	-120.0133290),
		    new GLatLng(39.2290120,	-120.0129470),
		    new GLatLng(39.2284580,	-120.0122070),
		    new GLatLng(39.2281490,	-120.0116880),
		    new GLatLng(39.2277910,	-120.0108410),
		    new GLatLng(39.2272610,	-120.0090180),
		    new GLatLng(39.2270890,	-120.0082930),
		    new GLatLng(39.2269780,	-120.0074230),
		    new GLatLng(39.2270090,	-120.0066830),
		    new GLatLng(39.2272000,	-120.0060420),
		    new GLatLng(39.2274090,	-120.0056080),
		    new GLatLng(39.2274090,	-120.0056080),
		    new GLatLng(39.2280690,	-120.0042420),
		    new GLatLng(39.2282100,	-120.0040280),
		    new GLatLng(39.2284510,	-120.0037920),
		    new GLatLng(39.2287480,	-120.0036320),
		    new GLatLng(39.2290800,	-120.0035630),
		    new GLatLng(39.2310300,	-120.0035020),
		    new GLatLng(39.2316890,	-120.0034180),
		    new GLatLng(39.2344700,	-120.0025480),
		    new GLatLng(39.2373700,	-120.0015560),
		    new GLatLng(39.2385480,	-120.0015490),
		    new GLatLng(39.2395590,	-120.0008930),
		    new GLatLng(39.2407610,	-120.0005800),
		    new GLatLng(39.2414210,	-120.0005190),
		    new GLatLng(39.2419820,	-120.0003970),
		    new GLatLng(39.2423590,	-120.0002140),
		    new GLatLng(39.2425380,	-120.0000690),
		    new GLatLng(39.2435910,	-119.9989170),
		    new GLatLng(39.2438890,	-119.9986800),
		    new GLatLng(39.2441290,	-119.9985580),
		    new GLatLng(39.2449680,	-119.9983600),
		    new GLatLng(39.2453920,	-119.9981540),
		    new GLatLng(39.2466390,	-119.9969180),
		    new GLatLng(39.2477910,	-119.9961620),
		    new GLatLng(39.2481190,	-119.9957280),
		    new GLatLng(39.2492790,	-119.9934770),
		    new GLatLng(39.2494090,	-119.9931720),
		    new GLatLng(39.2495990,	-119.9924320),
		    new GLatLng(39.2496490,	-119.9918980),
		    new GLatLng(39.2496490,	-119.9911800),
		    new GLatLng(39.2495610,	-119.9898680),
		    new GLatLng(39.2493290,	-119.9878920),
		    new GLatLng(39.2492980,	-119.9870990),
		    new GLatLng(39.2494200,	-119.9843670),
		    new GLatLng(39.2495610,	-119.9834290),
		    new GLatLng(39.2496680,	-119.9830630),
		    new GLatLng(39.2503510,	-119.9815060),
		    new GLatLng(39.2505300,	-119.9809110),
		    new GLatLng(39.2505800,	-119.9806140),
		    new GLatLng(39.2506220,	-119.9798970),
		    new GLatLng(39.2505420,	-119.9788890),
		    new GLatLng(39.2505490,	-119.9782870),
		    new GLatLng(39.2506410,	-119.9777220),
		    new GLatLng(39.2510600,	-119.9760890),
		    new GLatLng(39.2511710,	-119.9754790),
		    new GLatLng(39.2512510,	-119.9746700),
		    new GLatLng(39.2512890,	-119.9730300),
		    new GLatLng(39.2512700,	-119.9723660),
		    new GLatLng(39.2508510,	-119.9674530),
		    new GLatLng(39.2507400,	-119.9653700),
		    new GLatLng(39.2503510,	-119.9618910),
		    new GLatLng(39.2498280,	-119.9562680),
		    new GLatLng(39.2495190,	-119.9487230),
		    new GLatLng(39.2494010,	-119.9475710),
		    new GLatLng(39.2488290,	-119.9446790),
		    new GLatLng(39.2486190,	-119.9438930),
		    new GLatLng(39.2481500,	-119.9426120),
		    new GLatLng(39.2476620,	-119.9414980),
		    new GLatLng(39.2414280,	-119.9314190),
		    new GLatLng(39.2407000,	-119.9304280),
		    new GLatLng(39.2398410,	-119.9295810),
		    new GLatLng(39.2392200,	-119.9290390),
		    new GLatLng(39.2387620,	-119.9287570),
		    new GLatLng(39.2380980,	-119.9285960),
		    new GLatLng(39.2375110,	-119.9286500),
		    new GLatLng(39.2369610,	-119.9288640),
		    new GLatLng(39.2328190,	-119.9318080),
		    new GLatLng(39.2321090,	-119.9321370),
		    new GLatLng(39.2313310,	-119.9321820),
		    new GLatLng(39.2300420,	-119.9318920),
		    new GLatLng(39.2291300,	-119.9320220),
		    new GLatLng(39.2284890,	-119.9320370),
		    new GLatLng(39.2282220,	-119.9321210),
		    new GLatLng(39.2274590,	-119.9325710),
		    new GLatLng(39.2270810,	-119.9327320),
		    new GLatLng(39.2264520,	-119.9328230),
		    new GLatLng(39.2260890,	-119.9327930),
		    new GLatLng(39.2247510,	-119.9324260),
		    new GLatLng(39.2244680,	-119.9322890),
		    new GLatLng(39.2240910,	-119.9318700),
		    new GLatLng(39.2224620,	-119.9296260),
		    new GLatLng(39.2215190,	-119.9280780),
		    new GLatLng(39.2212600,	-119.9278110),
		    new GLatLng(39.2209820,	-119.9276430),
		    new GLatLng(39.2201880,	-119.9274060),
		    new GLatLng(39.2181890,	-119.9271620),
		    new GLatLng(39.2175410,	-119.9272380),
		    new GLatLng(39.2172090,	-119.9273380),
		    new GLatLng(39.2168620,	-119.9275280),
		    new GLatLng(39.2155110,	-119.9286880),
		    new GLatLng(39.2152790,	-119.9287870),
		    new GLatLng(39.2149010,	-119.9287490),
		    new GLatLng(39.2143900,	-119.9284360),
		    new GLatLng(39.2139820,	-119.9283070),
		    new GLatLng(39.2129710,	-119.9283600),
		    new GLatLng(39.2117120,	-119.9282680),
		    new GLatLng(39.2111820,	-119.9283290),
		    new GLatLng(39.2107700,	-119.9285280),
		    new GLatLng(39.2100600,	-119.9291310),
		    new GLatLng(39.2095720,	-119.9293980),
		    new GLatLng(39.2091600,	-119.9294510),
		    new GLatLng(39.2081110,	-119.9291760),
		    new GLatLng(39.2075390,	-119.9291230),
		    new GLatLng(39.2067990,	-119.9291310),
		    new GLatLng(39.2064780,	-119.9292530),
		    new GLatLng(39.2056620,	-119.9300230),
		    new GLatLng(39.2054790,	-119.9301530),
		    new GLatLng(39.2051320,	-119.9302980),
		    new GLatLng(39.2048420,	-119.9303590),
		    new GLatLng(39.2034910,	-119.9304200),
		    new GLatLng(39.2031290,	-119.9303510),
		    new GLatLng(39.2027510,	-119.9301680),
		    new GLatLng(39.2004890,	-119.9288330),
		    new GLatLng(39.1996690,	-119.9284210),
		    new GLatLng(39.1973800,	-119.9276810),
		    new GLatLng(39.1941300,	-119.9267430),
		    new GLatLng(39.1932600,	-119.9267270),
		    new GLatLng(39.1906200,	-119.9270940),
		    new GLatLng(39.1903610,	-119.9270710),
		    new GLatLng(39.1897200,	-119.9268880),
		    new GLatLng(39.1893500,	-119.9268880),
		    new GLatLng(39.1883700,	-119.9272230),
		    new GLatLng(39.1879080,	-119.9273220),
		    new GLatLng(39.1876720,	-119.9273070),
		    new GLatLng(39.1869320,	-119.9271320),
		    new GLatLng(39.1856610,	-119.9272540),
		    new GLatLng(39.1845700,	-119.9269030),
		    new GLatLng(39.1834980,	-119.9267730),
		    new GLatLng(39.1824420,	-119.9260710),
		    new GLatLng(39.1818890,	-119.9257970),
		    new GLatLng(39.1814380,	-119.9256520),
		    new GLatLng(39.1796680,	-119.9253080),
		    new GLatLng(39.1791190,	-119.9251480),
		    new GLatLng(39.1786920,	-119.9249270),
		    new GLatLng(39.1773990,	-119.9240570),
		    new GLatLng(39.1770100,	-119.9238510),
		    new GLatLng(39.1759990,	-119.9236530),
		    new GLatLng(39.1749990,	-119.9231800),
		    new GLatLng(39.1745190,	-119.9231410),
		    new GLatLng(39.1741290,	-119.9232330),
		    new GLatLng(39.1738510,	-119.9233930),
		    new GLatLng(39.1716690,	-119.9252700),
		    new GLatLng(39.1714210,	-119.9254380),
		    new GLatLng(39.1708410,	-119.9256820),
		    new GLatLng(39.1698800,	-119.9258120),
		    new GLatLng(39.1694300,	-119.9259190),
		    new GLatLng(39.1685710,	-119.9263230),
		    new GLatLng(39.1681400,	-119.9266510),
		    new GLatLng(39.1675300,	-119.9272230),
		    new GLatLng(39.1672710,	-119.9275510),
		    new GLatLng(39.1665000,	-119.9287720),
		    new GLatLng(39.1662900,	-119.9290470),
		    new GLatLng(39.1659510,	-119.9293900),
		    new GLatLng(39.1653520,	-119.9298400),
		    new GLatLng(39.1645890,	-119.9301830),
		    new GLatLng(39.1642000,	-119.9302370),
		    new GLatLng(39.1636310,	-119.9302290),
		    new GLatLng(39.1613690,	-119.9298020),
		    new GLatLng(39.1611710,	-119.9298020),
		    new GLatLng(39.1607890,	-119.9298320),
		    new GLatLng(39.1603580,	-119.9299470),
		    new GLatLng(39.1589510,	-119.9304500),
		    new GLatLng(39.1579700,	-119.9305270),
		    new GLatLng(39.1570890,	-119.9304200),
		    new GLatLng(39.1544800,	-119.9296570),
		    new GLatLng(39.1536600,	-119.9292980),
		    new GLatLng(39.1528890,	-119.9287720),
		    new GLatLng(39.1523020,	-119.9282000),
		    new GLatLng(39.1514280,	-119.9272000),
		    new GLatLng(39.1510390,	-119.9269870),
		    new GLatLng(39.1508100,	-119.9269490),
		    new GLatLng(39.1487310,	-119.9269790),
		    new GLatLng(39.1478810,	-119.9267810),
		    new GLatLng(39.1470180,	-119.9263920),
		    new GLatLng(39.1467590,	-119.9263610),
		    new GLatLng(39.1461980,	-119.9264070),
		    new GLatLng(39.1456790,	-119.9263610),
		    new GLatLng(39.1452790,	-119.9261780),
		    new GLatLng(39.1447600,	-119.9257430),
		    new GLatLng(39.1445080,	-119.9256290),
		    new GLatLng(39.1441920,	-119.9256900),
		    new GLatLng(39.1435090,	-119.9261170),
		    new GLatLng(39.1431010,	-119.9261170),
		    new GLatLng(39.1405600,	-119.9247130),
		    new GLatLng(39.1402400,	-119.9246670),
		    new GLatLng(39.1400110,	-119.9247130),
		    new GLatLng(39.1398200,	-119.9248200),
		    new GLatLng(39.1395680,	-119.9250560),
		    new GLatLng(39.1392900,	-119.9254000),
		    new GLatLng(39.1381800,	-119.9270320),
		    new GLatLng(39.1379010,	-119.9273530),
		    new GLatLng(39.1336780,	-119.9308400),
		    new GLatLng(39.1328320,	-119.9313130),
		    new GLatLng(39.1320990,	-119.9315410),
		    new GLatLng(39.1311990,	-119.9316640),
		    new GLatLng(39.1296880,	-119.9316640),
		    new GLatLng(39.1294290,	-119.9316100),
		    new GLatLng(39.1289290,	-119.9314120),
		    new GLatLng(39.1286580,	-119.9312520),
		    new GLatLng(39.1280100,	-119.9306720),
		    new GLatLng(39.1275410,	-119.9304500),
		    new GLatLng(39.1265180,	-119.9301070),
		    new GLatLng(39.1255800,	-119.9300540),
		    new GLatLng(39.1250610,	-119.9299320),
		    new GLatLng(39.1237410,	-119.9294890),
		    new GLatLng(39.1228100,	-119.9290770),
		    new GLatLng(39.1216700,	-119.9284520),
		    new GLatLng(39.1197200,	-119.9270480),
		    new GLatLng(39.1188090,	-119.9266510),
		    new GLatLng(39.1180920,	-119.9264830),
		    new GLatLng(39.1155280,	-119.9263380),
		    new GLatLng(39.1152190,	-119.9262390),
		    new GLatLng(39.1149790,	-119.9260790),
		    new GLatLng(39.1146890,	-119.9256900),
		    new GLatLng(39.1145590,	-119.9253310),
		    new GLatLng(39.1144220,	-119.9246290),
		    new GLatLng(39.1142200,	-119.9242400),
		    new GLatLng(39.1138500,	-119.9238820),
		    new GLatLng(39.1125490,	-119.9229740),
		    new GLatLng(39.1121290,	-119.9227290),
		    new GLatLng(39.1115990,	-119.9225620),
		    new GLatLng(39.1092300,	-119.9223400),
		    new GLatLng(39.1087990,	-119.9222490),
		    new GLatLng(39.1083910,	-119.9220890),
		    new GLatLng(39.1080210,	-119.9218220),
		    new GLatLng(39.1076200,	-119.9214020),
		    new GLatLng(39.1072620,	-119.9208600),
		    new GLatLng(39.1052020,	-119.9172900),
		    new GLatLng(39.1048090,	-119.9168010),
		    new GLatLng(39.1037900,	-119.9157180),
		    new GLatLng(39.1036910,	-119.9155580),
		    new GLatLng(39.1035390,	-119.9152300),
		    new GLatLng(39.1033400,	-119.9144900),
		    new GLatLng(39.1031610,	-119.9140620),
		    new GLatLng(39.1011310,	-119.9103320),
		    new GLatLng(39.1007500,	-119.9095380),
		    new GLatLng(39.1007500,	-119.9095380),
		    new GLatLng(39.1012610,	-119.9089280),
		    new GLatLng(39.1014710,	-119.9085620),
		    new GLatLng(39.1017680,	-119.9078220),
		    new GLatLng(39.1020090,	-119.9059680),
		    new GLatLng(39.1021190,	-119.9054110),
		    new GLatLng(39.1022680,	-119.9048920),
		    new GLatLng(39.1028590,	-119.9032900),
		    new GLatLng(39.1030500,	-119.9026870),
		    new GLatLng(39.1031910,	-119.9020690),
		    new GLatLng(39.1035310,	-119.9001690),
		    new GLatLng(39.1052700,	-119.8923190),
		    new GLatLng(39.1055300,	-119.8905110),
		    new GLatLng(39.1055980,	-119.8891600),
		    new GLatLng(39.1055600,	-119.8890380),
		    new GLatLng(39.1056900,	-119.8875580),
		    new GLatLng(39.1058880,	-119.8865810),
		    new GLatLng(39.1067810,	-119.8832400),
		    new GLatLng(39.1068380,	-119.8825990),
		    new GLatLng(39.1068190,	-119.8811190),
		    new GLatLng(39.1069600,	-119.8803860),
		    new GLatLng(39.1071820,	-119.8798600),
		    new GLatLng(39.1074100,	-119.8795390),
		    new GLatLng(39.1077310,	-119.8792190),
		    new GLatLng(39.1080590,	-119.8790130),
		    new GLatLng(39.1084210,	-119.8788830),
		    new GLatLng(39.1090090,	-119.8788600),
		    new GLatLng(39.1092990,	-119.8789290),
		    new GLatLng(39.1097490,	-119.8791730),
		    new GLatLng(39.1102490,	-119.8797070),
		    new GLatLng(39.1111180,	-119.8814620),
		    new GLatLng(39.1123010,	-119.8827900),
		    new GLatLng(39.1124610,	-119.8830720),
		    new GLatLng(39.1128620,	-119.8840710),
		    new GLatLng(39.1134110,	-119.8857500),
		    new GLatLng(39.1137200,	-119.8862690),
		    new GLatLng(39.1142010,	-119.8867030),
		    new GLatLng(39.1146320,	-119.8868790),
		    new GLatLng(39.1150090,	-119.8869480),
		    new GLatLng(39.1154900,	-119.8868790),
		    new GLatLng(39.1159900,	-119.8865970),
		    new GLatLng(39.1163290,	-119.8862920),
		    new GLatLng(39.1166000,	-119.8858870),
		    new GLatLng(39.1167180,	-119.8856200),
		    new GLatLng(39.1168790,	-119.8849720),
		    new GLatLng(39.1169090,	-119.8845210),
		    new GLatLng(39.1168790,	-119.8839870),
		    new GLatLng(39.1165700,	-119.8804170),
		    new GLatLng(39.1166000,	-119.8800200),
		    new GLatLng(39.1167490,	-119.8793870),
		    new GLatLng(39.1169890,	-119.8788830),
		    new GLatLng(39.1172600,	-119.8785020),
		    new GLatLng(39.1188700,	-119.8770980),
		    new GLatLng(39.1193200,	-119.8765870),
		    new GLatLng(39.1196210,	-119.8759990),
		    new GLatLng(39.1198010,	-119.8752520),
		    new GLatLng(39.1198390,	-119.8747100),
		    new GLatLng(39.1197510,	-119.8739780),
		    new GLatLng(39.1195980,	-119.8734660),
		    new GLatLng(39.1194310,	-119.8731000),
		    new GLatLng(39.1192280,	-119.8727870),
		    new GLatLng(39.1189990,	-119.8725200),
		    new GLatLng(39.1185000,	-119.8721240),
		    new GLatLng(39.1174010,	-119.8717120),
		    new GLatLng(39.1169820,	-119.8714680),
		    new GLatLng(39.1166690,	-119.8712080),
		    new GLatLng(39.1155820,	-119.8701480),
		    new GLatLng(39.1152500,	-119.8697590),
		    new GLatLng(39.1148190,	-119.8690720),
		    new GLatLng(39.1144710,	-119.8682480),
		    new GLatLng(39.1142500,	-119.8674160),
		    new GLatLng(39.1141400,	-119.8665470),
		    new GLatLng(39.1141400,	-119.8655400),
		    new GLatLng(39.1142880,	-119.8645480),
		    new GLatLng(39.1148680,	-119.8626480),
		    new GLatLng(39.1149710,	-119.8620830),
		    new GLatLng(39.1151390,	-119.8588560),
		    new GLatLng(39.1151890,	-119.8584210),
		    new GLatLng(39.1153180,	-119.8578490),
		    new GLatLng(39.1154710,	-119.8574220),
		    new GLatLng(39.1156620,	-119.8570710),
		    new GLatLng(39.1164590,	-119.8558580),
		    new GLatLng(39.1165890,	-119.8555910),
		    new GLatLng(39.1167600,	-119.8550490),
		    new GLatLng(39.1168210,	-119.8544620),
		    new GLatLng(39.1168100,	-119.8541560),
		    new GLatLng(39.1162800,	-119.8516620),
		    new GLatLng(39.1162190,	-119.8509830),
		    new GLatLng(39.1162490,	-119.8502580),
		    new GLatLng(39.1162990,	-119.8499220),
		    new GLatLng(39.1165200,	-119.8491130),
		    new GLatLng(39.1166920,	-119.8486860),
		    new GLatLng(39.1172790,	-119.8475720),
		    new GLatLng(39.1175800,	-119.8467410),
		    new GLatLng(39.1176410,	-119.8460390),
		    new GLatLng(39.1175610,	-119.8449170),
		    new GLatLng(39.1175800,	-119.8443680),
		    new GLatLng(39.1177290,	-119.8435520),
		    new GLatLng(39.1179500,	-119.8429720),
		    new GLatLng(39.1181980,	-119.8425370),
		    new GLatLng(39.1218910,	-119.8381120),
		    new GLatLng(39.1222610,	-119.8375170),
		    new GLatLng(39.1224520,	-119.8369290),
		    new GLatLng(39.1225090,	-119.8365020),
		    new GLatLng(39.1225090,	-119.8361820),
		    new GLatLng(39.1224100,	-119.8355100),
		    new GLatLng(39.1222690,	-119.8350980),
		    new GLatLng(39.1216390,	-119.8339770),
		    new GLatLng(39.1214410,	-119.8334880),
		    new GLatLng(39.1213000,	-119.8328780),
		    new GLatLng(39.1212810,	-119.8323140),
		    new GLatLng(39.1213420,	-119.8317490),
		    new GLatLng(39.1215210,	-119.8311920),
		    new GLatLng(39.1217500,	-119.8307420),
		    new GLatLng(39.1224400,	-119.8296130),
		    new GLatLng(39.1226810,	-119.8290100),
		    new GLatLng(39.1228490,	-119.8280720),
		    new GLatLng(39.1228710,	-119.8274540),
		    new GLatLng(39.1227990,	-119.8267970),
		    new GLatLng(39.1227000,	-119.8264080),
		    new GLatLng(39.1225590,	-119.8259740),
		    new GLatLng(39.1223110,	-119.8254390),
		    new GLatLng(39.1220510,	-119.8250500),
		    new GLatLng(39.1217500,	-119.8247070),
		    new GLatLng(39.1209410,	-119.8240280),
		    new GLatLng(39.1205900,	-119.8236470),
		    new GLatLng(39.1203120,	-119.8231810),
		    new GLatLng(39.1201520,	-119.8227010),
		    new GLatLng(39.1200600,	-119.8221660),
		    new GLatLng(39.1200790,	-119.8215030),
		    new GLatLng(39.1201400,	-119.8211820),
		    new GLatLng(39.1203190,	-119.8206630),
		    new GLatLng(39.1207810,	-119.8196410),
		    new GLatLng(39.1209410,	-119.8189320),
		    new GLatLng(39.1209110,	-119.8181000),
		    new GLatLng(39.1207200,	-119.8174820),
		    new GLatLng(39.1204410,	-119.8170010),
		    new GLatLng(39.1201400,	-119.8166580),
		    new GLatLng(39.1199190,	-119.8164900),
		    new GLatLng(39.1188390,	-119.8159330),
		    new GLatLng(39.1184010,	-119.8154910),
		    new GLatLng(39.1181790,	-119.8151470),
		    new GLatLng(39.1177900,	-119.8142320),
		    new GLatLng(39.1174390,	-119.8136220),
		    new GLatLng(39.1171910,	-119.8133090),
		    new GLatLng(39.1157990,	-119.8119960),
		    new GLatLng(39.1154290,	-119.8113710),
		    new GLatLng(39.1152500,	-119.8107910),
		    new GLatLng(39.1143610,	-119.8072280),
		    new GLatLng(39.1142880,	-119.8068010),
		    new GLatLng(39.1143300,	-119.8060610),
		    new GLatLng(39.1145710,	-119.8052900),
		    new GLatLng(39.1147690,	-119.8049160),
		    new GLatLng(39.1150020,	-119.8046420),
		    new GLatLng(39.1158490,	-119.8038860),
		    new GLatLng(39.1160700,	-119.8036190),
		    new GLatLng(39.1163100,	-119.8032230),
		    new GLatLng(39.1164700,	-119.8028560),
		    new GLatLng(39.1166110,	-119.8023070),
		    new GLatLng(39.1166610,	-119.8019030),
		    new GLatLng(39.1166500,	-119.8012620),
		    new GLatLng(39.1165010,	-119.8005830),
		    new GLatLng(39.1162800,	-119.7999880),
		    new GLatLng(39.1159290,	-119.7994540),
		    new GLatLng(39.1149790,	-119.7983320),
		    new GLatLng(39.1146090,	-119.7976990),
		    new GLatLng(39.1143110,	-119.7969820),
		    new GLatLng(39.1135480,	-119.7945180),
		    new GLatLng(39.1133000,	-119.7935490),
		    new GLatLng(39.1132090,	-119.7923200),
		    new GLatLng(39.1134610,	-119.7877580),
		    new GLatLng(39.1137500,	-119.7861180),
		    new GLatLng(39.1142620,	-119.7844920),
		    new GLatLng(39.1146200,	-119.7836840),
		    new GLatLng(39.1150090,	-119.7829440),
		    new GLatLng(39.1203380,	-119.7733380),
		    new GLatLng(39.1208690,	-119.7723240),
		    new GLatLng(39.1208690,	-119.7721860),
		    new GLatLng(39.1208000,	-119.7719800),
		    new GLatLng(39.1208000,	-119.7719800),
		    new GLatLng(39.1132010,	-119.7733690),
		    new GLatLng(39.1061780,	-119.7744900),
		    new GLatLng(39.1048810,	-119.7747420),
		    new GLatLng(39.1036420,	-119.7748340),
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
		    new GLatLng(38.9556810,	-119.7675480)
		], "#6400CF", 3);
		map.addOverlay(polyline);
	
	if(typeof(showpoint) != 'undefined') {
		
		var pt = pointsNorthTahoe[showpoint];
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
		for (var i = 0; i < pointsNorthTahoe.length; i++) {
			var pt = pointsNorthTahoe[i];
			if(pt != null) {
				pt.coords = new GLatLng(pt.lat,pt.lon);
				map.addOverlay(pt.createMarker());
				bounds.extend(pt.coords);
			}
		}
		
		if(pointsNorthTahoe.length == 1) {
			map.setCenter(points[0].coords, 10);
			pointsNorthTahoe[0].popup();
		}
		else if (!bounds.isEmpty()) {
			boundzoom = map.getBoundsZoomLevel(bounds);
			map.setCenter(bounds.getCenter(), --boundzoom);
		}
	}
}

function loadGoogleMapNorthTahoe() {
	
	createMap( 'googlemapNorthTahoe' );
	loadMarkersLayerNorthTahoe();

}

google.load("maps", "2.x");
google.setOnLoadCallback(loadGoogleMapNorthTahoe);