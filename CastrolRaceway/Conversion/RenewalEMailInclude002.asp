<% 
'CHANGE LOG
'JAI 10/19/11 - 2012 Update

RenewalLetter = "<CENTER>" & vbCrLf
RenewalLetter = RenewalLetter & "<table border=""0"" width=""745""><tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td ALIGN=""center""><FONT FACE=Calibri,Charcoal,Arial><IMG SRC=""http://www.tix.com//PrivateLabel/CastrolRaceway/Conversion/RockyMtnNJLogo.jpg""><IMG SRC=""http://www.tix.com//PrivateLabel/CastrolRaceway/Conversion/SaveMySeat.gif""><IMG SRC=""http://www.tix.com//PrivateLabel/CastrolRaceway/Conversion/OCC Logo.jpg""></FONT></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial><BR><B>SAVE MY SEAT<BR>Blow Your Mind-Not Your Budget; Weekend Passes FROM ONLY $99<BR>ONLY UNTIL NOVEMBER 15, 2011!!</B><BR></FONT></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial><BR>" & MonthName(Month(Now())) & " " & Day(Now()) & ", " & Year(Now()) & "<br><br></FONT></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ":<br><br>" & vbCrLf
RenewalLetter = RenewalLetter & "Ladies and Gentlemen, Start your Summer! It's time to get ready for the 2012 Rocky Mountain Nationals and the Oil City Cup! The dates of the 2012 events are:  Rocky Mountain Nationals, July 6-8, 2012 and the Oil City Cup, August 24-25, 2012.  Don’t miss out on Western Canada’s largest Motorsports Events! You can get your seats from last year's race by taking part in the Save My Seat program which runs until November 15, 2011.  <B>ADULT GA WEEKEND SEATS FOR ONLY $99.</B><BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Castrol Raceway also offers exceptional all inclusive ticketing options with the Rocky Mountain Nationals: Thunder Alley VIP weekend passes and the Oil City Cup: Checkered Flag Club; premium seating, fantastic catered meals, exclusive gifts, preferred parking, private autograph sessions, and much more. Contact Castrol Raceway for further  information and to upgrade your seats today. To receive further information and saving, sign up on-line as a Castrol Raceway e-letter subscriber to receive special news, announcements, and promotions throughout the season.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<B>QUICK & EASY: SAVE YOUR SEAT ONLINE.</B>  You can go online and complete your renewal; visit http://castrolraceway.tix.com/renew.asp. You will be prompted for your Order Number and Renewal Code which can be found on the included Save My Seat  ordering information below.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "If you are mailing your order in, please print and fill out the bottom portion of this form before sending to the Castrol Raceway office with full payment. You can also contact  the Castrol Raceway office directly at anytime (780) 461-5801, to renew your order over the phone or If you would like to upgrade your seats. You must contact the Castrol Raceway office to do so before the Nov 21st cut off date.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "See you at the Races!<BR><BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Castrol Raceway<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<HR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "If you are mailing in your Save My Seat form to Castrol Raceway, please fill out the payment information below.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<B>" & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & "</B><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<B>Order Number: " & rsOrderLine("OrderNumber") & "</B><BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Method of Payment:&nbsp;&nbsp;&nbsp;&nbsp;VISA&nbsp;&nbsp;&nbsp;&nbsp;MASTERCARD&nbsp;&nbsp;&nbsp;&nbsp;CHECK&nbsp;&nbsp;&nbsp;&nbsp;MONEY ORDER<BR><BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Credit Card #:____________________________&nbsp;&nbsp;&nbsp;Expiration Date:__________<BR><BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Check #:______________&nbsp;&nbsp;&nbsp;&nbsp;Amount Paid:______________<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "If your mailing address has changed or is changing, please notify the Castrol Raceway office." & vbCrLf
RenewalLetter = RenewalLetter & "</FONT></TD></TR></TBODY></TABLE></CENTER>" & vbCrLf
RenewalLetter = RenewalLetter & "<DIV>&nbsp;</DIV>" & vbCrLf
EMailMessage = EMailMessage & RenewalLetter

%>  





