var optima = {
  src: '/f/optima-md3.swf'
};

sIFR.activate(optima);

sIFR.replace(optima, {
  selector: 'h2',
  css: { '.sIFR-root': { 'letter-spacing': -1.1 } },
  wmode: "Transparent"
});
