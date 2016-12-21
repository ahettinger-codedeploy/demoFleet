<%
RenewalLetter = "<CENTER><table border=""0"" width=""600""><tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td ALIGN=""center""><IMG SRC=""/PrivateLabel/BudPark/Images/RockyMountainNationals.gif""><IMG SRC=""/PrivateLabel/BudPark/Images/SaveMySeat.gif""></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td>August 16, 2005<br><br></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ":<br><br>" & vbCrLf
RenewalLetter = RenewalLetter & "It’s time to once again to Save Your Seat for the 2006 4th Annual IHRA Rocky Mountain Nationals.  The dates for this year’s event will be June 23 – 25, 2006!  The excitement is growing for the 2006 event, as records in every class were shattered at the 3rd Annual Rocky Mountain Nationals.  The Competitor’s are looking to come back and see if they can do it again, only this time even faster!<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Attached with this letter is your order form to Save Your Seats, which you can go online and complete the renewal yourself (see directions below) or you can send the form back into the Bud Park office along with payment and we will make sure to take care of renewing your seats for you.  If you are looking to Upgrade your order (either change seats or add/remove seats to your order) please call the Bud Park office for instructions.  Remember, all renewal orders must be paid in full at time of renewal in order to keep your seats.  The deadline to Save Your Seat is December 20, 2005!<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "To Save Your Seat online visit http://budpark.tix.com/renew.asp.  You will be promoted for your Order Number and Renewal Code which can be found on the attached Save My Seat form.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "We’ll See You at the 4th Annual IHRA Rocky Mountain Nationals!<BR><BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Budweiser Motorsports Park<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<HR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "If you are sending in your Save My Seat form to the Bud Park office, please fill out the below payment information.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Circle one:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Visa&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;MC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Check<BR><BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "CC No:____________________________&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Check No:________<BR><BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Expiration Date:__________&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Check Amt:________<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Please let us know if your mailing address is changing so that we can update your information." & vbCrLf
RenewalLetter = RenewalLetter & "</TD></TR></TBODY></TABLE></CENTER>" & vbCrLf
Response.Write RenewalLetter
Response.Write "<DIV></DIV>" & vbCrLf
%>  