<%
RenewalLetter = "<table border=""0"" width=""600""><tbody>" & vbCrLf
'RenewalLetter = RenewalLetter & "<TR><TD colspan=""1"" ALIGN=""center""><IMG SRC=""http://www.tix.com/PrivateLabel/US131MotorsportsPark/Images/LetterLogo.jpg""></TD></TR>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td colspan=""1"">" & FormatDateTime(Now(), vbLongDate) & "<br><br></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ":<br><br>" & vbCrLf
RenewalLetter = RenewalLetter & "The Allentown Symphony Orchestra 2009-2010 Season will soon be upon us, and the renewal deadline for returning subscribers is July 30, 2009.  Because we value your business, we want to offer your tickets to you first before the premium subscriber seats go on sale to the general public.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "We currently have your last year's seats on hold for you to renew for the upcoming 2009-2010 season, and there are three easy ways you can renew your tickets:<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<UL><LI>Print out this email and mail it to our office at 23 N 6th St, Allentown, PA 18101.</LI>" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>Call us at (610) 432-6715 and simply have the form handy with your order number and renewal code.</LI>" & vbCrLf
RenewalLetter = RenewalLetter & "<LI><A HREF=""http://AllentownSymphony.tix.com/renew.asp"">Click here</A> to renew online.  You will be prompted to enter your order number and renewal code listed below.</LI></UL><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "The deadline for your ticket renewal is July 30, 2009.  We will hold your seat(s) from the general public until that time. <BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "We appreciate your time and attention and look forward to seeing you again for the 2009-2010 season.<BR><BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Sincerely,<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Sheila Evans<BR>Executive Director<BR>Allentown Symphony Association<BR><BR></td></tr></tbody></table>" & vbCrLf
EMailMessage = EMailMessage & RenewalLetter
'Response.Write "<DIV></DIV>" & vbCrLf
%>  





