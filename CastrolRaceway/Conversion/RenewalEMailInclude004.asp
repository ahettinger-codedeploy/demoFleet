<% 
'CHANGE LOG
'JAI 10/19/11 - 2012 Update
'JAI 10/11/12 - 2013 Update


RenewalLetter = "<CENTER>" & vbCrLf
RenewalLetter = RenewalLetter & "<table border=""0"" width=""745""><tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td ALIGN=""center""><FONT FACE=Calibri,Charcoal,Arial><IMG SRC=""http://www.tix.com//PrivateLabel/CastrolRaceway/Conversion/RockyMtnNJLogo.jpg""><IMG SRC=""http://www.tix.com//PrivateLabel/CastrolRaceway/Conversion/SaveMySeat.gif""><IMG SRC=""http://www.tix.com//PrivateLabel/CastrolRaceway/Conversion/OCC Logo.jpg""></FONT></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial><BR>" & MonthName(Month(Now())) & " " & Day(Now()) & ", " & Year(Now()) & "<br><br></FONT></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ":<br><br>" & vbCrLf


RenewalLetter = RenewalLetter & "<b>NITRO CHARGE YOUR FUN: 2013 SAVE MY SEAT- TICKET RENEWAL PROGRAM</b><BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Sadly, the 2012 race season has come to a close, but... that doesn’t mean we are taking a break. It’s time to start planning for our 16th year at Canada’s Premier Motorsport Complex <i>Castrol Raceway</i>! Back for the 11th season is the Mopar Rocky Mountain Nationals featuring the SMS Equipment Night of Fire, July 4-6, 2013. Also returning, <i>the Greatest Show on Dirt</i> - the World of Outlaws: Oil City Cup, August 23-24, 2013. The ticket renewal program ""Save My Seat"" is available for each until November 16, 2013.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<b>EXCLUSIVE OFFER!</b> As part of our continuing efforts to create the best value for our fans, for the first time we are offering an Annual Ticket holder Exclusive discount on all additional Major event passes. For a limited time, Purchase tickets to Annihilation Night or Hot August Night to receive a 20% discount. Order On-line TODAY!<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Promotional Code: <b>THX12</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Offer expires 11/16/12<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Castrol Raceway also offers all inclusive ticketing and VIP weekend pass options for many events:; includes Members only hospitality lounge access, premium seating, hot catered meals, exclusive gifts, private bar service, preferred parking, private autograph sessions, and much more. <BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<b>QUICK & EASY: SAVE YOUR SEAT ONLINE.</b> Complete your renewal; <a href=" & EMailRenewalURL & ">" & EMailRenewalURL & "</a><BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "You will be prompted for your Order Number and Renewal Code which can be found on the included Save My Seat ordering information below. To receive further information and saving, sign up on-line as a Castrol Raceway e-letter subscriber to receive special news, announcements, and promotions throughout the season.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "If you are mailing your order in, please print and fill out the bottom portion of this form before sending to the Castrol Raceway office with full payment. You can also contact the Castrol Raceway office directly at anytime " & EMailPhone & ", to renew your order over the phone or If you would like to upgrade your seats. You must contact the Castrol Raceway office to do so before the Nov 16th cutoff date.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Last, but not least, we just wanted to let you know-all the pieces are in place for another exceptional season, except one- YOU! Its fans like you who make Castrol Raceway a success. It is our greatest pleasure to provide the best possible experience for each person coming through our gates. We are very proud of the accomplishments made over the past 15 years and feel we have a great many benefits to offer; Excellent playground, children under 6 free, safe environment, knowledgeable staff, and continually growing and excellent events just to name a few. My family and I love racing and want to keep it alive in Edmonton, this is not our primary business, but a business run on passion. We look forward to having join us again in 2013.<BR><BR>" & vbCrLf
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





