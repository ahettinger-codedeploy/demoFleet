<%

'CHANGE LOG - Inception
'SSR 4/1/2011
'Meal Selection Survey. 

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%
    
'===============================================

Page = "Survey"
SurveyNumber = 997
SurveyFileName = "MealSurvey.asp"


'===============================================
'Democratic Committee of Lower Merion & Narberth
'Simple, simple

'One question:
'What is the meal preference for all of those attending?"

'Answers:
'- Chicken
'- Fish
'- Vegetarian

'Radio buttons - answer required

'1-for-1

'The custom survey report is already in place.


'===============================================

'Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    ClientFolder= "Tix"
Else
    ClientFolder = "democratslmn"
End If


'===============================================

'Check to see if Order Number exists.  If not, redirect to Home Page.

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

'Survey Start. 
'Request the form name and process requested action


Select Case Clean(Request("FormName"))
    Case "SurveyUpdate"
        Call SurveyUpdate
    Case "Continue"
        Call Continue
    Case Else
        Call SurveyForm
End Select


OBJdbConnection.Close
Set OBJdbConnection = nothing

'===============================================

    Const NUMBER_OF_PAGES = 3

Dim intPreviousPage
Dim intCurrentPage
Dim strItem

' What page did we come from?
intPreviousPage = Request.Form("page")

' What page are we on?
Select Case Request.Form("navigate")
	Case "< Back"
		intCurrentPage = intPreviousPage - 1
	Case "Next >"
		intCurrentPage = intPreviousPage + 1
	Case Else
		' Either it's our first run of the page and we're on page 1 or
		' the form is complete and pages are unimportant because we're
		' about to process our data!
		intCurrentPage = 1
End Select

' If we're not finished then display the form.
If Request.Form("navigate") <> "Finish" Then %>
	<form action="<%= Request.ServerVariables("URL") %>" method="post">
	<input type="hidden" name="page" value="<%= intCurrentPage %>">

	<%
	' Take data and store it in hidden form fields.  All our fields are
	' prefixed with numbers so that we know what page it belongs to.
	For Each strItem In Request.Form
		' Ignore the "page" and "navigate" button form fields.
		If strItem <> "page" And strItem <> "navigate" Then
			' If the data is from the current page we don't need
			' the hidden field since the data will show in the visible
			' form fields.
			If CInt(Left(strItem, 1)) <> intCurrentPage Then
				Response.Write("<input type=""hidden"" name=""" & strItem & """" _
				& " value=""" & Request.Form(strItem) & """>" & vbCrLf)
			End If
		End If
	Next

	' Display current page fields.  The fields are all named with
	' numerical prefix that tells us which page they belong to.
	' We need a Case for each page.
	Select Case intCurrentPage
		Case 1
			%>
			<table>
			<tr>
				<td><strong>Name:</strong></td>
				<td><input type="text" name="1_name"  value="<%= Request.Form("1_name") %>"></td>
			</tr><tr>
				<td><strong>Email:</strong></td>
				<td><input type="text" name="1_email" value="<%= Request.Form("1_email") %>"></td>
			</tr>
			</table>
			<%
		Case 2
			%>
			<table>
			<tr>
				<td><strong>Address:</strong></td>
				<td><input type="text" name="2_address" value="<%= Request.Form("2_address") %>"></td>
			</tr><tr>
				<td><strong>City:</strong></td>
				<td><input type="text" name="2_city"    value="<%= Request.Form("2_city") %>"></td>
			</tr><tr>
				<td><strong>State:</strong></td>
				<td><input type="text" name="2_state"   value="<%= Request.Form("2_state") %>"></td>
			</tr><tr>
				<td><strong>Zip:</strong></td>
				<td><input type="text" name="2_zip"     value="<%= Request.Form("2_zip") %>"></td>
			</tr>
			</table>
			<%
		Case 3
			' Notice that you can do other types of form fields too.
			%>
			<table>
			<tr>
				<td><strong>Sex:</strong></td>
				<td>
					<input type="radio" name="3_sex" value="male"   <% If Request.Form("3_sex") = "male"   Then Response.Write("checked=""checked""") %>>Male
					<input type="radio" name="3_sex" value="female" <% If Request.Form("3_sex") = "female" Then Response.Write("checked=""checked""") %>>Female
				</td>
			</tr><tr>
				<td><strong>Age:</strong></td>
				<td>
					<select name="3_age">
						<option></option>
						<option<% If Request.Form("3_age") = "< 20"    Then Response.Write(" selected=""selected""") %>>&lt; 20</option>
						<option<% If Request.Form("3_age") = "20 - 29" Then Response.Write(" selected=""selected""") %>>20 - 29</option>
						<option<% If Request.Form("3_age") = "30 - 39" Then Response.Write(" selected=""selected""") %>>30 - 39</option>
						<option<% If Request.Form("3_age") = "40 - 49" Then Response.Write(" selected=""selected""") %>>40 - 49</option>
						<option<% If Request.Form("3_age") = "50 - 59" Then Response.Write(" selected=""selected""") %>>50 - 59</option>
						<option<% If Request.Form("3_age") = "60 - 69" Then Response.Write(" selected=""selected""") %>>60 - 69</option>
						<option<% If Request.Form("3_age") = "70 - 79" Then Response.Write(" selected=""selected""") %>>70 - 79</option>
						<option<% If Request.Form("3_age") = "80 +"    Then Response.Write(" selected=""selected""") %>>80 +</option>
					</select>
				</td>
			</tr>
			</table>
			<%
		Case Else
			' You shouldn't see this error unless something goes wrong.
			Response.Write("Error: Bad Page Number!")
	End Select
	%>
	<br />
	<!-- Display form navigation buttons. -->
	<% If intCurrentPage > 1 Then %>
		<input type="submit" name="navigate" value="&lt; Back">
	<% End If %>
	<% If intCurrentPage < NUMBER_OF_PAGES Then %>
		<input type="submit" name="navigate" value="Next &gt;">
	<% Else %>
		<input type="submit" name="navigate" value="Finish">
	<% End If %>
	</form>
	<%
Else
	' This is where we process our data when the user submits the final page.
	' I just display the data, but you're free to store the data in a
	' database, send it via email, or do whatever you want with it.

	'For Each strItem In Request.Form
	'	Response.Write(strItem & ": " & Request.Form(strItem) & "<br />" & vbCrLf)
	'Next
	%>
	<p><strong>
	Here's what you entered:
	</strong></p>
	
	<pre>
	<strong>Name:</strong>    <%= Request.Form("1_name") %>
	<strong>Email:</strong>   <%= Request.Form("1_email") %>
	<strong>Address:</strong> <%= Request.Form("2_address") %>
	<strong>City:</strong>    <%= Request.Form("2_city") %>
	<strong>State:</strong>   <%= Request.Form("2_state") %>
	<strong>Zip:</strong>     <%= Request.Form("2_zip") %>
	<strong>Sex:</strong>     <%= Request.Form("3_sex") %>
	<strong>Age:</strong>     <%= Request.Form("3_age") %>
	</pre>

	<p>
	<a href="<%= Request.ServerVariables("URL") %>">Start Again</a>
	</p>
	<%
End If
%>
