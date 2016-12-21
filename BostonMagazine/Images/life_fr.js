var cmPageUrl; if(self == top) cmPageURL = document.location.href; else cmPageURL = document.referrer;
var ifr = (self==top ? '' : 'env=ifr;');
document.write('<scr'+'ipt language="javascript" src="http://a.collective-media.net/cmadj/q1.bostonmagazine/life_fr;sz=300x250;ord=[timestamp];'+ifr+'ord1=' +Math.floor(Math.random() * 1000000) + ';cmpgurl='+escape(escape(cmPageURL))+'?">');  document.write('</scr'+'ipt>');
