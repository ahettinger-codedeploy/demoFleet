function initCufon() {
	Cufon.replace('#header .reservation', { fontFamily: 'bignood_regular', hover: true });
	Cufon.replace('#header .phone', { fontFamily: 'bignood_regular', hover: true });
	Cufon.replace('#content .block h2', { fontFamily: 'bignood_regular', hover: true });
	Cufon.replace('#content .data h2', { fontFamily: 'bignood_regular', hover: true });
	Cufon.replace('#sidebar fieldset .submit', { fontFamily: 'bignood_regular', hover: true });

	Cufon.replace('#content .slogan-box h1', { textShadow: '#555 1px 1px, #000 2px 2px', fontFamily: 'bignood_regular' });
	Cufon.replace('#sidebar h3', { textShadow: '#555 1px 1px, #000 2px 2px', fontFamily: 'bignood_regular' });
	Cufon.replace('#content .slogan-box a', { textShadow: '#555 1px 1px, #000 2px 2px', fontFamily: 'bignood_regular' });
	Cufon.replace('#sidebar .slogan-box a', { textShadow: '#555 1px 1px, #000 2px 2px', fontFamily: 'bignood_regular' });
		
	Cufon.replace('#sidebar .contact-box h3', { fontFamily: 'bignood_regular', hover: true });
}

$(document).ready(function(){
	initCufon();
});