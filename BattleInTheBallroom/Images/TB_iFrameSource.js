var queryString;
	
function TB_parseQuery(force,useTop) {
	//alert(queryString);
	if (!queryString || force == true) {
		queryString = new Array;
		var qs = (useTop == true) ? top.location.search : self.location.search;
		if (qs.length > 0) {
		    qs = decodeURIComponent(qs);  // added on 9/25 for MusicCityRoots - shouldn't effect existing clients
			qs = qs.substring(1,qs.length); // trim the "?" from the start
			var pairs = qs.split('&');
			var key;
			var value;
			var pair;
			for (i=0;i<pairs.length;i++) {
				pair = pairs[i].split('=');
				if (pair.length > 0) {
					key = pair[0];
					if (key.length > 0) {
						if (pair.length > 1) {
							value = '';
							for(k=1;k<pair.length;k++) {
								value += pair[k];
								if (k<pair.length-1) value += "=";
							}
						} else {
						 value = '';
						}
						//alert(key + " = " + value);
						queryString[key] = value;
					}
				}
			}
		}
	}
}

TB_parseQuery(true, false);
if (!(queryString['Page'] == null)) {
    
    var pageSrc;
    pageSrc = queryString['Page'].toUpperCase();
    
    if (pageSrc.indexOf("TICKETBISCUIT.COM") > 0 || pageSrc.indexOf("BATTLEPASS.COM") > 0 || pageSrc.indexOf("WHISTLETIX.COM") > 0 || pageSrc.indexOf("TICKETBISCUIT.ASKCTS.COM") > 0 || pageSrc.indexOf("BATTLEPASS.ASKCTS.COM") > 0 || pageSrc.indexOf("WHISTLETIX.ASKCTS.COM") > 0  || pageSrc.indexOf("LOCALHOST") > 0) {
        window.frames['TBFrame'].location = queryString['Page']; 
    }
}

