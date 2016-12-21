<%
'CHANGE LOG
'JAI 4/23/13 - New script for TheatreZone renewals.
'JAI 4/16/14 - Uodated for 2014 TheatreZone renewals.
'SSR 4/21/14 - Updated renewal letter.

RenewalLetter = "<CENTER>" & vbCrLf
RenewalLetter = RenewalLetter & "<table border=""0"" width=""750""><tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td ALIGN=""center""><FONT FACE=Calibri,Charcoal,Arial><IMG SRC=""/PrivateLabel/TheatreZone-Florida/Renewal/Images/TZ_logoNEW_copy.jpg"" HEIGHT=""125""><BR><FONT FACE=Calibri,Charcoal,Arial><BR><b>Naples' Premier Professional Theatre</b> &middot; 13275 Livingston Road., Naples, FL  34109<BR>888.966.3352 &middot; <u>www.TheatreZone-Florida.com</u></FONT></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial><BR>" & MonthName(Month(Now())) & " " & Day(Now()) & ", " & Year(Now()) & "<br><br></FONT></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ":<br><br>" & vbCrLf

RenewalLetter = RenewalLetter & "Please join us in celebrating 10 years of outstanding professional theatre by renewing your Season 10 subscription and supporting TheatreZone.<br/><br/>" & vbCrLf
RenewalLetter = RenewalLetter & "Artistic director Mark Danni will unveil our 10th Anniversary Season selections during his curtain speech at the opening night of this season's final production, <em>Forever Plaid</em> on May 1st. Our 10th Anniversary Season opening night will be January 8, 2015 with productions in February, March and May.<br/><br/>" & vbCrLf
RenewalLetter = RenewalLetter & "We have reserved your seats from Season 9 for our 2015 Season 10 as one of your Season Ticket subscriber benefits. Enclosed is a copy of your reservation. Please review, and if there are any conflicts, let us know so we may make changes. Please know that while we will do our best to accommodate changes we cannot guarantee the same seats.<br/><br/>" & vbCrLf
RenewalLetter = RenewalLetter & "Please call the box office at 888-966-3352 x5 to secure your reservation or purchase online at <u>http://theatrezone-florida.tix.com/renew.aspx</u> by entering your order number and renewal code from the attached page. In the event you would like to renew your seats before the Season 10 unveiling, you may call or go online upon receipt of this letter, you do not have to wait until May 1st to do so. We will hold your season ticket reservation until June 1 when tickets will then be available to the general public.<br/><br/>" & vbCrLf
RenewalLetter = RenewalLetter & "Phone lines will be busy with renewals and season finale ticket sales, so please leave a message and we will return your call.<br/><br/>" & vbCrLf
RenewalLetter = RenewalLetter & "<p align=""center""><strong>Box Office phone hours:</strong><br/>Monday, Tuesday, Thursday and Friday 9 am to 1 pm<br/>AFTER June 6th we will be on summer hours and only return messages.<br/><br/>The onsite box office at the G&amp;L Theatre is open Wednesdays from 9 am to 1 pm through June 25.</p>" & vbCrLf
RenewalLetter = RenewalLetter & "Remember, a TheatreZone season ticket holder benefits from free ticket exchange, seat renewals, upgrades as available and waived $2 ticket fees.<br/><br/>Thank you for supporting TheatreZone and helping keep professional theatre alive in Southwest Florida. We look forward to seeing you next season." & vbCrLf

RenewalLetter = RenewalLetter & "Warm Regards,<br /><br />" & vbCrLf
RenewalLetter = RenewalLetter & "Rita L. Albaugh<br />" & vbCrLf
RenewalLetter = RenewalLetter & "Box Office Manager" & vbCrLf

RenewalLetter = RenewalLetter & "</FONT></TD></TR></TBODY></TABLE><br />" & vbCrLf
RenewalLetter = RenewalLetter & "</CENTER><br />" & vbCrLf

Response.Write RenewalLetter
Response.Write "<DIV>&nbsp;</DIV>" & vbCrLf


%>  