<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%


'===============================
'2010 Season Subscription Discount

'FlexSubDiscount

'Productions
'Annie Get Your Gun (54885)
'Chicago (54886)
'Grease (55462)


'===============================

'Discount Variables

ActCodeList = "54885,54886,55462"
SeriesPrice = 50
SeriesCount = 3

'===============================

'Determine number of valid productions on the order
SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS ActCount"
Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
ActCount = rsActCount("ActCount")	
rsActCount.Close
Set rsActCount = nothing

If ActCount => SeriesCount Then    

    'Get the least number of tickets for allowed ActCodes
    SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS TicketCount"
    Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
    NbrSubscriptions = rsMinTicketCount("NumSubs")		
    rsMinTicketCount.Close
    Set rsMinTicketCount = nothing
	
		
    'Get Act Code
    SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
    Set rsAct = OBJdbConnection.Execute(SQLAct)		
    ActCode = rsAct("ActCode")		
    rsAct.Close
    Set rsAct = nothing


    'Determine number of existing seats which have discount applied for this act and seat type code
    SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
    Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
    AppliedCount = rsDiscCount("LineCount")		
    rsDiscCount.Close
    Set rsDiscCount = nothing
    
    If AppliedCount < NbrSubscriptions Then	
    
    	'Count number of tickets which have been given a discount
		SQLCount = "SELECT COUNT(OrderLine.ItemNumber) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
		Set rsCount = OBJdbConnection.Execute(SQLCount)
		Count = rsCount("AppliedCount")
		rsCount.Close
		Set rsCount = nothing  
	
		'Divide if uneven series price exists between tickets
    	Remainder = Count MOD SeriesCount
    	
		If Remainder = SeriesCount - 1 Then 
		    NewPrice = SeriesPrice - ((SeriesCount - 1) * Round(SeriesPrice/SeriesCount, 2))
		Else
			  NewPrice = Round(SeriesPrice/SeriesCount, 2)
		End If
		
        If Price > NewPrice Then
        DiscountAmount = Clean(Request("Price")) - NewPrice
        Surcharge = 0
        AppliedFlag = "Y"
        End IF
	    

	End If
		
End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>