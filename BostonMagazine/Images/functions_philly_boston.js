/*---- Add Print Page ------ */
function addPrintPage(){
	if(!document.getElementById){return;}
	
	if(document.getElementById("utility")){
		var container = document.getElementById("utility");
		var supplements = container.getElementsByTagName("ul");
	}else{return;}
	var print_li = document.createElement("li");
	print_li.setAttribute("id", "print");
	var print_a = document.createElement("a");
	print_a.setAttribute("href", "javascript:window.print();");
	var print_txt = document.createTextNode("Print This Page");
	print_a.appendChild(print_txt);
	print_li.appendChild(print_a);
	if(supplements[0]){
		supplements[0].appendChild(print_li);
	}
}

/*---- Add Print Asset ------ */
function addPrintAsset(){
	if(!document.getElementById){
		return;
	}
	
	if(document.getElementById("utility")){
		var container = document.getElementById("utility");
		var supplements = container.getElementsByTagName("ul");
	}else{
		return;
	}
	var print_li = document.createElement("li");
	print_li.setAttribute("id", "print");
	var print_a = document.createElement("a");
	print_a.setAttribute("href", "javascript:printAsset();");
	var print_txt = document.createTextNode("Print This Article");
	print_a.appendChild(print_txt);
	print_li.appendChild(print_a);
	if(supplements[0]){
		supplements[0].appendChild(print_li);
	}
}

function printAsset() {
	closeWindow();
	openWindow('/scripts/print/article.php?asset_idx='+main_asset_idx+'');
}

/* ------ end Add Print Link ------- */


/*---- Table Striping ------ */
function storeTables(){ //finds tables to stripe
	if(!document.getElementById || !document.getElementsByTagName){return;}
	
	var tables = document.getElementsByTagName("table");
	
	for(var i = 0; i < tables.length; i++){
		if(tables[i].className == "striped"){stripeTable(tables[i]);}
	}
}

function stripeTable(tableToStripe){
	var rows = tableToStripe.getElementsByTagName("tr");
	
	for(var i = 2; i < rows.length; i+=2){
		addClass(rows[i], "even");
	}
}
/* ------ end Table Striping ------- */



/*---- Grey Initial Values ------ */

function greyInitialValues(){
	
	var filled = getElementsByClassName("filled");
	
	if(filled.length > 0){
		for(var i = 0; i < filled.length; i++){
			//filled[i].className = "empty";
			filled[i].setAttribute("class", "notfilled");
			filled[i].initialValue = filled[i].value;
			
			filled[i].onclick = filled[i].onfocus = function(){
				//this.className = "filled";
				this.setAttribute("class", "filled");
				if(this.value == this.initialValue){
					this.value= "";
				}
			}
			
			filled[i].onblur = function(){
				if(this.value == this.initialValue || this.value == ""){
					//this.className = "empty";
					this.setAttribute("class", "notfilled");
					this.value = this.initialValue;
				}else{
					//this.className = "filled";
					this.setAttribute("class", "filled");
				}
			}
		}
	}else{return;}
}

/* ------ Grey Initial Values ------- */

/*---- Advanced Search Hide/Show ------ */
function hideShowAdvancedSearch() {
	var div = document.getElementById("advanced_search");
	var links = div.getElementsByTagName("a");
	for(var i=0; i<links.length; i++) {
		if(links[i].className.match(/searchParent/i)) {
			links[i].onclick=function() {
				if(this.parentNode.nextSibling.nextSibling.style.display == "block") {
					this.parentNode.nextSibling.nextSibling.style.display = "none";
				} else {
					this.parentNode.nextSibling.nextSibling.style.display = "block";
				}
				return false;
			}
		}
	}
}
/* ------ end Advanced Search Hide/Show ------- */

/*Pop-Up*/
<!-- hide the script from dinosaurs --
//popup window script -------------------------------------

var popUpWin
var isIE3
var isIE3 = (navigator.appVersion.indexOf("MSIE 3") != -1) ? true : false

function openWindow(url) {
        popUpWin = window.open(url,popUpWin,"height=600,width=650,channelmode=0,dependent=0,directories=0,fullscreen=0,location=0,menubar=1,resizable=1,scrollbars=1,status=0,toolbar=0", "pop");
        if (popUpWin.opener == null) {
                popUpWin.opener = window
        }
        if (navigator.appName == 'Netscape') {
        popUpWin.focus();
        }
}
function closeWindow() {

        if (isIE3) {
                popUpWin = window.open("/blank.html","TechSpecs","toolbar=no,location=0,directories=0,status=no,menubar=no,scrollbars=no,resizable=no,height=1,width=1")
        }

        if (popUpWin && !popUpWin.closed) {
                popUpWin.close()
        }
        popUpWin = ""
}
// ice age begins -->
