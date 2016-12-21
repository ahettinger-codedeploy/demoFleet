
var requiem = {
	src: '/astralpress/wp-content/themes/astral/lib/requiem.swf'
	,ratios: [6,1.41,9,1.35,15,1.29,21,1.25,22,1.22,27,1.24,29,1.21,34,1.22,41,1.21,45,1.2,46,1.21,59,1.2,68,1.19,69,1.2,96,1.19,97,1.18,102,1.19,103,1.18,107,1.19,108,1.18,112,1.19,114,1.18,116,1.19,120,1.18,121,1.19,1.18]
};

// sIFR.domains = ['astralartisticservices.org'] // Don't check for domains in this demo
sIFR.useStyleCheck = true;
sIFR.activate(requiem);

sIFR.replace(requiem, {
	selector: 'body.home h2'
		,wmode: 'transparent'
		,color: '#ffffff'
		,css: [
			'.sIFR-root { color: #ffffff; font-size: 42px; text-align: center; font-weight: normal; }'
			,'a { text-decoration: none; }'
			,'a:link { color: #000000; }'
			,'a:hover { color: #CCCCCC; }'
		]
});

sIFR.replace(requiem, {
	selector: '.page h1'
		,wmode: 'transparent'
		,color: '#ffffff'
		,css: [
			'.sIFR-root { color: #ffffff; letter-spacing: 1; font-size: 42px; text-align: left; font-weight: bold; }'
			,'em { font-style: normal; font-size: 40px; display: block; clear: left; }'
		]
});

sIFR.replace(requiem, {
	selector: '.page h2'
		,wmode: 'transparent'
		,color: '#ffffff'
		,css: [
			'.sIFR-root { color: #ffffff; letter-spacing: 1; font-size: 36px; text-align: left; font-weight: bold; }'
			,'a { text-decoration: none; }'
			,'a:link { color: #f9f9f9; }'
			,'a:hover { color: #CCCCCC; }'
			,'em { font-style: normal; font-size: 40px;   }'
		]
});

sIFR.replace(requiem, {
	selector: '.page h3'
		,wmode: 'transparent'
		,color: '#ffffff'
		,css: [
			'.sIFR-root { color: #ffffff; font-size: 24px; text-align: left; font-weight: bold; }'
			,'a {  }'
			,'a:link { color: #f9f9f9; }'
			,'a:hover { color: #CCCCCC; }'
			,'em { font-style: normal; font-size: 80; }'
		]
});

sIFR.replace(requiem, {
	selector: '.page blockquote'
		,wmode: 'transparent'
		,color: '#ffffff'
		,css: [
			'.sIFR-root { color: #ffffff; font-size: 18px; text-align: left; font-weight: bold; }'
			,'a {  }'
			,'a:link { color: #f9f9f9; }'
			,'a:hover { color: #CCCCCC; }'
			,'cite { font-style: normal; font-size: 80; }'
		]
});

sIFR.replace(requiem, {
	selector: 'h3.tagline'
		,wmode: 'transparent'
		,css: [
			'.sIFR-root { color: #ffffff; letter-spacing: 1; font-size: 36px; text-align: left; font-weight: normal; }'
			,'a { text-decoration: none; }'
			,'a:link { color: #f9f9f9; }'
			,'a:hover { color: #CCCCCC; }'
			,'em { font-style: normal; font-size: 40px; display: block; }'
		]
});

sIFR.replace(requiem, {
	selector: 'body.home h4'
		,wmode: 'transparent'
		,css: [
			'.sIFR-root { color: #ffffff; font-size: 36px; text-align: center; font-weight: normal; }'
			,'a { text-decoration: none; }'
			,'a:link { color: #f9f9f9; }'
			,'a:hover { color: #CCCCCC; }'
		]
});
