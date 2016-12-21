<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'Music Worcester Inc. (7/15/2010)
'================================
'2010 Season Subscription Discount

'Valid for 15 Productions:
'ActCode	ActName
'54812      The Boston Philharmonic Orchestra
'54885	    Worcester Chorus
'54886	    The BBC Concert Orchestra
'54887	    The Kopelman String Quartet


'Set Discount Variables
SeriesPercentage = 10
SeriesCount = 4
SeriesActList = "54812,54885,54886,54887"


If AllowDiscount = "Y" Then 'It's okay to apply to this order.
	
    'Determine the number of season acts on this order.
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & SeriesActList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
	ActCount = rsActCount("ActCount")	
	rsActCount.Close
	Set rsActCount = nothing	
	
	If ActCount >= SeriesCount Then
	
		'Determine the number of possible subscriptions on this order (season + bonus)
		SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & SeriesActList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
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
            
            NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	

	        If Price > NewPrice Then
		        DiscountAmount = Clean(Request("Price")) - NewPrice
		        AppliedFlag = "Y"
	        End If
    	
	       If Price > NewPrice Then
		                DiscountAmount = Clean(Request("Price")) - NewPrice
		                AppliedFlag = "Y"
	       End If
    	
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