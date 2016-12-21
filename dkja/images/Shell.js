if (document.all && !document.getElementById) {
    document.getElementById = function (id) {
        return document.all[id];
    }
}



var WinSender;
var ForceClose = false;

var firefoxCounterObj;
var TotalProgress;
var url;
var xmlhttpShell;
var locked = false;
var timer;
var ie = (document.all) ? 1 : 0;
var p = (ie) ? "filter" : "MozOpacity";

var sURL = unescape(window.location.pathname);
var WinToRefreshAfterSave = null;

var loadingPanel = "";
var postBackElement = "";

var pageRequestManager = null;
try {
    pageRequestManager = Sys.WebForms.PageRequestManager.getInstance();
    pageRequestManager.add_initializeRequest(initializeRequest);
    pageRequestManager.add_endRequest(endRequest);
} catch (ex) { }



function __doRealPostBack(eventTarget, eventArgument) {
    if (!theForm.onsubmit || (theForm.onsubmit() != false)) {

        var hidRealAct = document.getElementById('HidRealAction');
        if (hidRealAct) {
            theForm.action = hidRealAct.value;
        }
        theForm.__EVENTTARGET.value = eventTarget;
        theForm.__EVENTARGUMENT.value = eventArgument;
        theForm.submit();
    }
}


function showChatWin(button, args) {
    button.set_autoPostBack(false);
    var arg = button.get_commandArgument();
    var windowW = window.innerWidth;
    var windowH = window.innerHeight;

    var url = pref + 'UserControls/BaseControls/ChatRoom/ChatPage.aspx?token=' + arg;
    var mngr = $find("TS_RadWindowManager1");
    var oPubWnd = mngr.getWindowByName("chatWin");
    if (windowW < 500 && windowH < 800) {
        url = url + '&mobile=1';
        window.open(url);
    } else {
        oPubWnd.SetUrl(url);
        oPubWnd.show();
    }
}
function showChatWinMobileApp(button, args) {
    button.set_autoPostBack(false);
    var arg = button.get_commandArgument();
    var windowW = window.innerWidth;
    var windowH = window.innerHeight;

    var url = pref + 'UserControls/BaseControls/ChatRoom/ChatPage.aspx?token=' + arg;
    url = url + '&mobile=1';
    window.location = url;
}
// to override important width css of text.table
function resizeSignUpsContainers() {
    var SUP_Conts = $(".SignUpEventContainer")
    var winW = window.innerWidth;
    for (i = 0; i < SUP_Conts.length; i++) {
        var mc = SUP_Conts.get(i);
        mc.setAttribute('style', 'width:100%');
        if ((winW - 25) < mc.offsetWidth) {
            mc.setAttribute('style', 'width:' + (winW - 25) + 'px !important');
        }
    }
    var signUpMainCont = SUP_Conts.get(0);
    var signUpConts = $(".SignUpEventTable");
    for (i = 0; i < signUpConts.length; i++) {
        signUpConts.get(i).setAttribute('style', 'width:' + signUpMainCont.offsetWidth + 'px !important');
    }
}

function updateProductPriceLabel(id, price) {
    var ProductPrice = document.getElementById(id);
    if (ProductPrice) {
        ProductPrice.innerHTML = price;
    }
}

// handler for telerik albums to fix images display if orientation does not match album
function handleAlbumImgNavigated(sender, args) {
    var item = args.get_item();
    var title = item.get_title();
    var w = parseInt(sender.get_imageArea()._imagesWrapper.childNodes[2].style.width.replace('px', ''));
    var h = parseInt(sender.get_imageArea()._imagesWrapper.childNodes[2].style.height.replace('px', ''));

    var AlbH = document.getElementById(sender._clientId).offsetHeight;
    var AlbW = document.getElementById(sender._clientId).offsetWidth;
    if (AlbH == AlbW) {
        return;
    }
    var isWideAlbum = AlbH < AlbW;
    var isWideImage = h < w;
    if (isWideAlbum && !isWideImage) {
        sender.get_imageArea()._imagesWrapper.childNodes[2].style.width = '';
    } else if (!isWideAlbum && isWideImage) {
        sender.get_imageArea()._imagesWrapper.childNodes[2].style.height = '';
    }
}


function ItemClicked(folderUrl) {
    window.location = folderUrl;
}

function gotoHttpsPage(testUrl, TargetURL, isNewWindow) {
    $.ajax({
        url: testUrl,
        dataType: "text",
        error: function (xhr, status, errorThrown) {
            alert("This browser does not support TLS encryption.\nPlease upgrade your browser to a newer version to view this secure content\n\nSupported Browser Versions:\n" + 
                  "- Google Chrome v30 and higher\n- Android Browser v5.0-5.1 and higher\n- Mozilla Firefox v27 and higher\n- Internet Explorer v11 and higher\n" + 
                  "- Internet Explorer mobile v11 and higher\n- Opera v17 and higher\n- Safari v7 and higher\n- Safari mobile v5 and higher");
        },
        success: function (data) {
            if (isNewWindow) {
                window.open(TargetURL, 'ISnavigate');
            } else {
                window.location = TargetURL;
            }
        },
        type: 'GET'
    });
}


/* Handler to fix vertical images on album slideshows */
function HandleGalleryImageLoaded(sender, args) {

    var item = args.get_item();
    var img = getNextImg(sender._imageArea._$image[0]);
    if (img == null) { return null; }
    if (parseInt(img.style.paddingLeft.replace("px", "")) == 0) {
        //do nothing wide image
    } else {
        //sender._imageArea._$image[0].style.setProperty("height", sender._element.offsetHeight + "px", "important");
        var pLeft = img.style.paddingLeft;
        img.style.cssText = "height: " + sender._element.offsetHeight + "px !important; padding-left: " + pLeft + "; padding-top: 0px; opacity: 1;";
    }
}

function getNextImg(e) {
    var ns = e.nextSibling;
    while (ns) {
        if (ns.tagName == 'IMG') {
            return ns;
        } else {
            ns = ns.nextSibling;
        }
    }
}
/*---------------------------------------*/

/* sign up stuff   */
function toggleSupCb(div,cbId){
    var cb = document.getElementById(cbId);
    if (cb.checked) {
        // change to not checked display
        div.className = 'signUpButton';
    } else {
        // change to checked display
        div.className = 'signUpButtonChecked';
    }
    cb.checked = !cb.checked;

    var pos = cbId.indexOf('_Sup');
    var leadID = cbId.substring(0, pos).replace(/_/g, '$');
    leadID = leadID + '$lbSubmit';
    WebForm_DoPostBackWithOptions(new WebForm_PostBackOptions(leadID, '', true, '', '', false, true));

}


function toggleSupCbAsRadio(div, cbId,groupName) {
    var cb = document.getElementById(cbId);
    if (cb.checked) {
        // change to not checked display
        div.className = 'signUpButton';
    } else {
        turnOffAllSupCbsByGroup(groupName);

        // change to checked display
        div.className = 'signUpButtonChecked';
    }
    cb.checked = !cb.checked;
    var pos = cbId.indexOf('_Sup');

    var leadID = cbId.substring(0, pos).replace(/_/g, '$');
    leadID = leadID + '$lbSubmit';
    WebForm_DoPostBackWithOptions(new WebForm_PostBackOptions(leadID, '', true, '', '', false, true));
}

function turnOffAllSupCbsByGroup(groupName) {
    var divs = document.getElementsByName(groupName);
    if (divs) {
        if (divs.length) {
            for (var i = 0; i < divs.length; i++) {
                turnOffSingleSupCbByGroupName(divs[i]);
            }
        } else {
            turnOffSingleSupCbByGroupName(divs);
        }
    }
}

function turnOffSingleSupCbByGroupName(div) {
    var cb = null;
    for (var i = 0; i < div.childNodes.length; i++) {
        var c1 = div.childNodes[i];
        if (c1.tagName && c1.tagName.toUpperCase() == 'DIV') {
            for (var j = 0; j < c1.childNodes.length; j++) {
                var c2 = c1.childNodes[j];
                if (c2.tagName && c2.tagName.toUpperCase() == 'INPUT') {
                    cb = c2;
                    break;
                }
            }
            break;
        }
    }

    if (cb) {
        cb.checked = false;
        div.className = 'signUpButton';
    }
}

function showLoginRegPopup(div, popupCid) {
    var popup = document.getElementById(popupCid);

    var hidID = div.id.substr(0, div.id.indexOf('Sup_') + 4) + 'regForm_LoginRegisteredForSlot';

    var hid = document.getElementById(hidID);
    hid.value = div.getAttribute("sl");
    if (popup) {
        popup.style.visibility = 'hidden';
        popup.style.display = '';

        offsets = div.getBoundingClientRect();

        var top = div.getBoundingClientRect().top + window.pageYOffset - div.ownerDocument.documentElement.clientTop;
        var left = div.getBoundingClientRect().left + window.pageXOffset - div.ownerDocument.documentElement.clientLeft;
        left = left - parseInt((popup.offsetWidth - div.offsetWidth) );
        popup.style.top = top + 'px';
        popup.style.left = left + 'px';
        popup.style.visibility = 'visible';
    }
}

/* end sign up stuff    */
    function toggleComments(comID) {
        var anc = document.getElementById(comID + '_anc');
        var com = document.getElementById(comID + '_Comments');
        var pager = document.getElementById(comID + '_pager');
        var hid = document.getElementById(comID + '_Expanded');

        if (anc.textContent.indexOf('Show') > 0) {
            anc.textContent = anc.textContent.replace('[+] Show', '[-] Hide');
            com.className = "PostCommentsContainer";
            if (pager) {
                pager.className = "CommentsPagerButtons";
            }
            if (hid) {
         
                hid.value = '1';
            }
            ScrollDivToBottom(comID + '_Comments');
        } else {
            anc.textContent = anc.textContent.replace('[-] Hide', '[+] Show');
            com.className = "PostCommentsContainerHid";
            if (pager) {
                pager.className = "CommentsPagerButtonsHid";
            }
            if (hid) {
           
                hid.value = '0';
            }
        }
    }

    // To handle the S3 uploaders failed event
    function OnClientUploadFailed(sender, args) {
        var error = args.get_message();
        console.log(error);
        alert(error);
    }

    function showNewPost(button, args) {
        button.set_autoPostBack(false);
        var uid = button.get_uniqueID();
        uid = uid.replace('btAddPost', 'NewPostDiv');
        while (uid.indexOf('$') > 0) {
            uid = uid.replace('$', '_');
        }
        var cont = document.getElementById(uid);
        if (cont) {
            cont.className = "NewPostDiv";
        }
        button.set_enabled(false);
    }


    function hideNewPost(button, args) {
        button.set_autoPostBack(false);
        var uid = button.get_uniqueID();
        uid = uid.replace('btCancel', 'NewPostDiv');
        while (uid.indexOf('$') > 0) {
            uid = uid.replace('$', '_');
        }
        var cont = document.getElementById(uid);
        if (cont) {
            cont.className = "NewPostDivHid";
        }

        uid = uid.replace('NewPostDiv', 'btAddPost')
        var addBt = $find(uid);
        addBt.set_enabled(true);
    }

    function ScrollDivToBottom(divID) {
        var div = document.getElementById(divID);
        if (div) {
            div.scrollTop = div.scrollHeight;
        }
    }
    function DoRadButtonRealPostBack(button, args) {
        button.set_autoPostBack(false);
        __doRealPostBack(button.get_uniqueID(), '');
    }


    function showAlbumZoomPopup(imgObj) {
        var imgUrl = pref + 'userControls/shellControls/showImageZoom.aspx?url=' + imgObj.ImageLink;
        var mngr = $find("TS_RadWindowManager1");

        var ratio = 0;

        var windowHeight = parseInt(window.innerHeight * 0.85);
        if (imgObj) {
            if (imgObj.Height && imgObj.Height > 0) {
                ratio = windowHeight / imgObj.Height;
            } else if (imgObj.ImageRealHeight && imgObj.ImageRealHeight > 0) {
                ratio = windowHeight / imgObj.ImageRealHeight;
            }
        }
        if (ratio > 0) {
            var windowWidth = parseInt(window.innerWidth * 0.85);

            if (imgObj.Width && imgObj.Width > 0) {
                var wRatio = windowWidth / imgObj.Width;
                if (wRatio < ratio) { ratio = wRatio; }
                windowWidth = parseInt(imgObj.Width * ratio);
            } else if (imgObj.ImageRealWidth && imgObj.ImageRealWidth > 0) {
                var wRatio = windowWidth / imgObj.ImageRealWidth;
                if (wRatio < ratio) { ratio = wRatio; }
                windowWidth = parseInt(imgObj.ImageRealWidth * ratio);
            }

            if (windowWidth > 0) {
                var oZoomWin = mngr.getWindowByName("AlbumZoomWin");
                imgUrl = imgUrl + '&width=' + windowWidth + '&height=' + windowHeight;
                oZoomWin.SetUrl(imgUrl);
                oZoomWin.set_height(windowHeight);
                oZoomWin.set_width(windowWidth);
                oZoomWin.show();
            }
        }
    }


    function initializeRequest(sender, eventArgs) {
        document.documentElement.style.overflow = 'hidden';

        loadingPanel = $find('GuideLoading')
        postBackElement = eventArgs.get_postBackElement().id;

        if (!loadingPanel) { return; }

        loadingPanel.show(postBackElement);

        var LoadingPanelElement = loadingPanel.get_element();
        LoadingPanelElement.style.position = 'absolute';
        LoadingPanelElement.style.width = window.innerWidth + 'px';
        LoadingPanelElement.style.height = window.innerHeight + 'px';
        LoadingPanelElement.style.top = '0px';
        if (document.body.scrollTop > 0) {
            LoadingPanelElement.style.top = document.body.scrollTop + 'px';
        }
        else if (document.documentElement.scrollTop > 0) {
            LoadingPanelElement.style.top = document.documentElement.scrollTop + 'px';
        }
    }

    function endRequest(sender, eventArgs) {
        document.documentElement.style.overflow = 'auto';

        loadingPanel = $find('GuideLoading')
        if (!loadingPanel) { return; }
        loadingPanel.hide(postBackElement);
    }
 


    function showLoadingPanel() {
        LoadingPanelRequestStart();
        $get("GuideLoading").style.display = 'block';
    }

    function showNewItems() {
        var dv = document.getElementById('PopUp');
        dv.style.visibility = 'visible';
        setInterval('hideNewItems();', 4000);
    }

    function hideNewItems() {
        var dv = document.getElementById('PopUp');
        dv.style.visibility = 'hidden';
    }
	


    function OpenMailTo(address, subject) {




        var windowHeight = parseInt(window.innerHeight * 0.85);
        var windowWidth = parseInt(window.innerWidth * 0.85);
        if (windowHeight > 530) { windowHeight = 530; }
        if (windowWidth > 630) { windowWidth = 630; }


        var url = pref + "UserControls/BaseControls/Guide/MailTo.aspx?address=" + address + '&subject=' + subject;

        if (windowWidth < 400) {
            url = url + '&minimal=1';
        }


        var mngr = $find("TS_RadWindowManager1");
        oPubWnd = mngr.getWindowByName("MailTo");
        oPubWnd.set_height(windowHeight);
        oPubWnd.set_width(windowWidth);
        oPubWnd.SetUrl(url);
        oPubWnd.show();

    }


    function getHidVal(HidID) {
        var HD = document.getElementById(HidID);
        if (HD) {
            return HD.value;
        }
    }


    function urldecode(str) {
        return decodeURIComponent((str + '').replace(/\+/g, '%20'));
    }


    function LoadingPanelRequestStart(sender, args) {
        if (document.documentElement.scrollHeight > document.documentElement.clientHeight) {

            var loadingPanel = $get("GuideLoading");
            var pageHeight = document.documentElement.scrollHeight;
            var viewportHeight = document.documentElement.clientHeight;
            var scrollTopOffset = document.documentElement.scrollTop;
            var loadingImageHeight = 50;

            loadingPanel.style.backgroundPosition = "center " + (parseInt(scrollTopOffset) + parseInt(viewportHeight / 2) - parseInt(loadingImageHeight / 2)) + "px";
            loadingPanel.style.backgroundAttachment = 'fixed';

            loadingPanel.style.height = pageHeight + "px"; //if pageheight is lower than 4000 do everything normally. 
        }
    }

    function alertLocal(str) {
        if (window.location.href.indexOf("localhost") > -1) {
            alert(str);
        }
    }

    function checkSentMail(sender, eventArgs) {
        if (eventArgs._argument == 1) {
            alert('The message was sent successfully.');
        }
    }

    function whichBrs() {
        var agt = navigator.userAgent.toLowerCase();
        if (agt.indexOf("opera") != -1) return 'Opera';
        if (agt.indexOf("staroffice") != -1) return 'Star Office';
        if (agt.indexOf("webtv") != -1) return 'WebTV';
        if (agt.indexOf("beonex") != -1) return 'Beonex';
        if (agt.indexOf("chimera") != -1) return 'Chimera';
        if (agt.indexOf("netpositive") != -1) return 'NetPositive';
        if (agt.indexOf("phoenix") != -1) return 'Phoenix';
        if (agt.indexOf("firefox") != -1) return 'Firefox';
        if (agt.indexOf("safari") != -1) return 'Safari';
        if (agt.indexOf("skipstone") != -1) return 'SkipStone';
        if (agt.indexOf("msie") != -1) return 'Internet Explorer';
        if (agt.indexOf("netscape") != -1) return 'Netscape';
        if (agt.indexOf("mozilla/5.0") != -1) return 'Mozilla';
        if (agt.indexOf('\/') != -1) {
            if (agt.substr(0, agt.indexOf('\/')) != 'mozilla') {
                return navigator.userAgent.substr(0, agt.indexOf('\/'));
            }
            else return 'Netscape';
        }
        else if (agt.indexOf(' ') != -1)
            return navigator.userAgent.substr(0, agt.indexOf(' '));
        else return navigator.userAgent;
    }

    function all(tagID) {

        if (document.all) {
            return document.all[tagID];
        }
        else {
            return document.getElementsByName(tagID);
        }
    }


    /* Load Journal PopUp */
    function showJournalPop() {
        var Jret_val = window.showModalDialog('/CRM/CRM_NewJournalEntry_Frame.html', '', 'dialogWidth:535px;dialogHeight:375px;');
        return Jret_val != null;
    }
    /* autocomplete with params */

    function splitInfo(tb, hid) {
        var HIDDEN = document.getElementById(hid);
        var temp = tb.value;
        var vals = temp.split('~');
        if ((vals.length > 1) && (HIDDEN != null)) {
            tb.value = Trim(vals[0]);
            HIDDEN.value = Trim(vals[1]);
        }
    }

    function op(n, v) {
        if (v == 100) {
            n.style[p] = '';
        } else {
            v = (ie) ? "alpha(opacity=" + v + ")" : v / 100;
            n.style[p] = v;
        }

    }

    function toggleMini(id) {

        var miniCont = document.getElementById('miniProgress_' + id);
        var arrow = document.getElementById('arrow_' + id);

        if (miniCont.style.display == 'none') {
            miniCont.style.display = 'block';
            arrow.src = pref + 'Shared/Controls/ImageUpload/Images/downMiniArrow.png';
        } else {
            miniCont.style.display = 'none';
            arrow.src = arrow.src = pref + 'Shared/Controls/ImageUpload/Images/upMiniArrow.png';
        }



    }

    function trimAnchor(URL) {
        var ind = URL.indexOf('#');
        if (ind == -1) { return URL; }
        return URL.substring(0, ind);
    }
    /*----------------------------------------------------------*/
    function CollapseAllDivs(subdivID) {
        var divsInput = document.getElementById('subFolderDivs');
        if (divsInput != null) {
            var arr = divsInput.value.split(',');
            for (i = 0; i < arr.length; i++) {
                var tempDiv = document.getElementById('subdiv' + arr[i]);
                if (tempDiv != null) { if ('subdiv' + arr[i] != subdivID) { tempDiv.style.display = 'none'; } }
            }
        }

    }
    function ExpandSibs(subdivID, targetUrl) {
        CollapseAllDivs('subdiv' + subdivID);
        var subdiv = document.getElementById('subdiv' + subdivID);
        if (subdiv != null) {
            if (subdiv.style.display == 'none') {
                subdiv.style.display = '';
            } else {

                window.location = targetUrl;
            }
        } else {
            window.location = targetUrl;
        }

    }
    /*----------------------------------------------------------*/

    function showHidePanes(show, hide) {
        document.getElementById(show).style.display = "block";
        var hideArr = hide.split(',');
        for (i = 0; i < hideArr.length; i++) {
            document.getElementById(hideArr[i]).style.display = "none";
        }
    }

    function openInfoWindow(infoPage) {
        // openInfoWindow opens the passed html page parameter in a remote window. 
        // You can create more remote windows by naming the new window object a 
        // different name. 

        //var newwind = window.showHelp(infoPage);      
        var newWind = window.open(infoPage, 'info', 'width=450,height=455,scrollbars=yes,toolbar=no,resizable=1');

        if (newWind.opener == null) {
            newWind.opener = window;
        }
        else {
            newWind.focus();
        }
    }


    function openSizedInfoWindow(infoPage, width, height) {
        // openInfoWindow opens the passed html page parameter in a remote window. 
        // You can create more remote windows by naming the new window object a 
        // different name. 

        //var newwind = window.showHelp(infoPage);      
        var newWind = window.open(infoPage, 'info', 'width=' + width + ',height=' + height + ',scrollbars=yes,menubar=no,resizable=1');

        if (newWind.opener == null) {
            newWind.opener = window;
        }
        else {
            newWind.focus();
        }
    }

    function openInfoWindowPrint(infoPage) {
        var newWind = window.open(infoPage, 'info', 'width=450,height=455,scrollbars=yes,toolbar=no,resizable=1');

        if (newWind.opener == null) {
            newWind.opener = window;
            //newWind.print();
        }
        else {
            newWind.focus();
            //newWind.print();
        }
        //newWind.document.close()
    }

    /*----------------------------------------------------------*/
    function CAGperm(packID, rowFrom, rowTo, MyControl) {
        if (MyControl == null) { return; }
        var ISchecked = MyControl.src.split('AllUsers')[1] != null;

        if (!ISchecked) {
            MyControl.src = MyControl.src.replace('NoneUsers', 'AllUsers');
            MyControl.alt = 'Check all';
        } else {
            MyControl.src = MyControl.src.replace('AllUsers', 'NoneUsers');
            MyControl.alt = 'Uncheck all';
        }


        var Cbs = document.getElementsByTagName('input');
        for (i = 0; i < Cbs.length; i++) {
            try {
                if ((Cbs[i].type == 'checkbox') && (!Cbs[i].disabled) && (Cbs[i].name.indexOf('MyGridHead') == -1)) {
                    if (Cbs[i].attributes['Pack'] != null) {
                        if (parseInt(Cbs[i].attributes['Pack'].value) == packID) {
                            if (Cbs[i].attributes['RowIndex'] != null) {
                                if ((parseInt(Cbs[i].attributes['RowIndex'].value) >= rowFrom) && (parseInt(Cbs[i].attributes['RowIndex'].value) <= rowTo)) {
                                    Cbs[i].checked = ISchecked;
                                    var CBControlClientID = Cbs[i].id.substring(0, Cbs[i].id.length - 3);
                                    UpdateCB(Cbs[i].id, CBControlClientID + '_CheckStatus');
                                }
                            }
                        }
                    }
                }
            }
            catch (ex) {
                var x = 'asdfasdfas';
            }

        }

    }
    /*----------------------------------------------------------*/

    function CAG(cbName, ONCB, OFFCB) {
        //gg;
        var CB = document.getElementById(ONCB);
        if (CB != null) {
            if (CB.src.split('AllUsers')[1] == null) {
                var CBS = all(cbName);
                CB.src = CB.src.replace('NoneUsers', 'AllUsers');
                CB.alt = 'Check all users';

                if (CBS == null) return false;
                if (CBS.tagName) {
                    CBS.checked = false;
                } else {
                    for (i = 0; i != CBS.length; i = i + 1) {
                        CBS[i].checked = false;
                    }
                }

            } else {

                var CBS = all(cbName);
                CB.src = CB.src.replace('AllUsers', 'NoneUsers');
                CB.alt = 'Uncheck all users';

                if (CBS == null) return false;
                if (CBS.tagName) {
                    CBS.checked = true;
                } else {
                    for (i = 0; i != CBS.length; i = i + 1) {
                        CBS[i].checked = true;
                    }
                }
            }
        }
    }

    /*----------------------------------------------------------*/

    function PasteEditorStuff(str) {
        var editorID = document.getElementById('hidden_editorID');
        var item = document.getElementById(editorID.value);
        var editor = CuteEditor_GetEditor(item);
        var Ox = document.createElement('div');
        Ox.innerHTML = str;
        //editor.InsertElement(Ox) ;
        //CuteEditor_GetEditor(item).ExecCommand('PasteHTML',false,str);
        editor.ExecCommand("PasteHTML", true, str);
    }



    function refreshAndRestart() {
        //  This version of the refresh function will cause a new
        //  entry in the visitor's history.  It is provided for
        //  those browsers that only support JavaScript 1.0.
        //
        window.location.href = sURL;

    }
    function refresh() {
        window.location.reload(true);
        //history.go();
        //__doPostBack('');
    }
    //******************************************* image uploader *************************
    function confirm_ImageDelete(cbName) {
        var counter = 0;
        var CBS = all(cbName);
        if (CBS == null) return false;
        if (CBS.tagName) {
            if (CBS.checked) counter = 1;
        } else {
            for (i = 0; i != CBS.length; i = i + 1) {
                if (CBS[i].checked) counter = counter + 1;
            }
        }
        if (counter == 0) {
            alert("You did not select any Images to remove");
            return false;
        }
        if (confirm("Are you sure you want to remove these " + counter + " Images?") == true)
            return true;
        else
            return false;
    }
    //**************************************************************************************************
    function showSplashTimedOnStart(WaitTime) {
        var Dis = document.getElementById('DisableScreen');
        Dis.style.visibility = 'visible';
        //Dis.style.z-index = '999999';
        var I = document.getElementById('Coverup');
        I.style.visibility = 'visible';
   
        setTimeout('hideSplash();', WaitTime);
    }


    function sS(IsCallBack, WaitTime) {
        /*SplashTimer = setInterval(DoTheSplash(IsCallBack),WaitTime);*/
        if (IsCallBack) {
            SplashTimer = setInterval('DoTheSplash(true);', WaitTime);
        } else {
            SplashTimer = setInterval('DoTheSplash(false);', WaitTime);
        }

        //block screen actions
        var Dis = document.getElementById('DisableScreen');
        if (Dis == null) { return true; }
        Dis.style.visibility = 'visible';
        //Dis.style.z-index = '999999';

        //hide message for 3 secs
        var I = document.getElementById('Coverup');
        I.style.visibility = 'hidden';
        //I.style.z-index = '-1';
   
    }

    function DoTheSplash(IsCallBack) {
        //stop timer
        if (typeof SplashTimer != 'undefined')
        { clearInterval(SplashTimer); }
        var Dis = document.getElementById('DisableScreen');
        if (Dis != null) {
            Dis.style.visibility = 'hidden';
            //Dis.style.z-index = '-1';
        }
        //show message
        var I = document.getElementById('Coverup');
        I.style.visibility = 'visible';
        //I.style.z-index = '999999';
    }


    function hideSplash() {
        var I = document.getElementById('Coverup');
  
        I.style.visibility = 'hidden';
        //I.style.z-index = '-1';
   
        var Dis = document.getElementById('DisableScreen');
        Dis.style.visibility = 'hidden';
        //Dis.style.z-index = '-1';
        try {
            clearInterval(SplashTimer);
        }
        catch (e)
        { }

    }


    ////////////////////////////////////////////// Forms /////////////////////////////////////////////////////////

    function addTagToTB(ddlID, tbID) {
        var DDl = document.getElementById(ddlID);
        var TB = document.getElementById(tbID);
        if ((DDl != null) && (TB != null)) {
            var Op = DDl.options[DDl.selectedIndex];
            // TB.value = TB.value + Op.value;
            TB.value = Op.value;
        }
    }

    function toggleCheckBoxStat(cbID) {
        var arrayCB = cbID.split(',');

        if (cbID.indexOf(',') == -1) {
            var theCB = document.getElementById(cbID);
            if (theCB != null) { theCB.checked = !theCB.checked; }
        } else {
            for (i = 0; i != arrayCB.length; i = i + 1) {
                var theCB = document.getElementById(arrayCB[i]);
                if (theCB != null) { theCB.checked = false; }
            }
        }
    }

    function SetupDivByCB(DivID, CbID) {
        var d = document.getElementById(DivID);
        var cb = document.getElementById(CbID);

        if (cb.checked) {
            d.style.visibility = 'visible';
        } else {
            d.style.visibility = 'hidden';
        }
    }

    function SetupDivByDDL(DivID, DdlID, visibleIndexes) {
        var d = document.getElementById(DivID);
        var ddl = document.getElementById(DdlID);

        var delimit = visibleIndexes.split(',');
        for (i = 0; i != delimit.length; i = i + 1) {
            if (parseInt(delimit[i]) == ddl.selectedIndex) {
                d.style.visibility = 'visible';
                return;
            }
        }

        d.style.visibility = 'hidden';
    }

    function UpdateDDLselection(text, value, textID, hiddenID) {
        var TheText = document.getElementById(textID);
        TheText.innerText = text;
        TheText.innerHTML = text;

        var TheHidden = document.getElementById(hiddenID);
        TheHidden.value = value;

    }

    function openSizedInfoWindow(infoPage, szw, szh, szr, szs) {
        // openInfoWindow opens the passed html page parameter in a remote window. 
        // You can create more remote windows by naming the new window object a 
        // different name. 

        //var newwind = window.showHelp(infoPage);      
        try {
            var newWind = window.open(infoPage, 'info', 'width=' + szw + ',height=' + szh + ',resizable=' + szr + ',scrollbars=' + szs + ',top=0,left=0');
            try { newWind.moveTo(screen.availWidth / 2 - (parseInt(szw) / 2), screen.availHeight / 2 - (parseInt(szh) / 2)); } catch (ex2) { }
        } catch (ex) { alert('Popup window cannot be open, Please enable Popups on this site to continue.'); }

        if (newWind.opener == null) {
            newWind.opener = window;
        }
        else {
            newWind.focus();
        }
    }


    function Trim(str) {
        str = str.replace(/^\s*|\s*$/g, "");
        for (i = 0; i < str.length; i++) {
            if (str.charAt(i) != ' ') { return str; }
        }
        return '';
    }


    function getSel() {
        var txt = '';
        var foundIn = '';
        if (window.getSelection) {
            txt = window.getSelection();
            foundIn = 'window.getSelection()';
        }
        else if (document.getSelection) {
            txt = document.getSelection();
            foundIn = 'document.getSelection()';
        }
        else if (document.selection) {
            txt = document.selection.createRange().text;
            foundIn = 'document.selection.createRange()';
        }
        else return;
        return txt;
    }
    function RefreshTab(objFoc) {

    }

    //-------------------------------------------------------------------------
    // tie buttons to enter keys

    function doTieClick(buttonName, e) {//the purpose of this function is to allow the enter key to point to the correct button to click.
        var key;

        if (window.event)
            key = window.event.keyCode;     //IE
        else
            key = e.which;     //firefox

        if (key == 13) {
            //Get the button the user wants to have clicked
            var btn = document.getElementById(buttonName);
            if (btn != null) { //If we find the button click it
                btn.click();
                event.keyCode = 0;
            }
        }

    }


    function openNewRadWin(level, url, windowName, sizeParams) {
        if (!level) {
            var oWnd = radopen(url, windowName, sizeParams);
        } else if (level = 1) {
            var oWnd1 = radopen(url, windowName, sizeParams);
        } else if (level = 2) {
            var oWnd2 = radopen(url, windowName, sizeParams);
        } else if (level = 3) {
            var oWnd3 = radopen(url, windowName, sizeParams);
        } else if (level = 4) {
            var oWnd4 = radopen(url, windowName, sizeParams);
        }
    }

    function OnRadWindowClose(oWnd, args) {
        var arg = args.get_argument();
        if (arg) {
            var url = arg.url;
            var targetID = arg.targetID;
            var targetTB = document.getElementById(targetID);
            targetTB.value = url;
        }
    }

    // ============================= Podcast select audio =========================

    function Select_Audio(tdID, guid) {
        var newTD = document.getElementById(tdID);
        SelectAudio(newTD, newTD.getAttribute('itemurl'), guid);
    }

    function SelectAudio(td, audioPath, guid) {
        // alert('SelectAudio \n' + audioPath + '\n' + guid);
        var selectedPodLineHD = document.getElementById('selectedPodLineHD_' + guid);
        var prevTd = document.getElementById(selectedPodLineHD.value);

        selectedPodLineHD.value = td.id;
        prevTd.className = prevTd.getAttribute('origclass');

        td.className = 'PodcastActiveRow';
        guid = '#' + guid;

        if (audioPath.toLowerCase().indexOf('.mp3') > 0) {
            $(guid).jPlayer("setMedia", { mp3: audioPath });
            $(guid).jPlayer("play", 0);
            if (navigator.appName.indexOf('xplorer') > 0) {
                $(guid).jPlayer("play");
            }
        } else if (audioPath.toLowerCase().indexOf('.wav') > 0) {
            $(guid).jPlayer("setMedia", { wav: audioPath });
            $(guid).jPlayer("play", 0);
            if (navigator.appName.indexOf('xplorer') > 0) {
                $(guid).jPlayer("play");
            }
        }
    }


    /* SHELL POPUPS SCRIPTS */



    function adjustPopupLink(sender, args) {
        var oWnd = GetRadWindowManager().getWindowByName("PopupLink");
        oWnd.get_contentFrame().contentWindow.expandMyDiv();
    }

    function showPopupLinkWindow(url, title, width, height, resize, autosize, anim, duration) {

        var windowHeight = parseInt(window.innerHeight * 0.90);
        var windowWidth = parseInt(window.innerWidth * 0.90);

        if (height > windowHeight)
        { height = windowHeight; }
        if (width > windowWidth)
        { width = windowHeight; }



        var mngr = $find("TS_RadWindowManager1");
        oWnd = mngr.getWindowByName("PopupLink");
        oWnd.set_title(title);
        //oWnd.set_iconUrl(icon);
        oWnd.SetUrl(url);
        oWnd.set_height(height);
        oWnd.set_width(width);

        if (resize) {
            oWnd.set_behaviors(Telerik.Web.UI.WindowBehaviors.Move + Telerik.Web.UI.WindowBehaviors.Close + Telerik.Web.UI.WindowBehaviors.Resize);
        } else {
            oWnd.set_behaviors(Telerik.Web.UI.WindowBehaviors.Move + Telerik.Web.UI.WindowBehaviors.Close);
        }

        if (autosize) {
            oWnd.set_autoSize(true);
        } else {
            oWnd.set_autoSize(false);
        }
        duration = duration * 1000;

        //Animations: None, Resize, Fade, Slide, FlyIn
        if (anim == 'None') { oWnd.set_animation(Telerik.Web.UI.WindowAnimation.None); }
        else if (anim == 'Resize') { oWnd.set_animation(Telerik.Web.UI.WindowAnimation.Resize); oWnd.set_animationDuration(duration); }
        else if (anim == 'Fade') { oWnd.set_animation(Telerik.Web.UI.WindowAnimation.Fade); oWnd.set_animationDuration(duration); }
        else if (anim == 'Slide') { oWnd.set_animation(Telerik.Web.UI.WindowAnimation.Slide); oWnd.set_animationDuration(duration); }
        else if (anim == 'FlyIn') { oWnd.set_animation(Telerik.Web.UI.WindowAnimation.FlyIn); oWnd.set_animationDuration(duration); }

        oWnd.show();

    }


    function showTemplateEdit(ActionCode, WinToRefresh) {
        if (WinToRefresh)
        { WinToRefreshAfterSave = WinToRefresh; }
        var url = pref + 'UserControls/BaseControls/Templates/TemplateEditor/TemplateEditPage.aspx?action=' + ActionCode;
        var mngr = $find("TS_RadWindowManager1");
        var oTmpWnd = mngr.getWindowByName("TemplateEdit");
        oTmpWnd.SetUrl(url);
        oTmpWnd.show();
        setTimeout(function () { oTmpWnd.setActive(true); }, 0);
    }

    function refreshTemplateList(sender, args) {
        if (WinToRefreshAfterSave) {
            try {
                WinToRefreshAfterSave.reload();
            } catch (ex) { alert(ex); }
        }
    }


    function onPopupLinkclosing(sender, args) {

        sender.SetUrl(pref + 'Shared/LoadingMsg.htm');
    }

    var ForceFullRefresh = false;

    function refreshGuide(sender, args) {
        sender.SetUrl(pref + 'Shared/LoadingMsg.htm');
        //alert('Guide is refreshed');
        if (sender.argument == "refreshAjax") {
            sender.argument = null;
            __doPostBack('TS$D$G$Bt_Refresh', '');

        } else if (sender.argument == "refresh" || ForceFullRefresh) {
            ForceFullRefresh = false;
            sender.argument = null;
            showLoadingPanel();
            __doPostBack('TS$Bt_Refresh', '');
        }
    }




    function ShowMovePanel(key, title, icon, fullRefresh) {
        var refreshStr = '';
        if (fullRefresh) {
            refreshStr = '&RefreshFull=1';
        }

        var url = pref + 'UserControls/BaseControls/Guide/ControlPanel/MoveItemDialog.aspx?Key=' + key + refreshStr;
        var mngr = $find("TS_RadWindowManager1");
        oWnd = mngr.getWindowByName("MoveWindow");
        oWnd.set_title(title);
        oWnd.set_iconUrl(icon);
        oWnd.SetUrl(url);
        oWnd.show();
    }

    function ShowSortItemsPanel(key) {
        var url = pref + 'UserControls/BaseControls/Guide/ControlPanel/SortInfoItems.aspx?RefreshFull=1&Key=' + key;
        var mngr = $find("TS_RadWindowManager1");
        oPubWnd = mngr.getWindowByName("SortItemsWindow");
        oPubWnd.SetUrl(url);
        oPubWnd.show();
    }

    function ShowSortFoldersPanel(key) {
        var url = pref + 'UserControls/BaseControls/Guide/ControlPanel/SortFolder.aspx?RefreshFull=1&Key=' + key;
        var mngr = $find("TS_RadWindowManager1");
        oPubWnd = mngr.getWindowByName("SortFoldersWindow");
        oPubWnd.SetUrl(url);
        oPubWnd.show();
    }

    function ShowDelPanel(key, fullRefresh) {
        var refreshStr = '';
        if (fullRefresh) {
            refreshStr = '&RefreshFull=1'
        }

        var mngr = $find("TS_RadWindowManager1");
        var url = pref + 'UserControls/BaseControls/Guide/ControlPanel/DeleteItemDialog.aspx?Key=' + key + refreshStr;
        oPubWnd = mngr.getWindowByName("DelWindow");
        oPubWnd.SetUrl(url);
        oPubWnd.show();


    }

    function ShowCPanel(action, fullRefresh) {

        var locationString = String(window.location);
        if (locationString.indexOf('tempContentMode') > 0) {
            ShowbyAction(action);
            return;
        }

        var mngr = $find("TS_RadWindowManager1");
        oWnd = mngr.getWindowByName("ControlPanel");

        var refreshStr = '';
        if (fullRefresh) {
            refreshStr = '&RefreshFull=1'
        }

        var relIdHid = document.getElementById('CurrentRelationID');
        var RelID = relIdHid.value;
        var url = pref + 'UserControls/BaseControls/Guide/ControlPanel/GuideControlPanelPage.aspx?relID=' + RelID + '&action=' + action + refreshStr;

        oWnd.set_title('');
        oWnd.SetUrl(pref + 'LoadingMsg.aspx?URL_Location=' + escape(url));
        oWnd.show();
    }




    function CPanelClosing(sender, e) {
        if (sender.get_contentFrame().contentWindow.closeIsOk || ForceClose) {
            ForceClose = false;
            return true;
        } else {
            WinSender = sender;
            setTimeout("WinSender.get_contentFrame().contentWindow.CloseCpanel();", 50);
            ForceClose = true;
            setTimeout("CPanelClosing(WinSender,null)", 100);
            e.set_cancel(true);
        }
    }

    function PrintPage(PageURL) {
        var XML_Guid = ''
        var InputHidden_Session_Form_XML_Guid = document.getElementById('Session_Form_XML_Guid');
        if (InputHidden_Session_Form_XML_Guid != null) {
            XML_Guid = InputHidden_Session_Form_XML_Guid.value;
        }

        if (XML_Guid != '') {
            if (PageURL.indexOf('ISvars') == -1) {
                if (PageURL.indexOf('?') == -1) {
                    PageURL += '?Session_Form_XML_Guid=' + XML_Guid;
                }
                else {
                    PageURL += '&Session_Form_XML_Guid=' + XML_Guid;
                }
            }
            else {
                PageURL = PageURL.replace('/ISvars/', '/ISvars/Session_Form_XML_Guid/' + XML_Guid + '/');
            }
        }
    
        openInfoWindow(PageURL);
    }


    var bodyOverflow = "";
    var htmlOverflow = "";

    function hideScroll() {
        bodyOverflow = document.body.style.overflow;
        htmlOverflow = document.documentElement.style.overflow;
        document.body.style.overflow = "hidden";
        document.documentElement.style.overflow = "hidden";
    }

    function restoreScroll(sender, args) {
        document.body.style.overflow = bodyOverflow;
        document.documentElement.style.overflow = htmlOverflow;
    }

    if (window.addEventListener) {
        window.addEventListener('DOMMouseScroll', wheel, false);
    }

    function wheel(event) {
        if (document.body.style.overflow == "hidden") {
            event.preventDefault();
            event.returnValue = false;
        } else {
            event.returnValue = true;
        }
    }
    window.onmousewheel = document.onmousewheel = wheel;
