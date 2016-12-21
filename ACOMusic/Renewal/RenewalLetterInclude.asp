<%
'CHANGE LOG
'JAI 4/27/12 - New script for Atlantic Classical Orchestra renewals.

RenewalLetter = "<CENTER>" & vbCrLf
RenewalLetter = RenewalLetter & "<table border=""0"" width=""750""><tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td ALIGN=""left""><FONT FACE=Calibri,Charcoal,Arial><IMG SRC=""/PrivateLabel/ACOMusic/Renewal/Images/ACOLogo.png"" HEIGHT=""125""></FONT></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial><BR>" & MonthName(Month(Now())) & " " & Day(Now()) & ", " & Year(Now()) & "<br><br></FONT></td></tr>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ":<br><br>" & vbCrLf


RenewalLetter = RenewalLetter & "Thank you for your support of the Atlantic Classical Orchestra. We are pleased to announce our 2013 season of concerts.<br /><br />" & vbCrLf
RenewalLetter = RenewalLetter & "You may now renew your seats online! Simply visit our ticketing website, <u>http://acomusic.tix.com/renew.asp</u>, and enter your order number and renewal code as listed on the attached page. Of course, you may also mail or fax your subscription order to us or call our office to talk with our staff about your seating.<br /><br />" & vbCrLf
RenewalLetter = RenewalLetter & "There are five ways to renew your subscription:<ul>" & vbCrLf
RenewalLetter = RenewalLetter & "<li>Renew online.  Simply visit the Season Ticket Renewal link at <u>http://acomusic.tix.com/renew.asp</u>, and enter your Order Number and Renewal Code on the attached page." & vbCrLf
RenewalLetter = RenewalLetter & "<li>Call us at (888) 310-7521." & vbCrLf
RenewalLetter = RenewalLetter & "<li>Mail the attached form to us with your payment information." & vbCrLf
RenewalLetter = RenewalLetter & "<li>Fax the attached form to us with your payment information to 772-460-0851" & vbCrLf
RenewalLetter = RenewalLetter & "<li>Come by our office located at 415 Avenue A, Suite 305, Fort Pierce, FL 34950" & vbCrLf
RenewalLetter = RenewalLetter & "</ul>" & vbCrLf
RenewalLetter = RenewalLetter & "To keep your season tickets you must place your order no later than <b>May 15, 2012</b>.  If you want to change your tickets, please contact our office to let our staff know of your preferences.<br /><br />" & vbCrLf
RenewalLetter = RenewalLetter & "Yours truly,<br /><br /><br />" & vbCrLf
RenewalLetter = RenewalLetter & "Matthew Stover<br />" & vbCrLf
RenewalLetter = RenewalLetter & "Executive Director<br />" & vbCrLf
RenewalLetter = RenewalLetter & "</FONT></TD></TR></TBODY></TABLE><br />" & vbCrLf
RenewalLetter = RenewalLetter & "<b>Atlantic Classical Orchestra – 415 Avenue A, Suite 305 – Fort Pierce, FL 34950</b><br />" & vbCrLf
RenewalLetter = RenewalLetter & "<b>Phone 772-460-0850 - Fax 772-460-0851</b><br />" & vbCrLf
RenewalLetter = RenewalLetter & "<b>info@acomusic.org</b><br />" & vbCrLf
RenewalLetter = RenewalLetter & "</CENTER><br />" & vbCrLf

Response.Write RenewalLetter
Response.Write "<DIV>&nbsp;</DIV>" & vbCrLf


%>  