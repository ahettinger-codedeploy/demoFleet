<% 
'CHANGE LOG
'SLM 05/15/14 - New 
'SLM 06/16/14 - Updated Reminder

RenewalLetter = "<table border=""0""><tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "<TR><TD><TABLE><TR><TD WIDTH=""400""><FONT FACE=" & EmailFontFace & "><IMG SRC=""http://www.tix.com/Clients/ArmedForcesBowl/Renewal/Images/ArmedForcesBowlLogo.png""><BR><BR></TD></TR></TABLE><BR><BR></FONT></TD></TR>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td valign=top><FONT FACE=" & EMailFontFace & ">Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ",<BR><BR>"

RenewalLetter = RenewalLetter & "<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height: normal;text-autospace:none'><span style='font-size:12.0pt;font-family:""Arial"",""sans-serif""'>Please contact the box office at 888-966-3352 or email info@theatrezone-florida.com to complete your ticket order.  Thank you for your continued patronage and support. We'll see you at the theatre!</span></p>" & "<BR>" & vbCrLf
'RenewalLetter = RenewalLetter & "<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height: normal;text-autospace:none'><span style='font-size:12.0pt;font-family:""Arial"",""sans-serif""'>LOCKHEED MARTIN ARMED FORCES BOWL</span></p>" & "<BR>" & vbCrLf
'RenewalLetter = RenewalLetter & "<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height: normal;text-autospace:none'><span style='font-size:12.0pt;font-family:""Arial"",""sans-serif""'>There are two easy ways to renew your tickets:</p><BR><B><I>1. Renew Online:</I></B>  Simply visit our website by clicking here, or go to the new www.ArmedForcesBowl.com website and follow the renewal link on the Ticket page.  Complete the renewal form by entering your order number and renewal code number, which can be found on this email below.<BR><BR><B><I>2. Call Bowl Office:</I></B>  817-810-0012<BR>" & "<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "</FONT></TD></TR></TBODY></TABLE><BR>" & vbCrLf
EMailMessage = EMailMessage & RenewalLetter

%>  





