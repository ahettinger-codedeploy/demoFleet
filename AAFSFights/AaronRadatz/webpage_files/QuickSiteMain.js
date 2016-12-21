var nav_QuickSiteMain = new Object();

nav_QuickSiteMain.mouseoverTextcolor="";
nav_QuickSiteMain.numLinks="10";
nav_QuickSiteMain.holidayButton="Christmas_Ornaments";
nav_QuickSiteMain.selectedItalic="false";
nav_QuickSiteMain.importedImageMouseOver="";
nav_QuickSiteMain.modernButton="Basic_Black";
nav_QuickSiteMain.lineWidth="1";
nav_QuickSiteMain.sophisticatedButton="Antique";
nav_QuickSiteMain.textColor="#FFFFFF";
nav_QuickSiteMain.buttonCategory="basic";
nav_QuickSiteMain.selectedUnderline="false";
nav_QuickSiteMain.underline="false";
nav_QuickSiteMain.accentStyle="Sphere";
nav_QuickSiteMain.mouseoverItalic="false";
nav_QuickSiteMain.horizontalWrap="10";
nav_QuickSiteMain.bold="false";
nav_QuickSiteMain.accentType="lines";
nav_QuickSiteMain.border="";
nav_QuickSiteMain.selectedBgcolor="";
nav_QuickSiteMain.squareTab="Camel";
nav_QuickSiteMain.orientation="horizontal";
nav_QuickSiteMain.selectedTextcolor="";
nav_QuickSiteMain.horizontalSpacing="10";
nav_QuickSiteMain.style="text";
nav_QuickSiteMain.mouseoverBgcolor="#406AB0";
nav_QuickSiteMain.accentColor="Royal_Blue";
nav_QuickSiteMain.imageWidth="114";
nav_QuickSiteMain.basicTab="Black";
nav_QuickSiteMain.graphicMouseover="true";
nav_QuickSiteMain.texturedButton="Brick";
nav_QuickSiteMain.tabCategory="basic";
nav_QuickSiteMain.funButton="Arts_and_Crafts";
nav_QuickSiteMain.localPreview="false";
nav_QuickSiteMain.dirty="false";
nav_QuickSiteMain.simpleButton="Autumn_Leaves";
nav_QuickSiteMain.mouseoverBold="false";
nav_QuickSiteMain.selectedEffect="false";
nav_QuickSiteMain.basicButton="Gray";
nav_QuickSiteMain.hasLinks="true";
nav_QuickSiteMain.importedImage="";
nav_QuickSiteMain.mouseoverUnderline="false";
nav_QuickSiteMain.lineColor="#000000";
nav_QuickSiteMain.textSize="12";
nav_QuickSiteMain.selectedBold="true";
nav_QuickSiteMain.mouseoverEffect="true";
nav_QuickSiteMain.type="Navigation";
nav_QuickSiteMain.importedImageSelected="";
nav_QuickSiteMain.textFont="Arial";
nav_QuickSiteMain.background="";
nav_QuickSiteMain.version="5";
nav_QuickSiteMain.italic="false";
nav_QuickSiteMain.darkButton="Basic_Black";
nav_QuickSiteMain.justification="left";
nav_QuickSiteMain.imageHeight="31";
nav_QuickSiteMain.graphicSelected="true";
nav_QuickSiteMain.brightButton="Chicky";
nav_QuickSiteMain.verticalSpacing="10";
nav_QuickSiteMain.navID="nav_QuickSiteMain";
nav_QuickSiteMain.shinyButton="Shiny_Aqua";
nav_QuickSiteMain.width="924";
nav_QuickSiteMain.height="18";
nav_QuickSiteMain.topFrame="true";

nav_QuickSiteMain.navName = "QuickSiteMain";
nav_QuickSiteMain.imagePath = "null";
nav_QuickSiteMain.selectedImagePath = "/~media/elements/LayoutClipart/";
nav_QuickSiteMain.mouseOverImagePath = "/~media/elements/LayoutClipart/";
nav_QuickSiteMain.imageWidth = "16";
nav_QuickSiteMain.imageHeight = "16";
nav_QuickSiteMain.fontClass = "size12 Arial12";
nav_QuickSiteMain.fontFace = "Arial, Helvetica, sans-serif";


var baseHref = '';
// this will only work if getElementsByTagName works
if (document.getElementsByTagName)
{
    // this will only work if we can find a base tag
    var base = document.getElementsByTagName('base');
    // Verify that the base object exists
    if (base && base.length > 0)
    {
        // if you don't specify a base href, href comes back as undefined
        if (base[0].href != undefined)
        {
            // get the base href
            baseHref = base[0].href;
            // add a trailing slash if base href doesn't already have one
            if (baseHref != '' && baseHref.charAt(baseHref.length - 1) != '/')
            {
                baseHref += '/';
            }
        }
    }
}


nav_QuickSiteMain.links=new Array(10);
var nav_QuickSiteMain_Link1 = new Object();
nav_QuickSiteMain_Link1.type = "existing";
nav_QuickSiteMain_Link1.displayName = "Home";
nav_QuickSiteMain_Link1.linkWindow = "_self";
nav_QuickSiteMain_Link1.linkValue = "index.html";
nav_QuickSiteMain_Link1.linkIndex = "1";
nav_QuickSiteMain.links[0] = nav_QuickSiteMain_Link1;
var nav_QuickSiteMain_Link2 = new Object();
nav_QuickSiteMain_Link2.type = "url";
nav_QuickSiteMain_Link2.displayName = "Tickets";
nav_QuickSiteMain_Link2.linkWindow = "_self";
nav_QuickSiteMain_Link2.linkValue = "http://aaronradatz.tix.com";
nav_QuickSiteMain_Link2.linkIndex = "2";
nav_QuickSiteMain.links[1] = nav_QuickSiteMain_Link2;
var nav_QuickSiteMain_Link3 = new Object();
nav_QuickSiteMain_Link3.type = "existing";
nav_QuickSiteMain_Link3.displayName = "Biography";
nav_QuickSiteMain_Link3.linkWindow = "_self";
nav_QuickSiteMain_Link3.linkValue = "biography.html";
nav_QuickSiteMain_Link3.linkIndex = "3";
nav_QuickSiteMain.links[2] = nav_QuickSiteMain_Link3;
var nav_QuickSiteMain_Link4 = new Object();
nav_QuickSiteMain_Link4.type = "existing";
nav_QuickSiteMain_Link4.displayName = "Choose&nbsp;a&nbsp;Show";
nav_QuickSiteMain_Link4.linkWindow = "_self";
nav_QuickSiteMain_Link4.linkValue = "chooseashow.html";
nav_QuickSiteMain_Link4.linkIndex = "4";
nav_QuickSiteMain.links[3] = nav_QuickSiteMain_Link4;
var nav_QuickSiteMain_Link5 = new Object();
nav_QuickSiteMain_Link5.type = "existing";
nav_QuickSiteMain_Link5.displayName = "Clients&nbsp;and&nbsp;Reviews";
nav_QuickSiteMain_Link5.linkWindow = "_self";
nav_QuickSiteMain_Link5.linkValue = "clientsandreviews.html";
nav_QuickSiteMain_Link5.linkIndex = "5";
nav_QuickSiteMain.links[4] = nav_QuickSiteMain_Link5;
var nav_QuickSiteMain_Link6 = new Object();
nav_QuickSiteMain_Link6.type = "existing";
nav_QuickSiteMain_Link6.displayName = "Special&nbsp;Projects";
nav_QuickSiteMain_Link6.linkWindow = "_self";
nav_QuickSiteMain_Link6.linkValue = "specialprojects.html";
nav_QuickSiteMain_Link6.linkIndex = "6";
nav_QuickSiteMain.links[5] = nav_QuickSiteMain_Link6;
var nav_QuickSiteMain_Link7 = new Object();
nav_QuickSiteMain_Link7.type = "existing";
nav_QuickSiteMain_Link7.displayName = "Pictures";
nav_QuickSiteMain_Link7.linkWindow = "_self";
nav_QuickSiteMain_Link7.linkValue = "pictures.html";
nav_QuickSiteMain_Link7.linkIndex = "7";
nav_QuickSiteMain.links[6] = nav_QuickSiteMain_Link7;
var nav_QuickSiteMain_Link8 = new Object();
nav_QuickSiteMain_Link8.type = "existing";
nav_QuickSiteMain_Link8.displayName = "Video";
nav_QuickSiteMain_Link8.linkWindow = "_self";
nav_QuickSiteMain_Link8.linkValue = "video.html";
nav_QuickSiteMain_Link8.linkIndex = "8";
nav_QuickSiteMain.links[7] = nav_QuickSiteMain_Link8;
var nav_QuickSiteMain_Link9 = new Object();
nav_QuickSiteMain_Link9.type = "existing";
nav_QuickSiteMain_Link9.displayName = "Fan&nbsp;Club";
nav_QuickSiteMain_Link9.linkWindow = "_self";
nav_QuickSiteMain_Link9.linkValue = "fanclub.html";
nav_QuickSiteMain_Link9.linkIndex = "9";
nav_QuickSiteMain.links[8] = nav_QuickSiteMain_Link9;
var nav_QuickSiteMain_Link10 = new Object();
nav_QuickSiteMain_Link10.type = "existing";
nav_QuickSiteMain_Link10.displayName = "Contact&nbsp;Information";
nav_QuickSiteMain_Link10.linkWindow = "_self";
nav_QuickSiteMain_Link10.linkValue = "contactinfomation.html";
nav_QuickSiteMain_Link10.linkIndex = "10";
nav_QuickSiteMain.links[9] = nav_QuickSiteMain_Link10;
function renderTextHTML(Navigation, strTpGif)
{
	// Displays the border and background color for text navigations
	var strHTML = '';

	// Add a 1 px border if specified
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

	// Generate the links
	var i;
	for(i = 0; i < Navigation.links.length; i++)
	{
		strHTML += renderTextLink(Navigation, Navigation.links[i], strTpGif);
	}

	strHTML += '</TABLE>';

	if(Navigation.border)
	{
		strHTML += '</TD><TD WIDTH="2" BGCOLOR="' + Navigation.border + '"><IMG SRC="/tp.gif" HEIGHT="2" ALT=""></TD></TR>';
		strHTML += '<TR HEIGHT="2" BGCOLOR="'  + Navigation.border + '"><TD HEIGHT="2" COLSPAN="3"><IMG SRC="/tp.gif" HEIGHT="2" ALT=""></TD></TR>';
		strHTML += '</TABLE>';
	}

	// Output the navigation
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
	// If user did not check the 'Mouseover Effect' box in the Effects tab, there is no mouseover effect
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
	// start style
	var strStyle = ' style="';

	strStyle += 'cursor: pointer; cursor: hand; '; // pointer is supported by IE6/Moz, hand is required for IE 5.x
	strStyle += 'color:' + strFontColor + ';';

	if(!bNetscape)
	{
		if (bold) strStyle += 'font-weight: bold;';
		if (italic) strStyle += 'font-style: italic;';
		if (underline) strStyle += 'text-decoration: underline;';
	}

	// end style
	strStyle += '" ';

	return strStyle;
}

function renderTextLink(Navigation, Link, strTpGif)
{
	var strHTML = '';
	// Determine if this link represents the current page
	var bIsCurrentPage = isCurrentPage(Link);

	// Get the link value
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

	//
	//	Determine current page variables
	//	Current page highlights (background and text) take precedence over text and background mouseovers
	
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

	//
	//	Check if using a version of Netscape 4.x, since this requires
	//	special handling.
	
	var bNetscape = false;
	var strAppName = navigator.appName;
	var appVer = parseFloat(navigator.appVersion);

	if ( (strAppName == 'Netscape') &&
		(appVer >= 4.0 && appVer < 5) )
	{  // Note: Netscape 6 returns an appVersion of 5 . . . go figure.
		bNetscape = true;
	}

	var strOnClick = getOnClick(strLinkValue, Link.linkWindow);
	var strStyle = getTextStyle(
		strFontColor,
		((bIsCurrentPage && 'true' == Navigation.selectedEffect) ? ('true' == Navigation.selectedBold) : ('true' == Navigation.bold)),
		((bIsCurrentPage && 'true' == Navigation.selectedEffect)  ? ('true' == Navigation.selectedItalic) : ('true' == Navigation.italic)),
		((bIsCurrentPage && 'true' == Navigation.selectedEffect)  ? ('true' == Navigation.selectedUnderline) : ('true' == Navigation.underline)),
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

	//
	//	Open in the current window, but set the location to the parent
	//	in case page is displayed in a frame, like for password protected pages.
	
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

	//
	//	Set id for integration with the online editor.  "[NavName]_Link[linkIndex]"
	//	NOTE: these IDs are NOT unique.  At load time, the online editor will walk the rendered HTML
	//	and prepend the unique element id.  Outside of the online editor, these IDs are NOT unique.
	
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

	// Begin anchor for text, only for Netscape (IE uses onClick handler)
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

	// Bold, Italic (Netscape 4 only; otherwise style is defined in TD for mouseover effects)
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

	// AFTER LINK TEXT
	if(Navigation.orientation=='vertical')
	{
		if(Navigation.accentType=='lines' || (bBackgroundOrBorder && Navigation.accentType!='both' ))
		{
			strHTML += '<IMG SRC="' + strTpGif + '" WIDTH="' + nGeneralPadding + '" HEIGHT="1" BORDER="0">';
		}
		// spacing between links
		if (nVertPaddingBottom > 0)
		{
			strHTML += '<BR><IMG SRC="' + strTpGif + '" WIDTH="1" HEIGHT="' + nVertPaddingBottom + '" BORDER="0">';
		}
	}
	else
	{
		if(Navigation.accentType=='both')
		{
			strHTML += '<IMG SRC="' + strTpGif + '"  WIDTH="' + nAccentGraphicPadding + '" HEIGHT="' + nAccentHeight + '" BORDER="0">';
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

	// End anchor </A>
	if(bNetscape)
	{
		strHTML += '</A>';
	}

	// Close cell
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

			// Place general background/border padding after accent graphic
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

		// For vertical, close row
		strHTML += '</TR>';
		//
		//	If lines are specified, to make the line - create a table cell of the correct height, fill with a tp gif
		//      and set the background color of the cell to the specified line color
		
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
		// Horizontal
		if(Navigation.accentType == 'lines')
		{
			if(!bLastLink && ((Link.linkIndex % Navigation.horizontalWrap) != 0))
			{
				strHTML += '<TD WIDTH="' +  Navigation.lineWidth +'" BGCOLOR="' + Navigation.lineColor +  '">';
				strHTML += '<IMG SRC="' + strTpGif + '" WIDTH="' + Navigation.lineWidth + '"></TD>';
			}
		}

		// Close table for this row after horizontalWrap number of links or last link
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

//
// This .js file includes utility functions used by both graphical and text navs
// in their rendering.  User pages including a nav element will import this file, along
// with TextNavigation.js and GraphicNavigation.js.  The functions within will
// be called by the [navname].js file generated at publish time.

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
		(appVer >= 4.0 && appVer < 5) ) {  document.write('</DIV>');
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

