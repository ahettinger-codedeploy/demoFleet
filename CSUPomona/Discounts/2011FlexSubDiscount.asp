<%

'CHANGE LOG - Inception
'SSR 4/5/2011

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'==============================================

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

'==============================================

'Silvia’s Client
'Purchase 1 ticket each to any 3 of these productions:
'62029   8th Songwriter Showcase 
'33144   Cal Poly Pomona Concert Band 
'33148   Cal Poly Pomona Guitar Ensemble 
'33145   Cal Poly Pomona Jazz Combo & Jazz Band 
'33142   Cal Poly Pomona MIDI Band 
'36318   Cal Poly Pomona Music Theater Workshop 
'33147   Cal Poly Pomona String Ensemble 
'62528   Guest Artist Recital, David Korevaar, piano 
'33146   Kellogg Chamber Singers & University Concert Choir 
'33143   Kellogg Soul Ensemble 
'44953   Quadruple Concert 
'62028   Shpachenko & Friends: Chamber Music Festival 
'62023   The Cavatina Duo 
'62022   The Los Angeles Electric 8

'Only Student tickets qualify for this discount
'Student tickets are discounted to $7.00
'Service fees are recalculated on lower ticket price

ActCodeList = "62029,33144,33148,33145,33142,36318,33147,62528,33146,33143,44953,62028,62023,62022" 
SeriesPrice = 7
SeriesCount = 3

'==============================================

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

If CInt(TotalActs) >= SeriesCount Then

    Select Case SeatTypeCode
        Case 6,1119
	    NewPrice = SeriesPrice
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