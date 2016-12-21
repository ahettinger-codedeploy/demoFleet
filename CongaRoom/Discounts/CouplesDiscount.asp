<%

'CHANGE LOG - Update
'SSR 3/21/2012
'Discount was missing the variable PackageCount

'CHANGE LOG - Inception
'SSR 3/19/2012


%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'========================================

'The Conga Room (2700)

'Couple Discount. Purchase tickets in mulitples of 2 for discount.


'Tego Calderon: ( Event Code: 451344 )
'Valid in SectionCode  GASRO Only
'Reg GA is $37.50
'New Price = $35/Ticket

'David Calzado Y Su Charanga Habanera: ( Event Code: 454081 )
'Reg GA is $30
'New Price = $25/Ticket
 
'Jose Alberto “EL Canario” ( Event Code: 453984 )
'Reg GA is $25
'New Price = $17.50/Ticket

PackageSection = "GASRO"
PackageCount = 2

'===========================================

SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND SectionCode = '" & PackageSection & "' AND Seat.EventCode = " & EventCode
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

                            Select Case SectionCode
                                Case "GASRO"

                                Select Case EventCode
                                    Case 451344 
                                        NewPrice = 35
                                    Case 454081 
                                        NewPrice = 25
                                   Case 453984
                                        NewPrice = 17.50
                                End Select
               
                                If Price > NewPrice Then
	                                DiscountAmount = Price - NewPrice
	                                AppliedFlag = "Y"
                                End If

                End Select

		End If
			
	End If
		
End If
						
rsEventCount.Close
Set rsEventCount = nothing




Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>