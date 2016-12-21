<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->


<%

'==================================================
'Anderson Symphony Orchestra (12/22/2010)

'Valid season subscriptions must have 1 ticket to each production
'Valid season subscriptions must have all tickets be of the same ticket type
'Valid season subscriptions must have all tickets in the same section color

'Valid Acts
'ASO 2010-11 WINTER CONCERT - Meaghan Sands (49365)
'ASO 2010-11 SEASON FINALE - AMERICAN SONGBOOK (49366)

'Blue Section
'Adult $54, Senior $50, Student $50

'Gold Section
'Adult $48, Senior $42, Student $18

'Green Section 
'Adult $40, Senior $32, Student $8

'==================================================

ActCodeList = "49365,49366"

SeriesCount = 2

BlueDiscount = 1

GoldDiscount = 1

GreenDiscount = 2

'==================================================

'Get the color for this section (needed for this discount to work)
SQLColor = "SELECT Color FROM Section(NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "'"
Set rsColor = OBJdbConnection.Execute(SQLColor)	
Color = UCase(rsColor("Color"))	
rsColor.Close
Set rsColor = nothing	

'Counts the number of tickets to each act with matching Seat Type Code and matching Color
SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND Color = '" & Color & "' AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " AND Color IN ('Gold', 'Green','Blue') GROUP BY Event.ActCode) AS ActCount"
Set rsActCount = OBJdbConnection.Execute(SQLActCount)
ActCount = rsActCount("ActCount")
rsActCount.Close
Set rsActCount = nothing
		
If ActCount >= SeriesCount Then
		
    'Get the least number of tickets for any applicable ActCode
    SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
    Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)			
    NbrSubscriptions = rsMinTicketCount("NumSubs")			
    rsMinTicketCount.Close
    Set rsMinTicketCount = nothing		
			
    'Get Act Code
    SQLAct = "SELECT ActCode FROM Event (NOLOCK) INNER JOIN SECTION (NOLOCK) On Event.EventCode = Section.EventCode WHERE Event.EventCode = " & EventCode & " AND Section.Color IN ('Gold', 'Green') Group By Event.ActCode"
    Set rsAct = OBJdbConnection.Execute(SQLAct)			
    ActCode = rsAct("ActCode")			
    rsAct.Close
    Set rsAct = nothing

    'Count # of existing seats which have discount applied for this act and seat type code
    SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
    Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)			
    AppliedCount = rsDiscCount("LineCount")		
    rsDiscCount.Close
    Set rsDiscCount = nothing			
			
    'If the # of discounts at this price for these events < the total possible, discount price
    
    If AppliedCount < NbrSubscriptions Then	

	    'Count number of tickets which have been given a discount
	    SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS AppliedCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')" 
	    Set rsCount = OBJdbConnection.Execute(SQLCount)
	    Count = rsCount("AppliedCount")
	    rsCount.Close
	    Set rsCount = nothing
	    
		Select Case Color
			Case "BLUE" 'Orchestra & Mezzanine 
                DiscountAmount = BlueDiscount
			Case "GOLD" 'Main Floor 
                DiscountAmount = GoldDiscount
			Case "GREEN" 'Upper Balcony 
		        Select Case SeatTypeCode
				    Case 1, 27 'Adult and Student
			            DiscountAmount = GreenDiscount
			        Case 1157 'Student
			            DiscountAmount = BlueDiscount			        
			    End Select            
		End Select			
		
	    NewPrice = Clean(Request("Price")) - DiscountAmount
	    	            
        If Request("NewSurcharge") <> "" Then
            Surcharge = NewSurcharge	
        ElseIf Request("CalcServiceFee") <> "N" Then
            Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))				
        End If
        
        AppliedFlag = "Y"
			
    End If
															
End If
		
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>