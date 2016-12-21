objects = document.getElementsByTagName("object");
for (var i = 0; i < objects.length; i++)
{
    objects[i].outerHTML = objects[i].outerHTML;
}
//add to pages below last <object> <script type="text/javascript" src="/ieupdate.js"></script>