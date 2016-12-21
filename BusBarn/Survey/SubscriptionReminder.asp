<%

'CHANGE LOG - Inception
'SSR 3/29/2011
'Custom Code 

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'========================================

Page = "Survey"
SurveyNumber = 1050
SurveyName = "SubscriptionReminder.asp"

'========================================

'Organization Name

'64420	Shout! The Mod Musical
'64421	Almost, Maine
'64422	Doubt, A Parable
'64423	The Government Inspector
'64424	The Clean House

DIM SeriesAct(5)
SeriesAct(1)="64420"
SeriesAct(2)="64421"
SeriesAct(3)="64422"
SeriesAct(4)="64423"
SeriesAct(5)="64424"

DIM ActImage(5)
ActImage(1)="http://www.busbarn.org/images/logo_showpage_shout.jpg"
ActImage(2)="http://www.busbarn.org/images/logo_showpage_almostmaine.jpg"
ActImage(3)="http://www.busbarn.org/images/logo_showpage_doubt.jpg"
ActImage(4)="http://www.busbarn.org/images/logo_showpage_government.jpg" 
ActImage(5)="http://www.busbarn.org/images/logo_showpage_cleanhouse.jpg" 

SeriesCount = 5

'===============================================

'CSS Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    ClientFolder= "Tix"
Else
    ClientFolder = "busbarn"
End If

'============================================================
 
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

'============================================================

'Skip Survey on Comp Orders

If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If

'============================================================

'Request the form name and process requested action

Select Case Request("FormName")
	Case "AddToCart"
		Call AddToCart
	Case "Continue"
		Call Continue
	Case Else
		Call SurveyForm
End Select

'==========================================================

Sub SurveyForm

ActCount = 0

'Survey Start. Request Form name and process requested action

            For i = 1 to SeriesCount
            
                SQLActCheck = "SELECT Event.ActCode FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE ActCode = " & SeriesAct(i) & " AND OrderHeader.OrderNumber = " & CleanNumeric(Session("OrderNumber"))&""
                Set rsActCheck = OBJdbConnection.Execute(SQLActCheck)
                    
                    If Not rsActCheck.EOF Then 
                                        
                        ActCount = ActCount + 1
                    
                    End If
                    
                rsActCheck.Close
                Set rsActCheck = Nothing        
                    
                
            Next

If ActCount < SeriesCount Then
    Call SurveyDisplay(ActCount)
Else
    Call Continue 
    Exit Sub
End If


End Sub

'===============================================
	
Sub SurveyDisplay(ActCount)

MissingActCount = (SeriesCount-ActCount)

Select Case MissingActCount
    Case  1
        S1 = ""
    Case Else
        S1 = "s"
 End Select


%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<title>Tix.com</title>

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
	width: 600px;
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
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/nw.gif') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/ne.gif') right -1px no-repeat;
    text-align: left;
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
	padding-left: 25px;
	padding-right: 25px;
	padding-top: 15px;
	padding-bottom: 15px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
</style>


</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

    <table id="rounded-corner" summary="surveypage" >
    <thead>
	    <tr>
    	    <th scope="col" class="category-left"></th>
    	    <th scope="col" class="category" colspan="2"><h2>Subscribe and Save!</h2></th>
    	    <th scope="col" class="category-right"></th>
        </tr>        
   </thead>
        <tbody>
        <tr>
            <td class="data" colspan="4">
            <div align="center"> 
            <h3>Add these <%=MissingActCount%> production<%=S1%> to your<br />current order and receive a discount!</h3><br />        
            <%
            
            For i = 1 to SeriesCount
            
                SQLActCheck = "SELECT Event.ActCode FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE ActCode = " & SeriesAct(i) & " AND OrderHeader.OrderNumber = " & CleanNumeric(Session("OrderNumber"))&""
                Set rsActCheck = OBJdbConnection.Execute(SQLActCheck)
                    
                    If rsActCheck.EOF Then 
                                        
                    %>
                    
                    <img src="<%=ActImage(i)%>" width="50%">&nbsp;<br /><br />
                    
                    <%
                    
                    End If
                    
                rsActCheck.Close
                Set rsActCheck = Nothing        
                    
                
            Next
            
            %>
            </div>     
            Bus Barn considers Subscribers family and offers many opportunities for subscribers to feel welcome and appreciated!<br />
            <br />
            <h3>Bus Barn offers Subscribers substantial benefits and opportunities:</h3>
            <ul>
                <li>Substantial savings in the price of tickets</li>
                <li>Easy performance rescheduling by phone</li>
                <li>Advance notice of special events</li>
                <li>Subscribers retain their subscription seats, which are renewable year to year.</li>
                <li>One free ticket is included with every subscription order placed prior to the start of the new season for patrons to bring a friend or family member.</li>
           </ul>
            <br />
            Simply add at least one ticket from each production above to your order and the discount will be taken automatically upon checkout.<br />
            <br />
            We look forward to seeing you this season!
            <br />
            <br />
            </td>
        </tr>
        <tr>
    	    <td class="footer-left">&nbsp;</td>
    	    <td class="footer" colspan="2">&nbsp;</td>
    	    <td class="footer-right">&nbsp;</td>
    	</tr>
        <tr>
            <td colspan="4" align=center>
                <br />
                <form action="<%= SurveyFileName %>" method="post">
                <INPUT TYPE="hidden" NAME="FormName" VALUE="AddToCart">
                <INPUT type="submit" value="Back To Shopping" /></form>
                <br />
                <br />
                <form action="<%= SurveyFileName %>" method="post">
                <INPUT TYPE="hidden" NAME="FormName" VALUE="Continue">
                <input type="submit" value="No Thanks!" />
                </form>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>
        </table>
        
  <!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%

End Sub ' SurveyForm      
        
'==========================================================

Sub AddToCart

    If Session("UserNumber") = "" Then
        Response.Redirect("/ShoppingCart.asp")
    Else
        Response.Redirect("/Management/EventSelection.asp")
    End If

End Sub 'AddToCart

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