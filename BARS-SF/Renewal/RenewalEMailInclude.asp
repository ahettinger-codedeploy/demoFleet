<%

RenewalLetter = "<TABLE border=""0"" width=""750""><TBODY>" & vbCrLf
RenewalLetter = RenewalLetter & "<TR><TD>" & vbCrLf
RenewalLetter = RenewalLetter & "Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ",<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Thank you for being a Bay Area Rainbow Symphony (BARS) subscriber. BARS is proud to announce our 2010-2011 season lead by Daniel Canosa, artistic director, showcasing the Bay Area's premier soloists and talent performing dynamic and eclectic programming. It's a year of classic favorites and new experiences you don't want to miss!<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<B><U>2010-2011 Season Highlights</U></B> (for full season, including dates and venues, see bottom of email)<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<UL>" & vbCrLf
enewalLetter = RenewalLetter & "<LI>Tchaikovsky's* dazzling Piano Concerto no. 1 with international sensation and local favorite Daniel Glover*, piano" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>Rimsky-Korsakov's decadently intoxicating <I>Scheherazade</I>" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>Britten's* Serenade for Tenor, Horn, & Strings with SF Opera alum Brian Thorsett, tenor, and BARS' horn virtuoso, Rachel Harvey" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>Copland's* inspring and expansive <I>Appalachian Spring</I>" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>Barber's* lush and thrilling Violin Concerto with the sensational Bettina Mussumeli*, violin" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>Villa-Lobos' enchanting Guitar Concerto with SF Conservatory prodigy Jon Mendle, guitar" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>Performances at the prestigious SF Conservatory of Music and First Unitarian Universalist Church" & vbCrLf
RenewalLetter = RenewalLetter & "</UL>" & vbCrLf
RenewalLetter = RenewalLetter & "<I>*Part of BARS' LGBTQ Composer and Performing Artist Series, which strives to redefine perceptions of LGBTQ music and increase awareness of the beauty, talents, and accomplishments of fellow LGBTQ individuals and groups</I><BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<U>Why Subscribe?</U> Subscribing is the only way to guarantee admission to all performances, enjoy the same seats at reserved seating venues, and access exclusive subscriber-only events. As a subscriber you save money and demonstrate that you are a patron who cares about BARS, artistic excellence, and the LGBTQ community.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<B>Renew your subscription today and save more than 25%</B> off individual ticket prices. As an existing subscriber, you have the option to renew your current seats, as well as have first-pick at other or additional seats. <I>Renew now, as unsold seats will be released for sale on Friday, July 2nd, 2010 at 5PM!</I><BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<B>Renew Online:</B>&nbsp;Go to <A HREF=""" & EMailRenewalURL & """>" & EMailRenewalURL & "</A>, and enter your unique Order Number and Renewal Code:<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Order Number: " & rsOrderLine("OrderNumber") & "<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Renewal Code: " & RenewalCode & "<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Note: email <A HREF=" & EMailReplyTo & ">" & EMailReplyTo & "</A> or call " & EMailPhone & " if:" & vbCrLf
RenewalLetter = RenewalLetter & "<UL>" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>The ticket type in the renewal is incorrect (ex. shows Regular, but should be Student/Senior)" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>You wish to renew your subscription but not keep the same seat(s)" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>You wish to add or remove seats" & vbCrLf
RenewalLetter = RenewalLetter & "</UL>" & vbCrLf
RenewalLetter = RenewalLetter & "Remember, you must renew no later than Friday, July 2nd, 2010 at 5pm to keep your current seats. We thank you in advance for patronage, and look forward to having you with us for another year.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "----------<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<B>BARS 2010-2011 Season Calendar</B><BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Saturday, September 25, 2010, 8PM, SF Conservatory of Music" & vbCrLf
RenewalLetter = RenewalLetter & "<UL>" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>Tchaikovsky* - Piano Concerto no. 1 with Daniel Glover*, piano" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>Rimsky-Korsakov - <I>Scheherazade</I>" & vbCrLf
RenewalLetter = RenewalLetter & "</UL>" & vbCrLf
RenewalLetter = RenewalLetter & "Saturday, November 20, 2010, 8PM, First Unitarian Universalist Church" & vbCrLf
RenewalLetter = RenewalLetter & "<UL>" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>Britten* - Serenade for Tenor, Horn, and Strings with Brian Thorsett, tenor, and Rachel Harvey, horn" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>Copland* - <I>Appalachian Spring</I>" & vbCrLf
RenewalLetter = RenewalLetter & "</UL>" & vbCrLf
RenewalLetter = RenewalLetter & "Saturday, March 26, 2011, 8PM, SF Conservatory of Music" & vbCrLf
RenewalLetter = RenewalLetter & "<UL>" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>Barber* - Violin Concerto with Bettina Mussumeli*, violin" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>Tchaikovsky* - Symphony no. 5" & vbCrLf
RenewalLetter = RenewalLetter & "</UL>" & vbCrLf
RenewalLetter = RenewalLetter & "Saturday, June 4, 2011, 8PM, SF Conservatory of Music" & vbCrLf
RenewalLetter = RenewalLetter & "<UL>" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>Villa-Lobos - Guitar Concerto with Jon Mendle, guitar" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>Falla* - <I>Three Cornered Hat (El Sombrero de Tres Picos)</I> Suite no. 2" & vbCrLf
RenewalLetter = RenewalLetter & "<LI>Marquez - <I>Danzon</I> no. 2" & vbCrLf
RenewalLetter = RenewalLetter & "</UL>" & vbCrLf
RenewalLetter = RenewalLetter & "<I>*Part of BARS' LGBTQ Composer and Performing Artist Series, which strives to redefine perceptions of LGBTQ music and increase awareness of the beauty, talents, and accomplishments of fellow LGBTQ individuals and groups</I>" & vbCrLf

RenewalLetter = RenewalLetter & "</TD></TR></TBODY></TABLE><BR><BR>" & vbCrLf
EMailMessage = EMailMessage & RenewalLetter

%>  





