$(function(){
	$('#header .countdown').countdown({
		until: new Date(2011, 10-1, 22),
		layout: '<span class="n days">{dn}</span> days <span class="n hours">{hn}</span> hrs <span class="n minutes">{mn}</span> min <span class="n seconds">{sn}</span> sec'});
});