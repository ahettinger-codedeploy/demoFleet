var imageFiles_ac_13 = new Array();
imageFiles_ac_13['0'] = new Array ('/PrivateLabel/ChicagoClubCabaret/images/ac_Home.gif', '/PrivateLabel/ChicagoClubCabaret/images/ac_HomeMouseover.gif');
imageFiles_ac_13['1'] = new Array ('/PrivateLabel/ChicagoClubCabaret/images/ac_Show_Times.gif', '/PrivateLabel/ChicagoClubCabaret/images/ac_Show_TimesMouseover.gif');
imageFiles_ac_13['2'] = new Array ('/PrivateLabel/ChicagoClubCabaret/images/ac_Reservations.gif', '/PrivateLabel/ChicagoClubCabaret/images/ac_ReservationsMouseover.gif');
imageFiles_ac_13['3'] = new Array ('/PrivateLabel/ChicagoClubCabaret/images/ac_Cabaret_Menu.gif', '/PrivateLabel/ChicagoClubCabaret/images/ac_Cabaret_MenuMouseover.gif');
imageFiles_ac_13['4'] = new Array ('/PrivateLabel/ChicagoClubCabaret/images/ac_Testimonials.gif', '/PrivateLabel/ChicagoClubCabaret/images/ac_TestimonialsMouseover.gif');
imageFiles_ac_13['5'] = new Array ('/PrivateLabel/ChicagoClubCabaret/images/ac_Contact_Us.gif', '/PrivateLabel/ChicagoClubCabaret/images/ac_Contact_UsMouseover.gif');

function image_on_ac_13 (position) {
   var doc = eval("document.imageac_13" + position);
   doc.src = imageFiles_ac_13[position][1];
}

function image_off_ac_13 (position) {
   var doc = eval("document.imageac_13" + position);
   doc.src = imageFiles_ac_13[position][0];
}
