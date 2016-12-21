<%

'CHANGE LOG

'SSR (9/12/2012) - Added Country Codes, Corrected Category List

'SSR (9/10/2012) - Updated survey for use with 2013 event

'SSR (1/4/2012) UPDATE: Restriction added. Purchase of child tickets requires at least 1 adult ticket

'SSR (11/4/2011) UPDATE: Pre-fill the 2nd page with data (if any already exists - ie re-opened orders)

'SSR (11/2/2011) UPDATE: Include Breakout Sessions on a 2nd page, UPDATE: Validate that all questions on 2nd page answered

'SSR (10/21/2011) UPDATE: Pre-fill the form with data (if any already exists - ie re-opened orders)

'SSR (10/5/2011) UPDATE: Validate that all questions answered

'SSR (9/19/2011) UPDATE: Changed field names from specific to generic to make future changes easier for SSR

'SSR (9/16/2011) Created survey

'TTT 1/15/13 - Added SurveyNumber to OrderLineDetail
%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'===============================================

Page = "Survey"
SurveyNumber = 1350
SurveyName = "Transitions2013.asp"

'===============================================


'Lynn University 
'Transitions 2013 Conference Survey

RequiredEvent = "468118"

AdultList = "1" 'List of Adult Seat Type Codes
ChildList = "" 'List of Child Seat Type Codes

WarningTitle = "SORRY"
WarningMessage = "Purchase of the <b>Student</b> ticket requires<BR>the purchase of at least one <b>Individual</b> ticket"

'===============================================

'Page 1
'-------
'Attendee Informaton
'Patron is required to fill out all answers on this form

FormName1 = "Attendee Information"
FormHeader1 = "Please complete the following information for each attendee"

'Form Questions
NumQuestions = 12

Dim Question(15)
Question(1) = "First Name"
Question(2) = "Last Name"
Question(3) = "Address"
Question(4) = "City"
Question(5) = "State"
Question(6) = "Country"
Question(7) = "Zip Code"
Question(8) = "Email"
Question(9) = "Telephone Number"
Question(10) = "School Name"
Question(11) = "Category"
Question(12) = "Other"
Question(13) = "11:15 a.m. Breakout Sessions"
Question(14) = "1:45 p.m. Breakout Sessions"
Question(15) = "3:00 p.m. Breakout Sessions"

FieldValue_1 = ""
FieldValue_2 = ""
FieldValue_3 = ""
FieldValue_4 = ""
FieldValue_5 = ""
FieldValue_6 = ""
FieldValue_7 = ""
FieldValue_8 = ""
FieldValue_9 = ""
FieldValue_10 = ""

'===============================================

'Page 2
'-------
'Workshop Selection
'Patron is required to select 1 class for each breakout session

FormName2 = "Class Information"
FormHeader2 = "Please select three breakout sessions for each attendee"

DIM SurveyFields(21,2)

'11:15 a.m. Breakout Sessions"
'------------------------------
SurveyFields(1,1) = "Stories of Success: Portraits of Hope and Resilience"
SurveyFields(2,1) = "Strategies to Manage Anxiety and Social Stressors for Individuals with Autism and Related Disabilities" 
SurveyFields(3,1) = "Thoughts of a Neuroscientist as a Father"
SurveyFields(4,1) = "1Financing the options of post-secondary opportunities"
SurveyFields(5,1) = "Visual Social Thinking Techniques: How to Leverage the Visual Thinker’s Strengths"
SurveyFields(6,1) = "Apple® and Accessibility in Education" 
SurveyFields(7,1) = "ADHD Medication Pitfalls and How to Avoid Them"

SurveyFields(1,2) = "Dr. Robert Brooks and Students"
SurveyFields(2,2) = "Ryan Joseph Seidman"
SurveyFields(3,2) = "Dr. Richard Axel"
SurveyFields(4,2) = "Carlo Salerno"
SurveyFields(5,2) = "Dr. Michael McManmon"
SurveyFields(6,2) = "Apple®"
SurveyFields(7,2) = "Laurie Dupar"

'1:45 p.m. Breakout Sessions"
'-----------------------------
SurveyFields(8,1) = "A Dialogue with Dr. Brooks" 
SurveyFields(9,1) = "Transition Planning and Assessment for Individuals with Autism Spectrum Disorder and Related Disabilities: What is it and why we do it" 
SurveyFields(10,1) = "Hope and Inspiration: An Infusion of Practical Advice"
SurveyFields(11,1) = "Burning a Hole in Your Pocket: Managing Money for Students with ADHD" 
SurveyFields(12,1) = "Making Your Kids School Savvy and Successful : Integrating Executive Functioning Skills within the School Environment"
SurveyFields(13,1) = "Reaching All Learners with Challenge Based Learning and Digital Content" 
SurveyFields(14,1) = "Jonathan Mooney on Project Eye-to-Eye"

SurveyFields(8,2) = "Dr. Robert Brooks"
SurveyFields(9,2) = "Sheena Blue"
SurveyFields(10,2) = "Nancy Freebery"
SurveyFields(11,2) = "Stephanie Moulton Sarkis"
SurveyFields(12,2) = "Dr. Cathy Wooley-Brown and Melanie Brockmeier"
SurveyFields(13,2) = "Apple®"
SurveyFields(14,2) = "Jonathan Mooney"

'3:00 p.m. Breakout Sessions"
'-----------------------------
SurveyFields(15,1) = "From Stressed Out to Stress Hardy: Learning to Take Care of Ourselves so We Can Take Care of the Teens in Our Lives"
SurveyFields(16,1) = "Strategies to Manage Anxiety and Social Stressors for Individuals with Autism and Related Disabilities"
SurveyFields(17,1) = "ADHD Medication Pitfalls and How to Avoid Them"
SurveyFields(18,1) = "Financing the options of post-secondary opportunities"
SurveyFields(19,1) = "I’m Ready for College but I can’t find my Backpack: Executive Functioning Strategies for College" 
SurveyFields(20,1) = "Apple® and Accessibility in Education"
SurveyFields(21,1) = "Hope and Inspiration: An Infusion of Practical Advice"

SurveyFields(15,2) = "Dr. Robert Brooks"
SurveyFields(16,2) = "Ryan Joseph Seidman"
SurveyFields(17,2) = "Laurie Dupar"
SurveyFields(18,2) = "Carlo Salerno"
SurveyFields(19,2) = "Dr. Michael McManmon"
SurveyFields(20,2) = "Apple®"
SurveyFields(21,2) = "Nancy Freebery and Ricky Freebery"

'===============================================

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

'===============================================

'CSS Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "#FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "#000000"
    TableDataBGColor = "#E9E9E9"
End If

'LastHex = box color
'FirstHex = background color

If Session("UserNumber")<> "" Then
    NECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomRightCorner16.txt"
Else
    NECorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=565f68&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=565f68&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=ded6c8&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=ded6c8&Src=BottomRightCorner16.txt"
End If

'===============================================

Select Case Clean(Request("FormName"))

    Case "SurveyUpdate"
        Call SurveyUpdate
    Case "EventListUpdate"
        Call EventListUpdate
    Case "Continue"
        Call Continue
    Case Else
        Call SurveyForm
        
End Select

'===============================================

Sub SurveyForm
 
SQLRequiredTicketCount = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & RequiredEvent & " AND OrderLine.SeatTypeCode IN (" & AdultList & ") GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
Set rsRequiredTicketCount = OBJdbConnection.Execute(SQLRequiredTicketCount)    
    If Not rsRequiredTicketCount.EOF Then
        RequiredTicketCount = rsRequiredTicketCount("Count")
    End If	
rsRequiredTicketCount.Close
Set rsRequiredTicketCount = nothing


SQLOfferTicketCount = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & RequiredEvent & " AND OrderLine.SeatTypeCode IN (" & ChildList & ") GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
Set rsOfferTicketCount = OBJdbConnection.Execute(SQLOfferTicketCount)    
    If Not rsOfferTicketCount.EOF Then
        OfferTicketCount = rsOfferTicketCount("Count")
    End If	
rsOfferTicketCount.Close
Set rsOfferTicketCount = nothing

Select Case RequiredTicketCount

    Case 0
        If OfferTicketCount = 0 Then
        Call Continue
        End If
        
        If OfferTicketCount => 1 Then
        Call WarningPage
        End If
        
    Case Else
        Call DisplaySurvey(Message)
 End Select
  

End Sub


'===============================================

Sub WarningPage


If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html>
<head>

<title>TIX.com</title>

<style type="text/css">
    
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
    line-height: 1 em;
}
#rounded-corner
{
	font-size: 11px;
    font-weight: 400;
	text-align: left;
	border-collapse: collapse;
	width: 70%;
	top: 10px;
	line-height: 22px;
	margin-top:  10px;
}
#rounded-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 0px;
    padding-right: 1px;
	font-size: 15px;
	font-weight: 600;
	text-align: center;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner thead th.category-left
{
	background: <%=TableCategoryBGColor%> url('<%=NECorner%>') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('<%=NWCorner%>') right -1px no-repeat;
    text-align: left;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{
    background: <%=TableDataBGColor%> url('<%=SWCorner%>') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('<%=SECorner%>') right bottom no-repeat;
}
#rounded-corner td.data
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	text-align: center;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-right
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
    text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
</style>
</head>

<body>

<!--#INCLUDE virtual="TopNavInclude.asp"-->
<form>
<table id="rounded-corner" summary="surveypage">
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2"><%=WarningTitle%></th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
<tbody>
    <tr>
        <td class="data-right">&nbsp;</td>
        <td class="data" colspan="2"><%=WarningMessage%></td>
        <td class="data-right">&nbsp;</td>
    </tr>
    <tr>
        <td class="footer-left">&nbsp;</td>
        <td class="footer" colspan="2">&nbsp;</td>
        <td class="footer-right">&nbsp;</td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
        <td >&nbsp;</td>
    </tr>
    <tr>
        <td >&nbsp;</td>
        <td align="center" colspan="2">
        <% If Session("UserNumber") = "" Then %>
            <INPUT TYPE="button" VALUE="Shopping Cart" onclick="location.href='/ShoppingCart.asp';" id=1 name=1 STYLE="width: 150px">
        <% Else  %>
            <INPUT TYPE="button" VALUE="Shopping Cart" onclick="location.href='/Management/ShoppingCart.asp';" id=1 name=1  STYLE="width: 150px">
        <% End If %>
        </td>
        <td >&nbsp;</td>
    </tr>
</tbody>
</table>
</form>

<!--#INCLUDE virtual="FooterInclude.asp"-->
</body>
</htmlL>

<%

End Sub 'Warning Page

'==========================================================

Sub DisplaySurvey(Message)   

If DocType <> "" Then
    Response.Write(DocType)
Else
    Response.Write("<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">")
End If

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html>

<head>

<title>="<%= Title %>"</title>

<style type="text/css">  
      
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
    line-height: 1 em;
}
#rounded-corner
{
	font-size: 11px;
    font-weight: 400;
	width: 500px;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 0px;
    padding-right: 1px;
	font-size: 15px;
	font-weight: 600;
	text-align: center;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner thead th.category-left
{
	background: <%=TableCategoryBGColor%> url('<%=NECorner%>') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('<%=NWCorner%>') right -1px no-repeat;
    text-align: left;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{
    background: <%=TableDataBGColor%> url('<%=SWCorner%>') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('<%=SECorner%>') right bottom no-repeat;
}
#rounded-corner td.data
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	text-align: center;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-left: 0px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-right
{
	padding-left: 0px;
	padding-right: 0px;
	padding-top: 10px;
	padding-bottom: 10px;
    text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
</style>

<script type="text/javascript">
function swap(num)
{
 if(document.getElementById('TitleSelect'+num).value == 'Other'){document.getElementById('Title1'+num).style.display = 'block'; document.getElementById('Title2'+num).style.display = 'block'; }
 else {document.getElementById('Title1'+num).style.display = 'none'; document.getElementById('Title2'+num).style.display = 'none';}
}
</script>

<script type="text/javascript">
function OtherCheck(num) {
    if(document.getElementById('TitleSelect'+num).value == 'Other') {
        document.getElementById('Title2'+num).value = ""
    } else {
        document.getElementById('Title2'+num).value = "N/A"
    }
}
</script>


</head>

<% If Message = "" Then %>
    <body>
<% Else %>
	<body onLoad="alert('<%= Message %>');" <%= BodyParameters %>>
<% End If %>


<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" name="Survey" method="post" onsubmit="return validateForm();">
<input type="hidden" name="FormName" value="SurveyUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<br />
<table id="tix-table" summary="surveypage" width="600" cellpadding="10" cellspacing="0" border="0">
<tbody>
    <tr>
        <td align="left">
	        <FONT FACE="<%= FontFace %>" SIZE="4">
            <b><%= FormName1 %></b></FONT>
        </td>
    </tr>
    <tr>
        <td >
        <FONT FACE="<%= FontFace %>" SIZE="2"><i><%= FormHeader1 %></i></FONT><br />
        <br />
        
        <%
        
        AvailOfferCount = 0

        SQLRequiredTicketCount = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType = 'Seat'"' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
        Set rsRequiredTicketCount = OBJdbConnection.Execute(SQLRequiredTicketCount)

        If Not rsRequiredTicketCount.EOF Then
        AvailOfferCount = rsRequiredTicketCount("Count")
        End If

        rsRequiredTicketCount.Close
        Set rsRequiredTicketCount = nothing  
        
        For i = 1 To AvailOfferCount
            
        SQLEvent = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue WITH (ROWLOCK) ON Event.VenueCode = Venue.VenueCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.LineNumber = " & i & " GROUP BY Event.EventCode, Event.EventDate, Act.Act, Venue.Venue ORDER BY Event.EventDate, Act.Act, Venue.Venue"
        Set rsEvent = OBJdbConnection.Execute(SQLEvent)   
            
        %>
        
        <table id="rounded-corner" summary="surveypage">
        <thead>
	        <tr>
    	        <th scope="col" class="category-left"></th>
    	        <th scope="col" class="category" colspan="2"><b>Attendee <%=i%></th>
    	        <th scope="col" class="category-right"></th>
            </tr>        
       </thead>
        <tbody>
        
        <%

        'Question Count
        For j = 1 to NumQuestions 

            SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & i & " AND FieldName = 'Answer" & j & "'"
            Set rsOrderLineDetail = OBJdbConnection.Execute(SQLOrderLineDetail)  
            
            If Not rsOrderLineDetail.EOF Then
                FieldValue = rsOrderLineDetail("FieldValue")
            Else
                FieldValue = ""
            End If
            
            rsOrderLineDetail.Close
            Set rsOrderLineDetail = nothing
                 
       
            Select Case j
            Case 1,2,3,4,7,8,9,10
            
            %>
            
            <tr>
                <td class="data-left" colspan="2"><%=Question(j)%></td>
                <td class="data-right" colspan="2"><INPUT TYPE="text" ID = "<%=Question(j)%>" NAME="Answer<%=j%>_<%=i%>" VALUE="<%=FieldValue%>" SIZE="24" /></td>
            </tr> 
            
<% 
			
			Case 5
%>
				<tr>
					<td class="data-left" colspan="2">
						<%=Question(j)%>
					</td>               
					<td class="data-right" colspan="2">
						<select name="Answer<%=j%>_<%=i%>"> 
						<option value="" selected="selected">Select a State</option> 
						<option value="AL">Alabama</option> 
						<option value="AK">Alaska</option> 
						<option value="AZ">Arizona</option> 
						<option value="AR">Arkansas</option> 
						<option value="CA">California</option> 
						<option value="CO">Colorado</option> 
						<option value="CT">Connecticut</option> 
						<option value="DE">Delaware</option> 
						<option value="FL">Florida</option> 
						<option value="GA">Georgia</option> 
						<option value="HI">Hawaii</option> 
						<option value="ID">Idaho</option> 
						<option value="IL">Illinois</option> 
						<option value="IN">Indiana</option> 
						<option value="IA">Iowa</option> 
						<option value="KS">Kansas</option> 
						<option value="KY">Kentucky</option> 
						<option value="LA">Louisiana</option> 
						<option value="ME">Maine</option> 
						<option value="MD">Maryland</option> 
						<option value="MA">Massachusetts</option> 
						<option value="MI">Michigan</option> 
						<option value="MN">Minnesota</option> 
						<option value="MS">Mississippi</option> 
						<option value="MO">Missouri</option> 
						<option value="MT">Montana</option> 
						<option value="NE">Nebraska</option> 
						<option value="NV">Nevada</option> 
						<option value="NH">New Hampshire</option> 
						<option value="NJ">New Jersey</option> 
						<option value="NM">New Mexico</option> 
						<option value="NY">New York</option> 
						<option value="NC">North Carolina</option> 
						<option value="ND">North Dakota</option> 
						<option value="OH">Ohio</option> 
						<option value="OK">Oklahoma</option> 
						<option value="OR">Oregon</option> 
						<option value="PA">Pennsylvania</option> 
						<option value="RI">Rhode Island</option> 
						<option value="SC">South Carolina</option> 
						<option value="SD">South Dakota</option> 
						<option value="TN">Tennessee</option> 
						<option value="TX">Texas</option> 
						<option value="UT">Utah</option> 
						<option value="VT">Vermont</option> 
						<option value="VA">Virginia</option> 
						<option value="WA">Washington</option> 
						<option value="WV">West Virginia</option> 
						<option value="WI">Wisconsin</option> 
						<option value="WY">Wyoming</option>
						</select>
					</td>
				</tr>
<% 
			
			Case 6
				
%>
				<tr>
					<td class="data-left" colspan="2">
						<%=Question(j)%>
					</td>               
					<td class="data-right" colspan="2">
						<select name="Answer<%=j%>_<%=i%>"> 
						<option value="" selected="selected">Select a Country</option> 
							<option value="AFG">Afghanistan</option>
							<option value="ALA">Åland Islands</option>
							<option value="ALB">Albania</option>
							<option value="DZA">Algeria</option>
							<option value="ASM">American Samoa</option>
							<option value="AND">Andorra</option>
							<option value="AGO">Angola</option>
							<option value="AIA">Anguilla</option>
							<option value="ATA">Antarctica</option>
							<option value="ATG">Antigua and Barbuda</option>
							<option value="ARG">Argentina</option>
							<option value="ARM">Armenia</option>
							<option value="ABW">Aruba</option>
							<option value="AUS">Australia</option>
							<option value="AUT">Austria</option>
							<option value="AZE">Azerbaijan</option>
							<option value="BHS">Bahamas</option>
							<option value="BHR">Bahrain</option>
							<option value="BGD">Bangladesh</option>
							<option value="BRB">Barbados</option>
							<option value="BLR">Belarus</option>
							<option value="BEL">Belgium</option>
							<option value="BLZ">Belize</option>
							<option value="BEN">Benin</option>
							<option value="BMU">Bermuda</option>
							<option value="BTN">Bhutan</option>
							<option value="BOL">Bolivia, Plurinational State of</option>
							<option value="BES">Bonaire, Sint Eustatius and Saba</option>
							<option value="BIH">Bosnia and Herzegovina</option>
							<option value="BWA">Botswana</option>
							<option value="BVT">Bouvet Island</option>
							<option value="BRA">Brazil</option>
							<option value="IOT">British Indian Ocean Territory</option>
							<option value="BRN">Brunei Darussalam</option>
							<option value="BGR">Bulgaria</option>
							<option value="BFA">Burkina Faso</option>
							<option value="BDI">Burundi</option>
							<option value="KHM">Cambodia</option>
							<option value="CMR">Cameroon</option>
							<option value="CAN">Canada</option>
							<option value="CPV">Cape Verde</option>
							<option value="CYM">Cayman Islands</option>
							<option value="CAF">Central African Republic</option>
							<option value="TCD">Chad</option>
							<option value="CHL">Chile</option>
							<option value="CHN">China</option>
							<option value="CXR">Christmas Island</option>
							<option value="CCK">Cocos (Keeling) Islands</option>
							<option value="COL">Colombia</option>
							<option value="COM">Comoros</option>
							<option value="COG">Congo</option>
							<option value="COD">Congo, the Democratic Republic of the</option>
							<option value="COK">Cook Islands</option>
							<option value="CRI">Costa Rica</option>
							<option value="CIV">Côte d'Ivoire</option>
							<option value="HRV">Croatia</option>
							<option value="CUB">Cuba</option>
							<option value="CUW">Curaçao</option>
							<option value="CYP">Cyprus</option>
							<option value="CZE">Czech Republic</option>
							<option value="DNK">Denmark</option>
							<option value="DJI">Djibouti</option>
							<option value="DMA">Dominica</option>
							<option value="DOM">Dominican Republic</option>
							<option value="ECU">Ecuador</option>
							<option value="EGY">Egypt</option>
							<option value="SLV">El Salvador</option>
							<option value="GNQ">Equatorial Guinea</option>
							<option value="ERI">Eritrea</option>
							<option value="EST">Estonia</option>
							<option value="ETH">Ethiopia</option>
							<option value="FLK">Falkland Islands (Malvinas)</option>
							<option value="FRO">Faroe Islands</option>
							<option value="FJI">Fiji</option>
							<option value="FIN">Finland</option>
							<option value="FRA">France</option>
							<option value="GUF">French Guiana</option>
							<option value="PYF">French Polynesia</option>
							<option value="ATF">French Southern Territories</option>
							<option value="GAB">Gabon</option>
							<option value="GMB">Gambia</option>
							<option value="GEO">Georgia</option>
							<option value="DEU">Germany</option>
							<option value="GHA">Ghana</option>
							<option value="GIB">Gibraltar</option>
							<option value="GRC">Greece</option>
							<option value="GRL">Greenland</option>
							<option value="GRD">Grenada</option>
							<option value="GLP">Guadeloupe</option>
							<option value="GUM">Guam</option>
							<option value="GTM">Guatemala</option>
							<option value="GGY">Guernsey</option>
							<option value="GIN">Guinea</option>
							<option value="GNB">Guinea-Bissau</option>
							<option value="GUY">Guyana</option>
							<option value="HTI">Haiti</option>
							<option value="HMD">Heard Island and McDonald Islands</option>
							<option value="VAT">Holy See (Vatican City State)</option>
							<option value="HND">Honduras</option>
							<option value="HKG">Hong Kong</option>
							<option value="HUN">Hungary</option>
							<option value="ISL">Iceland</option>
							<option value="IND">India</option>
							<option value="IDN">Indonesia</option>
							<option value="IRN">Iran, Islamic Republic of</option>
							<option value="IRQ">Iraq</option>
							<option value="IRL">Ireland</option>
							<option value="IMN">Isle of Man</option>
							<option value="ISR">Israel</option>
							<option value="ITA">Italy</option>
							<option value="JAM">Jamaica</option>
							<option value="JPN">Japan</option>
							<option value="JEY">Jersey</option>
							<option value="JOR">Jordan</option>
							<option value="KAZ">Kazakhstan</option>
							<option value="KEN">Kenya</option>
							<option value="KIR">Kiribati</option>
							<option value="PRK">Korea, Democratic People's Republic of</option>
							<option value="KOR">Korea, Republic of</option>
							<option value="KWT">Kuwait</option>
							<option value="KGZ">Kyrgyzstan</option>
							<option value="LAO">Lao People's Democratic Republic</option>
							<option value="LVA">Latvia</option>
							<option value="LBN">Lebanon</option>
							<option value="LSO">Lesotho</option>
							<option value="LBR">Liberia</option>
							<option value="LBY">Libya</option>
							<option value="LIE">Liechtenstein</option>
							<option value="LTU">Lithuania</option>
							<option value="LUX">Luxembourg</option>
							<option value="MAC">Macao</option>
							<option value="MKD">Macedonia, the former Yugoslav Republic of</option>
							<option value="MDG">Madagascar</option>
							<option value="MWI">Malawi</option>
							<option value="MYS">Malaysia</option>
							<option value="MDV">Maldives</option>
							<option value="MLI">Mali</option>
							<option value="MLT">Malta</option>
							<option value="MHL">Marshall Islands</option>
							<option value="MTQ">Martinique</option>
							<option value="MRT">Mauritania</option>
							<option value="MUS">Mauritius</option>
							<option value="MYT">Mayotte</option>
							<option value="MEX">Mexico</option>
							<option value="FSM">Micronesia, Federated States of</option>
							<option value="MDA">Moldova, Republic of</option>
							<option value="MCO">Monaco</option>
							<option value="MNG">Mongolia</option>
							<option value="MNE">Montenegro</option>
							<option value="MSR">Montserrat</option>
							<option value="MAR">Morocco</option>
							<option value="MOZ">Mozambique</option>
							<option value="MMR">Myanmar</option>
							<option value="NAM">Namibia</option>
							<option value="NRU">Nauru</option>
							<option value="NPL">Nepal</option>
							<option value="NLD">Netherlands</option>
							<option value="NCL">New Caledonia</option>
							<option value="NZL">New Zealand</option>
							<option value="NIC">Nicaragua</option>
							<option value="NER">Niger</option>
							<option value="NGA">Nigeria</option>
							<option value="NIU">Niue</option>
							<option value="NFK">Norfolk Island</option>
							<option value="MNP">Northern Mariana Islands</option>
							<option value="NOR">Norway</option>
							<option value="OMN">Oman</option>
							<option value="PAK">Pakistan</option>
							<option value="PLW">Palau</option>
							<option value="PSE">Palestinian Territory, Occupied</option>
							<option value="PAN">Panama</option>
							<option value="PNG">Papua New Guinea</option>
							<option value="PRY">Paraguay</option>
							<option value="PER">Peru</option>
							<option value="PHL">Philippines</option>
							<option value="PCN">Pitcairn</option>
							<option value="POL">Poland</option>
							<option value="PRT">Portugal</option>
							<option value="PRI">Puerto Rico</option>
							<option value="QAT">Qatar</option>
							<option value="REU">Réunion</option>
							<option value="ROU">Romania</option>
							<option value="RUS">Russian Federation</option>
							<option value="RWA">Rwanda</option>
							<option value="BLM">Saint Barthélemy</option>
							<option value="SHN">Saint Helena, Ascension and Tristan da Cunha</option>
							<option value="KNA">Saint Kitts and Nevis</option>
							<option value="LCA">Saint Lucia</option>
							<option value="MAF">Saint Martin (French part)</option>
							<option value="SPM">Saint Pierre and Miquelon</option>
							<option value="VCT">Saint Vincent and the Grenadines</option>
							<option value="WSM">Samoa</option>
							<option value="SMR">San Marino</option>
							<option value="STP">Sao Tome and Principe</option>
							<option value="SAU">Saudi Arabia</option>
							<option value="SEN">Senegal</option>
							<option value="SRB">Serbia</option>
							<option value="SYC">Seychelles</option>
							<option value="SLE">Sierra Leone</option>
							<option value="SGP">Singapore</option>
							<option value="SXM">Sint Maarten (Dutch part)</option>
							<option value="SVK">Slovakia</option>
							<option value="SVN">Slovenia</option>
							<option value="SLB">Solomon Islands</option>
							<option value="SOM">Somalia</option>
							<option value="ZAF">South Africa</option>
							<option value="SGS">South Georgia and the South Sandwich Islands</option>
							<option value="SSD">South Sudan</option>
							<option value="ESP">Spain</option>
							<option value="LKA">Sri Lanka</option>
							<option value="SDN">Sudan</option>
							<option value="SUR">Suriname</option>
							<option value="SJM">Svalbard and Jan Mayen</option>
							<option value="SWZ">Swaziland</option>
							<option value="SWE">Sweden</option>
							<option value="CHE">Switzerland</option>
							<option value="SYR">Syrian Arab Republic</option>
							<option value="TWN">Taiwan, Province of China</option>
							<option value="TJK">Tajikistan</option>
							<option value="TZA">Tanzania, United Republic of</option>
							<option value="THA">Thailand</option>
							<option value="TLS">Timor-Leste</option>
							<option value="TGO">Togo</option>
							<option value="TKL">Tokelau</option>
							<option value="TON">Tonga</option>
							<option value="TTO">Trinidad and Tobago</option>
							<option value="TUN">Tunisia</option>
							<option value="TUR">Turkey</option>
							<option value="TKM">Turkmenistan</option>
							<option value="TCA">Turks and Caicos Islands</option>
							<option value="TUV">Tuvalu</option>
							<option value="UGA">Uganda</option>
							<option value="UKR">Ukraine</option>
							<option value="ARE">United Arab Emirates</option>
							<option value="GBR">United Kingdom</option>
							<option value="USA">United States</option>
							<option value="UMI">United States Minor Outlying Islands</option>
							<option value="URY">Uruguay</option>
							<option value="UZB">Uzbekistan</option>
							<option value="VUT">Vanuatu</option>
							<option value="VEN">Venezuela, Bolivarian Republic of</option>
							<option value="VNM">Viet Nam</option>
							<option value="VGB">Virgin Islands, British</option>
							<option value="VIR">Virgin Islands, U.S.</option>
							<option value="WLF">Wallis and Futuna</option>
							<option value="ESH">Western Sahara</option>
							<option value="YEM">Yemen</option>
							<option value="ZMB">Zambia</option>
							<option value="ZWE">Zimbabwe</option>
						</select>
					</td>
				</tr>
<%
			
			
                Case 11  
                
                FieldValue_0 = "SELECTED"
                FieldValue_1 = ""
                FieldValue_2 = ""
                FieldValue_3 = ""
                FieldValue_4 = ""
                FieldValue_5 = ""
                FieldValue_6 = ""
                FieldValue_7 = ""               
                FieldValue_8 = ""
                FieldValue_9 = ""
                FieldValue_10 = ""
                                                
                If FieldValue =  "Educational Consultant" Then 
                    FieldValue_1 = "SELECTED" 
                    FieldValue_0 = ""
                End If
                
                If FieldValue =  "Guidance Counselor" Then 
                    FieldValue_2 = "SELECTED" 
                    FieldValue_0 = ""
                End If
                
                If FieldValue =  "High school student" Then 
                    FieldValue_4 = "SELECTED" 
                    FieldValue_0 = ""
                End If
                
                If FieldValue =  "Parent" Then 
                    FieldValue_5 = "SELECTED" 
                    FieldValue_0 = ""
                End If
                
                If FieldValue =  "Prospective Lynn University Student" Then 
                    FieldValue_6 = "SELECTED" 
                    FieldValue_0 = ""
                End If
                
                If FieldValue =  "Principal/Headmaster" Then 
                    FieldValue_7 = "SELECTED" 
                    FieldValue_0 = ""
                End If
                
                If FieldValue =  "Special Education Teacher" Then 
                    FieldValue_8 = "SELECTED" 
                    FieldValue_0 = ""
                End If
                
                If  FieldValue =  "Other" Then 
                    FieldValue_9 = "SELECTED" 
                    FieldValue_0 = ""
                End If                               
                
%>                   
                <tr>
                    <td class="data-left" colspan="2">
                        <%=Question(j)%>
                    </td>               
                    <td class="data-right" colspan="2">
                        <select name="Answer<%=j%>_<%=i%>" id="TitleSelect<%=i%>" onChange="swap(<%=i%>); OtherCheck(<%=i%>);" style="display:block;">
	                        <option value="0" <%=FieldValue_0%> >-- Select Option --</option>
							<option value="Educational Consultant" <%=FieldValue_1%> >Educational Consultant</option> 
							<option value="Guidance Counselor" <%=FieldValue_2%> >Guidance Counselor</option> 
							<option value="High school student" <%=FieldValue_4%> >High school student</option>  
							<option value="Parent" <%=FieldValue_5%> >Parent</option>  
							<option value="Prospective Lynn University Student" <%=FieldValue_6%> >Prospective Lynn University Student</option>  
							<option value="Principal/Headmaster" <%=FieldValue_7%> >Principal/Headmaster</option>  
							<option value="Special Education Teacher" <%=FieldValue_8%> >Special Education Teacher</option>  
							<option value="Other" <%=FieldValue_9%> >Other</option> 
	                    </select>
	                 </td>
	            </tr>
	            
<% 				
					If  FieldValue_9 = "SELECTED" Then 'Display the text box with data
	            
	                SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & i & " AND FieldName = 'Answer12'"
                    Set rsOrderLineDetail = OBJdbConnection.Execute(SQLOrderLineDetail)  
                    
                    If Not rsOrderLineDetail.EOF Then
                        FieldValue = rsOrderLineDetail("FieldValue")
                    Else
                        FieldValue = ""
                    End If
                    
                    rsOrderLineDetail.Close
                    Set rsOrderLineDetail = nothing
	            
%> 
	            
	            <tr>
	                <td class="data-left" colspan="2">
                        <span id="Title1<%=i%>" style="display:block;">Please Specify:</span>
                    </td> 
                    <td class="data-right" colspan="2">
	                    <INPUT TYPE="text" NAME="Answer12_<%=i%>" VALUE="<%=FieldValue%>" SIZE="24" id="Title2<%=i%>" style="display:block;"/>	    
                    </td>
                </tr>
                
<% 				
				Else 'Do Not Display the text box 
%> 
               
               	 <tr>
	                <td class="data-left" colspan="2">
                        <span id="Title1<%=i%>" style="display:none;">Please Specify:</span>
                    </td> 
                    <td class="data-right" colspan="2">
	                    <INPUT TYPE="text" NAME="Answer12_<%=i%>" VALUE="<%=FieldValue%>" SIZE="24" id="Title2<%=i%>" style="display:none;"/>	    
                    </td>
                </tr>
                
<% 			   End If   
                                 
			   End Select  
          
  		
			   Next
%>
          
            <tr>
    	        <td class="footer-left">&nbsp;</td>
    	        <td class="footer" colspan="2">&nbsp;</td>
    	        <td class="footer-right">&nbsp;</td>
    	    </tr>
            </tbody>
            </table>
            
<%
            
            rsEvent.Close
            Set rsEvent = nothing
            
%>
            
        <br />
        <br />
        
<%
            Next
%>
        </td>    
    </tr>
</tbody>
</table>

<INPUT TYPE="submit" VALUE="Continue"></FORM>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub ' SurveyForm

'===============================================

Sub SurveyUpdate

    SQLTicketCount = "SELECT OrderLine.ItemNumber, OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType = 'Seat'"' GROUP BY Seat.EventCode ORDER BY OrderLine.LineNumber"
    Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)     
	
 	If Not rsTicketCount.EOF Then
	 
		Do Until rsTicketCount.EOF
            
			SQLEvent = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue WITH (ROWLOCK) ON Event.VenueCode = Venue.VenueCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.LineNumber = " & i & " GROUP BY Event.EventCode, Event.EventDate, Act.Act, Venue.Venue ORDER BY Event.EventDate, Act.Act, Venue.Venue"
			Set rsEvent = OBJdbConnection.Execute(SQLEvent)    

				For j = 1 to NumQuestions                       
				
					'Delete existing Answer record for this line number.
					SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsTicketCount("LineNumber") & " AND FieldName = 'Answer" & j & "'"
					Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)

					'Insert Answer record for this line number.          
					SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, SurveyNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & i & "," & SurveyNumber & ", 'Answer" & j & "', '" & Clean(Request("Answer" & j &"_"& rsTicketCount("LineNumber"))) & "'  )"            
					Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail) 
				
				Next

			rsEvent.Close
			Set rsEvent = nothing
            
		rsTicketCount.MoveNext
		Loop
		
	End If
				
    rsTicketCount.Close
    Set rsTicketCount = nothing        
	
Call FormValidate
    
    
End Sub 'SurveyUpdate

'===============================================

Sub FormValidate

FormComplete = "True"

Message1 = "Please answer the following questions:"

AvailOfferCount = 0


SQLTicketCount = "SELECT OrderLine.ItemNumber, OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType = 'Seat'"' GROUP BY Seat.EventCode ORDER BY OrderLine.LineNumber"
Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)     
	
 	If Not rsTicketCount.EOF Then
	 
		Do Until rsTicketCount.EOF

			SQLEvent = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue WITH (ROWLOCK) ON Event.VenueCode = Venue.VenueCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.LineNumber = " & rsTicketCount("LineNumber") & " GROUP BY Event.EventCode, Event.EventDate, Act.Act, Venue.Venue ORDER BY Event.EventDate, Act.Act, Venue.Venue"
			Set rsEvent = OBJdbConnection.Execute(SQLEvent)

					'Check for Blank Fields 
					'----------------------    
					'Question Count
					For j = 1 to NumQuestions

					SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsTicketCount("LineNumber") & " AND FieldName = 'Answer" & j & "'"
					Set rsOrderLineDetail = OBJdbConnection.Execute(SQLOrderLineDetail)          
						If rsOrderLineDetail("FieldValue") = "" OR rsOrderLineDetail("FieldValue") = "0" Then 
							FormComplete = "False"                     
							Message2 = Message2 + Question(j) + "\n"                      
						End If            
					rsOrderLineDetail.Close
					Set rsOrderLineDetail = nothing

					Next

			rsEvent.Close
			Set rsEvent = nothing
		
		rsTicketCount.MoveNext
		Loop
		
	End If
				
rsTicketCount.Close
Set rsTicketCount = nothing     



If FormComplete Then
    Message = ""
    Call  EventList(Message)
Else
    Message = Message1 + "\n\n" + Message2
    Call DisplaySurvey(Message)   
End If

End Sub


'===============================================


Sub EventList(Message)

If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html>

<head>

<title>TIX.com</title>

<style type="text/css">
        
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
    line-height: 1 em;
}
#rounded-corner
{
	font-size: 10px;
    font-weight: 400;
	text-align: left;
	border-collapse: collapse;
	width: 600px;
	top: 10px;
	line-height: 22px;
	margin-top:  10px;
}
#rounded-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 0px;
    padding-right: 1px;
	font-size: 15px;
	font-weight: 600;
	text-align: center;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner thead th.category-left
{
	background: <%=TableCategoryBGColor%> url('<%=NECorner%>') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('<%=NWCorner%>') right -1px no-repeat;
    text-align: left;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{
    background: <%=TableDataBGColor%> url('<%=SWCorner%>') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('<%=SECorner%>') right bottom no-repeat;
}
#rounded-corner td.data
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-left: 0px;
	padding-right: 0px;
	padding-top: 10px;
	padding-bottom: 10px;
	text-align: left;
	line-height: 13px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-right
{
	padding-left: 10px;
	padding-right: 0px;
	padding-top: 10px;
	padding-bottom: 10px;
    text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
h2 
{
    border-bottom: 1px solid <%=TableCategoryBGColor%>;
    font-size: 14px;
    font-weight: 500;
}
h2 span 
{
    position: relative; 
    margin: 10; 
    bottom: -0.6em;
    padding: 1px 0.5em; 
    left: -0.2000em;
    border-style: solid; 
    border-width: 1px 1px 1px 0.8em;  
    border-color: <%=TableCategoryBGColor%> <%=TableCategoryBGColor%> <%=TableCategoryBGColor%> <%=TableCategoryBGColor%>;
    background-color: #ffffff;
}
.alert 
{
   display:none;
   position:absolute;
   top:1px;
   left:1px;
   width:300px;
   background-color:white;
   border-style:solid;
   border-width:1px;
   padding:15px 20px 5px 20px;
}
</style>

</head>

<% If Message = "" Then %>
    <body>
<% Else %>
	<body onLoad="alert('<%= Message %>');" <%= BodyParameters %>>
<% End If %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="EventListUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">


<table id="tix-table" summary="surveypage" cellpadding="0" cellspacing="0" border="0">
<tbody>
    <tr>
        <td align="left">
	        <FONT FACE="<%= FontFace %>" SIZE="4">
            <b><%= FormName2 %></b></FONT>
        </td>
    </tr>
    <tr>
        <td >
        <FONT FACE="<%= FontFace %>" SIZE="2"><i><%= FormHeader2 %></i></FONT><br />        
                       
        <%
        
    SQLTicketCount = "SELECT OrderLine.ItemNumber, OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType = 'Seat'"' GROUP BY Seat.EventCode ORDER BY OrderLine.LineNumber"
    Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)     
	
 	 If Not rsTicketCount.EOF Then
	 
		Do Until rsTicketCount.EOF
        
        SQLFirstName = "Select (SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.FieldName = 'Answer1' and OrderNumber = " & Session("OrderNumber")& " and LineNumber= " & rsTicketCount("LineNumber") & ") as FirstName"
        Set rsFirstName = OBJdbConnection.Execute(SQLFirstName)
        FirstName = rsFirstName("FirstName")

        SQLLastName = "Select (SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.FieldName = 'Answer2' and OrderNumber = " & Session("OrderNumber")& " and LineNumber= " & rsTicketCount("LineNumber") & ") as LastName"
        Set rsLastName = OBJdbConnection.Execute(SQLLastName)
        LastName = rsLastName("LastName")      
        
        %>

            <table id="rounded-corner" summary="surveypage" border="0">
            <thead>
	            <tr>
    	            <th scope="col" class="category-left">&nbsp;</th>
    	            <th scope="col" class="category"><b><%=FirstName%>&nbsp;<%=LastName%></th>
    	            <th scope="col" class="category-right">&nbsp;</th>
                </tr>        
            </thead>
            <tbody>
        
                <% 
				
				'Survey Questions 13, 14 and 15 - Select one workshop for each session 
				
				For j = 13 to 15 
				
				%>                      

                <tr>
                 <td class="data-left">&nbsp;</td>
                 <td class="data-left"><h2><span><%=Question(j)%></span></h2><br></td>
                 <td class="data-left">&nbsp;</td>
                </tr>

                <% 
				
				'Range of Survey Field Numbers to be listed.
				'Total of 21 workshops split into 3 lists
                
                Select Case j
                Case 13 'Session One Workshops
                    Count1 = "1"  'Session 1 First Listing
                    Count2 = "7"  'Session 1 Last Listing
                Case 14 'Session Two Workshops
                    Count1 = "8"  'Session 2 First Listing
                    Count2 = "14" 'Session 2 Last Listing
                Case 15 'Session Three Workshops
                    Count1 = "15" 'Session 3 First Listing
                    Count2 = "21" 'Session 3 Last Listing
                End Select
                
%> 
                             
<% 					For m = Count1 to Count2                         
                        
                        'Determine if this question already has an answer.
                        SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsTicketCount("LineNumber") & " AND FieldName = 'Answer" & j & "'"
                        Set rsOrderLineDetail = OBJdbConnection.Execute(SQLOrderLineDetail)                          
                            If Not rsOrderLineDetail.EOF Then
                                AnswerValue = rsOrderLineDetail("FieldValue")
                            Else
                                AnswerValue = ""
                            End If                        
                        rsOrderLineDetail.Close
                        Set rsOrderLineDetail = nothing  
                        
                        'Check the radio button for the pre-selected answer
                        If  AnswerValue = SurveyFields(m,1) Then
                            AnswerStatus = "CHECKED"
                        Else
                            AnswerStatus = ""
                        End If
                        
%> 
                        <tr align="left">
                           <td align="left" valign="top" class="data-right"><INPUT TYPE="radio" NAME="Answer<%=j%>_<%=i%>" VALUE="<%= SurveyFields(m,1) %>" <%= AnswerStatus %>></td>
                           <td class="data-left"><B><%= SurveyFields(m,1) %></b><br>Presenter: <%= SurveyFields(m,2) %></td>
                           <td align="left" class="data">&nbsp;</td>
                        </tr>  
                                
<% 						Next 

                 Next 
                
		rsTicketCount.MoveNext
		Loop
	
	 End If
			
	rsTicketCount.Close
	Set rsTicketCount = nothing  
	
%> 
     
        <tr>
	        <td class="footer-left">&nbsp;</td>
	        <td class="footer">&nbsp;</td>
	        <td class="footer-right">&nbsp;</td>
	    </tr>
	    <tr>
	        <td >&nbsp;</td>
	        <td align="center" colspan="2"><br /><INPUT TYPE="submit" VALUE="Continue"></form></td>
	        <td >&nbsp;</td>
	    </tr>
        </tbody>
    </table>
    
</td>
</tr>
</table>
<!--#INCLUDE virtual="/FooterInclude.asp"-->
</BODY>
</HTML>

<%

End Sub 

'==========================================================

Sub EventListUpdate

SQLTicketCount = "SELECT OrderLine.ItemNumber, OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType = 'Seat'"' GROUP BY Seat.EventCode ORDER BY OrderLine.LineNumber"
Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)     

	If Not rsTicketCount.EOF Then
 
	 Do Until rsTicketCount.EOF

        SQLEvent = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue WITH (ROWLOCK) ON Event.VenueCode = Venue.VenueCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.LineNumber = " & rsTicketCount("LineNumber")  & " GROUP BY Event.EventCode, Event.EventDate, Act.Act, Venue.Venue ORDER BY Event.EventDate, Act.Act, Venue.Venue"
        Set rsEvent = OBJdbConnection.Execute(SQLEvent)    

            For j = 13 to 15                       
            
                'Delete existing Answer record for this line number.
                SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsTicketCount("LineNumber")  & " AND FieldName = 'Answer" & j & "'"
                Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)

                'Insert Answer record for this line number.          
                SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, SurveyNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & rsTicketCount("LineNumber")  & "," & SurveyNumber & ", 'Answer" & j & "', '" & Clean(Request("Answer"&j&"_"&rsTicketCount("LineNumber") )) & "'  )"            
                Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail) 
            
            Next

        rsEvent.Close
        Set rsEvent = nothing
		
	rsTicketCount.MoveNext
	Loop
	
	End If
			
rsTicketCount.Close
Set rsTicketCount = nothing  
            
      
	
Call EventValidate
    
    
End Sub 'SurveyUpdate


'===============================================

Sub EventValidate

FormComplete = "True"

Message = "Please select 1 workshop for each breakout session"

AvailOfferCount = 0

SQLTicketCount = "SELECT OrderLine.ItemNumber, OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType = 'Seat'"' GROUP BY Seat.EventCode ORDER BY OrderLine.LineNumber"
Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)     

	If Not rsTicketCount.EOF Then
 
		Do Until rsTicketCount.EOF

			SQLEvent = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue WITH (ROWLOCK) ON Event.VenueCode = Venue.VenueCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.LineNumber = " & rsTicketCount("LineNumber") & " GROUP BY Event.EventCode, Event.EventDate, Act.Act, Venue.Venue ORDER BY Event.EventDate, Act.Act, Venue.Venue"
			Set rsEvent = OBJdbConnection.Execute(SQLEvent)

					'Question Count
					 For j = 13 to 15    

						SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsTicketCount("LineNumber") & " AND FieldName = 'Answer" & j & "'"
						Set rsOrderLineDetail = OBJdbConnection.Execute(SQLOrderLineDetail)  
									
							If rsOrderLineDetail("FieldValue") = "" OR rsOrderLineDetail("FieldValue") = "0" Then        
								FormComplete = "False"        
							End If
						
						rsOrderLineDetail.Close
						Set rsOrderLineDetail = nothing

					Next

			rsEvent.Close
			Set rsEvent = nothing
		
		rsTicketCount.MoveNext
		Loop
	
	End If
			
rsTicketCount.Close
Set rsTicketCount = nothing  



If FormComplete Then
   Continue
Else
    EventList(Message) 
End If

End Sub

'==========================================================

Sub Continue

    Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If
        
End Sub 'Continue

'==========================================================

%>