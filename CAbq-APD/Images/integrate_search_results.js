(function() {
var g = document.getElementById('searchform');
g.action='http://www.cabq.gov/results';

var input = document.createElement('input');
input.setAttribute('type', 'hidden');
input.setAttribute('name', 'cof');
input.setAttribute('value', 'FORID:11');

g.appendChild(input)

})();