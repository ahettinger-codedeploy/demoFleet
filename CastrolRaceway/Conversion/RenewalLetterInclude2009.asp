<%
RenewalLetter = "<CENTER><table border=""0"" width=""600""><tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td ALIGN=""center""><IMG SRC=""/PrivateLabel/CastrolRaceway/Images/RockyMountainNationals.gif""><IMG SRC=""/PrivateLabel/CastrolRaceway/Images/SaveMySeat.gif""><IMG SRC=""/PrivateLabel/CastrolRaceway/Images/OilCityCup.gif""></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><B>SAVE MY SEAT<BR>ONLY UNTIL NOV. 15 2008!!</B><BR></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td>" & MonthName(Month(Now())) & " " & Day(Now()) & ", " & Year(Now()) & "<br><br></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ":<br><br>" & vbCrLf
RenewalLetter = RenewalLetter & "With race season over, it’s time to start thinking about the 2009 Race Season and the Rocky Mountain Nationals and the Oil City Cup! The sates of the 2009 events are: Rocky Mountain Nationals July 3-5, 2009 and the Oil City Cup August 28-29, 2009.  Don’t miss out on Western Canada’s largest Motorsports Events! You can get your seats from last years race by taking part in the Save My Seat program which runs until November 15th, 2008.</B>.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Attached to this letter is your order form to “Save My Seats”.  You can go online and complete your renewal, send it to the Castrol Raceway office with full payment or you can call the Castrol Raceway office and we can do it for you over the phone.  If you are sending your order in, please fill out the bottom portion of this form.  If you would like to upgrade your seats, you must call the Castrol Raceway office to do so before the December 1st cut off date.<BR><BR>" & vbCrLf
'RenewalLetter = RenewalLetter & "Anyone who had a Motorhome site in 2008 and wishes to renew for 2009, please call the office to do so.  This will not be available as a Save My Seat program for 2007.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "To Save Your Seat online visit http://castrolraceway.tix.com/renew.asp.  You will be promoted for your Order Number and Renewal Code which can be found on the attached Save My Seat form.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "See you at the Races!<BR><BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Castrol Raceway<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<HR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "If you are sending in your Save My Seat form to the Castrol Raceway office, please fill out the below payment information.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Method of Payment:&nbsp;&nbsp;&nbsp;&nbsp;VISA&nbsp;&nbsp;&nbsp;&nbsp;MASTERCARD&nbsp;&nbsp;&nbsp;&nbsp;CHECK&nbsp;&nbsp;&nbsp;&nbsp;MONEY ORDER<BR><BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Credit Card #:____________________________&nbsp;&nbsp;&nbsp;Expiration Date:__________<BR><BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Check #:______________&nbsp;&nbsp;&nbsp;&nbsp;Amount Paid:______________<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "If your mailing address has changed or is changing, please notify the Castrol Raceway office." & vbCrLf
RenewalLetter = RenewalLetter & "</TD></TR></TBODY></TABLE></CENTER>" & vbCrLf
Response.Write RenewalLetter
Response.Write "<DIV>&nbsp;</DIV>" & vbCrLf
%>  