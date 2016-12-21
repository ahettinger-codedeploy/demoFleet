<!--#INCLUDE virtual=GlobalInclude.asp -->
<!--#INCLUDE virtual="dbOpenInclude.asp"-->

<%

'Make sure the request is coming from Tix
IPAddress = Request.ServerVariables("REMOTE_ADDR")
If IPAddress = "127.0.0.1" Then 'The request is from Tix

	ItemNumber = CleanNumeric(Request("ItemNumber"))

	Randomize()
	TixNum = CStr(ItemNumber * 3) & CStr(Int((999999999999 - 100000000000 + 1) * Rnd + 100000000000))
    
    TixNum = Left(TixNum, 20)	
    
	Response.Write "<TICKETNUMBER>" & TixNum & "</TICKETNUMBER>"
	
Else

	ErrorLog("E-Ticket Add Error - Unauthorized IP Address Attempt = " & IPAddress)

End If


%>


  