<% 
'CHANGE LOG
'SLM 05/15/14 - New 


RenewalLetter = "<table border=""0""><tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "<TR><TD><TABLE><TR><TD WIDTH=""400""><FONT FACE=" & EmailFontFace & "><IMG SRC=""http://www.tix.com/Clients/ArmedForcesBowl/Renewal/Images/ArmedForcesBowlLogo.png""><BR><BR></TD></TR></TABLE><BR><BR></FONT></TD></TR>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td valign=top><FONT FACE=" & EMailFontFace & ">Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ",<BR><BR>"

RenewalLetter = RenewalLetter & "<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height: normal;text-autospace:none'><span style='font-size:12.0pt;font-family:""Arial"",""sans-serif""'>Thanks once again for continuing to support the Lockheed Martin Armed Forces Bowl.  We are pleased to announce that our game will be played for the first time ever in January as we have been scheduled by ESPN to kickoff at 11:00am CT on Friday, January 2, 2015.</span></p>" & "<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height: normal;text-autospace:none'><span style='font-size:12.0pt;font-family:""Arial"",""sans-serif""'>Now is the time to renew your tickets in order to retain the same great seats you’ve become accustomed to enjoying at the beautiful Amon G. Carter stadium.  Please make sure to renew before the deadline of June 30th.</span></p>" & "<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height: normal;text-autospace:none'><span style='font-size:12.0pt;font-family:""Arial"",""sans-serif""'>There are two easy ways to renew your tickets:</p><BR><B><I>1. Renew Online:</I></B>  Simply visit our website by clicking here, or go to the new www.ArmedForcesBowl.com website and follow the renewal link on the Ticket page.  Complete the renewal form by entering your order number and renewal code number, which can be found on this email below.<BR><BR><B><I>2. Call Bowl Office:</I></B>  817-810-0012<BR>" & "<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "</FONT></TD></TR></TBODY></TABLE><BR>" & vbCrLf
EMailMessage = EMailMessage & RenewalLetter

%>  





