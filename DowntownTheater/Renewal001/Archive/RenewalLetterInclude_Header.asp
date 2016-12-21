<% 

'CHANGE LOG
'SLM 2/26/13 - New for 2013
'SLM 2/28/13 - Updated formatting
'SSR 8/08/13 - Updated from RialtoCinemas
'SSR 3/10/14 - Updated for 2014 Season
'SSR 6/09/14 - Updated for "The Nance"

'Header

RenewalLetter = "<table border=""0""><tbody>" & vbCrLf
RenewalLetter = RenewalLetter & "<tr><td valign=top><BR>" & vbCrLf

RenewalLetter = RenewalLetter & "<p><FONT FACE=" & MsgFontFace & ">Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ",</p>" & vbCrLf
RenewalLetter = RenewalLetter & "<p><FONT FACE=" & MsgFontFace & ">Thank you for your support of National Theatre Live! We hope that you continue to enjoy these world-class productions on the big screen at Rialto Cinemas Cerrito. Today we are thrilled to announce the first production in a new partnership with Lincoln Center Theater: Nathan Lane starring in the acclaimed Lincoln Center Theater production of <strong><em>The Nance</em></strong> captured live from the Lyceum Theatre on Broadway. </p>" & vbCrLf
RenewalLetter = RenewalLetter & "<p><FONT FACE=" & MsgFontFace & ">In the 1930s, burlesque impresarios welcomed the hilarious comics and musical parodies of vaudeville to their decidedly lowbrow niche. A headliner called ""the nance"" was a stereotypically camp homosexual and master of comic double entendre - usually played by a straight man. </p>" & vbCrLf
RenewalLetter = RenewalLetter & "<p><FONT FACE=" & MsgFontFace & ">Douglas Carter Beane's <strong><em>The Nance</em></strong> recreates the naughty, raucous world of burlesque's heyday and tells the backstage story of Chauncey Miles and his fellow performers. At a time when it is easy to play gay and dangerous to be gay, Chauncey's uproarious antics on the stage stand out in marked contrast to his offstage life. </p>" & vbCrLf
RenewalLetter = RenewalLetter & "<p><FONT FACE=" & MsgFontFace & ">Winner of Three Tony Awards <strong><em>The Nance</em></strong> has been proclaimed ""refreshingly original"" by the New York Daily News while USA Today raves ""Nathan Lane is as heartbreaking as he is hilarious."" The New Yorker calls <strong><em>The Nance</em></strong> ""a nearly perfect work of dramatic art."" Directed by 3-time Tony Award winner Jack O'Brien, <strong><em>The Nance</em></strong> brings 2&ndash;time Tony Award winner Nathan Lane back to Broadway as Chauncey. Jonny Orsini won the 2013 Clive Barnes Award presented to young actors and dancers for his performance as Ned. </p>" & vbCrLf
RenewalLetter = RenewalLetter & "<p><FONT FACE=" & MsgFontFace & ">As a subscriber to this season's National Theatre Live series at Rialto Cinemas Cerrito, we are sending you this priority notice of the upcoming presentation of <strong><em>The Nance</em></strong> on Wednesday July 16th at 7pm and Monday, July 21st at 7pm and your opportunity to purchase your same great National Theatre Live seats before they are offered to the general public. Simply visit our website, <em><span style='color:red'><a  style=""color: red;"" href="""&MsgRenewalURL&""">"&MsgRenewalURL&"</a></span></em> and enter your order number and renewal code as listed below.</p>" & vbCrLf

RenewalLetter = RenewalLetter & "</td></tr></tbody></table><BR>" & vbCrLf

RenewalLetter_Header = RenewalLetter

%>  