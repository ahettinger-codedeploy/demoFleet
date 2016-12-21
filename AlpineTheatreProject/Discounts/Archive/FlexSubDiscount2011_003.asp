<%

'CHANGE LOG - Update
'SSR 5/6/2011
'Discount Code is now calculated on original order date rather than the current date


'CHANGE LOG - Update
'SSR 4/5/2011
'Act 58999 (Cagney) is now Act 61397 (No Way to Treat a Lady)


%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'===============================

'Alpine Theater Project (1/6/2010)
'2011 Season Subscription

'Full Season Acts:
'58993	My Funny Valentine 2: Love Letters
'58994	ATP Winter LAB: The Last 5 Years
'58995	AKTP: Rent School Edition
'58996	I Do! I Do!
'58997	She Loves Me
'58998	An Evening of Frank Loesser
'61397  No Way to Treat a Lady
'59000	AKTP: Disney's Alice in Wonderland Jr

'---------------------------------------

'Package 1 ("The Full Monty") - 8 Acts

'8 Season Series:
'58993	My Funny Valentine 2: Love Letters
'58994	ATP Winter LAB: The Last 5 Years
'58995	AKTP: Rent School Edition
'58996	I Do! I Do!
'58997	She Loves Me
'58998	An Evening of Frank Loesser
'61397  No Way to Treat a Lady
'59000	AKTP: Disney's Alice in Wonderland Jr *

'Discount: 25% until 2/12
'Discount: 20% until 4/1
'Discount: 15% until 6/19

'Must purchase 1 ticket to all 8 production codes:
' 58993,58994,58995,58996,58997,58998,61397,59000

' Tickets discounted on the following productions only: 58993; 58994; 58996; 58997; 58998;61397
' * Not Discounted: 58995,59000

'---------------------------------------

'Package 2 ("Winter/Summer") - 6 Acts

'6 Season Series:
'58993	My Funny Valentine 2: Love Letters
'58994	ATP Winter LAB: The Last 5 Years
'58996	I Do! I Do! *
'58997	She Loves Me
'58998	An Evening of Frank Loesser
'61397  No Way to Treat a Lady

' Discount/time frame: 20% until 2/12
' Discount/time frame: 15% until 4/1
' Discount/time frame: 10% until 6/19

' Must purchase a ticket to the following production codes:
' 58993,58994,58996,58997,58998,58999

' Tickets discounted on the following productions only: 58993; 58994; 58996; 58997; 58998; 61397
' Not Discount: N/A

'---------------------------------------

'Package 3 ("Summer") - 4 Acts

'58996	I Do! I Do!
'58997	She Loves Me
'58998	An Evening of Frank Loesser
'61397  No Way to Treat a Lady

'Discount/time frame: 20% until 2/12
'Discount/time frame: 15% until 4/1
'Discount/time frame: 10% until 6/19

'Must purchase a ticket to the following production codes:
'58996,58997,58998,58999

' Tickets discounted on the following productions only: 58996; 58997; 58998; 61397
' Not Discount: N/A


'===============================
'Discount Variables

ActCount1List = "58993,58994,58995,58996,58997,58998,59000,61397"
ActCount2List = "58993,58994,58996,58997,58998,61397"
ActCount3List = "58996,58997,58998,61397"

DIM SeriesPercentage(3)
SeriesPercentage(1) = 25
SeriesPercentage(2) = 20
SeriesPercentage(3) = 20

DIM Date(3)
Date(1) = "6/20/2011" 'After 6/20/2011 discount expires
Date(2) = "4/2/2011"  'After 4/2/2011 discount drops by 10
Date(3) = "2/13/2011" 'After 2/13/2011 discount drops by 5  

'===============================

If AllowDiscount = "Y"  Then 'It's okay to apply to this order.

' Determine the original order date
SQLDateCheck = "SELECT OrderHeader.OrderDate FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
Set rsDateCheck = OBJdbConnection.Execute(SQLDateCheck)
OriginalDate = rsDateCheck("OrderDate")
rsDateCheck.Close
Set rsDateCheck = nothing

If CDate(OriginalDate) < CDate(Date(1)) Then  

	    'Determine number of acts on order	    

	    SQLActCount1 = "SELECT COUNT(ActCode) AS ActCount1 FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine on Seat.ItemNumber = OrderLine.ItemNumber WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCount1List & ") AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " GROUP BY Event.ActCode) AS ActCount1"
	    Set rsActCount1 = OBJdbConnection.Execute(SQLActCount1)	
	    ActCount1 = rsActCount1("ActCount1")	
	    rsActCount1.Close
	    Set rsActCount1 = nothing

	    SQLActCount2 = "SELECT COUNT(ActCode) AS ActCount2 FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine on Seat.ItemNumber = OrderLine.ItemNumber WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCount2List & ") AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " GROUP BY Event.ActCode) AS ActCount2"
	    Set rsActCount2 = OBJdbConnection.Execute(SQLActCount2)	
	    ActCount2 = rsActCount2("ActCount2")	
	    rsActCount2.Close
	    Set rsActCount2 = nothing	    

	    SQLActCount3 = "SELECT COUNT(ActCode) AS ActCount3 FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine on Seat.ItemNumber = OrderLine.ItemNumber WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCount3List & ") AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " GROUP BY Event.ActCode) AS ActCount3"
	    Set rsActCount3 = OBJdbConnection.Execute(SQLActCount3)	
	    ActCount3 = rsActCount3("ActCount3")	
	    rsActCount3.Close
	    Set rsActCount3 = nothing
	    	
	    If ActCount1 = 8 Then
		    SubscriptionType = "8SHOW"
		    Percentage = SeriesPercentage(1)
	    ElseIf ActCount2 = 6 Then
		    SubscriptionType = "6SHOW"
		    Percentage = SeriesPercentage(2)
	    ElseIf ActCount3 = 4 Then
		    SubscriptionType = "4SHOW"
		    Percentage = SeriesPercentage(3)
	    Else
	        SubscriptionType = "NOSHOW"
	    End If
	    
	    If CDate(OriginalDate) > CDate(Date(2)) Then   'Drops to 10% off after 4/2/2011           
            Percentage = (Percentage - 10) 
        ElseIf CDate(OriginalDate) >  CDate(Date(3)) Then  'Drops to 5% off after 2/13/2011         
            Percentage = (Percentage - 5) 
        End If
	
		'Get the least number of tickets for allowed ActCodes
		SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCount1List & ") GROUP BY Event.ActCode) AS TicketCount"
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

		'Count # of existing seats which have discount applied for this act and seat type code
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
		AppliedCount = rsDiscCount("LineCount")		
		rsDiscCount.Close
		Set rsDiscCount = nothing
		
		If AppliedCount < NbrSubscriptions Then
		    
		    If SubscriptionType <> "NOSHOW" Then	

		            If SubscriptionType = "4SHOW" Then
                
                        Select Case ActCode 
                            Case 58996,58997,58998,58999,61397
                                NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)                
                                DiscountAmount = Clean(Request("Price")) - NewPrice
                                AppliedFlag = "Y" 	
                        End Select 
                         
		            End If
            		
		            If SubscriptionType = "6SHOW" Then
                  
                        Select Case ActCode 
                            Case 58993,58994,58996,58997,58998,58999,61397 
                                NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)                
                                DiscountAmount = Clean(Request("Price")) - NewPrice
                                AppliedFlag = "Y" 	
                        End Select  
                        
		            End If
            		
		            If SubscriptionType = "8SHOW" Then 
        		          
                        Select Case ActCode 
                            Case 58993,58994,58996,58997,58998,58999,61397 
                                NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)                
                                DiscountAmount = Clean(Request("Price")) - NewPrice
                                AppliedFlag = "Y" 	
                        End Select  
                          		
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
		
End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>