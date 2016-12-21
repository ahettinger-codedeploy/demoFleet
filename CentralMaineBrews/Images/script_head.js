function roll(target, descrip, io) {
  var path = "document.getElementById(\"" + target + "\")";
  var button = "images/b_" + target + "_" + io + ".gif";
  eval(path).src = button;
  document.getElementById("menuhead").innerHTML = descrip;
}

// slide show
var slide = 1; var totalSlides = 14;
function slideShow() {
  var strip = "";
  for (i = slide; i <= totalSlides; i++) {
    strip += "<img class='wframe' src='sidebar/p" + i + ".jpg' width='200' height='118' alt='Central Maine Brew Fest' />"
  }
  for (i = 1; i < slide; i++) {
    strip += "<img class='wframe' src='sidebar/p" + i + ".jpg' width='200' height='118' alt='Central Maine Brew Fest' />"
  }
  document.getElementById("sidebar").innerHTML = strip;
  slide++;
  if (slide > totalSlides) {slide = 1}
}

function check(target) { // afternoon = true, evening = false
  var checked = "document.getElementById(\"fest" + target + "\")";
  var unchecked = "document.getElementById(\"fest" + !target + "\")";
  eval(checked).src = "images/check_on.gif";
  eval(unchecked).src = "images/check_off.gif";
  if (target == true) {
    document.getElementById("RefID").value = "Attending afternoon festival";
  } else {
    document.getElementById("RefID").value = "Attending evening festival";
  }
}

function priceCalc() {
  var quantity = document.getElementById("Quantity").value;
  var noAllow = quantity.indexOf(".") + quantity.indexOf("-") + quantity.indexOf("e");
  if (quantity == 0 || noAllow > -3) {quantity = "NaN"}
  if (!isNaN(quantity)) {
    document.getElementById("Quantity").value = quantity;
    var sub = quantity * 28.5;
    var price = (quantity * 28.5 + .001).toString();
    price = price.substr(0, price.indexOf(".") + 3);
    document.getElementById("price").innerHTML = "$" + price;
    document.getElementById("Amount").value = sub;
    document.getElementById("USER1").value = quantity;
  } else { // clear values
    document.getElementById("Quantity").value = "";
    document.getElementById("price").innerHTML = "&nbsp;";
    document.getElementById("Amount").value = "";
    document.getElementById("USER1").value = "";
  }
}

function repeatInfo() {
  document.getElementById("NameonAccount").value = document.getElementById("N").value;
  document.getElementById("AVSADDR").value = document.getElementById("A").value + ", " + document.getElementById("C").value + ", " + document.getElementById("S").value;
  document.getElementById("AVSZIP").value = document.getElementById("Z").value;
}

function validate() {
  if (document.getElementById("N").value.length == 0 ||
      document.getElementById("A").value.length == 0 ||
      document.getElementById("C").value.length == 0 ||
      document.getElementById("S").value.length == 0 ||
      document.getElementById("Z").value.length == 0 ||
      document.getElementById("NameonAccount").value.length == 0 ||
      document.getElementById("AVSADDR").value.length == 0 ||
      document.getElementById("AVSZIP").value.length == 0 ||
      document.getElementById("AccountNo").value.length == 0 ||
      document.getElementById("Email").value.length == 0 ||
      document.getElementById("Quantity").value.length == 0 ||
      document.getElementById("RefID").value.length == 0) {
      alert("A required field hasn't been filled.");
  } else {
   // generate full mailing address
      var sendto = "";
      sendto += escape(document.getElementById("A").value) + ", ";
      sendto += escape(document.getElementById("C").value) + ", ";
      sendto += escape(document.getElementById("S").value) + " ";
      sendto += escape(document.getElementById("Z").value);
      document.getElementById("USER3").value = sendto;
      var billto = "";
      billto += escape(document.getElementById("AVSADDR").value) + ", ";
      billto += escape(document.getElementById("AVSZIP").value);
      document.getElementById("USER4").value = billto;
   // gereate thank-you page info
      var goto = "https://www.centralmainebrews.com/tickets.php?";
      goto += "N=" + escape(document.getElementById("N").value) + "&";
      goto += "A=" + escape(document.getElementById("USER3").value) + "&";
      goto += "B=" + escape(document.getElementById("USER4").value) + "&";
      goto += "E=" + escape(document.getElementById("Email").value) + "&";
      goto += "Q=" + escape(document.getElementById("USER1").value) + "&";
      goto += "T=" + escape(document.getElementById("RefID").value);
      document.getElementById("CCRURL").value = goto;
   }
}

function email() {
  var sequence = "116105099107101116115064099101110116114097108109097105110101098114101119115046099111109"
  var string = ""; var index = 0;
  while (sequence.charAt(index) != "") {
    var code = parseFloat(sequence.substr(index, 3));
    string += String.fromCharCode(code);
    index += 3;
  }
  return string;
}