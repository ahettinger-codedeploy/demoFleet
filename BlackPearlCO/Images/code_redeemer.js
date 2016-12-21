document.write("<table style='border-collapse: collapse;'><tr><td><input id='instantencore_txt_redeem' type='text' style='width: 125px; height: 15px; border: solid 1px #AAAAAA; color: #AAAAAA; font-size: 12px; font-family: calibri, arial' value='enter download code' onfocus='instantencore_txt_redeem_focus();' onblur='instantencore_txt_redeem_blur()' /></td><td><div style='height: 19px;'><input type='image' id='instantencore_btn_redeem' alt='enter download code' src='http://www.instantencore.com/graphics/3.0/go.png' onclick='instantencore_btn_redeem_click();' /></div></td></tr></table>");

function instantencore_txt_redeem_focus() {
    var instantencore_txt_redeem = document.getElementById("instantencore_txt_redeem");
    if (instantencore_txt_redeem.value == "enter download code") {
        instantencore_txt_redeem.value = "";
        instantencore_txt_redeem.style.color = "#000000";
    }
}

function instantencore_txt_redeem_blur() {
    var instantencore_txt_redeem = document.getElementById("instantencore_txt_redeem");
    if (instantencore_txt_redeem.value.length == 0) {
        instantencore_txt_redeem.value = "enter download code";
        instantencore_txt_redeem.style.color = "#AAAAAA";
    }
}

function instantencore_btn_redeem_click() {
    var instantencore_txt_redeem = document.getElementById("instantencore_txt_redeem");
    if (instantencore_txt_redeem.value != "enter download code") {
        var url = "http://www.instantencore.com/Redeem.aspx?Code=" + instantencore_txt_redeem.value;
        window.open(url);
    }
}