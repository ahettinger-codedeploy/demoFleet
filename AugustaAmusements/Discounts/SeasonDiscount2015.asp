<%

'CHANGE LOG
'SSR 06/16/2015 - Custom Discount Code Created. 
'SSR 06/18/2015 - Added new surcharge and recalc options



%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================

'Augusta Amusements

'Custom Build-Your-Own. 
'When discount code “Discount” is entered, the following discount is provided:

'3-4 productions 5% off
'5+ productions 10% off

'ACT CODE	ACT NAME
'116738		Doc Severinsen and his Big Band
'116739		Broadway Boys
'116764		Billy Joel Tribute
'116765		Christmas with the Annie Moses Band
'116879		Live from Nashville
'116880		The World Famous Glenn Miller Orchestra
'116882		The McCartney Years
'116931		ADAM TRENT
'116932		Evening in the Round
'117089		HENRY GROSS ?One Hit Wanderer?
'117101		An Acoustic Evening with COLLIN RAYE
'117210		Johnny Peers and his Muttville Comix


'Offline/Online: Both
'Service Fees: Recalculate service fees
'Additional Tickets: N/A
'Automatic/Code Entry: Discount Code Entry Required
'Expiration: No Expiration
'Restrictions: N/A

'==================================================

MinSeriesCount = 3

SeriesDiscount3 = 5
SeriesDiscount5 = 10


ActCodeList = "116738,116739,116764,116765,116879,116880,116882,116931,116932,117089,117101,117210"

'--------------------------------------------------

If AllowDiscount = "Y" Then
	
        'Determine the number of acts with matching ticket types.
        SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
        Set rsActCount = OBJdbConnection.Execute(SQLActCount)
        ActCount = rsActCount("ActCount")
        rsActCount.Close
        Set rsActCount = nothing
		
    If ActCount => MinSeriesCount Then                
                
            If ActCount => 5 Then
                SeriesPercentage = SeriesDiscount5
            ElseIf ActCount => 3 Then
                SeriesPercentage = SeriesDiscount3
            End If
			
			'ErrorLog("SeriesPercentage : " & SeriesPercentage  & "")

            'Determine how many sets of matching act code / ticket type  are on the order
            SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS TicketCount"
            Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
            NbrSubscriptions = rsMinTicketCount("NumSubs")		
            rsMinTicketCount.Close
            Set rsMinTicketCount = nothing    	
            	
            'Get Act Code
            SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
            Set rsAct = OBJdbConnection.Execute(SQLAct)		
            ActCode = rsAct("ActCode")		
            rsAct.Close
            Set rsAct = nothing

            'Determine the number of tickets which have been discounted
            SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
            Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)			
            AppliedCount = rsDiscCount("LineCount")        		
            rsDiscCount.Close
            Set rsDiscCount = nothing	

            'Should the number of possible discounts be less then the total possible go ahead and discount this ticket
            If AppliedCount < NbrSubscriptions Then	  

                NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)

				If Price > NewPrice Then
				
					DiscountAmount = Clean(Request("Price")) - NewPrice
					AppliedFlag = "Y"
					
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

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>