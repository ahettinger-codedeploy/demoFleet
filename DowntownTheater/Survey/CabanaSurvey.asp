<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

Page = "Survey"
SurveyNumber = 922
SurveyName = "CabanaSurvey.asp"

'========================================

'JazzTraxx (12/23/2010)

'Survey restricts purchase single purchase of table seats.
'Patron must purchase all four seats at the Cabana sections.
'Patron must purchase chaise lounges in pairs

'========================================

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

If Session("UserNumber") <>"" Then    
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"    
    TableColumnHeadingBGColor = "99CC99"
    TableColumnHeadingFontColor = "000000"    
    TableDataBGColor = "E9E9E9"
    TableDataFontColor = "#000000"    
    BGColor = "ffffff"
    FontColor = "000000"    
    HeadingFontColor =  "#008400"    
End If


If Clean(Request("FormName")) = "Continue" Then
    Call Continue
Else
    Call SectionCheck
End If

'========================================

Sub SectionCheck

CabanaTickets = False

SQLOrderSeats = "SELECT Seat.EventCode, Section.Section, Seat.SectionCode, COUNT(OrderLine.ItemNumber) AS OrderSeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat') GROUP BY Seat.EventCode, Seat.SectionCode, Section.Section"
Set rsOrderSeats = OBJdbConnection.Execute(SQLOrderSeats)

    Do Until rsOrderSeats.EOF
    
        OrderSectionCode = rsOrderSeats("SectionCode")
                    
           If Left(OrderSectionCode,3) = "CBN"  Then
           CabanaTickets = True
           End If
            
    rsOrderSeats.MoveNext    
    Loop
    
rsOrderSeats.Close    
Set rsOrderSeats = nothing
            
If  CabanaTickets Then
    Call CabanaCheck
    Exit Sub
Else
   Call SectionCheck2
   Exit Sub
End If 
    
End Sub	

'========================================

Sub SectionCheck2

ChaiseTickets = False

SQLOrderSeats = "SELECT Seat.EventCode, Section.Section, Seat.SectionCode, COUNT(OrderLine.ItemNumber) AS OrderSeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat') GROUP BY Seat.EventCode, Seat.SectionCode, Section.Section"
Set rsOrderSeats = OBJdbConnection.Execute(SQLOrderSeats)

    Do Until rsOrderSeats.EOF
    
        OrderSectionCode = rsOrderSeats("SectionCode")
                    
           If Left(OrderSectionCode,3) = "CHS"  Then
           ChaiseTickets = True
           End If
            
    rsOrderSeats.MoveNext    
    Loop
    
rsOrderSeats.Close    
Set rsOrderSeats = nothing
            
If  ChaiseTickets Then
    Call ChaiseCheck
    Exit Sub
Else
   Call Continue
   Exit Sub
End If 
    
End Sub	
				
'=================================

Sub CabanaCheck           


SQLOrderSeats = "SELECT Seat.EventCode, Section.Section, Seat.SectionCode, COUNT(OrderLine.ItemNumber) AS OrderSeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat') GROUP BY Seat.EventCode, Seat.SectionCode, Section.Section"
Set rsOrderSeats = OBJdbConnection.Execute(SQLOrderSeats)

    Do Until rsOrderSeats.EOF

    SQLSectionSeats = "SELECT COUNT(ItemNumber) AS SectionSeatCount FROM Seat (NOLOCK) WHERE EventCode = " & rsOrderSeats("EventCode") & " AND SectionCode = '" & rsOrderSeats("SectionCode") & "'"
    Set rsSectionSeats = OBJdbConnection.Execute(SQLSectionSeats)
    	
        OrderSection = rsOrderSeats("Section")
        OrderSectionCode = rsOrderSeats("SectionCode")
        OrderEventCode = rsOrderSeats("EventCode")	
        OrderSeatCount = rsOrderSeats("OrderSeatCount")
        SectionSeatCount = rsSectionSeats("SectionSeatCount")

	        If OrderSeatCount < SectionSeatCount Then 'Not all seats were selected.  Go to warning page	
		        rsSectionSeats.Close
		        Set rsSectionSeats = nothing		
		        Call CabanaWarningPage(OrderSeatCount, SectionSeatCount, OrderSection, OrderEventCode, OrderSectionCode)		
		        Exit Sub
		    Else
		        Call SectionCheck2
		        Exit Sub		        		
	        End If
	            
    				
	rsSectionSeats.Close
	Set rsSectionSeats = nothing
    	
	rsOrderSeats.MoveNext

    Loop
    		
rsOrderSeats.Close
Set rsOrderSeats = nothing

OBJdbConnection.Close
Set OBJdbConnection = nothing

    
End Sub	


'=================================

Sub ChaiseCheck 

SQLOrderSeats = "SELECT Seat.EventCode, Section.Section, Seat.SectionCode, COUNT(OrderLine.ItemNumber) AS OrderSeatCount, Right(Seat.Image,5) AS Image FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat') GROUP BY Seat.EventCode, Seat.SectionCode, Section.Section, Seat.Image"
Set rsOrderSeats = OBJdbConnection.Execute(SQLOrderSeats)

    Do Until rsOrderSeats.EOF

    SQLSectionSeats = "SELECT COUNT(ItemNumber) AS SectionSeatCount FROM Seat (NOLOCK) WHERE EventCode = " & rsOrderSeats("EventCode") & " AND Right(Seat.Image,5) = '" & rsOrderSeats("Image") & "'"
    Set rsSectionSeats = OBJdbConnection.Execute(SQLSectionSeats)    
      	
        OrderSeatCount = rsOrderSeats("OrderSeatCount")
        SectionSeatCount = rsSectionSeats("SectionSeatCount")            
        
            If OrderSeatCount < SectionSeatCount Then 'Not all seats were selected.  Go to warning page	
 
	            
	            'Determine the missing seat
                SQLActualSeat = "Select Seat.Seat, Seat.OrderNumber From Seat (NOLOCK) Where EventCode = " & rsOrderSeats("EventCode") & " AND Right(Seat.Image,5) = '" & rsOrderSeats("Image") & "'"
                Set rsActualSeat = OBJdbConnection.Execute(SQLActualSeat)   
                
                 Do Until rsActualSeat.EOF
                    
                    If rsActualSeat("OrderNumber") = Session("OrderNumber") Then
                         OrderSeat = rsActualSeat("Seat")  
                    Else
                        MissingSeat = rsActualSeat("Seat") 
                    End If
                            
            	rsActualSeat.MoveNext

                Loop
                                  
                rsActualSeat.Close
	            Set rsActualSeat = nothing               
                 
                OrderSection = rsOrderSeats("Section")
                OrderEventCode = rsOrderSeats("EventCode")
                OrderSectionCode = rsOrderSeats("SectionCode")        
                 
	            rsSectionSeats.Close
	            Set rsSectionSeats = nothing	
	            
	            Call CHAISEWarningPage(MissingSeat,OrderSeat,OrderSection,OrderEventCode,OrderSectionCode)		
	            Exit Sub
	        Else
	            Call Continue	
	            Exit Sub		
            End If
            
   
        				
	    rsSectionSeats.Close
	    Set rsSectionSeats = nothing
    	
	rsOrderSeats.MoveNext

    Loop
    		
rsOrderSeats.Close
Set rsOrderSeats = nothing

    OBJdbConnection.Close
    Set OBJdbConnection = nothing

    Call Continue
    
End Sub	


'=================================


Sub CABANAWarningPage(OrderSeatCount, SectionSeatCount, OrderSection, OrderEventCode, OrderSectionCode)

RemainingSeatCount = (SectionSeatCount - OrderSeatCount)

If OrderSeatCount = 1 Then
	 s1 = ""
Else
	 s1 = "s"
End If

If RemainingSeatCount = 1 Then
    RemainingSeatCount = ""
	s2 = ""
Else
	 s2 = "s"
End If


If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

%>

<html>
<head>
<title><%= title %></title>

<link rel="stylesheet" type="text/css" href="/CSS/CustomSurveyCSS.asp" />

</head>
<body>

<%= strBody %>

<!--#include virtual="TopNavInclude.asp"-->

<div class="category">
SORRY
</div>

<div class="data">
You have only selected <b><%= OrderSeatCount %> seat<%=s1%></b> at <%= OrderSection %>.<BR>
<br />
Please select the remaining <%= RemainingSeatCount %> seat<%=s2%> in order to complete your purchase.<br /><br />
<%
If Session("UserNumber") = "" Then 'Internet order
%> 
<CENTER>
  <FORM ACTION="/Section.asp?Event=<%= OrderEventCode %>&Section=<%= OrderSectionCode %>&Details=NO" METHOD="POST" id="form5" name="form2"/>
    <INPUT TYPE="submit" VALUE="Add Additional Seats" id="Submit5" name="form2" style="width:12em;">
  </FORM>   

  <FORM ACTION="/ShoppingCart.asp" METHOD="POST" id="form6" name="form1">
    <INPUT TYPE="submit" VALUE="View Shopping Cart" id="Submit6" name="form1" style="width:12em;" />
  </FORM>
</CENTER>
<%
Else 'Box Office Order
%> 
<CENTER>
<FORM ACTION="/Management/SectionRowSelect.asp?Event=<%= OrderEventCode %>&Section=<%= OrderSectionCode %>&Details=NO" METHOD="POST" id="form7" name="form1" />
<INPUT TYPE="submit" VALUE="Add Additional Seats" id="Submit7" name="form1" style="width:12em;">
</FORM>

<FORM ACTION="/Management/ShoppingCart.asp" METHOD="POST" id="form8" name="form2">
<INPUT TYPE="submit" VALUE="View Shopping Cart" id="Submit8" name="form2" style="width:12em;" />
</FORM>
</CENTER>   
<%
End If
%> 
</div>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%		
	
End Sub 'Warning Page

'=================================


Sub CHAISEWarningPage(MissingSeat,OrderSeat,OrderSection,OrderEventCode,OrderSectionCode)	

If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

%>

<html>
<head>
<title><%= title %></title>

<style type="text/css">
.category 
{ 
width: 640px;	
padding-top:15px; 
padding-bottom:15px; 
padding-left:10px; 
padding-right:0px; 
background-color: <%= TableCategoryBGColor %>;

text-align: left;
font-size: medium;
font-weight: 700;
color: <%= TableCategoryFontColor %>;

border-width:1px;
border-style:solid;
border-color:<%= BGColor %>;
border-collapse:collapse;
}
.column
{ 
padding-top:0px; 
padding-bottom:0px; 
padding-left:5px; 
padding-right:5px; 
background-color: <%= TableColumnHeadingBGColor %>;

text-align:center;
font-size: x-small;
font-weight: 400;
color: <%= TableColumnHeadingFontColor %>;

border-width:1px;
border-style:solid;
border-color:<%= BGColor %>;
border-collapse:collapse;
}
.data
{ 
width:635px;	
padding-top:10px; 
padding-bottom:10px; 
padding-left:10px; 
padding-right:0px; 
background-color: <%= TableDataBGColor %>;

text-align: left;
font-size: x-small;
font-weight: 400;
color: <%= TableDataFontColor %>;

border-width:1px;
border-style:solid;
border-color:<%= BGColor %>;
border-collapse:collapse;
}
.schedule
{
padding-top:5px; 
padding-bottom:0px; 
padding-left:5px; 
padding-right:5px;
background-color: <%= BGColor %>;
	
text-align: left;
font-size: x-small;
font-weight: 400;
color: <%= FontColor %>;

border-width:1px;
border-style:solid;
border-color:<%= BGColor %>;
border-collapse:collapse;
}
.header
{
padding-top:20px; 
padding-bottom:5px; 
padding-left:0px; 
padding-right:0px;
background-color: <%= BGColor %>;

text-align: center;
font-size: small;
font-weight: 600;
color: <%= FontColor %>;
}
</style>

</head>
<body>

<%= strBody %>

<!--#include virtual="TopNavInclude.asp"-->

<table width="90%" cellpadding="10" cellspacing="3">
    <tr>
        <td align="center" class="category">
        SORRY
        </td>
    </tr> 
    <tr>
        <td class="data" >
        You have selected <%= OrderSection %> seat <%= OrderSeat %>.<BR>
        <br />
        Seats in this section must be purchased in pairs.<br />
        <br />
        To complete your transaction please add <b> <%= OrderSection %> seat <%= MissingSeat %></b> to your order.<br />
        <br />
        </td>
     </tr>
     <tr>
         <td class="schedule">
            <%
            If Session("UserNumber") = "" Then 'Internet order
            %> 
            <CENTER>
              <FORM ACTION="/Section.asp?Event=<%= OrderEventCode %>&Section=<%= OrderSectionCode %>&Details=NO" METHOD="POST" id="form1" name="form1"/>
                <INPUT TYPE="submit" VALUE="Add Additional Seats" id="Submit1" name="form1" style="width:12em;">
              </FORM>   

              <FORM ACTION="/ShoppingCart.asp" METHOD="POST" id="form2" name="form2">
                <INPUT TYPE="submit" VALUE="View Shopping Cart" id="Submit2" name="form2" style="width:12em;" />
              </FORM>
            </CENTER>
            <%
            Else 'Box Office Order
            %> 
            <CENTER>
            <FORM ACTION="/Management/SectionRowSelect.asp?Event=<%= OrderEventCode %>&Section=<%= OrderSectionCode %>&Details=NO" METHOD="POST" id="form3" name="form3" />
            <INPUT TYPE="submit" VALUE="Add Additional Seats" id="Submit3" name="form3" style="width:12em;">
            </FORM>

            <FORM ACTION="/Management/ShoppingCart.asp" METHOD="POST" id="form4" name="form4">
            <INPUT TYPE="submit" VALUE="View Shopping Cart" id="Submit4" name="form4" style="width:12em;" />
            </FORM>
            </CENTER>   
            <%
            End If
            %> 
         </td>
    </tr>
 </table>


<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%		
	
End Sub 'CHAISEWarningPage

'========================================

Sub Continue

If Session("OrderNumber") <> "" Then
		
	If Session("UserNumber") = "" Then
		'REE 4/19/3 - Modified to use Session Variable for SurveyComplete
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Ship.asp")
	Else
		'REE 4/19/3 - Modified to use Session Variable for SurveyComplete
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Management/AdvanceShip.asp")
	End If
		
Else 'No Session Order Number
	
	If Session("UserNumber") = "" Then
		Session.Contents.Remove("OrderNumber") 
		OBJdbConnection.Close
		Set OBJdbConnection = nothing
		Response.Redirect("/Default.asp")
	Else
		Session.Contents.Remove("OrderNumber") 
		OBJdbConnection.Close
		Set OBJdbConnection = nothing
		Response.Redirect("http://" & Request.ServerVariables("SERVER_NAME") & "/Management/ClearOrderNumber.asp")
	End If

End If

End Sub 'Continue

'=================================

%> 
