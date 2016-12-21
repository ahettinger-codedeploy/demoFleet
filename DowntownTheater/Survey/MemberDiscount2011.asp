<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%

Page = "Survey"
SurveyNumber = 922
SurveyFileName = "MemberDiscount2011.asp"

'===============================================

'Revision Theatre 2011 Season Subscription

'Subscription discounts are only applicable for members. 
 
'Must have purchased ItemNumber 2077, 2078, 2079, 2080 or 2449 within the past calendar year to receive sub discount.  

'2077	Individual Membership
'2078	Couples Membership
'2079	Household/Family Membership
'2080	Student/Senior Membership
'2449	Upgraded Membership (Donations Over $100)

'Subscription discount is also given if the membership is being purchased on the same order as the subscription.

'Discount only good on first week of performances for each Act.

'Subscriptions Acts:
'59966   Fundraising Concert 
'59962   Jesus Christ Superstar 
'59964   Little Shop of Horrors 
'59965   The Happy Elf 
'59963   The Notebook Break Up (World Premiere) 
'59961   ZANADU (NJ Premiere)

'Discounts
'If you buy a 6-Act Sub (1 ticket to each of the 6 Acts) you get:
'60% off each ticket if purchased before March 2, 2011
'50% off each ticket if purchased between March 2 and May 13, 2011
'40% off each ticket if purchased after May 13, 2011

'If you buy a 5-Act Sub (1 ticket to 5 of the 6 Acts) you get:
'55% off each ticket if purchased before March 2, 2011
'45% off each ticket if purchased between March 2 and May 31, 2011
'35% off each ticket if purchased after May 31, 2011

'If you buy a 4-Act Sub (1 ticket to 4 of the 6 Acts) you get:
'50% off each ticket if purchased before March 2, 2011
'40% off each ticket if purchased between March 2 and May 31, 2011
'30% off each ticket if purchased after May 31, 2011

'If you buy 1 ticket you get:
'20% off all single ticket purchases

'===============================================

DiscountTypeNumber = 54104 'Clear Survey

ItemNumberList = "3038,3039,3040"

ActCodeList = "54885,54786,54886,54887,55462,54812"

ActTier1 = 6
ActTier2 = 5
ActTier3 = 4

DiscountTier1 = .60
DiscountTier2 = .55
DiscountTier3 = .50

Date1 = "2/1/2011" 
Date2 = "3/2/2011"  
Date3 = "5/13/2011"

'===============================================

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


If Session("UserNumber")<> "" Then
TableCategoryBGColor = "#008400"
TableCategoryFontColor = "FFFFFF"
TableColumnHeadingBGColor = "99CC99"
TableColumnHeadingFontColor = "000000"
TableDataBGColor = "E9E9E9"
ClientFolder= "Tix"
Else
ClientFolder = "RevisionTheatre"
End If


'Check to see if this is a Comp Order. If so, skip the survey.
If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If


If Clean(Request("FormName")) = "Continue" Then    
    Call Continue    
Else
   Call DonationCheck    
End If


'===============================================

Sub DonationCheck

DonationFound = False

'Check if the donation item number is in the current order
SQLMemberDonation = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) WHERE OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & " "
Set rsMemberDonation = OBJdbConnection.Execute(SQLMemberDonation)
If Not rsMemberDonation.EOF Then 'it is in order
    DonationFound = True
    DonationItemNo = rsMemberDonation("ItemNumber")
End If
rsMemberDonation.Close
Set rsMemberDonation = nothing


'Check if the donation item number was purchased in the past year
SQLMemberBefore = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber")) & " ORDER BY OrderLine.ItemNumber"
Set rsMemberBefore = OBJdbConnection.Execute(SQLMemberBefore)
If Not rsMemberBefore.EOF Then
    DonationFound = True
    DonationItemNo = rsMemberBefore("ItemNumber")
End If
rsMemberBefore.Close
Set rsMemberBefore = nothing


If DonationFound Then 
	Call ApplyDiscount
Else
	Call Continue
End If


End Sub 'DonationCheck

'==============================

Sub ApplyDiscount

DiscountApplied = "N"

SQLActCount = "SELECT COUNT(DISTINCT ActCode) AS ActCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & " AND ActCode IN (" & ActCodeList & ")"
Set rsActCount = OBJdbConnection.Execute(SQLActCount)
ActCount = rsActCount("ActCount")
rsActCount.Close
Set rsActCount = nothing

If ActCount = ActTier1 Then
	DiscountAmount = DiscountTier1
ElseIf ActCount = ActTier2 Then
	DiscountAmount = DiscountTier2
ElseIf ActCount = ActTier3 Then
    DiscountAmount = DiscountTier3
Else
    DiscountAmount = 0
End If

'Standard Discount after Date 1
If Now() > CDate(Date1) Then                    
    DiscountAmount = (DiscountAmount) 
End If

'Discount drops by 10% after Date 2  
If Now() > CDate(Date2) Then               
    DiscountAmount = (DiscountAmount - .10) 
End If

'Discount drops by 20% after Date 3     
If Now() >  CDate(Date3) Then         
    DiscountAmount = (DiscountAmount - .20) 
End If

If DiscountAmount > 0 Then

    SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & DiscountAmount & ", DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemNumber IN (SELECT ItemNumber FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE Event.SurveyNumber = " & SurveyNumber & ")"
    Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)

    Call DBClose(OBJdbConnection)
    
    DiscountApplied = "Y"
	
    Call WarningPage(ActCount, DiscountAmount)
Else
    Call Continue
End If


End Sub 'ApplyDiscount

'=======================================

Sub WarningPage(ActCount, DiscountAmount)

Percentage = (DiscountAmount * 100)

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<title>Ticket Sales</title>

<style type="text/css">
body
{
line-height: 1.6em;
}
#rounded-corner
{
	font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
	font-size: small;
	margin: 45px;
	width: 500px;
	text-align: center;
	border-collapse: collapse;
}
#rounded-corner thead th.rounded-left
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Images/corner_nw.gif') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.rounded-right
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Images/corner_ne.gif') right -1px no-repeat;
    text-align: left;
}
#rounded-corner th.category
{
	padding: 8px;
	font-weight: strong;
	font-size: medium;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner td.data
{
	padding: 8px;
	font-weight: normal;
	font-size: small;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
	border-top: 1px solid;
	border-color: #ffffff;
}
#rounded-corner td.header
{
text-align: right;
}
#rounded-corner td.labelcell
{
text-align: right;
border-style: none;
}
</style>

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" NAME="Survey" >
<input type="hidden" name="FormName" value="Continue">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">


<! -- Table Begin -- >
    <table id="rounded-corner" summary="surveypage">
    <thead>
	    <tr>
    	    <th scope="col" class="rounded-left"></th>
    	    <th scope="col" class="category">Congratulations Member!</th>
    	    <th scope="col" class="rounded-right"></th>
        </tr>
   </thead>
   <tbody>
        <tr>
            <td colspan= "3" class="data">
            <br>
            <br>
            <br>
             Your <%= ActCount %>  Act Season Subscription purchase qualifies for a <%= Percentage %>% discount.<br>
            <br>
            <br>
            <br />            
            </td>
        </tr>
        <tr>
        	<td class="rounded-foot-left">&nbsp;</td>
        	<td>&nbsp;</td>
        	<td >&nbsp;</td>
        </tr>
    	<tr>
        	<td  colspan="3">
       
        	</td>
        </tr>
        	<td  class="footer-bottom" colspan = "3">
            <INPUT TYPE="submit" VALUE="Continue"></FORM>
            </td>
        </tr>
   </tbody>
   </table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>

</html>

<%

End Sub ' SurveyForm

'=======================================

Sub Continue

    Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If
    
End Sub 'Continue

'=======================================

%>

