<%

'CHANGE LOG
'JAI 6/1/12 - New per ticket discount script.  Combination of Amount, Percentage, and Fixed Price discounts.

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'SQLCampaignLog = "INSERT CampaignLog(CampaignNumber, CustomerNumber, DateOpened, IPAddress) VALUES(" & CleanNumeric(Request("CampaignNumber")) & ", " & CleanNumeric(Request("CustomerNumber")) & ", GETDATE(),'" & Request.ServerVariables("REMOTE_ADDR") & "')"
'Set rsCampaignLog = OBJdbConnection.Execute(SQLCampaignLog)

'--------------------------------------------------------

	ErrorLog("discount start")

	If AllowDiscount = "Y" Then 'It's okay to apply to this order.
	
			If request.queryString("ID") <> "" Then
				sID =  request.queryString("ID")
			End If
			
			ErrorLog("ID:" & sID & "")
			
			ErrorLog(" Session variables:" & Session.Contents.Count & "<BR>")

		  Dim strName
		  Dim iLoop
		  Dim strResult
		   
		   'Use a For Each ... Next to loop through the entire collection
		   
		   ErrorLog("Start Session Contents")
		   For Each strName in Session.Contents
		   
			 'Is this session variable an array?
			 If IsArray(Session(strName)) then
			   'If it is an array, loop through each element one at a time
			 For iLoop = LBound(Session(strName)) to UBound(Session(strName))
			ErrorLog(" " & strName & "(" & iLoop & ") - " & Session(strName)(iLoop) & "<BR>")
			 Next
			 Else
			   'We aren't dealing with an array, so just display the variable
				ErrorLog(" " & strName & " - " & Session.Contents(strName) & "<BR>")
			End If
			 
		   Next
		   ErrorLog("End Session Contents")
		   
			NewPrice = Round(CDbl(Clean(Request("Price"))),2) - 1
		
			If NewPrice < 0 Then
				NewPrice = 0
			End If
		
			DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice

			If NewSurcharge <> "" Then
				Surcharge = NewSurcharge
			ElseIf Request("CalcServiceFee") <> "N" Then
				Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
			End If
		
			AppliedFlag = "Y"
		
	End If	


Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf



%>