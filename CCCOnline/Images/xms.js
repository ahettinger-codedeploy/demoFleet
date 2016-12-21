var XMS = {
	path : '/xms/jscripts/',
	url_root : '/',
	loaded : false,
	xmodules : {cookie:{m:1},lightbox:{m:1,d:['builder','effects']},
				calendar:{m:1},colorpicker:{m:1},wysiwyg:{m:'fckeditor/fckeditor.js'},filemanager:{m:'ckfinder/ckfinder.js'},swfobject:{m:1}},
	pagids : {},
	basic_chars : 'abcdefghijklmnopqrstuvwxyz0123456789 ',
	
	require: function(libraryName) {
		document.write('<script type="text/javascript" src="'+libraryName+'"><\/script>');
	},

	load: function() {
		if(typeof Prototype=='undefined') {
			throw("XMS requires the Prototype JavaScript framework");
			return false;
		}
		
		this.pageLoadedBIND = this.pageLoaded.bindAsEventListener(this);
		Event.observe(window, 'load', this.pageLoadedBIND);
		
		$A(document.getElementsByTagName("script")).findAll( function(s) {
			return (s.src && s.src.match(/xms\.js(\?.*)?$/));
		}).each( (function(s) {
			this.path = s.src.replace(/xms\.js(\?.*)?$/,'');
			var modu = s.src.match(/\?.*load=([a-z,]*)/);
			var minc = {};
			
			this.url_root = this.path.split('/xms').first() + '/';
			
			if(typeof modu[1] != 'undefined' && modu[1]) {
				var incs = modu[1].split(',');
				for (var i=0; i < incs.length; i++) {
					if(typeof minc[incs[i]] == 'undefined') {
						if(typeof this.xmodules[incs[i]] != 'undefined') { // XMS Module
							if(this.xmodules[incs[i]].m != 1) { // specific path
								this.require(this.path+this.xmodules[incs[i]].m);
							} else { // modules folder
								this.require(this.path+'modules/'+incs[i]+'.js');
							}
							if(typeof this.xmodules[incs[i]].d != 'undefined') { // check/add dependencies
								for(var d=0; d<this.xmodules[incs[i]].d.length; d++) {
									incs[incs.length] = this.xmodules[incs[i]].d[d];
								}
							}
						} else {
							this.require(this.path+'scriptaculous/'+incs[i]+'.js');
						}
						minc[incs[i]] = true;
					}
				}
			}
		}).bind(this));
	},
	
	pageLoaded : function() {
		if(Prototype.Browser.IE) {
			$$('input[type="checkbox"]').each(function(c){c.observe('change',function(event){this.defaultChecked = this.checked})});
		}

		var xmselm = $$('.xms');
		var aval = {
			wysiwyg : (typeof FCKeditor != 'undefined'),
			calendar : (typeof Calendar != 'undefined'),
			colorpicker : (typeof Colorpicker != 'undefined'),
			filemanager : (typeof CKFinder != 'undefined')
		};
		
		for (var i=0; i < xmselm.length; i++) {
			if(aval.wysiwyg && xmselm[i].hasClassName('wysiwyg')) {
				this.fcktextarea(xmselm[i]);
			} else if(aval.calendar && xmselm[i].hasClassName('calendar')) {
				Calendar.add(xmselm[i]);
			} else if(aval.colorpicker && xmselm[i].hasClassName('colorpicker')) {
				Colorpicker.add(xmselm[i]);
			} else if(aval.filemanager && xmselm[i].hasClassName('filemanager')) {
				this.ckfinder(xmselm[i]);
			}
		}
		
		document.fire('xms:load');
		document.loaded = true;
		Event.stopObserving(window, 'load', this.pageLoadedBIND);
	},
	
	pagjax : function(lnk, doc, id, page) {
		this.pagids[id] = page;
		new Ajax.Request(this.url_root + 'xms/request.php/ajax/result_tag/' + doc, {
			method: 'post',
			parameters : {id : id, url : lnk.href, page : page},
			onSuccess: function(transport) {
				if(transport.responseText) {
					var resp = transport.responseText.split('<!--respagsp-->');
					var dv = $(id);
					var pag = $('__'+id+'_pagination');
					if(dv) {
						dv.update(resp[0]);
						if(pag) {
							pag.update(resp[1]);
						}
					} else {
						alert('Cannot find object "'+id+'"');
					}
				}
			}
		});
		return false;
	},
	
	pagjaxr : function(lnk, doc, id) {
		var page = 1;
		if(typeof this.pagids[id] != 'undefined') page = this.pagids[id];
		this.pagjax(lnk, doc, id, page);
	},
	
	submit_framejax : function(frm, code) {
		if(typeof this.apploading != 'undefined' && this.apploading == true) return false;

		var dobj = new Date();
		var cmil = dobj.getTime();
		var newurl = this.url_root + 'xms/request.php/ajax/app_tag/' + code + '/' + frm.action.explode(window.location.hostname+'/', 2).last();
		var old_target = frm.target;
		var old_action = frm.action;
		
		document.fire('xms:app:submit');
		
		if(typeof this.app_ifrmid == 'undefined') {
			this.app_ifrmid = 'app_frame_' + cmil;
			$$('body')[0].insert(new Element('iframe', {id : this.app_ifrmid, name : this.app_ifrmid, width: 0, height: 0}).hide());
		}

		var ifrmid = this.app_ifrmid;
		var ifrm = $(ifrmid);
		frm.target = ifrmid;
		frm.action = newurl;
		this.apploading = true;

		ifrm.observe('load', function() {
			if(ifrm.contentWindow.location != 'about:blank') {	
				var inHTML = ifrm.contentWindow.document.body.innerHTML.toString();
				if(inHTML.substr(0, 2) == 'OK') {
					var response = unescape(inHTML).split("\n");
					var pid = response[0].split(':')[1];
					var fields = {};
					var xerrors = response[1].split(',');
					var xoerrors = {};
					var xofiles = {};
					response[2] = response[2].strip();
					if(frm.elements.length > 0) {
						for(var i=0; i<frm.elements.length; i++) if(frm.elements[i].name) fields[frm.elements[i].name] = $(frm.elements[i]);
						for(var r=1; r<xerrors.length; r++) xoerrors[xerrors[r]] = true;
						for(var m=3; m<response.length; m++) {
							var xfiles = response[m].explode(',', 2);
							if(xfiles[0] != '') xofiles[xfiles[0]] = xfiles[1];
						}
						if(response[2] == '' || xerrors.length > 1) {
							for(var fn in fields) {
								if(typeof xoerrors[fn] != 'undefined' && xoerrors[fn]) {
									if(! fields[fn].hasClassName('xerror')) fields[fn].addClassName('xerror');
								} else {
									if(fields[fn].hasClassName('xerror')) fields[fn].removeClassName('xerror');
								}
								if(xerrors.length < 2 && typeof xofiles[fn] != 'undefined') {
									fields[fn].removeSiblingsUntil('span').insert({before: xofiles[fn]}).hardReset();
								}
							}
						}
						if(xerrors.length < 2 && response[2] != '') {
							document.location.href = response[2];
						}
					}
					
					document.fire('xms:app:finish', {errors: xerrors, primary: pid});
				} else {
					alert(inHTML.stripTags());
				}
				
				ifrm.stopObserving('load');
				this.apploading = false;
				frm.action = old_action;
			}
		}.bindAsEventListener(this));

		return true;
	},
	
 	fcktextarea : function(oTextarea) {
		oTextarea = $(oTextarea);
		var tbid = oTextarea.identify();
		var tbsize = oTextarea.getDimensions();
		var oFCKeditor = new FCKeditor(tbid, tbsize.width, tbsize.height);
		oFCKeditor.BasePath	=  this.url_root + 'xms/jscripts/fckeditor/';
		oFCKeditor.ToolbarSet = 'XMS';
		oFCKeditor.ReplaceTextarea();
	},
	
	ckfinder : function(input) {
		if(imageonly = input.hasClassName('imageonly')) icon = 'image.png';
		else icon = 'browse.png';
		
		input.insert({after: new Element('img', {src : XMS.url_root + 'xms/images/' + icon, style : 'cursor: pointer', border : 0}).observe('click',
			(function() {
				var finder = new CKFinder() ;
				if(imageonly) finder.resType = 'Images';
				finder.BasePath = this.url_root + 'xms/jscripts/ckfinder/';
				//finder.SelectFunction = SetFileField ; TBD: finish this
				finder.Popup() ;
			}).bindAsEventListener(this)
		)});
	},

	highlight_fields : function(clsname) {
		var fields = $$('.xerror');
		var fnt, label, message;
		for(var i=0; i < fields.length; i++) {
			fnt = fields[i].name.replace(/\]\[|\[|\]/g, ':') + ':';
			fnt = fnt.replace('::', ':');
			label = $(fnt+'LABEL')
			if(clsname && label) {
				label.addClassName(clsname);
			}
			message = $(fnt+'MESSAGE');
			if(message) {
				message.show();
			}
		}
	},
	
	chars_only : function(e, chars) {
		var code;
		if (!e) var e = window.event;
		if (e.keyCode) code = e.keyCode;
		else if (e.which) code = e.which;
		var ch = String.fromCharCode(code).toUpperCase();
		chars = chars.toUpperCase();
		for(var i=0; i<chars.length; i++) {
			if(chars[i] == ch) {
				return true;
			}
		}
		return false;
	},
	
	numbers_only : function(e) {
		var code;
		if (!e) var e = window.event;
		if (e.keyCode) code = e.keyCode;
		else if (e.which) code = e.which;
		if( ! (code < 48 || code > 57) || (code >= 37 && code <= 40) 
		|| code == 8 || code == 9) {
			return true;
		} else {
			return false;
		}
	},

	decimals_only : function(e) {
		var code;
		if (!e) var e = window.event;
		if (e.keyCode) code = e.keyCode;
		else if (e.which) code = e.which;
		if( ! (code < 48 || code > 57) || (code >= 37 && code <= 40) 
		|| code == 8 || code == 9 || code == 46 ) {
			return true;
		} else {
			return false;
		}
	},

	no_submit : function(e) {
		var code;
		if (!e) var e = window.event;
		if (e.keyCode) code = e.keyCode;
		else if (e.which) code = e.which;
		if(code != 13) {
			return true;
		} else {
			return false;
		}
	}
}

String.prototype.explode = function(delimiter, limit) {	
	if (typeof limit == 'undefined' || ! limit) {
		return this.split(delimiter);
    } else {
        var splitted = this.split(delimiter);
		if(splitted.length > limit) {
        	var s1 = splitted.splice(0, limit - 1);
        	var s2 = splitted.join(delimiter);
        	s1.push(s2);
        	return s1;
		} else {
			return splitted;
		}
    }
}

var XMSElement = {
	removeSiblingsUntil: function(element, selector){
		element = $(element);
		var prevSibs = element.previousSiblings();
		for(var i=0; i < prevSibs.length; i++) { if(prevSibs[i]) {
			if(prevSibs[i].match(selector)) {
				prevSibs[i].remove();
				break;
			} else {
				prevSibs[i].remove();
			}
		}}
		return element;
	}
}

var XMSFormElement = {
	hardReset : function(element) {
		if(element.parentNode) {
			if(Prototype.Browser.IE) {
				var newElement = element.cloneNode(false);
				element.parentNode.replaceChild(newElement,element);
				return $(newElement);
			} else if(! Prototype.Browser.Opera) {
				return $(element).clear();
			} else {
				var wrapper = new Element('span');
			    wrapper.appendChild(element.cloneNode(false));
				wrapper.innerHTML = wrapper.innerHTML; // only hope
				var newElement = wrapper.firstChild.cloneNode(false);
				element.parentNode.replaceChild(newElement,element);
			    return $(newElement);
			}
		} else {
			return $(element).clear();
		}
	}
}

Element.addMethods(XMSElement);
Element.addMethods('input', XMSFormElement);

XMS.load();

function number_format(number, decimals, dec_point, thousands_sep) { 
    var n = number, c = isNaN(decimals = Math.abs(decimals)) ? 2 : decimals;
    var d = dec_point == undefined ? "." : dec_point;
    var t = thousands_sep == undefined ? "," : thousands_sep, s = n < 0 ? "-" : "";
    var i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", j = (j = i.length) > 3 ? j % 3 : 0;
    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
}

function dollar_format(num) {return number_format(num, 2, '.', ',');}

function reset_all_forms() {
	$$('form').each(function(f) {f.reset();});
}