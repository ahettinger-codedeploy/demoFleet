function tryToEnableWACookies(waUrl)
{
  function getXMLHttpRequest(method, url)
  {
    var xhr = new window.XMLHttpRequest();
    if ("withCredentials" in xhr)
    {
      // XHR for Chrome/Firefox/Opera/Safari.
      xhr.open(method, url, true);
    } else if (typeof XDomainRequest != "undefined")
    {
      // XDomainRequest for IE.
      xhr = new XDomainRequest();
      xhr.open(method, url);
    } else
    {
      // CORS not supported.
      xhr = null;
    }
    return xhr;
  }

  var oReq = getXMLHttpRequest("POST", waUrl + "/Sys/Cookies/GetCookiesEnabled");

  function handler()
  {
    if (oReq.readyState == 4) // complete 
    {
      if (oReq.status == 200)
      {
        if (oReq.responseText == "disabled")
        {
          document.location.href = waUrl + "/Sys/Cookies/OpenAndClose?origin=" + encodeURIComponent(document.location.href);
        }
      }
    }
  }

  function testWACookiesAjax()
  {
    if (!oReq)
    {
      return;
    }

    if (oReq.setRequestHeader)
    {
      oReq.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    }
    if (oReq.contentType)
    {
      oReq.contentType = "application/x-www-form-urlencoded";
    }
    oReq.withCredentials = true;
    oReq.onload = handler;
    oReq.send('origin=' + document.location.href);
  }

  var testCookieName = "WACookiesTestDone" + waUrl.replace(/\./g, "").replace(/\-/g, "").replace(/\:/g, "").replace(/\//g, "")
  
  if (document.cookie.indexOf(testCookieName + "=1") >= 0)
  {
    return;
  }

  document.cookie = testCookieName + "=1";

  if (document.cookie.indexOf(testCookieName + "=1") < 0)
  {
    return;
  }
  
  testWACookiesAjax();
}
