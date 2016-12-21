<%
'CHANGE LOG
'JAI 7/12/13 - Centerpoint Theatre Renewal Letter 2014
'JAI 7/16/13 - Set RenewalLetterDate
'JAI 7/19/13 - Updated Format

RenewalLetter = ""
RenewalLetter = RenewalLetter & "<table width=750>"
RenewalLetter = RenewalLetter & "<tr><td align=""center""><img src=" & LogoImage & " width=""350""><br /><b>PO Box 62, Centerville, UT  84014 - www.CPTUtah.org</b><br /></td></tr></table><br />" & vbCrLf
RenewalLetter = RenewalLetter & "<table width=750>"
RenewalLetter = RenewalLetter & "<tr><td colspan=""2"">" & RenewalLetterDate & "</td></tr>" 
RenewalLetter = RenewalLetter & "<tr><td colspan=""2"">&nbsp;</td></tr>" 
RenewalLetter = RenewalLetter & "<tr><td width=""15"">&nbsp;</td><td>Return Service Requested</td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td colspan=""2"">&nbsp;</td></tr>" 
RenewalLetter = RenewalLetter & "<tr><td>&nbsp;</td><td>" & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & "<BR>" & vbCrLf
RenewalLetter = RenewalLetter & rsCustInfo("ShipAddress1") & "<BR>" & vbCrLf
If rsCustInfo("ShipAddress2") <> "" Then
	RenewalLetter = RenewalLetter & rsCustInfo("ShipAddress2") & "<BR>" & vbCrLf
End If
RenewalLetter = RenewalLetter & rsCustInfo("ShipCity") & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "</TD></TR></TABLE><BR>" & vbCrLf

RenewalLetter = RenewalLetter & "Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ",<br><br>" & vbCrLf
RenewalLetter = RenewalLetter & "<table border=""0"" width=""750""><tr><td>" & vbCrLf & vbCrLf

RenewalLetter = RenewalLetter & "Thank you for your past support of CenterPoint Legacy Theatre as a Season Ticket Holder. We look forward to having you join us again for our 2015 Season. Please see the enclosed card for details.<BR><BR>"
RenewalLetter = RenewalLetter & "As a Season Ticket Holder you now have the opportunity to secure the same seats for the 2015 Season. To do so <B>you must renew</b> between August 4 and August 30. **<BR><BR>"
RenewalLetter = RenewalLetter & "There are three ways to renew:<BR>"
RenewalLetter = RenewalLetter & "<ul>"
RenewalLetter = RenewalLetter & "<li>Online at www.CPTUtah.org.  Simply click on the Season Ticket Renewal link and enter your Order Number and Renewal Code from the attached page</li>"
RenewalLetter = RenewalLetter & "<li>Come into the Box Office or Call us at (801) 298-1302. (Phones can be very busy)</li>"
RenewalLetter = RenewalLetter & "<li>Mail/Fax the attached form to us with your payment information – Fax (801) 298-4784</li>"
RenewalLetter = RenewalLetter & "</ul><BR>"
RenewalLetter = RenewalLetter & "<p style=""text-align:center""><B>You must complete your renewal by August 30, 2014.</B></p><BR>"
RenewalLetter = RenewalLetter & "If you would like to move your 2015 tickets to a matinee or to the balcony, please contact the box office to complete your renewal.<BR><BR>"
RenewalLetter = RenewalLetter & "<b>**Once you have renewed your current seats,</b> you will have an opportunity to make adjustments or purchase additional season tickets from September 4 thru September 13, 2014.<BR><BR>"

RenewalLetter = RenewalLetter & "Please address your renewal questions to the box office staff.<BR><BR>" & vbCrLf

RenewalLetter = RenewalLetter & "Yours truly,<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<span class=""signature"">Jansen Davis</span><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Executive Director<BR><BR>" & vbCrLf

RenewalLetter = RenewalLetter & "<center>" & vbCrLf
RenewalLetter = RenewalLetter & "<table cellpadding=""0"" cellspacing=0"" class=""smalltable"">" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td colspan=""3""><b>Buying season tickets saves you more than 25% off the single ticket price!</b></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td colspan=""3"">&nbsp;</td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td>&nbsp;</td><td align=""right""><b>Tu/We/Mat</b></td><td align=""right""><b>Mo/Th/Fr/Sa</b></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><b>Main Level Adult</b></td><td align=""right"">$103.00</td><td align=""right"">$115.00</td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><b>Main Level Senior/Student</b></td><td align=""right"">$97.00</td><td align=""right"">$108.00</td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><b>Balcony Level Adult</b></td><td align=""right"">$80.00	</td><td align=""right"">$92.00</td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><b>Balcony Level Senior/Student</b></td><td align=""right"">$74.00	</td><td align=""right"">$85.00</td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "</table>" & vbCrLf
RenewalLetter = RenewalLetter & "</center>" & vbCrLf

RenewalLetter = RenewalLetter & "</td></tr></table>" & vbCrLf
RenewalLetter = RenewalLetter & "<DIV>&nbsp;</DIV>" & vbCrLf

Response.Write RenewalLetter

%>  





