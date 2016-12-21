<%

'CHANGE LOG

'SSR 7/19/16 - Created 2016 Season Renewal Include Script - based on 2015 version
'SSR 7/20/16 - Added yellow background to highlight the renewal deadline dates.
'SSR 7/20/16 - Changed salutation.

RenewalLetter = ""

Select Case fnTemplateDetail("Index")

Case 27 'Fixed

RenewalLetter = RenewalLetter & "<div class=""section""> " & vbCrLf
RenewalLetter = RenewalLetter & "<table border=""0"" cellpadding=""0"" cellspacing=""0"" WIDTH=""100%""> " & vbCrLf 
RenewalLetter = RenewalLetter & "<tbody> " & vbCrLf 
RenewalLetter = RenewalLetter & "<tr> " & vbCrLf 
RenewalLetter = RenewalLetter & "<td> " & vbCrLf 
RenewalLetter = RenewalLetter & "<p align=""center""> " & vbCrLf 
RenewalLetter = RenewalLetter & "<img src=""https://cdn.pbrd.co/images/bS3EgB7ev.png"" /> " & vbCrLf 
RenewalLetter = RenewalLetter & "</p> " & vbCrLf 
RenewalLetter = RenewalLetter & "</td> " & vbCrLf 
RenewalLetter = RenewalLetter & "</tr> " & vbCrLf 
RenewalLetter = RenewalLetter & "<tr> " & vbCrLf 
RenewalLetter = RenewalLetter & "<td> " & vbCrLf 
RenewalLetter = RenewalLetter & "<table border=""0"" width=""100%""> " & vbCrLf 
RenewalLetter = RenewalLetter & "<tr> " & vbCrLf 
RenewalLetter = RenewalLetter & "<td> " & vbCrLf 
RenewalLetter = RenewalLetter & "August 1, 2016<BR> " & vbCrLf 
RenewalLetter = RenewalLetter & "<BR> " & vbCrLf 
RenewalLetter = RenewalLetter & "Return Service Requested<BR> " & vbCrLf 
RenewalLetter = RenewalLetter & "<BR> " & vbCrLf 
RenewalLetter = RenewalLetter & "" & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & "<BR> " & vbCrLf
RenewalLetter = RenewalLetter & rsCustInfo("ShipAddress1") & "<BR>" & vbCrLf
If rsCustInfo("ShipAddress2") <> "" Then
	RenewalLetter = RenewalLetter & rsCustInfo("ShipAddress2") & "<BR>" & vbCrLf
End If
RenewalLetter = RenewalLetter & rsCustInfo("ShipCity") & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "" & vbCrLf
RenewalLetter = RenewalLetter & "</td> " & vbCrLf 
RenewalLetter = RenewalLetter & "<td width=""35%"" align=""center""> " & vbCrLf 
RenewalLetter = RenewalLetter & "<h2> " & vbCrLf 
RenewalLetter = RenewalLetter & "You must complete<BR> " & vbCrLf 
RenewalLetter = RenewalLetter & "your renewal by<BR> " & vbCrLf 
RenewalLetter = RenewalLetter & "<span style=""color:#900A2F;"">September 3rd, 2016.</span> " & vbCrLf 
RenewalLetter = RenewalLetter & "</h2> " & vbCrLf 
RenewalLetter = RenewalLetter & "</td> " & vbCrLf 
RenewalLetter = RenewalLetter & "</tr> " & vbCrLf 
RenewalLetter = RenewalLetter & "</table> " & vbCrLf 
RenewalLetter = RenewalLetter & "</td> " & vbCrLf 
RenewalLetter = RenewalLetter & "</tr> " & vbCrLf 
RenewalLetter = RenewalLetter & "<tr> " & vbCrLf 
RenewalLetter = RenewalLetter & "<td> " & vbCrLf 
RenewalLetter = RenewalLetter & "<BR> " & vbCrLf 
RenewalLetter = RenewalLetter & "<p> " & vbCrLf 
RenewalLetter = RenewalLetter & "Dear " & rsCustInfo("ShipFirstName") & "," & vbCrLf
RenewalLetter = RenewalLetter & "</p> " & vbCrLf 
RenewalLetter = RenewalLetter & "<p> " & vbCrLf 
RenewalLetter = RenewalLetter & "Our 2017 season is another great season! It is such an honor for us at CenterPoint Legacy Theatre to bring you a variety of theatrical experiences. " & vbCrLf 
RenewalLetter = RenewalLetter & "From the classics to newer works destined to become classics, we strive to create an experience that engages, entertains and enriches you each time you " & vbCrLf 
RenewalLetter = RenewalLetter & "come to Our Community’s Theatre. " & vbCrLf 
RenewalLetter = RenewalLetter & "</p> " & vbCrLf 
RenewalLetter = RenewalLetter & "<p> " & vbCrLf 
RenewalLetter = RenewalLetter & "As a Season Ticket Subscriber you now have the opportunity to renew for the 2017 Season.<strong> </strong>To do so,<strong> you must renew </strong> " & vbCrLf 
RenewalLetter = RenewalLetter & "between now and September 3<sup>rd</sup>. " & vbCrLf 
RenewalLetter = RenewalLetter & "</p> " & vbCrLf 
RenewalLetter = RenewalLetter & "<p> " & vbCrLf 
RenewalLetter = RenewalLetter & "How to renew: " & vbCrLf 
RenewalLetter = RenewalLetter & "</p> " & vbCrLf 
RenewalLetter = RenewalLetter & "<table border=""0""> " & vbCrLf 
RenewalLetter = RenewalLetter & "<tr> " & vbCrLf 
RenewalLetter = RenewalLetter & "<td width=""7%"" align=""left"" valign=""top"">&nbsp;</td> " & vbCrLf 
RenewalLetter = RenewalLetter & "<td width=""23%"" align=""left"" valign=""top""> " & vbCrLf 
RenewalLetter = RenewalLetter & "<b>ONLINE</b> - Visit CPTUtah.org<BR> " & vbCrLf 
RenewalLetter = RenewalLetter & "<p style=""font-size:12px; margin-top:5px; font-style: italic""> " & vbCrLf 
RenewalLetter = RenewalLetter & "Simply click on the Season Ticket Renewal link and enter your Order Number and Renewal Code from the attached invoice " & vbCrLf 
RenewalLetter = RenewalLetter & "</p> " & vbCrLf 
RenewalLetter = RenewalLetter & "</td> " & vbCrLf 
RenewalLetter = RenewalLetter & "<td width=""8%"" align=""center"" valign=""top"">Or</td> " & vbCrLf 
RenewalLetter = RenewalLetter & "<td width=""23%"" align=""left"" valign=""top""> " & vbCrLf 
RenewalLetter = RenewalLetter & "<b>VISIT US</b> - Stop by or call the box office 801.298.1302<BR> " & vbCrLf 
RenewalLetter = RenewalLetter & "<p style=""font-size:12px; margin-top:5px; font-style: italic""> " & vbCrLf 
RenewalLetter = RenewalLetter & "Wait times on the phone may be longer than normal due to increased calls for renewals " & vbCrLf 
RenewalLetter = RenewalLetter & "</p> " & vbCrLf 
RenewalLetter = RenewalLetter & "</td> " & vbCrLf 
RenewalLetter = RenewalLetter & "<td width=""8%"" align=""center"" valign=""top"">Or</td> " & vbCrLf 
RenewalLetter = RenewalLetter & "<td width=""23%"" align=""left"" valign=""top""> " & vbCrLf 
RenewalLetter = RenewalLetter & "<b>MAIL/FAX</b> - Fax - 801.298.4784 PO Box 62 Centerville, UT 84014<BR> " & vbCrLf 
RenewalLetter = RenewalLetter & "<p style=""font-size:12px; margin-top:5px; font-style: italic""> " & vbCrLf 
RenewalLetter = RenewalLetter & "Send us the attached invoice with your payment information " & vbCrLf 
RenewalLetter = RenewalLetter & "</p> " & vbCrLf 
RenewalLetter = RenewalLetter & "</td> " & vbCrLf 
RenewalLetter = RenewalLetter & "<td width=""7%"" align=""left"" valign=""top"">&nbsp;</td> " & vbCrLf 
RenewalLetter = RenewalLetter & "</tr> " & vbCrLf 
RenewalLetter = RenewalLetter & "</table> " & vbCrLf 
RenewalLetter = RenewalLetter & "</td> " & vbCrLf 
RenewalLetter = RenewalLetter & "</tr> " & vbCrLf 
RenewalLetter = RenewalLetter & "<tr> " & vbCrLf 
RenewalLetter = RenewalLetter & "<td> " & vbCrLf 
RenewalLetter = RenewalLetter & "<p> " & vbCrLf 
RenewalLetter = RenewalLetter & "If you would like to change your 2017 subscription to a matinee, balcony, or a Flex Pass Subscription, please contact the box office to complete your " & vbCrLf 
RenewalLetter = RenewalLetter & "renewal. " & vbCrLf 
RenewalLetter = RenewalLetter & "</p> " & vbCrLf 
RenewalLetter = RenewalLetter & "<p> " & vbCrLf 
RenewalLetter = RenewalLetter & "Please address all other renewal questions to the box office staff. " & vbCrLf 
RenewalLetter = RenewalLetter & "</p> " & vbCrLf 
RenewalLetter = RenewalLetter & "<p> " & vbCrLf 
RenewalLetter = RenewalLetter & "Thank you for your past support of CenterPoint Legacy Theatre as a Season Subscriber. We look forward to having you join us again for our 2017 Season! " & vbCrLf 
RenewalLetter = RenewalLetter & "</p> " & vbCrLf 
RenewalLetter = RenewalLetter & "<p> " & vbCrLf 
RenewalLetter = RenewalLetter & "With warm regards,<BR> " & vbCrLf 
RenewalLetter = RenewalLetter & "<img src=""https://cdn.pbrd.co/images/bS4WDAalU.png"" width=""150px""/><BR> " & vbCrLf 
RenewalLetter = RenewalLetter & "Executive Director<BR> " & vbCrLf 
RenewalLetter = RenewalLetter & "CenterPoint Legacy Theatre<BR> " & vbCrLf 
RenewalLetter = RenewalLetter & "</p> " & vbCrLf 
RenewalLetter = RenewalLetter & "<p style=""font-size:12px; background-color:#FFFF00; color:#000000;""> " & vbCrLf 
RenewalLetter = RenewalLetter & "<strong> Exchanges: </strong> " & vbCrLf 
RenewalLetter = RenewalLetter & "After you have renewed your current subscription<strong>,</strong> you will have an opportunity to make adjustments or purchase additional season " & vbCrLf 
RenewalLetter = RenewalLetter & "subscriptions starting September 12<sup>th</sup>. However, you must renew by September 3<sup>rd</sup> for this opportunity.<strong></strong> " & vbCrLf 
RenewalLetter = RenewalLetter & "</p> " & vbCrLf 
RenewalLetter = RenewalLetter & "</td> " & vbCrLf 
RenewalLetter = RenewalLetter & "</tr> " & vbCrLf 
RenewalLetter = RenewalLetter & "</tbody> " & vbCrLf 
RenewalLetter = RenewalLetter & "</table> " & vbCrLf
RenewalLetter = RenewalLetter & "</div> " & vbCrLf

Case 28  'Flex

RenewalLetter = RenewalLetter & "<div class=""section""> " & vbCrLf
RenewalLetter = RenewalLetter & "<table border=""0"" cellpadding=""0"" cellspacing=""0"" WIDTH=""100%""> " & vbCrLf
RenewalLetter = RenewalLetter & "<tbody> " & vbCrLf
RenewalLetter = RenewalLetter & "<tr> " & vbCrLf
RenewalLetter = RenewalLetter & "<td> " & vbCrLf
RenewalLetter = RenewalLetter & "<p align=""center""> " & vbCrLf
RenewalLetter = RenewalLetter & "<img src=""https://cdn.pbrd.co/images/bS3EgB7ev.png"" /> " & vbCrLf
RenewalLetter = RenewalLetter & "</p> " & vbCrLf
RenewalLetter = RenewalLetter & "</td> " & vbCrLf
RenewalLetter = RenewalLetter & "</tr> " & vbCrLf
RenewalLetter = RenewalLetter & "<tr> " & vbCrLf
RenewalLetter = RenewalLetter & "<td> " & vbCrLf
RenewalLetter = RenewalLetter & "<table border=""0"" width=""100%""> " & vbCrLf
RenewalLetter = RenewalLetter & "<tr> " & vbCrLf
RenewalLetter = RenewalLetter & "<td> " & vbCrLf
RenewalLetter = RenewalLetter & "August 1, 2016<BR> " & vbCrLf
RenewalLetter = RenewalLetter & "<BR> " & vbCrLf
RenewalLetter = RenewalLetter & "Return Service Requested<BR> " & vbCrLf
RenewalLetter = RenewalLetter & "<BR> " & vbCrLf
RenewalLetter = RenewalLetter & "" & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & "<BR> " & vbCrLf
RenewalLetter = RenewalLetter & rsCustInfo("ShipAddress1") & "<BR>" & vbCrLf
If rsCustInfo("ShipAddress2") <> "" Then
	RenewalLetter = RenewalLetter & rsCustInfo("ShipAddress2") & "<BR>" & vbCrLf
End If
RenewalLetter = RenewalLetter & rsCustInfo("ShipCity") & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "" & vbCrLf
RenewalLetter = RenewalLetter & "</td> " & vbCrLf
RenewalLetter = RenewalLetter & "<td width=""35%"" align=""center""> " & vbCrLf
RenewalLetter = RenewalLetter & "<h2> " & vbCrLf
RenewalLetter = RenewalLetter & "You must complete<BR> " & vbCrLf
RenewalLetter = RenewalLetter & "your renewal by<BR> " & vbCrLf
RenewalLetter = RenewalLetter & "<span style=""color:#900A2F;"">September 3rd, 2016.</span> " & vbCrLf
RenewalLetter = RenewalLetter & "</h2> " & vbCrLf
RenewalLetter = RenewalLetter & "</td> " & vbCrLf
RenewalLetter = RenewalLetter & "</tr> " & vbCrLf
RenewalLetter = RenewalLetter & "</table> " & vbCrLf
RenewalLetter = RenewalLetter & "</td> " & vbCrLf
RenewalLetter = RenewalLetter & "</tr> " & vbCrLf
RenewalLetter = RenewalLetter & "<tr> " & vbCrLf
RenewalLetter = RenewalLetter & "<td> " & vbCrLf
RenewalLetter = RenewalLetter & "<BR> " & vbCrLf
RenewalLetter = RenewalLetter & "<p> " & vbCrLf
RenewalLetter = RenewalLetter & "Dear " & rsCustInfo("ShipFirstName") & "," & vbCrLf
RenewalLetter = RenewalLetter & "</p> " & vbCrLf
RenewalLetter = RenewalLetter & "<p> " & vbCrLf
RenewalLetter = RenewalLetter & "Our 2017 season is another great season! It is such an honor for us at CenterPoint Legacy Theatre to bring you a variety of theatrical experiences. " & vbCrLf
RenewalLetter = RenewalLetter & "From the classics to newer works destined to become classics, we strive to create an experience that engages, entertains and enriches you each time you " & vbCrLf
RenewalLetter = RenewalLetter & "come to Our Community’s Theatre. " & vbCrLf
RenewalLetter = RenewalLetter & "</p> " & vbCrLf
RenewalLetter = RenewalLetter & "<p> " & vbCrLf
RenewalLetter = RenewalLetter & "As a Flex Pass Subscriber you now have the opportunity to renew for the 2017 Season.<strong> </strong>To do so,<strong> you must renew </strong>between " & vbCrLf
RenewalLetter = RenewalLetter & "now and September 3<sup>rd</sup>. " & vbCrLf
RenewalLetter = RenewalLetter & "</p> " & vbCrLf
RenewalLetter = RenewalLetter & "<p> " & vbCrLf
RenewalLetter = RenewalLetter & "How to renew: " & vbCrLf
RenewalLetter = RenewalLetter & "</p> " & vbCrLf
RenewalLetter = RenewalLetter & "<table border=""0""> " & vbCrLf
RenewalLetter = RenewalLetter & "<tr> " & vbCrLf
RenewalLetter = RenewalLetter & "<td width=""7%"" align=""left"" valign=""top"">&nbsp;</td> " & vbCrLf
RenewalLetter = RenewalLetter & "<td width=""23%"" align=""left"" valign=""top""> " & vbCrLf
RenewalLetter = RenewalLetter & "<b>ONLINE</b> - Visit CPTUtah.org<BR> " & vbCrLf
RenewalLetter = RenewalLetter & "<p style=""font-size:12px; margin-top:5px; font-style: italic""> " & vbCrLf
RenewalLetter = RenewalLetter & "Simply click on the Season Ticket Renewal link and enter your Order Number and Renewal Code from the attached invoice " & vbCrLf
RenewalLetter = RenewalLetter & "</p> " & vbCrLf
RenewalLetter = RenewalLetter & "</td> " & vbCrLf
RenewalLetter = RenewalLetter & "<td width=""8%"" align=""center"" valign=""top"">Or</td> " & vbCrLf
RenewalLetter = RenewalLetter & "<td width=""23%"" align=""left"" valign=""top""> " & vbCrLf
RenewalLetter = RenewalLetter & "<b>VISIT US</b> - Stop by or call the box office 801.298.1302<BR> " & vbCrLf
RenewalLetter = RenewalLetter & "<p style=""font-size:12px; margin-top:5px; font-style: italic""> " & vbCrLf
RenewalLetter = RenewalLetter & "Wait times on the phone may be longer than normal due to increased calls for renewals " & vbCrLf
RenewalLetter = RenewalLetter & "</p> " & vbCrLf
RenewalLetter = RenewalLetter & "</td> " & vbCrLf
RenewalLetter = RenewalLetter & "<td width=""8%"" align=""center"" valign=""top"">Or</td> " & vbCrLf
RenewalLetter = RenewalLetter & "<td width=""23%"" align=""left"" valign=""top""> " & vbCrLf
RenewalLetter = RenewalLetter & "<b>MAIL/FAX</b> - Fax - 801.298.4784 PO Box 62 Centerville, UT 84014<BR> " & vbCrLf
RenewalLetter = RenewalLetter & "<p style=""font-size:12px; margin-top:5px; font-style: italic""> " & vbCrLf
RenewalLetter = RenewalLetter & "Send us the attached invoice with your payment information " & vbCrLf
RenewalLetter = RenewalLetter & "</p> " & vbCrLf
RenewalLetter = RenewalLetter & "</td> " & vbCrLf
RenewalLetter = RenewalLetter & "<td width=""7%"" align=""left"" valign=""top"">&nbsp;</td> " & vbCrLf
RenewalLetter = RenewalLetter & "</tr> " & vbCrLf
RenewalLetter = RenewalLetter & "</table> " & vbCrLf
RenewalLetter = RenewalLetter & "</td> " & vbCrLf
RenewalLetter = RenewalLetter & "</tr> " & vbCrLf
RenewalLetter = RenewalLetter & "<tr> " & vbCrLf
RenewalLetter = RenewalLetter & "<td> " & vbCrLf
RenewalLetter = RenewalLetter & "<p> " & vbCrLf
RenewalLetter = RenewalLetter & "If you would like to change your 2017 subscription to a Traditional Subscription, please contact the box office to complete your renewal. " & vbCrLf
RenewalLetter = RenewalLetter & "</p> " & vbCrLf
RenewalLetter = RenewalLetter & "<p> " & vbCrLf
RenewalLetter = RenewalLetter & "Please address all other renewal questions to the box office staff. " & vbCrLf
RenewalLetter = RenewalLetter & "</p> " & vbCrLf
RenewalLetter = RenewalLetter & "<p> " & vbCrLf
RenewalLetter = RenewalLetter & "Thank you for your past support of CenterPoint Legacy Theatre as a Season Subscriber. We look forward to having you join us again for our 2017 Season! " & vbCrLf
RenewalLetter = RenewalLetter & "</p> " & vbCrLf
RenewalLetter = RenewalLetter & "<p> " & vbCrLf
RenewalLetter = RenewalLetter & "With warm regards,<BR> " & vbCrLf
RenewalLetter = RenewalLetter & "<img src=""https://cdn.pbrd.co/images/bS4WDAalU.png"" width=""150px""/><BR> " & vbCrLf
RenewalLetter = RenewalLetter & "Executive Director<BR> " & vbCrLf
RenewalLetter = RenewalLetter & "CenterPoint Legacy Theatre<BR> " & vbCrLf
RenewalLetter = RenewalLetter & "</p> " & vbCrLf
RenewalLetter = RenewalLetter & "<p style=""font-size:12px; background-color:#FFFF00; color:#000000;""> " & vbCrLf 
RenewalLetter = RenewalLetter & "<strong>Exchanges: </strong> " & vbCrLf
RenewalLetter = RenewalLetter & "After you have renewed your current subscription<strong>,</strong> you will have an opportunity to make adjustments or change to a Traditional Season " & vbCrLf
RenewalLetter = RenewalLetter & "Subscription starting September 12<sup>th</sup>. However, you must renew by September 3<sup>rd</sup> for this opportunity. " & vbCrLf
RenewalLetter = RenewalLetter & "</p> " & vbCrLf
RenewalLetter = RenewalLetter & "</td> " & vbCrLf
RenewalLetter = RenewalLetter & "</tr> " & vbCrLf
RenewalLetter = RenewalLetter & "</tbody> " & vbCrLf
RenewalLetter = RenewalLetter & "</table> " & vbCrLf
RenewalLetter = RenewalLetter & "</div> " & vbCrLf

End Select

RenewalLetter = RenewalLetter & "<div class=""page-break""></div>" & vbCrLf

Response.Write RenewalLetter

%>  





