if( document.domain.indexOf( "dell.com" ) != -1 )
{
document.domain = "dell.com" ;
}
var m_pnlinks;
var m_mhFixed = false;
var m_mda = null;
var m_production = true;
var m_menudef = "/content/public/menu.aspx";
var m_avgChW = 6;
var m_crumbRegEx1 = /<.*>/g;
var m_crumbRegEx2 = /&nbsp;/g;
var m_crumbRegEx3 = /&~ck=bt/g;
var m_subNavLinksDisplay = false;
var m_subNavIconsDisplay = false;
var m_largeFont = false;
var m_supressSubNav = false;
var m_stdEmpty = "";
var m_stdOffImg;
var m_mastheadWidth = 728;
var m_tabNav = true;
var m_subNavLinkWidth = null;
var m_phoneTitle = null;
var m_phoneMsg = null;
var m_phoneTariff = null;
var m_tabContentDiv = null;
var m_timeoutDelay = null;
var loaded = new Array();
var onloadFired = false;
var m_isRtl = false;
var m_isCenter = false;
var m_isPopupIntention = false;
function writeMH( phoneTitle, phoneMsg, phoneTariff, segmentTitle, hasLocale, logoLink, pnmsg )
{
m_phoneTitle = phoneTitle;
m_phoneMsg = phoneMsg;
m_phoneTariff = phoneTariff;
document.writeln ( "<!-- begin masthead -->" );
m_mastheadWidth = 728;

var Tablewidth = ( m_mastheadWidth ? m_mastheadWidth+"px" : "100%" );
if(m_isCenter)
{
document.writeln ( "<!-- start center align -->" );
//document.writeln ( "<table style=\"margin-left:auto;margin-right:auto\"><tr><td>" );
document.writeln ( "<table style=\"margin-left:auto;margin-right:auto; width:" + Tablewidth + ";\"><tr><td>" );
}
else
{
    document.writeln ( "<table style=\"width:" + Tablewidth + ";\"><tr><td>" );
}
m_stdOffImg = "<img src=\"" + m_imgPfx + "/images/global/brand/icons/smextlink.gif\", width=\"16\" height=\"9\" border=\"0\"/>";
autoconfig();
if ( typeof(m_menuBar) == "undefined" )
{
if( !m_production )
{
document.write( "<div class=\"para\" style=\"color:red; font-weight:bold\">There is a problem with the menu definition. " );
document.write( "<a href=\"" + m_menudef + "\">Click here to view</a></div>" );
return;
}
return;
}
if( m_largeFont )
{
m_avgChW = m_avgChW + 2;
}
m_mhFixed = true;
document.writeln( "<a name=\"mastheadtop\"></a>" );
document.write( "<table id=\"masthead\" width=\"" + m_mastheadWidth + "\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">" );
document.write( "<tr><td valign=\"bottom\" rowspan=\"2\">" );
document.write( "<div class=\"logocontainer\" id=\"logocontainer\">" );
document.write( "<a href=\"#skipMH\"><img src=\"" + m_imgPfx + "/images/global/general/spacer.gif\" alt=\"Skip to main content\" border=\"0\" width=\"1\" height=\"1\" /></a>" );
if( typeof( m_nothomelogo ) != "undefined" )
{
m_nothomelogo = m_nothomelogo.replace ( "/images/global/brand/ui/logo.gif" , "/images/global/brand/ui/logo43.gif");
if( logoLink )
{
document.write( "<a class=\"logolink\" href=\"" + m_homelink + "\">" );
}
document.write( "<img class=\"logo\" src=\"" + m_nothomelogo + "\" border=\"0\" width=\"109\" height=\"41\" alt=\"Dell\" />" );
if( logoLink )
{
document.write( "</a>" );
}
}
document.write( "</div></td><td valign=\"top\" " + ((typeof(m_menuBar) != "undefined" && m_menuBar && m_menuBar.length > 0) ? "colspan=\"2\"" : "") + "><table id=\"pbarstriptable\" width=\"" + (m_mastheadWidth - 109) + "\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr><td>" );
renderBuyOnline();
document.write( "</td><td><div style=\"height:20px;\" /></td><td nowrap=\"true\" valign=\"top\">" );
var ticks = new Date();
if( !( m_pnlinks && m_subNavLinksDisplay && ( !m_supressSubNav ) ) && ( typeof( m_langSelectorUrl ) != "undefined") )
{
document.write( "<div class=\"lang_selector\">" );
renderLanguageToggle();
document.write( "</div>" );
}
document.write( "</td></tr></table></td></tr><tr>" );
document.write( "<td>" );
if ( typeof( m_supressSearch ) == "undefined" || m_supressSearch == false )
{
document.write( "<div class=\"searchcontainer\" id=\"searchcontainer\">")
if( m_search )
{
document.write( m_search );
}
else
{
renderSearchLinks();
}

var searchCombo = document.getElementById("cat");
SetSeachComboTitle(searchCombo);

document.write( "</div>" );
}
document.write( "</td></tr><tr><td colspan=\"3\">" );
document.write( "<div class=\"subnavcontainernomenu\" id=\"subnav\" ><img src=\"" + m_imgPfx + "/images/global/general/spacer.gif\" border=\"0\" alt=\"\" height=\"5\" width=\"1\" /></div>" );
if( m_pnlinks && m_subNavLinksDisplay && (!m_supressSubNav) )
{
document.write( "<div class=\"secondarynavcontainer\">" );
renderSubNavLinks();
document.write( "</div>" );
}
if( m_mda )
{
document.write( "<div class=\"mdabarcontainer\" id=\"mdabar\">" );
document.write( "<span class=\"mdainfo\">" );
document.write( m_mda );
document.write( "</span>" );
document.write( "</div>" );
}
document.write( "<div class=\"breadcrumbcontainer\">" );
renderHomepageCrumbs();
document.write( "</div>" );
document.write ( "</td></tr></table>" );
document.write ( "<a name=\"skipMH\"></a>" );
document.writeln ( "<!-- end masthead -->" );
}

// set the title of the search combo
function SetSeachComboTitle (SelectObj)
{
    if (SelectObj)
    {
        if (SelectObj.selectedIndex > -1)
        {
            if (SelectObj.options[SelectObj.selectedIndex].value != "")
            { 
                 var searchCombo = document.getElementById("cat");
                 if (searchCombo)
                 {
                    searchCombo.title = SelectObj.options[SelectObj.selectedIndex].text;
                 }
            }
        }
    }
}
function renderBuyOnline()
{
if( m_phoneTitle || m_phoneMsg )
{
document.write( "<div class=\"message_buyonline\">" );
if(m_isRtl)
{
buyOnlineStyle="right";
buyOnlineAlign="left";
}
else
{
buyOnlineStyle="left";
buyOnlineAlign="right";
}
if( m_phoneTitle )
{
document.write("<div style=\"float:" + buyOnlineStyle + ";padding-" + buyOnlineAlign + ":3px\">")
document.write( m_phoneTitle );
document.write("</div>")
}
if( m_phoneMsg )
{
document.write("<div style=\"float:" + buyOnlineStyle + ";padding-" + buyOnlineAlign + ":3px\">")
document.write( m_phoneMsg );
document.write("</div>")
}
if( m_phoneTariff )
{
document.write("<div style=\"float:" + buyOnlineStyle + "\">")
document.write( "<span class=\"mhTextNewTrf\">" + m_phoneTariff + "</span>" );
document.write("</div>")
}
document.write( "</div>" );
}
}
var isCSS = false;
var isW3C = false;
var isIE4 = false;
var isNN4 = false;
var isIE6 = false;
var isGecko = false;
var isOpera = false;
var isDHTML = false;
var suppressMenus = false;
var legacyMode = false;
var timerID = null;
var subtimerID = null;
var m_anchorClicked = false;
function addBookMark()
{
if ( window.external )
{
window.external.AddFavorite( document.location.href,document.title );
}
else
{
alert( "Sorry, your browser doesn't support bookmarking this page...\n\nPlease try pressing Control + D instead" );
}
}
function autoconfig()
{
if( document && document.images )
{
isCSS = (document.body && document.body.style) ? true : false;
isW3C = (isCSS && document.getElementById) ? true : false;
isIE4 = (isCSS && document.all && readIEVer() >= 4.0) ? true : false;
isNN4 = (document.layers) ? true : false;
isGecko = (isCSS && navigator && navigator.product && navigator.product == "Gecko");
isOpera = (isCSS && navigator.userAgent.indexOf( "Opera") != -1 );
isIE6CSS = (document.compatMode && document.compatMode.indexOf("CSS1") >= 0) ? true : false;
isIE6 = ( isIE6CSS && readIEVer() >= 6.0 );
isDHTML = isCSS && ( isIE4 || isGecko || isOpera );
if( suppressMenus )
{
isDHTML = false;
}
else if( isOpera && readOperaVer() < 7 )
{
isDHTML = false;
}
else if( isGecko && navigator.productSub <= 20011022 )
{
isDHTML = false;
}
else if( isGecko && navigator.productSub == 20030107 )
{
var x = navigator.userAgent.indexOf( "AppleWebKit" );
if( x > -1 )
{
isDHTML = ( navigator.userAgent.substring( x + 12, x + 15 ) ) > 300;
}
else
{
isDHTML = false;
}
}
}
}
function readIEVer()
{
var agent = navigator.userAgent;
var offset = agent.indexOf( "MSIE" );
if( offset < 0 )
{
return 0;
}
return parseFloat( agent.substring( offset + 5, agent.indexOf( ";", offset ) ) );
}
function readOperaVer()
{
var agent = navigator.userAgent;
var offset = agent.indexOf( "Opera" );
if( offset < 0 )
{
return 0;
}
return parseFloat( agent.substring( offset + 6 ) );
}
function renderSearchLinks()
{
if( m_searchLinks )
{
for( var n = 0; n < m_searchLinks.length; n++ )
{
if( n > 0 )
{
document.write( "<span class=\"mhSpace\">|</span>" );
}
var href = m_searchLinks[n].Href;
var text = m_searchLinks[n].Text;
document.write( "<span class=\"mh_search_sep_SE\" style=\"white-space:nowrap\"><a href=\"" + href + "\" class=\"para_small\">" + text + "</a></span>" );
}
}
}
function renderSubNavLinks()
{
var pwidth = (m_subNavLinkWidth != null) ? ("style=\"width:" + m_subNavLinkWidth + "px;\"") : "";
if(m_isRtl)
subnavLinksAlign="left";
else
subnavLinksAlign="right";
document.write( "<div " + pwidth + "><table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" height=\"22\" align=\"" + subnavLinksAlign + "\"><tr>" );
for( var n = 0; n < m_pnlinks.length; n++ )
{
if( n > 0 )
{
document.write( "<td ><img src=\"" + m_imgPfx + "/images/global/masthead/secondary_sep.gif\" alt=\"\"></td>" );
}
var href = m_pnlinks[n].Href;
var icon = m_pnlinks[n].Icon;
if( icon && m_subNavIconsDisplay )
{
document.write( "<td valign=\"middle\"><a href=\"" + href + "\"><img src=\"" + m_imgPfx + "/images/global/brand/icons/" + icon + ".gif\" border=\"0\" alt=\"\"></a></td>" );
}
document.write( "<td align=\"right\" valign=\"middle\" nowrap=\"true\"><a class=\"lnk_crumb\" href=\"" + href + "\">" + m_pnlinks[n].Text + "</a></td>" );
}
document.write( "<td>&nbsp;</td>" );
document.write( "</tr></table></div>" );
}
function renderLanguageToggle()
{
document.write( "<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" height=\"10\" align=\"right\"><tr>" );
document.write( "<td align=\"left\" valign=\"middle\"><a href=\"" + m_langSelectorUrl + "\"><img src=\"" + m_imgPfx + "/images/global/brand/icons/" + m_langSelectorIcon + ".gif\" border=\"0\" alt=\"\"></a></td>" );
document.write( "<td align=\"left\" valign=\"middle\" nowrap=\"true\"><a class=\"lnk_crumb\" href=\"" + m_langSelectorUrl + "\">" + m_langSelectorCaption + "</a></td>" );
document.write( "</tr></table>" );
}
function menuItem( text, href, target )
{
this.Text = text;
this.Href = mhFixupLink( href, "&~ck=mn" );
this.IsSeparator = false;
this.IsCaption = false;
this.MenuItems = null;
this.OffDell = false;
this.TargetHtml = m_stdEmpty;
if( ( typeof(target) != "undefined" ) && target )
{
this.OffDell = ( target == "offdell" );
this.TargetHtml = " target=\"" + target + "\"";
}
}
function mhLink( text, href, icon, extra, isFilter )
{
href = mhFixupLink( href, extra );
this.Text = text;
this.Href = href;
this.Icon = icon;
this.IsFilter = isFilter;
}
function addPnLink( text, href, icon )
{
if( !m_pnlinks )
{
m_pnlinks = new Array();
}
m_pnlinks[m_pnlinks.length] = new mhLink( text, href, icon, "&~ck=pn" );
}
function mhFixupLink( href, extra )
{
if( typeof(extra) == "undefined" )
{
extra = "&~ck=mn";
}
if( href )
{
var anchor = null;
var anchorix = href.indexOf( "#" );
if( anchorix != -1 )
{
anchor = href.substr( anchorix );
href = href.substr( 0, anchorix );
}
if( href.indexOf( "?" ) == -1 )
{
extra = "?" + extra.substr( 1 );
}
if( href.toLowerCase().indexOf( "javascript:" ) == -1 )
{
href += extra;
}
else
{
start = href.indexOf( "?" );
if( start != -1 )
{
ix = href.indexOf( "\'", start );
if( ix == -1 )
{
ix = href.indexOf( "\\", start );
if( ix == -1 )
{
ix = href.indexOf( "\"", start );
}
}
if( ix != -1 )
{
href = href.substr( 0, ix ) + extra + href.substr( ix );
}
}
}
if( anchor )
{
href += anchor;
}
}
return href;
}
function winopen(url,stuff,morestuff)
{
var popwin = window.open(url,stuff,morestuff);
if( typeof(popwin) != "undefined" && popwin )
{
popwin.focus();
}
lastPopup = popwin;
}
function writeFooterLine()
{
document.writeln( "<tr><td nowrap=\"1\" class=\"mhLine\" height=\"1\" width=\"1\"></td></tr>" );
}
function writeFooterStart()
{
var width = ( m_mhFixed ? m_mastheadWidth : "100%" );
document.write( "<table width=\"" + m_mastheadWidth + "\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" bgcolor=\"#ededed\">" );
document.write( "<tr><td bgcolor=\"white\"><img src=\"" + m_imgPfx + "/images/global/general/spacer.gif\" border=\"0\" height=\"8\" width=\"1\" alt=\"\" /></td></tr>" );
document.write( "</table>" );
}
function writeFooterMid()
{
var width = ( m_mhFixed ? m_mastheadWidth : "100%" );
document.write( "<table width=\"" + m_mastheadWidth + "\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" bgcolor=\"#ededed\">" );
if( typeof(m_localeSelector) != "undefined" )
{
document.writeln( "<tr><td colspan=\"2\" style=\"background-color:#ffffff;border-top: 1px solid #efefef\"><div class=\"locale_selector\">" + m_localeSelector + "</div></td></tr>" );
}
document.write( "<tr><td colspan=\"2\"><img src=\"" + m_imgPfx + "/images/global/general/spacer.gif\" border=\"0\" height=\"1\" width=\"1\" alt=\"\" /></td></tr></table>" );
}
function writeFooterBegin()
{
writeFooterStart();
writeFooterMid();
}
function writeFooterClose()
{
document.write( "</td><td><table><tr><td valign=\"middle\"><a href=\"#mastheadtop\"><img src=\"" + m_imgPfx + "/images/global/brand/ui/arrow_top.gif\" width=\"7\" height=\"4\" alt=\"\" border=\"0\"></a></td><td style=\"padding-right:6px;\" valign=\"middle\"><a href=\"#mastheadtop\"><span class=\"para\">" + m_gototop + "</span></a></td></tr></table></td></tr><TR><td colspan=\"2\" ><img src=\"" + m_imgPfx + "/images/global/general/spacer.gif\" alt=\"\" border=\"0\" height=\"5\" width=\"1\" /></td></tr><TR><td colspan=\"2\" bgcolor=\"#cdcdcd\"><img src=\"" + m_imgPfx + "/images/global/general/spacer.gif\" alt=\"\" border=\"0\" height=\"1\" width=\"1\" /></td></tr></table>" );
}
function writeFooterEnd()
{
var width = ( m_mhFixed ? m_mastheadWidth : "100%" );
document.write( "<table width=\"" + width + "\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" bgcolor=\"#ededed\">" );
document.write( "<tr><td colspan=\"2\" class=\"bcbg\"><img src=\"" + m_imgPfx + "/images/global/general/spacer.gif\" border=\"0\" height=\"1\" width=\"1\" alt=\"\" /></td></tr>" );
document.write( "<tr><td colspan=\"2\" ><img src=\"" + m_imgPfx + "/images/global/general/spacer.gif\" border=\"0\" height=\"5\" width=\"1\" alt=\"\" /></td></tr><tr><td width=\"" + width + "\" align=\"center\" valign=\"top\">" );
document.write( m_birdseed );
document.write( "</td><td><table><tr><td valign=\"middle\"><img src=\"" + m_imgPfx + "/images/global/brand/ui/arrow_top.gif\" width=\"7\" height=\"4\" alt=\"\" border=\"0\"></td><td style=\"padding-right:6px;\" valign=\"middle\"><a href=\"#mastheadtop\"><span class=\"para\">" + m_gototop + "</span></a></td></tr></table></td></tr><TR><td colspan=\"2\" ><img src=\"" + m_imgPfx + "/images/global/general/spacer.gif\" alt=\"\" border=\"0\" height=\"5\" width=\"1\" /></td></tr><TR><td colspan=\"2\" bgcolor=\"#cdcdcd\"><img src=\"" + m_imgPfx + "/images/global/general/spacer.gif\" alt=\"\" border=\"0\" height=\"1\" width=\"1\" /></td></tr></table>" );
}
function writeFooter()
{
writeFooterStart();
writeFooterEnd();
}
function Bandwidth()
{
if( readIEVer() < 5.0 || isOpera || navigator.appVersion.toLowerCase().indexOf("win") == -1 )
{
return "NA";
}
document.body.addBehavior ("#default#clientCaps");
if ( typeof( document.body.connectionType) != "undefined" )
{
if ( document.body.connectionType == "modem" )
{
return "Modem";
}
return "Lan";
}
}
function fixup_FragHeight()
{
}
function getQueryVariable(variable)
{
var query = window.location.search.substring(1);
var vars = query.split("&");
for (var i=0;i<vars.length;i++)
{
var pair = vars[i].split("=");
if (pair[0] == variable)
{
return pair[1];
}
}
}
function renderHomepageCrumbs( footer )
{
document.write( "<div class=\"para_crumb_43\" style=\"padding-bottom:4px;padding-top:4px;\">" );
if(m_isRtl)
{
crumbStyle = "right";
crumbPadding = "left"
}
else
{
crumbStyle = "left";
crumbPadding = "right";
}
document.write("<div style=\"padding-"+ crumbPadding +":3px;font-weight:bold;float:" + crumbStyle + "\">" + getYouAreHereHome() + ":&nbsp;</div>" );
if( flag )
{
document.write( "<div style=\"float:" + crumbStyle + ";padding-"+ crumbPadding +":3px\"><img src=\"" + m_imgPfx + "/images/global/masthead/smlflags/" + flag + ".gif\" alt=\"\" border=\"0\" /></div>");
}
document.write( "<div style=\"float:" + crumbStyle + "\" class=\"crumbsel43\">" + m_ctryShort + "</div>" );
document.write( "</div>" );
}
function getYouAreHereHome()
{
if ( typeof ( m_youAreHere ) != "undefined" )
{
return m_youAreHere;
}
return "";
}
function addOnLoad( fn )
{
if ( onloadFired )
{
return;
}
if( window.onload )
{
if( window.onload != safeLoad )
{
loaded[0] = window.onload;
window.onload = safeLoad;
loaded[ 1 ] = fn;
}
else
{
loaded[ loaded.length + 1 ] = fn;
}
}
else
{
window.onload = fn;
}
}
function safeLoad()
{
onloadFired = true;
for( var i=0;i<loaded.length;i++ )
{
if( loaded[i] != undefined )
{
loaded[i]();
}
}
}
function getXMLHTTPObj()
{
var obj = false;
/*@cc_on @*/
/*@if (@_jscript_version >= 5)
try { obj = new ActiveXObject( "Msxml2.XMLHTTP" ); } catch( e ){ try { obj = new ActiveXObject( "Microsoft.XMLHTTP" ); } catch( oc ) { obj = false; } }
@end @*/
if( !obj && typeof XMLHttpRequest != "undefined" )
{
try
{
obj = new XMLHttpRequest();
}
catch(e)
{
obj = false;
}
}
if( !obj )
{
return undefined;
}
return obj;
}
var hostname = document.location.hostname.toLowerCase();
if ( hostname == "www.ap.dell.com" || hostname == "ap.dell.com" ){document.location.replace ("http://www1.ap.dell.com/content/default.aspx?c=ap&l=en&s=gen");}
if ( hostname == "www.euro.dell.com" ){document.location.replace ("http://www1.euro.dell.com/content/default.aspx?c=eu&s=gen&l=en");}
if ( hostname == "www.jp.dell.com" || hostname == "dell.co.jp" || hostname == "jp.dell.com" || hostname == "www.dell.co.jp" ){document.location.replace ("http://www1.jp.dell.com/content/default.aspx?c=jp&l=jp&s=gen");}
/* OnlineOpinion (S3t,1424b) */
/* This product and other products of OpinionLab, Inc. are protected by U.S. Patent No. 6606581, 6421724, 6785717 B1 and other patents pending. */
var custom_var,_sp='%3A\\/\\/',_rp='%3A//',_poE=0.0, _poX=0.0,_sH=screen.height,_d=document,_w=window,_ht=escape(_w.location.href),_hr=_d.referrer,_tm=(new Date()).getTime(),_kp=0,_sW=screen.width;_d.onkeypress=_fK;function _fK(_e){if(!_e)_e=_w.event;var _k=(typeof _e.which=='number')?_e.which:_e.keyCode;if((_kp==15&&_k==12))_w.open('https://secure.opinionlab.com/pageviewer/pv_controlboard.html?url='+_fC(_ht),'PageViewer','height=529,width=705,screenX='+((_sW-705)/2)+',screenY='+((_sH-529)/2)+',top='+((_sH-529)/2)+',left='+((_sW-705)/2)+',status=yes,toolbar=no,menubar=no,location=no,resizable=yes');_kp=_k};function _fC(_u){_aT=_sp+',\\/,\\.,-,_,'+_rp+',%2F,%2E,%2D,%5F';_aA=_aT.split(',');for(i=0;i<5;i++){eval('_u=_u.replace(/'+_aA[i]+'/g,_aA[i+5])')}return _u};function O_LC(){_w.open('http://ccc01.opinionlab.com/comment_card.asp?time1='+_tm+'&time2='+(new Date()).getTime()+'&prev='+_fC(escape(_hr))+'&referer='+_fC(_ht)+'&height='+_sH+'&width='+_sW+'&custom_var='+custom_var,'comments','width=535,height=192,screenX='+((_sW-535)/2)+',screenY='+((_sH-192)/2)+',top='+((_sH-192)/2)+',left='+((_sW-535)/2)+',resizable=yes,copyhistory=yes,scrollbars=no')};function _fPe(){if(Math.random()>=1.0-_poE){O_LC();_poX=0.0}};function _fPx(){if(Math.random()>=1.0-_poX)O_LC()};window.onunload=_fPx;function O_GoT(_p){_d.write('<a href=\'javascript:O_LC()\'>'+_p+'</a>');_fPe()}
function doOpionlabs( _p)
{
var pageSeg = getCookieKeyValue("lwp","s");
var pageLang = getCookieKeyValue("lwp","l");
var pageCnty = getCookieKeyValue("lwp","c");
var pageCS = getCookieKeyValue("lwp","cs");
var metricPath = null;
var metas = document.getElementsByTagName ( "META");
var _lG =pageLang + "-" + pageCnty + ".";
if ( pageLang == "jp" )
{
_lG = "ja-JP.";
}
else if ( pageLang == "en")
{
_lG = "";
}
if ( metas != null )
{
for ( i = 0 ; i < metas.length ; i ++)
{
if ( metas[i].name== "METRICSPATH" )
{
metricPath = metas[i].getAttribute("CONTENT");
if ( metricPath != null && metricPath.length > 9)
{
metricPath = metricPath.substring( 9 );
}
break;
}
}
}
var ssid = getCookie ( "SITESERVER" );
if ( ssid != null && ssid.length > 3 )
{
ssid = ssid.substring ( 3 );
}
custom_var = metricPath + "|" + ssid + "|" + pageSeg;
_rp='%3A//'+_lG;
if ( _p != null )
{
O_GoT(_p);
}
}
function getCookieKeyValue( cname, id )
{
try
{
var sid = id + "=";
var lwp = getCookie( cname );
var startIdx = 0;
var endIdx = 0;
if( lwp.indexOf(sid) == -1 )
{
return null;
}
else
{
startIdx = lwp.indexOf(sid) + id.length + 1;
if( lwp.substring( startIdx ).indexOf( "&" ) == -1 )
{
return lwp.substring( startIdx ).toLowerCase();
}
else
{
endIdx = lwp.substring( startIdx ).indexOf( "&" ) + startIdx;
}
}
return lwp.substring( startIdx, endIdx ).toLowerCase();
}
catch(e)
{}
return null;
}
function getCookie(NameOfCookie)
{
if (document.cookie.length > 0)
{
begin = document.cookie.indexOf(NameOfCookie+"=");
if (begin != -1)
{
begin += NameOfCookie.length + 1;
end = document.cookie.indexOf(";", begin);
if (end == -1)
{
end = document.cookie.length;
}
return unescape( document.cookie.substring(begin, end));
}
}
return "";
}
function doIPerceptions( ratio , jsFile)
{
var strURL = document.URL;
var country = "";
var language = "";
var segment = "";
var department= "";

country = getQueryVariable("c");
country = (country==null || country=="") ? "us" : country; 
language = getQueryVariable("l");
language = (language==null || language=="") ? "en" : language;
segment = getQueryVariable("s");
segment = (segment==null || segment=="") ? "bsd" : segment;

if (strURL.indexOf("support.dell.com") != -1 || strURL.indexOf("support.euro.dell.com") != -1 || strURL.indexOf("supportapj.dell.com") != -1)
{
department= "_support";
}
else
{
department= "";
}
var randomNumber = Math.floor((Math.random() * 100));
if (randomNumber < ratio )
{
loadIPScript( jsFile + 'wv359redirect_' + country + '_' + language + "_" + segment + department + '.js');
}
}
function loadIPScript( path )
{
var head = document.getElementsByTagName("head")[0];
script = document.createElement('script');
script.type = "text/javascript";
script.src = path;
head.appendChild(script);
}
function fixupFragHeight()
{
//if(m_isCenter && !m_isPopupIntention)
if(!m_isPopupIntention)
{
document.writeln( "<!--end center align -->" );
document.writeln( "</td></tr></table>" );
}
}



function RenderBorder()
{

document.writeln( "<table id=\"borderTable\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" bgcolor=\"#ededed\">" );
document.writeln( "<tr><td bgcolor=\"#999999\"><img src=\"" + m_imgPfx + "/images/global/general/spacer.gif\" border=\"0\" height=\"1\" width=\"1\" alt=\"\" /></td></tr>" );
document.writeln( "</table>" );

}

function RenderViewLargeTextURL(cls,lnk,txt)
{

var viewUrl = "<div class=\"" + cls + "\"><a href=\"" + lnk + "\" style=\"padding-left:20px\">" + txt + "</a></div>";
              
document.writeln(viewUrl);

}


function RenderStartLegalLinks()
{
 document.writeln( "<table width=\"100%\" cellpadding=\"0\" style=\"padding-left:10px;\" cellspacing=\"0\" border=\"0\" bgcolor=\"#ededed\">" );           
            document.writeln( "<tr><td colspan=\"2\" ><img src=\"" + m_imgPfx + "/images/global/general/spacer.gif\" border=\"0\" height=\"5\" width=\"1\" alt=\"\" /></td></tr><tr><td width=\"100%\" align=\"center\" valign=\"top\">" );
}

function RenderEndLegalLinks(gototop)
{
 document.writeln( "</td><td><table><tr><td valign=\"middle\"><a href=\"#mastheadtop\"><img src=\"" + m_imgPfx + "/images/global/brand/ui/arrow_top.gif\" width=\"7\" height=\"4\" alt=\"\" border=\"0\"></a></td><td style=\"padding-right:6px;\" valign=\"middle\"><a href=\"#mastheadtop\"><span class=\"para\">" + gototop + "</span></a></td></tr></table></td></tr><TR><td colspan=\"2\" ><img src=\"" + m_imgPfx + "/images/global/general/spacer.gif\" alt=\"\" border=\"0\" height=\"5\" width=\"1\" /></td></tr><TR><td colspan=\"2\" bgcolor=\"#cdcdcd\"><img src=\"" + m_imgPfx + "/images/global/general/spacer.gif\" alt=\"\" border=\"0\" height=\"1\" width=\"1\" /></td></tr></table>" );
}