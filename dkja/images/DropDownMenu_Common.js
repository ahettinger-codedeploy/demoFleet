function ISDropDown_ChangeClass(ControlID, className)
{
    ControlToChangeClass = document.getElementById(ControlID);
    ControlToChangeClass.className = className;
}

function ISDropDown_ChangeImage(imageControlID, imagePath)
{
    imageControl = document.getElementById(imageControlID);
    imageControl.src = imagePath;
}

function setControlPositionForUpDirection(ControlID)
{
    control = document.getElementById(ControlID);
    control.style.visibility = 'hidden';
    control.style.display = 'block';
    control.style.top = - control.offsetHeight;
    control.style.visibility = '';
    control.style.display = 'none';
}

function ISDropDown_AdjustSubMenuTableWidth(SubMenuTable) 
{
    var CalculatedWidth = 0;
    var TableBody = SubMenuTable.children[0];
    for (TRIndex = 0; TRIndex <= TableBody.children.length - 1; TRIndex++) 
    {
        var SubMenuCell = TableBody.children[TRIndex].children[0];
        if (SubMenuCell.children.length > 1) 
        {
            var SubMenuCellWidth = 0;
            SubMenuCellWidth = SubMenuCell.offsetWidth + SubMenuCell.children[1].offsetWidth + 5;
            if (SubMenuCellWidth > CalculatedWidth) { CalculatedWidth = SubMenuCellWidth }
        }
    }

    return CalculatedWidth;
}

function DropDown_OnMenuClick(event, MenuCell, newlocation, openInNewWindow)
{
    event.cancelBubble = true;
    if (event.stopPropagation) event.stopPropagation();
    if (openInNewWindow)
    {
        window.open(newlocation, 'ISTopMenu');
    }
    else
    {
        window.location = newlocation;
    }
}