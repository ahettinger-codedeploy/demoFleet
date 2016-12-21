<%

'CHANGE LOG - Inception
'SSR 5/23/2011
'Custom Season Discount

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'=======================================================================

' (5/19/2011) 
' Bus Barn 
' 2011 Season Subscription
' 3 Tier by Day of Week

'Silvia’s Client 

'Qualifying Acts
'----------------
'64420	Shout! The Mod Musical
'64421	Almost, Maine
'64422	Doubt, A Parable
'64423	The Government Inspector
'64424	The Clean House

'Buy 1 ticket to each production to receive one of these discounts:

'Wednesday Series
'----------------
'Buy all Wednesday performances, pay $110 total ($22/ticket)

'Weekday Series
'----------------
'Buy any combination of Thursdays, Fridays or Saturdays, pay $135 total ($27/ticket)

'Sunday Series
'----------------
'Buy all Sunday performances, pay $115 total ($23/ticket)

'No change to service fees
'Online and offline
'Automatic discount
'Additional tickets beyond subscription quantity do not get the discount 

'=======================================================================

'Discount Variables

'Min number of productions required
'-----------------------------------
SeriesCount = 5   


'ActCodes which can be included in subscription
'-----------------------------------
ActCodeList = "64420,64424,64423,64422,64421"   


'Thursday/Friday/Saturday Series Price 
'--------------------------------------
WeekdayPrice =   27.00


'Sunday Series Price
'--------------------
SundayPrice =   23.00


'Wednesday Series Price
'------------------------
WednesdayPrice =   22.00


'=======================================================================
 
'Days of the Week, 1 = Sunday, 2 = Monday, 3 = Tuesday, 4 = Wednesday, 5 = Thursday, 6 = Friday, 7 = Saturday 
  
SQLDayOfWeek = "SELECT (DATEPART(WEEKDAY, Event.Eventdate)) AS DOW FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & ""
Set rsDayOfWeek= OBJdbConnection.Execute(SQLDayOfWeek)	
DOW = UCase(rsDayOfWeek("DOW"))	
rsDayOfWeek.Close
Set rsDayOfWeek = nothing	

'ErrorLog("DOW " & DOW & "")	   

'Count # of Acts on the order.
SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND (DATEPART(WEEKDAY, Event.Eventdate)) = " & DOW & " AND OrderLine.SeatTypeCode = " & SeatTypeCode & " GROUP BY Event.ActCode) AS ActCount"
Set rsActCount = OBJdbConnection.Execute(SQLActCount)
ActCount = rsActCount("ActCount")
rsActCount.Close
Set rsActCount = nothing

'ErrorLog("ActCount " & ActCount & "")	
		
If ActCount = SeriesCount Then

'ErrorLog("SeriesCount " & SeriesCount & "")
		
    'Get the least number of tickets for any applicable ActCode
    SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Seat.SectionCode = '" & SectionCode & "' AND OrderLine.SeatTypeCode = " & SeatTypeCode & "  GROUP BY Event.ActCode) AS TicketCount"
    Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)			
    NbrSubscriptions = rsMinTicketCount("NumSubs")			
    rsMinTicketCount.Close
    Set rsMinTicketCount = nothing	
    
    'ErrorLog(" NbrSubscriptions" &  NbrSubscriptions & "")
        		
    'Get Act Code
    SQLAct = "SELECT ActCode FROM Event (NOLOCK) INNER JOIN SECTION (NOLOCK) On Event.EventCode = Section.EventCode WHERE Event.EventCode = " & EventCode & " Group By Event.ActCode"
    Set rsAct = OBJdbConnection.Execute(SQLAct)			
    ActCode = rsAct("ActCode")			
    rsAct.Close
    Set rsAct = nothing
    
     'ErrorLog("ActCode" &  ActCode & "")
        
    'Count # of existing seats which have discount applied for this act and seat type code
    SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND (DATEPART(WEEKDAY, Event.Eventdate)) = 7 AND OrderLine.SeatTypeCode = " & SeatTypeCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') "
    Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)			
    AppliedCount = rsDiscCount("LineCount")		
    rsDiscCount.Close
    Set rsDiscCount = nothing
    
    'ErrorLog("AppliedCount" &  AppliedCount  & "")
    		
    'Should the # of discounts at this price for these events < the total possible, discount price
        If AppliedCount < NbrSubscriptions Then					
		    Select Case DOW		
		        Case 4
		            SeriesPrice = WednesdayPrice
		        Case 5,6,7
		            SeriesPrice = WeekdayPrice
		        Case 1
		            SeriesPrice = SundayPrice
	        End Select
	        
	        'ErrorLog("SeriesPrice" &  SeriesPrice  & "")
	         
	        NewPrice = SeriesPrice
	         
	        If Price > NewPrice Then
	            DiscountAmount = Clean(Request("Price")) - NewPrice
	            AppliedFlag = "Y"
            End If
            
             'ErrorLog("DiscountAmount" &  DiscountAmount  & "")
           
            If Request("NewSurcharge") <> "" Then
	            Surcharge = NewSurcharge	
            ElseIf Request("CalcServiceFee") <> "N" Then
	            Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))				
            End If		
    		
        End If
															
End If
	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>

