/*globals BLACKBAUD */
// v5.6 printing...
//isListView is just a special case flag b/c that one likes to render differently.
BLACKBAUD.netcommunity.PrintDiv = function (printDivID, isListView, PRINT_TITLE, PRINT_DATE) {

    var sWinHTML, disableLinks, disableToolTips, sOption, regExp, winprint;

    sWinHTML = document.getElementById(printDivID).innerHTML;

    //Defining key functions that are needed in this print page window.
    //These are just strings.  The \ at the end lets it run over the line.
    //233825 - keep styling on links
    disableLinks = "function DisableLinks() {var x = window.document.getElementsByTagName('a');for (i = 0; i < x.length; i++) {x[i].removeAttribute('href');}}";

    disableToolTips = "function DisableToolTips(elementType) {var x = window.document.getElementsByTagName(elementType);for (i = 0; i < x.length; i++) {x[i].setAttribute('onmouseover', '');x[i].setAttribute('onmouseout', '');x[i].onmouseover = '';}}";

    sOption = "toolbar=yes,location=no,directories=yes,menubar=yes,status=no,";
    sOption += "scrollbars=yes,resizable=yes,width=750,height=600,left=100,top=25";

    //CR296918-040108
    function properlyFormat(match) {
        return match.toLowerCase();
    }

    //Let's make this properly formatted for XHTML
    //Finds all <TAGNAME and all /TAGNAME>
    //An additional check back be done for <TAGNAME> just add |<[A-Z]+>, but we assume only <BR> is like that
    //BR needs its own custom formatting
    regExp = new RegExp('<[A-Z]+\\s|/[A-Z]+>', 'g');
    sWinHTML = sWinHTML.replace(regExp, function (match) {
        return properlyFormat(match);
    });
    sWinHTML = sWinHTML.replace(/<BR>/g, "<br />");

    winprint = window.open("", "", sOption);
    winprint.document.open();
    winprint.document.write('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">');
    winprint.document.write('<html><head><title>Print Calendar</title>');


    // Load CSS Classes    
    $('link[rel="stylesheet"]').each(function (i, t) {
        var URL = $(t).attr('href');
        if (URL && URL.length > 0) {
            winprint.document.write('<LINK href="' + URL + '" rel="stylesheet">');
        }
    });

    winprint.document.write('</head>');

    //Open Body and display Title
    winprint.document.write('<body style="background-color:white;margin:5px;" onload="DisableLinks();DisableToolTips(\'span\');DisableToolTips(\'div\');">');
    winprint.document.write('<table width="100%"');
    if (isListView) {
        winprint.document.write('style="border-bottom: 1px solid black;">');
    }

    winprint.document.write('<tr>');

    if ((typeof (PRINT_DATE) === "undefined") || (PRINT_DATE.length === 0)) {
        winprint.document.write('<td style="width: 100%; font-weight: bold;">' + PRINT_TITLE + '</td>');
    }
    else {
        winprint.document.write('<td style="width: 60%; font-weight: bold;">' + PRINT_TITLE + '</td>');
        winprint.document.write('<td style="width: 40%; font-weight: bold; text-align: right;">' + PRINT_DATE + '</td>');
    }

    winprint.document.write('</tr></table>');
    if (isListView) {
        winprint.document.write('<br />');
    }


    //Inject javascript to disable certain page features.
    winprint.document.write('<script type="text/javascript">');
    winprint.document.write(disableLinks);
    winprint.document.write(disableToolTips);
    winprint.document.write('</script>');


    //Print the content
    winprint.document.write(sWinHTML);


    winprint.document.write('</body></html>');
    winprint.document.close();
    winprint.focus();
    //winprint.print();     uncomment to call the browser print dialog
};