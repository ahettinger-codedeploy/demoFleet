<% 
'CHANGE LOG
'SLM 04/8/14 - Chamber Music Detroit 2014


RenewalLetter = "<table border=""0""><tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "<TR><TD><TABLE><TR><TD WIDTH=""400""><FONT FACE=" & EmailFontFace & "><IMG SRC=""http://www.tix.com/Clients/ChamberMusicDetroit/Renewal/Images/RenewalLogo.jpg""><BR><BR></TD></TR></TABLE><BR><BR></FONT></TD></TR>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td valign=top><FONT FACE=" & EMailFontFace & ">Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ",<BR><BR>"

RenewalLetter = RenewalLetter & "<p>We are pleased to let you know that you can now renew your subscriptions to the Chamber Music Society of Detroit’s 2014-2015 season online.</span></p>" & vbCrLf
RenewalLetter = RenewalLetter & "<p>Just follow these simple steps:<BR><BR>1)	Visit our website at: http://chambermusicdetroit.tix.com/renew.aspx <BR>2)	Enter your order number and renewal code as listed below.  If you have subscriptions to both the Signature and Sunday Recital Series, they are listed below and will  both be automatically renewed with the same order number and renewal code.<BR>3)	Enter your payment information when prompted.</span></p>" & vbCrLf
RenewalLetter = RenewalLetter & "<p>Your renewal information is:</p>" & vbCrLf
RenewalLetter = RenewalLetter & "</FONT></TD></TR></TBODY></TABLE><BR>" & vbCrLf
EMailMessage = EMailMessage & RenewalLetter

%>  





