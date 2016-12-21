YAHOO.namespace("Remark.panel");YAHOO.Remark.panel.panels = [];
function createRemark(id_in, title_in, body_in, context_in){var args={};args.visible=true;args.effect={effect:eval(YAHOO.widget.ContainerEffect.FADE),
duration:0.01}
args.width="250px";args.constraintoviewport=false;args.iframe=false;args.fixedcenter=false;args.draggable=true;args.modal=false;args.underlay="shadow";args.close=true;var contextArg=new Array();if(context_in){
contextArg[0]=context_in;contextArg[1]="tl";contextArg[2]="bl";args.context=contextArg;}
var newMod;var isNew=true;if(YAHOO.Remark.panel.panels[id_in]){newMod=YAHOO.Remark.panel.panels[id_in];newMod.cfg.applyConfig(args);isNew=false;}
else{newMod=new YAHOO.widget.Panel(id_in, args);YAHOO.Remark.panel.panels[id_in]=newMod;}
newMod.setHeader("<div class='tl'></div><span>"+title_in+"<span><div class='tr'></div>");newMod.setBody(body_in);if(isNew){newMod.render(document.body);}
else{newMod.render();}

}