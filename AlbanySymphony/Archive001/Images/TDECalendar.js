		YAHOO.namespace("VisualCalendar");
		var calendarArray = new Array();
		
		function configLanguage(lang){
			var ms,	ml, wc,ws, wm, wl;
				switch(lang){
					case "DE":
						ms = ["Jan", "Feb", "Mär", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dez"];
						ml = ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"];
						wc = ["S", "M", "D", "M", "D", "F", "S"];
						ws = ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"];
						wm = ["Son", "Mon", "Die", "Mit", "Don", "Fre", "Sam"];
						wl = ["Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"];
					break;
					case "SP":
						ms = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"];
						ml = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
						wc = ["D", "L", "M", "M", "J", "V", "S"];
						ws = ["Do", "Lu", "Ma", "Mi", "Ju", "Vi", "Sa"];
						wm = ["Dom", "Lun", "Mar", "Mie", "Jue", "Vie", "Sab"];
						wl = ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"];
					break;
					case "FR":
						ms = ["Jan", "Fév", "Mar", "Avr", "Mai", "Jui", "Jui", "Aoû", "Sep", "Oct", "Nov", "Déc"];
						ml = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"];
						wc = ["D", "L", "M", "M", "J", "V", "S"];
						ws = ["Di", "Lu", "Ma", "Me", "Je", "Ve", "Sa"];
						wm = ["Dim", "Lun", "Mar", "Mer", "Jeu", "Ven", "Sam"];
						wl = ["Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"];
					break;
					case "IT":
						ms = ["Gen", "Feb", "Mar", "Apr", "Mag", "Giu", "Lug", "Aug", "Set", "Ott", "Nov", "Dic"];
						ml = ["Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno", "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"];
						wc = ["D", "L", "M", "M", "G", "V", "S"];
						ws = ["Do", "Lu", "Ma", "Me", "Gi", "Ve", "Sa"];
						wm = ["Dom", "Lun", "Mar", "Mer", "Gio", "Ven", "Sab"];
						wl = ["Domenica", "Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì", "Sabato"];
					break;
					case "JP":
						ms = ["1·î", "2·î", "3·î", "4·î", "5·î", "6·î", "7·î", "8·î", "9·î", "10·î", "11·î", "12·î"];
						ml = ["1·î", "2·î", "3·î", "4·î", "5·î", "6·î", "7·î", "8·î", "9·î", "10·î", "11·î", "12·î"];
						wc = ["Æü", "·î", "²Ð", "¿å", "ÌÚ", "¶â", "ÅÚ"];
						ws = ["Æü", "·î", "²Ð", "¿å", "ÌÚ", "¶â", "ÅÚ"];
						wm = ["Æü", "·î", "²Ð", "¿å", "ÌÚ", "¶â", "ÅÚ"];
						wl = ["Æü", "·î", "²Ð", "¿å", "ÌÚ", "¶â", "ÅÚ"];
					break;
					default:
						return;
					break;
				}
				YAHOO.widget.myCalendar_Core.prototype.customConfig = function() {
				this.Config.Locale.MONTHS_SHORT = ms;
				this.Config.Locale.MONTHS_LONG = ml;
				this.Config.Locale.WEEKDAYS_1CHAR = wc;
				this.Config.Locale.WEEKDAYS_SHORT = ws;
				this.Config.Locale.WEEKDAYS_MEDIUM = wm;
				this.Config.Locale.WEEKDAYS_LONG = wm;
				}
		}	
		
		// Resets the year to its previous valid value when something invalid is entered
		function FixYearInput(YearField) {
			 var todayDate = new Date();	
		   var YearRE = new RegExp('\\d{' + 4 + '}');
		   if (!YearRE.test(YearField.value)) YearField.value = todayDate.getFullYear();
		}
		
		function showCalendar(calendarId) {
			var linkToCalendar = document.getElementById("dateLink"+calendarId);
			var calendarContainer = document.getElementById("VisualCalendar"+calendarId);
			var pos = YAHOO.util.Dom.getXY("dateLink"+calendarId);
			calendarContainer.style.display='block';
			YAHOO.util.Dom.setXY(calendarContainer, [pos[0],pos[1]+linkToCalendar.offsetHeight+1]);
		}

		function changeDate(calendarId) {
			var selMonth = document.getElementById("selMonth"+calendarId);
			var selDay = document.getElementById("selDay"+calendarId);
			var selYear = document.getElementById("selYear"+calendarId);
			var monthValue, dayValue, yearValue;
			
			if(selMonth.type=="select-one") monthValue = selMonth.selectedIndex+1;	
			else monthValue = selMonth.value;
			
			if(selDay.type=="select-one") dayValue = selDay.selectedIndex+1;	
			else dayValue = selDay.value;
			
			yearValue = selYear.value;
			calendarArray["VisualCalendar"+calendarId].select(monthValue + "/" + dayValue + "/" + yearValue);
			calendarArray["VisualCalendar"+calendarId].setMonth(monthValue-1);
			calendarArray["VisualCalendar"+calendarId].setYear(yearValue);
			calendarArray["VisualCalendar"+calendarId].render();
		}
		function htmlContruct(calendarId)
		{
		    var divCal = document.getElementById("containerVisualCalendar"+calendarId);
		    divCal.innerHTML = '<div id="VisualCalendar'+calendarId+'"><div  style="position:relative;"><div id="VisualCalendar'+calendarId+'Layer" style="display:none;position:absolute;border:1px solid #7B9EBD;background-color:#F7F9FB;left:6px;top:25px;padding:15px"><div id="VisualCalendar'+calendarId+'SelectAdd" name="VisualCalendar'+calendarId+'SelectAdd" style="display:none;"></div><div id="VisualCalendar'+calendarId+'SelectEdit" name="VisualCalendar'+calendarId+'SelectEdit" style="display:none;"><select id="VisualCalendar'+calendarId+'Select" name="VisualCalendar'+calendarId+'Select" onchange="renderselect(this,\'VisualCalendar'+calendarId+'\');"><option value="1">sdf</select></div><div><input type="text" name="VisualCalendar'+calendarId+'title" id="VisualCalendar'+calendarId+'title" value="Title" style="width:270px" /></div><textarea style="width:270px" name="VisualCalendar'+calendarId+'comment" id="VisualCalendar'+calendarId+'comment">Comment...</textarea><div style="text-align:left"><div id="VisualCalendar'+calendarId+'ButtonsAdd" name="VisualCalendar'+calendarId+'ButtonsAdd" style="display:none;float:left"><input type="button" name="save" value="Save" onclick="javascript:saveCalendar(\'VisualCalendar'+calendarId+'\')"/>&nbsp;<input type="button" name="cancel" value="Cancel" onclick="javascript:closeDivAdd(\'VisualCalendar'+calendarId+'\')"/></div><div id="VisualCalendar'+calendarId+'ButtonsEdit" name="VisualCalendar'+calendarId+'ButtonsEdit" style="display:none;float:left"><input type="button" name="edit" value="Save" onclick="javascript:editCalendar(\'VisualCalendar'+calendarId+'\')"/>&nbsp;<input type="button" name="del" value="Delete" onclick="javascript:deleteRangeVisual(\'VisualCalendar'+calendarId+'\')"/>&nbsp;<input type="button" name="canceledit" value="Cancel" onclick="javascript:closeDivAdd(\'VisualCalendar'+calendarId+'\')"/><br /><br /><b>Tip</b>: Use <b>&lt;br&gt;</b> for line break</div></div></div></div><input type="hidden" name="VisualCalendar'+calendarId+'range" id="VisualCalendar'+calendarId+'range" value=""/><input type="hidden" value="misdatos" name="xmldates" id="xmldates"></div><div id="VisualCalendar'+calendarId+'Events" class="eventlist" ></div>';
		    
	    }
	    function updateEventList(calendarId,type)
		{
		    var eventList = document.getElementById("VisualCalendar"+calendarId+"Events");
		    if (calendarArray["VisualCalendar"+calendarId].admin) 
		    {
		        if (type==-1)
		        {
		            eventList.innerHTML = '<a href="javascript:updateEventList(\''+calendarId+'\',1);"><img src="'+YAHOO.widget.myCalendar_Core.IMG_ROOT+'events.gif" border="0"></a>';
		            
		        }    
		        else
		        {	        
		            calID = "VisualCalendar"+calendarId;
		            var htmltext = '<div><div style="float:left"><a href="javascript:updateEventList(\''+calendarId+'\',1);"><div class="event-button">Month</div></a></div><div style="float:left"><a href="javascript:updateEventList(\''+calendarId+'\',0);"><div class="event-button">All</div></a></div><div style="float:right"><a href="javascript:updateEventList(\''+calendarId+'\',-1);"><img src="'+YAHOO.widget.myCalendar_Core.IMG_ROOT+'close.gif" border="0"></a></div><div style="clear:both"></div></div>';
			        for (i=0;i<calendarArray[calID].reservedDates.length;i++)
			        {
			            if (type==1)
			            {
			                r = getEnds(calendarArray[calID].reservedDates[i].range,calID);
			                current = calendarArray[calID].pageDate.getMonth();
			                if ((current == r[0].getMonth()) || (current == r[1].getMonth()))
			                   htmltext += "<font class=\"smallf\">"+calendarArray[calID].reservedDates[i].range+": </font><b>"+calendarArray[calID].reservedDates[i].title+"</b><br/> "+calendarArray[calID].reservedDates[i].comment+"<a href=\"javascript:deleteRangeList('"+calendarId+"','"+calendarArray[calID].reservedDates[i].range+"',"+type+")\"><img src=\""+YAHOO.widget.myCalendar_Core.IMG_ROOT+"delete.gif\" align=\"absmiddle\" alt=\"Delete\" border=\"0\"></a><br /><br />";
			            }
			            else
			                htmltext +=    "<font class=\"smallf\">"+calendarArray[calID].reservedDates[i].range+": </font><b>"+calendarArray[calID].reservedDates[i].title+"</b><br/> "+calendarArray[calID].reservedDates[i].comment+"<a href=\"javascript:deleteRangeList('"+calendarId+"','"+calendarArray[calID].reservedDates[i].range+"',"+type+")\"><img src=\""+YAHOO.widget.myCalendar_Core.IMG_ROOT+"delete.gif\" align=\"absmiddle\" alt=\"Delete\" border=\"0\"></a><br /><br />";
			        }
			        eventList.innerHTML = '<div class="yui-calcontainer">'+htmltext+'</div>';    
                }  
            }     
            
		    
	    }
		
		function initCalendar(calendarId,language, admin) {
		
		    
			htmlContruct(calendarId);
			calID = "VisualCalendar"+calendarId;
			
		    var todayDate = new Date();
			var selMonth = document.getElementById("selMonth"+calendarId);
			var selDay = document.getElementById("selDay"+calendarId);
			var selYear = document.getElementById("selYear"+calendarId);
			var calendarContainer = document.getElementById(calID);
			var calendarVisibility = calendarContainer.style.display;
			
			configLanguage(language);
			
			if(selMonth.type=="select-one") selMonth.selectedIndex = todayDate.getMonth();	
			else selMonth.value = todayDate.getMonth()+1;
			
			if(selDay.type=="select-one") selDay.selectedIndex = todayDate.getDate()-1;	
			else selDay.value = todayDate.getDate();
			
			selYear.value = todayDate.getFullYear();
			
			
			if (admin)
			    YAHOO.widget.myCalendar_Core.IMG_ROOT="../";
			else
			    YAHOO.widget.myCalendar_Core.IMG_ROOT="TDE_VCalendar/";    
			
			
			calendarArray[calID] = new YAHOO.widget.Calendar("calendarArray[VisualCalendar"+calendarId+"]", calID);
			calendarArray[calID].admin = admin;
			calendarArray[calID].language = language; 
			
			calendarArray[calID].startday = "";
			calendarArray[calID].reservedDates = new Array();
			var r = initDates(calID);
			
		    var tmp = new Array();
		    var tmp2 = new Array();
		    tmp = r.split("\n*-*\n");
		    reservedDate = "";
		    for (i=0;i<(tmp.length-1);i++)
		    {
		        tmp2 = tmp[i].split("\n");
				var tmpstr = '';
				for (kt=2;kt<tmp2.length;kt++)
				  if (kt != tmp2.length-1)
				    tmpstr += tmp2[kt]+"\n";
				  else
				    tmpstr += tmp2[kt];  
		        myrange = {range:tmp2[0],title:tmp2[1],comment:tmpstr};
		        calendarArray[calID].reservedDates[i] = myrange;
		        reservedDate += tmp2[0]+",";
		    }
		    if (reservedDate!="")
		        reservedDate = reservedDate.substr(0,reservedDate.length-1);
			
			calendarArray[calID].renderBodyCellReserved = function(workingDate, cell) {
					YAHOO.util.Dom.addClass(cell, "reserved");
		    }
		    
		    
			calendarArray[calID].addRenderer(reservedDate, calendarArray[calID].renderBodyCellReserved);	
			
			calendarArray[calID].render();
			
			
			calendarArray[calID].onSelect = function(){
				var calendarDate = this.getSelectedDates()[0];
				if(selMonth.type=="select-one") selMonth.selectedIndex = calendarDate.getMonth();	
				else selMonth.value = calendarDate.getMonth()+1;
			
				if(selDay.type=="select-one") selDay.selectedIndex = calendarDate.getDate()-1;	
				else selDay.value = calendarDate.getDate();
			
				selYear.value = calendarDate.getFullYear();
				calendarContainer.style.display=calendarVisibility;
			};
			
			
            updateEventList(calendarId,-1);
			addClick("",calendarArray[calID]); ///marcar visualmente como add
			
		}
		
		function getSelectedDates(calendarId){
			return calendarArray[calendarId].getSelectedDates();
		}
		
		function resetSelectedDates(calendarId){
			calendarArray[calendarId].reset();
		}
		function getRequest()
        {
              http_request = false;
              if (window.XMLHttpRequest) { // Mozilla, Safari,...
                 http_request = new XMLHttpRequest();
                 if (http_request.overrideMimeType) {
                 	// set type accordingly to anticipated content type
                    //http_request.overrideMimeType('text/xml');
                    http_request.overrideMimeType('text/html');
                 }
              } else if (window.ActiveXObject) { // IE
                 try {
                    http_request = new ActiveXObject("Msxml2.XMLHTTP");
                 } catch (e) {
                    try {
                       http_request = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (e) {}
                 }
              }
              if (!http_request) {
                 alert('Cannot create XMLHTTP instance');
                 return false;
              }
              return http_request;
        }
        function initDates(id)
        {
            http_request = getRequest();   
            http_request.open("GET", YAHOO.widget.myCalendar_Core.IMG_ROOT + "load.php?id="+id, false);
            http_request.send(null);
            var text = http_request.responseText;
            text = text.replace(/%26/g, "&");  
            return text;
        }
        
        
        
        function dateChanged(y,m,d,calID)
        { 
            if (calendarArray[calID].admin)
            {
                if (calendarArray[calID].actionstate=='add')
                {
        	        if (calendarArray[calID].startday=="")
        	        {
        	            calendarArray[calID].startday = m + "/" + d + "/" + y;
        	            showLabel(calendarArray[calID]);
        	        }    
        	        else 
        	        {
        	            range = calendarArray[calID].startday+"-"+m + "/" + d + "/" + y; 
        	            layer = document.getElementById(calID+"Layer");
        	            layer.style.display = "";
        	            divAdd = document.getElementById(calID+"SelectAdd");
        	            ss = range;
        	            divAdd.innerHTML = "<strong>From: </strong>" + ss.replace(/-/g, " <strong>To:</strong> ");
        	            divAdd.style.display = "";
        	            divAdd = document.getElementById(calID+"ButtonsAdd");
        	            divAdd.style.display = "";
        	            inputrange = document.getElementById(calID+"range");
        	            inputrange.value = range;
        	            renderCalendar(calID);
        	        }
        	    }    
        	    else if (calendarArray[calID].actionstate=='edit')
                {
                    calendarArray[calID].rangesSelected = new Array();
                    calendarArray[calID].rangesSelected = inrangeArray(new Date(y, (m-1), d),calID);
        	        if (calendarArray[calID].rangesSelected.length > 0) //al menos esta dentro de un rango
        	        {
        	            
        	            oSelect = document.getElementById(calID+"Select");        	        
        	            clearOptions(oSelect);
        	            var oOption;
        	            for (i=0;i<calendarArray[calID].rangesSelected.length;i++)
        	            {
        	                oOption = document.createElement("OPTION");
                            oOption.text= calendarArray[calID].rangesSelected[i].range;
                            oOption.value= calendarArray[calID].rangesSelected[i].range;
                            
                            if(navigator.userAgent.indexOf('MSIE') != -1) 
                                oSelect.add(oOption);
			    	        else 
			    	            oSelect.add(oOption, null);
        	            }
        	            layer = document.getElementById(calID+"Layer");
        	            layer.style.display = "";
        	            divEdit = document.getElementById(calID+"SelectEdit");
        	            divEdit.style.display = "";
        	            divEdit = document.getElementById(calID+"ButtonsEdit");
        	            divEdit.style.display = "";
        	            
        	            updateinput(calID,calendarArray[calID].rangesSelected[0]);
        	        }
                }
            }
        	
        	 
        }
        function inrange(d,calID)
        {
            range = -1;
            for (i=0;i<calendarArray[calID].reservedDates.length;i++)
            {
                dn = getEnds(calendarArray[calID].reservedDates[i].range,calID);
                a = dn[0];
                b = dn[1];
                doadd = true;
                if (a <= d && b >= d)  // si esta dentro del rango
                {                    
                    range =  i;
                }                    
            }
            return range;
        }
        function inrangeArray(d,calID)
        {
            range = new Array();
            for (i=0;i<calendarArray[calID].reservedDates.length;i++)
            {
                dn = getEnds(calendarArray[calID].reservedDates[i].range,calID);
                a = dn[0];
                b = dn[1];
                doadd = true;
                if (a <= d && b >= d)  // si esta dentro del rango
                {                    
                    range[range.length] =  calendarArray[calID].reservedDates[i];
                }                    
            }
            return range;
        }
        function getRange(d1,d2)
        {
            return (d1.getMonth()+1)+'/'+d1.getDate()+'/'+d1.getFullYear()+'-'+(d2.getMonth()+1)+'/'+d2.getDate()+'/'+d2.getFullYear();
        }
        function getEnds(range,calID) // devuelve un arreglo con los dias estremos del rango
        {
            var d1,d2,s,pos;
            s = range;
            pos = s.indexOf("-");
            d1 = calendarArray[calID]._parseDate(s.substr(0,pos));
            d2 = calendarArray[calID]._parseDate(s.substr(pos+1));
            return new Array(new Date(d1[0],d1[1]-1,d1[2]),new Date(d2[0],d2[1]-1,d2[2]));
        }
        
        function renderCalendar(calID)
        {       
            calendarArray[calID].clearAllItems();
           
            for (i=0;i<calendarArray[calID].reservedDates.length;i++)  
                calendarArray[calID].addRenderer(calendarArray[calID].reservedDates[i].range, calendarArray[calID].renderBodyCellReserved);
           
        	calendarArray[calID].render();
        	updateEventList(calID.replace(/VisualCalendar/g, ""),-1);
        	
        }
        function addCalendar(range,title,comment,calID)
        {
            var d,dn,swap;
            var tmp = new Array();
            var tmptitle = new Array();
            var tmpcomment = new Array();
            var top = 0;
            var located = false;
            d = getEnds(range,calID);
            var doadd;
            if (d[1] < d[0])
            {
                swap = d[1];
                d[1] = d[0]
                d[0] = swap;
            }
            for (i=0;i<calendarArray[calID].reservedDates.length;i++)
            {
                
                
                myrange = {range:calendarArray[calID].reservedDates[i].range,title:calendarArray[calID].reservedDates[i].title,comment:calendarArray[calID].reservedDates[i].comment};
                tmp[top++] = myrange;
                
            }
            myrange = {range:getRange(d[0],d[1]),title:title,comment:comment};
            tmp[top++] = myrange;
            
            calendarArray[calID].reservedDates = tmp; 
            
            makePOSTRequest(calID); 
        }
        function makePOSTRequest(calID) {  
         
           var strdates = "";
           for (i=0;i<calendarArray[calID].reservedDates.length;i++)
               strdates += calendarArray[calID].reservedDates[i].range+"\n"+calendarArray[calID].reservedDates[i].title+"\n"+calendarArray[calID].reservedDates[i].comment+"\n*-*\n";
           strdates = strdates.replace(/&/g, "%26");  
           parameters = "xmldates=" + encodeURI(strdates)   ; 
           
           http_request = getRequest();      
           http_request.onreadystatechange = alertContents;
           http_request.open('POST',YAHOO.widget.myCalendar_Core.IMG_ROOT + 'update.php?id='+calID, true);
           http_request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
           
           parameters += "&id=" + encodeURI( calID );
           
           
           http_request.setRequestHeader("Content-length", parameters.length);
           http_request.setRequestHeader("Connection", "close");
           http_request.send(parameters);
        }
        function alertContents() {
           if (http_request.readyState == 4) {
              if (http_request.status == 200) {
                 //alert(http_request.responseText);           
              } else {
                 alert('There was a problem with the request.');
              }
           }
        }
        function closeDivAdd(calID)
        {
            layer = document.getElementById(calID+"Layer");
        	layer.style.display = "none";
        	divEdit = document.getElementById(calID+"SelectEdit");
        	divEdit.style.display = "none";
        	divEdit = document.getElementById(calID+"ButtonsEdit");
        	divEdit.style.display = "none";
        	divAdd = document.getElementById(calID+"SelectAdd");
        	divAdd.style.display = "none";
        	divAdd = document.getElementById(calID+"ButtonsAdd");
        	divAdd.style.display = "none";
        	calendarArray[calID].startday = ""; 
        	showLabel(calendarArray[calID]);
        }
        
        function saveCalendar(calID)
        {
            
            inputrange = document.getElementById(calID+"range");
            inputtitle = document.getElementById(calID+"title");
            inputcomment = document.getElementById(calID+"comment");
            
            addCalendar(inputrange.value,inputtitle.value,inputcomment.value,calID);
            
            renderCalendar(calID);
        	closeDivAdd(calID);
        }
        function editCalendar(calID)
        {
            
            selectDomElement = document.getElementById(calID+"Select");
            inputtitle = document.getElementById(calID+"title");
            inputcomment = document.getElementById(calID+"comment");
            located = false;
            for (i=0;i<calendarArray[calID].reservedDates.length;i++)
            {
                if ((calendarArray[calID].reservedDates[i].range == calendarArray[calID].rangesSelected[0].range) && !located)
                {
                    located = true;
                    
                    k = i + selectDomElement.selectedIndex;
                    
                    calendarArray[calID].reservedDates[k].title = inputtitle.value;
                    
                    calendarArray[calID].rangesSelected[selectDomElement.selectedIndex].title = inputtitle.value;
                    calendarArray[calID].reservedDates[k].comment = inputcomment.value;
                    calendarArray[calID].rangesSelected[selectDomElement.selectedIndex].comment = inputcomment.value;
                }              
            }
            
            makePOSTRequest(calID); 
        	closeDivAdd(calID);
        	updateEventList(calID.replace(/VisualCalendar/g, ""),-1);
        }
        function deleteRangeList(calendarId,value,type)
        {
            deleteRange('VisualCalendar'+calendarId,value);
            updateEventList(calendarId,type);
        }
        function deleteRangeVisual(calID)
        {
            var d,dn,swap;
            var tmp = new Array();
            var tmptitle = new Array();
            var tmpcomment = new Array();
            
            inputrange = document.getElementById(calID+"range");
            deleteRange(calID,inputrange.value);
           
                       
            closeDivAdd(calID);
        }
        function deleteRange(calID,value)
        {
            
            var d,dn,swap;
            var tmp = new Array();
            var tmptitle = new Array();
            var tmpcomment = new Array();
            
            dn = getEnds(value,calID);
            s = value;
            pos = s.indexOf("-");
            d1 = calendarArray[calID]._parseDate(s.substr(0,pos));
            k = inrange(new Date(d1[0],d1[1]-1,d1[2]),calID);
            
            
            for (i=0;i<calendarArray[calID].reservedDates.length;i++)
            {
                if (i<k)
                {   
                    tmp[i] = calendarArray[calID].reservedDates[i];
                }
                else if (i>k)
                {
                    tmp[i-1] = calendarArray[calID].reservedDates[i];
                }
                       
            }
            
            calendarArray[calID].reservedDates = tmp;
            makePOSTRequest(calID);  
            renderCalendar(calID);
        }
        
        
        
        
        /////////////////////////////////////////////////////////////////////////////////////
function addMouseOver(e,tag)
{
    YAHOO.util.Dom.addClass(tag, "calcellADDH");
}
function addMouseOut(e,tag)
{
    YAHOO.util.Dom.removeClass(tag, "calcellADDH");
}
function addClick(e,cal)
{
    clearClick(cal);
    YAHOO.util.Dom.addClass(cal.table, "yui-calcontainerADD");
    YAHOO.util.Dom.addClass(cal.tagadd, "calcellADDSeleted");
    cal.actionstate = "add";
    
    showLabel(cal);
}

function editMouseOver(e,tag)
{
    YAHOO.util.Dom.addClass(tag, "calcellEDITH");
}
function editMouseOut(e,tag)
{
    YAHOO.util.Dom.removeClass(tag, "calcellEDITH");
}
function editClick(e,cal)
{
    clearClick(cal);
    YAHOO.util.Dom.addClass(cal.table, "yui-calcontainerEDIT");
    YAHOO.util.Dom.addClass(cal.tagedit, "calcellEDITSeleted");
    cal.actionstate = "edit";
    showLabel(cal);
}

function clearClick(cal)
{
    YAHOO.util.Dom.removeClass(cal.table, "yui-calcontainerADD");
    YAHOO.util.Dom.removeClass(cal.tagadd, "calcellADDSeleted");
    YAHOO.util.Dom.removeClass(cal.table, "yui-calcontainerEDIT");
    YAHOO.util.Dom.removeClass(cal.tagedit, "calcellEDITSeleted");
    YAHOO.util.Dom.removeClass(cal.table, "yui-calcontainerDEL");
    YAHOO.util.Dom.removeClass(cal.tagdel, "calcellDELSeleted");
}
function showLabel(cal)
{
    if (cal.admin)
    {
        switch (cal.actionstate)
        {
            case "add":
                if (cal.startday=="")
                    cal.label.innerHTML = "Select Start Date";
                else
                    cal.label.innerHTML = '<div class="sennaled">Select End Date</div>';
            break;
            case "edit":
                cal.label.innerHTML = "Edit Event";
            break;
        }
    }
}
function clearOptions(selectDomElement)
{
	while(selectDomElement.length > 0)
		selectDomElement.remove(0);
}
function updateinput(calID,selected)
{
    
    inputrange = document.getElementById(calID+"range");
    
    inputrange.value = selected.range;
    inputtitle = document.getElementById(calID+"title");
    inputtitle.value = selected.title;
    inputcomment = document.getElementById(calID+"comment");
    inputcomment.value = selected.comment;
}			
function renderselect(selectDomElement,calID)
{
    updateinput(calID,calendarArray[calID].rangesSelected[selectDomElement.selectedIndex]);
}
