<%
'CHANGE LOG
'JAI 7/12/13 - Centerpoint Theatre Renewal Letter 2014
'JAI 7/16/13 - Set RenewalLetterDate

RenewalLetter = ""
RenewalLetter = RenewalLetter & "<table width=750>"
RenewalLetter = RenewalLetter & "<tr><td align=""center"" colspan=""2""><img src=" & LogoImage & " width=""350""><br /><b>PO Box 62, Centerville, UT  84014 - www.CenterPointTheatre.org</b><br /></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td colspan=""2"">&nbsp;</td></tr>" 
RenewalLetter = RenewalLetter & "<tr><td colspan=""2"">" & RenewalLetterDate & "</td></tr>" 
RenewalLetter = RenewalLetter & "<tr><td colspan=""2"">&nbsp;</td></tr>" 
RenewalLetter = RenewalLetter & "<tr><td colspan=""2"">&nbsp;</td></tr>" 
RenewalLetter = RenewalLetter & "<TR><TD colspan=""2"">" & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & "<BR>" & rsCustInfo("ShipAddress1") & "<BR>" & vbCrLf
If rsCustInfo("ShipAddress2") <> "" Then
	RenewalLetter = RenewalLetter & rsCustInfo("ShipAddress2") & "<BR>" & vbCrLf
End If
RenewalLetter = RenewalLetter & rsCustInfo("ShipCity") & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "</TD></TR></TABLE><BR><BR>" & vbCrLf

RenewalLetter = RenewalLetter & "Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ",<br /><br />" & vbCrLf
RenewalLetter = RenewalLetter & "<table border=""0"" width=""750""><tr><td>" & vbCrLf & vbCrLf

RenewalLetter = RenewalLetter & "We are very grateful and thrilled for your past support of CenterPoint Legacy Theatre as a Season Ticket Holder. We are excited to have you join us again for our 2014 Season. Please use the enclosed Season magnet as a great reminder of your reserved dates.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "As a current Season Ticket Holder you now have the opportunity to secure the same seats for the 2014 Season starting today thru August 25! To renew, simply visit our website and enter your Order Number and Renewal Code listed on the attached page; call or come into the Box Office; or you may mail or fax us the attached order page with your payment information. All renewal orders must be received before August 25. <BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<b>You must renew your tickets</b> between August 5 and August 25. <b>Failing to renew will release your seats</b>, making them available for sale to the general public. Once you have renewed your current seats, you will have an opportunity to make adjustments or purchase additional season tickets from August 29 thru September 14, 2013. <BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Next season CenterPoint Theatre will offer two matinee performances per show. If you would like to move your 2014 tickets to a matinee, please contact the box office to complete your renewal.<BR><BR>" & vbCrLf

RenewalLetter = RenewalLetter & "<b>To keep the same seats for the 2014 Season, you must complete your renewal by August 25, 2013.</b><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "There are three ways to renew your Season Tickets:<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<UL>" & vbCrLf
RenewalLetter = RenewalLetter & "<LI><b>Renew online</b> at www.CenterPointTheatre.org.  Simply click on the Season Ticket Renewal link and enter your Order Number and Renewal Code from the attached page</LI>" & vbCrLf
RenewalLetter = RenewalLetter & "<LI><b>Come into the Box Office</b> or <b>Call</b> us at (801) 298-1302. (Phones can be very busy)</LI>" & vbCrLf
RenewalLetter = RenewalLetter & "<LI><b>Mail/Fax</b> the attached form to us with your payment information - Fax (801) 298-4784</LI>" & vbCrLf
RenewalLetter = RenewalLetter & "</UL>" & vbCrLf

RenewalLetter = RenewalLetter & "Please address your renewal questions to the box office staff.<BR><BR>" & vbCrLf

RenewalLetter = RenewalLetter & "Yours truly,<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<span class=""signature"">Jansen Davis</span><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Executive Director<BR><BR>" & vbCrLf

RenewalLetter = RenewalLetter & "<center>" & vbCrLf
RenewalLetter = RenewalLetter & "<table class=""smalltable"">" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td colspan=""3""><b>Buying season tickets saves you more than 25% off the single ticket price!</b></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td colspan=""3"">&nbsp;</td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td>&nbsp;</td><td align=""right""><b>Tu/We/Mat</b></td><td align=""right""><b>Mo/Th/Fr/Sa</b></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><b>Main Level Adult</b></td><td align=""right"">$99.00</td><td align=""right"">$110.00</td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><b>Main Level Senior/Student</b></td><td align=""right"">$94.00</td><td align=""right"">$105.00</td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><b>Balcony Level Adult</b></td><td align=""right"">$89.00</td><td align=""right"">$100.00</td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><b>Balcony Level Senior/Student</b></td><td align=""right"">$84.00</td><td align=""right"">$95.00</td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "</table>" & vbCrLf
RenewalLetter = RenewalLetter & "</center>" & vbCrLf

RenewalLetter = RenewalLetter & "</td></tr></table>" & vbCrLf
RenewalLetter = RenewalLetter & "<DIV>&nbsp;</DIV>" & vbCrLf

Response.Write RenewalLetter

%>  





