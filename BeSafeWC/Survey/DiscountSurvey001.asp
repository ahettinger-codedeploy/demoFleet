<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'CHANGE LOG
'SSR 09/24/14	'Per Ticket Discount Survey
				'Companion to the Per Ticket Discount Script
				
	'-------------------------------------

	'Discount Variables

	DIM DiscountNumber
	DiscountNumber = 99124

	DIm varIndex
	varIndex = "RequiredDonationItem"

	DIm varDisc
	varDisc = "SeriesCount"

	DIM MemberDiscount
	MemberDiscount = CDbl((GetVarValue(DiscountNumber, "Percentage")/100))

	DIM MaxDiscount
	MaxDiscount = getMaxAllowedDiscount
		
	'----------------------------------------------------------

	'Check to see if Order Number exists.  If not, redirect to Home Page.

	If Session("OrderNumber") = "" Then

		If Session("UserNumber") = "" Then
			Response.Redirect("/Default.asp")
		Else
			Response.Redirect("/Management/Default.asp")
		End If
		
	Else

		If Session("UserNumber") = "" Then
			Call Continue
		Else
			Page = "Management"
		End If
		
		If Session("OrderTypeNumber") = 5 Then
			Call Continue
		End If
		
	End If

	Call ApplyDiscount
	
	'----------------------------------------------------------
	
	Sub ApplyDiscount
	
		'Determine that another discount has not been applied
		If Not OtherDiscount Then
			
			'Determine if patron qualifies for discounted tickets
			If MaxDiscount > 0 Then
							
				TicketQuantity = AppliedDiscounts(MaxDiscount)
				
				'Process discount
				SQLLineNo = "SELECT TOP(" & TicketQuantity & ") OrderLine.LineNumber FROM OrderLine (NOLOCK) WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Discount = 0 AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
				Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)    
				
					If Not rsLineNo.EOF Then
						Do While Not rsLineNo.EOF                
							SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = (Price * " & MemberDiscount & "), DiscountTypeNumber = " & DiscountNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
							Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
							rsLineNo.movenext
						Loop
					End If

				rsLineNo.Close
				Set rsLineNo = Nothing

				Call Continue
				
			End If
				
		End If


	End Sub

	'--------------------------------------------------------

	Function getMaxAllowedDiscount
		
		DIM TicketCount 'Number of Allowed Discounted Tickets
		TicketCount = 0
			
		DIM IndexList 'donation items
		IndexList = GetVarValue(DiscountNumber, varIndex)
		
		DIM DiscList 'Series Count
		DiscList = GetVarValue(DiscountNumber, varDisc)
						
		DIM arrayTble 'Discount Table
				
		If instr(IndexList,",") <> 0 AND instr(DiscList,",") <> 0 Then
				
			'get list of donation items
			DIM IndexArr 
			IndexArr = split(IndexList,",")
			
			'get list of series count
			DIM DiscArr	
			DiscArr = split(DiscList,",")
			
			'1st column: donation items
			DIM IndexCol 
			IndexCol = 0
			
			'2nd column: series count
			DIM DiscCol 
			DiscCol = 1
			
			'get number of rows in table
			DIM rowCount 
			rowCount = uBound(IndexArr)

			'Resize table
			reDIM arrayTble(rowCount) 
			
			'Populate table cells
			For i = 0 to rowCount
				arrayTble(i) = array(CDbl(IndexArr(i)),CDbl(DiscArr(i)))
			Next
			
			'Sort table by first column
			For col1 = UBound(arrayTble) - 1 To 0 Step -1
				For col2 = 0 To col1
					If arrayTble(col2)(0) > arrayTble(col2+1)(0) Then
						swap = arrayTble(col2)
						arrayTble(col2) = arrayTble(col2+1)
						arrayTble(col2+1) = swap
					End If
				Next
			Next
			
			'Determine past purchase history
			For i = 0 To rowCount
			
				row = arrayTble
				RequiredDonationItem = row(i)(IndexCol)
				SeriesCount = row(i)(DiscCol)
			
				SQLMember = "SELECT Count(OrderLine.ItemNumber) AS ItemCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE (OrderLine.ItemNumber = " & RequiredDonationItem & " AND OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.StatusCode = 'R') OR (OrderLine.ItemNumber = " & RequiredDonationItem & " AND OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.StatusCode = 'S' AND GetDate() < (DateAdd(Day, 365, OrderHeader.OrderDate)))" 
				Set rsMember = OBJdbConnection.Execute(SQLMember)
					If Not IsNull(rsMember("ItemCount")) Then
						TicketCount = TicketCount + (rsMember("ItemCount") * SeriesCount)				
					End If
				rsMember.Close
				Set rsMember = nothing
				
			Next
				
		End If
		
		getMaxAllowedDiscount = TicketCount

	End Function
	
	'-------------------------------------
	
	Function OtherDiscount
	
		DIM DiscountFound
		DiscountFound = FALSE
		
		SQLOtherDiscount = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND ( OrderLine.DiscountTypeNumber <> 0 AND OrderLine.DiscountTypeNumber <> " & DiscountNumber & " )"
		Set rsOtherDiscount = OBJdbConnection.Execute(SQLOtherDiscount)
			If NOT rsOtherDiscount.EOF Then 
				If rsOtherDiscount("Count") > 0 Then
					DiscountFound = TRUE
				End If
			End If
		rsOtherDiscount.Close
		Set rsOtherDiscount = nothing

		OtherDiscount = DiscountFound
	
	End Function
	
	'-------------------------------------
	
	Function AppliedDiscounts(MaxDiscount)
		
		DIM TicketCount
		TicketCount = 0
	
		'Determine number of discounted tickets already given to the patron
		SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & DiscountNumber & " AND OrderLine.StatusCode = 'S'"
		Set rsApplied = OBJdbConnection.Execute(SQLApplied)
			TicketCount = (MaxDiscount - rsApplied("TicketCount"))
		rsApplied.Close
		Set rsApplied = nothing
					
		AppliedDiscounts = CInt(TicketCount)	
		
	End Function
	
	'-------------------------------------
	
	Function GetVarValue(strDiscountNumber, VarName)

		SQLDiscountScript = "SELECT DiscountScript FROM DiscountType (NOLOCK) WHERE DiscountType.DiscountTypeNumber = " & strDiscountNumber & ""
		Set rsDiscountScript = OBJdbConnection.Execute(SQLDiscountScript)
			If NOT rsDiscountScript.EOF Then 
				source = rsDiscountScript("DiscountScript")
			End If
		rsDiscountScript.Close
		Set rsDiscountScript = nothing

		pos1 = instr(source, varname + "=")

		'to check if the variable was not found
		if pos1=0 then
			GetVarValue="Not Found!!!"
			exit function
		end if
		pos1 = pos1 + len(varName) + 1
		pos2=instr(mid(source,pos1), "&")-1


		'to check if it was the last variable
		if pos2=-1 then
			str1 = mid(source, pos1)
		else
			str1 = mid(source, pos1, pos2)
		end if
		
		GetVarValue=str1

	End Function
	
	'-------------------------------------
	
	Sub Continue

		Session("SurveyComplete") = Session("OrderNumber")
		If Session("UserNumber") = "" Then
			Response.Redirect("/Ship.asp")
		Else
			Response.Redirect("/Management/AdvanceShip.asp")
		End If
		
	End Sub 'Continue

	'--------------------------------------------------------

%>

