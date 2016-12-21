<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'GA (GENAD) Settings, must be sets of 4
GAGroupCount = 4
GADiscountAmount = 12.50

QtyToApply = 3
GroupMultiple = 4


If AllowDiscount = "Y" Then 'It's okay to apply this ticket

    'Count # of tickets in this event / section
	SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode")) & " AND Seat.SectionCode = '" & SectionCode & "'"
	Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)
    NbrTickets = rsEventCount("SeatCount")
    rsEventCount.Close
    Set rsEventCount = nothing

	Select Case SectionCode
	    Case "PLAT" 
            
            If NbrTickets >= QtyToApply Then
            
                'Count # of tickets with discount already applied
                SQLDiscCount1 = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND Seat.SectionCode = '" & SectionCode & "'"
                Set rsDiscCount1 = OBJdbConnection.Execute(SQLDiscCount1)
                
                If rsDiscCount1("LineCount") > Fix(NbrTickets  / (Fix(GroupMultiple))) Then 'Apply the discount		
		            NewPrice = 45	
	            Else
		            NewPrice = Clean(Request("Price"))       
	            End If       
                
                rsDiscCount1.Close
                Set rsDiscCount1 = nothing
                
                DiscountAmount = Clean(Request("Price")) - NewPrice

			    AppliedFlag = "Y"
			    
		    End If	
		    
		    
        Case "DMND" 
            
            If NbrTickets >= QtyToApply Then
            
                'Count # of tickets with discount already applied
                SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND Seat.SectionCode = '" & SectionCode & "'"
                Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
                
                If rsDiscCount("LineCount") > Fix(NbrTickets  / (Fix(GroupMultiple))) Then 'Apply the discount		
		            NewPrice = 40	
	            Else
		            NewPrice = Clean(Request("Price"))       
	            End If       
                
                rsDiscCount.Close
                Set rsDiscCount = nothing
                
                DiscountAmount = Clean(Request("Price")) - NewPrice

			    AppliedFlag = "Y"
			    
		    End If	
		    
		    
        Case "GOLD" 
            
            If NbrTickets >= QtyToApply Then
            
                'Count # of tickets with discount already applied
                SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND Seat.SectionCode = '" & SectionCode & "'"
                Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
                
                If rsDiscCount("LineCount") > Fix(NbrTickets  / (Fix(GroupMultiple))) Then 'Apply the discount		
		            NewPrice = 40	
	            Else
		            NewPrice = Clean(Request("Price"))       
	            End If       
                
                rsDiscCount.Close
                Set rsDiscCount = nothing
                
                DiscountAmount = Clean(Request("Price")) - NewPrice

			    AppliedFlag = "Y"
			    
		    End If	
		    
        Case "SLVR" 
            
            If NbrTickets >= QtyToApply Then
            
                'Count # of tickets with discount already applied
                SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND Seat.SectionCode = '" & SectionCode & "'"
                Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
                
                If rsDiscCount("LineCount") > Fix(NbrTickets  / (Fix(GroupMultiple))) Then 'Apply the discount		
		            NewPrice = 40	
	            Else
		            NewPrice = Clean(Request("Price"))       
	            End If       
                
                rsDiscCount.Close
                Set rsDiscCount = nothing
                
                DiscountAmount = Clean(Request("Price")) - NewPrice

			    AppliedFlag = "Y"
			    
		    End If	   
		            

	End Select	

	If Request("CalcServiceFee") <> "N" Then
		Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
	End If
		
End If
					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>