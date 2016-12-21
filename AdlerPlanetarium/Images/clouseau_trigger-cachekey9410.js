
/* Merged Plone Javascript file
 * This file is dynamically assembled from separate parts.
 * Some of these parts have 3rd party licenses or copyright information attached
 * Such information is valid for that section,
 * not for the entire composite file
 * originating files are separated by - filename.js -
 */

/* - clouseau_trigger.js - */
// http://www.adlerplanetarium.org/portal_javascripts/clouseau_trigger.js?original=1
function showClouseau(context){var footer=document.getElementById("region-content").nextSibling;var wrapper=document.getElementById("region-content").parentNode;var div=document.createElement("div");var iframe=document.createElement("iframe");var existing=document.getElementById("clouseau_iframe");if(existing){wrapper.removeChild(existing)} else{div.id="clouseau_iframe";iframe.src="clouseau_minimal?context="+context;iframe.style.width="100%";iframe.style.height="800px";div.appendChild(iframe);wrapper.insertBefore(div,footer);wrapper.focus()}}

/* - adler.js - */
// http://www.adlerplanetarium.org/portal_javascripts/adler.js?original=1
<SCRIPT type="text/javascript" LANGUAGE="JavaScript">
function strongGlobalNavTabs(){pvar=document.getElementById('portaltab-plan');if(pvar){pvar.style.fontWeight="bold"}}
window.onload=strongGlobalNavTabs();</SCRIPT>
