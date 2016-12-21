<%

'SSR 11/30/15 - Created custom discount. Uses customer classification and production subcategory to determine discount.
'SSR 12/01/15 - Updated. New surcharge of $0 on ticket discounted at 100%. No change to service fee on tickets discounted at 50%.

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%
'============================================================
'Body Local 
'Customer Classification Discount by Event Act Subcategory

'DISCOUNT PARAMETERS
'
'Valid Customer Classifications
'436  (Existing Member)  
'437  (New Member)  
'
'Valid Production Subcategory
'174 (Soiree) 
'173 (Luncheon)
'Customers with a valid customer classification who purchase tickets to an event with a valid production subcategory 
'Will receive specific number of free tickets as listed below.  Any additional tickets will receive a 50% discount
'
'Customer	Production			Disc		Disc
'Class		SubCategory			100%		50%
'436 		173					1			Unlimited
'436 		174					2			Unlimited
'
'437 		173					1			Unlimited
'437 		174					1			Unlimited
'
'DISCOUNT RESTRICTIONS
'
'Discounted ticket types can be any ticket type, any section, any price tier.
'Only customers with valid classifications and valid subcategories (as listed above) will receive discounted tickets.  
'Since each customer can have multiple classifications, the total number of allowed tickets is the combined total across all valid customer classifications.
'$0 service fee on 100% discounted tickets.
'No change to service fee on 50% discounted tickets.


'========================================================

'Set Discount Variables

DIM CustClass1
DIM CustClass2

CustClass1 = 436	'Existing Member 
CustClass2 = 437	'New Member 

DIM EventClass1
DIM EventClass2
DIM EventClass3

EventClass1 = 173 	'Luncheon
EventClass2 = 174	'Soiree
EventClass3 = 165	'Holiday - 2015

DIM Percentage1
DIM Percentage2

Percentage1 = 100	'Ticket Discount
Percentage2 = 50	'Addl Ticket Discount

'---------------------------------------------------------

'Set Counters

DIM CustomerNumber
CustomerNumber = fnCustomerNumber

DIM AllowedTickets
AllowedTickets = 0

DIM AppliedCount
AppliedCount = 0

'---------------------------------------------------------


If AllowDiscount = "Y" Then 

		'---------------------------------------------

		'Determine the production subcategory for this event
		SQLEventClass = "SELECT Act.SubCategoryCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE Event.EventCode = " & EventCode & ""
		Set rsEventClass = OBJdbConnection.Execute(SQLEventClass)
			If Not rsEventClass.EOF Then
				EventClass = rsEventClass("SubCategoryCode")
				'ErrorLog("EventClass: " & EventClass & "")
			End If
		rsEventClass.Close
		Set rsEventClass = nothing
		
		'---------------------------------------------

		'Determine the classifications for this customer
		SQLCustClass = "SELECT OrderHeader.CustomerNumber, CustomerClass.ClassNumber FROM OrderHeader (NOLOCK) INNER JOIN CustomerClass (NOLOCK) ON OrderHeader.CustomerNumber = CustomerClass.CustomerNumber  WHERE OrderNumber = " & OrderNumber & ""
		Set rsCustClass = OBJdbConnection.Execute(SQLCustClass)
			If Not rsCustClass.EOF Then
			
				'ErrorLog("CustClass: " & rsCustClass("ClassNumber") & "")
			
				Do While Not rsCustClass.EOF
									
					Select Case rsCustClass("ClassNumber")
			
						Case CustClass1 '436

							Select Case EventClass
							
								Case EventClass1 '173
								
									'ErrorLog("CustomerClass 436 AND EventClass 173 = AllowedTickets: 1")
									AllowedTickets = AllowedTickets + 1
								
								Case EventClass2 '174
								
									'ErrorLog("CustomerClass 436 AND EventClass 174 = AllowedTickets: 2")
									AllowedTickets = AllowedTickets + 2
								
								Case EventClass3 '165
								
									'ErrorLog("CustomerClass 436 AND EventClass 165 = AllowedTickets: 1")
									AllowedTickets = AllowedTickets + 1
							
							End Select
						
						Case CustClass2 '437
						
							Select Case EventClass
							
								Case EventClass1 '173
								
									'ErrorLog("CustomerClass 437 AND EventClass 173 = AllowedTickets: 1")
									AllowedTickets = AllowedTickets + 1
								
								Case EventClass2 '174
								
									'ErrorLog("CustomerClass 437 AND EventClass 174 = AllowedTickets: 1")
									AllowedTickets = AllowedTickets + 1
								
								Case EventClass3 '165
								
									'ErrorLog("CustomerClass 437 AND EventClass 165 = AllowedTickets: 2")
									AllowedTickets = AllowedTickets + 0
							
							End Select
												
					End Select

				rsCustClass.MoveNext	
				Loop	
			End If
		rsCustClass.Close
		Set rsCustClass = nothing
		
		'ErrorLog("AllowedTickets: " & AllowedTickets & "")
				
		'---------------------------------------------
	
		'Determine the number of discounted tickets for this event
		SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (OrderHeader.CustomerNumber = " & CustomerNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S') OR (OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'R')"
		Set rsApplied = OBJdbConnection.Execute(SQLApplied)	
			AppliedCount = rsApplied("TicketCount")	
			'ErrorLog("AppliedCount: " & AppliedCount &"")			
		rsApplied.Close
		Set rsApplied = nothing
		
		'---------------------------------------------
		
		If AllowedTickets > 0 Then 
	 
			If AppliedCount < AllowedTickets Then				
				NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage1)/100), 2)	
				NewSurcharge = 0
			Else
				NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage2)/100), 2)	
				NewSurcharge = ""
			End If
															
			DiscountAmount = Price - NewPrice
			
			AppliedFlag = "Y"
			
			If NewSurcharge <> "" Then
				Surcharge = NewSurcharge
			Else
				If Request("CalcServiceFee") <> "N" Then
					Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
				End If
			End If
		
			'ErrorLog("DiscountAmount: " & DiscountAmount & "")
		
		End If

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

'---------------------------------------------------------

Public Function fnCustomerNumber

	'this function returns the patrons customer number

	DIM strResults

	If Request("CustomerNumber") = "" Then 
		SQLOrderCustomer = "SELECT CustomerNumber FROM OrderHeader (NOLOCK) WHERE OrderNumber = " & OrderNumber
		Set rsOrderCustomer = OBJdbConnection.Execute(SQLOrderCustomer)
			If Not rsOrderCustomer.EOF Then
				strResults = rsOrderCustomer("CustomerNumber")
			End If
		rsOrderCustomer.Close
		Set rsOrderCustomer = nothing
	Else
		strResults = CleanNumeric(Request("CustomerNumber"))
	End If
	
	fnCustomerNumber = strResults

End Function

'---------------------------------------------------------



%>
