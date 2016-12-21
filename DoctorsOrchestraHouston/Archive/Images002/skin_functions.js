function Rollover(imagename, image, over)
{
  if(window.document.images)
  {
    if(over)
    {
      window.document.images["sdhover" + imagename].src = image;
    }
    else
    {
      window.document.images["sdhover" + imagename].src = image;
    }
  }
}

function ToggleCommentDiv(elm, hiddenDivName, ShowText, HideText)
{
  var hiddenDiv = document.getElementById(hiddenDivName);

  if(hiddenDiv.style.display == 'none')
  {
    elm.innerHTML = HideText;
    hiddenDiv.style.display = 'block';
  }
  else
  {
    elm.innerHTML = ShowText;
    hiddenDiv.style.display = 'none';
  }
}