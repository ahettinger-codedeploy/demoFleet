<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->
<%
SQLCustInfo = "SELECT Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & Clean(Request("OrderNumber")) & " AND OrderLine.LineNumber = " & Clean(Request("LineNumber"))
Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

If Not rsCustInfo.EOF Then

	Response.Write "<HTML><HEAD><TITLE>Invoice Format</TITLE><BODY leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0>" & vbCrLf

	Response.Write "<BR><BR><TABLE WIDTH=""750""><TR><TD WIDTH=""50"">&nbsp;</TD><TD WIDTH=""400"" VALIGN=""top"">Len Hayko Promotions, LLC<BR>10226 E. Karen Dr<BR>Scottsdale, AZ 85255 </TD><TD WIDTH=""300""><IMG SRC=/PrivateLabel/BallroomBoxing/Invoice/Logo.gif HEIGHT=""120""></TD></TR></TABLE>"
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
	Response.Write "<CENTER><TABLE WIDTH=""700""><TR><TD>Dear " & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & ", <BR><BR>Thank you for purchasing tickets from Len Hayko Promotions, LLC.&nbsp;&nbsp;The details of your order are listed below.  For questions regarding this order, contact us at haykopromotions@aol.com or call (623) 776-6130.<BR><BR>" & vbCrLf

	Response.Write "</BODY></HTML>" & vbCrLf

Else

	ErrorLog("Invoice Format - Order Number = " & Clean(Request("OrderNumber")) & " | Line Number = " & Clean(Request("LineNumber")))

End If

rsCustInfo.Close
Set rsCustInfo = nothing

OBJdbConnection.Close
Set OBJdbConnection = nothing


%>  