jQuery(document).ready(function () {

    var megaList = jQuery("#dnn_pnav").find(".mega-menu-item");

    jQuery(megaList).each(function (index) {

        var mList = jQuery(this);
        var col = mList.attr("data-col");
        var markup = "<li><div class='mega-menu-content'><div class='row-fluid'>";
        var leftContent = "";
        var rightContent = "";
        var newCol = -1;
        var cnt = 1;
        var leftCol = -1;
        var rightCol = -1;

        if (mList.find(".lft-cont"))
            leftContent = mList.find(".lft-cont").html();

        if (mList.find(".rgt-cont"))
            rightContent = mList.find(".rgt-cont").html();

        if (col != 5) {
            newCol = 12 / col;
            leftCol = newCol;
            rightCol = newCol;
        }
        else {

            if (leftContent != "" && rightContent == "")
                leftCol = 4;
            else if (rightContent != "" && leftContent == "")
                rightCol = 4;
            else if (rightContent != "" && leftContent != "") {
                leftCol = 3;
                rightCol = 3;
            }

            newCol = 2;
        }

        for (var i = 1; i <= col; i++) {

            if (i == 1 && leftContent)
                markup += "<div class='span" + leftCol + "'>" + jQuery("<div />").html(leftContent).text() + "</div>";
            else if (i == col && rightContent)
                markup += "<div class='span" + rightCol + "'>" + jQuery("<div />").html(rightContent).text() + "</div>";
            else {

                if (leftContent)
                    markup += "<div class='span" + newCol + " col-" + parseInt(i - 1) + "'></div>";
                else
                    markup += "<div class='span" + newCol + " col-" + i + "'></div>";
            }
        }

        markup += "</div></div></li>";
        mList.find("> .mega-ul").prepend(markup);

        var menuList = mList.find("> .mega-ul > li:gt(0)");

        if (!(leftContent == null || typeof leftContetn == 'undefined'))
            col = col - 1;

        if (!(rightContent == null || typeof leftContetn == 'undefined'))
            col = col - 1;

        jQuery(menuList).each(function (index) {

            if (index % col == 0)
                cnt = 1;

            mList.find(".col-" + cnt).append(jQuery("<ul class='mega-ul-ul'></ul>").append(jQuery(this))).find("li.mega-li").removeClass().find("ul.mega-ul").removeClass().addClass("mega-ul-ul");

            cnt++;
        });

        mList.find(".mega-menu-content .row-fluid").children().children().find("> li > a, > li > span").addClass("mega-menu-sub-title");
    });
});