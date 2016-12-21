<%

RenewalLetter = "<BR><BR><BR><CENTER><table border=""0"" width=""600""><tbody><tr><td>August 16, 2005<br><br></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ":<br><br>" & vbCrLf
RenewalLetter = RenewalLetter & "This is the custom text announcing the details of the event and anything else you'd like to mention.  Save your seats by visting http://budpark.tix.com/renewal.asp and entering your order number and the renewal code from the enclosed form.  If you prefer, you may return this form to us or call us at (XXX) XXX-XXXX.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Included in this letter is the form to save the same seats that you had this year for 2006. Remember, the deadline is December 20, 2005. If you don't renew by this date, your tickets will be available from someone else to purchase.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "We'll See You Next Year,<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Budweiser Motorsports Park<BR><BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<HR><BR><BR>" & vbCrLf

RenewalLetter = RenewalLetter & "Circle one:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Visa&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;MC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Check<BR><BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "CC No:____________________________&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Check No:________<BR><BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Expiration Date:__________&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Check Amt:________</TD></TR></TBODY></TABLE></CENTER>" & vbCrLf
Response.Write RenewalLetter
Response.Write "<DIV></DIV>" & vbCrLf
%>  