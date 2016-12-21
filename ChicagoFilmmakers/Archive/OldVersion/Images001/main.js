n1off = new Image(62, 22);
n1off.src = "/PrivateLabel/ChicagoFilmmakers/Images/nav_home_off.gif";
n2off = new Image(59, 22);
n2off.src = "/PrivateLabel/ChicagoFilmmakers/Images/nav_films_off.gif";
n3off = new Image(64, 22);
n3off.src = "/PrivateLabel/ChicagoFilmmakers/Images/nav_events_off.gif";
n4off = new Image(70, 22);
n4off.src = "/PrivateLabel/ChicagoFilmmakers/Images/nav_tickets_off.gif";
n5off = new Image(82, 22);
n5off.src = "/PrivateLabel/ChicagoFilmmakers/Images/nav_sponsors_off.gif";
n6off = new Image(67, 22);
n6off.src = "/PrivateLabel/ChicagoFilmmakers/Images/nav_venues_off.gif";
n7off = new Image(63, 22);
n7off.src = "/PrivateLabel/ChicagoFilmmakers/Images/nav_travel_off.gif";
n8off = new Image(57, 22);
n8off.src = "/PrivateLabel/ChicagoFilmmakers/Images/nav_media_off.gif";
n9off = new Image(78, 22);
n9off.src = "/PrivateLabel/ChicagoFilmmakers/Images/nav_about_off.gif";

n1on = new Image(62, 22);
n1on.src = "/PrivateLabel/ChicagoFilmmakers/Images/nav_home_on.gif";
n2on = new Image(59, 22);
n2on.src = "/PrivateLabel/ChicagoFilmmakers/Images/nav_films_on.gif";
n3on = new Image(64, 22);
n3on.src = "/PrivateLabel/ChicagoFilmmakers/Images/nav_events_on.gif";
n4on = new Image(70, 22);
n4on.src = "/PrivateLabel/ChicagoFilmmakers/Images/nav_tickets_on.gif";
n5on = new Image(82, 22);
n5on.src = "/PrivateLabel/ChicagoFilmmakers/Images/nav_sponsors_on.gif";
n6on = new Image(67, 22);
n6on.src = "/PrivateLabel/ChicagoFilmmakers/Images/nav_venues_on.gif";
n7on = new Image(63, 22);
n7on.src = "/PrivateLabel/ChicagoFilmmakers/Images/nav_travel_on.gif";
n8on = new Image(57, 22);
n8on.src = "/PrivateLabel/ChicagoFilmmakers/Images/nav_media_on.gif";
n9on = new Image(78, 22);
n9on.src = "/PrivateLabel/ChicagoFilmmakers/Images/nav_about_on.gif";

function img_act(v) {
	document[v].src = eval(v + "on.src");
}
function img_inact(v) {
	document[v].src = eval(v + "off.src");
}
