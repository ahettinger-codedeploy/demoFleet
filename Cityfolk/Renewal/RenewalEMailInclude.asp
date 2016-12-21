<%
'CHANGE LOG
'JAI 5/24/11 - Initial coding - copy of Castrol Raceway

RenewalLetter = "<CENTER>" & vbCrLf
RenewalLetter = RenewalLetter & "<table border=""0"" width=""745""><tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td ALIGN=""center""><FONT FACE=Calibri,Charcoal,Arial><IMG SRC=""http://www.tix.com/PrivateLabel/CityFolk/Renewal/Images/New CF logo no tagline bw.jpg"" WIDTH=500 HEIGHT=160></FONT><BR><BR></td></tr>" & vbCrLf

RenewalLetter = RenewalLetter & "<tr><td><FONT FACE=Calibri,Charcoal,Arial>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ":<br><br>" & vbCrLf

RenewalLetter = RenewalLetter & "Once again, Cityfolk has found the best in Celtic music to present to you for our 2011/2012 Season. We have combined old and new music to showcase a genre of music that is decades old and rich with history. While we know we can’t please everyone, we sure try. And for the 2011/2012 season we have a new venue for two of our concerts. We will be presenting bohola and Genticorum at Centennial Hall in Stivers School for the Arts. While Stivers is new to the Celtic series, it is not new to Cityfolk. We have had a long and beneficial relationship with them and have presented our jazz and education programs at Stivers for many years. It is a beautiful, 600-seat theater that has high-end technology and uses every event to help train students interested in pursuing theater production as a career. The hall is newly remodeled with very comfortable seating. As you will see from the chart, the seating is numbered all the way across the hall which makes finding your seat very easy. The parking lot is very close, well-lit  and ample.  We know you will enjoy the venue as much as we do.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "We thank you in advance for your support of Cityfolk by purchasing series tickets. Like many organizations, we depend heavily on individual, local support to keep us thriving and able to keep presenting diverse music to the community.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Starting in October, we present <B>bohola</B> with Dancers from the Richens/Timm Academy of Irish Dance. Two of the greatest Irish musicians of our time join forces in <B>bohola</B>: piano accordion virtuoso Jimmy Keane—a five-time winner of the All-Ireland title and recently named Male Musician of the Decade by <I>Irish American News</I>—and singer Pat Broaders, a master of the <I>bouzar</I> (an 8-stringed, guitar shaped-bouzouki), uilleann pipes and whistles. The exciting duo has been hailed as “two master musicians in their day and in their prime…Chicago’s hometown world champions” (<I>Irish American News</I>). Saturday, October 22, 8:00pm at Stivers School for the Arts, Centennial Hall.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Cityfolk kicks off the Christmas season with <B>Natalie MacMaster: Christmas in Cape Breton</B>.  Natalie returns to Dayton with her band for <I>Christmas in Cape Breton</I>, a very special holiday celebration that joyfully recreates the Christmas traditions and customs of her family home in Cape Breton Island off the east end of Nova Scotia. The award-winning fiddler and step-dancer, called “the most dynamic performer in Celtic music today” (<I>Boston Herald</I>), presents a tuneful new program for the whole family blending familiar Christmas carols and songs with traditional Cape Breton fiddle tunes, lively step-dancing and audience favorites. MacMaster and her band will be joined for this performance by a local children’s choir. Sunday, December 4, 7:00pm at the Dayton Masonic Center.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "<B>Genticorum</B> is one of the fastest-rising Canadian bands and is a <I>Québécois</I> acoustic power trio with a distinctive sound that is at once both ancient and modern—what <I>Sing Out</I> calls “a very full and glorious noise, both instrumentally and vocally.” The charismatic young group (Pascal Gemme, Alexandre de Grosbois-Garand, Yann Falquet) has captivated audiences in 15 countries with its fresh take on traditional European and North American folk music that combines precise and intricate fiddle and flute work, songs sung in French, gorgeous vocal harmonies, energetic foot percussion and the characteristic and irrepressible <I>joie de vivre</I> that’s at the heart of <I>Québécois</I> music. Saturday, February 25, 8:00pm at Stivers School for the Arts, Centennial Hall.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Purchase your tickets quickly and easily by clicking on the link , or print the form and mail it to the Cityfolk offices with your payment. You may also call the box office at 937-496-3863 to purchase tickets or make any changes to your seats. Please plan to purchase your tickets by June 24 as all seats will be released to the public on that date.<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "We are excited about the 2011/2012 Season and hope that you enjoy it.<BR><BR>" & vbCrLf

RenewalLetter = RenewalLetter & "Sincerely,<BR><BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Kathleen<BR>" & vbCrLf                                              
RenewalLetter = RenewalLetter & "Kathleen Alter<BR>" & vbCrLf
RenewalLetter = RenewalLetter & "Executive Director<BR>" & vbCrLf

RenewalLetter = RenewalLetter & "</FONT></TD></TR></TBODY></TABLE></CENTER>" & vbCrLf
RenewalLetter = RenewalLetter & "<DIV>&nbsp;</DIV>" & vbCrLf
EMailMessage = EMailMessage & RenewalLetter

%>  





