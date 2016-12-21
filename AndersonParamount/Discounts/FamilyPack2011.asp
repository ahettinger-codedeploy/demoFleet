<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%


'===========================================
'Anderson Paramount Theatre Centre & Ballroom (10/20/2011)
'4 Ticket Package Discount

'Purchase tickets in packages of 4
'Package price is $30.00 

'All tickets in the package from same event code
'No change in the per ticket service fees.
'Manual discount code entry required

PackageCount = 4
PackagePrice = 30.00

'===========================================


If AllowDiscount = "Y" Then 'It's okay to apply to this order.

SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.SeatTypeCode = " & SeatTypeCode & " AND Seat.SectionCode NOT IN ('ADAOC','ADAOA','ORCBF','ORCCF','ORCAF') AND Seat.EventCode = " & EventCode
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

If Not rsEventCount.EOF Then

	If rsEventCount("SeatCount") >= PackageCount Then 

		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

		If Int(rsDiscCount("LineCount") / PackageCount) < Int(rsEventCount("SeatCount") / PackageCount) Then 
		
	            'Count number of tickets which have been given a discount
                SQLCount = "SELECT COUNT(OrderLine.ItemNumber) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
                Set rsCount = OBJdbConnection.Execute(SQLCount)
                Count = rsCount("AppliedCount")
                rsCount.Close
                Set rsCount = nothing 

		        Remainder = Count MOD PackageCount
		        If Remainder = PackageCount - 1 Then 
		            NewPrice = PackagePrice - ((PackageCount - 1) * Round(PackagePrice/PackageCount, 2))
		        Else
			        NewPrice = Round(PackagePrice/PackageCount, 2)
		        End If
               
                If Price > NewPrice Then
	                DiscountAmount = Price - NewPrice
	                AppliedFlag = "Y"
                End If

        	    NewSurcharge = CDbl(Clean(Request("NewSurcharge")))
			    If Request("NewSurcharge") <> "" Then
				    Surcharge = NewSurcharge
			    Else
				    If Request("CalcServiceFee") <> "N" Then
					    Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
				    End If
			    End If

		End If
			
	End If
		
End If
						
rsEventCount.Close
Set rsEventCount = nothing

End If


Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>