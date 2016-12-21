<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Initialize Variables
NewPrice = Clean(Request("Price"))
Price = Clean(Request("Price"))
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
OrderNumber = Clean(Request("OrderNumber"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
EventCode = Clean(Request("EventCode"))

'Get Act Code
SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
Set rsAct = OBJdbConnection.Execute(SQLAct)		
ActCode = CDbl(rsAct("ActCode"))
rsAct.Close
Set rsAct = nothing

'Initialize Discount Variables
FullActCodeList = "60377,60373,60386,60372,60371"
ThreeActCodeList = "60373,60372,60371"
MatEventCodeList = "340767,340772,340776,340783,340784,340791"

ThreeSeriesPriceMat = 60 '3 Production Matinee/Preview is $50
ThreeSeriesPrice     = 80 '3 Production Series Price is $75
FullSeriesPrice      = 105 '5 Production Series Price is $105
FullSeriesCount = 5
ThreeSeriesCount = 3
NbrSubscriptions = 0

'Count # of full acts allowed on the order
SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & FullActCodeList & ") GROUP BY Event.ActCode) AS ActCount"
Set rsActCount = OBJdbConnection.Execute(SQLActCount)
ActCount = CInt(rsActCount("ActCount"))
rsActCount.Close
Set rsActCount = nothing

If ActCount >= FullSeriesCount And Instr(FulLActCodeList, ActCode) <> 0 Then 
	SeriesCount = FullSeriesCount
	SeriesPrice = FullSeriesPrice
    NewSeatTypeCode = 4053
    
	'Get the fewest number of tickets for any applicable ActCode
	SQLMinTicketCount = "SELECT ActCode, COUNT(*) AS NumSubs FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & FullActCodeList & ")" & AllowedSeatTypeList & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode ORDER BY COUNT(*) DESC"
	Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)
    If Not rsMinTicketCount.EOF Then
        rsMinTicketCount.Move(SeriesCount - 1) 'Read ahead one less than the the SeriesCount records.  Check to see if there are SeriesCount different Acts are on order.
        If Not rsMinTicketCount.EOF Then
    		NbrSubscriptions = rsMinTicketCount("NumSubs")
        End If
    End If
	rsMinTicketCount.Close
	Set rsMinTicketCount = nothing

Else 'Look for Three Show Sub

    'Count # of three acts allowed on the order for 3-Show Matinee/Preview
    SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ThreeActCodeList & ") AND Event.EventCode IN (" & MatEventCodeList & ") GROUP BY Event.ActCode) AS ActCount"
    Set rsActCount = OBJdbConnection.Execute(SQLActCount)
    ActCount = CInt(rsActCount("ActCount"))
    rsActCount.Close
    Set rsActCount = nothing

    If ActCount >= ThreeSeriesCount And Instr(ThreeActCodeList, ActCode) <> 0 And Instr(MatEventCodeList, EventCode) <> 0 Then 'Matinee Subscription
        SeriesCount = ThreeSeriesCount
	    SeriesPrice = ThreeSeriesPriceMat
        NewSeatTypeCode = 4052

	    'Get the fewest number of tickets for any applicable ActCode
	    SQLMinTicketCount = "SELECT ActCode, COUNT(*) AS NumSubs FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ThreeActCodeList & ") AND Event.EventCode IN (" & MatEventCodeList & ") " & AllowedSeatTypeList & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode ORDER BY COUNT(*) DESC"
	    Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)
        If Not rsMinTicketCount.EOF Then
            rsMinTicketCount.Move(SeriesCount - 1) 'Read ahead one less than the the SeriesCount records.  Check to see if there are SeriesCount different Acts are on order.
            If Not rsMinTicketCount.EOF Then
    		    NbrSubscriptions = rsMinTicketCount("NumSubs")
            End If
        End If
	    rsMinTicketCount.Close
	    Set rsMinTicketCount = nothing

    Else
    
        'Count # of three acts allowed on the order for 3-Show
        SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ThreeActCodeList & ") GROUP BY Event.ActCode) AS ActCount"
        Set rsActCount = OBJdbConnection.Execute(SQLActCount)
        ActCount = CInt(rsActCount("ActCount"))
        rsActCount.Close
        Set rsActCount = nothing
    
        If ActCount >= ThreeSeriesCount And Instr(ThreeActCodeList, ActCode) <> 0 Then 'Three Show Sub   
            SeriesCount = ThreeSeriesCount
            SeriesPrice = ThreeSeriesPrice
            NewSeatTypeCode = 4051
        
            'Get the fewest number of tickets for any applicable ActCode
            SQLMinTicketCount = "SELECT ActCode, COUNT(*) AS NumSubs FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ThreeActCodeList & ") " & AllowedSeatTypeList & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode ORDER BY COUNT(*) DESC"
            Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)
            If Not rsMinTicketCount.EOF Then
                rsMinTicketCount.Move(SeriesCount - 1) 'Read ahead one less than the the SeriesCount records.  Check to see if there are SeriesCount different Acts are on order.
                If Not rsMinTicketCount.EOF Then
		            NbrSubscriptions = rsMinTicketCount("NumSubs")
                End If
            End If
            rsMinTicketCount.Close
            Set rsMinTicketCount = nothing
            
        End If
    End If
    
End If
		
'Count # of existing seats which have discount applied for this act.
SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.ActCode = " & ActCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
AppliedCount = rsDiscCount("LineCount")
rsDiscCount.Close
Set rsDiscCount = nothing			

If AppliedCount < NbrSubscriptions Then 'If this ticket is within the series count, apply the discount price to this ticket
		
	SQLCount = "SELECT COUNT(OrderLine.ItemNumber) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
	Set rsCount = OBJdbConnection.Execute(SQLCount)
	Count = rsCount("AppliedCount")
	rsCount.Close
	Set rsCount = nothing

	'MOD function to determine the last ticket to complete the subscription discount (i.e. fourth ticket in the FlexPass-4, or eighth ticket in a FlexPass-8, etc.).  
	'The MOD function calculates the remainder when dividing one number by the other. 
	Remainder = Count MOD SeriesCount

	' Calculates the total of all discounted ticket prices already given to figure out the discounted ticket price to be assign to this ticket.
	If Remainder = SeriesCount - 1 Then 
	    NewPrice = SeriesPrice - ((SeriesCount - 1) * Round(SeriesPrice/SeriesCount, 2))
        Surcharge = 0
	Else
		'Standard rounding on all other tickets.
	    NewPrice = Round(SeriesPrice/SeriesCount, 2)
        Surcharge = 0
	End If

	AppliedFlag = "Y"					
    SeatTypeCode = NewSeatTypeCode
    
Else
	
		NewPrice = Price 'Falls outside of the required series number. Gets full price.

End If
		
DiscountAmount = Clean(Request("Price")) - NewPrice
								
If Request("CalcServiceFee") <> "N" Then
	Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
End If
				

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf
Response.Write "<SEATTYPECODE>" & SeatTypeCode  & "</SEATTYPECODE>" & vbCrLf

%>