<% 
'CHANGE LOG
'SLM 4/6/15 - Updated for 2016

RenewalLetter = "<CENTER>" & vbCrLf
RenewalLetter = RenewalLetter & "<table border=""0""><tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<td COLSPAN=2 ALIGN=""center""><FONT FACE=Calibri,Charcoal,Arial><IMG SRC=""http://www.tix.com/Clients/TheatreZone-Florida/Renewal/Images/TZ_logoNEW_copy.jpg"" HEIGHT=""125""><FONT FACE=Calibri,Charcoal,Arial><BR><b>Naples' Premier Professional Theatre</b> &middot; 13275 Livingston Road., Naples, FL  34109<BR>888.966.3352 &middot; <u>www.TheatreZone-Florida.com</u></FONT></td></FONT>" & vbCrLf
RenewalLetter = RenewalLetter & "</tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<td COLSPAN=2><FONT FACE=Calibri,Charcoal,Arial><BR>" & MonthName(Month(Now())) & " " & Day(Now()) & ", " & Year(Now()) & "<br><br></FONT></td>" & vbCrLf
RenewalLetter = RenewalLetter & "</tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<td COLSPAN=2><FONT FACE=Calibri,Charcoal,Arial>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ":<br><br>" & vbCrLf

RenewalLetter = RenewalLetter & "<br>" & vbCrLf
RenewalLetter = RenewalLetter & "Our Season 11 series has been announced and subscriptions are currently on sale! The 2016 season opens January 7<sup>th</sup> with <i>Sweet Smell of Success</i>, followed by <i>The Boy From Oz</i> in February, <i>Into The Woods</i> in March, and finally, <i>Dames at Sea</i>" & vbCrLf
RenewalLetter = RenewalLetter & "closes our season in May.<br>" & vbCrLf
RenewalLetter = RenewalLetter & "<br>" & vbCrLf
RenewalLetter = RenewalLetter & "We have reserved your seats from Season 10 for Season 11 as one of your series subscriber benefits. Enclosed is a copy of your reservation. Your season" & vbCrLf
RenewalLetter = RenewalLetter & "ticket reservation will be held until June 1, when individual tickets become available to the general public. Please review, and if you have any conflicts" & vbCrLf
RenewalLetter = RenewalLetter & "promptly contact the Box Office so we may make changes on your behalf. Please know that while we do our best to accommodate changes, all potential upgrades" & vbCrLf
RenewalLetter = RenewalLetter & "or date changes are based upon current availability.<br>" & vbCrLf
RenewalLetter = RenewalLetter & "<br>" & vbCrLf
RenewalLetter = RenewalLetter & "To renew your subscription online you may click <a href=""http://theatrezone-florida.tix.com/renew.aspx"">here</a>. Enter your order number and" & vbCrLf
RenewalLetter = RenewalLetter & "Tix renewal code and proceed through the online checkout to submit payment. You may also enclose your check or credit card information with the payment" & vbCrLf
RenewalLetter = RenewalLetter & "form you received with your renewal letter in the mail.<br>" & vbCrLf
RenewalLetter = RenewalLetter & "<br>" & vbCrLf
RenewalLetter = RenewalLetter & "If you require alterations to your renewal reservation, or do not wish to renew at this time, please either email the Box Office at <a href=""mailto:info@theatrezone-florida.com"">info@theatrezone-florida.com</a>, or call 888-966-3352x5 and leave a single detailed message.<br>" & vbCrLf
RenewalLetter = RenewalLetter & "<br>" & vbCrLf
RenewalLetter = RenewalLetter & "Thank you for your continued support of TheatreZone. We look forward to seeing you next season at the Theatre!<br>" & vbCrLf
RenewalLetter = RenewalLetter & "<br>" & vbCrLf

RenewalLetter = RenewalLetter & "</FONT></td>" & vbCrLf
RenewalLetter = RenewalLetter & "</tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<td width=""50%"" align=""left""><FONT FACE=Calibri,Charcoal,Arial>Rita L. Albaugh<br/>Box Office Manager</FONT></td>" & vbCrLf
RenewalLetter = RenewalLetter & "<td width=""50%"" align=""left""><FONT FACE=Calibri,Charcoal,Arial>Jamie A. Eckhold<br/>Box Office Manager</FONT></td>" & vbCrLf
RenewalLetter = RenewalLetter & "</tr>" & vbCrLf
RenewalLetter = RenewalLetter & "</tbody></table>" & vbCrLf
RenewalLetter = RenewalLetter & "</CENTER>" & vbCrLf

RenewalLetter = RenewalLetter & "<DIV>&nbsp;</DIV>" & vbCrLf
EMailMessage = EMailMessage & RenewalLetter

%>  





