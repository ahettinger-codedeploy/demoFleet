<%

'CHANGE LOG
'SSR 6/13/14 Created TIX1 Past Event Survey to compliment TIX2 Past Event Discount
'SSR 6/16/14 Updated to allow discounts in any combination for Flex Pass subscription

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'-------------------------------------------------

Page = "Survey"
SurveyNumber = 1685
SurveyFileName = "PastEventDiscount2014.asp"

'===============================================

'Chester Theatre Company 
'2014 Season Subscription

'Past Event Discount
'When patron buys a ticket to either of the three subscription events,
'they will receive 1 discounted ticket to each of the 4 productions
 
'EventCode		Name				Valid Days					Quantity						
'----------		----------------------------------------------------------		
'631798 	 	2014 Flex Pass		Any Day						6 tickets in any combination
'631849 	 	2014 Weekday  		Wednesday/Thursday/Friday	1 ticket to each production
'631851 	 	2014 Weekend 		Saturdays/Sundays			1 ticket to each production


'ActCode    Production
'-------	----------
'101071		Madagascar
'101072		Annapurna
'101073		A Number
'101074		The Amish Project


'Discount Amount
'--------------------------- 
'Discount: 	  100% off
'Service Fee: $0.00

'Restrictions
'--------------------------- 
'Automatic discount
'Applied to online orders only
'Valid for all ticket types
'Valid for all sections/price tiers
'Does not expire

'Weekday, 4 = Wednesday, 5 = Thursday, 6 = Friday
'Weekend, 1 = Sunday, 7 = Saturday 

'==================================================

'Survey Variables

	DIM ActCodeList
	DIM MemberDiscountNumber
	
	DIM MemberEvent1,MemberEvent2,MemberEvent3
	DIM SeriesCount1,SeriesCount2,SeriesCount3
	
	DIM AppliedCount1,AppliedCount2,AppliedCount3
	DIM AllowedCount1,AllowedCount2,AllowedCount3
	DIM AvailableCount1,AvailableCount2,AvailableCount3
	DIM FreeTicketCount
	
	DIM MemberEvent1Found

	ActCodeList = "101071,101072,101073,101074"
	
	MemberDiscountNumber = 91167
	
	DiscountAmount = 1.0 '100% Discount

	MemberEvent1 = "631849"	'2014 Weekday
	SeriesCount1 = 1
	
	MemberEvent2 = "631851"	'2014 Weekend
	SeriesCount2 = 1
	
	MemberEvent3 = "631798"	'2014 Flex Pass
	SeriesCount3 = 6

	AppliedCount1 = 0
	AllowedCount1 = 0
	AvailableCount1 = 0
	
	AppliedCount2 = 0
	AllowedCount2 = 0
	AvailableCount2 = 0
	
	
	FreeTicketCount1 = 0
	FreeTicketCount2 = 0
	
	MemberEvent1Found = FALSE
	MemberEvent2Found = FALSE
	MemberEvent3Found = FALSE

'--------------------------------------------------------------
 
	'Check to see if Order Number exists.
	'Display management tabs for box office orders

	If Session("OrderNumber") = "" Then
		If Session("UserNumber") = "" Then
			Response.Redirect("/Default.asp")
		Else
			Response.Redirect("/Management/Default.asp")
		End If	
	Else
		If Session("UserNumber") = "" Then
			Page = "Survey"
		Else
			Page = "Management"
		End If	
	End If


	'Check to see if this is a Comp Order. If so, skip the survey.
	If Session("OrderTypeNumber") = 5 Then
		Call Continue
	End If
	
	If Clean(Request("FormName")) = "Continue" Then    
		Call Continue    
	Else
	   Call MembershipCheck  
	End If
	
	Call Continue

	OBJdbConnection.Close
	Set OBJdbConnection = nothing

'--------------------------------------------------------------

	Sub MembershipCheck 
	
		If Session("CustomerNumber") <> "" Then
			CustomerNbr = Session("CustomerNumber")
		Else
			'Get the customer number
			SQLCustNumber = "SELECT CustomerNumber FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & Session("OrderNumber") & ""
			Set rsCustNumber = OBJdbConnection.Execute(SQLCustNumber)
				If Not rsCustNumber.EOF Then
					CustomerNbr = rsCustNumber("CustomerNumber")
				End If
			rsCustNumber.Close
			Set rsCustNumber = nothing
		End If
		
		ERRORLOG("CustomerNbr: "& CustomerNbr &"")
		
		'--------------------------------------------------------------
		
		'Determine if the patron has purchased member event 1
		SQLMemberEvent = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND EventCode = " & CleanNumeric(MemberEvent1) & ""
		Set rsMemberEvent = OBJdbConnection.Execute(SQLMemberEvent)
		If Not rsMemberEvent.EOF Then
			MemberEvent1Found = True
		End If   
		rsMemberEvent.Close
		Set rsMemberEvent = nothing
		
		ERRORLOG("MemberEvent1: "&MemberEvent1&" "&MemberEvent1Found&"")

		'--------------------------------------------------------------
			
		'Determine if the patron has purchased member event 2
		SQLMemberEvent = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CustomerNbr & " AND EventCode = " & CleanNumeric(MemberEvent2) & ""
		Set rsMemberEvent = OBJdbConnection.Execute(SQLMemberEvent)
		If Not rsMemberEvent.EOF Then
			MemberEvent2Found = True
		End If   
		rsMemberEvent.Close
		Set rsMemberEvent = nothing
		
		ERRORLOG("MemberEvent2: "&MemberEvent2&" "&MemberEvent2Found&"")
		
		'--------------------------------------------------------------
		
		'Determine if the patron has purchased member event 3
		SQLMemberEvent = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CustomerNbr & " AND EventCode = " & CleanNumeric(MemberEvent3) & ""
		Set rsMemberEvent = OBJdbConnection.Execute(SQLMemberEvent)
		If Not rsMemberEvent.EOF Then
			MemberEvent3Found = True
		End If   
		rsMemberEvent.Close
		Set rsMemberEvent = nothing

		ERRORLOG("MemberEvent3: "&MemberEvent3&" "&MemberEvent3Found&"")


		'--------------------------------------------------------------

		If MemberEvent1Found Then
		
			FreeTicketCount = 0
			SeriesName = "2014 Weekday Season Subscription<BR>Wednesday/Thursday/Friday Shows"
		
		
			'Clear out any other discounts on the order
			'-----------------------------------------
			SQLDiscLine = "SELECT LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat','SubFixedEvent') ORDER BY LineNumber"
			Set rsDiscLine = OBJdbConnection.Execute(SQLDiscLine)

			If Not rsDiscLine.EOF Then
				Do While Not rsDiscLine.EOF
				
					SQLClearDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = 0, DiscountTypeNumber = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsDiscLine("LineNumber")
					Set rsClearDiscount = OBJdbConnection.Execute(SQLClearDiscount)
					
				rsDiscLine.movenext
				Loop
			End If

			rsDiscLine.Close
			Set rsDiscLine = Nothing
			
		
			'Discount Wednesday, Thursday, Friday performances
			ERRORLOG("Process MemberEvent1")
			
			ProductionList = Split(ActCodeList,",")

			
			'Allowed Tickets
			'--------------------------------------------------------
			'Determine if patron has purchased the season ticket in current order
			SQLEvent1Current = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber  INNER JOIN OrderHeader (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE EventCode = " & CleanNumeric(MemberEvent1) & " AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))& " "
			Set rsEvent1Current = OBJdbConnection.Execute(SQLEvent1Current)
				If Not rsEvent1Current.EOF Then 'it is in order
					Event1CurrentCount = rsEvent1Current("TicketCount")
				End If
			rsEvent1Current.Close
			Set rsEvent1Current = nothing


			'Determine if patron has purchased the season ticket in the past
			SQLEvent1Before = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CustomerNbr & " AND Seat.EventCode = " & CleanNumeric(MemberEvent1) & " AND OrderHeader.StatusCode = 'S'  AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber")) & "" 
			Set rsEvent1Before = OBJdbConnection.Execute(SQLEvent1Before)
				If Not rsEvent1Before.EOF Then
					Event1BeforeCount = rsEvent1Before("TicketCount")
				End If
			rsEvent1Before.Close
			Set rsEvent1Before = nothing
			
			
			AllowedCount1 = (Event1CurrentCount + Event1BeforeCount) * SeriesCount1
						
			ERRORLOG("AllowedCount1 " & AllowedCount1 &"")


			'Cycle through each production in the season
			'--------------------------------------------
			
			For ActCd = lbound(ProductionList) to ubound(ProductionList)

				'Determine the number of discounts already applied.
				'Deduct number of applied from number of allowed.
				'Process any remaining allowed discounts 
				
				'----------------------------------------
				
				SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE CustomerNumber = " & CustomerNbr & " AND ActCode = " & CleanNumeric(ProductionList(ActCd)) & " AND (DATEPART(WEEKDAY, Event.Eventdate)) IN (4,5,6) AND OrderLine.StatusCode = 'S' AND OrderLine.DiscountTypeNumber = " & MemberDiscountNumber & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber"))
				Set rsApplied = OBJdbConnection.Execute(SQLApplied)

					AppliedCount1 = rsApplied("TicketCount")
					
					ERRORLOG("AppliedCount1 " & AppliedCount1 &"")
					
					AvailableCount1 = (AllowedCount1 - AppliedCount1)
					
					ERRORLOG("AvailableCount1 " & AvailableCount1 &"")
					
					If AvailableCount1 > 0 Then 
							
						SQLLineNo = "SELECT TOP(" & AvailableCount1 & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.ActCode = " & ProductionList(ActCd) & " AND (DATEPART(WEEKDAY, Event.Eventdate)) IN (4,5,6) ORDER BY LineNumber DESC"
						Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)

						If Not rsLineNo.EOF Then 

							Do While Not rsLineNo.EOF
							
								SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & DiscountAmount & ", Surcharge = 0, DiscountTypeNumber = " & MemberDiscountNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
								Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
								rsLineNo.movenext
								FreeTicketCount = FreeTicketCount + 1
								ERRORLOG("FreeTicketCount " & FreeTicketCount &"")
								
							Loop
							
						End If

						rsLineNo.Close
						Set rsLineNo = Nothing
							
					End If
						
				rsApplied.Close
				Set rsApplied = nothing     
					
				
			Next
			
			If FreeTicketCount >= 1  Then
				Call WarningPage(SeriesName,FreeTicketCount)
				End Sub
			End If

		End If
	
	'--------------------------------------------------------------
	
		'Weekend Subscription:  Saturday, Sunday performances
	
		If MemberEvent2Found Then
		
			FreeTicketCount = 0
			SeriesName = "Weekend Subscription<BR>Saturday, Sunday performances"
		
			'Clear out any other discounts on the order
			'-----------------------------------------
			SQLDiscLine = "SELECT LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat','SubFixedEvent') ORDER BY LineNumber"
			Set rsDiscLine = OBJdbConnection.Execute(SQLDiscLine)

			If Not rsDiscLine.EOF Then
				Do While Not rsDiscLine.EOF
				
					SQLClearDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = 0, DiscountTypeNumber = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsDiscLine("LineNumber")
					Set rsClearDiscount = OBJdbConnection.Execute(SQLClearDiscount)
					
				rsDiscLine.movenext
				Loop
			End If

			rsDiscLine.Close
			Set rsDiscLine = Nothing
			
		
			ERRORLOG("Process MemberEvent2")
			
			ProductionList = Split(ActCodeList,",")

			'Determine the number of allowed tickets
			'--------------------------------------------------------
			SQLFreeTickets = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (OrderHeader.CustomerNumber = " & CustomerNbr & " OR OrderHeader.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & ") AND Seat.EventCode = " & MemberEvent2
			Set rsFreeTickets = OBJdbConnection.Execute(SQLFreeTickets)
				If Not rsFreeTickets.EOF Then
					AllowedCount2 = rsFreeTickets("TicketCount") * SeriesCount2
				End If
			rsFreeTickets.Close
			Set rsFreeTickets = nothing
			
			ERRORLOG("AllowedCount2 " & AllowedCount2 &"")


			'Cycle through each production in the season
			'--------------------------------------------
			For ActCd = lbound(ProductionList) to ubound(ProductionList)

				'Determine the number of discounts already applied.
				'Deduct number of applied from number of allowed.
				'Process any remaining allowed discounts 
				'-----------------------------------------------------------------
				SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE CustomerNumber = " & CustomerNbr & " AND ActCode = " & CleanNumeric(ProductionList(ActCd)) & " AND (DATEPART(WEEKDAY, Event.Eventdate)) IN (1,7) AND OrderLine.StatusCode = 'S' AND OrderLine.DiscountTypeNumber = " & MemberDiscountNumber & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber"))
				Set rsApplied = OBJdbConnection.Execute(SQLApplied)

					AppliedCount2 = rsApplied("TicketCount")
					
					ERRORLOG("AppliedCount2 " & AppliedCount2 &"")
					
					AvailableCount2 = (AllowedCount2 - AppliedCount2)
					
					ERRORLOG("AvailableCount2 " & AvailableCount2 &"")
					
					If AvailableCount2 > 0 Then 
							
						SQLLineNo = "SELECT TOP(" & AvailableCount2 & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.ActCode = " & ProductionList(ActCd) & " AND (DATEPART(WEEKDAY, Event.Eventdate)) IN (1,7) ORDER BY LineNumber DESC"
						Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)

						If Not rsLineNo.EOF Then 
						
							
											
							Do While Not rsLineNo.EOF
							
								SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & DiscountAmount & ", Surcharge = 0, DiscountTypeNumber = " & MemberDiscountNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
								Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
								rsLineNo.movenext
								FreeTicketCount = FreeTicketCount + 1
								ERRORLOG("FreeTicketCount " & FreeTicketCount &"")
								
							Loop
							
						End If

						rsLineNo.Close
						Set rsLineNo = Nothing
							
					End If
						
				rsApplied.Close
				Set rsApplied = nothing     
					
				
			Next
			
			If FreeTicketCount >= 1  Then
				Call WarningPage(SeriesName,FreeTicketCount)
			End If


		End If
	
		'---------------------------------------------------------------
	
		If MemberEvent3Found Then
		
			SeriesName = "Flex Pass Holder"
			FreeTicketCount = 0
		
			'Clear out any other discounts on the order
			'-----------------------------------------
			SQLDiscLine = "SELECT LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat','SubFixedEvent') ORDER BY LineNumber"
			Set rsDiscLine = OBJdbConnection.Execute(SQLDiscLine)

			If Not rsDiscLine.EOF Then
				Do While Not rsDiscLine.EOF
				
					SQLClearDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = 0, DiscountTypeNumber = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsDiscLine("LineNumber")
					Set rsClearDiscount = OBJdbConnection.Execute(SQLClearDiscount)
					
				rsDiscLine.movenext
				Loop
			End If

			rsDiscLine.Close
			Set rsDiscLine = Nothing
		
			ERRORLOG("Process MemberEvent3")
			
			
			
			'Determine the number of allowed tickets
			'--------------------------------------------------------
			SQLFreeTickets = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (OrderHeader.CustomerNumber = " & CustomerNbr & " OR OrderHeader.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & ") AND Seat.EventCode = " & MemberEvent3
			Set rsFreeTickets = OBJdbConnection.Execute(SQLFreeTickets)
				If Not rsFreeTickets.EOF Then
					AllowedCount3 = rsFreeTickets("TicketCount") * SeriesCount3
				End If
			rsFreeTickets.Close
			Set rsFreeTickets = nothing
			
			ERRORLOG("AllowedCount3 " & AllowedCount3 &"")
			
			
			'Determine the number of applied tickets
			'--------------------------------------------------------
			SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.StatusCode = 'S' AND OrderLine.DiscountTypeNumber = " & MemberDiscountNumber & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber"))
			Set rsApplied = OBJdbConnection.Execute(SQLApplied)
				If Not rsApplied.EOF Then
					AppliedCount3 = rsApplied("TicketCount")
				End If
			rsApplied.Close
			Set rsApplied = nothing
			
			ERRORLOG("AppliedCount3 " & AppliedCount3 &"")
			
			AvailableCount3 = (AllowedCount3 - AppliedCount3)
			
			ERRORLOG("AvailableCount3 " & AvailableCount3 &"")
			
			If AvailableCount3 > 0 Then 
    					
					SQLLineNo = "SELECT TOP(" & AvailableCount3 & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND ActCode IN (" & ActCodeList & ") AND OrderLine.DiscountTypeNumber <> " & MemberDiscountNumber & " ORDER BY LineNumber DESC"
					Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
					
						If Not rsLineNo.EOF Then

							Do While Not rsLineNo.EOF            
								SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & DiscountAmount & ", Surcharge = 0, DiscountTypeNumber = " & MemberDiscountNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
								Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
								rsLineNo.movenext
								FreeTicketCount = FreeTicketCount + 1
								ERRORLOG("FreeTicketCount " & FreeTicketCount &"")
							Loop
							
						End If
					
					rsLineNo.Close
					Set rsLineNo = Nothing 

			End If
			
			
			If FreeTicketCount >= 1  Then
				Call WarningPage(SeriesName,FreeTicketCount)
			End If
			

		End If

End Sub


'------------------------------------------

Sub WarningPage(SeriesName,FreeTicketCount)

	Select Case FreeTicketCount
		Case  1
			S1 = ""
		Case Else
			S1 = "s"
	 End Select
 
%>
<head>

	<title>Support</title>
	
	<!-- Force IE to turn off past version compatibility mode and use current version mode -->
	<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
	
	<!-- Get the width of the users display-->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	
	<!-- Text encoded as UTF-8 -->
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

	<!-- icons -->
	<link href="https://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.min.css" rel="stylesheet">
	
	<!-- bootstrap -->
	<link href="https://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet" id="default">
  	
	<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries in IE8, IE9 -->
	<!--[if lt IE 9]>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.6.2/html5shiv.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/respond.js/1.3.0/respond.js"></script>
	<![endif]-->
	
</head>

	<body>
	
	<section id="wrapper" class="container main" style="margin-top:50px;">

	<!--#INCLUDE virtual="TopNavInclude.asp"-->
	
	<form action="<%= SurveyFileName %>" NAME="Survey" >
	<input type="hidden" name="SurveyNumber" value="<%= SurveyNumber %>">
	<input type="hidden" name="FormName" value="Continue">
		<div class="row"> 	
			<div class="col-md-6 col-md-offset-3">	
			
				<form class="form-horizontal" action="?" method="post">
				
					<div class="panel panel-default">
							
						<div class="panel-heading">
							<span class="panel-label"><h4><B>CHESTER THEATRE BOX OFFICE</B></h4></span>
						</div>
						   
						<div class="panel-body">
							<h4><%=SeriesName%></h4>
							This order has qualified for a season subscription<BR> 
							discount on <%=FreeTicketCount%> ticket<%=S1%>.
							<BR>
						</div>
						
						<div class="panel-footer clearfix">
							<div class="pull-right">
								<button class="btn btn-default" TYPE="submit">Continue</button>
							</div>
						</div>
						
					</div>
					
				</form>
			
			</div>
		</div>
	</form>

	<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%

End Sub ' Warning Page

'------------------------------------------

	Sub Continue
					
		Session("SurveyComplete") = Session("OrderNumber")
		If Session("UserNumber") = "" Then
			Response.Redirect("/Ship.asp")
		Else
			Response.Redirect("/Management/AdvanceShip.asp")
		End If		

	End Sub 'Continue

'------------------------------------------


%>