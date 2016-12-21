<% 
'CHANGE LOG
'JAI 5/12/15 - 2015 Payment gateway issues resolution
'JAI 5/19/15 - Updated for 2nd email blast.

RenewalLetter = ""
RenewalLetter = RenewalLetter & "<table border=""0""><tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<td COLSPAN=2 ALIGN=""center""><FONT FACE=Calibri,Charcoal,Arial>" & vbCrLf
RenewalLetter = RenewalLetter & "<IMG SRC=""https://www.tix.com/clients/ColumbianTheatre/Images/cologo.gif"" WIDTH=""140"" HEIGHT=""82"">" & vbCrLf
RenewalLetter = RenewalLetter & "</td></FONT>" & vbCrLf
RenewalLetter = RenewalLetter & "</tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<td COLSPAN=2><FONT FACE=Calibri,Charcoal,Arial>" & MonthName(Month(Now())) & " " & Day(Now()) & ", " & Year(Now()) & "<br><br></FONT></td>" & vbCrLf
RenewalLetter = RenewalLetter & "</tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<td COLSPAN=2><FONT FACE=Calibri,Charcoal,Arial>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ":<br /><br />" & vbCrLf

RenewalLetter = RenewalLetter & "Due to a problem with our credit card processor, we were unable to complete the charge to your " & CTTenderType & " ending with " & CTCreditCardNumber & " for the order you placed on " & FormatDateTime(CTTenderDate, vbShortDate) & " at " & TimeFormat(LocalDateTime(Session("OrganizationNumber"),CTTenderDate)) & ".  Your order number is " & rsOrderLine("OrderNumber") & " and the details are listed below.<br /><br />" & vbCrLf

RenewalLetter = RenewalLetter & "We appreciate your support of Columbian Theatre and ask that you complete your order now.  Please <a href=""" & EMailRenewalURL & "?o=" & rsOrderLine("OrderNumber") & "&c=" & RenewalCode & """>click here</a> or cut and paste the URL below into your browser to complete your purchase.<br /><br />" & vbCrLf

RenewalLetter = RenewalLetter & EMailRenewalURL & "?o=" & rsOrderLine("OrderNumber") & "&c=" & RenewalCode & "<br /><br />" & vbCrLf

RenewalLetter = RenewalLetter & "We understand that this is an unusual request, so please don't hesitate to contact me via email at <a href=mailto:" & EMailReplyTo & ">" & EMailReplyTo & "</a> or by phone at " & EMailPhoneNumber & " if you have any questions.<br /><br />" & vbCrLf

RenewalLetter = RenewalLetter & "Thank you in advance for your prompt attention to this matter and we apologize for any inconvenience this issue has caused.<br /><br />" & vbCrLf

RenewalLetter = RenewalLetter & "Sincerely,<br /><br />" & vbCrLf

RenewalLetter = RenewalLetter & "Brooke Rindt<br />" & vbCrLf
RenewalLetter = RenewalLetter & "Administrative Coordinator<br />" & vbCrLf
RenewalLetter = RenewalLetter & "The Columbian Theatre Foundation, Inc.<br />" & vbCrLf
RenewalLetter = RenewalLetter & "521 Lincoln Street<br />" & vbCrLf
RenewalLetter = RenewalLetter & "Wamego, KS 66547<br />" & vbCrLf
RenewalLetter = RenewalLetter & "<a href=mailto:" & EMailReplyTo & ">" & EMailReplyTo & "</a><br />" & vbCrLf
RenewalLetter = RenewalLetter & EMailPhoneNumber & vbCrLf

RenewalLetter = RenewalLetter & "</FONT></td>" & vbCrLf
RenewalLetter = RenewalLetter & "</tr>" & vbCrLf
RenewalLetter = RenewalLetter & "</tbody></table>" & vbCrLf

RenewalLetter = RenewalLetter & "<DIV>&nbsp;</DIV>" & vbCrLf
EMailMessage = EMailMessage & RenewalLetter
ErrorLog("CT - EMM: " & EMailMessage)
%>  





