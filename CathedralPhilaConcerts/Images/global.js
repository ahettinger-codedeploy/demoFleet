$("a").filter(function () {
    return this.hostname && this.hostname !== location.hostname;
}).each(function () {
    $(this).attr({
        target: "_blank",
        title: "Visit " + this.href + " (click to open in a new window)"
    });
});
 var menus = $('ul.A-Menu > li');
 $(function() {
    $('#nav > div > ul > li > a')
       .each(function() {
           this.href = this.href.replace('#', '');
       });
   });
 function wrap(el) {
    $(el).wrap('<div class="wrap">' + '<div class="bd">' + '<div class="c">' + '<div class="s">' + '</div>' + '</div>' + '</div>' + '</div>');
    $(el).parent().parent().parent().parent().prepend('<div class="hd">' + '<div class="c"></div>' + '</div>').append('<div class="ft">' + '<div class="c"></div>' + '</div>');
}
function Tabs(etab, epnl) {
    var tabs = $(etab).find("> li");
    var panels = $(epnl).find("> div");
    $(tabs.get(0)).addClass("sel");
    $(panels.get(0)).addClass("sel");

    $(tabs).click(function() {
        var index = $(tabs).index(this);
        $(tabs).removeClass("sel");
        $(panels).removeClass("sel");
        $(tabs.get(index)).addClass("sel");
        $(panels.get(index)).addClass("sel");
    }, function() { });
}

function isValidEmailAddress(emailAddress) {
    var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
    return pattern.test(emailAddress);
}
