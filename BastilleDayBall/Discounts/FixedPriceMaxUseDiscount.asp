<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->


<%

'Committee of French Speaking Societies (6/14/2010)
'===================================================
'Fixed Price Discount with Max System Usage by Ticket Type

'SeatCode   Ticket Type    Fixed Price     Max
'4449       Bleu ticket    $15.00          100
'4450       Blanc ticket   $75.00          50
'4451       Rouge ticket   $150.00         25


OneSeatCode = 4449
OnePrice = 15
OneSystemMax = 10

TwoSeatCode = 4450
TwoPrice = 75
TwoSystemMax = 95

ThreeSeatCode = 4451
ThreePrice = 150
ThreeSystemMax= 200

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

    'Count the number of tickets which have already been discounted
    SQLAppliedCount = "SELECT DISTINCT (SELECT Count(OrderLine.LineNumber) FROM OrderLine WHERE OrderLine.SeatTypeCode = 4449 AND OrderLine.OrderNumber NOT IN (" & OrderNumber & ")) as OneTicketApplied, (SELECT Count(OrderLine.LineNumber) FROM OrderLine WHERE OrderLine.SeatTypeCode = 4450 AND OrderLine.OrderNumber NOT IN (" & OrderNumber & ")) as TwoTicketApplied, (SELECT Count(OrderLine.LineNumber) FROM OrderLine WHERE OrderLine.SeatTypeCode = 4451 AND OrderLine.OrderNumber NOT IN (" & OrderNumber & ")) as ThreeTicketApplied FROM OrderLine (NOLOCK) WHERE OrderLine.DiscountTypeNumber = 46229 AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') AND OrderLine.StatusDate >= '6/1/2010' Group by Orderline.SeatTypeCode"
    Set rsAppliedCount = OBJdbConnection.Execute(SQLAppliedCount)
    

    'Determine the number of tickets on order which can be discounted
    SQLDiscCount = "SELECT DISTINCT (SELECT Count(OrderLine.LineNumber) FROM OrderLine WHERE OrderLine.SeatTypeCode = " & OneSeatCode & ") as OneDiscCount, (SELECT Count(OrderLine.LineNumber) FROM OrderLine WHERE OrderLine.SeatTypeCode = " & OneSeatCode & ") as TwoDiscCount, (SELECT Count(OrderLine.LineNumber) FROM OrderLine WHERE OrderLine.SeatTypeCode = " & OneSeatCode & ")as ThreeDiscCount FROM OrderLine (NOLOCK) WHERE OrderLine.OrderNumber = " & OrderNumber & " Group by Orderline.SeatTypeCode"
    Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
			
	'Fixed Price by Seat Type
	   Select Case SeatTypeCode
				Case 4449 
				
					If Int(rsDiscCount("OneDiscCount") /10) < Int(rsAppliedCount("OneTicketApplied") / 10) Then 'Apply the discount to this item
					    NewPrice = 15
				    Else
				        NewPrice = Price
				    End If
				    
				Case 4450
				    If rsDiscCount("TwoDiscCount") < (75 - rsAppliedCount("TwoTicketApplied")) Then    
					    NewPrice = 75
				    Else
				        NewPrice = Price
				    End If
				    
			   Case 4451 
				    If rsDiscCount("ThreeDiscCount")  < (200 -  rsAppliedCount("ThreeTicketApplied")) Then    
					    NewPrice = 150
				    Else
				        NewPrice = Price
				    End If
	    End Select
	    
	    

		
        'Apply Discount
	    If Price > NewPrice Then
	    DiscountAmount = Price - NewPrice
	    AppliedFlag = "Y"
        End If

        ' Determine Surcharge
        If Request("NewSurcharge") <> "" Then
	        Surcharge = NewSurcharge
        Else

	        If Request("CalcServiceFee") <> "N" Then
		        Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
	        End If
        	
        End If
        
        
rsDiscCount.Close
Set rsDiscCount = nothing 

rsAppliedCount.Close
Set rsAppliedCount = nothing  
        
End If		
		
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>