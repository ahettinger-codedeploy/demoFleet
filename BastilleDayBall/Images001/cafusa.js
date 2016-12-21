//Powered by Softery.com
//Ver: 4//
function FlashSolver()
    {
    window.setTimeout("ReloadFlashObjects()", 1);
    window.status = "";
    window.defaultStatus = "";
    }
function ReloadFlashObjects()
	{
	n=navigator;
	nav=n.appVersion.toLowerCase();
	if ((nav.indexOf('win')!=-1) || (nav.indexOf('nt')!=-1)) 
		{
		if (navigator.appName == "Microsoft Internet Explorer")
			{
			var tmpObject = document.getElementsByTagName('object');
			if (tmpObject && tmpObject.length) 
				{
				for (var i = 0; i < tmpObject.length; i++) 
					{
					if (tmpObject[i].getAttribute('classid').toLowerCase() == 'clsid:d27cdb6e-ae6d-11cf-96b8-444553540000') 
						{
						var ps = tmpObject[i].getElementsByTagName('param');
						if (ps && ps != null)
							{
							for (var j = 0; j < ps.length; j++) 
								{
								if (ps[j].getAttribute('name').toLowerCase() == 'flashvars') 
									{
									var variables = ps[j].getAttribute('value');
									break;
									}
								}
							}
						var obj = tmpObject[i].outerHTML + "\n";
						obj = obj.replace(/FLASHVARS" VALUE=""/i,'FLASHVARS" value="'+variables+'"');
						tmpObject[i].outerHTML = obj;
						}
					}
				tmpObject = null;
				}
			}
		}
	}
window.onunload = function()
	{
	n=navigator;
	nav=n.appVersion.toLowerCase();
	if ((nav.indexOf('win')!=-1) || (nav.indexOf('nt')!=-1)) 
		{
		if (navigator.appName == "Microsoft Internet Explorer")
			{
			if (document.getElementsByTagName) 
				{
				var tmpObject = document.getElementsByTagName("object"); 
				for (i=0; i<tmpObject.length; i++)
					{
					tmpObject[i].outerHTML = ""; 
					}
				}
			}
		}
	}

function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function getScrollingPosition()
{
  var position = [0, 0];

  if (typeof(window.pageYOffset) != 'undefined')
  {
    position = [
        window.pageXOffset,
        window.pageYOffset
    ];
  }

  else if (typeof(document.documentElement.scrollTop)
      != 'undefined' && (document.documentElement.scrollTop > 0 ||
    document.documentElement.scrollLeft > 0))
  {
    position = [
        document.documentElement.scrollLeft,
        document.documentElement.scrollTop
    ];
  }

  else if (typeof(document.body.scrollTop) != 'undefined')
  {
    position = [
        document.body.scrollLeft,
        document.body.scrollTop
    ];
  }

  return position;
}


function loadData(photo){
	document.getElementById('grandephoto').style.top=getScrollingPosition()[1]+100 + 'px';
//	document.getElementById('grandephoto').style.left=document.documentElement.scrollLeft+200 + 'px';
	document.getElementById('grandephoto').style.left=getScrollingPosition()[0]+200+'px';
	document.getElementById('loading').style.top=(getScrollingPosition()[1]+0) + 'px';
	document.getElementById('loading').style.left=getScrollingPosition()[0] + 'px';
	document.getElementById('masque').style.display='inline';
//	document.getElementById('masque').style.height=document.body.clientHeight + 'px';

	sendData('photo='+ photo, '../ajax/getpict.php');
}

function vote(photo, note){

	sendData('photo='+ photo + '&note='+ note, '../ajax/vote.php');
}

function sendData(data, page){
	// affichage du loading...
	document.getElementById('loading').style.display='inline';

	if(window.ActiveXObject){
		//Internet Explorer
		var XhrObj = new ActiveXObject("Microsoft.XMLHTTP") ;
		}
    else{
		var XhrObj = new XMLHttpRequest();
		}
	//définition de l'endroit d'affichage:

	var content = document.getElementById("grandephoto");
	//Ouverture du fichier en methode POST
	XhrObj.open("POST", page);
	//Ok pour la page cible
	XhrObj.onreadystatechange = function()
		{
		if (XhrObj.readyState == 4 && XhrObj.status == 200)
			{
			content.innerHTML = XhrObj.responseText ;
			// fermeture du loading...
			document.getElementById('loading').style.display='none';
			}
		}    
		XhrObj.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
		XhrObj.send(data);
	}



function closeData(){
	document.getElementById('grandephoto').innerHTML = '';
	document.getElementById('masque').style.display='none';
}
