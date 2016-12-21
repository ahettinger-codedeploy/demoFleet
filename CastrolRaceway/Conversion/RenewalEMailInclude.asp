<% 
'CHANGE LOG
'JAI 10/19/11 - 2012 Update
'JAI 10/11/12 - 2013 Update
'JAI 10/24/14 - Updated for 2015.
'JAI 11/2/15 - Updated for 2016.
'SSR 11/17/15 - RenewalEmailInclude014.asp was used for 2016 HAN and RMN emails
'SSR 10/10/16 - Updated for 2016 DPS letters

RenewalLetter = "<CENTER>" & vbCrLf
RenewalLetter = RenewalLetter & "<table border=""0"" width=""745"">" & vbCrLf

Select Case LetterFormat
Case "DPS"

      RenewalLetter = RenewalLetter & "<tr><td align=""center""><FONT FACE=Calibri,Charcoal,Arial><IMG SRC=""http://www.tix.com/PrivateLabel/CastrolRaceway/Conversion/CastrolHeader.png"" WIDTH=""700""></FONT></td></tr>" & vbCrLf
      RenewalLetter = RenewalLetter & "<tr><td align=""left""><FONT FACE=Calibri,Charcoal,Arial>" & vbCrLf

      RenewalLetter = RenewalLetter & "<p align=""center""> <strong>CASTROL RACEWAY</strong> </p>" & vbCrLf 
      RenewalLetter = RenewalLetter & "<p align=""center""> <strong>2017 PITSTALL RENEWAL PROGRAM</strong> </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> <strong> </strong> </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> <strong>WELCOME BACK !</strong> </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> <strong>The 2016 race season has come to a close.</strong> </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> <strong>Were planning for our 20th year</strong> <strong></strong> </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> <strong>at Canada's Premier Motor Sport Complex !</strong> </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> <strong> </strong> </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> <strong>Book your Pitstall and Season Pass now for the 2017 season. </strong> </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> <strong>It’s going to be a great one!</strong> </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> All the pieces are in place for another exceptional season except one- </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> <strong>YOU! </strong> </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> Its our race participants like you who make Castrol Raceway a success. </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> It is our pleasure to provide the best possible experience </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> for each competitor at our facility. </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> <strong>YOU are our Castrol Race Family! </strong> <strong></strong> </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> Our family loves racing and wants to keep it alive in Edmonton. </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> As a family owned business, we run on passion. </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> Our competitors understand that passion. </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> <strong>We look forward to having join us again in </strong> </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> <strong>2017!</strong> </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> Order online or contact the Castrol Raceway office (780) 461-5801 </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> to renew or request changes your pit stall subscription. </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> <strong>You must contact the Castrol Raceway office </strong> </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> <strong>before the Dec. 1/2016 cut-off date. </strong> </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> <strong> </strong> </p> " & vbCrLf
      RenewalLetter = RenewalLetter & "<p align=""center""> <strong>SEE YOU AT THE RACES!</strong> </p>" & vbCrLf
 

      RenewalLetter = RenewalLetter & "</td></tr></table>" & vbCrLf 
      
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





