<!--
        if (document.images) {
            peopleon = new Image();             peopleon.src = "/newimages/rpeople_on.gif";
            ministrieson = new Image();         ministrieson.src = "/newimages/rministries_on.gif";
            worshipon = new Image();            worshipon.src = "/newimages/rworship_on.gif";
			eventson = new Image();             eventson.src = "/newimages/revents_on.gif";
			libraryon = new Image();            libraryon.src = "/newimages/rlibrary_on.gif";
			familylifeon = new Image();         familylifeon.src = "/newimages/rfamilylife_on.gif";
			abouton = new Image();              abouton.src = "/newimages/rabout_on.gif";

            peopleoff = new Image();            peopleoff.src = "/newimages/rpeople_off.gif";
            ministriesoff = new Image();        ministriesoff.src = "/newimages/rministries_off.gif";
            worshipoff = new Image();           worshipoff.src = "/newimages/rworship_off.gif";
			eventsoff = new Image();            eventsoff.src = "/newimages/revents_off.gif";
			libraryoff = new Image();           libraryoff.src = "/newimages/rlibrary_off.gif";
			familylifeoff = new Image();        familylifeoff.src = "/newimages/rfamilylife_off.gif";
			aboutoff = new Image();             aboutoff.src = "/newimages/rabout_off.gif";

         }

     function imgOn(imgName) {
            // if (document.images) {
            if (document[imgName]) {
                document.images[imgName].src = eval(imgName + "on.src");
            }
    }
	
	function imgOff(imgName) {
            // if (document.images) {
            if (document[imgName]) {
                document.images[imgName].src = eval(imgName + "off.src")
            }
    }

// -->