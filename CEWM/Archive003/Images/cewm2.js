// Title: Horizontal Menu (Relative)
// Description: 
// Web Folder: 
// Web URL: http://127.0.0.1/
// Absolute Path: False

ace_state.columns = 1;
ace_state.position = 'bottom';
ace_state.closedelay = 500;
ace_state.nowrap = 'nowrap';
ace_state.hbgcolor = '#8080FF';
ace_state.hftcolor = '#000000';
ace_state.nbgcolor = '#0000A0';
ace_state.nftcolor = '#FFFFFF';
ace_state.fontFamily = 'Arial';
ace_state.fontSize = '10pt';
ace_state.fontStyle = 'normal';
ace_state.fontWeight = 'normal';
ace_state.cellpadding = 1;
ace_state.layerpadding = 3;

acemenu = new ACEMenu('0');
acemenu.columns = 10;
acemenu.width = '50';
acemenu.hspacing = 75;
acemenu.nowrap = 'nowrap';
acemenu.hbgcolor = '#FCBA63';
acemenu.hftcolor = '#000000';
acemenu.nbgcolor = '#D9DAE2';
acemenu.nftcolor = '#000000';
acemenu.fontFamily = 'Arial';
acemenu.fontSize = '9pt';
acemenu.fontStyle = 'normal';
acemenu.fontWeight = 'bold';
acemenu.textalign = 'left';
acemenu.menuborder = '0px  solid';
acemenu.layerpadding = 5;

acemenu.AddItem('Home', 'http://www.cewm.org/index.html', '_self', false , '', '0', '0');
acemenu.AddItem('Advertise', 'http://www.cewm.org/index.html', '_self', false , '', '0', '0');
acemenu.AddItem('Support Us', 'http://www.cewm.org/index.html', '_self', false , '', '0', '0');
acemenu.AddItem('Tickets', 'http://www.cewm.org/index.html', '_self', false , '', '0', '0');
acemenu.AddItem('Artists', 'http://www.cewm.org/index.html', '_self', false , '', '0', '0');
acemenu.AddItem('CD Sales', 'http://www.cewm.org/musiccd.html', '_self', false , '', '0', '0');
acemenu.AddItem('About Us', 'http://www.cewm.org/index.html', '_self', false , '', '0', '0');
acemenu.AddItem('Commissioning Project', 'http://www.cewm.org/commissioning_project.html', '', false , '', '0', '0');
acemenu.AddItem('Press', 'http://www.cewm.org/index.html', '_self', false ,'', '0', '0');
acemenu.AddItem('Essays', 'http://www.cewm.org/index.html', '_self', false , '', '0', '0');

acemenu = new ACEMenu('2');
acemenu.columns = 1;
acemenu.nowrap = 'nowrap';
acemenu.hbgcolor = '#BFBFBF';
acemenu.hftcolor = '#A73585';
acemenu.nbgcolor = '#FCBA63';
acemenu.nftcolor = '#000000';
acemenu.fontFamily = 'Arial';
acemenu.fontSize = '9pt';
acemenu.fontStyle = 'normal';
acemenu.fontWeight = 'bold';
acemenu.textalign = 'left';

acemenu.AddItem('Playbill Information', 'http://www.cewm.org/ad_letter.htm', '_self', false , '', '0', '0');
acemenu.AddItem('Sign Up', 'http://www.cewm.org/index.html', '_self', false , '', '0', '0');
acemenu.AddItem('Playbill ONLINE', 'http://www.cewm.org/cewm_links.html', '_self', false , '', '0', '0');

acemenu = new ACEMenu('2i2');
acemenu.columns = 1;
acemenu.position = 'right';
acemenu.width = '15';
acemenu.hspacing = 5;
acemenu.nowrap = 'nowrap';
acemenu.hbgcolor = '#BFBFBF';
acemenu.hftcolor = '#FFFFFF';
acemenu.nbgcolor = '#A69286';
acemenu.nftcolor = '#FFFFFF';
acemenu.fontFamily = 'Arial';
acemenu.fontSize = '9pt';
acemenu.fontStyle = 'normal';
acemenu.fontWeight = 'bold';
acemenu.textalign = 'left';

acemenu.AddItem('Electronically', 'http://www.cewm.org/online_playbill_ad_rates.asp', '_blank', false , '', '0', '0');
acemenu.AddItem('Print PDF', 'http://www.cewm.org/adletter_spring-form_combined-2012.pdf', '_blank', false , '', '0', '0');

acemenu = new ACEMenu('3');
acemenu.columns = 1;
acemenu.nowrap = 'nowrap';
acemenu.hbgcolor = '#BFBFBF';
acemenu.hftcolor = '#A73585';
acemenu.nbgcolor = '#FCBA63';
acemenu.nftcolor = '#0F0F0F';
acemenu.fontFamily = 'Arial';
acemenu.fontSize = '9pt';
acemenu.fontStyle = 'normal';
acemenu.fontWeight = 'bold';
acemenu.textalign = 'left';

acemenu.AddItem('Contributors', 'http://www.cewm.org/underwriters_form.asp', '', false , '', '0', '0');
acemenu.AddItem('Patrons Events', 'http://www.cewm.org/patron_events.html', '', false , '', '0', '0');

acemenu = new ACEMenu('4');
acemenu.columns = 1;
acemenu.nowrap = 'nowrap';
acemenu.hbgcolor = '#BFBFBF';
acemenu.hftcolor = '#A73585';
acemenu.nbgcolor = '#FCBA63';
acemenu.nftcolor = '#000000';
acemenu.fontFamily = 'Arial';
acemenu.fontSize = '9pt';
acemenu.fontStyle = 'normal';
acemenu.fontWeight = 'bold';
acemenu.textalign = 'left';

acemenu.AddItem('Season Series Great Barrington', 'http://www.cewm.org/tickets.html', '_self', false , '', '0', '0');
acemenu.AddItem('The Berkshires', 'http://www.cewm.org/index.html', '_self', false , '', '0', '0');
acemenu.AddItem('Scottsdale', '', 'http://www.cewm.org/index.html', '_self', false ,'', '0', '0');
acemenu.AddItem('Patron Events', 'http://www.cewm.org/patron_events.html', '', false , '', '0', '0');
acemenu.AddItem('Print & Mail In Form', 'mail_in_form2012-2013.PDF', '_blank', false , '', '0', '0');

acemenu = new ACEMenu('4i2');
acemenu.columns = 1;
acemenu.position = 'right';
acemenu.width = '15';
acemenu.hspacing = 5;
acemenu.nowrap = '';
acemenu.hbgcolor = '#BFBFBF';
acemenu.hftcolor = '#FFFFFF';
acemenu.nbgcolor = '#A69286';
acemenu.nftcolor = '#FFFFFF';
acemenu.fontFamily = 'Arial';
acemenu.fontSize = '9pt';
acemenu.fontStyle = 'normal';
acemenu.fontWeight = 'bold';
acemenu.textalign = 'left';

acemenu.AddItem('Concerts', 'http://www.cewm.org/greatbarrington.html', '_self', false , '', '0', '0');
acemenu.AddItem('Conversations With...', 'http://www.cewm.org/conversations.html', '_self', false , '', '0', '0');

acemenu = new ACEMenu('4i3');
acemenu.position = 'right';
acemenu.nowrap = '';
acemenu.hbgcolor = '#BFBFBF';
acemenu.hftcolor = '#FFFFFF';
acemenu.nbgcolor = '#A69286';
acemenu.nftcolor = '#FFFFFF';
acemenu.fontFamily = 'Arial';
acemenu.fontSize = '9pt';
acemenu.fontStyle = 'normal';
acemenu.fontWeight = 'bold';
acemenu.textalign = 'left';

acemenu.AddItem('December 12, 2012', 'http://www.scottsdaleperformingarts.org/event.php?id=849', '_blank', false , '', '0', '0');
acemenu.AddItem('February 6, 2013', 'http://www.scottsdaleperformingarts.org/event.php?id=841', '_blank', false , '', '0', '0');

acemenu = new ACEMenu('5');
acemenu.columns = 1;
acemenu.nowrap = 'nowrap';
acemenu.hbgcolor = '#BFBFBF';
acemenu.hftcolor = '#A73585';
acemenu.nbgcolor = '#FCBA63';
acemenu.nftcolor = '#000000';
acemenu.fontFamily = 'Arial';
acemenu.fontSize = '9pt';
acemenu.fontStyle = 'normal';
acemenu.fontWeight = 'bold';
acemenu.textalign = 'left';

acemenu.AddItem('Artistic Director', 'http://www.cewm.org/bio_hanani.html', '', false , '', '0', '0');
acemenu.AddItem('Artist Bios', 'http://www.cewm.org/aboutartist.html', '', false , '', '0', '0');

acemenu = new ACEMenu('7');
acemenu.columns = 1;
acemenu.nowrap = 'nowrap';
acemenu.hbgcolor = '#BFBFBF';
acemenu.hftcolor = '#A73585';
acemenu.nbgcolor = '#FCBA63';
acemenu.nftcolor = '#000000';
acemenu.fontFamily = 'Arial';
acemenu.fontSize = '9pt';
acemenu.fontStyle = 'normal';
acemenu.fontWeight = 'bold';
acemenu.textalign = 'left';

acemenu.AddItem('Staff Members', 'http://www.cewm.org/staff_members.html', '', false , '', '0', '0');
acemenu.AddItem('Board Members', 'http://www.cewm.org/board_of_dir.html', '', false , '', '0', '0');
acemenu.AddItem('Education', 'http://www.cewm.org/index.html', '_self', false ,'', '0', '0');
acemenu.AddItem('Patrons Events', 'http://www.cewm.org/patron_events.html', '', false , '', '0', '0');
acemenu.AddItem('Contact Us', 'http://www.cewm.org/e_form.asp', '', false , '', '0', '0');

acemenu = new ACEMenu('7i3');
acemenu.columns = 1;
acemenu.position = 'right';
acemenu.width = '25';
acemenu.hspacing = 5;
acemenu.nowrap = 'nowrap';
acemenu.hbgcolor = '#BFBFBF';
acemenu.hftcolor = '#FFFFFF';
acemenu.nbgcolor = '#A69286';
acemenu.nftcolor = '#FFFFFF';
acemenu.fontFamily = 'Arial';
acemenu.fontSize = '9pt';
acemenu.fontStyle = 'normal';
acemenu.fontWeight = 'bold';

acemenu.AddItem('Nova Musical Trust', 'http://novamusicaltrust.blip.tv/', '_blank', false , '', '0', '0');
acemenu.AddItem('Master Class Videos', 'http://www.cewm.org/video.html', '', false , '', '0', '0');

acemenu = new ACEMenu('9');
acemenu.columns = 1;
acemenu.nowrap = 'nowrap';
acemenu.hbgcolor = '#BFBFBF';
acemenu.hftcolor = '#A73585';
acemenu.nbgcolor = '#FCBA63';
acemenu.nftcolor = '#000000';
acemenu.fontFamily = 'Arial';
acemenu.fontSize = '9pt';
acemenu.fontStyle = 'normal';
acemenu.fontWeight = 'bold';
acemenu.textalign = 'left';

acemenu.AddItem('Artist Bios', 'http://www.cewm.org/aboutartist.html', '', false , '', '0', '0');
acemenu.AddItem('High Res Photos', 'http://www.cewm.org/index.html', '_self', false , '', '0', '0');
acemenu.AddItem('Press Releases', 'http://www.cewm.org/index.html', '_self', false , '', '0', '0');
acemenu.AddItem('Reviews', 'http://www.cewm.org/index.html', '_self', false , '', '0', '0');

acemenu = new ACEMenu('9i2');
acemenu.columns = 1;
acemenu.position = 'right';
acemenu.width = '15';
acemenu.hspacing = 5;
acemenu.nowrap = 'nowrap';
acemenu.hbgcolor = '#BFBFBF';
acemenu.hftcolor = '#FFFFFF';
acemenu.nbgcolor = '#A69286';
acemenu.nftcolor = '#FFFFFF';
acemenu.fontFamily = 'Arial';
acemenu.fontSize = '9pt';
acemenu.fontStyle = 'normal';
acemenu.fontWeight = 'bold';

acemenu.AddItem('Ashkenasi', 'http://www.cewm.org/press_photo/Ashkenasi.jpg', '_blank', false , '', '0', '0');
acemenu.AddItem('Avalon Quartet', 'http://www.cewm.org/press_photo/AvalonQuartet.jpg', '_blank', false , '', '0', '0');
acemenu.AddItem('Berick', 'http://www.cewm.org/press_photo/Berick.tif', '_blank', false , '', '0', '0');
acemenu.AddItem('Fisk', 'http://www.cewm.org/press_photo/ElliotFisk.tif', '_blank', false , '', '0', '0');
acemenu.AddItem('Hamada', 'http://www.cewm.org/press_photo/Hamada.jpg', '_blank', false , '', '0', '0');
acemenu.AddItem('Hanani', 'http://www.cewm.org/press_photo/Yeh537.tif', '_blank', false , '', '0', '0');
acemenu.AddItem('Keren', 'http://www.cewm.org/press_photo/Keren.jpg', '_blank', false , '', '0', '0');
acemenu.AddItem('Milenkovich', 'http://www.cewm.org/press_photo/Milenkovich.jpg', '_blank', false , '', '0', '0');
acemenu.AddItem('Neiman', 'http://www.cewm.org/press_photo/Neiman.jpg', '_blank', false , '', '0', '0');
acemenu.AddItem('Ponce', 'http://www.cewm.org/press_photo/WalterPonce300dpi.tif', '_blank', false , '', '0', '0');
acemenu.AddItem('Rogovoy', 'http://www.cewm.org/press_photo/SethRogovoy.jpg', '_blank', false , '', '0', '0');
acemenu.AddItem('Rose Ensemble', 'http://www.cewm.org/press_photo/RoseEnsemblevertical.jpg', '_blank', false , '', '0', '0');

acemenu = new ACEMenu('9i3');
acemenu.columns = 1;
acemenu.position = 'right';
acemenu.width = '15';
acemenu.hspacing = 5;
acemenu.nowrap = 'nowrap';
acemenu.hbgcolor = '#BFBFBF';
acemenu.hftcolor = '#FFFFFF';
acemenu.nbgcolor = '#A69286';
acemenu.nftcolor = '#FFFFFF';
acemenu.fontFamily = 'Arial';
acemenu.fontSize = '9pt';
acemenu.fontStyle = 'normal';
acemenu.fontWeight = 'bold';

acemenu.AddItem('Current Season', 'http://www.cewm.org/press.htm', '', false , '', '0', '0');
acemenu.AddItem('Archives 2011-2012', 'http://www.cewm.org/press_archive_11-12.htm', '', false , '', '0', '0');
acemenu.AddItem('Archives 2010-2011', 'http://www.cewm.org/press_archive_10_11.htm', '', false , '', '0', '0');
acemenu.AddItem('Archives 2009-2010', 'http://www.cewm.org/press_archive_09_10.htm', '', false , '', '0', '0');
acemenu.AddItem('Archives 2008-2009', 'http://www.cewm.org/press_archive_08_09.htm', '', false , '', '0', '0');

acemenu = new ACEMenu('9i4');
acemenu.columns = 1;
acemenu.position = 'right';
acemenu.width = '15';
acemenu.hspacing = 5;
acemenu.nowrap = 'nowrap';
acemenu.hbgcolor = '#BFBFBF';
acemenu.hftcolor = '#FFFFFF';
acemenu.nbgcolor = '#A69286';
acemenu.nftcolor = '#FFFFFF';
acemenu.fontFamily = 'Arial';
acemenu.fontSize = '9pt';
acemenu.fontStyle = 'normal';
acemenu.fontWeight = 'bold';

acemenu.AddItem('Current Season', 'http://www.cewm.org/reviews.html', '', false , '', '0', '0');
acemenu.AddItem('Archives 2011-2012', 'http://www.cewm.org/reviews2011-2012.html', '', false , '', '0', '0');

acemenu = new ACEMenu('10');
acemenu.columns = 1;
acemenu.width = '25';
acemenu.hspacing = 15;
acemenu.nowrap = 'nowrap';
acemenu.hbgcolor = '#BFBFBF';
acemenu.hftcolor = '#A73585';
acemenu.nbgcolor = '#FCBA63';
acemenu.nftcolor = '#000000';
acemenu.fontFamily = 'Arial';
acemenu.fontSize = '9pt';
acemenu.fontStyle = 'normal';
acemenu.fontWeight = 'bold';
acemenu.textalign = 'left';

acemenu.AddItem('Handel and the Cantata', 'handel_the_cantata.pdf', '_blank', false , '', '0', '0');
acemenu.AddItem('Of Toys and Instruments', 'http://www.cewm.org/playbill_essays_6.html', '', false , '', '0', '0');
acemenu.AddItem('Yehuda Hanani Crosses Paths with Music Giants', 'pdf_articles/Yehuda Hanani Crosses Paths with Musical Giants.PDF', '_blank', false , '', '0', '0');
acemenu.AddItem('A Conversation with Pipa Soloist Liu Fang', 'http://www.cewm.org/pipa_soloist.pdf', '_blank', false , '', '0', '0');
acemenu.AddItem('The 1920s: Berlin, Paris, New York', 'http://www.cewm.org/twenties.pdf', '_blank', false , '', '0', '0');
acemenu.AddItem('The Original Soul Music', 'http://www.cewm.org/playbill_essays.html', '', false , '', '0', '0');
acemenu.AddItem('An Alternative View of Western Music', 'http://www.cewm.org/playbill_essays_2.html', '', false , '', '0', '0');
acemenu.AddItem('Sounding Off On Sound', 'http://www.cewm.org/playbill_essays_3.html', '', false , '', '0', '0');
acemenu.AddItem('A Tale of Two Prodigies', 'http://www.cewm.org/playbill_essays_4.html', '', false , '', '0', '0');
acemenu.AddItem('Stravinsky and The Soldiers Tale', 'http://www.cewm.org/playbill_essays_5.html', '', false , '', '0', '0');
acemenu.AddItem('Intoxicating Dreams: German Orientalism', 'http://www.cewm.org/article_levine.pdf', '_blank', false , '', '0', '0');


