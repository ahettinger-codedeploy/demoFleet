<%
RenewalLetter = "<CENTER><table border=""0"" width=""600""><tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td ALIGN=""center""><FONT FACE=Impact,Charcoal,Arial><IMG SRC=""/PrivateLabel/CastrolRaceway/Conversion/RockyMountainNationals.gif""><IMG SRC=""/PrivateLabel/CastrolRaceway/Conversion/SaveMySeat.gif""><IMG SRC=""/PrivateLabel/CastrolRaceway/Conversion/OilCityCup.gif""></FONT></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Impact,Charcoal,Arial><BR><B>SAVE MY SEAT<BR>Blow Your Mind-Not Your Budget; Weekend Passes ONLY $99<BR>ONLY UNTIL NOVEMBER 30, 2009!!</B><BR></FONT></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Impact,Charcoal,Arial><BR>" & MonthName(Month(Now())) & " " & Day(Now()) & ", " & Year(Now()) & "<br><br></FONT></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Impact,Charcoal,Arial>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ":<br><br>" & vbCrLf
RenewalLetter = RenewalLetter & "With race season over, it’s time to start thinking about the 2010 Race Season, the Rocky Mountain Nationals and the Oil City Cup! The dates of the 2010 events are:  Rocky Mountain Nationals, June 25-27, 2010 and the Oil City Cup, August 27-28, 2010.  Don’t miss out on Western Canada’s largest Motorsports Events! You can get your seats from last year's race by taking part in the Save My Seat program which runs until November 30, 2009.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Attached to this letter is your order form to ""Save My Seats"".  You can go online and complete your renewal, send it to the Castrol Raceway office with full payment or you can call the Castrol Raceway office and we can renew your order over the phone.  If you are sending your order in, please fill out the bottom portion of this form.  If you would like to upgrade your seats, you must call the Castrol Raceway office to do so before the December 1st cut off date.<BR><BR>" & vbCrLf
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