<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->
<%


'Initialize Variables
'==================================================================================

OrganizationNumber = 1946
'Organization Number

'Organization Name = automatically pulled from database

StreetAddress = "P.O. Box 4432"
'Street Address. If this is a 2 line street address use <BR> between the two lines

CityStateZip = "Charleston, WV 25364"
'City, State and Zip Code

ClientDirectory = "ACRProductions" 
'Name of Client Directory where Invoice.asp or InvoiceFormat.asp is located

PhoneNumber = "(800) 597-8624." 
'Customer Service Phone Number. If org doesn't have a number, use PhoneNumber = ""

'Email Address = automatically pulled from database

LogoName = "logo.jpg"
'Organization Logo. Logo should be saved to /Clients/ClientDirectory/Invoice/ directory
'If org doesn't have a logo, use LogoName = ""

'===================================================================================



'Get Organization Name
SQLOrgName = "SELECT Organization FROM Organization (NOLOCK) WHERE OrganizationNumber = " & OrganizationNumber & ""
Set rsOrgName = OBJdbConnection.Execute(SQLOrgName)
OrgName = rsOrgName("Organization")
rsOrgName.Close
Set rsOrgName = nothing


'Get Customer Service Email Address
SQLEmail = "SELECT OptionValue FROM OrganizationOptions WITH (ROWLOCK) WHERE OrganizationNumber = " & OrganizationNumber & " AND OptionName = 'CustomerServiceEmailAddress'"
Set rsEmail = OBJdbConnection.Execute(SQLEmail)


'Add Email Address to Invoice			
If Not rsEmail.EOF Then
	EmailAddress = "email us at " & rsEmail("OptionValue") & " " & vbCrLf
Else
	EmailAddress = ""
End If
			
rsEmail.Close
Set rsEmail = nothing



'Add Phone Number to Invoice
If PhoneNumber <> "" Then
PhoneNumber = "call " & PhoneNumber & " " & vbCrLf
	If EmailAddress <> "" Then
		EmailAddress = "" & EmailAddress & " or " & vBCrLf
	End If
End If


'Add Logo to Invoice
If LogoName <> "" Then
    Logo = "<IMG SRC=""/Clients/" & ClientDirectory & "/Invoice/" & LogoName & """ HEIGHT=""120"">"
Else
   Logo = "<IMG SRC=""/Images/Clear.gif"" HEIGHT=""120"">"
End If
 
 
    
'Get Customer Information
SQLCustInfo = "SELECT Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & Clean(Request("OrderNumber")) & " AND OrderLine.LineNumber = " & Clean(Request("LineNumber"))
Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

If Not rsCustInfo.EOF Then

	Response.Write "<HTML><HEAD><TITLE>Invoice Format</TITLE>" & vbCrLf

'Font Choices (if needed to match Logo font)
	
'Arial, Arial, Helvetica, sans-serif
'Comic Sans MS, Comic Sans MS5, cursive 
'Courier New, Courier New, Courier6, monospace  
'Georgia, Georgia, serif 
'Impact, Impact5, Charcoal6, sans-serif
'Lucida Console, Monaco5, monospace 
'Palatino Linotype, Book Antiqua3, Palatino6, serif 
'Tahoma, Geneva, sans-serif Tahoma, 
'Times New Roman, Times, serif  
'Trebuchet MS, Helvetica, sans-serif 
'Verdana, Verdana, Geneva, sans-serif 
%>
	
<style type="text/css" media="all">
body {
background: white;
font-family: Arial, Arial, Helvetica, sans-serif;
font-size: 8pt;
}
</style>

<%
	Response.Write "</HEAD>" & vbCrLf
	Response.Write "<BODY leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0>" & vbCrLf
	Response.Write "<BR><BR><TABLE WIDTH=""750""><TR><TD WIDTH=""50"">&nbsp;</TD><TD WIDTH=""400"" VALIGN=""top"">" & OrgName & "<BR>" & StreetAddress & "<BR>" & CityStateZip & "</TD><TD WIDTH=""300"">" & Logo & "</TD></TR></TABLE>"
	Response.Write "<BR><BR><TABLE WIDTH=""750""><TR><TD WIDTH=""50"">&nbsp;</TD><TD WIDTH=""400""><B>Shipping Information</B></TD><TD WIDTH=""300""><B>Billing Information</B></TD></TR>"
	Response.Write "<TR><TD>&nbsp;</TD><TD>" & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & "<BR>" & rsCustInfo("ShipAddress1") & "<BR>" & vbCrLf
	If rsCustInfo("ShipAddress2") <> "" Then
		Response.Write rsCustInfo("ShipAddress2") & "<BR>" & vbCrLf
	End If
	Response.Write rsCustInfo("ShipCity") & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "</TD><TD>" & rsCustInfo("FirstName") & " " & rsCustInfo("LastName") & "<BR>" & rsCustInfo("Address1") & "<BR>" & vbCrLf
	If rsCustInfo("Address2")<> "" Then
		Response.Write rsCustInfo("Address2") & "<BR>" & vbCrLf
	End If
	Response.Write rsCustInfo("City") & ", " & rsCustInfo("State") & " " & rsCustInfo("PostalCode") & "</TD></TR></TABLE><BR><HR>" & vbCrLf
	Response.Write "<CENTER><TABLE WIDTH=""700""><TR><TD>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ", <BR><BR>Thank you for purchasing tickets from " & OrgName & ".&nbsp;&nbsp;Your recently purchased tickets are enclosed. Please review your order information and notify us of any discrepancies. For questions regarding this order, " & EmailAddress & " " & PhoneNumber & "<BR><BR>" & vbCrLf

	Response.Write "</BODY></HTML>" & vbCrLf

Else

	ErrorLog("Invoice Format - Order Number = " & Clean(Request("OrderNumber")) & " | Line Number = " & Clean(Request("LineNumber")))

End If

rsCustInfo.Close
Set rsCustInfo = nothing

OBJdbConnection.Close
Set OBJdbConnection = nothing


%>  