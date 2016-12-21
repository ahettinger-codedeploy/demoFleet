<% 
'CHANGE LOG
'SSR - 2014 Renewal Letter


RenewalLetter = "<table border=""0""><tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "<TR><TD><TABLE align=""center""><TR align=""center""><TD WIDTH=""400"" align=""center""><FONT FACE=" & EmailFontFace & "><IMG SRC=""http://www.testtix.com/Clients/HeartofDallasBowl/Renewal/Images/logo.png""><BR><BR></TD></TR></TABLE><BR><BR></TD></TR>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td valign=top><FONT FACE=" & EMailFontFace & ">Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ",<BR><BR>"
'Begin Content
RenewalLetter = RenewalLetter & "<p><FONT FACE=" & EMailFontFace & ">Thank you for your support of the 2013 Heart of Dallas Bowl presented by PlainsCapital Bank featuring Oklahoma State University and Purdue University. Proceeds from last year’s game enabled us to write the Metro Dallas Homeless Alliance a check for $100,000 to help fight homelessness in our city.</span></p>" & vbCrLf
RenewalLetter = RenewalLetter & "<p><FONT FACE=" & EMailFontFace & ">This past year we have been busy improving the national stature of our game. In August we announced a partnership with both the Big 12 and Big Ten conferences to rotate hosting a participant every year beginning in 2014. They will be matched up annually against an opponent from Conference USA through the 2019 bowl. In September, we were pleased to announce that the ownership and management of our game was transferred to ESPN Regional Television. </span></p>" & vbCrLf
RenewalLetter = RenewalLetter & "<p><FONT FACE=" & EMailFontFace & ">With all these upgrades occurring, it is now a great time to renew your tickets for the fourth annual game. We look forward to seeing you on New Year’s Day and providing you a Dallas tradition for years to come. Please make sure to renew before </span><span style=""font-weight: bold;"">November 1</span><span style=""vertical-align: super; font-weight: bold;"">st</span><span>.</span></p>" & vbCrLf
RenewalLetter = RenewalLetter & "<p><FONT FACE=" & EMailFontFace & "><span style=""font-weight: bold;"">There are two easy ways to renew your tickets:</span></p>" & vbCrLf
RenewalLetter = RenewalLetter & "<ol start=""1"" style=""margin: 0; padding: 0;"">" & vbCrLf
RenewalLetter = RenewalLetter & "<li style=""padding-left: 0pt; margin-left: 36pt; padding-bottom: 0pt; direction: ltr; font-family: " & EMailFontFace & ";""><span style=""font-weight: bold;"">Renew On-Line:</span><span> Simply visit our website by </span><span style=""color: #0000ff; text-decoration: underline;""><a href="""&EmailRenewalURL&""" style=""color: inherit; text-decoration: inherit;"">clicking here</a></span><span>, or going to </span><span style=""color: #0000ff; text-decoration: underline;""><a href="""&OrganizationURL&""" style=""color: inherit; text-decoration: inherit;"">"&OrganizationURL&"</a></span><span> and follow the renewal link at the top of the page. Complete the renewal form by entering your order number and renewal code number, which can be found at the bottom of this e-mail, before </span><span style=""font-weight: bold;"">November 1</span><span style=""vertical-align: super; font-weight: bold;"">st</span><span>.</span></li>" & vbCrLf
RenewalLetter = RenewalLetter & "<li style=""padding-left: 0pt; margin-left: 36pt; direction: ltr; font-family: " & EMailFontFace & ";""><span style=""font-weight: bold;"">Call</span><span> our office at (214) 389-4300.</span></li>" & vbCrLf
RenewalLetter = RenewalLetter & "</ol>" & vbCrLf
'End Content
RenewalLetter = RenewalLetter & "</FONT></TD></TR></TBODY></TABLE><BR>" & vbCrLf
EMailMessage = EMailMessage & RenewalLetter

%>  





