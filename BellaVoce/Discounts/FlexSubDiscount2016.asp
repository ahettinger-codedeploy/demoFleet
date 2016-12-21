<%

'CHANGE LOG - Update
'SSR 7/7/16 Created New Discount


%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->
<!--#include virtual="NoCacheInclude.asp"-->

<%

'===============================

'If they buy these 3 Productions:

'65606 Holiday Delights
'65605 Messiah Messiah
'130023 Spring Brahms Requiem

'General Admission (64611): $81 series price
'Full-time student/child/senior (69479): No Discount
'Premium (64612): No Discount

'On sale August 1, 2016
'Off sale Nov. 20, 2016

'---------------------------

'If they buy these 6 Productions:

'65606 Holiday Delights
'65605 Messiah Messiah
'130023 Spring Brahms Requiem

'130026 Opus 327 Bach Cantatas
'130025 Opus 327 Cecilia!
'130027 Opus 327 Monteverdi

'General Admission (64611): $125 series price
'Senior/student/child: $95 series price

'On sale August 1, 2016
'Off sale September 24, 2016

'===============================

'Discount Variables

DIM SeriesDiscount
DIM SeriesPrice

DIM ActCount1List
DIM ActCount2List

ActCount1List = "65606,65605,130023,130026,130025,130027"
ActCount2List = "65606,65605,130023"

DIM OnSale
OnSale =  "8/1/2016"

DIM OffSale3
DIM OffSale6
 
OffSale3 = "11/20/2016"
OffSale6 = "9/24/2016"

'===============================

If Now() > CDate(OnSale) Then  

	    'Determine number of acts on order	    

	    SQLActCount1 = "SELECT COUNT(ActCode) AS ActCount1 FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine on Seat.ItemNumber = OrderLine.ItemNumber WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCount1List & ") AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " GROUP BY Event.ActCode) AS ActCount1"
	    Set rsActCount1 = OBJdbConnection.Execute(SQLActCount1)	
	    ActCount1 = rsActCount1("ActCount1")	
	    rsActCount1.Close
	    Set rsActCount1 = nothing

	    SQLActCount2 = "SELECT COUNT(ActCode) AS ActCount2 FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine on Seat.ItemNumber = OrderLine.ItemNumber WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCount2List & ") AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " GROUP BY Event.ActCode) AS ActCount2"
	    Set rsActCount2 = OBJdbConnection.Execute(SQLActCount2)	
	    ActCount2 = rsActCount2("ActCount2")	
	    rsActCount2.Close
	    Set rsActCount2 = nothing	    
	    	
	    If ActCount1 = 6 Then
		    SubscriptionType = "6SHOW"
                ActList = ActCount1List
	    ElseIf ActCount2 = 3 Then
		    SubscriptionType = "3SHOW"
                ActList = ActCount2List
	    Else
	        SubscriptionType = "NOSHOW"
	    End If
          
          ErrorLog("SubscriptionType " & SubscriptionType &"")
          
          If SubscriptionType <> "NOSHOW" Then
	    
            'Removed dates which lower the percentage of discount
            'If Now() > CDate(Date(2)) Then   'Drops to 10% off after 4/2/2011           
            '    Percentage = (Percentage - 10) 
            'ElseIf Now() >  CDate(Date(3)) Then  'Drops to 5% off after 2/13/2011         
            '    Percentage = (Percentage - 5) 
            'End If
	
		'Get the least number of tickets for allowed ActCodes
		SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActList & ") GROUP BY Event.ActCode) AS TicketCount"
		Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
		NbrSubscriptions = rsMinTicketCount("NumSubs")		
		rsMinTicketCount.Close
		Set rsMinTicketCount = nothing
            
            ErrorLog("NbrSubscriptions  " & NbrSubscriptions  &"")
		
		'Get Act Code
		SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
		Set rsAct = OBJdbConnection.Execute(SQLAct)		
		ActCode = rsAct("ActCode")		
		rsAct.Close
		Set rsAct = nothing

            If SubscriptionType = "3SHOW" Then
            
                  If Now() < CDate(OffSale3) Then
            
                        SeriesCount = 3
                                    
                        Select Case ActCode 
                            Case 65606,65605,130023
                              Select Case SeatTypeCode
                                    Case 64611 'General Admission
                                          SeriesPrice = 81
                                    Case 69479 'Senior/student/child
                                          SeriesPrice = ""
                              End Select 
                        End Select  
                        
                  End If

            ElseIf SubscriptionType = "6SHOW" Then 
            
                  If Now() < CDate(OffSale6) Then
            
                         SeriesCount = 6
                      
                        Select Case ActCode 
                            Case 65606,65605,130023,130026,130025,130027
                                    Select Case SeatTypeCode
                                          Case 64611 'General Admission
                                                SeriesPrice = 125
                                          Case 69479 'Senior/student/child
                                                SeriesDiscount  = 15
                                    End Select 
                       End Select 
                 
                 End If

            End If
            
            ErrorLog("SeriesPrice " & SeriesPrice &"")
            ErrorLog("SeriesDiscount " & SeriesDiscount &"")
                        
		'Count # of existing seats which have discount applied for this act and seat type code
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
		AppliedCount = rsDiscCount("LineCount")		
		rsDiscCount.Close
		Set rsDiscCount = nothing
            
            ErrorLog("AppliedCount " & AppliedCount &"")
             ErrorLog("NbrSubscriptions " & NbrSubscriptions &"")
            		
		If AppliedCount < NbrSubscriptions Then
            
                  If SeriesDiscount <> "" Then
                                 
                        'Count # of applied tickets on this order
                        SQLCount = "SELECT COUNT(*) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
                        Set rsCount = OBJdbConnection.Execute(SQLCount)
                        TotalAppliedCount = rsCount("AppliedCount")
                        rsCount.Close
                        Set rsCount = nothing
                  
                        'MOD function to determine the last ticket to complete the subscription discount (i.e. fourth ticket in the FlexPass-4, or eighth ticket in a FlexPass-8, etc.).  
                        Remainder = TotalAppliedCount MOD SeriesCount

                        ' Calculates the total of all discounted ticket prices already given to figure out the discounted ticket price to be assign to this ticket.
                        If Remainder = SeriesCount - 1 Then 
                              DiscountAmount = SeriesDiscount - ((SeriesCount - 1) * Round(SeriesDiscount / SeriesCount, 2))
                        Else
                                    'Standard rounding on all other tickets.
                              DiscountAmount = Round(SeriesDiscount/SeriesCount, 2)
                        End If

                        NewPrice = Price - DiscountAmount
		
                        AppliedFlag = "Y"

                        If Request("NewSurcharge") <> "" Then
                              Surcharge = NewSurcharge
                        Else
                              If Request("CalcServiceFee") <> "N" Then
                                    Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
                              End If
                        End If
                        
                  End If
                  
                  If SeriesPrice <> "" Then
                                
                        'Count # of applied tickets on this order
                        SQLCount = "SELECT COUNT(*) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
                        Set rsCount = OBJdbConnection.Execute(SQLCount)
                        TotalAppliedCount = rsCount("AppliedCount")
                        rsCount.Close
                        Set rsCount = nothing
                        
                        ErrorLog("TotalAppliedCount " & TotalAppliedCount &"")
                       ErrorLog("SeriesCount " & SeriesCount &"")

                        'MOD function to determine the last ticket to complete the subscription discount (i.e. fourth ticket in the FlexPass-4, or eighth ticket in a FlexPass-8, etc.).  
                        Remainder = TotalAppliedCount MOD SeriesCount
                        
                        ErrorLog("Remainder" & Remainder &"")

                        'Calculates the total of all discounted ticket prices already given to figure out the discounted ticket price to be assign to this ticket.
                        If Remainder = SeriesCount - 1 Then 
                              NewPrice = SeriesPrice - ((SeriesCount - 1) * Round(SeriesPrice / SeriesCount, 2))
                        Else
                        'Standard rounding on all other tickets.
                              NewPrice = Round(SeriesPrice/SeriesCount, 2)
                        End If
                        
                      If Price > NewPrice Then
                          DiscountAmount = Clean(Request("Price")) - NewPrice
                          AppliedFlag = "Y"
                      End If  
                        
                       ErrorLog("NewPrice" & NewPrice &"")
                        
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