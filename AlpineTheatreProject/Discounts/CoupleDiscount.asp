<%

'CHANGE LOG - Inception
'SSR (11/14/2011)
'Custom Discount

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'===============================================

'Alpine Theatre Project 

'Couple CostCo Discount

'The custom Costco discount we are needing is as follows:
'Discount Code: CW2012
'Details: 2 Tier 1 (blue) tickets for a total of $59.99
'Restrictions: Ends 8/19/2012

RequiredSeatType = 1
Expires = "8/19/2012"

PackageCount = 2
PackagePrice = 59.99
PackageSection = "BALC1"

'===========================================

SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND SectionCode = '" & PackageSection & "' AND OrderLine.SeatTypeCode = 1 AND Seat.EventCode = " & EventCode
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




Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>%>