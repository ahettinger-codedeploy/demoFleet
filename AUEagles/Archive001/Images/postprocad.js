var myOrd = Math.random()*10000000000000000;
var myTile = 0;
var myPTile = 0;

function procad(tag,isSync) {
   if(isSync){
	tag = addPTile(tag);
   }
   else{
	tag = addTile(tag);
   }
   tag = addOrd(tag);
   var nrJumpTag = tag.replace(/\/adj\//, "\/jump\/");
   var nrImageTag = tag.replace(/\/adj\//, "\/ad\/");
   document.writeln("<!--begin adver tag-->");
   document.writeln("<SCRIPT SRC=\"" + tag + "\" type=\"text/javascript\" language=\"JavaScript1.1\"></SCRIPT>");
   document.writeln("<noscript><a href=\"" + nrJumpTag + "\" target=\"_blank\"><img src=" + nrImageTag + "\">" );
   document.writeln("</a></noscript>");
   document.writeln("<!--end ad tag-->");
   var fullTag = ("<!--begin adver tag -->");
   fullTag = fullTag + ("<SCRIPT SRC=\"" + tag + "\" type=\"text/javascript\" language=\"JavaScript1.1\"></SCRIPT>");
   fullTag = fullTag + ("<noscript><a href=\"" + nrJumpTag + "\" target=\"_blank\"><img src=\"" + nrImageTag + "\">" );
   fullTag = fullTag + ("</a></noscript>");
   fullTag = fullTag + ("<!--end ad tag-->");
//alert(fullTag);
}

function addPTile(tag) {
	if(myPTile == 16){
		return tag;
		}
	myPTile = myPTile + 1;
	if(myPTile < 2){
		var pTileTag = 'ptile=' + myPTile + ';dcopt=ist';
		}
	else{
		var pTileTag = 'ptile=' + myPTile;
		}
	tag = tag.replace(/dcopt=ist/g, pTileTag);
	return tag;
}

function addTile(tag) {
	if(myTile == 16){
		return tag;
		}
	myTile = myTile + 1;
	if(myTile < 2){
                var tileTag = 'tile=' + myTile + ';dcopt=ist';
                }
        else{
                var tileTag = 'tile=' + myTile;
                }
	tag = tag.replace(/dcopt=ist/g, tileTag);
	return tag;
}

function addOrd(tag) {
	var ordTag = 'ord=' + myOrd + "?";
	tag = tag + ordTag;
	return tag;
}
