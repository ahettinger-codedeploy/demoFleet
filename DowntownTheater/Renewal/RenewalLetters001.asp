<%
'CHANGE LOG

'SSR 06/26/16 - Updated Event Selection Qty for Tulip Festival

%>

<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include virtual="/include/managementinclude.asp"-->

<%

'-------------------------------------------------

Page = "Management"

If Session("UserNumber") = "" Then 
	OBJdbConnection.Close
	Set OBJdbConnection = nothing
	Response.Redirect("Default.asp")
End If

If Session("OrganizationNumber") = "" Then 
	OBJdbConnection.Close
	Set OBJdbConnection = nothing
	Response.Redirect("Default.asp")
End If

SQLUsers = "SELECT UserType FROM Users (NOLOCK) WHERE UserNumber = " & Session("UserNumber")
Set rsUsers = OBJdbConnection.Execute(SQLUsers)
	If Not IsNull(rsUsers("UserType")) Then
		UserType = rsUsers("UserType")
	Else
		UserType = ""
	End If
rsUsers.Close
Set rsUsers = nothing	

'-------------------------------------------------

'Variables

DIM ScriptName
DIM MaxSeats

DIM strGroupUser

DIM EventStart
DIM EventEnd


DIM strPageTitle

DIM tabName(4)
DIM tabStatus(4)
DIM tabPage(4)

DIM SQLWhereEvents

DIM NavMenu

'-------------------------------------------------

ScriptName = fnScriptName()
MaxSeats = 500

EventStart = FormatDateTime(Now(), vbShortDate)
EventEnd = Now() - .25

'-------------------------------------------------

'Group Event Data

DIM dataFileName
DIM dataFolder

DIM GroupEventList
DIM formData

dataFileName = "GroupEventList.txt"
dataFolder = "EventSelection"

'Load the group event data
If GroupEventList = "" Then

End If

'Update the group event data
If Request("FormName") = "EventSelection" Then
	If Request.Form("EventCode") <> "" Then
		formData = Request.Form("EventCode")
            Call subWriteFile(formData)
	End If
End If

'-------------------------------------------------

'Navigation Menu

'Letters Tab

            tabPage(1) = "Letters"
            tabName(1) = "Print Letters"

'Emails Tab

	If SecurityCheck("SubscriptionRenewalLetters") = True Then 
		tabPage(2) = "Emails"
		tabName(2) = "Send Emails"
	End If

'Reminders Tab

	If SecurityCheck("SubscriptionRenewalLetters") = True Then 
		tabPage(3) = "Reminders"
		tabName(3) = "Send Reminder"
	End If

'Admin Tab

	If SecurityCheck("SubscriptionRenewalLetters") = True Then 
		tabPage(4) = "Options"
		tabName(4) = ""
	End If

'-------------------------------------------------

'Determine the requested page view
'Verify permission to display page

If Request.QueryString("PageView") <> "" Then
      PageView = Request.QueryString("PageView")
Else
      PageView = "Letters"
End If



If PageView = tabPage(1) Then
      'Letters
	If SecurityCheck("TulipTimeGroupSales") = True Then 

		strPageTitle	=  tabName(1)
		tabStatus(1) 	= "active"
            SQLWhereEvents 	= " AND OrderLine.StatusCode = 'R'"
            
	End If
	
ElseIf PageView = tabPage(2) Then
      'Emails
	If SecurityCheck("TulipTimeGroupSales") = True Then 

		strPageTitle	=  tabName(2)
		tabStatus(2) 	= "active"
		SQLWhereEvents 	= " AND OrderLine.StatusCode = 'R' AND Customer.EMailAddress IS NOT NULL AND Customer.EMailAddress <> ''"

	End If
      
ElseIf PageView = tabPage(3) Then
      'Reminders
	If SecurityCheck("TulipTimeGroupSales") = True Then 

		strPageTitle	=  tabName(3)
		tabStatus(3) 	= "active"
		SQLWhereEvents 	= " AND OrderLine.StatusCode = 'S' AND Customer.EMailAddress IS NOT NULL AND Customer.EMailAddress <> ''"

	End If

ElseIf PageView = tabPage(4) Then
      'Options
	If SecurityCheck("TulipTimeGroupSales") = True Then 

		strPageTitle	=  tabName(4)
		tabStatus(4) 	= "active"
		
	End If

End if

'-------------------------------------------------

Call EventMenu

'-------------------------------------------------

Sub EventMenu

%>

<html>
<head>
<title>Tix - <%=strPageTitle%> </title>

<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Roboto:400,100,300,500,700,900" >

<link rel="stylesheet" type="text/css" href="https://oss.maxcdn.com/icheck/1.0.2/skins/all.min.css" >

<link type="text/css" rel="stylesheet" href="css/basic.css">

<link type="text/css" rel="stylesheet" href="css/panel.css">	

<link type="text/css" rel="stylesheet" href="css/table.css">

<link type="text/css" rel="stylesheet" href="css/switch.css">

<link type="text/css" rel="stylesheet" href="css/buttons.css">

<link type="text/css" rel="stylesheet" href="css/navbar.css">

<style>
#content-inner-wrapper
{
width: 990px !important;
max-width: 990px !important;
}

#panel-options-outer
{
width: 990px !important;
max-width: 990px !important;
margin-left: 20px;
}

#panel-main
{
max-width:990px;
padding:10px;
}

table#eventlist.table thead tr th:last-child,
table#eventlist.table tbody tr td:last-child
{
text-align: center;
}

div.page-content h2.pageHeader 
{
margin:0px;
padding-bottom: 20px;
padding-top: 20px;
border-bottom:1px solid red;
}

#panel-options-outer 
{
margin-left: 20px;
max-width: 990px !important;
width: 990px !important;
}

.inset-shadow-bar 
{ 

}




</style>

</head>

<body>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->
							
<%

'Build Navigation Menu
Call NavBar

'Build Options Panel
Call PanelOptions

If request("FormName") = "" Then
      Call EventListing
End If

If request("FormName") = "PrintMenu" Then
      Call EventProcess
End If


 

%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

	<SCRIPT src="https://cdn.jsdelivr.net/icheck/1.0.2/icheck.min.js" type="text/javascript" language="javascript" ></SCRIPT> 
	
	<SCRIPT type="text/javascript" language="javascript">
	
		$(function() 
		{
		
			// iCHECK - RADIO BUTTON
		
			// set radio button color
			$("input[type=radio]").iCheck(
			{
				radioClass: 'iradio_square-green',
				increaseArea: '30%'
			});
			
			// activate hightlight for pre-selected radiobuttons
			$("input[type=radio]:checked").each(function() 
			{
				$(this).closest("tr").addClass("active");
			});
			
			// toggle hightlight when radiobutton changes state
			$("input[type=radio]").on('ifToggled', function(event)
			{
				$(this).closest("tr").toggleClass("active")
			});
			
			// iCHECK - CHECKBOX
			
			// set checkbox color
			// ignore toggle switch checkboxes
			$("input[type=checkbox]:not(.switch-input)").iCheck(
			{
				checkboxClass: 'icheckbox_square-green',
				increaseArea: '30%'
			});

			// activate hightlight for pre-selected checkboxes
			$("input[type=checkbox]:checked").each(function() 
			{
				$(this).closest("tr").addClass("active");
			});

			// toggle hightlight when checkbox changes state
			$("input[type=checkbox]").on('ifToggled', function(event)
			{
				$(this).closest("tr").toggleClass("active")
			});
		 
		}); 
		
				(function($) 
		{
			$.fn.toggleDisabled = function() 
			{
				return this.each(function() 
				{
					var $this = $(this);
					if ($this.attr('disabled')) $this.removeAttr('disabled');		
					
					else $this.attr('disabled', 'disabled');
				});
			};
		})(jQuery);

		$(function() 
		{
			//toggle switch is disabled by default
			$('#toggle-switch').prop('checked', false);
			
			//toggle controls are all disabled by default
			$('.toggle-control').prop('disabled', true);

			//toggle control submit is enabled by default
			$('.toggle-submit').prop('disabled', false);
			
			//enable toggle controls when toggle switch selected
			$('#toggle-switch').change(function() 
			{
				$('.toggle-control').toggleDisabled();       
			});
		});


		jQuery.fn.blindToggle = function(speed, easing, callback) 
		{
		var h = (this.height() + parseInt(this.css('paddingTop')) + parseInt(this.css('paddingBottom')) + 9);
		return this.animate({marginTop: parseInt(this.css('marginTop')) < 0 ? 0 : -h}, speed, easing, callback);  
		};
 
		jQuery.fn.slideFadeToggle = function(speed, easing, callback) 
		{
		return this.animate({opacity: 'toggle', height: 'toggle'}, speed, easing, callback);  
		};
 
		$(function() 
		{
			$('#btnOptions').click(function() 
			{
				$('#panel-options-inner').blindToggle(1000, 'easeInOutQuart');
			});    
		});

	</SCRIPT>


</body>

</html>

<%

End Sub

'-------------------------------------------------

Sub NavBar

response.write "<div id=""navbar"">" & vbCrLf

response.write "<ul class=""nav nav-tabs pull-left"">" & vbCrLf

For i = 1 to 3
	If tabPage(i) <> "" Then
		response.write "<li class=" & tabStatus(i) & ">" & vbCrLf
		response.write "<a href=""" & Server.URLEncode(fnScriptName) & "?PageView=" & Server.URLEncode(tabPage(i)) & """>" & tabName(i) & "</a>" & vbCrLf
		response.write "</li>" & vbCrLf
	End If
Next

response.write "</ul>" & vbCrLf

response.write "<div class=""nav-btn pull-right"">" & vbCrLf
response.write "<BUTTON class=""btn btn-large btn-default"" id=""btnOptions"" type=""button"" data-placement=""top"" title=""Options"">" & vbCrLf
response.write "<span class=""fa fa-cog""></span>" & vbCrLf
response.write "<SPAN class=""icon-label""></SPAN>" & vbCrLf
response.write "</BUTTON>" & vbCrLf
response.write "</div>" & vbCrLf
	
response.write "</div>" & vbCrLf

response.write "<h2 class=""pageHeader inset-shadow-bar"">" & strPageTitle & "</h2>"

'Build Event Listing

Select Case strPageTitle
	Case tabPage(4)

	Case Else

		If strPageTitle <> tabPage(2) Then

		End If
End Select


End Sub

'-------------------------------------------------

Sub PanelOptions

%>

<!-- panel edit -->  
<DIV class="panel-body" id="panel-options-outer">
<DIV class="container-fluid" id="panel-options-inner"> 
                               
            <ul class="nav nav-pills nav-stacked col-sm-3" style="margin-top: 15px;" style="outline:1px solid red; padding: 15px;">
                  <li  class="active"><a href="#tabA" data-toggle="tab">Printing Options</a></li>
            </ul>

            <div class="tab-content col-sm-9">
                        
                  <div class="tab-pane  active" id="tabA" style="border:1px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
                        
                        <h4>Printing Options!</h4>
                        
                        <form class="form-horizontal" role="form">
                        
                              <fieldset>

                                    <div class="form-group">

                                          <label class="col-sm-3 control-label">Template</label>
                                          
                                          <div class="col-lg-7">
                                                <select class="form-control">
                                                      <option>Template</option>
                                                      <option>Template</option>
                                                      <option>Template</option>
                                                      <option>Template</option>
                                                </select>	
                                          </div>
       
                                    </div>


                              </fieldset>

                        </form>
                        
                  </div>
                  
                  <div class="tab-pane" id="tabB" style="border:1px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
                        <h3>Option B</h3>	
                  </div>
                  
                  <div class="tab-pane" id="tabC" style="border:1px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
                        <h3>Option C</h3>
                  </div>
                  
                  <div class="tab-pane" id="tabD" style="border:1px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
                        <h3>Option D</h3>
                  </div>
                  
            </div>
            
</div>
</div>
               
<%     
     
End Sub

'------------------------------------

Sub EventListing

'Build the event list page for ticket sales

Response.Write "<DIV class=""panel-body"" id=""panel-main"">" & vbCrLf
				
SQLEvents = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue, COUNT(distinct OrderHeader.OrderNumber) AS OrderCount  FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK)  ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK)  ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Shipping (NOLOCK)  ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN Act (NOLOCK)  ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK)  ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber  WHERE Event.EventCode IN ( SELECT Event.EventCode  FROM Event(NOLOCK) INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber  WHERE Organization.OrganizationNumber = " & Session("OrganizationNumber") & " AND EventDate > GETDATE() ) AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') " & SQLWhereEvents & " GROUP BY Event.EventCode, Act.Act, Event.EventDate, Venue.Venue"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

If Not rsEvents.EOF Then

            Response.Write "<FORM ACTION=""" & fnScriptName() & """ METHOD=""post"">" & vbCrLf
            Response.Write "<INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""PrintMenu"">" & vbCrLf

            Response.Write "<FONT>" & vbCrLf

            Response.Write "<table class=""table"" id=""eventlist"">" & vbCrLf
            Response.Write "<thead>" & vbCrLf
            Response.Write "<tr>" & vbCrLf
            Response.Write "<th>Print</th>" & vbCrLf
            Response.Write "<th>Event<BR>Code</th>" & vbCrLf
            Response.Write "<th>Date<BR>Time</th>" & vbCrLf
            Response.Write "<th>Event<BR>Name</th>" & vbCrLf
            Response.Write "<th>Venue<BR>Location</th>" & vbCrLf
            Response.Write "<th>Order<BR>Count</th>" & vbCrLf
            Response.Write "</tr>" & vbCrLf
            Response.Write "</thead>" & vbCrLf
            Response.Write "<tbody>" & vbCrLf

		Do Until rsEvents.EOF
		
                  'Determine if event has date or time suppressed

                  'Event List

                  Response.Write "<tr>" & vbCrLf
                  Response.Write "<td><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=" & rsEvents("EventCode") & "></td>" & vbCrLf
                  Response.Write "<td>" & rsEvents("EventCode") & "</td>" & vbCrLf
                  Response.Write "<td>" & rsEvents("EventDate") & "</td>" & vbCrLf
                  Response.Write "<td>" & rsEvents("Act") & "</td>" & vbCrLf
                  Response.Write "<td>" & rsEvents("Venue") & "</td>" & vbCrLf
                  Response.Write "<td>" & rsEvents("OrderCount") & "</td>" & vbCrLf
                  Response.Write "</tr>" & vbCrLf

                  rsEvents.MoveNext
		Loop
 
		Response.Write "</TBODY>" & vbCrLf
		Response.Write "</TABLE>" & vbCrLf
		Response.Write "</FONT>" & vbCrLf
		Response.Write "<DIV STYLE=""width:95%; text-align:left;"">" & vbCrLf
		Response.Write "<INPUT CLASS=""btn btn-ghost btn-default toggle-submit"" TYPE=""submit"" VALUE=""Print"">" & vbCrLf
		Response.Write "</DIV>" & vbCrLf
		Response.Write "</FORM>" & vbCrLf

Else


		Response.Write "<FONT>" & vbCrLf
		Response.Write "<TABLE CELLSPACING=0 CELLPADDING=1 WIDTH=95% BORDER=0>" & vbCrLf
		Response.Write "<TR>" & vbCrLf
		Response.Write "<TD>" & vbCrLf

		Response.Write "<div style=""min-height: 300px; text-align: center; font-family: Verdana,Arial,Helvetica, sans-serif; font-size: small;  color: black;"">There are no events to list at this time.</div>" & vbCrLf

		Response.Write "</TD>" & vbCrLf
		Response.Write "</TR>" & vbCrLf
		Response.Write "</TABLE>" & vbCrLf
		Response.Write "</FONT>" & vbCrLf


    
End If


Response.Write "</DIV>" & vbCrLf

rsEvents.Close
Set rsEvents = nothing

End Sub
				
'-------------------------------------------------

Sub EventProcess


For Each Item In Request("EventCode") 'Loop for each Event requested
	EventNumber = EventNumber + 1
	If SQLWhere = "" Then 
		SQLWhere = " WHERE Event.EventCode IN (" & Clean(Request("EventCode"))
	Else
		SQLWhere = SQLWhere & ", " & Clean(Request("EventCode"))
	End If
Next


SQLOrderLine = "SELECT OrderHeader.OrderTypeNumber, OrderHeader.OrderSurcharge, OrderHeader.ShipFee, OrderHeader.Total, OrderLine.OrderNumber, OrderLine.LineNumber, OrderLine.ItemNumber, OrderLine.Price, OrderLine.Surcharge, OrderLine.Discount, OrderLine.ShipCode, Event.EventCode, Event.EventDate, Event.Map, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, PostalCode, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress, Shipping.ShipType, Act.Act, Venue.Venue, SeatType.SeatType, Seat.Row, Seat.Seat, Seat.SectionCode, Section.Section FROM OrderLine INNER JOIN OrderHeader ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event ON Seat.EventCode = Event.EventCode INNER JOIN Section ON Seat.SectionCode = Section.SectionCode AND Event.EventCode = Section.EventCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN SeatType ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode "
SQLOrderLine = SQLOrderLine & SQLWhere & ") AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Customer.EMailAddress IS NOT NULL AND Customer.EMailAddress <> '' ORDER BY OrderLine.OrderNumber, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode, Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)

Do Until rsOrderLine.EOF

      If rsOrderLine("OrderNumber") <> LastOrderNumber Then 

            ReturnAddress = ""
  
            ReturnAddress = ReturnAddress & rsOrderLine("OrderNumber") & "<BR><BR>"
  
            LastOrderNumber = rsOrderLine("OrderNumber")

            EMailMessage = EMailMessage &  ReturnAddress
            
            Response.write  EMailMessage
            
      End If
                  
rsOrderLine.MoveNext	
Loop	
	
rsOrderLine.Close
Set rsOrderLine = nothing   

End Sub

'-------------------------------------------------

Sub subReadFile()

	DIM objFSO
	DIM objFile

	DIM strFilePath
	DIM strFolderPath
	
	strFolderPath = fnFolderPath
	strFilePath = strFolderPath & dataFileName
      
      GroupEventList = ""
		
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set objFile = objFSO.OpenTextFile(strFilePath)
		
	If Not objFile.AtEndOfStream Then 		
		GroupEventList = GroupEventList & objFile.ReadAll
	Else
		GroupEventList = "000000"
	End If
		
	objFile.Close

	Set objFile = nothing
	Set objFSO = nothing
				
End Sub

'-------------------------------------------------

Sub subWriteFile(formData)

	DIM objFSO
	DIM objFile
	
	DIM strFilePath
	DIM strFolderPath
	
	strFolderPath = fnFolderPath
	strFilePath = strFolderPath & dataFileName
		
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set objFile = objFSO.CreateTextFile(strFilePath,true)
	
	objFile.Write(formData)
	
	objFile.Close

	Set objFile = nothing
	Set objFSO = nothing
		
End Sub

'-------------------------------------------------

Public Function fnFolderPath

	'This function looks for the name of the client folder in the database
	'and builds the path for that folder
	
	DIM StrResults

	RootPath =  Server.MapPath("/") & "\"

	DataFolder = "\EventSelection\"

	SQLSearch = "SELECT OptionValue FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & Session("OrganizationNumber") & " AND OptionName = 'ClientFolder'"
	set rsSearch = OBJdbConnection.Execute(SQLSearch)
		If Not rsSearch.EOF Then
			ClientFolder = "Clients\" & rsSearch("OptionValue")
		End If
	rsSearch.Close
	Set rsSearch = nothing

	strResults =  RootPath & ClientFolder & DataFolder

	fnFolderPath = StrResults

End Function

'-------------------------------------------------

Public Function fnScriptName()

	DIM strPath
	DIM arrPath
	DIM strResults

	strPath = Request.ServerVariables("SCRIPT_NAME")
	arrPath = Split(strPath, "/")
	strResults = arrPath(UBound(arrPath,1))
	
	fnScriptName = strResults
  
End Function 

'-------------------------------------------------

Public Function fnInArray(item, strList)

	arrItem = split(strList,",")

	fnInArray = False

	For i=0 To Ubound(arrItem)
		
		If Int(arrItem(i)) = Int(item) Then
		  fnInArray = True
		  Exit Function      
		End If
	 
	Next
  
End Function

'-------------------------------------------------

%>