<% 
'CHANGE LOG
'JAI 10/19/11 - 2012 Update
'JAI 10/11/12 - 2013 Update
'JAI 10/24/14 - Updated for 2015.
'JAI 11/2/15 - Updated for 2016.

RenewalLetter = "<CENTER>" & vbCrLf
RenewalLetter = RenewalLetter & "<table border=""0"" width=""745"">" & vbCrLf

Select Case LetterFormat
Case "DPS"

    RenewalLetter = RenewalLetter & "<tr><td align=""center""><FONT FACE=Calibri,Charcoal,Arial><IMG SRC=""http://www.tix.com/PrivateLabel/CastrolRaceway/Conversion/CastrolHeader.png"" WIDTH=""700""></FONT><br />" & vbCrLf

    RenewalLetter = RenewalLetter & "<FONT FACE=Calibri,Charcoal,Arial SIZE=""6"">2016 - ""SAVE MY PIT SPOT"" RENEWAL PROGRAM</FONT></td></tr>" & vbCrLf

    RenewalLetter = RenewalLetter & "<tr><td align=""left""><FONT FACE=Calibri,Charcoal,Arial>" & vbCrLf
    RenewalLetter = RenewalLetter & "Along with your 2016 Competitor Welcome letter, outlining all policies and guidelines, Castrol Raceway is  pleased to offer you the opportunity to renew your 2015 Pit Stall for the 2016 season, on our tix program, as part of our continuing effort to create ease and comfort to our Drivers, as well as, an opportunity to purchase your Driver and Crew Season Pass.<BR><BR>" & vbCrLf

    RenewalLetter = RenewalLetter & "<tr><td align=""left""><FONT FACE=Calibri,Charcoal,Arial><FONT SIZE=""5"">QUCIK & EASY, ""Save My Pit Spot"" online, with a renewal form ready for completion:</FONT>  <a href=""http://castrolraceway.tix.com/renew.aspx"">http://castrolraceway.tix.com/renew.aspx.</a><BR><BR>" & vbCrLf
    RenewalLetter = RenewalLetter & "<i>You will be prompted for your Order Number and Renewal Code which can be found on the included ordering information below.</i> To receive further information and saving, <u>sign up on-line as a Castrol Raceway e-letter subscriber</u> to receive special news, announcements, and promotions throughout the season.<BR><BR>" & vbCrLf
    RenewalLetter = RenewalLetter & "If you are mailing your order in, please print and fill out the bottom portion of this form before sending to the Castrol Raceway office with full payment. You can also contact the Castrol Raceway office directly at anytime (780) 461-5801, to renew your order over the phone." & vbCrLf
    RenewalLetter = RenewalLetter & "Should you have any change in your mailing address, please notify Castrol Raceway Office.</FONT></td></tr>" & vbCrLf
    RenewalLetter = RenewalLetter & "</table>" & vbCrLf
    
    RenewalLetter = RenewalLetter & "<table width=""745""><tr><td><FONT FACE=Calibri,Charcoal,Arial>See you at the Races,<BR><BR><br/><b>Castrol Raceway</b><br /></FONT></td><td><IMG SRC=""http://www.tix.com/Images/Clear.gif"" WIDTH=""400"" HEIGHT=""1""></td><td><IMG SRC=""http://www.tix.com/PrivateLabel/CastrolRaceway/Conversion/CastrolLogo.png"" WIDTH=""175""></td></tr></table></td></tr>" & vbCrLf
    RenewalLetter = RenewalLetter & "<tr><td align=""center""><FONT FACE=Calibri,Charcoal,Arial><IMG SRC=""http://www.tix.com/PrivateLabel/CastrolRaceway/Conversion/CastrolRaceway.com.png"" WIDTH=""700""></FONT></td></tr>" & vbCrLf


Case "RMN"

    RenewalLetter = RenewalLetter & "<tr><td align=""center""><FONT FACE=Calibri,Charcoal,Arial><IMG SRC=""http://www.tix.com/PrivateLabel/CastrolRaceway/Conversion/CastrolHeader.png"" WIDTH=""700""></FONT></td></tr>" & vbCrLf

    RenewalLetter = RenewalLetter & "<FONT FACE=Calibri,Charcoal,Arial SIZE=""6"">NITRO CHARGE YOUR FUN: 2016 SAVE MY SEAT- TICKET RENEWAL PROGRAM</FONT>" & vbCrLf

    RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial>" & vbCrLf
    RenewalLetter = RenewalLetter & "Sadly, the 2015 race season has come to a close, but… that doesn’t mean we are taking a break. It’s time to start planning for our 16th year at Canada’s Premier Motorsport Complex Castrol Raceway! Back for the 11th season is the Mopar Rocky Mountain Nationals featuring the SMS Equipment Night of Fire, July 15, 16, 17, 2016.<BR>" & vbCrLf

    RenewalLetter = RenewalLetter & "<table width=""100%"">" & vbCrLf
	RenewalLetter = RenewalLetter & "<tr><td ><IMG SRC=""http://www.tix.com/Images/Clear.gif"" WIDTH=""1"" HEIGHT=""1""></td></tr>" & vbCrLf
	RenewalLetter = RenewalLetter & "<tr><td colspan=""3"" style=""background:none; border:inset 4px #333333; border-width:4px 0 0 0; height:1px; width:100%; margin:0px 0px 0px 0px; padding-top:1px;padding-bottom:1px;""><IMG SRC=""http://www.tix.com/Images/Clear.gif"" WIDTH=""1"" HEIGHT=""1""></td></tr></table>" & vbCrLf

    RenewalLetter = RenewalLetter & "<FONT SIZE=""5"">QUICK & EASY: SAVE YOUR SEAT:</FONT>  <a href=""http://castrolraceway.tix.com/renew.aspx"">http://castrolraceway.tix.com/renew.aspx.</a><BR><BR>" & vbCrLf
    RenewalLetter = RenewalLetter & "<i>You will be prompted for your Order Number and Renewal Code which can be found on the included Save My Seat ordering information below. To receive further information and saving, sign up on-line as a Castrol Raceway e-letter subscriber to receive special news, announcements, and promotions throughout the season.<BR><BR>" & vbCrLf
    RenewalLetter = RenewalLetter & "If you are mailing your order in, please print and fill out the bottom portion of this form before sending to the Castrol Raceway office with full payment. You can also contact the Castrol Raceway office directly at anytime (780) 461-5801, to renew your order over the phone or If you would like to upgrade your seats. You must contact the Castrol Raceway office to do so before the Dec. 24, 2015 cutoff date.<BR><BR>" & vbCrLf
    RenewalLetter = RenewalLetter & "Last, but not least, we just wanted to let you know-all the pieces are in place for another exceptional season, except one- YOU! Its fans like you who make Castrol Raceway a success. It is our greatest pleasure to provide the best possible experience for each person coming through our gates. We are very proud of the accomplishments made over the past 16 years and feel we have a great many benefits to offer; Excellent playground, children under 6 free, safe environment, knowledgeable staff, and continually growing and excellent events just to name a few. My family and I love racing and want to keep it alive in Edmonton, this is not our primary business, but a business run on passion. We look forward to having join us again in 2016.<BR><BR>" & vbCrLf
    RenewalLetter = RenewalLetter & "<table><tr><td><FONT FACE=Calibri,Charcoal,Arial>See you at the Races,<BR><BR><b>Castrol Raceway</b><br /></FONT></td><td><IMG SRC=""http://www.tix.com/Images/Clear.gif"" WIDTH=""300"" HEIGHT=""1""></td><td><IMG SRC=""http://www.tix.com/PrivateLabel/CastrolRaceway/Conversion/CastrolLogo.png"" WIDTH=""175""></td></tr></table>" & vbCrLf

    RenewalLetter = RenewalLetter & "<tr><td align=""center""><FONT FACE=Calibri,Charcoal,Arial><IMG SRC=""http://www.tix.com/PrivateLabel/CastrolRaceway/Conversion/CastrolRaceway.com.png"" WIDTH=""700""></FONT></td></tr>" & vbCrLf
    RenewalLetter = RenewalLetter & "</td></tr>" & vbCrLf

Case Else 'Error

    RenewalLetter = RenewalLetter & "<tr><td align=""center""><FONT FACE=Calibri,Charcoal,Arial><IMG SRC=""http://www.tix.com/PrivateLabel/CastrolRaceway/Conversion/CastrolRaceway.png""></FONT></td></tr>" & vbCrLf
    RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial><BR>" & MonthName(Month(Now())) & " " & Day(Now()) & ", " & Year(Now()) & "</FONT><br><br></td></tr>" & vbCrLf
    RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ":<br><br>" & vbCrLf
    RenewalLetter = RenewalLetter & "<b>SAVE YOUR SEAT TODAY! RENEWALS AVAILABLE THROUGH DECEMBER 12, 2014</b><BR><BR>" & vbCrLf
    RenewalLetter = RenewalLetter & "</td></tr>" & vbCrLf

End Select

RenewalLetter = RenewalLetter & "</table>" & vbCrLf
EMailMessage = EMailMessage & RenewalLetter

%>  





