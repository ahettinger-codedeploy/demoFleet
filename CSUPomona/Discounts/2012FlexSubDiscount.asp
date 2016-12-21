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
'76580   9th Songwriter Showcase 
'33144   Cal Poly Pomona Concert Band 
'33148   Cal Poly Pomona Guitar Ensemble 
'33145   Cal Poly Pomona Jazz Band 
'33142   Cal Poly Pomona MIDI Band 
'76579   Ensemble FRET 
'75879   Jonathan Bass Piano Recital 
'33146   Kellogg Chamber Singers & University Concert Choir 
'33143   Kellogg Soul Ensemble 
'75881   Kim Jun Man, Korean Dramatic Tenor 
'75880   Line Forms Hear Guitar Trio 
'76577   Music Theater Workshop “Once Upon A Mattress” 
'62028   Shpachenko & Friends: Chamber Music Festival 
'76578   The Chamber Music of Brahms and Mendelssohn 
'76576   Yates & Shpachenko

'Only Student tickets qualify for this discount
'Student tickets are discounted to $7.00
'Service fees are recalculated on lower ticket price

ActCodeList = "76580,33144,33148,33145,33142,76579,75879,33146,33143,75881,75880,76577,62028,76578,76576" 
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