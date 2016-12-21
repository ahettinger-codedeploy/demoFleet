<% 
'CHANGE LOG
'JAI 10/19/11 - 2012 Update
'JAI 10/11/12 - 2013 Update

RenewalLetter = "<CENTER>" & vbCrLf
RenewalLetter = RenewalLetter & "<table border=""0"" width=""745"">" & vbCrLf

Select Case LetterFormat
    Case "HAN"
        RenewalLetter = RenewalLetter & "<tr><td align=""center""><FONT FACE=Calibri,Charcoal,Arial><IMG SRC=""http://www.tix.com/PrivateLabel/CastrolRaceway/Conversion/CastrolRaceway.png""></FONT></td></tr>" & vbCrLf
        RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial><BR>" & MonthName(Month(Now())) & " " & Day(Now()) & ", " & Year(Now()) & "</FONT><br><br></td></tr>" & vbCrLf
        RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ":<br><br>" & vbCrLf
        RenewalLetter = RenewalLetter & "<center><FONT SIZE=""5"">SEE THE SKIES LIGHT UP WITH</FONT><BR>" & vbCrLf
        RenewalLetter = RenewalLetter & "<FONT SIZE=""5"">FLAMES, SMOKE, AND SPEEDS EXCEEDING 300MPH</FONT></center><BR>" & vbCrLf
        RenewalLetter = RenewalLetter & "<b>Event Date: AUGUST 13, 2014</b><BR><BR>" & vbCrLf
        RenewalLetter = RenewalLetter & "<b>SAVE YOUR SEAT TODAY! RENEWALS AVAILABLE OCTOBER 21 - NOVEMBER 20, 2013</b><BR><BR>" & vbCrLf
        RenewalLetter = RenewalLetter & "Hot August Night is the largest Jet Car show in Canada with the 2014 event hosting 8 Jets from throughout the United States and Canada. Not only does Hot August Night give us a great big ball of Jet fire, it showcases the best of the best of Western Canada’s extreme motorsports. Nitro Funny Cars, Alcohol Funny Cars, and 200MPH Top Fuel Harleys are just the tip of the iceberg for this fan favorite event. Hot August Night has been a long standing tradition at Castrol Raceway, as the single largest one day event year after year. <BR><BR>" & vbCrLf
        RenewalLetter = RenewalLetter & "<center><FONT SIZE=""5"">YOUR HEART WILL BEAT FASTER AND YOUR ADRENALINE WILL FLOW;</FONT><BR>" & vbCrLf
        RenewalLetter = RenewalLetter & "<FONT SIZE=""5"">GUARANTEED - HOT AUGUST NIGHT</FONT></center><BR>" & vbCrLf

    Case "RMN"
        RenewalLetter = RenewalLetter & "<tr><td align=""center""><FONT FACE=Calibri,Charcoal,Arial><IMG SRC=""http://www.tix.com/PrivateLabel/CastrolRaceway/Conversion/CastrolRaceway.png""><IMG SRC=""http://www.tix.com/Images/Clear.gif"" HEIGHT=""111"" WIDTH=""150""><IMG SRC=""http://www.tix.com/PrivateLabel/CastrolRaceway/Conversion/RMNLogo.jpg""></FONT></td></tr>" & vbCrLf
        RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial><BR>" & MonthName(Month(Now())) & " " & Day(Now()) & ", " & Year(Now()) & "</FONT><br><br></td></tr>" & vbCrLf
        RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ":<br><br>" & vbCrLf
        RenewalLetter = RenewalLetter & "<center><FONT SIZE=""5"">A NEW ERA IN POWERFUL ENTERTAINMENT:</FONT><BR>" & vbCrLf
        RenewalLetter = RenewalLetter & "<FONT SIZE=""5"">NITRO JAM RETURNS FOR ANOTHER INCREDIBLE WEEKEND</FONT></center><BR>" & vbCrLf
        RenewalLetter = RenewalLetter & "<b>Event Dates: JULY 4-6, 2014</b><BR><BR>" & vbCrLf
        RenewalLetter = RenewalLetter & "<b>SAVE YOUR SEAT TODAY! RENEWALS AVAILABLE OCTOBER 21 - NOVEMBER 20, 2013</b><BR><BR>" & vbCrLf
        RenewalLetter = RenewalLetter & "After getting away from traditional racing and exploring a more entertainment-based program over the past three years under Feld Motor Sports, the IHRA under new ownership has announced that it will be combining the best of both worlds with the return of traditional elimination-style racing in its professional classes while still maintaining a family-friendly format.<BR><BR>" & vbCrLf
        RenewalLetter = RenewalLetter & "<center><FONT SIZE=""3"">Back and better than before is the 13th Annual:</FONT><BR>" & vbCrLf
        RenewalLetter = RenewalLetter & "<FONT SIZE=""4"">Mopar NITRO JAM Rocky Mountain Nationals</FONT><BR>" & vbCrLf
        RenewalLetter = RenewalLetter & "<FONT SIZE=""4"">presented by Good Vibrations featuring the SMS Equipment Night of Fire</FONT></center><BR>" & vbCrLf

    Case "WOO"
        RenewalLetter = RenewalLetter & "<tr><td align=""center""><FONT FACE=Calibri,Charcoal,Arial><IMG SRC=""http://www.tix.com/PrivateLabel/CastrolRaceway/Conversion/CastrolRaceway.png""><IMG SRC=""http://www.tix.com/Images/Clear.gif"" HEIGHT=""111""WIDTH=""150""><IMG SRC=""http://www.tix.com/PrivateLabel/CastrolRaceway/Conversion/WOOLogo.jpg""></FONT></td></tr>" & vbCrLf
        RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial><BR>" & MonthName(Month(Now())) & " " & Day(Now()) & ", " & Year(Now()) & "</FONT><br><br></td></tr>" & vbCrLf
        RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ":<br><br>" & vbCrLf
        RenewalLetter = RenewalLetter & "<center><FONT SIZE=""5"">THRILL PACKED ACTION RETURNS IN 2014</FONT><BR>" & vbCrLf
        RenewalLetter = RenewalLetter & "<FONT SIZE=""5"">THE GREATEST SHOW ON DIRT: THE STP WORLD OF OUTLAWS</FONT></center><BR>" & vbCrLf
        RenewalLetter = RenewalLetter & "<b>Event Dates: AUGUST 22 & 23, 2014</b><BR><BR>" & vbCrLf
        RenewalLetter = RenewalLetter & "<b>SAVE YOUR SEAT TODAY! RENEWALS AVAILABLE OCTOBER 21 - NOVEMBER 20, 2013</b><BR><BR>" & vbCrLf
        RenewalLetter = RenewalLetter & "The best drivers in the world, return for the 8th Annual World of Outlaws: Oil City Cup. The winged warriors will do battle with their fire-breathing 850-plus horsepower machines each night for the $10,000 top prize.  The Oil City Cup is the only chance in 2014 that Sprint Car fans in Western Canada have to see the World of Outlaws in action, with their thrilling wheel-to-wheel brand of racing, just centimeters apart at breathtaking speeds.<BR><BR>" & vbCrLf
        RenewalLetter = RenewalLetter & "<center><FONT SIZE=""4"">Back and better than before is the 8th Annual:</FONT><BR>" & vbCrLf
        RenewalLetter = RenewalLetter & "<FONT SIZE=""5"">The STP World of Outlaws: Oil City Cup</FONT></center><BR>" & vbCrLf

    Case Else 'Error
        RenewalLetter = RenewalLetter & "<tr><td align=""center""><FONT FACE=Calibri,Charcoal,Arial><IMG SRC=""http://www.tix.com/PrivateLabel/CastrolRaceway/Conversion/CastrolRaceway.png""></FONT></td></tr>" & vbCrLf
        RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial><BR>" & MonthName(Month(Now())) & " " & Day(Now()) & ", " & Year(Now()) & "</FONT><br><br></td></tr>" & vbCrLf
        RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ":<br><br>" & vbCrLf
        RenewalLetter = RenewalLetter & "<b>SAVE YOUR SEAT TODAY! RENEWALS AVAILABLE OCTOBER 21 - NOVEMBER 20, 2013</b><BR><BR>" & vbCrLf

End Select

RenewalLetter = RenewalLetter & "<b>QUICK & EASY - SAVE YOUR SEAT ONLINE: </b> <a href=" & EMailRenewalURL & ">" & EMailRenewalURL & "</a><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "You will be prompted for your Order Number and Renewal Code which can be found on the included Save My Seat ordering information below. To receive further information and savings, sign up on-line as a Castrol Raceway e-letter subscriber to receive special news, announcements, and promotions throughout the season.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<b>MAIL/PHONE ORDERS & SEAT UPGRADES:</b> If you are mailing your order in, please print and fill out the bottom portion of this form before sending to the Castrol Raceway office with full payment. You can also contact the Castrol Raceway office directly at anytime <b>" & EMailPhone & "</b>, to renew your order over the phone or If you would like to upgrade your seats. You must contact the Castrol Raceway office to do so before the Nov 20th cutoff date.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "See you at the Races!<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<b>Kimberly Reeves,</b> Owner<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Castrol Raceway<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Office: 780.461.5801<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Hotline: 780.468-FAST	<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<a href=""www.CastrolRaceway.com"">www.CastrolRaceway.com</a></FONT></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "</table>" & vbCrLf
RenewalLetter = RenewalLetter & "<br /><HR><br />" & vbCrLf

EMailMessage = EMailMessage & RenewalLetter

%>  





