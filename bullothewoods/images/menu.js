﻿jQuery(document).ready(function () { var megaList = jQuery("#mainMenu").find(".mega-menu-item"); jQuery(megaList).each(function (index) { var mList = jQuery(this); var col = mList.attr("data-col"); var markup = "<li><div class='mega-menu-content'><div class='row'>"; var leftContent = ""; var rightContent = ""; var newCol = -1; var cnt = 1; var leftCol = -1; var rightCol = -1; if (mList.find(".lft-cont")) leftContent = mList.find(".lft-cont").html(); if (mList.find(".rgt-cont")) rightContent = mList.find(".rgt-cont").html(); if (col != 5) { newCol = 12 / col; leftCol = newCol; rightCol = newCol } else { if ((leftContent != "" || leftContent != null) && (rightContent == "" || rightContent == null)) leftCol = 4; else if ((rightContent != "" || rightContent != null) && (leftContent == "" || leftContent == null)) rightCol = 4; else if ((rightContent != "" || rightContent != null) && (leftContent != "" || leftContent != null)) { leftCol = 3; rightCol = 3 } newCol = 2 } for (var i = 1; i <= col; i++) { if (i == 1 && leftContent) markup += "<div class='col-md-" + leftCol + "'>" + jQuery("<div />").html(leftContent).text() + "</div>"; else if (i == col && rightContent) markup += "<div class='col-md-" + rightCol + "'>" + jQuery("<div />").html(rightContent).text() + "</div>"; else { if (leftContent) markup += "<div class='col-md-" + newCol + " col-" + parseInt(i - 1) + "'></div>"; else markup += "<div class='col-md-" + newCol + " col-" + i + "'></div>" } } markup += "</div></div></li>"; mList.find("> .dropdown-menu").prepend(markup); var menuList = mList.find("> .dropdown-menu > li:gt(0)"); if (!(leftContent == null || typeof leftContent == 'undefined')) col = col - 1; if (!(rightContent == null || typeof rightContent == 'undefined')) col = col - 1; jQuery(menuList).each(function (index) { if (index % col == 0) cnt = 1; mList.find(".col-" + cnt).append(jQuery("<ul class='sub-menu'></ul>").append(jQuery(this))).find("li.dropdown-submenu").removeClass().find("ul.dropdown-menu").removeClass().addClass("sub-menu"); cnt++ }); mList.find(".mega-menu-content .row").children().children().find("> li > a, > li > span").addClass("mega-menu-sub-title") }) });