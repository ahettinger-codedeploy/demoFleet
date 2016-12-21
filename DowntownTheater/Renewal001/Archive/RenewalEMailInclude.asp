<% 
'CHANGE LOG
'JAI 11/22/11 - Updated for 2012.
'JAI 12/4/12 - Updated for 2013.
'SSR 12/4/13 - Updated for 2014.

RenewalLetter = "" & vbCrLf
RenewalLetter = RenewalLetter & "<table border=""0"">" & vbCrLf
RenewalLetter = RenewalLetter & "<tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<td align=""left""> <FONT FACE=Calibri,Charcoal,Arial>" & vbCrLf
RenewalLetter = RenewalLetter & "Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ":<br><br>" & vbCrLf
RenewalLetter = RenewalLetter & "You can now renew your 2014 Porthouse Theatre Subscription three ways!<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<OL><LI>Online, by clicking the link below<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<A HREF=""" & EMailRenewalURL & """>" & EMailRenewalURL & "</A></LI><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>Phone, by calling 330-672-3884 </LI><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>Mail, by sending in your subscription renewal form to:<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<strong>Porthouse Theatre</strong><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "1325 Theatre Drive MSP B141<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "PO Box 5190<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Kent, Ohio – 44242-0001<BR></LI></UL><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Please know that if you would like to purchase a Porthouse Theatre subscription as a holiday gift, the deadline is Monday, December 16, to allow enough time for mailing.<BR><BR>" & vbCrLf 
RenewalLetter = RenewalLetter & "We hope you have a wonderful holiday season and we look forward to seeing you in the Summer!<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Happy Holidays,<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Porthouse Theatre<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "</td>" & vbCrLf
RenewalLetter = RenewalLetter & "</tr>" & vbCrLf
RenewalLetter = RenewalLetter & "</tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "</table>" & vbCrLf
RenewalLetter = RenewalLetter & "<DIV>&nbsp;</DIV>" & vbCrLf
EMailMessage = EMailMessage & RenewalLetter

%>  
