<%

'CHANGE LOG - Inception
'SSR 4/6/2012
'Custom Discount Created

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'========================================================================================

'Anderson Symphony Orchestra

'SilviaTIX: Code = Bunny
'SilviaTIX: Discount is for Sunday event only

'SilviaTIX: $50 (Adult) becomes $38
'SilviaTIX: $48 (Senior) becomes $35
'SilviaTIX: $48 (Student) becomes $25
'SilviaTIX: i'll write it up
'sergiotix: easy enough...
'SilviaTIX: expires tuesday
'SilviaTIX: or should i say it should run through tuesday

'========================================================================================

AdultTicket = 1  
AdultPrice = 38

SeniorTicket = 27	
SeniorPrice = 35

StudentTicket = 1119
StudentPrice = 25

ExpirationDate = "4/11/2012"

'========================================================================================


If AllowDiscount = "Y" Then 'It's okay to apply to this order.


        'Check to see if discount has reached expirationdate.
        'We use the original order date, rather than today's date as
        'this allows the order to be re-opened without losing the discounted pricing

        SQLDateCheck = "SELECT OrderHeader.OrderDate FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
        Set rsDateCheck = OBJdbConnection.Execute(SQLDateCheck)
        OriginalOrderDate = rsDateCheck("OrderDate")
        rsDateCheck.Close
        Set rsDateCheck = nothing


        If CDate(OriginalOrderDate) < CDate(ExpirationDate) Then  
		
		        Select Case Clean(Request("SeatTypeCode"))			
                    Case 1
				        NewPrice = 38			
                    Case 27
				        NewPrice = 35
                    Case 1119
				        NewPrice = 25
                End Select
	

                If Price > NewPrice Then
                    DiscountAmount = Clean(Request("Price")) - NewPrice
                    AppliedFlag = "Y"
                End If

                If NewSurcharge <> "" Then
                    Surcharge = NewSurcharge
                Else
                    If CalcServiceFee <> "N" Then
                        Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
                    End If
                End If


        End If


End if

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>

   
