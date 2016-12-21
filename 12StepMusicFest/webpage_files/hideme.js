/*
hideme.js
emulates php mailto command
mrz 5/08
mrz 9/08 changed subject delimiter from \ to ~.  Left original \ check in for backwards compatibility

This function handles the cloaking of emails
e-mail info is passed in the ID portion of the calling string
this function will format that into a valid command and invoke the user's local email client
-------
How to invoke:
  <a onclick="hideme(this.id)"; id="see ID below" href="#">Email me</a>
  email address: name@domain.com
  id="info" - will generate a mailto command with info@[thisdomain]?subject=Message from [thisdomain]
	id="info#tsgwebplus.com" - will generate a mailto command with into@tsgwebplus.com?subject=Message from [thisdomain]
	id="info\custom subject line - will generate a mailto command with into@[thisdomain]?subject=custom subject line
Use examples:
<a onclick="hideme(this.id)"; id="info53#thirstylizards.com\web feedback" href="#">Email me</a><br />
<a onclick="hideme(this.id)"; id="info53\web feedback" href="#">Email me</a><br />
<a onclick="hideme(this.id)"; id="malin" href="#">Email me</a><br />
*/

function hideme(estring) {
  emsub = estring.split("\\");		// use \ to split the string we got into email and [optionally] subject
  if(emsub.length==1) emsub = estring.split("~");		// use ~ to split the string we got into email and [optionally] subject
  em = emsub[0].split("#");				// splt the email portion into name and [optionally] domain
	if(em.length==2) domain = em[1]; else domain = getEmailDomain();	// if we got a domain - use it else use default
	eml = em[0] +"@"+ domain;			// build email address
  if(emsub.length==2) subject = emsub[1]; else subject = "Message from " + domain;  // if we got a subject - use it else use default
  mstring = "mailto:" + eml + "?subject=" + subject;	// build mailto string
//  alert (mstring);
  document.location.href=mstring;											// go there
	return;																							// outta here
}
