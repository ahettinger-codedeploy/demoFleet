var map;
var geocoder;
var gc_title;
var bounds; 
var pointsTahoe = Array();

pointsTahoe[0] = new PVGeoMarker('From: 395 Eugene Drive, Stateline, NV 89449 (South Shore Tahoe LLC)', null, '<p></p>', -119.946213,38.974190 );
//pointsTahoe[1] = new PVGeoMarker('Directions to 1627 US Highway 395 North, Minden, NV 89423 (Carson Valley Inn)', null, '<p></p>', , );
pointsTahoe[2] = new PVGeoMarker('To: 1627 US Highway 395 North, Minden, NV 89423 (Carson Valley Inn)', null, '<p></p>', -119.767548,38.955685 );

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

function loadMarkersLayerTahoe() {
	bounds = new GLatLngBounds();
	map.clearOverlays();   	
	
	var polyline = new GPolyline([	    
		    new GLatLng(38.9741900,	-119.9462100),
		    new GLatLng(38.9727200,	-119.9428400),
		    new GLatLng(38.9732000,	-119.9425100),
		    new GLatLng(38.9732000,	-119.9425100),
		    new GLatLng(38.9733500,	-119.9423700),
		    new GLatLng(38.9709100,	-119.9366600),
		    new GLatLng(38.9703000,	-119.9350500),
		    new GLatLng(38.9703000,	-119.9350500),
		    new GLatLng(38.9697800,	-119.9351500),
		    new GLatLng(38.9691600,	-119.9353800),
		    new GLatLng(38.9676300,	-119.9363100),
		    new GLatLng(38.9676300,	-119.9363100),
		    new GLatLng(38.9680800,	-119.9350600),
		    new GLatLng(38.9682800,	-119.9343400),
		    new GLatLng(38.9683700,	-119.9337000),
		    new GLatLng(38.9684100,	-119.9327600),
		    new GLatLng(38.9683500,	-119.9307100),
		    new GLatLng(38.9683800,	-119.9294400),
		    new GLatLng(38.9683100,	-119.9285300),
		    new GLatLng(38.9675500,	-119.9255200),
		    new GLatLng(38.9675900,	-119.9240900),
		    new GLatLng(38.9675400,	-119.9231700),
		    new GLatLng(38.9673000,	-119.9225100),
		    new GLatLng(38.9671100,	-119.9222200),
		    new GLatLng(38.9669500,	-119.9217000),
		    new GLatLng(38.9670000,	-119.9204800),
		    new GLatLng(38.9671500,	-119.9194200),
		    new GLatLng(38.9673900,	-119.9183200),
		    new GLatLng(38.9674900,	-119.9180400),
		    new GLatLng(38.9676300,	-119.9178100),
		    new GLatLng(38.9677700,	-119.9176400),
		    new GLatLng(38.9681300,	-119.9174000),
		    new GLatLng(38.9699300,	-119.9170500),
		    new GLatLng(38.9703600,	-119.9170400),
		    new GLatLng(38.9706200,	-119.9169300),
		    new GLatLng(38.9707300,	-119.9167800),
		    new GLatLng(38.9707700,	-119.9166600),
		    new GLatLng(38.9707200,	-119.9164300),
		    new GLatLng(38.9704500,	-119.9159400),
		    new GLatLng(38.9703100,	-119.9154400),
		    new GLatLng(38.9703200,	-119.9152100),
		    new GLatLng(38.9704800,	-119.9146800),
		    new GLatLng(38.9709100,	-119.9136800),
		    new GLatLng(38.9713600,	-119.9121200),
		    new GLatLng(38.9714800,	-119.9119400),
		    new GLatLng(38.9724500,	-119.9111300),
		    new GLatLng(38.9726900,	-119.9107700),
		    new GLatLng(38.9728800,	-119.9103700),
		    new GLatLng(38.9730400,	-119.9097100),
		    new GLatLng(38.9729500,	-119.9087900),
		    new GLatLng(38.9727300,	-119.9081300),
		    new GLatLng(38.9726500,	-119.9077500),
		    new GLatLng(38.9726700,	-119.9070100),
		    new GLatLng(38.9727400,	-119.9065700),
		    new GLatLng(38.9727400,	-119.9052600),
		    new GLatLng(38.9728000,	-119.9049200),
		    new GLatLng(38.9734300,	-119.9035800),
		    new GLatLng(38.9735300,	-119.9030700),
		    new GLatLng(38.9736400,	-119.9021300),
		    new GLatLng(38.9737100,	-119.9019500),
		    new GLatLng(38.9739700,	-119.9017100),
		    new GLatLng(38.9741600,	-119.9016600),
		    new GLatLng(38.9746300,	-119.9016900),
		    new GLatLng(38.9747600,	-119.9016400),
		    new GLatLng(38.9748900,	-119.9015500),
		    new GLatLng(38.9750300,	-119.9012800),
		    new GLatLng(38.9750300,	-119.9010500),
		    new GLatLng(38.9749400,	-119.9008200),
		    new GLatLng(38.9747500,	-119.9006500),
		    new GLatLng(38.9744500,	-119.9005400),
		    new GLatLng(38.9737400,	-119.9004600),
		    new GLatLng(38.9733600,	-119.9003200),
		    new GLatLng(38.9731400,	-119.9000700),
		    new GLatLng(38.9730400,	-119.8996600),
		    new GLatLng(38.9730500,	-119.8994800),
		    new GLatLng(38.9732400,	-119.8990400),
		    new GLatLng(38.9738800,	-119.8982900),
		    new GLatLng(38.9741500,	-119.8976700),
		    new GLatLng(38.9748000,	-119.8969300),
		    new GLatLng(38.9748800,	-119.8966000),
		    new GLatLng(38.9748500,	-119.8959000),
		    new GLatLng(38.9749000,	-119.8953200),
		    new GLatLng(38.9752000,	-119.8947000),
		    new GLatLng(38.9757200,	-119.8941600),
		    new GLatLng(38.9759200,	-119.8937900),
		    new GLatLng(38.9760500,	-119.8934400),
		    new GLatLng(38.9767700,	-119.8907400),
		    new GLatLng(38.9766900,	-119.8898400),
		    new GLatLng(38.9764900,	-119.8890800),
		    new GLatLng(38.9764700,	-119.8888500),
		    new GLatLng(38.9765100,	-119.8886600),
		    new GLatLng(38.9768800,	-119.8880800),
		    new GLatLng(38.9773000,	-119.8877400),
		    new GLatLng(38.9777000,	-119.8875800),
		    new GLatLng(38.9784100,	-119.8874500),
		    new GLatLng(38.9787900,	-119.8872400),
		    new GLatLng(38.9790200,	-119.8869500),
		    new GLatLng(38.9792000,	-119.8865600),
		    new GLatLng(38.9792600,	-119.8862600),
		    new GLatLng(38.9792700,	-119.8859700),
		    new GLatLng(38.9792200,	-119.8856200),
		    new GLatLng(38.9791000,	-119.8853100),
		    new GLatLng(38.9788900,	-119.8850100),
		    new GLatLng(38.9785700,	-119.8847500),
		    new GLatLng(38.9770800,	-119.8842400),
		    new GLatLng(38.9768400,	-119.8841200),
		    new GLatLng(38.9765300,	-119.8838400),
		    new GLatLng(38.9763700,	-119.8835600),
		    new GLatLng(38.9762600,	-119.8832300),
		    new GLatLng(38.9759600,	-119.8817300),
		    new GLatLng(38.9757600,	-119.8812400),
		    new GLatLng(38.9755800,	-119.8809600),
		    new GLatLng(38.9750100,	-119.8803100),
		    new GLatLng(38.9746400,	-119.8796700),
		    new GLatLng(38.9744400,	-119.8787300),
		    new GLatLng(38.9743400,	-119.8770100),
		    new GLatLng(38.9743800,	-119.8761600),
		    new GLatLng(38.9743400,	-119.8756500),
		    new GLatLng(38.9741600,	-119.8746200),
		    new GLatLng(38.9741700,	-119.8742600),
		    new GLatLng(38.9743800,	-119.8729300),
		    new GLatLng(38.9744100,	-119.8726100),
		    new GLatLng(38.9743900,	-119.8722800),
		    new GLatLng(38.9739000,	-119.8703700),
		    new GLatLng(38.9738600,	-119.8699400),
		    new GLatLng(38.9739500,	-119.8694700),
		    new GLatLng(38.9741200,	-119.8691500),
		    new GLatLng(38.9743400,	-119.8688800),
		    new GLatLng(38.9748200,	-119.8686700),
		    new GLatLng(38.9754100,	-119.8686100),
		    new GLatLng(38.9759600,	-119.8686200),
		    new GLatLng(38.9764900,	-119.8687000),
		    new GLatLng(38.9774700,	-119.8690100),
		    new GLatLng(38.9778900,	-119.8690700),
		    new GLatLng(38.9783900,	-119.8690300),
		    new GLatLng(38.9805500,	-119.8686400),
		    new GLatLng(38.9807900,	-119.8685200),
		    new GLatLng(38.9811700,	-119.8682000),
		    new GLatLng(38.9813400,	-119.8679900),
		    new GLatLng(38.9814600,	-119.8677200),
		    new GLatLng(38.9815800,	-119.8672800),
		    new GLatLng(38.9817900,	-119.8659200),
		    new GLatLng(38.9818000,	-119.8650100),
		    new GLatLng(38.9816600,	-119.8642800),
		    new GLatLng(38.9812700,	-119.8633300),
		    new GLatLng(38.9804200,	-119.8622900),
		    new GLatLng(38.9800000,	-119.8616900),
		    new GLatLng(38.9787100,	-119.8585200),
		    new GLatLng(38.9786000,	-119.8582100),
		    new GLatLng(38.9785200,	-119.8576900),
		    new GLatLng(38.9786700,	-119.8561600),
		    new GLatLng(38.9786200,	-119.8558300),
		    new GLatLng(38.9785500,	-119.8556400),
		    new GLatLng(38.9782700,	-119.8551700),
		    new GLatLng(38.9780500,	-119.8549800),
		    new GLatLng(38.9778000,	-119.8548600),
		    new GLatLng(38.9775200,	-119.8548200),
		    new GLatLng(38.9771200,	-119.8549200),
		    new GLatLng(38.9769000,	-119.8551000),
		    new GLatLng(38.9767200,	-119.8553300),
		    new GLatLng(38.9765800,	-119.8556100),
		    new GLatLng(38.9765000,	-119.8558900),
		    new GLatLng(38.9764800,	-119.8563000),
		    new GLatLng(38.9765300,	-119.8566900),
		    new GLatLng(38.9766800,	-119.8570700),
		    new GLatLng(38.9771800,	-119.8577200),
		    new GLatLng(38.9774400,	-119.8582400),
		    new GLatLng(38.9775200,	-119.8585400),
		    new GLatLng(38.9775100,	-119.8591000),
		    new GLatLng(38.9773600,	-119.8595900),
		    new GLatLng(38.9771000,	-119.8599100),
		    new GLatLng(38.9769000,	-119.8600700),
		    new GLatLng(38.9766500,	-119.8601800),
		    new GLatLng(38.9764900,	-119.8601900),
		    new GLatLng(38.9760700,	-119.8601100),
		    new GLatLng(38.9758100,	-119.8599500),
		    new GLatLng(38.9756100,	-119.8597500),
		    new GLatLng(38.9737400,	-119.8573400),
		    new GLatLng(38.9727700,	-119.8564300),
		    new GLatLng(38.9725600,	-119.8560400),
		    new GLatLng(38.9722500,	-119.8552900),
		    new GLatLng(38.9720300,	-119.8549200),
		    new GLatLng(38.9708500,	-119.8532500),
		    new GLatLng(38.9706100,	-119.8529900),
		    new GLatLng(38.9703900,	-119.8528500),
		    new GLatLng(38.9698300,	-119.8527100),
		    new GLatLng(38.9695400,	-119.8527400),
		    new GLatLng(38.9692600,	-119.8528800),
		    new GLatLng(38.9690700,	-119.8530600),
		    new GLatLng(38.9687500,	-119.8534900),
		    new GLatLng(38.9682600,	-119.8544400),
		    new GLatLng(38.9682100,	-119.8547000),
		    new GLatLng(38.9681900,	-119.8553600),
		    new GLatLng(38.9682200,	-119.8563100),
		    new GLatLng(38.9679500,	-119.8569900),
		    new GLatLng(38.9672000,	-119.8580000),
		    new GLatLng(38.9670400,	-119.8582800),
		    new GLatLng(38.9669500,	-119.8586100),
		    new GLatLng(38.9669300,	-119.8589800),
		    new GLatLng(38.9669900,	-119.8602000),
		    new GLatLng(38.9668500,	-119.8607500),
		    new GLatLng(38.9667500,	-119.8609300),
		    new GLatLng(38.9664700,	-119.8612700),
		    new GLatLng(38.9662000,	-119.8613800),
		    new GLatLng(38.9657900,	-119.8613600),
		    new GLatLng(38.9643900,	-119.8611100),
		    new GLatLng(38.9639200,	-119.8609800),
		    new GLatLng(38.9636800,	-119.8608300),
		    new GLatLng(38.9634700,	-119.8605800),
		    new GLatLng(38.9632700,	-119.8601600),
		    new GLatLng(38.9632200,	-119.8598200),
		    new GLatLng(38.9632100,	-119.8596000),
		    new GLatLng(38.9632700,	-119.8592400),
		    new GLatLng(38.9634800,	-119.8585000),
		    new GLatLng(38.9635000,	-119.8582600),
		    new GLatLng(38.9635400,	-119.8561500),
		    new GLatLng(38.9634800,	-119.8558000),
		    new GLatLng(38.9632900,	-119.8554000),
		    new GLatLng(38.9623100,	-119.8539900),
		    new GLatLng(38.9621200,	-119.8534600),
		    new GLatLng(38.9621300,	-119.8527500),
		    new GLatLng(38.9622000,	-119.8524000),
		    new GLatLng(38.9625100,	-119.8515300),
		    new GLatLng(38.9626100,	-119.8510900),
		    new GLatLng(38.9626700,	-119.8505900),
		    new GLatLng(38.9627800,	-119.8485500),
		    new GLatLng(38.9626900,	-119.8480800),
		    new GLatLng(38.9625400,	-119.8477500),
		    new GLatLng(38.9623400,	-119.8474200),
		    new GLatLng(38.9621500,	-119.8472600),
		    new GLatLng(38.9614600,	-119.8469500),
		    new GLatLng(38.9604300,	-119.8465800),
		    new GLatLng(38.9599000,	-119.8464400),
		    new GLatLng(38.9596800,	-119.8464500),
		    new GLatLng(38.9594300,	-119.8465000),
		    new GLatLng(38.9591400,	-119.8466700),
		    new GLatLng(38.9576000,	-119.8479400),
		    new GLatLng(38.9572400,	-119.8480700),
		    new GLatLng(38.9559100,	-119.8478600),
		    new GLatLng(38.9556600,	-119.8478600),
		    new GLatLng(38.9544000,	-119.8484000),
		    new GLatLng(38.9538100,	-119.8484900),
		    new GLatLng(38.9534600,	-119.8484200),
		    new GLatLng(38.9525300,	-119.8480200),
		    new GLatLng(38.9521600,	-119.8479500),
		    new GLatLng(38.9516300,	-119.8480800),
		    new GLatLng(38.9501300,	-119.8491500),
		    new GLatLng(38.9497100,	-119.8493400),
		    new GLatLng(38.9494800,	-119.8493700),
		    new GLatLng(38.9488500,	-119.8491800),
		    new GLatLng(38.9486200,	-119.8490000),
		    new GLatLng(38.9482800,	-119.8486000),
		    new GLatLng(38.9476000,	-119.8473500),
		    new GLatLng(38.9471700,	-119.8469500),
		    new GLatLng(38.9466900,	-119.8467700),
		    new GLatLng(38.9464900,	-119.8467600),
		    new GLatLng(38.9462100,	-119.8468300),
		    new GLatLng(38.9440700,	-119.8478300),
		    new GLatLng(38.9432700,	-119.8480200),
		    new GLatLng(38.9426200,	-119.8480900),
		    new GLatLng(38.9420800,	-119.8481000),
		    new GLatLng(38.9413100,	-119.8479500),
		    new GLatLng(38.9397400,	-119.8474900),
		    new GLatLng(38.9392900,	-119.8474800),
		    new GLatLng(38.9386300,	-119.8475800),
		    new GLatLng(38.9381800,	-119.8477400),
		    new GLatLng(38.9378100,	-119.8478100),
		    new GLatLng(38.9373600,	-119.8477600),
		    new GLatLng(38.9364700,	-119.8475200),
		    new GLatLng(38.9357900,	-119.8474500),
		    new GLatLng(38.9348500,	-119.8474900),
		    new GLatLng(38.9344900,	-119.8474500),
		    new GLatLng(38.9340200,	-119.8473200),
		    new GLatLng(38.9335600,	-119.8471100),
		    new GLatLng(38.9331300,	-119.8467900),
		    new GLatLng(38.9326300,	-119.8463000),
		    new GLatLng(38.9290100,	-119.8416800),
		    new GLatLng(38.9287300,	-119.8411600),
		    new GLatLng(38.9285900,	-119.8407700),
		    new GLatLng(38.9285200,	-119.8403700),
		    new GLatLng(38.9285100,	-119.8389800),
		    new GLatLng(38.9285100,	-119.8389800),
		    new GLatLng(38.9286200,	-119.8373500),
		    new GLatLng(38.9322400,	-119.8239300),
		    new GLatLng(38.9323100,	-119.8233600),
		    new GLatLng(38.9323000,	-119.8168600),
		    new GLatLng(38.9321900,	-119.8101500),
		    new GLatLng(38.9321700,	-119.8021300),
		    new GLatLng(38.9322700,	-119.7844300),
		    new GLatLng(38.9323600,	-119.7794500),
		    new GLatLng(38.9323600,	-119.7794500),
		    new GLatLng(38.9395400,	-119.7795700),
		    new GLatLng(38.9435300,	-119.7795800),
		    new GLatLng(38.9490200,	-119.7795000),
		    new GLatLng(38.9526800,	-119.7793700),
		    new GLatLng(38.9556500,	-119.7793500),
		    new GLatLng(38.9556500,	-119.7793500),
		    new GLatLng(38.9557700,	-119.7792100),
		    new GLatLng(38.9558000,	-119.7788900),
		    new GLatLng(38.9560400,	-119.7779100),
		    new GLatLng(38.9563300,	-119.7762800),
		    new GLatLng(38.9561800,	-119.7757300),
		    new GLatLng(38.9557700,	-119.7746400),
		    new GLatLng(38.9543700,	-119.7711400),
		    new GLatLng(38.9543700,	-119.7711400),
		    new GLatLng(38.9558300,	-119.7701800),
		    new GLatLng(38.9558300,	-119.7701800),
		    new GLatLng(38.9553400,	-119.7690300),
		    new GLatLng(38.9553400,	-119.7690300),
		    new GLatLng(38.9560400,	-119.7685500)
		], "#6400CF", 3);
		map.addOverlay(polyline);
	
	if(typeof(showpoint) != 'undefined') {
		
		var pt = pointsTahoe[showpoint];
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
		for (var i = 0; i < pointsTahoe.length; i++) {
			var pt = pointsTahoe[i];
			if(pt != null) {
				pt.coords = new GLatLng(pt.lat,pt.lon);
				map.addOverlay(pt.createMarker());
				bounds.extend(pt.coords);
			}
		}
		
		if(pointsTahoe.length == 1) {
			map.setCenter(pointsTahoe[0].coords, 10);
			pointsTahoe[0].popup();
		}
		else if (!bounds.isEmpty()) {
			boundzoom = map.getBoundsZoomLevel(bounds);
			map.setCenter(bounds.getCenter(), --boundzoom);
		}
	}
}

function loadGoogleMapTahoe() {
	
	createMap( 'googlemapTahoe' );
	loadMarkersLayerTahoe();

}

google.load("maps", "2.x");
google.setOnLoadCallback(loadGoogleMapTahoe);