function tsinit(tsi){ts=eval("ts"+tsi);if(document.readyState&&document.readyState!="complete"){window.setTimeout("tsinit("+ts.ident+")",500);return }if(dom){var tdiv=document.getElementById?document.getElementById("tsdiv"+ts.ident):document.all["tsdiv"+ts.ident];ts.ah=tdiv.offsetHeight;ts.tdiv=tdiv;ts.tdiv.style.top=-1}setInterval("sctxt("+ts.ident+")",55)}function sctxt(tsi){ts=eval("ts"+tsi);if(ts.mv==false&&ts.ps=="1"){return }tdiv=ts.tdiv;if(dom){if(parseInt(tdiv.style.top)>(ts.ah)*(-1)){tdiv.style.top=parseInt(tdiv.style.top)-ts.csp+"px"}else{tdiv.style.top=parseInt(ts.height)}}}function stop(tsi){ts=eval("ts"+tsi);ts.mv=false}function start(tsi){ts=eval("ts"+tsi);ts.mv=true};