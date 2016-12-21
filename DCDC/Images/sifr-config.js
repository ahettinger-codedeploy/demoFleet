var univers = {
  src: '/f/univers.swf'
};

sIFR.activate(univers);

sIFR.replace(univers, {
	selector: '#copy h2'
	,css: {
  		'.sIFR-root': { 'color': '#9d1d00', 'background-color': '#000000' }
	}
});