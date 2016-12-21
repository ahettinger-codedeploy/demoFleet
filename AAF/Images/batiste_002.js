// Auteur : bieler batiste
// Blog : www.magnin-sante.ch/journal
// send me a mail :
//      faden@PASDEPOURRIELaltern.org - remove ( PASDEPOURRIEL )
//      or send me a mail with this form
//      http://www.magnin-sante.ch/journal/?p=mailto.php&amp;m=gbefoAbmufso/psh

function initMenu()
{
    if ( browser.isDOM1 
    && !( browser.isMac && browser.isIE ) 
    && !( browser.Opera && browser.versionMajor < 7 )
    && !( browser.isIE && browser.versionMajor < 5 ) )
    {
        // get some element
        var menu = document.getElementById('Menu');
        var lis = menu.getElementsByTagName('li');
        
        // change the style of the menu
        menu.className="menu";
        
        // i am searching for ul element in li element
        for ( var i=0; i<lis.length; i++ )
        {            
            // is there a ul element ?
            if ( lis.item(i).getElementsByTagName('ul')[0] )
            {
                // improve keyboard navigation with IE
                if ( browser.isIE )
                {
                    addAnEvent(lis.item(i),'keyup',visible);
                }
                
                // apply the method to DOM compliant browsers
                addAnEvent(lis.item(i),'mouseover',visible);
                addAnEvent(lis.item(i),'mouseout',hidden);
                addAnEvent(lis.item(i),'blur',hidden);
                addAnEvent(lis.item(i),'focus',visible);
            }
        }
    }
}

function addAnEvent( target, eventName, functionName )
{
    // apply the method to IE
    if ( browser.isIE )
    {
        //target.attachEvent( 'on'+eventName, functionName ); // dont work properly with this
        eval('target.on'+eventName+'=functionName');
    }
    // apply the method to DOM compliant browsers
    else
    {
        target.addEventListener( eventName , functionName , true ); // true is important for Opera7
    }
}
    
/* hide the first ul element of the current element */
function hidden()
{
    /* setAttribute dont work correctly with IE */
    this.getElementsByTagName('a')[0].className = "";
    this.getElementsByTagName('ul')[0].style.visibility = "hidden";
}

/* show the first ul element of the current element */
function visible()
{
    this.getElementsByTagName('a')[0].className = "Hover";
    this.getElementsByTagName('ul')[0].style.visibility = "visible";
}
    
/* used to improve keyboard navigation with IE */
function hiddenUl( ul )
{
    if ( browser.isIE )
    {
        var uls = ul.getElementsByTagName('ul');
        for ( var i=0; i<uls.length; i++ )
        {
            uls.item(i).style.visibility = "hidden";
        }
        ul.style.visibility = "hidden";
    }
} 
    
// not very clean but simple
// the function can be run in the HTML for faster display
window.onload=initMenu;

    