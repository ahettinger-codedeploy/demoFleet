
<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'----------------------------------------------

'Set the flag to include the TooltipInclude.html file
TooltipIncludeFlag = "Y"
Page = "Survey"
Session("Timeout") = 120
Server.ScriptTimeout = 60 * 20 '20 Minutes

'----------------------------------------------

'Survey Parameters

AppliedFlag = "N"
SurveyFileName ="CampaignTracker.asp"
SurveyNumber = 1547

DiscountTypeNumber = 97295
DiscountAmount = .50 '50% Discount
RequiredSeatCode = 2013

TicketCount  = 0

CampaignNumber = ""
RequiredCampaignNumber = 1334
CampaignNumberFound = FALSE

'----------------------------------------------

'Initial Valiation
'Check to see if Order Number exists.  
'If not, redirect to Home Page.

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


'-----------------------------------------------
	'Program Flow

	ErrorLog("Survey Start")
	
	Select Case Clean(Request("FormName"))
		Case "Continue"
			Call Continue
		Case Else
			Call SurveyForm
	 End Select

	OBJdbConnection.Close
	Set OBJdbConnection = nothing

'-----------------------------------------------

Sub SurveyForm

	ErrorLog("Check Session Variables")
	
	'Check Session Variables
	For Each Item In Session.Contents
		If Session.Contents(Item) <> "" Then
			ItemValue = Session.Contents(Item)
			ErrorLog " " & Item & " = " & ItemValue & " "
			Execute Item & " = """ & ItemValue & """"
		End If
	Next
	
	If CampaignNumber = "1334" Then
		CampaignNumberFound = TRUE
	End If
	
	If CampaignNumberFound  Then
	
		ErrorLog("CampaignNumber Found")

		'Apply the discount for this membership level
		SQLLineNo = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND SeatTypeCode = " & RequiredSeatCode & " ORDER BY OrderLine.Price DESC"
		Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)

		If Not rsLineNo.EOF Then                
			Do While Not rsLineNo.EOF
				SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & DiscountAmount & ", Surcharge = 0, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
				Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
				rsLineNo.movenext
				TicketCount = TicketCount + 1
			Loop
		End If
		
		ApplyDiscount = Y

		rsLineNo.Close
		Set rsLineNo = Nothing 
		
		Call WarningPage

	Else
	
		ErrorLog("CampaignNumber Not Found")
	
		Call WarningPage
		
	End If


End Sub


Sub WarningPage

SQLCampDesc = "SELECT Description FROM CampaignHeader (NOLOCK) WHERE CampaignNumber = " & RequiredCampaignNumber & ""
Set rsCampDesc = OBJdbConnection.Execute(SQLCampDesc)
	CampDesc = rsCampDesc("Description")
rsCampDesc.Close
Set rsCampDesc = nothing

If TicketCount > 0 Then

	panelStatus = "panel-success"
	campStatus = "SUCCESS"

	Select Case TicketCount
		Case  1
			S1 = ""
		Case Else
			S1 = "s"
	 End Select
	 
Else

	panelStatus = "panel-danger"
	campStatus = "SORRY"


End If
 
%>

<!DOCTYPE html>

<html lang="en">

	<head>

		<title>Survey</title>
		
		<!-- Force IE to turn off past version compatibility mode and use current version mode -->
		<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
		
		<!-- Get the width of the users display-->
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		
		<!-- Text encoded as UTF-8 -->
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

		<!-- icons -->
		<link href="https://netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">
		
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

		<div class="row"> 	
			<div class="col-md-6 col-md-offset-3">	
			
				<form class="form-horizontal" action="?" method="post">
					<input type="hidden" name="SurveyNumber" value="<%= SurveyNumber %>">
					<input type="hidden" name="FormName" value="Continue">

															
								<div class="panel <%=panelStatus%>">
								
									<div class="panel-heading">
										<span class="panel-label"><h4><B>CAMPAIGN TRACKER</B></h4></span>
									</div>

									<div class="panel-body">
											<h4><%=campStatus%></h4>
										<p >	
											<dl class="dl-horizontal" style="text-align:left; width: 70%">
												<dt>Campaign Description:</dt>
												<dd><%=CampDesc%></dd>
												<dt>Campaign Number:</dt>
												<dd><%=CampaignNumber%></dd>
												<dt>Customer Number:</dt>
												<dd><%=CustomerNumber%></dd>
											</dl>
										</p>
											This order has qualified for a discount on <%=TicketCount%> ticket<%=S1%>.
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

'---------------------------

Sub Continue

    Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If
	
End Sub 'Continue

'---------------------------

%>