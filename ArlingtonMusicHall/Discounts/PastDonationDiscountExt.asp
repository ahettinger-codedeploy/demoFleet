<%

'CHANGE LOG
'SSR 09/24/14	'Created past donation discount script

                  'Tickets will be discounted if donation item(s) purchased in the past 365 days
                  'Tickets will also be discounted if the donation item(s) and the tickets are purchased on the same transaction.

                  'Required Parameters:

                  'Donation Item (single):                        &DonationItem=4758
                  'Donation Item (multiple):                      &DonationItem=4758,4759,4761,4762

                  'Number of tickets to discount (single): 	      &TicketCount=10
                  'Number of tickets to discount (multiple):      &TicketCount=10,8,4,4
                  
                  'Optional Parameter:

                  'Discount Tickets Per Act:                      &PerAct=Y
                  
'SSR 10/19/16     'Cleaned up discount script
				
%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%
	'--------------------------------------------------------

	'Discount Variables
	
	DIM CustomerNbr
	CustomerNbr = fnCustomerNbr
	
      DIM AllowedCount
      DIM AppliedCount
	
	'-------------------------------------------------------
		
	If AllowDiscount = "Y" Then 'It's okay to apply to this order.
      
      	AllowedCount = fnAllowedCount

		If AllowedCount > 0 Then
            
                  If Clean(Request("PerAct")) = "Y" Then
            
                        SQLAppliedCount = "SELECT Count(OrderLine.DiscountTypeNumber) as LineCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderHeader.CustomerNumber = " & CustomerNbr & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND Event.ActCode = (SELECT Event.ActCode FROM Event (NOLOCK) WHERE Event.EventCode = " & EventCode & ")"
                        Set rsAppliedCount= OBJdbConnection.Execute(SQLAppliedCount)
                              AppliedCount = rsAppliedCount("LineCount")
                        rsAppliedCount.Close
                        Set rsAppliedCount = nothing    
                  Else
                        SQLAppliedCount = "SELECT Count(OrderLine.DiscountTypeNumber) as LineCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderHeader.CustomerNumber = " & CustomerNbr & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & ""
                        Set rsAppliedCount= OBJdbConnection.Execute(SQLAppliedCount)
                              AppliedCount = rsAppliedCount("LineCount")
                        rsAppliedCount.Close
                        Set rsAppliedCount = nothing
                  End If
                  			
			If CInt(AppliedCount) < CInt(AllowedCount) Then
				Call ProcessDiscount
			End If
								
		End If
		
	End If
	
	Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
	Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
	Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
	Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf
		
	'--------------------------------------------------------
	
	Sub ProcessDiscount

            If Clean(Request("Percentage")) <> "" Then
                  'Percentage Discount
                  NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
                  
            ElseIf Clean(Request("FixedPrice")) <> "" Then
                  'FixedPrice Discount
                  NewPrice = round(CDbl(Clean(Request("FixedPrice"))),2)
                  
            ElseIf Clean(Request("DiscountAmount")) <> "" Then
                  'Amount Discount
                  NewPrice = round(CDbl(Clean(Request("Price"))),2) - round(CDbl(Clean(Request("DiscountAmount"))),2)
            
            Else
            
                  NewPrice = round(CDbl(Clean(Request("Price"))))
            
            End If

		If NewPrice < Price Then
		
			If NewPrice < 0 Then
				NewPrice = 0
			End If
			
			DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
			
			Call ProcessSurcharge
			
			AppliedFlag = "Y"
			
		End If
		
	End Sub
	
	'--------------------------------------------------------
	
	Sub ProcessSurcharge

            'Apply Series Surcharge
            If Clean(Request("SeriesSurcharge")) <> "" Then
                  SeriesSurcharge = Round(CDbl(Clean(Request("SeriesSurcharge"))),2)
                  
                  'Count # of applied tickets on this order
                  SQLCount = "SELECT COUNT(*) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
                  Set rsCount = OBJdbConnection.Execute(SQLCount)
                  TotalAppliedCount = rsCount("AppliedCount")
                  rsCount.Close
                  Set rsCount = nothing

                  'MOD function to determine the last ticket to complete the subscription discount (i.e. fourth ticket in the FlexPass-4, or eighth ticket in a FlexPass-8, etc.).  
                  Remainder = TotalAppliedCount MOD SeriesCount

                  ' Calculates the total of all discounted ticket prices already given to figure out the discounted ticket price to be assign to this ticket.
                  If Remainder = SeriesCount - 1 Then 
                        Surcharge = SeriesSurcharge - ((SeriesCount - 1) * Round(SeriesSurcharge / SeriesCount, 2))
                  Else
                        'Standard rounding on all other tickets.
                        Surcharge = Round(SeriesSurcharge/SeriesCount, 2)
                  End If

            'Apply NewSurcharge
            ElseIf Request("NewSurcharge") <> "" Then
                  Surcharge = Request("NewSurcharge")

            'Apply ReCalc Surcharge
            ElseIf Request("CalcServiceFee") <> "N" Then
                  Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
                  
            End If
			
	End Sub
	
	'--------------------------------------------------------
	
	Function fnAllowedCount
	
		'Determine the number of allowed tickets to discount:
			
            'List of donation items
		DIM DonationList 
		DonationList = Request.QueryString("DonationItem")
            
		'List of ticket counts
		DIM CountList 
		CountList = Request.QueryString("TicketCount")

		'Determine if there multiple price tiers
		If instr(DonationList,",") <> 0 AND instr(CountList,",") <> 0 Then
		
                  'Multiple Price Tiers
				
			'Array of donation items
			DIM DonationArr 
			DonationArr = split(DonationList,",")
			
			'Array of ticket counts
			DIM CountArr	
			CountArr = split(CountList,",")
                  
                  'Discount Table
			
			'1st column: donation item
			DIM DonationCol 
			DonationCol = 0
			
			'2nd column: ticket count
			DIM CountCol 
			CountCol = 1
			
			'Determine number of rows in table
			DIM rowCount 
			rowCount = uBound(DonationArr)

			'Create discount table
                  DIM arrayTble
                  reDIM arrayTble(rowCount) 
			
			'Populate each row in discount table
			For i = 0 to rowCount
				arrayTble(i) = array(CDbl(DonationArr(i)),CDbl(CountArr(i)))
			Next
			
			'Sort the discount table
			For col1 = UBound(arrayTble) - 1 To 0 Step -1
				For col2 = 0 To col1
					If arrayTble(col2)(0) > arrayTble(col2+1)(0) Then
						swap = arrayTble(col2)
						arrayTble(col2) = arrayTble(col2+1)
						arrayTble(col2+1) = swap
					End If
				Next
			Next
			
			'Loop through each row in discount table
                  'Determine the correct number of tickets to discount
			For i = 0 To rowCount
			
				row = arrayTble
				DonationItem = row(i)(DonationCol)
				TicketCount = row(i)(CountCol)
			
				SQLCount = "SELECT Count(OrderLine.ItemNumber) AS ItemCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE (OrderLine.ItemNumber = " & DonationItem & " AND OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.StatusCode = 'R') OR (OrderLine.ItemNumber = " & DonationItem & " AND OrderHeader.CustomerNumber = " & CustomerNbr & " AND OrderLine.StatusCode = 'S' AND GetDate() < (DateAdd(Day, 365, OrderHeader.OrderDate)))" 
				Set rsCount = OBJdbConnection.Execute(SQLCount)
					If Not IsNull(rsCount("ItemCount")) Then
						Count = Count + (rsCount("ItemCount") * TicketCount)				
					End If
				rsCount.Close
				Set rsCount = nothing
				
			Next
				
		Else
		
                  'Single Discount Price Tier
                  
                  DonationItem = Request.QueryString("DonationItem")
                  TicketCount = Request.QueryString("TicketCount")

                  SQLCount = "SELECT Count(OrderLine.ItemNumber) AS ItemCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE (OrderLine.ItemNumber = " & DonationItem & " AND OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.StatusCode = 'R') OR (OrderLine.ItemNumber = " & DonationItem & " AND OrderHeader.CustomerNumber = " & CustomerNbr & " AND OrderLine.StatusCode = 'S' AND GetDate() < (DateAdd(Day, 365, OrderHeader.OrderDate)))" 
                  Set rsCount = OBJdbConnection.Execute(SQLCount)
                        If Not IsNull(rsCount("ItemCount")) Then
                              Count = Count + (rsCount("ItemCount") * TicketCount)					
                        End If
                  rsCount.Close
                  Set rsCount = nothing

  				
		End If
		
		fnAllowedCount = Count 

	End Function
	
	'--------------------------------------------------------
	
	Function fnCustomerNbr
	
		DIM strResult
	
		'get Customer Number
		SQLMemberNumber= "SELECT CustomerNumber FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
		Set rsMemberNumber = OBJdbConnection.Execute(SQLMemberNumber)
			If Not rsMemberNumber.EOF Then
				strResult = rsMemberNumber("CustomerNumber")
			End If
		rsMemberNumber.Close
		Set rsMemberNumber = nothing
		
		
		fnCustomerNbr = strResult
		
		
	End Function
	
	'--------------------------------------------------------

%>