function fwLoadMenus() {
  if (window.fw_menu_0) return;
  window.fw_menu_0 = new Menu("root",119,16,"Verdana, Arial, Helvetica, sans-serif",11,"#ffffff","#2A7891","#2A7891","#ffffff");
  fw_menu_0.addMenuItem("Home","location='http://guccicrew.com/deliverer/index.html'");
  fw_menu_0.hideOnMouseOut=true;
  window.fw_menu_2 = new Menu("root",118,16,"Verdana, Arial, Helvetica, sans-serif",11,"#ffffff","#2A7891","#2A7891","#ffffff");
  fw_menu_2.addMenuItem("About Deliverer","location='http://guccicrew.com/deliverer/about.html'");
  fw_menu_2.addMenuItem("History","location='http://guccicrew.com/deliverer/history.html'");
  fw_menu_2.hideOnMouseOut=true;
  window.fw_menu_3 = new Menu("root",124,16,"Verdana, Arial, Helvetica, sans-serif",11,"#ffffff","#2A7891","#2A7891","#ffffff");
  fw_menu_3.addMenuItem("Cast","location='http://guccicrew.com/deliverer/cast.html'");
  fw_menu_3.addMenuItem("Creative","location='http://guccicrew.com/deliverer/creative.html'");
  fw_menu_3.hideOnMouseOut=true;
  window.fw_menu_4 = new Menu("root",128,16,"Verdana, Arial, Helvetica, sans-serif",11,"#ffffff","#2A7891","#2A7891","#ffffff");
  fw_menu_4.addMenuItem("News & Info","location='http://guccicrew.com/deliverer/news.html'");
  fw_menu_4.hideOnMouseOut=true;
  window.fw_menu_5 = new Menu("root",128,16,"Verdana, Arial, Helvetica, sans-serif",11,"#ffffff","#2A7891","#2A7891","#ffffff");
  fw_menu_5.addMenuItem("Purchase Tickets","location='http://guccicrew.com/deliverer/tickets.html'");
  fw_menu_5.hideOnMouseOut=true;

  fw_menu_5.writeMenus();
} // fwLoadMenus()

function getLeft() {
	if(navigator.appName == "Netscape") {
		if(window.innerWidth < 480) {
			return(1)
		} else {
			return((window.innerWidth - 480) * .5 - 9);
		}
	} else {
		if(document.body.clientWidth < 480) {
			return(1)
		} else {
			return((document.body.clientWidth - 480) * .5);
		}
	} 
}