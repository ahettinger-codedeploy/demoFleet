<%
'CHANGE LOG
'JAI 7/12/13 - Centerpoint Theatre Renewal Letter 2014
'JAI 7/16/13 - Set RenewalLetterDate
'JAI 7/19/13 - Updated Format
'SSR 7/16/15 - Updated RenewalLetter
'SSR 7/17/15 - Updated
'SSR 7/20/15 - Updated

RenewalLetter = ""
RenewalLetter = RenewalLetter & "<table width=""750"" border=""0"">"

RenewalLetter = RenewalLetter & "<tr><td colspan=""3"">" & RenewalLetterDate & "</td></tr>" 

RenewalLetter = RenewalLetter & "<tr><td colspan=""3"">&nbsp;</td></tr>" 

RenewalLetter = RenewalLetter & "<tr><td colspan=""3"">Return Service Requested</td></tr>" & vbCrLf

RenewalLetter = RenewalLetter & "<tr><td colspan=""3"">&nbsp;</td></tr>" 

RenewalLetter = RenewalLetter & "<tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<td valign=""top"">" & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & "<BR>" & vbCrLf
RenewalLetter = RenewalLetter & rsCustInfo("ShipAddress1") & "<BR>" & vbCrLf
If rsCustInfo("ShipAddress2") <> "" Then
	RenewalLetter = RenewalLetter & rsCustInfo("ShipAddress2") & "<BR>" & vbCrLf
End If
RenewalLetter = RenewalLetter & rsCustInfo("ShipCity") & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "</td>"
RenewalLetter = RenewalLetter & "<td valign=""top"" align=""center""><span style=""font-size:20px; font-weight:400;"">You must complete<BR>your renewal by</span><BR><span style=""font-size:20px; font-weight:700;"">September 5th, 2015.</span></span></td>"
RenewalLetter = RenewalLetter & "<td><img src=""/images/clear.gif"" width=""25px;""></td>" & vbCrLf
RenewalLetter = RenewalLetter & "</TR></TABLE><BR>" & vbCrLf


RenewalLetter = RenewalLetter & "<table border=""0"" width=""750""><tr><td>" & vbCrLf
RenewalLetter = RenewalLetter & "Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ",<br><br>" & vbCrLf
RenewalLetter = RenewalLetter & "<p>We hope you are as so very super excited excited for our 2016 season as we are! Much thought and deliberation was taken in selecting these wonderful shows and we can’t wait for you to revisit some classics and experience some new favorites this coming year!</p>" & vbCrLf
RenewalLetter = RenewalLetter & "<p>As a Season Ticket Subscriber you now have the opportunity to secure the same seats for the 2016 Season.&nbsp;&nbsp;To do so<b> you must renew </b>between August 10th and September 5th.*</p>" & vbCrLf
RenewalLetter = RenewalLetter & "<p>How to renew:</p>" & vbCrLf

RenewalLetter = RenewalLetter & "<center>" & vbCrLf
RenewalLetter = RenewalLetter & "<table border=""0"" width=""550"">" & vbCrLf
RenewalLetter = RenewalLetter & "<tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<td width=""25%"" align=""left"" valign=""top"">" & vbCrLf
RenewalLetter = RenewalLetter & "<p><b>ONLINE</b>- Visit CPTUtah.org</p>" & vbCrLf
RenewalLetter = RenewalLetter & "<p><i style=""font-size:12px; margin-top:5px;"">Simply click on the Season Ticket Renewal link and enter your Order Number and Renewal Code from the attached invoice</i></p>" & vbCrLf
RenewalLetter = RenewalLetter & "</td>" & vbCrLf
RenewalLetter = RenewalLetter & "<td width=""10%"" align=""center"" valign=""top"">Or</td>" & vbCrLf
RenewalLetter = RenewalLetter & "<td width=""27%"" align=""left"" valign=""top"">" & vbCrLf
RenewalLetter = RenewalLetter & "<p><b>VISIT US</b>- Stop by or call the box office<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "801.298.1302</p>" & vbCrLf
RenewalLetter = RenewalLetter & "<p><i style=""font-size:12px; margin-top:5px;"">Wait times on the phone may be longer than normal due to increased calls for renewals</i></p>" & vbCrLf
RenewalLetter = RenewalLetter & "</td>" & vbCrLf
RenewalLetter = RenewalLetter & "<td width=""10%"" align=""center"" valign=""top"">Or</td>" & vbCrLf
RenewalLetter = RenewalLetter & "<td width=""27%"" align=""left"" valign=""top"">" & vbCrLf
RenewalLetter = RenewalLetter & "<p><b>MAIL/FAX</b>- <BR>Fax 801.298.4784<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "PO Box 62 Centerville, UT 84014<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<p><i style=""font-size:12px; margin-top:5px;"">Send us the attached invoice with your payment information</i></p>" & vbCrLf
RenewalLetter = RenewalLetter & "</td>" & vbCrLf
RenewalLetter = RenewalLetter & "</tr>" & vbCrLf
RenewalLetter = RenewalLetter & "</table>" & vbCrLf
RenewalLetter = RenewalLetter & "</center>" & vbCrLf

RenewalLetter = RenewalLetter & "<p>If you would like to move your 2016 subscription to a matinee, balcony, or a Flex Pass Subscription, please contact the box office to complete your renewal</p>" & vbCrLf
RenewalLetter = RenewalLetter & "<p>Please address all other renewal questions to the box office staff.</p>" & vbCrLf
RenewalLetter = RenewalLetter & "<p>Thank you for your past support of CenterPoint Legacy Theatre as a Season Ticket Subscriber. We look forward to having you join us again for our 2016 Season!<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<p>" & vbCrLf
RenewalLetter = RenewalLetter & "With warm regards,<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<img src=""https://tix.com/Clients/CenterPointTheatre/Renewal/Images/signature.png"" height=""75px""/><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Executive Director<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "CenterPoint Legacy Theatre<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "</p>" & vbCrLf
RenewalLetter = RenewalLetter & "<p>" & vbCrLf
RenewalLetter = RenewalLetter & "*Exchanges: After you have renewed your current subscription, you will have an opportunity to make adjustments or purchase additional season subscriptions starting September 14th." & vbCrLf
RenewalLetter = RenewalLetter & "</p>" & vbCrLf

RenewalLetter = RenewalLetter & "</td></tr></table>" & vbCrLf

RenewalLetter = RenewalLetter & "<DIV>&nbsp;</DIV>" & vbCrLf

Response.Write RenewalLetter

%>  





