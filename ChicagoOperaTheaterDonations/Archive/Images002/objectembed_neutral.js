function ObjectLoad()
{
    if ( objectDestination )
    {
        var bodyElement = objectDestination.parentElement;
        
        if ( bodyElement.objectSource )
        {
            bodyElement.innerHTML = "<embed width=100% height=100% fullscreen=yes>";
            bodyElement.firstChild.src = bodyElement.objectSource;
        }
    }
}
