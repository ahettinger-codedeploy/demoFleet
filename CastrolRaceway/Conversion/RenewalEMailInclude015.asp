<% 
'CHANGE LOG
'JAI 10/19/11 - 2012 Update
'JAI 10/11/12 - 2013 Update
'JAI 10/24/14 - Updated for 2015.
'JAI 11/2/15 - Updated for 2016.
'SSR 11/17/15 - RenewalEmailInclude014.asp was used for 2016 HAN and RMN emails

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





