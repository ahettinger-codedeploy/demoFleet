// JavaScript Document
// subnav - Javascript for greenberg theatre
// Show and Hide an object based on it's ID
function show(object) {
    if (document.getElementById && document.getElementById(object) != null){
         node = document.getElementById(object).style.visibility='visible';
    }else if (document.layers && document.layers[object] != null){
        document.layers[object].visibility = 'visible';
    }else if (document.all){
        document.all[object].style.visibility = 'visible';
    }
}
function hide(object) {
    if (document.getElementById && document.getElementById(object) != null){
        node = document.getElementById(object).style.visibility='hidden';
    }else if (document.layers && document.layers[object] != null){
        document.layers[object].visibility = 'hidden';
    }else if (document.all){
        document.all[object].style.visibility = 'hidden';
    }
}

// write text to status bar and clear text from status bar
function statusmessage(text){
    window.status = text;
}
function clearstatus(){
    window.status = "";
}

// site specific show/hide element management scripts
function showsection(num){
	hide("sn"+currentsection);
	show("sn"+num);
	currentsection=num;
}

//sn = sub nav shortheand
function snon(){
   show("sn1");
   hide("sn2");
   hide("sn3");
   hide("sn4");
   hide("sn5");
   hide("sn6");
   currentsn=1;
}
function snoff(){
   hide("sn1");
   hide("sn2");
   hide("sn3");
   hide("sn4");
   hide("sn5");
   hide("sn6"); 
   currentsn=1;
}


// variables for site management tracking
var currentsection=1;
var currentsn=1;