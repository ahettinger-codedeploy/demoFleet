$(document).ready(function () {
    //The Presentation role needs to be added to the search web part for accessibility
    $('.ms-sbtable').attr('role', 'presentation');
    $('.s4-wpTopTable').attr('role', 'presentation');
    var inDesignMode = document.forms[MSOWebPartPageFormName].MSOLayout_InDesignMode.value;

    if (inDesignMode == "1") {
        if (RTE) {
            RTE.RichTextEditor.paste = function () { RTE.Cursor.paste(true); }
            RTE.Cursor.$3C_0 = true;
        }
    }
    
});