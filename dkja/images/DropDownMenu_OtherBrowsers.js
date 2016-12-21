function ShowSubMenu(event, ParentCellID, SubMenuID, SubMenuMode, OpenDirection, adjustPosition)
{
    parentcell = document.getElementById(ParentCellID);
    submenu = document.getElementById(SubMenuID);

    if ((parentcell != event.relatedTarget) && (submenu != event.relatedTarget))
    {
        submenu.style.visibility = 'hidden';
        submenu.style.display = 'block';

        var submenutable = submenu.children[0];
        if (submenutable.style.width == '') {
            var CalculatedWidth = ISDropDown_AdjustSubMenuTableWidth(submenutable);
            if (CalculatedWidth != 0) { submenutable.style.width = CalculatedWidth }
        }

        if (SubMenuMode == 'OneForAll') {
            submenutable.style.marginLeft = parentcell.offsetLeft + 'px';
        }


        if ( adjustPosition && (submenu.style.left == '') )
        {   
            var ParentComputedStyle = getComputedStyle(parentcell);
            var submenupositionX = submenu.offsetLeft + parentcell.offsetWidth - parseInt(ParentComputedStyle.getPropertyValue("padding-left").replace('px', ''));
            if (parentcell.style.left != '') { submenupositionX += parseInt(parentcell.style.left) }
            submenu.style.left = submenupositionX + 'px';
            if (OpenDirection == 'up') { submenu.style.top = submenu.parentNode.parentNode.offsetTop - submenu.offsetHeight + parentcell.offsetHeight }
        }
        else if (!adjustPosition && (OpenDirection == 'up') && (submenu.style.top == '')) 
        {
            submenu.style.top = (-submenu.offsetHeight) + 'px';
        }

        
        submenu.style.visibility = '';
        return true;
    }
    return false;
}

function HideSubMenu(event, ParentCellID, SubMenuID) 
{
    parentcell = document.getElementById(ParentCellID);
    submenu = document.getElementById(SubMenuID);
    relatedElement = event.relatedTarget;
    if ( (relatedElement != parentcell) && (relatedElement != submenu) )
    {
        while (relatedElement)
        {
            if ((relatedElement == parentcell) || (relatedElement == submenu)) break;
            relatedElement = relatedElement.parentNode;
        }
    }
    if ( (relatedElement != parentcell) && (relatedElement != submenu) )
    {
        submenu.style.display = 'none';
        return true;
    }
    return false;
}