<%
RenewalLetter = "<CENTER><table border=""0"" width=""700""><tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td ALIGN=""center""><BR><BR><BR><BR><BR><br></td></tr>" & vbCrLf
'RenewalLetter = RenewalLetter & "<tr><td><FONT SIZE=3>" & MonthName(Month(Now())) & " " & Day(Now()) & ", " & Year(Now()) & "<BR><BR><br><BR></FONT></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><FONT SIZE=3>March 11, 2009<BR><BR><br><BR></FONT></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><FONT SIZE=3>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ":<br><br>" & vbCrLf
RenewalLetter = RenewalLetter & "With deep appreciation for your loyal support of the Canton Symphony, I am <I><U>thrilled</U></I> to invite you to renew your Classical subscription series for the Canton Symphony Orchestra’s 2009-2010 Season.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "This will be a real season to remember, starting in October with a rare concerto appearance by the legendary pianist Menahem Pressler, founder of the world-famous <I>Beaux Arts Trio</I>; and ending with a glorious performance of the stirring Mozart <I>Requiem</I> in May.  In between, there are superb solo artists on every concert, and programs with great music for every taste.  Do you like Beethoven?  There’s an all-Beethoven concert in November. Tchaikovsky?  <I>Romeo and Juliet</I> in March.  Chopin and Schumann?  We celebrate their 200th Birthdays in April.  Do you love great singing? Mezzo-soprano Kelley O’Connor and baritone David Small perform glorious works by John Adams and Peter Lieberson.  Each concert is a jewel, and together it’s an extraordinary season you will not want to miss!<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "As a season subscriber you will continue to receive subscriber benefits, including substantial savings over single tickets, reserved seating, no lines at the box office and no-fee ticket exchanges, invitations to open rehearsals and an opportunity to meet the conductor and musicians. Subscribers may also buy additional single Classical Concert tickets at a 20% discount.  <I><B>NEW: Refer a Friend!</B></I>  You can earn a 20% rebate on one of your season seats for each new <I>Classical 7 Series</I> season seat purchased by someone you refer on the attached form – and they get a 20% savings, too!<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "There are three easy ways to renew your subscription:<BR><UL>" & vbCrLf
RenewalLetter = RenewalLetter & "<LI><B>Renew your seats online!</B> Simply visit our website, <U>www.cantonsymphony.org</U>, click RENEW SEATS, then enter your <I>order number</I> and <I>renewal code</I> listed on the attached page." & vbCrLf
RenewalLetter = RenewalLetter & "<LI><B>Renew by mail!</B> Send your order to the Symphony Office address below." & vbCrLf
RenewalLetter = RenewalLetter & "<LI><B>Renew by phone!</B>  Call our Ticket Office at 330-452-2094" & vbCrLf
RenewalLetter = RenewalLetter & "</UL><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "To guarantee your same seats, <B><I><U>please place your order no later than June 01, 2009</U></I></B>.  After that date, your seats may be released and made available for purchase by others.  Thank you!<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Yours truly,<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<IMG SRC=""/PrivateLabel/CantonSymphony/Renewals/Steve.jpg""><BR>Steve Wogaman<BR>President & CEO<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "</FONT></TD></TR></TBODY></TABLE></CENTER>" & vbCrLf
Response.Write RenewalLetter
Response.Write "<DIV>&nbsp;</DIV>" & vbCrLf
%>