/* HideShow */
function expandCollapse() {
for (var i=0; i<expandCollapse.arguments.length; i++) {
var element = document.getElementById(expandCollapse.arguments[i]);
element.style.display = (element.style.display == "none") ? "block" : "none";
}
}
/* HideShow */

/* dropdown forms */
function leapto(form) {
var myindex=form.mode.selectedIndex
parent.location.href=(form.mode.options[myindex].value);
}
/* dropdown forms */

/* bookmarks */
function bookmarksite(title, url){
if (document.all)
window.external.AddFavorite(url, title);
else if (window.sidebar)
window.sidebar.addPanel(title, url, "")
}
/* bookmarks */

 