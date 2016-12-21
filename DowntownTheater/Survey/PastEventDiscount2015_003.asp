<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%
'CHANGE LOG
'SSR 10/09/14 - 'Updated survey to process the membership discount for TIX1. 
				'The discount code for TIX2 has also been programmed but it is not currently in use.
				'Please note that when it's decided to switch this org over to TIX2, use discount code 2014SubTix2

				
	'-------------------------------------
	'Survey Parameters
	
	'Get the discount code
	DIM DiscountNumber
	DiscountNumber = 99347
		
	DIM OrderNumber
	OrderNumber = Session("OrderNumber")
		
	'Get the Required Event Code
	DIM RequiredPastEvent
	RequiredPastEvent = fnGetVarValue("RequiredPastEvent")

	'Get the MemberDiscount
	DIM MemberDiscount
	MemberDiscount = CDbl((fnGetVarValue("Percentage")/100))
		
	'Get the Customer Number
	DIM CustomerNbr
	If CustomerNbr = 1 Then
		SQLMemberNumber= "SELECT CustomerNumber FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
		Set rsMemberNumber = OBJdbConnection.Execute(SQLMemberNumber)
			If Not rsMemberNumber.EOF Then
				CustomerNbr = rsMemberNumber("CustomerNumber")
			End If
		rsMemberNumber.Close
		Set rsMemberNumber = nothing
		
	Else
		CustomerNbr = Session("CustomerNumber")
	End If
	
	'----------------------------------------------------------
	
	If Session("OrderNumber") = "" Then
		If Session("UserNumber") = "" Then
			Response.Redirect("/Default.asp")
		Else
			Response.Redirect("/Management/Default.asp")
		End If	
	Else
		If Session("OrderTypeNumber") = 5 Then
			Call Continue
		End If
	End If


	Call ApplyDiscount
	
'----------------------------------------------------------
	
	Sub ApplyDiscount
	
		ProductionList = Split(fnActList,",")
	
		'Verify that another discount has not been applied
		If Not fnOtherDiscount Then
		
			'Determine the number of free tickets allowed for each production
			TotalTicketCount = fnAllowedDiscount
			
			If TotalTicketCount > 0 Then
			
				For ActCd = lbound(ProductionList) to ubound(ProductionList)
				
					SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE CustomerNumber = " & CustomerNbr & " AND ActCode = " & CleanNumeric(ProductionList(ActCd)) & " AND OrderLine.StatusCode = 'S' AND OrderLine.DiscountTypeNumber = " & DiscountNumber & " AND OrderHeader.OrderNumber <> " & OrderNumber & ""
					Set rsApplied = OBJdbConnection.Execute(SQLApplied)

						SeasonTicketCount = (TotalTicketCount - rsApplied("TicketCount"))
						
						If SeasonTicketCount > 0 Then 
								
							SQLLineNo = "SELECT TOP(" & SeasonTicketCount & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ProductionList(ActCd) & " ORDER BY LineNumber DESC"
							Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)

							If Not rsLineNo.EOF Then 				
								Do While Not rsLineNo.EOF
									SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & MemberDiscount & ", Surcharge = 0, DiscountTypeNumber = " & DiscountNumber & " WHERE OrderNumber = " & OrderNumber & " AND LineNumber = " & rsLineNo("LineNumber") & ""
									Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
									rsLineNo.movenext
									FreeTicketCount = FreeTicketCount + 1
								Loop
							End If

							rsLineNo.Close
							Set rsLineNo = Nothing
								
						End If
							
					rsApplied.Close
					Set rsApplied = nothing     

				Next
				
			End If
			
		End If
			
			
			Call Continue

	End Sub
	
	'----------------------------------------------------------
	
	Function fnAllowedDiscount

		'Determine the number of discounted tickets for each production

		DIM NbrSubscriptions
		NbrSubscriptions = 0
		
		SQLPastEventCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE (EventCode IN (" & RequiredPastEvent & ") AND OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.StatusCode = 'R') OR (EventCode IN (" & RequiredPastEvent & ") AND OrderHeader.CustomerNumber = " & CustomerNbr & " AND OrderLine.StatusCode = 'S' AND GetDate() < (DateAdd(Day, 365, OrderHeader.OrderDate)))"
		Set rsPastEventCount = OBJdbConnection.Execute(SQLPastEventCount)
			If Not rsPastEventCount.EOF Then
				NbrSubscriptions = rsPastEventCount("TicketCount")
			End If
		rsPastEventCount.Close
		Set rsPastEventCount = nothing
				

		DIM SeriesCount
		SeriesCount = fnGetVarValue("SeriesCount") 

		
		DIM MaxDiscounts
		MaxDiscounts = (NbrSubscriptions * SeriesCount)
		
		fnAllowedDiscount = MaxDiscounts
		
		
	End Function
	
	'----------------------------------------------------------
	
	Function fnOtherDiscount
	
		DIM DiscountFound
		DiscountFound = FALSE
		
		SQLOtherDiscount = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ( OrderLine.DiscountTypeNumber <> 0 AND OrderLine.DiscountTypeNumber <> " & DiscountNumber & " )"
		Set rsOtherDiscount = OBJdbConnection.Execute(SQLOtherDiscount)
			If NOT rsOtherDiscount.EOF Then 
				If rsOtherDiscount("Count") > 0 Then
					DiscountFound = TRUE
				End If
			End If
		rsOtherDiscount.Close
		Set rsOtherDiscount = nothing

		fnOtherDiscount = DiscountFound
	
	End Function
	
'----------------------------------------------------------

	Function fnGetVarValue(VarName)

		SQLDiscountScript = "SELECT DiscountScript FROM DiscountType (NOLOCK) WHERE DiscountType.DiscountTypeNumber = " & DiscountNumber & ""
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
		
		fnGetVarValue=str1

	End Function

	
'--------------------------------------------------------

	Function fnActList
	
		SQLActCodeList = "SELECT DISTINCT Event.ActCode FROM DiscountEvents (NOLOCK) INNER JOIN Event (NOLOCK) ON DiscountEvents.EventCode = Event.EventCode WHERE DiscountTypeNumber = " & DiscountNumber & ""
		Set rsActCodeList = OBJdbConnection.Execute(SQLActCodeList )
			If NOT rsActCodeList.EOF Then 
				ActCodeList = ActCodeList & rsActCodeList("ActCode") &","
			End If
		rsActCodeList.Close
		Set rsActCodeList = nothing
		
		ActCodeList = Left(ActCodeList, Len(ActCodeList) - 1)  
			
		fnActList = ActCodeList
	
	End Function

'--------------------------------------------------------

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

