﻿<% 
'CHANGE LOG
'SLM 3/18/13 - New for 2013

RenewalLetter = "<table border=""0""><tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "<TR><TD><TABLE WIDTH=""700""><TR><TD><FONT FACE=" & EmailFontFace & "><IMG SRC=""http://www.tix.com/Clients/ChamberMusicDetroit/Renewal/Images/CMDEmailLogo.jpg""><BR><BR></TD></TR></TABLE><BR><BR></FONT></TD></TR>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td valign=top><FONT FACE=" & EMailFontFace & ">Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ",<BR><BR>"
RenewalLetter = RenewalLetter & "<div style='margin-bottom:0in;margin-bottom:.0001pt;line-height:&#xA;normal;text-autospace:none'><span style='font-size:12.0pt;&#xA;font-family:""Times New Roman"",""sans-serif"";font-family:""Times New Roman""'>Thank you for your support of the Chamber Music Society of Detroit!  We are excited to bring you the historic 70th Season of the greatest chamber music concerts in Southeast Michigan.   You will receive a brochure in the mail soon, but you can view the entire season brochure now by clicking here: <strong>http://chambermusicdetroit.org/flipbook/2013-14-season-brochure</strong>.</span></div><BR>" & vbCrLf 
RenewalLetter = RenewalLetter & "<div style='margin-bottom:0in;margin-bottom:.0001pt;line-height:&#xA;normal;text-autospace:none'><span style='font-size:12.0pt;&#xA;font-family:""Times New Roman"",""sans-serif"";font-family:""Times New Roman""'>Here is a list of all the Society’s concerts at the Seligman Performing Arts Center in 2013-2014:</span></div><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<div style='margin-bottom:0in;margin-bottom:.0001pt;line-height:&#xA;normal;text-autospace:none'><span style='font-size:12.0pt;&#xA;font-family:""Times New Roman"",""sans-serif"";font-family:""Times New Roman""'><strong>Signature Chamber Series</strong> (Nine Saturdays at 8:00 PM):<BR><strong><li>October 5, 2013</strong> – Emerson String Quartet<BR><li><strong>November 16, 2013</strong> – Danish String Quartet with Juho Pohjonen, piano<BR><li><strong>December 7, 2013</strong> – Daniel Hope, violin and Simone Dinnerstein, piano<BR><li><strong>January 11, 2014</strong> – Jasper String Quartet, with Matt Haimowitz, cello and Christopher O’Riley, piano<BR><li><strong>February 8, 2014</strong> – Imani Winds with Gilbert Kalish, piano<BR><li><strong>March 22, 2014</strong> – Orion String Quartet with Peter Serkin, piano<BR><li><strong>April 5, 2014</strong> – The Nash Ensemble of London<BR><li><strong>April 26, 2014</strong> – Trio Settecento (with Rachel Barton Pine, violin)<BR><li><strong>May 17, 2014</strong> – Zukerman ChamberPlayers (with Pinchas Zukerman, violin)</span></div><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<div style='margin-bottom:0in;margin-bottom:.0001pt;line-height:&#xA;normal;text-autospace:none'><span style='font-size:12.0pt;&#xA;font-family:""Times New Roman"",""sans-serif"";font-family:""Times New Roman""'><strong>*New* Sunday Recital Series</strong> (Three Sundays at 3:00 PM):<BR><li><strong>November 17, 2013</strong> – Juho Pohjonen, piano<BR><li><strong>January 26, 2014</strong> – David Geringas, cello and Ian Fountain, piano<BR><li><strong>March 23, 2014</strong> – Peter Serkin, piano</span></div><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<div style='margin-bottom:0in;margin-bottom:.0001pt;line-height:&#xA;normal;text-autospace:none'><span style='font-size:12.0pt;&#xA;font-family:""Times New Roman"",""sans-serif"";font-family:""Times New Roman""'><strong>DON’T WAIT - RENEW NOW!</strong></span></div><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<div style='margin-bottom:0in;margin-bottom:.0001pt;line-height:&#xA;normal;text-autospace:none'><span style='font-size:12.0pt;&#xA;font-family:""Times New Roman"",""sans-serif"";font-family:""Times New Roman""'>Single tickets will on sale this year on August 1, 2013.  But as a valued series subscriber, you don’t have to wait – you can renew your same subscription seats, reserved for you until May 18, 2013.  <strong>For the first time, you can renew directly from this e-mail right now!</strong>  Please note that if you subscribe to more than one series, you will get a separate renewal e-mail for each.</span></div><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<div style='margin-bottom:0in;margin-bottom:.0001pt;line-height:&#xA;normal;text-autospace:none'><span style='font-size:12.0pt;&#xA;font-family:""Times New Roman"",""sans-serif"";font-family:""Times New Roman""'><strong>Just follow these four easy steps to renew:<BR><BR>1) Carefully jot down your 8-digit order number and your personalized renewal code printed below.<BR>2) Click on this link: http://chambermusicdetroit.tix.com/renew.aspx?np=sc<BR>3) Enter the numbers from step 1 in the boxes provided.<BR>4) Follow the green buttons to check out and complete your order.  Then you’re done!<BR><BR>For assistance, please call 248-855-6070.<BR></strong></span></div><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<div style='margin-bottom:0in;margin-bottom:.0001pt;line-height:&#xA;normal;text-autospace:none'><span style='font-size:12.0pt;&#xA;font-family:""Times New Roman"",""sans-serif"";font-family:""Times New Roman""'>Important: if you would like to add a subscription for a series you have not subscribed to before, you can do that on our regular website: <strong>www.ChamberMusicDetroit.org/subscribe</strong>.</span></div><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<div style='margin-bottom:0in;margin-bottom:.0001pt;line-height:&#xA;normal;text-autospace:none'><span style='font-size:12.0pt;&#xA;font-family:""Times New Roman"",""sans-serif"";font-family:""Times New Roman""'>Thank you for being a part of one of the very finest chamber music communities in America – we’ll see you at the concerts!</span></div><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<div style='margin-bottom:0in;margin-bottom:.0001pt;line-height:&#xA;normal;text-autospace:none'><span style='font-size:12.0pt;&#xA;font-family:""Times New Roman"",""sans-serif"";font-family:""Times New Roman""'>Sincerely,<BR></span></div><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<div style='margin-bottom:0in;margin-bottom:.0001pt;line-height:&#xA;normal;text-autospace:none'><span style='font-size:12.0pt;&#xA;font-family:""Times New Roman"",""sans-serif"";font-family:""Times New Roman""'><IMG SRC=""http://www.tix.com/Clients/ChamberMusicDetroit/Renewal/Images/CMDEmailSignature.jpg"">" & vbCrLf
RenewalLetter = RenewalLetter & "<div style='margin-bottom:0in;margin-bottom:.0001pt;line-height:&#xA;normal;text-autospace:none'><span style='font-size:12.0pt;&#xA;font-family:""Times New Roman"",""sans-serif"";font-family:""Times New Roman""'>Steve Wogaman, President<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<div style='margin-bottom:0in;margin-bottom:.0001pt;line-height:&#xA;normal;text-autospace:none'><span style='font-size:12.0pt;&#xA;font-family:""Times New Roman"",""sans-serif"";font-family:""Times New Roman""'>Chamber Music Society of Detroit</span></div><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "</FONT></TD></TR></TBODY></TABLE>" & vbCrLf
EMailMessage = EMailMessage & RenewalLetter

%>  




