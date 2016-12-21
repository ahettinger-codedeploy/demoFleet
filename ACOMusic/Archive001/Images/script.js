var ShipFirst = "";
var ShipLast = "";
var ShipMiddle = "";
var ShipCompany = "";
var ShipAddress1 = "";
var ShipAddress2 = "";
var ShipCity = "";
var ShipState = "";
var ShipStateIndex = 0;
var ShipZip = "";
var ShipCountry = "";
var ShipCountryIndex = 0;

function backup_shipping(form) {
	ShipFirst = form.shipping_firstname.value;
	ShipLast = form.shipping_lastname.value;
	ShipMiddle = form.shipping_middlename.value;
	ShipCompany = form.shipping_company.value;
	ShipAddress1 = form.shipping_address.value;
	ShipAddress2 = form.shipping_address2.value;
	ShipCity = form.shipping_city.value;
	ShipZip = form.shipping_zip.value;
	ShipStateIndex = form.shipping_state.selectedIndex;
	ShipState = form.shipping_state[ShipStateIndex].value;
	ShipCountryIndex = form.shipping_state.selectedIndex;
	ShipCountry = form.shipping_country[ShipCountryIndex].value;
}

function same_as_billing(form) {
	if (form.sameaddress.checked) {
		backup_shipping(form);
		form.shipping_firstname.value = form.firstname.value;
		form.shipping_lastname.value = form.lastname.value;
		form.shipping_middlename.value = form.middlename.value;
		form.shipping_company.value = form.company.value;
		form.shipping_address.value = form.address.value;
		form.shipping_address2.value = form.address2.value;
		form.shipping_city.value = form.city.value;
		form.shipping_zip.value = form.zip.value;
		form.shipping_state.selectedIndex = form.state.selectedIndex;
		form.shipping_country.selectedIndex = form.country.selectedIndex;
	}else {
		form.shipping_firstname.value = ShipFirst;
		form.shipping_lastname.value = ShipLast;
		form.shipping_middlename.value = ShipMiddle;
		form.shipping_company.value = ShipCompany;
		form.shipping_address.value = ShipAddress1;
		form.shipping_address2.value = ShipAddress2;
		form.shipping_city.value = ShipCity;
		form.shipping_zip.value = ShipZip;       
		form.shipping_state.selectedIndex = ShipStateIndex;
		form.shipping_country.selectedIndex = ShipCountryIndex;
	}
}

function echeck(str) {
	var at="@";
	var dot=".";
	var lat=str.indexOf(at);
	var lstr=str.length;
	var ldot=str.indexOf(dot);
	if(str.indexOf(at)==-1){
		return false;
	}
	if(str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr){
		return false;
	}
	if(str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr){
		return false;
	}
	if(str.indexOf(at,(lat+1))!=-1){
		return false;
	}
	if(str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot){
		return false;
	}
	if(str.indexOf(dot,(lat+2))==-1){
		return false;
	}
	if(str.indexOf(" ")!=-1){
		return false;
	}
	return true;				
}

function verifyCheckout(form,step){
	var errormsg = new Array();
	
	if(!form.firstname.value){
		errormsg.push("Billing first name");
	}
	if(!form.lastname.value){
		errormsg.push("Billing last name");
	}
	if(!form.address.value){
		errormsg.push("Billing address");
	}
	if(!form.city.value){
		errormsg.push("Billing city");
	}
	if(!form.state.value){
		errormsg.push("Billing state");
	}
	if(!form.zip.value){
		errormsg.push("Billing zip");
	}
	if(!form.country.value){
		errormsg.push("Billing country");
	}
	if(!form.phone.value){
		errormsg.push("Contact phone number");
	}
	if(!form.shipping_firstname.value){
		errormsg.push("Shipping first name");
	}
	if(!form.shipping_lastname.value){
		errormsg.push("Shipping last name");
	}
	if(!form.shipping_address.value){
		errormsg.push("Shipping address");
	}
	if(!form.shipping_city.value){
		errormsg.push("Shipping city");
	}
	if(!form.shipping_state.value){
		errormsg.push("Shipping state");
	}
	if(!form.shipping_zip.value){
		errormsg.push("Shipping zip");
	}
	if(!form.shipping_country.value){
		errormsg.push("Shipping country");
	}
	if(!echeck(form.email.value)){
		errormsg.push("Properly Formated Email Address");
	}
	if(step >= 2){
		if(!form.cardnumber.value){
			errormsg.push("Credit Card Number");
		}
		if(!form.expm.value){
			errormsg.push("Credit Card Expiration Month");
		}
		if(!form.expy.value){
			errormsg.push("Credit Card Expiration Year");
		}
	}
	
	if(errormsg.length > 0) {
		if(errormsg.length > 1) { ess = 's'; }
		var message = new String('\n\nThe following field' + ess + ' are required:\n');
		for(var i = 0; i < errormsg.length; i++){ message += '\n' + errormsg[i]; }
		alert(message);
		return false;
	}
	
	if (document.getElementById("agreecheckbox") != null)
	{
		if (document.getElementById("agreecheckbox").checked != true)
		{
			document.getElementById("agreecheckboxlabel").style.color = "#FF0000";	
			alert('Please Accept The Terms and Conditions');
			return false;
		}
	}
	
	
}

if(typeof(cFlash) == 'undefined'){
	function cFlash(swf, version, width, height, id){
		this.generateId = function(l){
			if (!l) l = 10;
			var s = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890-_';
			var out = '';
			while(l--){
				out += s.substr(Math.round(Math.random() * s.length), 1);
			}
			return out;
		}
		
		this.setParameter = function(p, v){
			this.parameters[p] = v;
		}
		
		this.getParameter = function(p){
			if (!this.parameters[p]) return false;
			return this.parameters[p];
		}
		
		this.setAttribute = function(a, v){
			this.attributes[a] = v;
		}
		
		this.getAttribute = function(a){
			if (!this.attributes[a]) return false;
			return this.attributes[a];
		}
		
		this.setVariable = function(fv, v){
			this.variables[fv] = v;
		}
		
		this.getVariable = function(fv){
			if (!this.variables[fv]) return false;
			return this.variables[fv];
		}
		
		this.getVariables = function(){
			var v, out = [];
			for(v in this.variables){
				if (!this.variables[v]) continue;
				out.push(v + '=' + this.variables[v]);
			}
			return out.join('&');
		}
		
		this.getFlashVersion = function(){
			if (this.__fv == null){
				var e, p, version = 0;
				if (this.AX){
					e  = 'try';
					e += '{';
					e += '	p = new ActiveXObject("ShockwaveFlash.ShockwaveFlash");';
					e += '	version = p.GetVariable("$version").split(" ")[1].split(",")[0];';
					e += '}';
					e += 'catch(err){}';
					eval(e);
				}else{
					p = navigator.plugins['Shockwave Flash'];
					if (p && p.description){
						version = p.description.replace(/([a-z]|[A-Z]|\s)+/, '').replace(/(\s+r|\s+b[0-9]+)/, '.').split('.')[0];
					}
				}
				this.__fv = version;
			}
			return this.__fv;
		}
		
		this.canDisplay = function(){
			return (this.getAttribute('version') <= this.getFlashVersion());
		}
		
		this.getFlashHTML = function(){
			var html = '', k, variables;
			variables = this.getVariables();
			if (this.AX){
				html  = '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" ';
				html += 'id="' + this.id + '" ';
				html += 'width="' + this.getAttribute('width') + '" ';
				html += 'height="' + this.getAttribute('height') + '">';
				
				html += '<param name="movie" value="' + this.getAttribute('swf') + '" />';
				
				for(var k in this.parameters){
					html += '<param name="' + k + '" value="' + this.parameters[k] + '" />';
				}
				
				if (variables) html += '<param name="flashvars" value="' + variables + '" />';
				
				html += '</object>';
			}else{
				html  = '<embed type="application/x-shockwave-flash" ';
				html += 'id="' + this.id + '" ';
				html += 'src="' + this.getAttribute('swf') + '" ';
				html += 'width="' + this.getAttribute('width') + '" ';
				html += 'height="' + this.getAttribute('height') + '"';
				
				for(var k in this.parameters)
				{
					html += ' ' + k + '="' + this.parameters[k] + '"';
				}
				
				if (variables) html += ' flashvars="' + variables + '"';
				
				html += '></embed>';
			}
			
			return html;
		}
		
		this.setAltHTML = function(s){
			this.altHTML = s;
		}
		
		this.getAltHTML = function(){
			if (!this.altHTML){
				var h = '<p style="text-align:center">This section of this page requires Macromedia Flash Player ' + this.getAttribute('version') + '.';
				h += '<br /><br /><a href="http://www.macromedia.com/go/getflashplayer" target="_blank">Get Flash Player</a></p>';
				return h;
			}
			return this.altHTML;
		}
		
		this.getElement = function(id){
			if (!document.getElementById){
				if (document.all) return document.all(i);
				if (document.layers) return document.layers[i];
				return null;
			}
			return document.getElementById(id);
		}
		
		this.writeIn = function(id){
			var obj = this.getElement(id);
			if (this.canDisplay()){
				obj.innerHTML = this.getFlashHTML();
				this.__fo = this.getElement(this.id);
				return true;
			}else{
				obj.innerHTML = this.getAltHTML();
				return false;
			}
		}
		
		this.__fo = null;
		this.__fv = null;
		this.altHTML = '';
		
		this.parameters = {};
		this.attributes = {};
		this.variables = {};
		this.AX = (window.ActiveXObject ? true : false);
		if (swf) this.setAttribute('swf', swf);
		
		this.setAttribute('version', 6);
		if (version) this.setAttribute('version', version);
		
		if (!width) width = '100%';
		if (!height) height = '100%';
		this.setAttribute('width', width);
		this.setAttribute('height', height);
		
		if (!id) id = this.generateId();
		this.id = id;
		this.setParameter('name', id);
		
		this.__fo = this.getElement(this.id);
	}	
}

