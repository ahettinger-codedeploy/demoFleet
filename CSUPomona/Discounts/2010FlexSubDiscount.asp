<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->


<%

'Cal Poly Pomona Music Department - Flex Subscription 1/14/2010
'Purchase 1 ticket each to 3 productions from this list:

'Phillip Clarke Memorial (33140)
'Cal Poly Pomona MIDI Band (33142)
'Kellogg Soul Ensemble (33143)
'Cal Poly Pomona Concert Band (33144)
'Cal Poly Pomona Jazz Band (33145)
'Kellogg Chamber Singers & University Concert Choir (33146)
'Cal Poly Pomona Guitar Ensemble (33148)
'Nadia Shpachenko and Friends: Chamber Music Festival (41742)
'Michael Garson Trio In Concert (44877)
'Political Satirist Roy Zimmerman in Concert: A Music Industry Studies Benefit (44878)
'6th Songwriter Showcase (44880)
'Shape-Shifting Guitars (44953)

'Only Student tickets qualify for this discount
'Michael Garson tickets are discounted to $10.00
'All other productions, tickets are discounted to $7.00
'Service fees are recalculated on lower ticket price



'Initialize Variables
Price = Clean(Request("Price"))
NewPrice = Price
DiscountAmount = 0
ItemType = Clean(Request("ItemType"))
Surcharge = Clean(Request("Surcharge"))
NewSurcharge = CDbl(Clean(Request("NewSurcharge")))
CalcServiceFee = Clean(Request("CalcServiceFee"))
EventCode = Clean(Request("EventCode"))
OrderNumber = Clean(Request("OrderNumber"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
AppliedFlag = "N"
'ActCodeList = "33140,33142,33143,33144,33145,33146,33148,41742,44877,44878,44880,44953" 'ActCodes of Productions which can be included in Season Subscription.
ActCodeList = "41742,48816,48817,36318,44880,33142,33143,33144,33146,33147,33145,33148" 'ActCodes of Productions which can be included in Season Subscription.
TotalActs = 0

SQLActCode = "SELECT Event.ActCode, COUNT(Event.ActCode) AS Smallest FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.ActCode IN(" & ActCodeList & ") GROUP BY Event.ActCode ORDER BY COUNT(Event.ActCode)"
Set rsActCode = OBJdbConnection.Execute(SQLActCode)

If Not rsActCode.EOF Then
    Do While Not rsActCode.EOF
        TotalActs = TotalActs + 1
        rsActCode.movenext
    Loop
End If

rsActCode.Close
Set rsActCode = nothing

If CInt(TotalActs) >= 3 Then

    Select Case SeatTypeCode
        Case 1119 'Student
	        Select Case Price
	            Case 12
	                NewPrice = 10
	            Case 10
	                NewPrice = 7
	        End Select    
     End Select 


DiscountAmount = Price - NewPrice

Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
    
AppliedFlag = "Y"     

End If
   
	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>