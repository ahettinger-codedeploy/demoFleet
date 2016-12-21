<% 
'CHANGE LOG
'SSR 5/10/16 - Updated

RenewalLetter = "<CENTER>" & vbCrLf
RenewalLetter = RenewalLetter & "<table border=""0""><tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<td COLSPAN=2 ALIGN=""center""><FONT FACE=Calibri,Charcoal,Arial><IMG SRC=""http://www.tix.com/Clients/CabrilloPlayhouse/Renewal/Images/CabrilloPlayhouseLogo.gif"" HEIGHT=""125""></td></FONT>" & vbCrLf
RenewalLetter = RenewalLetter & "</tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<td COLSPAN=2><FONT FACE=Calibri,Charcoal,Arial>Dear Cabrillo Playhouse Subscriber:<br><br>" & vbCrLf

RenewalLetter = RenewalLetter & "<br>" & vbCrLf

RenewalLetter = RenewalLetter & "<p>Our 2016-2017 season has been announced and is currently on sale!  As a season ticket holder, your series and seats from Season 2015-2016 have been reserved for Season 2016-2017 as one of your subscriber benefits. Your seats are guaranteed until June 6th; however, they are not secured until receipt of payment. Any unpaid reservations will be released for sale June 8th, 2016 when individual tickets go on sale to the public.  Don't miss out on Cabrillo’s new season. Contact the Box Office today, or follow the online renewal instructions below to purchase your 2017 subscription before your tickets are released for sale to the general public.</p>" & vbCrLf
RenewalLetter = RenewalLetter & "<p>Enclosed are the current details of your reservation. To renew your subscription online you may click this Tix Renewal Link <a href=""" & EMailRenewalURL & """>" & EMailRenewalURL & "</a>.  Enter the order number and Tix renewal code listed on your reservation and proceed through the online checkout to submit payment. You may also mail your check or credit card information to Cabrillo Playhouse, PO Box 265, San Clemente, CA 92674.</p>" & vbcr

RenewalLetter = RenewalLetter & "<p>To renew your subscription online click (or tap) the button below:</p>" & vbCrLf

RenewalLetter = RenewalLetter & "<center>" & vbCrLf
RenewalLetter = RenewalLetter & "<table border=""0"" cellspacing=""0"" cellpadding=""0"">" & vbCrLf
RenewalLetter = RenewalLetter & "<tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<td align=""center"" style=""-webkit-border-radius: 3px; -moz-border-radius: 3px; border-radius: 3px;"" bgcolor=""#C01F18"">" & vbCrLf
RenewalLetter = RenewalLetter & "<a href="" " & EasyRenewalURL & " "" target=""_blank"" style=""font-size: 13px; font-family: Helvetica, Arial, sans-serif; color: #ffffff; text-decoration: none; color: #ffffff; text-decoration: none; -webkit-border-radius: 3px; -moz-border-radius: 3px; border-radius: 3px; padding: 12px 18px; border: 1px solid #C01F18; display: inline-block;"">" & vbCrLf
RenewalLetter = RenewalLetter & "RENEW" & vbCrLf
RenewalLetter = RenewalLetter & "</a>" & vbCrLf
RenewalLetter = RenewalLetter & "</td>" & vbCrLf
RenewalLetter = RenewalLetter & "</tr>" & vbCrLf
RenewalLetter = RenewalLetter & "</table>" & vbCrLf
RenewalLetter = RenewalLetter & "</center>" & vbCrLf


RenewalLetter = RenewalLetter & "<p>If you require assistance, alterations to your renewal reservation, or do not wish to renew at this time, please either email the Box Office at <a href=""mailto:Cabrillo_theatre@hotmail.com"">Cabrillo_theatre@hotmail.com<a/> and leave a single detailed message, or call the box office at 949-492-0465.</p>" & vbCrLf
RenewalLetter = RenewalLetter & "<p>Thank you for your continued support of the Cabrillo Playhouse.  We look forward to seeing you  at the Theatre!</p>" & vbcr
RenewalLetter = RenewalLetter & "<p>Warm Regards,</p>" & vbcr

RenewalLetter = RenewalLetter & "</FONT></td>" & vbCrLf
RenewalLetter = RenewalLetter & "</tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<td width=""50%"" align=""left""><FONT FACE=Calibri,Charcoal,Arial>Sandra Weaver<br/>Box Office Manager</FONT></td>" & vbCrLf
RenewalLetter = RenewalLetter & "</tr>" & vbCrLf
RenewalLetter = RenewalLetter & "</tbody></table>" & vbCrLf
RenewalLetter = RenewalLetter & "</CENTER>" & vbCrLf

RenewalLetter = RenewalLetter & "<DIV>&nbsp;</DIV>" & vbCrLf
EMailMessage = EMailMessage & RenewalLetter



%>  





