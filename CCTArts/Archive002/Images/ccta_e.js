/*--- Avanquest WebEasy External Script ---*/

/* -------------------------------------------- */
/* Popup Menu Library                             */
/* -------------------------------------------- */

var wePopupNext = 0;


function weFindAnchor(el)
{
    var n=el.firstChild;
    while (n)
    {
        if('A'==n.nodeName) return n;
        n=n.nextSibling;
    }
    return null;
}


function weFindDiv(el)
{
    var prev=el.previousSibling;
    if (!prev) return null;
    if ('DIV'==prev.nodeName) return prev;
    return weFindDiv(prev);
}


function weIsAbs(el)
{
    if (!el) return false;
    if (!el.tagName) return false;
    var tag=el.tagName.toUpperCase();
    if ('TD,TR,TABLE'.indexOf(tag) < 0) return true;
    return false;            
}


function weElemPos(el)
{
    var pos={ left:el.offsetLeft, top: el.offsetTop };
    if (!weIsAbs(el.offsetParent)) 
    {
        var pr = weElemPos(el.offsetParent);
        pos.left += pr.left;
        pos.top  += pr.top;
    }
    return pos;
}


function weIsParent(me, own)
{
    if (!me.parentNode) return false;
    if (me.parentNode == own) return true;
    return weIsParent(me.parentNode, own);
}




function wePopupTime(popDiv)
{
    var src='var m=document.getElementById("'+popDiv.id+'");if(!m.isOver){m.style.visibility="hidden";}';
    setTimeout(src,500);
}


function wePopupOver(oneDiv)
{
    var popDiv=oneDiv.parentNode;
    var el=weFindAnchor(oneDiv);
    if (el && !(popDiv.className)) el.style.color=popDiv.weOvrTx;
    if (!el || !(popDiv.className)) oneDiv.style.backgroundColor=popDiv.weOvrBg;
    popDiv.isOver = true; 
}

function wePopupAway(oneDiv)
{
    var popDiv=oneDiv.parentNode;
    var el=weFindAnchor(oneDiv);
    if (el && !(popDiv.className)) el.style.color=popDiv.weOutTx;
    if (!el || !(popDiv.className)) oneDiv.style.backgroundColor = 'transparent';
    popDiv.isOver = false;
    wePopupTime(popDiv);
}



function wePopupHide(an)
{
    if (!V5) return;
    var popDiv=weFindDiv(an);
    if (!popDiv) return;
    popDiv.isOver=false;
    wePopupTime(popDiv);
}

           
function wePopupShow(an,way,fgc,fnt,fnz,fnb,fni,fnu,agn,trn,bgc,bdr,bdc,lnw,pad,fgo,bgo)
{
    if (!V5) return;
    var div=weFindDiv(an);
    if (!div) return;
    if (!div.id)
    {    
        div.id='wePopupID'+(wePopupNext++);
        div.weOvrBg=bgo;
        div.weOutTx=fgc;
        div.weOvrTx=fgo;
        if (!(div.className))
        {
            div.style.backgroundColor=(trn?'transparent':bgc);
            div.style.borderColor=bdc;
            div.style.borderWidth=lnw+'px';
            if ('none'!=bdr) div.style.borderStyle = bdr;
        }
        var it=div.firstChild;
        var isOne=true;
        var wd=0;
        while (it)
        {
            if (it.nodeName=='DIV')
            {
                     if (isOne) isOne=false;
                else if (div.className) it.style.borderTopWidth='0px';
                else {    
                    it.style.borderTopColor = bdc;
                    it.style.borderTopStyle = bdr;
                    it.style.borderTopWidth = lnw+'px';
                }
                if (!(div.className))
                {
                    it.style.textAlign = agn;
                    it.style.padding = pad+'px';
                }
                var at=weFindAnchor(it);
                if (at)
                {
                    if (at.style)
                    {
                        if (!(div.className))
                        {    
                            at.style.color = fgc;
                            at.style.fontFamily = fnt;
                            at.style.fontSize   = fnz;
                            at.style.fontWeight = fnb;
                            at.style.fontStyle  = fni;
                            at.style.textDecoration = fnu;    
                        }
                    }
                    if (an.target) at.target=an.target;                        
                    if (at.offsetWidth>wd) wd=at.offsetWidth;
                    if (IE) at.style.width='100%';
                }                            
            }
            it = it.nextSibling;
        }
        if (wd>0) div.style.width=(wd+2*lnw+2*pad)+'px';
        var ox=0;
        var oy=0;
        var op=an.parentNode;
        if ('BODY'==an.parentNode.nodeName)
        {
            op=an.firstChild;
            if ('IMG'!=op.nodeName) op=op.nextSibling;
            ox=op.offsetLeft;
            oy=op.offsetTop;
        }
        else if (!weIsAbs(an.parentNode)) 
        {    
            op=an.firstChild;
            if ('IMG'!= op.nodeName) op=op.nextSibling;
            var pt=weElemPos(op)
            ox=pt.left;
            oy=pt.top;
        }
        div.style.left=ox+'px';
        div.style.top =oy+'px';
             if (2 == way)    div.style.left=(ox-div.offsetWidth)+'px';
        else if (3 == way)    div.style.top =(oy-div.offsetHeight)+'px';
        else if (1 == way)    div.style.top =(oy+op.offsetHeight)+'px';
        else div.style.left=(ox+op.offsetWidth)+'px';
    }
    for (var i=0;i<wePopupNext;++i)
    {
        var id='wePopupID'+i;
        if (div.id!=id)
        {
            var pop=document.getElementById('wePopupID'+i);
            if (!weIsParent(div,pop)) pop.style.visibility='hidden';
        }
    }
    div.style.visibility='visible';
    div.isOver=true;
}




/*--- EndOfFile ---*/
