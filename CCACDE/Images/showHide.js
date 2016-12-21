// JavaScript Document

function showHide(theID){

if(document.getElementById(theID).style.display=="none"){
    document.getElementById(theID).style.display="block"
}else{
    document.getElementById(theID).style.display="none"   
}
return;
}