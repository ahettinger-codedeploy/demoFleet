<!--#INCLUDE virtual="PrivateLabelInclude.asp" -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<%
Page = "Seating"
ProgramName = "Section"
%>
<html>
<HEAD>
<title><%= Title %></title>

<SCRIPT LANGUAGE="JavaScript">    

<!-- Hide code from non-js browsers

function validateForm() {
	formObj = document.EventForm;
	var yes = 0;
	for (var i=0;i<2;i++) {
	    if (eval("formObj.Event[i].checked") == true)
	        yes++;
		}
	if (yes == 0) {
		alert("Please select a restaurant.");
		return false;
		}
  if (formObj.SeatCount.value == "") {
      alert("Please enter the number of dinners you would like to purchase.");
      formObj.SeatCount.focus();
      return false;
      }
	var emailReg = "\\D";
	var regex = new RegExp(emailReg);
	if (regex.test(formObj.SeatCount.value)==true){
		alert("Please enter a valid dinner quantity.")
		return false;
		}
    }    

// end hiding -->
</SCRIPT>

</HEAD>
<%= strBody %>
<center>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->

<br>

<%
If Session("UserNumber") = "" Then
	EventPage = "Event.asp"
Else
	EventPage = "/Management/Event.asp"
End If
%>

<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B>Would you like to add a dinner to your purchase?</B></FONT><BR>
<BR>
<FORM ACTION="<%= EventPage %>" METHOD="post" onSubmit='return validateForm()' Name="EventForm">
<INPUT TYPE="hidden" NAME="FormName" VALUE="EventForm">
<TABLE WIDTH="400">
<TR><TD ALIGN="right"><INPUT TYPE="radio" NAME="Event" VALUE="20630"></TD><TD><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">Tratorria Portobello</FONT></TD><TD ALIGN="right"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">$30.00</FONT></TD></TR>
<TR><TD ALIGN="right"><INPUT TYPE="radio" NAME="Event" VALUE="20631"></TD><TD><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">Metropolitan Cafe</FONT></TD><TD ALIGN="right"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">$30.00</FONT></TD></TR>
</TABLE>
<BR>
<BR>
<TABLE WIDTH="400">
<TR><TD ALIGN="right"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">Quantity: </FONT></TD><TD ALIGN="left"><INPUT TYPE="text" NAME="SeatCount" SIZE="5"></TD></TR>
</TABLE>
<BR>
<INPUT TYPE="submit" VALUE="Add To Cart"></FORM>

<BR>
<%

Session("SurveyComplete") = Session("OrderNumber")

If Session("UserNumber") = "" Then
	ShipPage = "Ship.asp"
Else
	ShipPage = "/Management/AdvanceShip.asp"
End If

Response.Write "<FORM ACTION=""" & ShipPage & """ METHOD=""post""><INPUT TYPE=""submit"" VALUE=""No Thanks""></FORM>" & vbCrLf

%>

<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->

</BODY>
</HTML>
