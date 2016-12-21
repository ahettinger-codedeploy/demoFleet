//highlight rows in a grid view
function setRowColorOn(oRow, clickable)
{
    Dea.Css.addClass(oRow, "highlightColor");  
    if(clickable == true) 
        oRow.style.cursor = "hand"; 
}
//removes the highlight of rows in grid view
function setRowColorOff(oRow) {
    Dea.Css.removeClass(oRow, "highlightColor");  
}

function selectRow(oRowToSelect, sd)
{
    if(!oRowToSelect.parentNode) 
        return; 
    
    clearAllRows(oRowToSelect.parentNode.childNodes);
    Dea.Css.addClass(oRowToSelect, "selectedColor");  
    sData = sd;
}   

//clears background color on rows of gridview
function clearAllRows(oRows)
{
     for(i = 0; i < oRows.length; i++)
     {
        Dea.Css.removeClass(oRows[i], "selectedColor");  
     }
}

function selectRowForMultiple(oRowToSelect, sd, sCheckBoxId, e) {
    var t = e.target || e.srcElement;
    if (t.tagName !== "INPUT") {
        if ($("#" + sCheckBoxId).is(":checked")) {
            $("#" + sCheckBoxId).attr("checked", "");
        }
        else {
            $("#" + sCheckBoxId).attr("checked", "checked");
        }
    }
}     

//Called if we need to select a row in gridview at start up
function selectRowById(sId)
{
    oRowToSelect = getObj(sId);      
    oLastRow = oRowToSelect;
    Dea.Css.addClass(oRowToSelect, "selectedColor");
}   

   
