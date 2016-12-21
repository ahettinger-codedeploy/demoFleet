var nav_QuickSiteMain = new Object();

nav_QuickSiteMain.underline="false";
nav_QuickSiteMain.justification="center";
nav_QuickSiteMain.accentStyle="Arrow";
nav_QuickSiteMain.selectedUnderline="false";
nav_QuickSiteMain.textFont="Helvetica";
nav_QuickSiteMain.funButton="Arts_and_Crafts";
nav_QuickSiteMain.mouseoverBgcolor="";
nav_QuickSiteMain.darkButton="Basic_Black";
nav_QuickSiteMain.buttonCategory="basic";
nav_QuickSiteMain.mouseoverBold="true";
nav_QuickSiteMain.italic="false";
nav_QuickSiteMain.importedImageMouseOver="";
nav_QuickSiteMain.textSize="14";
nav_QuickSiteMain.tabCategory="basic";
nav_QuickSiteMain.style="text";
nav_QuickSiteMain.hasLinks="true";
nav_QuickSiteMain.accentColor="Black";
nav_QuickSiteMain.selectedBgcolor="";
nav_QuickSiteMain.graphicSelected="true";
nav_QuickSiteMain.selectedTextcolor="#9F8045";
nav_QuickSiteMain.basicButton="Gray";
nav_QuickSiteMain.accentType="none";
nav_QuickSiteMain.graphicMouseover="true";
nav_QuickSiteMain.horizontalSpacing="26";
nav_QuickSiteMain.lineColor="#000000";
nav_QuickSiteMain.selectedEffect="false";
nav_QuickSiteMain.lineWidth="2";
nav_QuickSiteMain.modernButton="Basic_Black";
nav_QuickSiteMain.border="";
nav_QuickSiteMain.type="Navigation";
nav_QuickSiteMain.simpleButton="Autumn_Leaves";
nav_QuickSiteMain.sophisticatedButton="Antique";
nav_QuickSiteMain.bold="true";
nav_QuickSiteMain.localPreview="true";
nav_QuickSiteMain.verticalSpacing="10";
nav_QuickSiteMain.basicTab="White";
nav_QuickSiteMain.selectedBold="true";
nav_QuickSiteMain.mouseoverEffect="true";
nav_QuickSiteMain.mouseoverTextcolor="#D1AF6E";
nav_QuickSiteMain.navID="nav_QuickSiteMain";
nav_QuickSiteMain.mouseoverUnderline="false";
nav_QuickSiteMain.imageHeight="31";
nav_QuickSiteMain.texturedButton="Brick";
nav_QuickSiteMain.selectedItalic="false";
nav_QuickSiteMain.brightButton="Chicky";
nav_QuickSiteMain.importedImageSelected="";
nav_QuickSiteMain.dirty="false";
nav_QuickSiteMain.squareTab="Camel";
nav_QuickSiteMain.horizontalWrap="7";
nav_QuickSiteMain.mouseoverItalic="false";
nav_QuickSiteMain.imageWidth="114";
nav_QuickSiteMain.numLinks="5";
nav_QuickSiteMain.background="";
nav_QuickSiteMain.importedImage="";
nav_QuickSiteMain.version="5";
nav_QuickSiteMain.shinyButton="Shiny_Aqua";
nav_QuickSiteMain.orientation="horizontal";
nav_QuickSiteMain.holidayButton="Christmas_Ornaments";
nav_QuickSiteMain.textColor="#E8E7CE";

nav_QuickSiteMain.navName="QuickSiteMain";
nav_QuickSiteMain.imagePath = "";
nav_QuickSiteMain.selectedImagePath = "http://www.homestead.com/~media/elements/LayoutClipart/Accent_Arrow_Black_Selected";
nav_QuickSiteMain.mouseOverImagePath = "http://www.homestead.com/~media/elements/LayoutClipart/Accent_Arrow_Black_Selected";
nav_QuickSiteMain.imageWidth = "16";
nav_QuickSiteMain.imageHeight = "16";
nav_QuickSiteMain.fontClass = "size14 Helvetica14";
nav_QuickSiteMain.fontFace = "Helvetica, Arial, sans-serif";



	var baseHref = '';
	
	if (document.getElementsByTagName)
	{
	
	var base = document.getElementsByTagName('base');
	
	if (base && base.length > 0)
	{
	
	if (base[0].href != undefined)
	{
	
	baseHref = base[0].href;
	
	if (baseHref != '' && baseHref.charAt(baseHref.length - 1) != '/')
	{
	baseHref += '/';
	}
	}
	}
	}


nav_QuickSiteMain.links=new Array(5);


var nav_QuickSiteMain_Link1 = new Object();
nav_QuickSiteMain_Link1.type = "existing";
nav_QuickSiteMain_Link1.displayName = "Home";
nav_QuickSiteMain_Link1.linkWindow = "_self";
nav_QuickSiteMain_Link1.linkValue = "index.html";
nav_QuickSiteMain_Link1.linkIndex = "1";
nav_QuickSiteMain.links[0] = nav_QuickSiteMain_Link1;

var nav_QuickSiteMain_Link2 = new Object();
nav_QuickSiteMain_Link2.type = "existing";
nav_QuickSiteMain_Link2.displayName = "Photos";
nav_QuickSiteMain_Link2.linkWindow = "_self";
nav_QuickSiteMain_Link2.linkValue = "biography.html";
nav_QuickSiteMain_Link2.linkIndex = "2";
nav_QuickSiteMain.links[1] = nav_QuickSiteMain_Link2;

var nav_QuickSiteMain_Link3 = new Object();
nav_QuickSiteMain_Link3.type = "existing";
nav_QuickSiteMain_Link3.displayName = "Concert&nbsp;Photos";
nav_QuickSiteMain_Link3.linkWindow = "_self";
nav_QuickSiteMain_Link3.linkValue = "discography.html";
nav_QuickSiteMain_Link3.linkIndex = "3";
nav_QuickSiteMain.links[2] = nav_QuickSiteMain_Link3;

var nav_QuickSiteMain_Link4 = new Object();
nav_QuickSiteMain_Link4.type = "existing";
nav_QuickSiteMain_Link4.displayName = "Upcoming&nbsp;Shows";
nav_QuickSiteMain_Link4.linkWindow = "_self";
nav_QuickSiteMain_Link4.linkValue = "shows.html";
nav_QuickSiteMain_Link4.linkIndex = "4";
nav_QuickSiteMain.links[3] = nav_QuickSiteMain_Link4;

var nav_QuickSiteMain_Link5 = new Object();
nav_QuickSiteMain_Link5.type = "existing";
nav_QuickSiteMain_Link5.displayName = "Contact&nbsp;Me";
nav_QuickSiteMain_Link5.linkWindow = "_self";
nav_QuickSiteMain_Link5.linkValue = "contact.html";
nav_QuickSiteMain_Link5.linkIndex = "5";
nav_QuickSiteMain.links[4] = nav_QuickSiteMain_Link5;




function renderTextHTML(Navigation, strTpGif)
{
	
	var strHTML = '';
	
	
	if(Navigation.border)
	{
	strHTML += '<TABLE CELLSPACING="0" BORDER="0" CELLPADDING="0">';
	strHTML += '<TR HEIGHT="2" BGCOLOR="' + Navigation.border + '"><TD HEIGHT="2" COLSPAN="3"><IMG SRC="/tp.gif" HEIGHT="2" ALT=""></TD></TR>';
	strHTML += '<TR><TD WIDTH="2" BGCOLOR="' + Navigation.border + '"><IMG SRC="/tp.gif" HEIGHT="2" ALT=""></TD><TD>';
	}
	var strBGColor = '';
	if(Navigation.background)
	{
	strBGColor = 'BGCOLOR="' + Navigation.background + '"';	
	}
	
	strHTML += '<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" ' + strBGColor + '>';

	
	var i;
	for(i = 0; i < Navigation.links.length; i++)
	{
	strHTML += renderTextLink(Navigation, Navigation.links[i], strTpGif);	
	}

	strHTML += '</TABLE>';
	
	if(Navigation.border)
	{
	strHTML += '</TD><TD WIDTH="2" BGCOLOR="' + Navigation.border + '"><IMG SRC="/tp.gif" HEIGHT="2" ALT=""></TD></TR>';
	strHTML += '<TR HEIGHT="2" BGCOLOR="' + Navigation.border + '"><TD HEIGHT="2" COLSPAN="3"><IMG SRC="/tp.gif" HEIGHT="2" ALT=""></TD></TR>';
	strHTML += '</TABLE>';
	}
	
	
	return strHTML;
}
 
function backgroundMouseOn(tableCell, newColor) 
{ 
	tableCell.oldBGColor = tableCell.style.backgroundColor;
	tableCell.style.backgroundColor = newColor;
} 
function backgroundMouseOff(tableCell)
{ 
	tableCell.style.backgroundColor = tableCell.oldBGColor;
}

function getTextMouseOverHandler(Navigation, bIsCurrentPage)
{
	
	if (Navigation.mouseoverEffect != 'true') return '';

	var bShowMouseoverBg = !(bIsCurrentPage && 'true' == Navigation.selectedEffect && Navigation.selectedBgcolor);
	var bShowMouseoverText = !(bIsCurrentPage && 'true' == Navigation.selectedEffect && Navigation.selectedTextcolor);

	var strMouseOver = '';
	var strMouseOut = '';
	
	if(Navigation.mouseoverBgcolor && bShowMouseoverBg)
	{
	strMouseOver += ' backgroundMouseOn(this, \'' + Navigation.mouseoverBgcolor+ '\');';
	strMouseOut += ' backgroundMouseOff(this);';
	}
	var textColor;
	var baseTextColor = Navigation.textColor;
	var bold;
	var baseBold = Navigation.bold;
	var underline;
	var baseUnderline = Navigation.underline;
	var italic;
	var baseItalic = Navigation.italic;
	if(bIsCurrentPage && 'true' == Navigation.selectedEffect)
	{
	textColor = Navigation.selectedTextcolor ? Navigation.selectedTextcolor : (Navigation.mouseoverTextColor ? Navigation.mouseoverTextcolor : Navigation.textColor);
	baseTextColor = Navigation.selectedTextcolor ? Navigation.selectedTextcolor : Navigation.textColor;
	baseBold = bold = Navigation.selectedBold;
	baseUnderline = underline = Navigation.selectedUnderline;
	baseItalic = italic = Navigation.selectedItalic;
	}
	else
	{
	textColor = Navigation.mouseoverTextcolor ? Navigation.mouseoverTextcolor : Navigation.textColor;
	bold = Navigation.mouseoverBold;
	underline = Navigation.mouseoverUnderline;
	italic = Navigation.mouseoverItalic;
	}
	strMouseOver += ' textMouseOn(this, \'' + textColor + '\', \'' + bold + '\', \'' + underline + '\', \'' + italic + '\');';
	strMouseOut += ' textMouseOff(this, \'' + baseTextColor + '\', \'' + baseBold + '\', \'' + baseUnderline + '\', \'' + baseItalic + '\');';
	
	return ' onMouseOver="' + strMouseOver + '" onMouseOut="' + strMouseOut + '"';
}

function getTextStyle(strFontColor, bold, italic, underline, bNetscape) 
{
	
	var strStyle = ' style="';

	strStyle += 'cursor: pointer; cursor: hand; '; 
	strStyle += 'color:' + strFontColor + ';';
	
	if(!bNetscape)
	{
	if (bold) strStyle += 'font-weight: bold;';
	if (italic) strStyle += 'font-style: italic;';
	if (underline) strStyle += 'text-decoration: underline;';
	}
	
	
	strStyle += '" ';
	
	return strStyle;
}

function renderTextLink(Navigation, Link, strTpGif)
{
	var strHTML = '';
	
	var bIsCurrentPage = isCurrentPage(Link);
	
	
	var strLinkValue = fixLinkValue(Link);
	
	var strFontColor = Navigation.textColor;	
	var strBGHTML = '';	
	var strGraphicName = 'ID' + Navigation.navName + Link.linkIndex;
	
	var nVerticalSpacing = Navigation.verticalSpacing;
	var nHorizontalSpacing = Navigation.horizontalSpacing;
	
	var nVertPaddingTop = Math.floor(nVerticalSpacing/2);
	var nVertPaddingBottom = Math.round(nVerticalSpacing/2);
	
	var nHorizPaddingLeft = Math.floor(nHorizontalSpacing/2);
	var nHorizPaddingRight = Math.round(nHorizontalSpacing/2);
	var bLastLink = Link.linkIndex == Navigation.numLinks;
	
	var nGeneralPadding = 10;
	var nAccentGraphicPadding = 10;
	var nAccentWidth = Navigation.imageWidth;
	var nAccentHeight = Navigation.imageHeight;

	
	if (bIsCurrentPage && 'true' == Navigation.selectedEffect) 
	{
	if(Navigation.selectedTextcolor)
	{
	strFontColor = Navigation.selectedTextcolor;
	}
	if(Navigation.selectedBgcolor)
	{
	strBGHTML += ' BGCOLOR="' + Navigation.selectedBgcolor + '" ';
	}
	} 
	
	var bBackgroundOrBorder = Navigation.border || Navigation.background;
	
	
	var bNetscape = false;
	var strAppName = navigator.appName;
	var appVer = parseFloat(navigator.appVersion);
	
	if ( (strAppName == 'Netscape') &&
	(appVer >= 4.0 && appVer < 5) ) 
	{ 
	bNetscape = true;
	}	
	
	var strOnClick = getOnClick(strLinkValue, Link.linkWindow); 
	var strStyle = getTextStyle(
	strFontColor,
	((bIsCurrentPage && 'true' == Navigation.selectedEffect) ? ('true' == Navigation.selectedBold) : ('true' == Navigation.bold)),
	((bIsCurrentPage && 'true' == Navigation.selectedEffect) ? ('true' == Navigation.selectedItalic) : ('true' == Navigation.italic)),
	((bIsCurrentPage && 'true' == Navigation.selectedEffect) ? ('true' == Navigation.selectedUnderline) : ('true' == Navigation.underline)),
	bNetscape
	);
	var strMouseOver = getTextMouseOverHandler(Navigation, bIsCurrentPage);
	
	var strAlignment;
	if(Navigation.orientation=='vertical')
	{
	strAlignment = Navigation.justification;	
	}
	else
	{
	strAlignment = 'center';	
	}
	
	var strTextAlignment = 'ALIGN="' + strAlignment + '" ';
	
	
	var strLinkTarget = Link.linkWindow;
	if(strLinkTarget == '_self')
	{
	strLinkTarget = '_parent';
	}

	if(Navigation.orientation=='horizontal')
	{
	if((Link.linkIndex % Navigation.horizontalWrap) == 1) 
	{
	strHTML += '<TR ALIGN="CENTER" VALIGN="MIDDLE">';
	strHTML += '<TD>';
	strHTML += '<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0">';
	strHTML += '<TR>';
	}	
	}
	else
	{
	strHTML += '<TR ';
	strHTML += strBGHTML;
	
	if(!bNetscape)
	{
	strHTML += strOnClick + strStyle + strMouseOver;
	}
	
	strHTML +='>';

	if(Navigation.accentType == 'left' || Navigation.accentType=='both')
	{
	strHTML += '<TD ALIGN="CENTER" >';
	
	if(bNetscape)
	{
	strHTML += '<A TARGET="' + strLinkTarget + '" HREF="' + strLinkValue + '">';
	}
	
	if(Navigation.border!='' || Navigation.background!='')
	{
	strHTML += '<IMG SRC="' + strTpGif + '" WIDTH="' + nGeneralPadding + '" HEIGHT="' + nAccentHeight + '" BORDER="0">';	
	}
	
	strHTML += '<IMG NAME="' + strGraphicName + '" SRC="' + Navigation.imagePath + '" HEIGHT="' + nAccentHeight + '" WIDTH="' + nAccentWidth + '" BORDER="0">';
	strHTML += '<IMG SRC="' + strTpGif + '" WIDTH="' + nAccentGraphicPadding + '" HEIGHT="' + nAccentHeight +'" BORDER="0">';
	
	if(bNetscape)
	{
	strHTML += '</A>';
	}
	
	strHTML += '</TD>';
	}
	}
	
	strHTML += '<TD ' + strTextAlignment + ' VALIGN="MIDDLE" NOWRAP ';	
	
	
	strHTML += ' id="'+Navigation.navName+'_Link'+Link.linkIndex+'"';
	
	if(Navigation.orientation=='horizontal')
	{
	strHTML += strBGHTML;
	if(!bNetscape)
	{
	strHTML += strOnClick + strStyle + strMouseOver;
	}
	}
	
	strHTML += '>';
	
	
	if(bNetscape)
	{
	strHTML += '<A HREF="' + strLinkValue + '" TARGET="' + strLinkTarget + '">'; 
	}	
	
	if(Navigation.orientation=='vertical')
	{
	if(nVertPaddingTop > 0)
	{
	strHTML += '<IMG SRC="' + strTpGif + '" WIDTH="1" HEIGHT="' + nVertPaddingTop + '" BORDER="0"><BR>';
	}
	
	if(Navigation.accentType=='lines' || ((Navigation.border!='' || Navigation.background!='') && Navigation.accentType!='left' && Navigation.accentType!='both'))
	{
	strHTML += '<IMG SRC="' + strTpGif + '" WIDTH="' + nGeneralPadding + '" HEIGHT="1" BORDER="0">';
	}
	}
	else
	{
	if(bBackgroundOrBorder && nVertPaddingTop > 0)
	{
	strHTML += '<IMG SRC="' + strTpGif + '" WIDTH="1" HEIGHT="' + nVertPaddingTop + '" BORDER="0"><BR>';
	}
	
	if( ((Link.linkIndex % Navigation.horizontalWrap) != 1 || bBackgroundOrBorder) && nHorizPaddingLeft > 0) 
	{
	strHTML += '<IMG SRC="' + strTpGif + '" WIDTH="' + nHorizPaddingLeft + '" HEIGHT="1" BORDER="0">';
	}	

	if(Navigation.accentType=='left' || Navigation.accentType=='both')
	{
	strHTML += '<IMG NAME="' + strGraphicName + '" SRC="'+ Navigation.imagePath + '" HEIGHT="' + nAccentHeight + '" WIDTH="' + nAccentWidth + '" BORDER="0">';
	strHTML += '<IMG SRC="' + strTpGif + '" WIDTH="' + nAccentGraphicPadding + '" HEIGHT="' + nAccentHeight + '" BORDER="0">';
	}	
	}

	
	var strFormattingStart = ''; 
	var strFormattingEnd = '';
	if (bNetscape)
	{
	if((bIsCurrentPage && 'true' == Navigation.selectedEffect) ? ('true' == Navigation.selectedItalic) : ('true' == Navigation.italic))
	{
	strFormattingStart += '<I>';
	strFormattingEnd = '</I>' + strFormattingEnd;
	}
	if((bIsCurrentPage && 'true' == Navigation.selectedEffect) ? ('true' == Navigation.selectedBold) : ('true' == Navigation.bold))
	{
	strFormattingStart += '<B>';
	strFormattingEnd = '</B>' + strFormattingEnd;
	}
	}
	
	strHTML += '<FONT';
	strHTML += ' FACE="' + Navigation.fontFace + '" ';
	strHTML += ' CLASS="' + Navigation.fontClass + '" '; 
	
	if(bNetscape)
	{
	strHTML += ' COLOR="' + strFontColor + '"';
	}
	strHTML += '>'; 
	
	strHTML += strFormattingStart + Link.displayName + strFormattingEnd;
	
	strHTML += '</FONT>';
	
	
	if(Navigation.orientation=='vertical')
	{
	if(Navigation.accentType=='lines' || (bBackgroundOrBorder && Navigation.accentType!='both' ))
	{
	strHTML += '<IMG SRC="' + strTpGif + '" WIDTH="' + nGeneralPadding + '" HEIGHT="1" BORDER="0">';
	}
	
	if (nVertPaddingBottom > 0)
	{
	strHTML += '<BR><IMG SRC="' + strTpGif + '" WIDTH="1" HEIGHT="' + nVertPaddingBottom + '" BORDER="0">';
	}
	}
	else
	{
	if(Navigation.accentType=='both')
	{
	strHTML += '<IMG SRC="' + strTpGif + '" WIDTH="' + nAccentGraphicPadding + '" HEIGHT="' + nAccentHeight + '" BORDER="0">';
	strHTML += '<IMG NAME="' + strGraphicName + '" SRC="' + Navigation.imagePath + '" HEIGHT="' + nAccentHeight + '" WIDTH="' + nAccentWidth + '" BORDER="0">';
	}
	
	if (((Link.linkIndex % Navigation.horizontalWrap != 0 && !bLastLink) || bBackgroundOrBorder) && nHorizPaddingRight > 0 ) 
	{
	strHTML += '<IMG SRC="' + strTpGif + '" WIDTH="' + nHorizPaddingRight + '" HEIGHT="1" BORDER="0">';
	}
	
	if(bBackgroundOrBorder && nVertPaddingBottom > 0)
	{
	strHTML += '<BR><IMG SRC="' + strTpGif + '" WIDTH="1" HEIGHT="' + nVertPaddingBottom + '" BORDER="0">';
	}
	}
	
	
	if(bNetscape)
	{
	strHTML += '</A>';
	}	

	
	strHTML += '</TD>';
	
	if(Navigation.orientation=='vertical')
	{
	if(Navigation.accentType=='both')
	{
	strHTML += '<TD ALIGN="CENTER" >';
	
	if(bNetscape)
	{
	strHTML += '<A TARGET="' + Link.linkWindow + '" HREF="' + strLinkValue + '">';
	}
	
	
	if(bBackgroundOrBorder)
	{
	strHTML += '<IMG SRC="' + strTpGif + '" WIDTH="' + nGeneralPadding + '" HEIGHT="' + nAccentHeight + '" BORDER="0">';
	}
	
	strHTML += '<IMG NAME="' + strGraphicName + '" SRC="' + Navigation.imagePath + '" HEIGHT="' + nAccentHeight + '" WIDTH="' + nAccentWidth + '" BORDER="0">';
	strHTML += '<IMG SRC="' + strTpGif + '" WIDTH="' + nAccentGraphicPadding + '" HEIGHT="' + nAccentHeight +'" BORDER="0">';
	
	if(bNetscape)
	{
	strHTML += '</A>';
	}
	strHTML += '</TD>';
	}
	
	
	strHTML += '</TR>';
	
	if(Navigation.accentType=='lines')
	{
	if(!bLastLink)
	{
	strHTML += '<TR><TD HEIGHT="' + Navigation.lineWidth + '" BGCOLOR="' + Navigation.lineColor + '">';
	strHTML += '<IMG SRC="' + strTpGif + '" WIDTH="1" HEIGHT="' + Navigation.lineWidth + '"></TD></TR>';
	}
	}
	}
	else
	{
	
	if(Navigation.accentType == 'lines')
	{	
	if(!bLastLink && ((Link.linkIndex % Navigation.horizontalWrap) != 0)) 
	{ 
	strHTML += '<TD WIDTH="' + Navigation.lineWidth +'" BGCOLOR="' + Navigation.lineColor + '">';
	strHTML += '<IMG SRC="' + strTpGif + '" WIDTH="' + Navigation.lineWidth + '"></TD>';
	}
	}
	
	
	if( ((Link.linkIndex % Navigation.horizontalWrap) == 0) || bLastLink )
	{
	strHTML += '</TR>';
	strHTML += '</TABLE>';
	strHTML += '</TD></TR>';
	
	if(!bLastLink && !bBackgroundOrBorder)
	{	
	if (nVerticalSpacing > 0)
	{
	strHTML += '<TR>';
	strHTML += '<TD>';
	strHTML += '<IMG SRC="' + strTpGif + '" WIDTH="1" HEIGHT="' + nVerticalSpacing + '" BORDER="0">';
	strHTML += '</TD></TR>';
	}
	}
	}
	}
	return strHTML;
}




function renderHTML(Navigation)
{
	if (navigator.userAgent.indexOf('Mozilla/3') != -1)
	{
	return 'Sorry, since you are using an old version of Netscape, you may not be able to access all the pages in this Web site.';	
	}

	if (Navigation.style == 'text')
	{
	return renderTextHTML(Navigation, '/tp.gif');
	}
	else
	{
	return renderGraphicalHTML(Navigation, '/tp.gif');
	}
}


function fixLinkValue(Link)
{
	if(Link.type!='existing')
	{
	return Link.linkValue;
	}
	else
	{
	return baseHref + strRelativePathToRoot + Link.linkValue;	
	}
}

function isCurrentPage(Link) 
{
	if(Link.type!='existing')
	{
	return false;
	}	
	var strLinkValue = Link.linkValue.toLowerCase();
	return (strRelativePagePath == strLinkValue);	
} 

function getOnClick(strLinkValue, strLinkTarget) 
{ 
	var strOnClick;
	if(strLinkTarget == '_blank')
	{
	strOnClick = 'onClick="window.open(\'' + strLinkValue + '\');"';
	}
	else
	{ 
	strOnClick = 'onClick="document.location = \'' + strLinkValue + '\';"';
	}
	return strOnClick;
} 

function netscapeDivCheck() 
{ 
	var strAppName = navigator.appName;
	var appVer = parseFloat(navigator.appVersion);
	if ( (strAppName == 'Netscape') &&
	(appVer >= 4.0 && appVer < 5) ) { document.write('</DIV>');
	}
}

function textMouseOn(textObj, newColor, mouseoverBold, mouseoverUnderline, mouseoverItalic)
{ 
	if(newColor)
	{
	textObj.style.color=newColor; 
	}
	if(mouseoverBold=='true')
	{
	textObj.style.fontWeight='bold';
	}
	else
	{
	textObj.style.fontWeight='normal';
	}
	if(mouseoverUnderline=='true')
	{
	textObj.style.textDecoration='underline';
	}
	else
	{
	textObj.style.textDecoration='none';
	}
	if(mouseoverItalic=='true')
	{
	textObj.style.fontStyle='italic';
	}
	else
	{
	textObj.style.fontStyle='normal';
	}
} 

function textMouseOff(textObj, newColor, bold, underline, italic)
{ 
	textObj.style.color=newColor; 
	if(bold=='true')
	{
	textObj.style.fontWeight='bold';
	}
	else
	{
	textObj.style.fontWeight='normal';
	}
	if(underline=='true')
	{
	textObj.style.textDecoration='underline';
	}
	else
	{
	textObj.style.textDecoration='none';
	}
	if(italic=='true')
	{
	textObj.style.fontStyle='italic';
	}
	else
	{
	textObj.style.fontStyle='normal';
	}
}



	document.write(renderHTML(nav_QuickSiteMain));

