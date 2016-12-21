<%
RenewalLetter = "<CENTER>" & vbCrLf
RenewalLetter = RenewalLetter & "<table border=""0"" width=""745""><tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td ALIGN=""center""><FONT FACE=Calibri,Charcoal,Arial><IMG SRC=""/PrivateLabel/CastrolRaceway/Conversion/RockyMountain_Kim.jpg""><IMG SRC=""/PrivateLabel/CastrolRaceway/Conversion/SaveMySeat.gif""><IMG SRC=""/PrivateLabel/CastrolRaceway/Conversion/OCC Logo.jpg""></FONT></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial><BR><B>SAVE MY SEAT<BR>Blow Your Mind-Not Your Budget; Weekend Passes ONLY $99<BR>ONLY UNTIL NOVEMBER 15, 2010!!</B><BR></FONT></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial><BR>" & MonthName(Month(Now())) & " " & Day(Now()) & ", " & Year(Now()) & "<br><br></FONT></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ":<br><br>" & vbCrLf
RenewalLetter = RenewalLetter & "With race season over, it’s time to start thinking about the 2011 Race Season, the Rocky Mountain Nationals and the Oil City Cup! The dates of the 2011 events are:  Rocky Mountain Nationals, June 24-26, 2011 and the Oil City Cup, August 26-27, 2011.  Don’t miss out on Western Canada’s largest Motorsports Events! You can get your seats from last year's race by taking part in the Save My Seat program which runs until November 15, 2010.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "With the continued strength of the Canadian dollar, for the second year in a row, Castrol Raceway is able to maintain the <B>lower</B> the ticket prices for the Rocky Mountain Nationals. Unheard of for most entertainment venues, Castrol Raceway in partnership with IHRA and Feld Motorsports is offering tickets at greatly reduced prices. As with the 2010 event, individual day tickets have come down $10 each and Weekend General Admission Tickets are available for <B>ONLY $99</B>. This fantastic offer is only available for a limited time, so renew your tickets <B>TODAY</B>!<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Attached to this letter is your order form to ""Save My Seats"".  You can go online and complete your renewal, send it to the Castrol Raceway office with full payment or you can call the Castrol Raceway office at (780) 461-5801, and we can renew your order over the phone.  If you are sending your order in, please fill out the bottom portion of this form.  If you would like to upgrade your seats, you must call the Castrol Raceway office to do so before the December 1st cut off date.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "To Save Your Seat online, visit http://castrolraceway.tix.com/renew.asp.  You will be prompted for your Order Number and Renewal Code which can be found on the attached Save My Seat form.<BR><BR>" & vbCrLf
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
Response.Write RenewalLetter
Response.Write "<DIV>&nbsp;</DIV>" & vbCrLf
%>  