<%

'CHANGE LOG
'SSR (12/05/2011)
'Added BODY parameters so PL will display correctly


'CHANGE LOG - Inception
'SSR (12/08/2011)
'Custom Survey

'CHANGE LOG - Update
'SLM (1/16/2012)
'Reduced number of premiums

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'===============================================

Page = "Survey"
SurveyNumber = 475
SurveyName = "PremiumSurvey.asp"
BoxOfficeByPass = False

'===============================================

SurveyTitle = "Cityfolk Membership Premiums"
SurveyHeader = "Select from these premiums:"

ItemNumberList = "458,459,460,461,462,463,464,465,466"

DIM PremiumList(7)
PremiumList(1) = "Cityfolk key ring"
PremiumList(2) = "Cityfolk baseball cap"
PremiumList(3) = "Cityfolk tote bag"
PremiumList(4) = "Cityfolk T- shirt"
'PremiumList(5old) = "Cityfolk Travel Mug"
'PremiumList(6old) = "Cityfolk Stainless Steel Water Bottle"
PremiumList(5) = "Cityfolk Portable Chair (limited quantities)"
'PremiumList(8old) = "Cityfolk Blanket (limited quantities)"
PremiumList(6) = "Cityfolk Insulated Cooler (limited quantities)"

DIM ImageList(7)
ImageList(1) = "/Clients/Cityfolk/DonationImages/web_cf_keychain.jpg"
ImageList(2) = "/Clients/Cityfolk/DonationImages/web_cf_ballcap.jpg"
ImageList(3) = "/Clients/Cityfolk/DonationImages/web_cf_bag.jpg"
ImageList(4) = "/Clients/Cityfolk/DonationImages/web_cf_shirt.jpg"
'ImageList(5old) = "http://www.cityfolk.org/images/merch/cf_travelmug-red.jpg"
'ImageList(6old) = "http://www.cityfolk.org/images/merch/cf_water-bottle.jpg"
ImageList(5) = "http://www.cityfolk.org/images/merch/cf_stool.JPG"
'ImageList(8old) = "/Clients/Cityfolk/DonationImages/web_cf_blanket.jpg"
ImageList(6) = "/Clients/Cityfolk/DonationImages/web_cf_cooler.jpg"

DIM ImageShop(7)
ImageShop(1) = ""
ImageShop(2) = ""
ImageShop(3) = ""
ImageShop(4) = ""
'ImageShop(5old) = ""
'ImageShop(6old) = ""
ImageShop(5) = ""
'ImageShop(8old) = ""
ImageShop(6) = ""

DIM PremCount 

DIM RoomPass


'===============================================

'CSS Survey Variables

If Session("UserNumber")<> "" Then
    'Green
    TableCategoryBGColor = "#008400"
    'White
    TableCategoryFontColor = "FFFFFF"
    'Light Green
    TableColumnHeadingBGColor = "#99cc99"
    'Black
    TableColumnHeadingFontColor = "000000"
    'Gray
    TableDataBGColor = "E9E9E9"
End If

'============================================================
 
'Verify that Order Number exists - if not bounce back to default page
'Verify that User Number exists - if so display management tabs

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

'============================================================

'Bypass this survey on all Comp Orders
'Bypass this survey for Box Office Users

If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If

If Session("OrderTypeNumber") <> 1 Then
    If BoxOfficeByPass Then
	    Call Continue
    End If
End If

'============================================================

'Request the form name and process requested action

Select Case Clean(Request("FormName"))
    Case "Continue"
        Call Continue
    Case "SurveyUpdate"
        Call SurveyUpdate
    Case "UpdatePasses"
        Call UpdatePasses
    Case "Premium(Message)"
        Call Premium(Message)
    Case Else
        Call MemberCheck
 End Select   

'==========================================================

Sub MemberCheck

'Determine if the donation item number is in order
SQLMemberDonation = "SELECT OrderLine.ItemNumber, OrderLine.Price, Donation.Description FROM OrderLine (NOLOCK) INNER JOIN Donation (NOLOCK) on OrderLine.ItemNumber = Donation.ItemNumber WHERE OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))
Set rsMemberDonation = OBJdbConnection.Execute(SQLMemberDonation)

    DonationItemNo = rsMemberDonation("ItemNumber")
    DonationType = rsMemberDonation("Description")
    DonationAmount = rsMemberDonation("Price")

rsMemberDonation.Close
Set rsMemberDonation = nothing

'Student	$15.00
'Individual	$30.00
If DonationAmount  =< 49 Then
    PremCount = 0 
    RoomPass = 0 
     
'Family	$50.00    
ElseIf DonationAmount => 50 And DonationAmount =< 99 Then
    PremCount = 1
    RoomPass = 0
    
'Friend	$100.00    
ElseIf DonationAmount => 100 And DonationAmount =< 249 Then
    PremCount = 2
    RoomPass = 0

'Believer	$250.00    
ElseIf DonationAmount => 250 And DonationAmount =< 499 Then
    PremCount = 3
    RoomPass = 0

'Sustainer	$500.00    
ElseIf DonationAmount => 500 And DonationAmount =< 749 Then
    PremCount = 4
    RoomPass = 2
    
'Stakeholder	$750.00
'Benefactor	$1,000.00
ElseIf DonationAmount => 750 Then
    PremCount = 4
    RoomPass = 4
    
End If
  
If PremCount = 0 Then 
Call Continue

ElseIf PremCount < 4 Then
Call Premium(Message)

ElseIf PremCount = 4 Then
Call PassPrem

End If

End Sub

'=====================================================

Sub Premium(Message)

If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If


'Determine if the donation item number is in order
SQLMemberDonation = "SELECT OrderLine.ItemNumber, OrderLine.Price, Donation.Description FROM OrderLine (NOLOCK) INNER JOIN Donation (NOLOCK) on OrderLine.ItemNumber = Donation.ItemNumber WHERE OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))
Set rsMemberDonation = OBJdbConnection.Execute(SQLMemberDonation)

    DonationItemNo = rsMemberDonation("ItemNumber")
    DonationType = rsMemberDonation("Description")
    DonationAmount = rsMemberDonation("Price")

rsMemberDonation.Close
Set rsMemberDonation = nothing

'Student	$15.00
'Individual	$30.00
If DonationAmount  =< 49 Then
    PremCount = 0 
    RoomPass = 0 
     
'Family	$50.00    
ElseIf DonationAmount => 50 And DonationAmount =< 99 Then
    PremCount = 1
    RoomPass = 0
    
'Friend	$100.00    
ElseIf DonationAmount => 100 And DonationAmount =< 249 Then
    PremCount = 2
    RoomPass = 0

'Believer	$250.00    
ElseIf DonationAmount => 250 And DonationAmount =< 499 Then
    PremCount = 3
    RoomPass = 0

'Sustainer	$500.00    
ElseIf DonationAmount => 500 And DonationAmount =< 749 Then
    PremCount = 4
    RoomPass = 2
    
'Stakeholder	$750.00
'Benefactor	$1,000.00
ElseIf DonationAmount => 750 Then
    PremCount = 4
    RoomPass = 4
    
End If

If PremCount > 1 Then
modifier = "S"
Else
modifier = ""
End If


%>

<html>
<head>
<title><%= title %></title>

<style type="text/css">
body
{
line-height: 1 em;
}
#rounded-corner
{
	font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
	font-size: 12px;
	font-weight: 400;
	width: 550px;
	line-height: 32px;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{
	padding-top: 10px;
	padding-bottom: 10px;
	padding-left: 20px;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}

#rounded-corner td.category
{
	padding-top: 15px;
	padding-bottom: 15px;
    padding-left: 15px;
	font-size: 15px;
	font-weight: 600;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/sw.gif') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/se.gif') right bottom no-repeat;
}
#rounded-corner td.data
{
	padding-top: 1px;
	padding-bottom: 1px;
	font-weight: normal;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-top: 4px;
	padding-bottom: 4px;
	padding-left: 5px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}		
#rounded-corner td.data-right
{	
	padding-top: 4px;
	padding-bottom: 4px;
	padding-right: 5px;
	text-align: right;
	vertical-align: top; 
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.column
{
	padding-top: 5px;
    padding-left: 15px;
	text-align: left;
	color: <%=TableColumnHeadingFontColor%>;
	background: <%=TableColumnHeadingBGColor%>;
}
</style>
<head>

</head>


<% If Message = "" Then %>
    <%= strBody %>
<% Else %>
	<body onLoad="alert('<%= Message %>');" BGCOLOR=#5C8727 LINK=#051642 ALINK=#051642 VLINK=#051642 leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 >
	<%= strBody %>
<% End If %>

<!--#include virtual="TopNavInclude.asp"-->

<FORM ACTION="<%= SurveyName %>" name="Survey" METHOD="post">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<br />

<table id="rounded-corner" summary="surveypage">
<thead>
    <tr>
	    <th scope="col" class="category" colspan="2">PLEASE SELECT <%=PremCount%> PREMIUIM<%= modifier %> - Please note that an additional item may be substituted if we are out of stock of one the items you've selected.</th>
    </tr>        
</thead>
<tbody>
<tr>
    <td class="data-left" colspan="2">
    <table id="rounded-corner">    
     <%    For j = 1 To UBound(PremiumList) - 1 %>
     <tr>
         <td class="data-right" ><img src="<%=ImageList(j)%>" height="50"</td>
         <td class="data" ><input type="checkbox" NAME="Answer2" value="<%=PremiumList(j)%>"></td>
         <td class="data-left"><%=PremiumList(j)%></td>
     </tr>  
      <% Next %>  
    </table>
    </td>
    </tr>      
    <tr>
        <td class="footer" colspan="2"><input type="hidden" NAME="Answer1" value="<%=PremCount%>"></td>
    </tr>
    </tbody>
</table>
<br /> 
        
<INPUT TYPE="submit" VALUE="Continue">
</form>


<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>

</html>

<%		
	
End Sub '

'============================================================

Sub PassPrem

If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

'Determine if the donation item number is in order
SQLMemberDonation = "SELECT OrderLine.ItemNumber, OrderLine.Price, Donation.Description FROM OrderLine (NOLOCK) INNER JOIN Donation (NOLOCK) on OrderLine.ItemNumber = Donation.ItemNumber WHERE OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))
Set rsMemberDonation = OBJdbConnection.Execute(SQLMemberDonation)

    DonationItemNo = rsMemberDonation("ItemNumber")
    DonationType = rsMemberDonation("Description")
    DonationAmount = rsMemberDonation("Price")

rsMemberDonation.Close
Set rsMemberDonation = nothing

'Student	$15.00
'Individual	$30.00
If DonationAmount  =< 49 Then
    PremCount = 0 
    RoomPass = 0 
     
'Family	$50.00    
ElseIf DonationAmount => 50 And DonationAmount =< 99 Then
    PremCount = 1
    RoomPass = 0
    
'Friend	$100.00    
ElseIf DonationAmount => 100 And DonationAmount =< 249 Then
    PremCount = 2
    RoomPass = 0

'Believer	$250.00    
ElseIf DonationAmount => 250 And DonationAmount =< 499 Then
    PremCount = 3
    RoomPass = 0

'Sustainer	$500.00    
ElseIf DonationAmount => 500 And DonationAmount =< 749 Then
    PremCount = 4
    RoomPass = 2
    
'Stakeholder	$750.00
'Benefactor	$1,000.00
ElseIf DonationAmount => 750 Then
    PremCount = 4
    RoomPass = 4
    
End If

If PremCount > 1 Then
modifier = "S"
Else
modifier = ""
End If


%>

<html>
<head>
<title><%= title %></title>

<style type="text/css">
body
{
line-height: 1 em;
}
#rounded-corner
{
	font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
	font-size: 12px;
	font-weight: 400;
	width: 550px;
	line-height: 32px;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{
	padding-top: 15px;
	padding-bottom: 15px;
	padding-left: 20px;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}

#rounded-corner td.category
{
	padding-top: 15px;
	padding-bottom: 15px;
    padding-left: 15px;
	font-size: 15px;
	font-weight: 600;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/sw.gif') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/se.gif') right bottom no-repeat;
}
#rounded-corner td.data
{
	padding-top: 5px;
	padding-bottom: 5px;
	font-weight: normal;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-top: 10px;
	padding-bottom: 10px;
	padding-left: 20px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}		
#rounded-corner td.data-right
{	
	padding-top: 2px;
	padding-bottom: 2px;
	padding-right: 15px;
	text-align: right;
	vertical-align: top; 
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.column
{
	padding-top: 5px;
    padding-left: 15px;
	text-align: left;
	color: <%=TableColumnHeadingFontColor%>;
	background: <%=TableColumnHeadingBGColor%>;
}
</style>

<head>

</head>

<%= strBody %>

<!--#include virtual="TopNavInclude.asp"-->

<FORM ACTION="<%= SurveyName %>" name="Survey" METHOD="post">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<br />

<table id="rounded-corner" summary="surveypage">
<thead>
    <tr>
	    <th scope="col" class="category" colspan="2">SELECT PREMIUIMS OR PASSES</th>
    </tr>        
</thead>
<tbody>
<tr>
    <td class="data-left" colspan="2">
    Would you prefer <%= rowcount %> premiums or <%= rowcount %> passes?<br />
    <input type="radio" name="FormName" value="Premium(Message)"><%=PremCount%>&nbsp;premiums<br />
    <input type="radio" name="FormName" value="UpdatePasses"><%= RoomPass %>&nbsp;passes<br /> 
    </td>
</tr>     
<tr>
   <td class="footer" colspan="2">&nbsp;</td>
    </tr>
    </tbody>
</table>
<br /> 
<input type="hidden" name="Answer1" value="<%=RoomPass%>">         
<INPUT TYPE="submit" VALUE="Continue">
</form>


<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>

</html>

<%		
	
End Sub '

'========================================

Sub SurveyUpdate

Count = 0

NumQuestions = 2

DIM Question(3)
Question(1) = "Number of Premiums:"
Question(2) = "Premium Name:"


'Determine if the donation item number is in order
SQLMemberDonation = "SELECT OrderLine.ItemNumber, OrderLine.Price, Donation.Description FROM OrderLine (NOLOCK) INNER JOIN Donation (NOLOCK) on OrderLine.ItemNumber = Donation.ItemNumber WHERE OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))
Set rsMemberDonation = OBJdbConnection.Execute(SQLMemberDonation)

    DonationItemNo = rsMemberDonation("ItemNumber")
    DonationType = rsMemberDonation("Description")
    DonationAmount = rsMemberDonation("Price")

rsMemberDonation.Close
Set rsMemberDonation = nothing

'Student	$15.00
'Individual	$30.00
If DonationAmount  =< 49 Then
    PremCount = 0 
    RoomPass = 0 
     
'Family	$50.00    
ElseIf DonationAmount => 50 And DonationAmount =< 99 Then
    PremCount = 1
    RoomPass = 0
    
'Friend	$100.00    
ElseIf DonationAmount => 100 And DonationAmount =< 249 Then
    PremCount = 2
    RoomPass = 0

'Believer	$250.00    
ElseIf DonationAmount => 250 And DonationAmount =< 499 Then
    PremCount = 3
    RoomPass = 0

'Sustainer	$500.00    
ElseIf DonationAmount => 500 And DonationAmount =< 749 Then
    PremCount = 4
    RoomPass = 2
    
'Stakeholder	$750.00
'Benefactor	$1,000.00
ElseIf DonationAmount => 750 Then
    PremCount = 4
    RoomPass = 4
    
End If


If Clean(Request("Answer2")) <> "" Then
    For Each Item IN Request("Answer2")
        If Item <> "" Then
        Count = Count + 1
        End If
    Next
End If
          
        
If Count = PremCount Then

            For AnswerNumber = 1 To NumQuestions
                If Clean(Request("Answer" & AnswerNumber)) <> "" Then
                        For Each Item IN Request("Answer" & AnswerNumber)
	                        If Item <> "" Then
		                        SQLUpdateSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & Clean(Request("SurveyNumber")) & ", " & Session("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', " & AnswerNumber & ", '" & Clean(Item) & "', '" & Question(AnswerNumber) & "')"
		                        Set rsUpdateSurvey = OBJdbConnection.Execute(SQLUpdateSurvey)
	                        End If
                        Next
                End If
            Next
            
            Call Continue

                
ElseIf Count > PremCount Then  
                    Message = "You have selected too many premiums"
                    Call Premium(Message)

ElseIf Count < PremCount Then

                    Message = "You have not selected enough premiums"
                    Call Premium(Message)
Else
                    Message = "Please select your premiums"
                    Call Premium(Message)
End If


End Sub

'========================================

Sub UpdatePasses

If Session("OrderNumber") <> "" Then

    NumQuestions = 1

    Dim Question(2)
    Question(1) = "Number of Passes"
	    AnswerNumber = 1
		    If Clean(Request("Answer" & AnswerNumber)) <> "" Then
				    For Each Item IN Request("Answer" & AnswerNumber)
					    If Item <> "" Then
						    SQLUpdateSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & Clean(Request("SurveyNumber")) & ", " & Session("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', " & AnswerNumber & ", '" & Clean(Item) & "', '" & Question(AnswerNumber) & "')"
						    Set rsUpdateSurvey = OBJdbConnection.Execute(SQLUpdateSurvey)
					    End If
				    Next
		    End If
	
End If

Call Continue

End Sub

'======================		
	
Sub Continue
		
	If Session("UserNumber") = "" Then
		'REE 4/19/3 - Modified to use Session Variable for SurveyComplete
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Ship.asp")
	Else
		'REE 4/19/3 - Modified to use Session Variable for SurveyComplete
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Management/AdvanceShip.asp")
	End If


End Sub 'Update SurveyAnswer

'========================================

%> 
