<%

'CHANGE LOG - Inception
'SSR 2/24/2014 - Version 5 of Invoice Format Template, reduced number of required variables for custom invoice
'SSR 12/29/15 - Updated to allow override of organization name.
'LSP 08/11/16 - add image

%>

<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->
<%

'==================================================================================

'Invoice Variables

OrganizationName = ""
'OPTIONAL - enter alternate organization name to overide organization name in database.

StreetAddress = ""
'Street Address. If this is a 2 line street address use <BR> between the two lines

CityStateZip = ""
'City, State and Zip Code

LogoFileName = ""
'logo file should be saved in either Invoice\Images folder

ClientDirectory = ""

InvoiceEmailAddress = ""
'OPTIONAL - enter email address to overide the org's customer service email.

InvoicePhoneNumber = "" 
'OPTIONAL - enter phone number to use on invoice, otherwise phone number will not be listed.

'-----------------------------------------------------------------------------------

'Get Organization Information
SQLEmail = "SELECT DISTINCT Organization.OrganizationNumber, Organization.Organization, OrganizationOptions.OptionValue AS CustomerServiceEmail FROM OrderHeader (NOLOCK)  INNER JOIN  OrderLine (NOLOCK)  ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK)  ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN  Event  (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK)  ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber LEFT JOIN  OrganizationOptions (NOLOCK) ON Organization.OrganizationNumber = OrganizationOptions.OrganizationNumber WHERE  OrderHeader.OrderNumber = " & Clean(Request("OrderNumber")) & " AND OrganizationVenue.Owner = 1 AND OrganizationOptions.OptionName = 'CustomerServiceEmailAddress'"
Set rsEmail = OBJdbConnection.Execute(SQLEmail)
	OrganizationNumber =  rsEmail("OrganizationNumber") 
	CustomerServiceEmail = rsEmail("CustomerServiceEmail")
	If  OrganizationName = "" Then
		OrganizationName =  rsEmail("Organization") 
	End If
rsEmail.Close
Set rsEmail = nothing


'Get Email Address
If InvoiceEmailAddress = "" Then
	If CustomerServiceEmail <> "" Then
		 EmailContact = " via e-mail at " & CustomerServiceEmail
    Else
		EmailContact = ""
	End If
Else
	EmailContact = " via e-mail at " & InvoiceEmailAddress
End If


'Get Phone Number
If InvoicePhoneNumber <> "" Then
	PhoneContact = " by calling " & InvoicePhoneNumber
	If EmailContact <> "" Then
		PhoneContact = " or by calling " & InvoicephoneNumber
	End If
End If


'Get Customer Information
SQLOrderLine = "SELECT Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & Clean(Request("OrderNumber")) & " AND OrderLine.LineNumber = " & Clean(Request("LineNumber"))
Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)

If Not rsOrderLine.EOF Then

	ShipCountry = UCase(rsOrderLine("ShipCountry"))
	Select Case ShipCountry
		Case "UNITED STATES", "UNITED STATES OF AMERICA", "US", "USA", "U.S.A."
			ShipCountry = ""
		Case Else
			ShipCountry = "<BR>" & ShipCountry
	End Select

	Response.Write "<BR><BR><BR><TABLE border=0 WIDTH=750><TR><TD align=""center"" WIDTH=""350""><IMG SRC=""/clients/artistseriesconcerts/invoice/images/logo.jpg"" height=""125""></TD></TR></TABLE><BR><BR><BR><BR>"
	Response.Write "<TABLE border=0 WIDTH=750><TR><TD WIDTH=""75"">&nbsp;</TD><TD WIDTH=""350""><B>Shipping Information</B></TD><TD WIDTH=""325""><B>Billing Information</B></TD></TR>"
	Response.Write "<TR><TD>&nbsp;</TD><TD>" & PCase(rsOrderLine("ShipFirstName")) & " " & PCase(rsOrderLine("ShipLastName")) & "<BR>" & PCase(rsOrderLine("ShipAddress1")) & "<BR>" & vbCrLf
	If rsOrderLine("ShipAddress2") <> "" Then
		Response.Write PCase(rsOrderLine("ShipAddress2")) & "<BR>" & vbCrLf
	End If
	Response.Write PCase(rsOrderLine("ShipCity")) & ", " & rsOrderLine("ShipState") & " " & PCase(rsOrderLine("ShipPostalCode")) & PCase(ShipCountry) & "</TD><TD>" & PCase(rsOrderLine("FirstName")) & " " & PCase(rsOrderLine("LastName")) & "<BR>" & PCase(rsOrderLine("Address1")) & "<BR>" & vbCrLf
	If rsOrderLine("Address2")<> "" Then
		Response.Write PCase(rsOrderLine("Address2")) & "<BR>" & vbCrLf
	End If
	Response.Write PCase(rsOrderLine("City")) & ", " & rsOrderLine("State") & " " & PCase(rsOrderLine("PostalCode")) & "</TD></TR></TABLE><BR><BR>" & vbCrLf
	Response.Write "<TABLE border=0 WIDTH=""750""><TR><TD>Dear " & PCase(rsOrderLine("ShipFirstName")) & " " & PCase(rsOrderLine("ShipLastName")) & ", <BR><BR>Thank you for purchasing tickets from " & OrganizationName & ".&nbsp;&nbsp;The details of your order are listed below.&nbsp;&nbsp;For questions regarding this order, contact " & OrganizationName & "" & EmailContact & " or call 941-306-1202<BR><BR>" & vbCrLf
	

Else

	ErrorLog("Invoice Format - Order Number = " & Clean(Request("OrderNumber")) & " | Line Number = " & Clean(Request("LineNumber")))

End If

rsOrderLine.Close
Set rsOrderLine = nothing

OBJdbConnection.Close
Set OBJdbConnection = nothing

'-----------------------------

FUNCTION  PCase(strIn) 
strOut = "" 
boolUp = True 	
aLen =  Len(strIn)  
If len(aLen) > 0 Then 
For i = 1 To Len(strIn) 
c = Mid(strIn, i, 1)
If c = " " or c = "'" or c = "-"  then 
strOut = strOut & c 
boolUp = True 
Else 
If boolUp Then 
tc = Ucase(c) 
Else 
tc = LCase(c) 
End If 
strOut = strOut & tc 
boolUp = False 
End If 
Next 
End If
PCase = strOut 
END FUNCTION

'-----------------------------

FUNCTION GetFilePath()
Dim strPath
Dim aryPath
strPath = Request.ServerVariables("SCRIPT_NAME")
aryPath = Split(strPath, "/")
aryPath(UBound(aryPath,1)) = ""
GetFilePath = Join(aryPath, "/")
END FUNCTION

'-----------------------------


%>  