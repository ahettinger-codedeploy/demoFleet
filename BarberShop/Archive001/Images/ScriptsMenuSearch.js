function MenuBarGo() {

    // get the current search option
    if (!document.getElementById("select1")) {
        return false;
    }
    
    var theOption = document.getElementById("select1");
    var theOptionSelected = theOption.options[theOption.selectedIndex].text.toLowerCase();

    return GotoTarget(theOptionSelected);
}

function SearchChanged(field)
{
    var theOptionSelected = field.options[field.selectedIndex].text.toLowerCase();
    return GotoTarget(theOptionSelected);
}

function GotoTarget(theOptionSelected) {

    if (theOptionSelected.indexOf("google") != -1) {
        window.location = "google.aspx";
    }
    
    if (theOptionSelected.indexOf("chapter") != -1) {
        window.open("http://ebiz.barbershop.org/ebusiness/Public/ChapterProximitySearch2.aspx", "chapWin");
    }

    if (theOptionSelected.indexOf("quartet") != -1) {
        window.open("http://ebiz.barbershop.org/ebusiness/Public/SearchQuartets.aspx", "quartetWin");
    }
    
    return true;
}