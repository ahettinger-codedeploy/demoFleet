$(document).ready(function() {
$('a.popup').click(function() {
var popupid = $(this).attr('rel');
$('#' + popupid).fadeIn();
$('body').append('<div id="fade"></div>');
$('#fade').css({'filter' : 'alpha(opacity=80)'}).fadeIn();
var popuptopmargin = ($('#' + popupid).height() + 10) / 2;
var popupleftmargin = ($('#' + popupid).width() + 10) / 2;
$('#' + popupid).css({
'margin-top' : -popuptopmargin,
'margin-left' : -popupleftmargin
});
});
$('#fade').click(function() {
$('#fade , #popuprel').fadeOut()
return false;
});
});