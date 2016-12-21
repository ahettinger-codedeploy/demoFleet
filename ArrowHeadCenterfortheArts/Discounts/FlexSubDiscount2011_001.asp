<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================
' Arrowhead Center for the Arts (12/14/2010)
' aka Grand Marais Playhouse 

' Shout! The Mod Musical, ActCode = 58437
' Always, Patsy Cline, ActCode = 16818

' Automatic Discount Code: 5OFF2011PAIR

' Buy 1 ticket to each act, and get $2.50 off each ticket
' $5.00 total off the pair.
' No limit on number of pairs.
' All seats are general admission.

' no change in service fees

SeriesCount = 2
ActCodeList = "58437,16818"
SeriesDiscount = 2.5

'==================================================

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	'Determine the number of acts on this order.
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
	ActCount = rsActCount("ActCount")	
	rsActCount.Close
	Set rsActCount = nothing
	
	If ActCount >= SeriesCount Then

			'Determine the number of possible subscriptions on this order
			SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
			Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
			NbrSubscriptions = rsMinTicketCount("NumSubs")		
			rsMinTicketCount.Close
			Set rsMinTicketCount = nothing

			'Get the ActCode
			SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
			Set rsAct = OBJdbConnection.Execute(SQLAct)		
			ActCode = rsAct("ActCode")		
			rsAct.Close
			Set rsAct = nothing

			'Count the number of seats which have been discounted
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
			AppliedCount = rsDiscCount("LineCount")		
			rsDiscCount.Close
			Set rsDiscCount = nothing

			'If the number of discounted seats at this price for these events is less then the total possible, apply discount

			If AppliedCount < NbrSubscriptions Then	
    
                    NewPrice = Clean(Request("Price")) - SeriesDiscount
                    
                    If NewPrice < 0 Then
                        NewPrice = 0
                    End If
            
                    DiscountAmount = Clean(Request("Price")) - NewPrice
            
                    AppliedFlag = "Y"
                    
                    If Request("NewSurcharge") <> "" Then
				        Surcharge = NewSurcharge
			        Else
				        If Request("CalcServiceFee") <> "N" Then
					        Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
				        End If
			        End If
			      
			End If	
	
	End If	
	
End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>