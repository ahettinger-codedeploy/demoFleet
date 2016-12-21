/* Sidebar Meny Active Visual Update */
function setActive() {
var loca;
 if( aObj = document.getElementById('hierpage-2').getElementsByTagName('a'))
 {
  for(i=0;i<aObj.length;i++) {
  loca=aObj[i].href;
    if(loca==document.URL || (loca + '#')==document.URL) {
      aObj[i].className='m_active';
      break;
    }
  }
  }
  
  if (document.getElementById('wpadminbar')){
document.getElementById('wpadminbar').style.zIndex=10000;

}

/*  document.getElementById('mmm1').style.zIndex=10000;*/

  
}

/*  window.onload = setActive;*/