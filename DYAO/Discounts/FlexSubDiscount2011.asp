<%

'CHANGE LOG - Inception
'SSR 8/25/2011
'Custom Season Discount

'CHANGE LOG - Update
'SSR 9/28/2011
'Restricted discount to ItemType Seat Only


%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->
<%

'================================================================

'Denver Young Artists Orchestra (8/25/2011)

'4 Act Season Subscription
'3 Price Tiers by Section Color and Seat Type Code - Series Price

'Valid subscriptions must have 1 ticket to all 4 productions
'Valid subscriptions must be of the same ticket type
'Valid subscriptions must contain the same section color

'Valid Acts
'------------
'(67728) DYAO Presents Linda Wang, Violin - October 16, 2011 at 2:30pm 
'(67729) DYAO Presents David Korevaar, Piano - December 17, 2011 at 7:30pm 
'(67730) DYAO 2012 Concerto Competition Winner - March 11, 2012 at 2:30pm 
'(67731) DYAO Prokofiev Symphony No. 5 - May 6, 2012 at 2:30pm 

'Tier 1 Series 
'------------------
'BLUE SECTION
'Adult $100
'Senior $50
'Student $50

'Tier 2 Series 
'------------------
'GOLD SECTION
'Adult $70
'Senior $36
'Student $36

'Tier 3 Series 
'-------------------
'GREEN SECTION
'Adult $50
'Senior $20
'Student $20

'================================================================

SeriesCount = 4

ActCodeList = "67728,67729,67730,67731"

SeatTypeA = "1" 'Adult
SeatTypeB = "3" 'Senior
SeatTypeC = "6" 'Student

Tier1_Color = "DARKBLUE"
Tier1_PriceA = "100"
Tier1_PriceB = "50"

Tier2_Color = "DARKGOLD"
Tier2_PriceA = "70"
Tier2_PriceB = "36"

Tier3_Color = "DARKGREEN"
Tier3_PriceA = "50"
Tier3_PriceB = "20"

'================================================================

'Get the color for this section (needed for this discount to work)
SQLColor = "SELECT Color FROM Section(NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "'"
Set rsColor = OBJdbConnection.Execute(SQLColor)	
Color = UCase(rsColor("Color"))	
rsColor.Close
Set rsColor = nothing

'Counts the number of tickets to each act with matching Seat Type Code and matching Color
SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('Seat') AND Event.ActCode IN (" & ActCodeList & ") AND Color = '" & Color & "' AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " AND Color IN ('DarkBlue', 'DarkGold', 'DarkGreen') GROUP BY Event.ActCode) AS ActCount"
Set rsActCount = OBJdbConnection.Execute(SQLActCount)
ActCount = rsActCount("ActCount")
rsActCount.Close
Set rsActCount = nothing
		
If ActCount >= SeriesCount Then
		
    'Get the least number of tickets for any applicable ActCode
    SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('Seat') GROUP BY Event.ActCode) AS TicketCount"
    Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)			
    NbrSubscriptions = rsMinTicketCount("NumSubs")			
    rsMinTicketCount.Close
    Set rsMinTicketCount = nothing	
			
    SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode & ""
	Set rsAct = OBJdbConnection.Execute(SQLAct)		
	ActCode = rsAct("ActCode")		
	rsAct.Close
	Set rsAct = nothing 
		    
    SQLSergioCount = "SELECT OrderLine.LineNumber as LineCode,  Act.Act as Actname, orderline.itemnumber as itemcode, orderline.discounttypenumber as disccode FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act on Event.ActCode = Act.ActCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('Seat') AND act.ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & ""
    Set rsSergioCount = OBJdbConnection.Execute(SQLSergioCount)
    
   ' If not rsSergioCount.EOF Then
    '    Do While NOT rsSergioCount.EOF
        
    '    Line1 = rsSergioCount("LineCode")
    '    Line1 = Line1 & "Item: " & rsSergioCount("itemCode")  
    '    Line1 = Line1 & "Act: " & rsSergioCount("actname")   
    ''    Line1 = Line1 & "Disc: " & rsSergioCount("discCode")   
        ErrorLog("Line1  " & Line1  & "")
        
    '    rsSergioCount.movenext
    '    Loop
   ' End If
    
    rsSergioCount.Close
    Set rsSergioCount = nothing	
		
	'Count # of existing seats which have discount applied for this act
	SQLDiscCount = "SELECT COUNT(*) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
	AppliedCount = rsDiscCount("LineCount")
	rsDiscCount.Close
	Set rsDiscCount = nothing 
         
    	    
    If AppliedCount < NbrSubscriptions Then	
    
        'Tier 1 Series 
        '------------------
        Select Case Color
        Case Tier1_Color
                Select Case SeatTypeCode
	            Case SeatTypeA
                    SeriesPrice = Tier1_PriceA
                Case SeatTypeB, SeatTypeC
                    SeriesPrice = Tier1_PriceB
                End Select
        End Select
        
        'Tier 2 Series 
        '------------------
        Select Case Color
        Case Tier2_Color
                Select Case SeatTypeCode
	            Case SeatTypeA
                    SeriesPrice = Tier2_PriceA
                Case SeatTypeB, SeatTypeC
                    SeriesPrice = Tier2_PriceB
                End Select
        End Select
        
        'Tier 3 Series 
        '------------------
        Select Case Color
        Case Tier3_Color
                Select Case SeatTypeCode
	            Case SeatTypeA
                    SeriesPrice = Tier3_PriceA
                Case SeatTypeB, SeatTypeC
                    SeriesPrice = Tier3_PriceB
                End Select
        End Select 

	    'Count number of tickets which have been given a discount
	    SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS AppliedCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')" 
	    Set rsCount = OBJdbConnection.Execute(SQLCount)
	    Count = rsCount("AppliedCount")
	    rsCount.Close
	    Set rsCount = nothing
	    
        Remainder = Count MOD SeriesCount				        

            If Remainder = SeriesCount - 1 Then 
                NewPrice = SeriesPrice - ((SeriesCount - 1) * Round(SeriesPrice/SeriesCount, 2))
            Else
                NewPrice = Round(SeriesPrice/SeriesCount, 2)
            End If
				
	        DiscountAmount =  Clean(Request("Price")) - NewPrice
	    	            
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