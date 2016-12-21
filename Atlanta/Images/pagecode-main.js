var serverDom=location.hostname;

if (serverDom!=="atlanta.usdmdev.net")
{
	var s=s_gi("usdmatlantaglobal");
} else 
{
	var s=s_gi("usdmatlantanetdev");
} 


var microSite='main';
//var s_code=s.t();if(s_code)document.write(s_code)