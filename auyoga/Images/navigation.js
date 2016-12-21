// AU Navigation accordion opener - Marico Hawes 2009
function findElement(){
	var ptIndex; // prototype index value for the control we want to expand
	var thisSite = '/';
	var aH = $$('.accordion_content a');  //get all links

	if (aH == null || $('accordion_first') == undefined)
		return 0;

	var firstPtIndex = $('accordion_first')._prototypeEventID[0];  // get the first accord index

	aH = $A(aH);
	// alert(aH.length);

	var thisPage = aH.find(function(i){

		siteName = i.href.split('#')[0].split('?')[0];
		siteName = siteName.replace(thisSite,'');

		pageName = document.location.href.split('#')[0].split('?')[0];
		pageName = pageName.replace(thisSite,'');

		if (i.hash == '##')
			return 0;
	     	/*var iLen = String(i.href).length;
	     	if(String(i.href).substring(iLen, iLen - 2) == '####')
	     		return null;*/
	       	/* if(pageName==siteName)
	       		alert(i.href + ' ' +  document.location.href + thisSite); */
		return pageName == siteName;
	});

	// Open all accordions if we have 20 or fewer links
	if (aH.length == 0) {
		aT = $$('#nav-accordion-holder .accordion_toggle');
		// Loop through all accordion_toggles and manually set styles
		for (i=aT.length-1; i>=0; i--) {
			$$('#nav-accordion-holder .accordion_toggle')[i].addClassName('accordion_toggle_active');
			tA = $$('#nav-accordion-holder .accordion_toggle')[i].next(0);
			tA.setStyle({display: 'block',height:'auto'});
		}
	} else {
		if (thisPage != null) {
			// $(thisPage).addClassName('red-arrow red-active');
			thisPageParent = thisPage.parentNode.parentNode;
			pS = thisPageParent.parentNode;
			if (pS != null) {
				while ((pS.className != 'accordion_toggle') && (pS.className != 'accordion_toggle top') ) {
					pS = pS.previousSibling;
				}
				ptIndex = pS._prototypeEventID[0] - firstPtIndex;
				mainAccordion.activate($$('#nav-accordion-holder .accordion_toggle')[ptIndex]);
			}
		} else {
			mainAccordion.activate($$('#nav-accordion-holder .accordion_toggle')[0]);
		}
	}
}