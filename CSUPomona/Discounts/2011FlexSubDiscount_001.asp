<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->


<%

'Cal Poly Pomona Music Department - Flex Subscription 11/2/2010
'Purchase 1 ticket each to 3 productions from this list:

'33138   Cahueque & Noll 
'33144   Cal Poly Pomona Concert Band 
'33148   Cal Poly Pomona Guitar Ensemble 
'33145   Cal Poly Pomona Jazz Band 
'33142   Cal Poly Pomona MIDI Band 
'33147   Cal Poly Pomona String Ensemble 
'41741   Charles Lindsley Memorial Vocal Scholarship Fund Raiser 
'33146   Kellogg Chamber Singers & University Concert Choir 
'33137   Peter Yates, Bowed Guitar 

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
ActCodeList = "33138,33144,33148,33145,33142,33147,41741,33146,33137" 'ActCodes of Productions which can be included in Season Subscription.

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