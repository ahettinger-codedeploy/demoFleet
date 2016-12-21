<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%


'======================================================

'Academy of Music Theater - (12/21/2010)

'Season Subscription Discount with Bonus Act

'If you buy:
'EventCode #321248 (Raising Arizona)
'EventCode #321249 (O Brother)
'EventCode #321257 (Fargo)

'and you also buy EventCode #321258 (The Big Lebowski), you get EventCode #321258 free.
'Discount is one-for-one 
'Discount is given automatically
'Fee on free ticket is $0
'Online and offline

'======================================================

ActCodeList = "321248,321249,321257"

SeriesPercentage = 1
SeriesCount = 3

BonusPercentage = 50
BonusActList = 321258 


If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	
'Determine the number of season acts on this order.
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
	ActCount = rsActCount("ActCount")	
	rsActCount.Close
	Set rsActCount = nothing	
	
	If ActCount >= SeriesCount Then
	
		'Determine the number of possible subscriptions on this order (season + bonus)
		SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ", " & BonusActList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
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
		        
				    Select Case ActCode
				        Case 321258  'Mega Star Benefit Concert 
				            NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(BonusPercentage)/100), 2)		
				    Case Else
					        NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)						    
				    End Select			    
 
    	        
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