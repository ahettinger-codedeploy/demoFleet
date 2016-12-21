var xhr;

function checkSessionCore(UniqueID) {
    LastClickedUniqueID = UniqueID;
    try {
        xhr = new ActiveXObject("Microsoft.XMLHTTP");    // Trying Internet Explorer 
    }
    catch (e)    // Failed 
        {
        xhr = new XMLHttpRequest();    // Other browsers.
    }

    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4) {
            if (xhr.status == 200) {
                var resText = xhr.responseText.split(",");
                if (parseInt(resText[0]) > 0) {
                    __doPostBack(LastClickedUniqueID, '');
                }
                else {
                    if (parseInt(resText[0]) == 0) {

                        showReconWin();

                        try { hideLoadingPanel(); } catch (e) { alert(e); }
                        return false;
                    } else {
                        alert(resText[1]);
                        try { hideLoadingPanel(); } catch (e) { alert(e); }
                        return false;
                    }
                }
            }
            else {
                //document.ajax.dyn="Error code " + xhr.status;
                if (xhr.status != 0) {
                    alert(ValidatorErrorPrefix + xhr.status);
                    try { hideLoadingPanel(); } catch (e) { }
                    return false;
                }
            }
        }
    };

    var ie = (document.all) ? 1 : 0;
    if (ie) {
        xhr.open('Post', pref + validatorXMLurl, true);
    } else {
        xhr.open('Get', pref + validatorXMLurl, true);
    }
    xhr.send(null);
}


function checkSession(UniqueID) {

    try { showLoadingPanel(); } catch (e) { }
    checkSessionCore(UniqueID);
}

var panelTimeout = null;
function finishReconnect(sender, args) {
   
     if (sender.argument != null) {
        var res = sender.argument;
        sender.argument = null;
        __doPostBack(LastClickedUniqueID, '');
        panelTimeout = setTimeout(" try { hideLoadingPanel(); } catch (e) { alert(e); }", 250);
    }
   
}