<!--
        if (document.images) {
            peopleon = new Image();             peopleon.src = "/PrivateLabel/ChampionForest/Images/rpeople_on.gif";
            ministrieson = new Image();         ministrieson.src = "/PrivateLabel/ChampionForest/Images/rministries_on.gif";
            worshipon = new Image();            worshipon.src = "/PrivateLabel/ChampionForest/Images/rworship_on.gif";
			eventson = new Image();             eventson.src = "/PrivateLabel/ChampionForest/Images/revents_on.gif";
			libraryon = new Image();            libraryon.src = "/PrivateLabel/ChampionForest/Images/rlibrary_on.gif";
			familylifeon = new Image();         familylifeon.src = "/PrivateLabel/ChampionForest/Images/rfamilylife_on.gif";
			abouton = new Image();              abouton.src = "/PrivateLabel/ChampionForest/Images/rabout_on.gif";

            peopleoff = new Image();            peopleoff.src = "/PrivateLabel/ChampionForest/Images/rpeople_off.gif";
            ministriesoff = new Image();        ministriesoff.src = "/PrivateLabel/ChampionForest/Images/rministries_off.gif";
            worshipoff = new Image();           worshipoff.src = "/PrivateLabel/ChampionForest/Images/rworship_off.gif";
			eventsoff = new Image();            eventsoff.src = "/PrivateLabel/ChampionForest/Images/revents_off.gif";
			libraryoff = new Image();           libraryoff.src = "/PrivateLabel/ChampionForest/Images/rlibrary_off.gif";
			familylifeoff = new Image();        familylifeoff.src = "/PrivateLabel/ChampionForest/Images/rfamilylife_off.gif";
			aboutoff = new Image();             aboutoff.src = "/PrivateLabel/ChampionForest/Images/rabout_off.gif";

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