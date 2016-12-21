var avenir_85 = {
	src: 'avenir_85b.swf'
}

var exponto_bold = {
	src: 'exponto_bold.swf'
}

sIFR.activate(avenir_85, exponto_bold);


function sifr_replace_all() {
	sIFR.replace(exponto_bold, {
		selector: 'h1',
		wmode: 'transparent',
		css: {
				'.sIFR-root': { 'color': '#a41d21'}
			},
		ratios: [9,1.16,16,1.09,24,1.06,31,1.04,32,1.05,49,1.03,74,1.02,95,1.01,96,1.02,1.01]
	});
	
	sIFR.replace(exponto_bold, {
		selector: 'h2',
		wmode: 'transparent',
		css: {
				'.sIFR-root': { 'color': '#e7a34b'},
				'a': { 'color': '#e7a34b', 'text-decoration': 'underline'},
				'a:hover': { 'color': '#e7a34b', 'text-decoration': 'underline'}
			},
		ratios: [9,1.16,16,1.09,24,1.06,31,1.04,32,1.05,49,1.03,74,1.02,95,1.01,96,1.02,1.01]
	});

	sIFR.replace(avenir_85, {
		selector: 'h3',
		wmode: 'transparent',
		css: {
				'.sIFR-root': { 'color': '#a41d21'},
				'a': { 'color': '#a41d21', 'text-decoration': 'none'},
				'a:hover': { 'color': '#a41d21', 'text-decoration': 'none'},
				'.black': { 'color': '#000000'}
			},
		ratios: [9,1.16,16,1.09,24,1.06,37,1.04,74,1.02,1.01]
	});

	sIFR.replace(avenir_85, {
		selector: 'h4',
		wmode: 'transparent',
		css: {
				'.sIFR-root': { 'color': '#a41d21'}
			},
		ratios: [9,1.16,16,1.09,24,1.06,37,1.04,74,1.02,1.01]
	});	
}

sifr_replace_all();
