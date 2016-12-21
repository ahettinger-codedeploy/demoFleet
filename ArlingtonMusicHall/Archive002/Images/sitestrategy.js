

function displayunicode(e)
{
var browser=navigator.appName;
var b_version=navigator.appVersion;
var version=parseFloat(b_version);
var evtobj=window.event? event : e //distinguish between IE's explicit event object (window.event) and Firefox's implicit.
var unicode=evtobj.charCode? evtobj.charCode : evtobj.keyCode

//alert(evtobj.altKey);
if(browser=='Microsoft Internet Explorer')
{
  if(unicode=='1')
    {
    href=location.href.replace(location.search,"");top.location.href=href+"?ctl=Login";
    }
  else if(unicode=='26')
    {
    top.location.href="/admin/security/logoff.aspx";
    }
}
else
{
  if(evtobj.ctrlKey && unicode=='65')
    {
    href=location.href.replace(location.search,"");top.location.href=href+"?ctl=Login";
    }
  else if(evtobj.ctrlKey && unicode=='90')
    {
    top.location.href="/admin/security/logoff.aspx";
    }
  }
}
document.onkeypress = displayunicode;
