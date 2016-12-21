function expand(s, classSelected, classShow)
{
  var td = s;
  var d = td.getElementsByTagName("div").item(0);

  td.className = classSelected;
  d.className = classShow;
}

function collapse(s, classNormal, classHide)
{
  var td = s;
  var d = td.getElementsByTagName("div").item(0);

  td.className = classNormal;
  d.className = classHide;
}