HS.sExp = 1800000;
HS.vExp = 180;
HS.getUniqueID = function(now) {
var rand = Math.floor(Math.random() * 1000).toString("36");
return escape(user) + now.toString("36") + rand;
};
HS.prepCookies = function() {
var vID = $.cookie("hst_vid"), sID = $.cookie("hst_sid");
var now = new Date().getTime();
if (!vID) { 
var id = HS.getUniqueID(now);
vID = "V" + id;
sID = "S" + id;
}
else if (!sID) {
sID = "S" + HS.getUniqueID(now);
}
else {
var sParams = sID.split("|");
if (sParams.length == 2 && now - sParams[1] < HS.sExp) {
sID = sParams[0];
}
else {
sID = "S" + HS.getUniqueID(now);
}
}
HS.vID = vID;
HS.sID = sID;
$.cookie("hst_vid", vID, { expires: HS.vExp });
$.cookie("hst_sid", sID + "|" + now);
};
HS.ce = function(err) {
if (HS.dErr == "true") {
var msg = "";
for (key in err) {
msg += key + ": " + err[key] + "\r\n";
}
alert(msg);
}
};
try{
HS.prepCookies();
$(document).ready(function () {
var max_url = 2083;
function trackHS(params) {
var src = HS.tURL;
src += "?rt=" + escape(user);
src += "&p=" + escape(pp);
src += "&u=" + escape(window.location.href);
src += "&sid=" + escape(HS.sID);
src += "&vid=" + escape(HS.vID);
src += "&x=" + new Date().getTime();
src += "&" + params;
if (src.length > max_url) {
src = src.substring(0, max_url - 6) + "&trc=y";
}
getTP().src = src;
}
function tv() {
try{
var referrer = "ref=" + escape(document.referrer);
trackHS(referrer, false);
}catch(e){HS.ce(e);}
}
function tc(params, elem) {
var parentDivs = $(elem).parents("div[id^=element]");
if (parentDivs.length > 0) {
params += "&e=" + escape(parentDivs[0].id);
}
trackHS(params);
wait(75);
}
function wait(time) {
var start = new Date().getTime();
var sleeping = true;
while (sleeping) {
var test = new Date();
sleeping = test.getTime() - start < time;
}
}
function getTP() {
HS.tp = HS.tp || document.createElement('img');
return HS.tp;
}
function getFormAttributes(form) {
var params = "";
if (form) {
params += "&act=" + escape(form.action);
if (form.H_HSGOTO) {
params += "&go=" + escape(form.H_HSGOTO.value);
}
if (form.CMD) {
params += "&cmd=" + escape(form.CMD.value);
}
}
return params;
}
tv();
$("a").click(function() {
try{
var params = "nn=a";
if (this.href) {
params += "&hrf=" + escape(this.href);
}
if (this.rel) {
params += "&rel=" + escape(this.rel);
}
if (this.onclick) {
params += "&clk=" + escape(this.onclick);
}
if ($(this).children("img").length > 0) {
params += "&img=" + escape($(this).children("img")[0].src);
}
else {
params += "&txt=" + escape($(this).text());
}
tc(params, this);
}catch(e){HS.ce(e);}
});
$("tr[onclick]").click(function() {
try{
var params = "nn=tr&clk=" + escape(this.onclick) +
"&id=" + escape($(this).children("td")[0].id);
tc(params, this);
}catch(e){HS.ce(e);}
});
$("td[onclick]").click(function() {
try{
var params = "nn=td&clk=" + escape(this.onclick) +
"&id=" + escape(this.id);
tc(params, this);
}catch(e){HS.ce(e);}
});
$("area[href]").click(function() {
try{
var params = "nn=area&hrf=" + escape(this.href);
tc(params, this);
}catch(e){HS.ce(e);}
});
$("input[type=image]").click(function() {
try{
var params = "nn=image&img=" + this.src;
params += getFormAttributes(this.form);
tc(params, this);
}catch(e){HS.ce(e);}
});
$("input[type=button]").click(function() {
try{
var params = "nn=button&txt=" + escape(this.value);
params += getFormAttributes(this.form);
tc(params, this);
}catch(e){HS.ce(e);}
});
$("input[type=submit]").click(function() {
try{
var params = "nn=submit&txt=" + escape(this.value);
params += getFormAttributes(this.form);
if (this.id) {
params += "&id=" + escape(this.id);
}
tc(params, this);
}catch(e){HS.ce(e);}
});
});
}catch(e){HS.ce(e);}