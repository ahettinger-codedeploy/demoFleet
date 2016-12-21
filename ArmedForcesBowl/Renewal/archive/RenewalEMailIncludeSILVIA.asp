<% 
'CHANGE LOG
'SLM 05/15/14 - New 
'SLM 06/16/14 - Updated Reminder
'SSR 06/25/2015 - Updated Reminder

 RenewalLetter = ""
 RenewalLetter = RenewalLetter & "<table class=""one-col-bg"" style=""border-collapse: collapse; border-spacing: 0px; width: 100%; background-color: rgb(255, 255, 255);""> " & vbCrLf
 RenewalLetter = RenewalLetter & "<tbody> " & vbCrLf
 RenewalLetter = RenewalLetter & "<tr> " & vbCrLf
 RenewalLetter = RenewalLetter & "<td style=""padding: 0px; vertical-align: top;"" align=""center""> " & vbCrLf
 RenewalLetter = RenewalLetter & "<table class=""one-col centered"" style=""border-collapse: collapse; border-spacing: 0px; margin-left: auto; margin-right: auto; width: 600px; table-layout: fixed;""> " & vbCrLf
 RenewalLetter = RenewalLetter & "<tbody> " & vbCrLf
 RenewalLetter = RenewalLetter & "<tr> " & vbCrLf
 RenewalLetter = RenewalLetter & "<td class=""column"" style=""padding: 0px; vertical-align: top; text-align: left;""> " & vbCrLf
 RenewalLetter = RenewalLetter & "<div class=""image"" style=""font-size: 12px; margin-bottom: 26px; color: rgb(78, 85, 97); font-family: sans-serif;"" align=""center""> " & vbCrLf
 RenewalLetter = RenewalLetter & "<img class=""gnd-corner-image gnd-corner-image-center gnd-corner-image-top"" style=""border: 0px none; display: block; max-width: 640px;"" src=""http://tix.com/clients/armedforcesbowl/renewal/images/2015/iwantyoureminder.jpg"" alt="""" width=""600"" height=""673""> " & vbCrLf
 RenewalLetter = RenewalLetter & "</div> " & vbCrLf
 RenewalLetter = RenewalLetter & "<table class=""contents"" style=""border-collapse: collapse; border-spacing: 0px; table-layout: fixed; width: 100%;""> " & vbCrLf
 RenewalLetter = RenewalLetter & "<tbody><tr> " & vbCrLf
 RenewalLetter = RenewalLetter & "<td class=""padded"" style=""padding: 0px 90px; vertical-align: top; word-wrap: break-word;""> " & vbCrLf
 RenewalLetter = RenewalLetter & "<h2 style=""margin-top: 0px; color: rgb(207, 0, 0); font-size: 26px; margin-bottom: 20px; font-family: sans-serif; line-height: 34px; text-align: center;""><em>" & FirstName & " Renew your seats for the Lockheed Martin Armed Forces Bowl!</em></h2> " & vbCrLf
 RenewalLetter = RenewalLetter & "</td> " & vbCrLf
 RenewalLetter = RenewalLetter & "</tr> " & vbCrLf
 RenewalLetter = RenewalLetter & "</tbody> " & vbCrLf
 RenewalLetter = RenewalLetter & "</table> " & vbCrLf
 RenewalLetter = RenewalLetter & "<table class=""contents"" style=""border-collapse: collapse; border-spacing: 0px; table-layout: fixed; width: 100%;""> " & vbCrLf
 RenewalLetter = RenewalLetter & "<tbody> " & vbCrLf
 RenewalLetter = RenewalLetter & "<tr> " & vbCrLf
 RenewalLetter = RenewalLetter & "<td class=""padded"" style=""padding: 0px 90px; vertical-align: top; word-wrap: break-word; text-align:center;"">  <p style=""margin-top: 0px; color: rgb(78, 85, 97); font-size: 16px; font-family: sans-serif; line-height: 25px; margin-bottom: 25px; font-weight: 300;"">July 4 - Early renewal deadline. Every person who renews before this date will receive TWO (2) PRE-GAME SIDELINE CREDENTIALS per account. In addition, every ticket renewed will be counted as one (1) entry into a drawing with the winner going through the bowl's gift suite with our two participating teams.<BR><BR>August 31 - Final ticket renewal deadline to keep your seats for the 13th edition of the Lockheed Martin Armed Forces Bowl.<BR><BR>Last year's game saw the largest 4th quarter comeback in a bowl game EVER! Don't miss the next exciting chapter of history in this year's Lockheed Martin Armed Forces Bowl!<BR></p>  <p style=""margin-top: 0px; color: rgb(78, 85, 97); font-size: 16px; font-family: sans-serif; line-height: 25px; margin-bottom: 25px; font-weight: 300;""> <strong style=""font-weight: bold;"">LOCKHEED MARTIN ARMED FORCES BOWL<br> <strong style=""font-weight: bold;"">TUESDAY, DECEMBER 29, 2015   1:00 p.m. KICKOFF<br> <strong style=""font-weight: bold;"">AMON G. CARTER STADIUM / FORT WORTH, TEXAS<br> </p> </td> " & vbCrLf
 RenewalLetter = RenewalLetter & "</tr> " & vbCrLf
 RenewalLetter = RenewalLetter & "</tbody> " & vbCrLf
 RenewalLetter = RenewalLetter & "</table> " & vbCrLf
 RenewalLetter = RenewalLetter & "<table class=""contents"" style=""border-collapse: collapse; border-spacing: 0px; table-layout: fixed; width: 100%;""> " & vbCrLf
 RenewalLetter = RenewalLetter & "<tbody> " & vbCrLf
 RenewalLetter = RenewalLetter & "<tr> " & vbCrLf
 RenewalLetter = RenewalLetter & "<td class=""padded"" style=""padding: 0px 90px; vertical-align: top; word-wrap: break-word;""> <div class=""btn"" style=""margin-bottom: 26px; padding-bottom: 2px; text-align: center;""> <a href=""" & EMailRenewalURL & "?o=" & rsOrderLine("OrderNumber") & "&c=" & RenewalCode & """""> <img src=""http://tix.com/clients/armedforcesbowl/renewal/images/2015/btn-action.jpg"" alt=""CLICK HERE TO RENEW YOUR TICKETS"" border=""0""></a> </div> </td> " & vbCrLf
 RenewalLetter = RenewalLetter & "</tr> " & vbCrLf
 RenewalLetter = RenewalLetter & "</tbody> " & vbCrLf
 RenewalLetter = RenewalLetter & "</table> " & vbCrLf
 RenewalLetter = RenewalLetter & "<table class=""contents"" style=""border-collapse: collapse; border-spacing: 0px; table-layout: fixed; width: 100%;""> " & vbCrLf
 RenewalLetter = RenewalLetter & "<tbody> " & vbCrLf
 RenewalLetter = RenewalLetter & "<tr> " & vbCrLf
 RenewalLetter = RenewalLetter & "<td class=""padded"" style=""padding: 0px 90px; vertical-align: top; word-wrap: break-word; text-align:center;""> <p style=""font-family: Verdana,Geneva,sans-serif; font-size: 14px;	font-style: normal;	font-variant: normal; font-weight: 400;	color: #525252; line-height: 23px;margin-bottom:20px;""> Questions?<BR><a href=""mailto:trisha.m.branch@espn.com?subject=Renewal Question"">Contact Trisha.M.Branch@espn.com </a><BR> Thank you for your support!<br> </p> </td> " & vbCrLf
 RenewalLetter = RenewalLetter & "</tr> " & vbCrLf
 RenewalLetter = RenewalLetter & "</tbody> " & vbCrLf
 RenewalLetter = RenewalLetter & "</table> " & vbCrLf
  
 EMailMessage = EMailMessage & RenewalLetter

%>  





