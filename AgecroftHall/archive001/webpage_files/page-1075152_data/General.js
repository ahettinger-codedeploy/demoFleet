/*   /Admin/html_res/js/dataChangeWatcher.js   */

(function()
{
  if (window.DataChangeWatcher == null)
  {
    window.DataChangeWatcher = new Object();
    var validationGroup = "DataChangeWatcherValidationGroup";
    var warningMessage = "Cancel your changes?";
    var watch = false;
    var watchTM = null;
    var isInited = false;
    var savedValues = new Object();
    var alreadyChanged = false;
    var initWhenValidatorsLoadedCounter = 0;
    
    DataChangeWatcher.startWatching = startWatching;
    DataChangeWatcher.stopWatching = stopWatching;
    DataChangeWatcher.pauseWatching = pauseWatching;
    DataChangeWatcher.resumeWatching = resumeWatching;
    DataChangeWatcher.changeValidator = validate;
    DataChangeWatcher.changeValidatorSkipLineEndings = validateIgnoreLineEndings;
    DataChangeWatcher.changeValidatorCustom = validateCustom;
    DataChangeWatcher.checkIfDataChanged = checkIfDataChanged;
    DataChangeWatcher.confirmIfDataChanged = confirmIfDataChangedAndStopWatching;
    DataChangeWatcher.isWatching = isWatching;
    DataChangeWatcher.setChanged = setChanged;
    DataChangeWatcher.setNotChanged = setNotChanged;
  }
  
  if (typeof(watch) == 'undefined')
  {
    var watch = null;
  }
  
  
  function isWatching ()
  {
    return (watch != null) ? watch : null;
  }
    

  function stopWatching()
  {
      if (watchTM) clearTimeout(watchTM);
      watch = false;
  }
  
  
  function startWatching (validationGroupName, message, forceInit)
  {
    if (forceInit)
    {
      isInited = false;
      watch = false;
    }
    
    if (isInited)
    {
      watch = true;
    }
    else
    {
      if (validationGroupName)
      {
        validationGroup = validationGroupName;
      }
      
      if (message)
      {
        warningMessage  = message;
      }
      
      // we have to start it with timeout - this is for Atlas
      setTimeout(initWhenValidatorsLoaded, 100);
    }
  }
  
  
  
  
  function pauseWatching (source)
  {
    if (watchTM) clearTimeout(watchTM);
    watch = false;
  }
  
  
  function resumeWatching (source)
  {
    if (watchTM) clearTimeout(watchTM);
    
    if (BonaPage.Browser.isWebKit && !source)
    {
      watchTM = setTimeout(function () { watch = true; }, 7);
    }
    else
    {
      watch = true;
    }
  }
  
  
  function initWhenValidatorsLoaded ()
  {
    if (isInited)
    {
      return;
    }
     
    initWhenValidatorsLoadedCounter++;
    
    // check of Page_ValidationActive is true
    // we can save initial values only if 
    if (typeof(Page_ValidationActive) == 'boolean' && Page_ValidationActive &&
        (WA.isWidgetMode || !WA.BonaEditor || WA.BonaEditor.EditorsManager == null || initWhenValidatorsLoadedCounter > 10 ||
         (WA.BonaEditor.EditorsManager != null && WA.BonaEditor.EditorsManager.checkIfAllEditorsReady())))
    {
      initWhenValidatorsLoadedCounter = 0;
      watch = true;
      var origValidatorUpdateIsValid = ValidatorUpdateIsValid;
      var origValidatorUpdateDisplay = ValidatorUpdateDisplay;
      
      ValidatorUpdateIsValid = function() {};
      ValidatorUpdateDisplay = function() {};
      
      //call validate so validation is performed. 
      //isInited = false and thus DataChangeWatcher.changeValidator will save current values to the senders
      Page_ClientValidate(validationGroup);
      
      ValidatorUpdateIsValid = origValidatorUpdateIsValid;
      ValidatorUpdateDisplay = origValidatorUpdateDisplay;
      
      addOnBeforeUnloadHandler();
      isInited = true;
      initWhenValidatorsLoadedCounter = 0;
    }
    else if (WA.BonaEditor && WA.BonaEditor.EditorsManager != null && !WA.BonaEditor.EditorsManager.checkIfAllEditorsReady())
    {
      setTimeout(initWhenValidatorsLoaded, 100);
    }
  }
  
  
  function validate (sender, args)
  {
    validateCustom(sender.controltovalidate, args.Value, args);
  }
  
  
  function validateIgnoreLineEndings (sender, args)
  {
    validateCustom(sender.controltovalidate, args.Value, args, true);
  }
  
  
  function validateCustom (uniqueKey, value, args, ignoreLineEndings)
  {
    var isValid = true;
      
    if (watch)
    {
      if (alreadyChanged)
      {
        isValid = false;
      }
      else
      {
        if (!isInited)
        {
          if (savedValues)
          {
            savedValues[uniqueKey] = value;
          }
        }
        else if (savedValues[uniqueKey] != null)
        {
          isValid = checkValuesAreEqual(savedValues[uniqueKey] + '', value, ignoreLineEndings);
        } 
      }
    }
    
    args.IsValid = isValid;
  }
  
  
  function checkValuesAreEqual (value1, value2, ignoreLineEndings)
  {
    var valuesEqual;
  
    if (ignoreLineEndings)
    {
      valuesEqual = (WA.String.gtrim(value1.replace(/[\n\r\t]+/g, '').replace(/^\s*(.*)\s*$/, '$1')) == WA.String.gtrim(value2.replace(/[\n\r\t]+/g, '').replace(/^\s*(.*)\s*$/, '$1')));
    }
    else
    {
      valuesEqual = (WA.String.gtrim(value1) == WA.String.gtrim(value2));
    }
    
    return valuesEqual;
  }
  
  
  function checkIfDataChanged ()
  {
      if (!watch) {
          return false;
      }
      var changed = (alreadyChanged) ? true : false;
    
    if (window && window.Page_ClientValidate)
    {
      changed = !Page_ClientValidate(validationGroup) || changed;    
    }
    
    if (window && window.BonaValidateIfChanged)
    {
      changed = BonaValidateIfChanged() || changed;
    }
    
    return changed;
  }
  
  
  function confirmIfDataChangedAndStopWatching ()
  {
    var confirmed = true;

    if (checkIfDataChanged())
    {
      confirmed = confirm(warningMessage);
    }
      
    if (confirmed)
    {
       pauseWatching();
    }
    else if (window.Page_Validators)
    {
      setTimeout(function()
      {
        for (var i = 0; i < Page_Validators.length; i++)
        {
          if (typeof(Page_Validators[i].validationGroup) == 'string' && Page_Validators[i].validationGroup != validationGroup)
          {
            ValidatorValidate(Page_Validators[i], Page_Validators[i].validationGroup, null);
          }
        }
      }, 10);
    }

    return confirmed;
  }
  
  
  function addOnBeforeUnloadHandler ()
  {
    var isAdminPanelPresent = false;
    
    try
    {
      if(BonaPage.topWindow.adminpanel)
      {
        isAdminPanelPresent = true;
      }
    }
    catch(e){};

    if (isAdminPanelPresent)
    {
      if (document.all)
      {
        try
        {        
            BonaPage.topWindow.adminpanel.document.body.onbeforeunload = validateBeforeUnloadAdminFrame;
            BonaPage.topWindow.adminpanel.document.body.onunload = pauseWatching;        
            BonaPage.topWindow.contentarea.document.body.onbeforeunload = validateBeforeUnloadContentFrame;
            BonaPage.topWindow.contentarea.document.body.onunload = pauseWatching;        
            BonaPage.topWindow.document.body.onbeforeunload = validateBeforeUnloadFrameSet;
            BonaPage.topWindow.document.body.onunload = pauseWatching;
        }
        catch(e)
        {
            setTimeout(function() { addOnBeforeUnloadHandler(); }, 100);
        }
      }
      else
      {
        if (window.BonaPage && BonaPage.Browser.isOnBeforeUnloadEnabled)
        {
          BonaPage.topWindow.adminpanel.onbeforeunload = validateBeforeUnloadAdminFrame;
          BonaPage.topWindow.contentarea.onbeforeunload = validateBeforeUnloadContentFrame;
          BonaPage.topWindow.onbeforeunload = validateBeforeUnloadFrameSet;
          
          if (BonaPage.Browser.isWebKitSafari)
          {
            function fixSafariLinksForDCW ()
            {
              var i;
              var links = BonaPage.topWindow.contentarea.document.getElementsByTagName('A');
              
              for (i = 0; i < links.length; i++)
              {
                if ((!links[i].getAttribute('target', 0) || links[i].getAttribute('target', 0).toLowerCase() != '_blank') && !links[i].onclick)
                {
                  links[i].onclick = confirmIfDataChangedAndStopWatching;
                }
              }
            }
            
            if (BonaPage.topWindow.contentarea.BonaPage)
            {
              BonaPage.topWindow.contentarea.BonaPage.addPageStateHandler(BonaPage.topWindow.contentarea.BonaPage.PAGE_PARSED, fixSafariLinksForDCW);
            }
          }
        }
        
        BonaPage.topWindow.adminpanel.onunload = pauseWatching;
        BonaPage.topWindow.contentarea.onunload = pauseWatching;
        BonaPage.topWindow.onunload = pauseWatching;
      }
    }
    else
    {
      if (document.all)
      {
        window.document.body.onbeforeunload = validateBeforeUnloadNoFrames;
        window.document.body.onunload = pauseWatching;
      }
      else
      {
        if (window.BonaPage && BonaPage.Browser.isOnBeforeUnloadEnabled)
        {
          window.onbeforeunload = validateBeforeUnloadNoFrames;
        }
        
        window.onunload = pauseWatching;
      }
    }
  }
  
  
  function removeOnBeforeUnloadHandler ()
  {
    //globalUtils.removeHandler(window, 'beforeunload', validateBeforeUnload);
  }
  
  
  function getWarningMessageIfDataChanged ()
  {
    var dataChanged = checkIfDataChanged();
    if (dataChanged)
      return warningMessage;
  }
  
  
  function validateBeforeUnloadNoFrames ()
  {
    if (!watch)
    {
      return;
    }

    var message = getWarningMessageIfDataChanged();

    pauseWatching();
    
    if (document.all)
    {
        window.setTimeout(resumeWatching, 100);
    }
    else
    {
        window.setTimeout(resumeWatching, 100);
    }

    return message;
  }
  
  
  function validateBeforeUnloadAdminFrame ()
  {
    if (!watch)
    {
      return;
    }

    var message = getWarningMessageIfDataChanged();

    pauseWatching();
    
    if (document.all)
    {
      BonaPage.topWindow.adminpanel.setTimeout(resumeWatching, 100);
    }
    else
    {
      BonaPage.topWindow.adminpanel.setTimeout(resumeWatching, 100, 'admin');
    }

    return message;
  }
  
  
  function validateBeforeUnloadContentFrame ()
  {
    if (!watch)
    {
      return;
    }

    var message = getWarningMessageIfDataChanged();

    pauseWatching();
    
    if (document.all)
    {
      setTimeout(resumeWatching, 100);
    }
    else
    {
      BonaPage.topWindow.contentarea.setTimeout(resumeWatching, 100, 'content');
    }

    return message;
  }
  
  
  function validateBeforeUnloadFrameSet ()
  {
    if (!watch)
    {
      return;
    }

    var message = getWarningMessageIfDataChanged();

    pauseWatching();
    
    if (BonaPage)
    {
      if (document.all)
      {
        BonaPage.topWindow.setTimeout(resumeWatching, 100);
      }
      else
      {
        BonaPage.topWindow.contentarea.setTimeout(resumeWatching, 100, 'content');
        BonaPage.topWindow.adminpanel.setTimeout(resumeWatching, 100, 'admin');
      }
    }
    else
    {
      try
      {
        if (document.all)
        {
          top.setTimeout(resumeWatching, 100);
        }
        else
        {
          top.contentarea.setTimeout(resumeWatching, 100, 'content');
          top.adminpanel.setTimeout(resumeWatching, 100, 'admin');
        }
      }
      catch (err) {}
    }

    return message;
  }
  
  
  function setChanged ()
  {
    alreadyChanged = true;
  }
  
  
  function setNotChanged ()
  {
    alreadyChanged = false;
  }
  
}) ();




/*   /Admin/html_res/js/customFieldsValidation.js   */

if (!window.pictureUploaders)
{
  window.pictureUploaders = new Object();
}
window.registerPictureUploader = function(frameId, win)
{
  var frame = document.getElementById(frameId);

  if (!frame)
  {
    return;
  }
  
  var name = frame.getAttribute('name');
  initPictureUploaders(name);
  window.pictureUploaders[name].win = win;
  hidePleaseWait(name);  
  invokeValidator(name);
}
function invokeValidator(name)
{
  initPictureUploaders(name);
  var validatorId = window.pictureUploaders[name].validatorId;    
  
  if (validatorId == null || validatorId == undefined)
  {
    setTimeout(function(){invokeValidator(name)}, 100);
    return;
  }

  if (validatorId == '')
    return;

  var val = document.getElementById(validatorId);

  if (val)
  {
    ValidatorValidate(val);
  } 
}
function hidePleaseWait(name)
{
  initPictureUploaders(name);
  var win = window.pictureUploaders[name].win;
  var pleaseWaitId = window.pictureUploaders[name].pleaseWaitId;
  
  if (!win || !pleaseWaitId)
  {
    setTimeout(function(){hidePleaseWait(name)}, 100);  
    return;
  }
  
  if (pleaseWaitId == '')
    return;
  
  var pleaseWait = document.getElementById(pleaseWaitId);
  
  if (!pleaseWait)
  {
    return;
  }
  
  pleaseWait.wasHideByFrame = 't';
  pleaseWait.style.display = 'none';
}
function showPleaseWait(pleaseWaitId, frameName)
{
  var pleaseWait = document.getElementById(pleaseWaitId);
  
  if (!pleaseWait) 
  {
    return;
  }
  
  var wasHideByFrame = pleaseWait.getAttribute('wasHideByFrame');
  
  if (wasHideByFrame == 't')
  {
    return;
  }
  
  pleaseWait.style.display = 'block';
}
function setControlIds(pleaseWaitId, validatorId, frameName)
{
  initPictureUploaders(frameName);
  window.pictureUploaders[frameName].pleaseWaitId = pleaseWaitId;
  window.pictureUploaders[frameName].validatorId = validatorId;
}
function initPictureUploaders(frameName)
{
  if (!window.pictureUploaders[frameName])
  {
    window.pictureUploaders[frameName] = new Object();
  }
}
function validatePictureRequired(src, args, frameName)
{
  var frame = window.pictureUploaders[frameName].win;

  if (!frame)
  {
    setTimeout(function() { validatePictureRequired(src, args, frameName); }, 100);
    return;
  }

  args.IsValid = frame.isPicturePresent(frameName);
}
function syncronizeEmailCheckboxesState(subscribedToEmailsCheckBoxId, otherCheckBoxesContainerId)
{
  var subscribedToEmailsCheckBox = document.getElementById(subscribedToEmailsCheckBoxId);
  var otherCheckBoxesContainer = document.getElementById(otherCheckBoxesContainerId);
  
  if (!subscribedToEmailsCheckBox || !otherCheckBoxesContainer)
  {
    return;
  }
  
  var otherCheckBoxes = otherCheckBoxesContainer.getElementsByTagName('input');
  var otherCheckBoxesLabels = otherCheckBoxesContainer.getElementsByTagName('label');
  var length = otherCheckBoxes.length;
  
  if (subscribedToEmailsCheckBox.checked)
  {
    for(var i = 1; i < length; i++)// from the first!!
    {
      otherCheckBoxes[i].disabled = false;
      otherCheckBoxesLabels[i].className = "";
    } 
  }
  else
  {
    for(var i = 1; i < length; i++)// from the first!!
    {
      otherCheckBoxes[i].checked = false; 
      otherCheckBoxes[i].disabled = true;
      otherCheckBoxesLabels[i].className = "disabled";
    } 
  }
}

var MemberPasswordHelper;
(function()
{
  if (!MemberPasswordHelper)
  {
    var MemberPasswordHelper = new Object();
    var minPasswordLength = 7;
    var passwordLength = 8;
  }
  
  function minPasswordLengthValidate(sender, args)
  {
      args.IsValid = WA.String.gtrim(args.value).length >= minPasswordLength;
  };
})();




/*   /Admin/html_res/js/ResizingTextarea.js   */

var TextareaHashObject = new Array();

function TextareaResizer(TextareaID, TextareaContainerID, AutoExpandOnFocus, CollapsedHeight, ExpandedHeight, ExplicitHeight, WatermarkString, CanCollapseWhenNotEmpty)
{
    // private properties
    var pThis = this;
    this.intCurrHeight = 50;
    this.Textarea;
    this.TextareaContainer;
    this.objTextareaResizeInterval;
    
    if (TextareaID)             this.Textarea = document.getElementById(TextareaID);                // required
    if (!this.Textarea)         return null;
    if (TextareaContainerID)    this.objContainer = document.getElementById(TextareaContainerID);   // optional 
        
    this.SetAttribute = function(strAttribute, anyInitValue, anyDefaultValue)
    {
        if (!this.Textarea) return false;
        var anyExistingValue = this.Textarea[strAttribute];
        if ((anyInitValue != "undefined") && (anyInitValue || (anyInitValue == false))) 
        {
            this.Textarea[strAttribute] = anyInitValue;
        }
        else
        {
            if (!anyExistingValue) this.Textarea[strAttribute] = anyDefaultValue;
        }
        return true;
    }
        
    // public attrubutes initialization
    this.SetAttribute("TextareaContainerID", TextareaContainerID, null);    // optinal
    this.SetAttribute("TextareaContainerPadding", null, 10);                // optional
    this.SetAttribute("AutoExpandOnFocus", AutoExpandOnFocus, true);
    this.SetAttribute("CollapsedHeight", CollapsedHeight, 50);
    this.SetAttribute("ExpandedHeight", ExpandedHeight, 200);
    this.SetAttribute("ExplicitHeight", ExplicitHeight, false);
    this.SetAttribute("WatermarkString", WatermarkString, "Write your comments here...");
    this.SetAttribute("CanCollapseWhenNotEmpty", CanCollapseWhenNotEmpty, false);
    
    this.Textarea.style.overflow = (this.Textarea["ExplicitHeight"] ? "auto" : "visible");
        
    var isDOM = (document.getElementById) ? true : false;
    var isOpera = window.opera && isDOM;
    var isIE = document.all && document.all.item && !isOpera;
    
    // initializing private properties

    this.intCurrHeight = this.Textarea["CollapsedHeight"];
    this.Textarea.style.height = this.intCurrHeight + "px";
    
    if (this.Textarea.value.length == 0) this.Textarea.value = this.Textarea["WatermarkString"];

	// initializing event hendlers
	var strRE = ' ';
    strRE.match(/(((((.)))))/);
    ((this.Textarea.onfocus + '').replace(/\n/g, '')).match(/.*?\{(.*)\}.*?/);
    this.Textarea.onfocus = new Function(RegExp.$1 + '; TextareaHashObject["' + this.Textarea.id + '"].OnFocus()');
    strRE.match(/(((((.)))))/);
    ((this.Textarea.onblur + '').replace(/\n/g, '')).match(/.*?\{(.*)\}.*?/);
    this.Textarea.onblur = new Function(RegExp.$1 + '; TextareaHashObject["' + this.Textarea.id + '"].OnBlur()');
    
    if (isIE)
    {
      this.Textarea.attachEvent('onkeydown', function () { pThis.OnKeyDown(event); });
    }
    else
    {
      this.Textarea.addEventListener('keydown', function (e) { pThis.OnKeyDown(e); }, false);
    }
   

    // properties "Set"
    this.SetTextareaID = function(strNewTextareaID)
    {   
        if (!this.Textarea) return false;
        var objNewTextarea = document.getElementById(strNewTextareaID);
        if (objNewTextarea)
        {
            this.Textarea = objNewTextarea;
            return true;
        }
        return false;
	}
	
	this.SetContainerID = function(strNewContainerID)
    {   
        if (!this.Textarea) return false;
        var objNewContainer = document.getElementById(strNewContainerID);
        if (objNewContainer)
        {
            this.TextareaContainer = objNewContainer;
            this.SetAttribute("ContainerID", strNewContainerID);
            return true;
        }
        return false;
	}
	
	this.SetAutoExpandOnFocus = function(blnEnableAutoExpand)
    {   
        if (!this.Textarea) return false;
        return this.SetAttribute("AutoExpandOnFocus", blnEnableAutoExpand);
	}
	
	this.SetCollapsedHeight = function(intNewCollapsedHeight)
    {   
        if (!this.Textarea) return false;
        if (intNewCollapsedHeight < 1) return false;
        if (this.Textarea.style.height == this.Textarea.CollapsedHeight + "px") 
        {
            this.Resize(intNewExpandedHeight);
        }
        this.SetAttribute("CollapsedHeight", intNewCollapsedHeight);
        return true;
	}
	
	this.SetExpandedHeight = function(intNewExpandedHeight)
    {   
        if (!this.Textarea) return false;
        if (intNewExpandedHeight <= this.Textarea.CollapsedHeight) return false;
        if (this.Textarea.style.height == this.Textarea.ExpandedHeight + "px") 
        {
            this.Resize(intNewExpandedHeight);
        }
        this.SetAttribute("ExpandedHeight", intNewExpandedHeight);
        return true;
	}
	
	this.SetExplicitHeight = function(blnEnableExplicitHeight)
    {  
        if (!this.Textarea) return false;
        this.SetAttribute("ExplicitHeight", blnEnableExplicitHeight);
        if (this.blnEnableExplicitHeight == false)
        {
            this.Textarea.style.overflow = "visible";
        }
        else
        {
            this.Textarea.style.overflow = "auto";
        } 
        return true;
	}
	
	this.SetWatermarkString = function(strNewWatermarkString)
    {  
        if (!this.Textarea) return false;
        if (this.Textarea.value == this.Textarea.WatermarkString) this.Textarea.value = strNewWatermarkString;
        this.SetAttribute("WatermarkString", strNewWatermarkString); 
	}
	
	this.SetTextareaContainerPadding = function(intNewTextareaContainerPadding)
	{
	    if (!this.Textarea) return false;
        this.SetAttribute("TextareaContainerPadding", intNewTextareaContainerPadding); 
	}
	
	this.SetCanCollapseWhenNotEmpty = function(blnCanCollapseWhenNotEmpty)
	{
	    if (!this.Textarea) return false;
        this.SetAttribute("CanCollapseWhenNotEmpty", blnCanCollapseWhenNotEmpty); 
	}
	
   
    // properties "Get"
    
    this.Expanded = function()
    {
        return this.Textarea.style.height == this.Textarea.ExpandedHeight;
    }
    
    this.Collapsed = function()
    {
        return this.Textarea.style.height == this.Textarea.CollapsedHeight;
    }
    
    this.Resize = function(intNewHeight)
    {            
        var intResizeStep = 0;
        try
        {
            window.clearTimeout(this.objTextareaResizeInterval);
        }
        catch (err) { }  
        if (Math.abs(intNewHeight - this.intCurrHeight) < 2)
        {
            this.intCurrHeight = intNewHeight;
        }
        else
        {   
            this.intCurrHeight = (this.intCurrHeight / 2) + (intNewHeight / 2);
            this.objTextareaResizeInterval = window.setTimeout("TextareaHashObject['" + this.Textarea.id + "'].Resize(" + intNewHeight + ")", 30);
        }
        this.Textarea.style.height = this.intCurrHeight + 'px';
        if (this.objContainer) this.objContainer.style.height = (this.intCurrHeight + this.Textarea["TextareaContainerPadding"]) + 'px';
    }
    
    this.OnFocus = function()
    {
        if (this.Textarea["WatermarkString"] == this.Textarea.value) this.Textarea.value = "";
        if (this.Textarea.style.height != this.Textarea["ExpandedHeight"] + "px")
        {
            if (this.Textarea["AutoExpandOnFocus"] == true) this.Resize(this.Textarea["ExpandedHeight"]);
        }
    }
    
    this.OnBlur = function()
    {
        if (this.Textarea["AutoExpandOnFocus"] == true)
        {     
            if ((this.Textarea.value.length == 0) || (this.Textarea["CanCollapseWhenNotEmpty"])) 
            {
                this.Resize(this.Textarea["CollapsedHeight"]);
            }
        }
        if (this.Textarea.value.length == 0)
        {
            this.Textarea.value = this.Textarea["WatermarkString"];
        }
    }
    
    this.OnKeyDown = function (e)
    {    
        var key = (isIE) ? e.keyCode : e.which;
        
        if (key == 27)
        { 
            if(this.Textarea.value.length < 10)
            {
                this.Textarea.value = "";
                this.OnBlur();
                document.body.focus();
            }
            else
            {
                return false;
            }
        }        
    }
    
    this.Expand = function()
    {
        this.Resize(this.Textarea["ExpandedHeight"]);
    }
    
    this.Collapse = function()
    {
        this.Resize(this.Textarea["CollapsedHeight"]);
    }
    

    // initializing global chache
    TextareaHashObject[this.Textarea.id] = this;
}




/*   /Content/Members/PictureUploader/PictureUploader.js   */

function startUpload(btnId)
{
  var upload = document.getElementById('upload');
  var process = document.getElementById('process');
  upload.style.display = 'none';
  process.style.display = 'block';
  
  try
  {
    document.getElementById(btnId).click();
  }
  catch(e)
  {
    upload.style.display = 'block';
    process.style.display = 'none';
  }
}
function hideWaitMessage(waitControlId)
{
  if (!parent)
  {
    return;
  }
  
  var waitControl = parent.document.getElementById(waitControlId);
  
  if (!waitControl)
  {
    return;
  }
  
  waitControl.style.display = 'none';
}
function setHeight(frameId, height)
{
  height = height + 'px';
  setFrameHeight(frameId, height);
}
function setFrameHeight(frameId, height)
{
  if (!parent)
  {
    return;
  }
  
  var frame = parent.document.getElementById(frameId);
  
  if (!frame)
  {
    return;
  }
  
  frame.style.height = height;
}
window.getState = function(frameName)
{
  if (!parent)
  {
    return 0;
  }
  
  if (!parent.pictureState)
  {
    return 0;
  }
  
  if (!parent.pictureState[frameName])
  {
    return 0;
  }
  
  return parent.pictureState[frameName];
}
window.isPicturePresent = function(frameName)
{
  return (parent.pictureState[frameName] == 2 || parent.pictureState[frameName] == 1);
}
function stateNoPicture(frameId)
{
  changeState(frameId, 0);
}
function statePictureDefault(frameId)
{
  changeState(frameId, 1);
}
function statePictureUploaded(frameId)
{
  changeState(frameId, 2);
}
function changeState(frameId, value)
{
  if (!parent)
  {
    return;
  }
  
  var name = parent.document.getElementById(frameId).getAttribute('name');
  
  if (!parent.pictureState)
  {
    parent.pictureState = new Object();
  }
  
  parent.pictureState[name] = value;  
}
function registerUploader(frameId)
{
  if (!parent || !parent.registerPictureUploader)
  {
    return;
  }
  
  parent.registerPictureUploader(frameId, window);
}
function setDataChangeWatcherChanged()
{
  if (typeof(BonaPage.topWindow.DataChangeWatcher) != "undefined")
  {
    BonaPage.topWindow.DataChangeWatcher.setChanged();
    return;
  }
  if (typeof(BonaPage.topWindow.contentarea) != "undefined" && typeof(BonaPage.topWindow.contentarea.DataChangeWatcher) != "undefined")
  {
    BonaPage.topWindow.contentarea.DataChangeWatcher.setChanged();
  }
}


/*   /Content/Events/EventListPreferences.js   */

var EventListPreferences;

(function()
{
  if (EventListPreferences == null)
  {
    EventListPreferences = new Object();
  }

  EventListPreferences.tagsTableId = '';
  EventListPreferences.showAllRadioId = '';
  EventListPreferences.selectAll = selectAll;
  EventListPreferences.clearAll = clearAll;
  EventListPreferences.preventClick = preventClick;
  EventListPreferences.disableTagsSelection = disableTagsSelection;
  EventListPreferences.enableTagsSelection = enableTagsSelection;
  EventListPreferences.atLeastOneTagShouldBeSelected = atLeastOneTagShouldBeSelected;
  EventListPreferences.validateInputsStateChanged = validateInputsStateChanged;

  function validateInputsStateChanged(sender, args)
  {
    validateStateChanged(args, 'preferencesHolder');
  }

  function selectAll(evt)
  {
    setCheckboxesInCheckedState(true);
    
    if (evt.preventDefault)
    {
      evt.preventDefault();
    }
    else
    {
      evt.returnValue = false;
    }
  }
  function clearAll(evt)
  {
    setCheckboxesInCheckedState(false);
    
    if (evt.preventDefault)
    {
      evt.preventDefault();
    }
    else
    {
      evt.returnValue = false;
    }
  }
  function disableTagsSelection()
  {
    setCheckboxesInEnabledState(false);
    var selectAllAnchor = WA.$('selectAll', window);
    var clearAllAnchor = WA.$('clearAll', window);
    clearHandlers(selectAllAnchor);
    clearHandlers(clearAllAnchor);
    WA.addHandler(selectAllAnchor, 'click', preventClick);
    WA.addHandler(clearAllAnchor, 'click', preventClick);
  }
  function enableTagsSelection()
  {
    setCheckboxesInEnabledState(true);
    var selectAllAnchor = WA.$('selectAll', window);
    var clearAllAnchor = WA.$('clearAll', window);
    clearHandlers(selectAllAnchor);
    clearHandlers(clearAllAnchor);
    WA.addHandler(selectAllAnchor, 'click', selectAll);
    WA.addHandler(clearAllAnchor, 'click', clearAll);
  }
  function clearHandlers(anchor)
  {
    BonaPage.removeHandler(anchor, 'click', preventClick);
    BonaPage.removeHandler(anchor, 'click', selectAll);
    BonaPage.removeHandler(anchor, 'click', clearAll);
  }
  function atLeastOneTagShouldBeSelected(sender, args)
  {
    var tags = document.getElementById(EventListPreferences.tagsTableId);
    var checkboxes = tags.getElementsByTagName('input');
    var showAllEvents = WA.$(EventListPreferences.showAllRadioId, window);

    if (showAllEvents.checked)
    {
      args.IsValid = true;
      return;
    }
    else
    {
      for (var i = 0; i < checkboxes.length; i++)
      {
        if (checkboxes[i].checked)
        {
          args.IsValid = true;
          return;
        }
      }
    }

    args.IsValid = false;
  }
  function validateStateChanged(args, containerId)
  {
    var state = '';
    var control = document.getElementById(containerId);

    if (!control)
    {
      return;
    }

    var children = control.getElementsByTagName('INPUT');

    for (var i = 0; i < children.length; i++)
    {
      if (children[i].checked)
      {
        state += children[i].value;
      }
    }

    DataChangeWatcher.changeValidatorCustom(containerId, state, args);
  }

  function setCheckboxesInCheckedState(state)
  {
    var tags = document.getElementById(EventListPreferences.tagsTableId);
    var checkboxes = tags.getElementsByTagName('input');

    for (var i = 0; i < checkboxes.length; i++)
    {
      checkboxes[i].checked = state;
    }
  }
  function setCheckboxesInEnabledState(state)
  {
    var tags = document.getElementById(EventListPreferences.tagsTableId);
    var checkboxes = tags.getElementsByTagName('input');

    for (var i = 0; i < checkboxes.length; i++)
    {
      if (state == false)
      {
        checkboxes[i].checked = false;
      }

      checkboxes[i].disabled = !state;
    }
  }
  function preventClick(evt)
  {
    if (evt.preventDefault)
    {
      evt.preventDefault();
    }
    else
    {
      evt.returnValue = false;
    }
  }
})();




/*   /Content/Events/EventRegistration.js   */

var EventRegistration;

(function() {

  var $ = function (id) { return document.getElementById(id); };
  
  if(EventRegistration == null) 
  {
    EventRegistration = new Object();
  }

  var additionalBasePrice = 0; 
  var eventBasePrice = 0;
  var currentPrice = 0; 
  var paymentInstructionsDiv;
  var paymentTypeSelectorTR;
  var currencySymbol = '';
  var currencyCode = '';
  var totalPriceLabel;
  var isOnlinePayPalPaymentForEventSupported = false;

  // public properties
  EventRegistration.paymentInstructionsDiv = paymentInstructionsDiv;
  EventRegistration.paymentTypeSelectorTR = paymentTypeSelectorTR;
  EventRegistration.currencySymbol = currencySymbol;
  EventRegistration.currencyCode = currencyCode;
  EventRegistration.totalPriceLabel = totalPriceLabel;
  EventRegistration.isOnlinePayPalPaymentForEventSupported = isOnlinePayPalPaymentForEventSupported;
  
  // public methods
  EventRegistration.initializePrice = initializePrice;
  EventRegistration.calcTotalPrice = calcTotalPrice;
  EventRegistration.clickCustomRadioButton = clickCustomRadioButton;
  EventRegistration.clickCustomCheckBox = clickCustomCheckBox;
  EventRegistration.clickRegType = clickRegType;

  function initializePrice(additional, eventBase, priceLabelId)
  {
    eventBasePrice = eventBase ? new Number(eventBase) : 0;
    if (priceLabelId)
    {
      EventRegistration.totalPriceLabel = $get(priceLabelId);
    }
    additionalBasePrice = 0; 
    currentPrice = 0; 
    calcTotalPrice(additional);
  }
  
  function calcTotalPrice(additional)
  {
    if (!EventRegistration.totalPriceLabel)
    {
      return;
    }
    additionalBasePrice += additional ? new Number(additional) : 0;
    currentPrice =  additionalBasePrice + new Number(eventBasePrice);
    EventRegistration.totalPriceLabel.innerHTML = EventRegistration.currencySymbol + currentPrice + EventRegistration.currencyCode;
    EventRegistration.totalPriceLabel.style.fontWeight = 'bold';
    setPaymentTypeSelectorVisibility();
  }
  
  function clickCustomRadioButton(sender, args)
  {
    var clickedRadioButton = args.target;
    var previouslyClickedRadioButton = args.previous;

    calcTotalPrice(new Number(clickedRadioButton.parentNode.getAttribute('price')));
    
    if (previouslyClickedRadioButton)
    {
      calcTotalPrice(new Number(previouslyClickedRadioButton.parentNode.getAttribute('price')) * -1);  
    }
  }
  function clickCustomCheckBox(sender, args)
  {
    var clickedCheckBox = args.target;
    if (clickedCheckBox.checked)
    {
      calcTotalPrice(clickedCheckBox.parentNode.getAttribute('price'));  
    }
    else
    {
      calcTotalPrice(clickedCheckBox.parentNode.getAttribute('price') * -1);    
    }
  }
  function clickRegType(newPrice)
  {
    objFakeRadioGroupValue.value = "1";
    for (var i = 0; i < Page_Validators.length; i++) {
        ValidatorValidate(Page_Validators[i], "EventRegistrationValidation", null);
    }
    ValidatorUpdateIsValid();
    Page_BlockSubmit = !Page_IsValid;
    eventBasePrice = new Number(newPrice);
    calcTotalPrice();  
  }
  function setPaymentTypeSelectorVisibility()
  {
    if (EventRegistration.paymentInstructionsDiv)
    {
      EventRegistration.paymentInstructionsDiv.style.display = currentPrice > 0 ? 'block':'none';;
    }
    if(EventRegistration.paymentTypeSelectorTR)
    {
      if(document.all)
      {
        EventRegistration.paymentTypeSelectorTR.style.display = currentPrice > 0 ? 'block':'none';
      }
      else
      {
        EventRegistration.paymentTypeSelectorTR.style.display = currentPrice > 0 ? 'table-row':'none';
      }  
    }
  }
}) ();




/*   /Content/Members/MemberDirectoryProfile.js   */

var MemberDirectoryProfile;

( function() {

  if (MemberDirectoryProfile == null) 
  {
    MemberDirectoryProfile = new Object();
  }
  
  /****************************************************************/
  /***  PUBLIC PROPERTIES AND METHODS                           ***/
  /****************************************************************/
  
  MemberDirectoryProfile.validateStateChanged = validateStateChanged;
  /****************************************************************/
  /***  PRIVATE FIELDS AND METHODS                              ***/
  /****************************************************************/

  var commentResizer;
  
  function $(id)
  { 
    return document.getElementById(id);
  }
  function validateStateChanged (src, args)
  {
    var state = '';
    var control = $(MemberDirectoryProfile.includeMeInMemberDirectoryContainer);
    if (control)
    {
      var children = control.getElementsByTagName('INPUT');
      
      for (var i=0; i<children.length; i++)
      {
        if (children[i].checked)
        {
          state += children[i].value;
        }
      }

      DataChangeWatcher.changeValidatorCustom(MemberDirectoryProfile.includeMeInMemberDirectoryContainer, state, args);
    }
  }
}) ();




/*   /Content/SubscriptionForm/SubscriptionFormPreferences.js   */

var SubscriptionFormPreferences;

(function()
{
  if (SubscriptionFormPreferences == null)
  {
    SubscriptionFormPreferences = new Object();
  }

  SubscriptionFormPreferences.adjustContactFieldsVisibility = adjustContactFieldsVisibility;
  
  SubscriptionFormPreferences.optionSelectedFieldsRadioId = optionSelectedFieldsRadioId;
  SubscriptionFormPreferences.contactFieldsContainerId = contactFieldsContainerId;
  
  var optionSelectedFieldsRadioId;
  var contactFieldsContainerId;

  function adjustContactFieldsVisibility()
  {
    var optionSelectedFieldsRadio = document.getElementById(SubscriptionFormPreferences.optionSelectedFieldsRadioId);
    var contactFieldsContainer = document.getElementById(SubscriptionFormPreferences.contactFieldsContainerId);
    contactFieldsContainer.style.display = (optionSelectedFieldsRadio.checked) ? 'block' : 'none';
  }
  
})();




