<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'Cheyenne Little Theatre Players
'2010 Season Subscription Discount (3/9/2010)
'============================================

'4 Act Season Subscription - Two Plus Two
'----------------------------------------
'Valid for the following productions: 
'37221	Old Fashioned Melodrama
'47052	The Odd Couple
'47053	A Christmas Carol
'47054	A Streetcar Named Desire
'47056	The 25th Annual Putnam County Spelling Bee
'47057	Noices Off
'47058	Grease
'47338	The Sound of Music

'Two+Two subscription requires 2 Musical acts and 2 Drama acts
'Valid musical productions: Fiddler, Spelling Bee, Grease
'Valid drama productions: Odd Couple, Christmas Carol, Streetcar, Radio Drama, Noises Off
'Adult subscription is 10% off ($82.80)
'Senior subscription is 10% off (84.00)
'Student subscription is 10% off ($68.00) 


'8 Act Season Subscription - Single
'----------------------------------------
'Valid for the same productions as above
'Full Season subscription requires 1 ticket to each of the 8 productions
'Adult subscription price is 15% off ($146.20)
'Senior subscription price is 15% off ($132.60)
'Student subscription price is 15% off  ($107.10)
'Additional single tickets are $1.00 off


'8 Act Season Subscription - Family Pack
'----------------------------------------
'Valid for the same productions as above
'Family Pack subscription requires 2 Adult + 2 Student Full Season subscriptions
'Each Adult subscription is 25% off ($129.00)
'Each Student subscription is 25% off ($94.50)
'Additional Student subscriptions are 25% off ($94.50)
'Additional single tickets are $1.00 off


'Initialize Variables
Price = Clean(Request("Price"))
NewPrice = Clean(Request("Price"))
NewSurcharge = CDbl(Clean(Request("NewSurcharge")))
AppliedFlag = "N"

AdultList = "1" 
SeniorList = "3" 
StudentList = "6" 


SeriesCount = 8 
ActCodeList = "47338,47052,47053,47054,37221,47056,47057,47058"

SingleTicketDiscount = 1

FullSubPercentage = 15 
FullSubscription = "N"

FamilyPackQuantity = 4
FamilyPackPercentage = 25 
FamilyPack = "N"

Call DBOpen(OBJdbConnection)
Call DBOpen(OBJdbConnection2)
Call DBOpen(OBJdbConnection3)
Call DBOpen(OBJdbConnection4)
Call DBOpen(OBJdbConnection5)
Call DBOpen(OBJdbConnection6)
Call DBOpen(OBJdbConnection7)
Call DBOpen(OBJdbConnection8)
Call DBOpen(OBJdbConnection9)
Call DBOpen(OBJdbConnection10)
Call DBOpen(OBJdbConnection11)
Call DBOpen(OBJdbConnection12)
Call DBOpen(OBJdbConnection13)
Call DBOpen(OBJdbConnection14)
Call DBOpen(OBJdbConnection15)

'===================================================

'Determine number of Adult Productions on order
SQLAdultActCount = "SELECT COUNT(ActCode) AS AdultActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.SeatTypeCode IN (" & AdultList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS AdultActCount"
Set rsAdultActCount = OBJdbConnection.Execute(SQLAdultActCount)
AdultActCount = rsAdultActCount("AdultActCount")
rsAdultActCount.Close
Set rsAdultActCount = nothing

'Determine number of Senior Productions on order
SQLSeniorActCount = "SELECT COUNT(ActCode) AS SeniorActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.SeatTypeCode IN (" & SeniorList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS SeniorActCount"
Set rsSeniorActCount = OBJdbConnection2.Execute(SQLSeniorActCount)
SeniorActCount = rsSeniorActCount("SeniorActCount")
rsSeniorActCount.Close
Set rsSeniorActCount = nothing

'Determine number of Student Productions on order
SQLStudentActCount = "SELECT COUNT(ActCode) AS StudentActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.SeatTypeCode IN (" & StudentList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS StudentActCount"
Set rsStudentActCount = OBJdbConnection3.Execute(SQLStudentActCount)
StudentActCount = rsStudentActCount("StudentActCount")
rsStudentActCount.Close
Set rsStudentActCount = nothing

If AdultActCount = SeriesCount Or StudentActCount = SeriesCount Or SeniorActCount = SeriesCount Then
   FullSubscription = "Y"
End If

'===================================================

'Determine number of Adult Subscriptions on order
SQLAdultSubCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.SeatTypeCode IN (" & AdultList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
Set rsAdultSubCount = OBJdbConnection4.Execute(SQLAdultSubCount)
AdultSubCount = rsAdultSubCount("NumSubs")	
rsAdultSubCount.Close
Set rsAdultSubCount = nothing

'Determine number of Senior Subscriptions on order
SQLSeniorSubCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.SeatTypeCode IN (" & SeniorList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
Set rsSeniorSubCount = OBJdbConnection5.Execute(SQLSeniorSubCount)		
SeniorSubCount = rsSeniorSubCount("NumSubs")		
rsSeniorSubCount.Close
Set rsSeniorSubCount = nothing

'Determine number of Student Subscriptions on order
SQLStudentSubCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.SeatTypeCode IN (" & StudentList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
Set rsStudentSubCount = OBJdbConnection6.Execute(SQLStudentSubCount)		
StudentSubCount = rsStudentSubCount("NumSubs")		
rsStudentSubCount.Close
Set rsStudentSubCount = nothing

If AdultSubCount => 2 And StudentSubCount  => 2  Then    
    FamilyPack = "Y"    
End If

'===================================================

'INDIVIDUAL FULL SEASON SUBSCRIPTION DISCOUNT

If FullSubscription = "Y" And FamilyPack = "N" Then 
	
'Determine the number of acts on this order.
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
	Set rsActCount = OBJdbConnection7.Execute(SQLActCount)	
	ActCount = rsActCount("ActCount")	
	rsActCount.Close
	Set rsActCount = nothing
	
	If ActCount >= SeriesCount Then

	'Determine the number of possible subscriptions on this order
		SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
		Set rsMinTicketCount = OBJdbConnection8.Execute(SQLMinTicketCount)		
		NbrSubscriptions = rsMinTicketCount("NumSubs")		
		rsMinTicketCount.Close
		Set rsMinTicketCount = nothing
		
		'Get the ActCode
		    SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
		    Set rsAct = OBJdbConnection9.Execute(SQLAct)		
		    ActCode = rsAct("ActCode")		
		    rsAct.Close
		    Set rsAct = nothing

		'Count the number of seats which have been discounted
		    SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
		    Set rsDiscCount = OBJdbConnection10.Execute(SQLDiscCount)		
		    AppliedCount = rsDiscCount("LineCount")		
		    rsDiscCount.Close
		    Set rsDiscCount = nothing
	
		If AppliedCount < NbrSubscriptions Then	
			Select Case SeatTypeCode
				Case 1 'Adult
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(FullSubPercentage)/100), 2)
				Case 3 'Senior
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(FullSubPercentage)/100), 2)
				Case 5 'Student
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(FullSubPercentage)/100), 2)
            End Select
        Else
           	        NewPrice = Clean(Request("Price")) - SingleTicketDiscount
		End If	
											
	End If

	If Price > NewPrice Then
		DiscountAmount = Clean(Request("Price")) - NewPrice
		AppliedFlag = "Y"
	End If
	
	If Request("NewSurcharge") <> "" Then
		Surcharge = NewSurcharge
	Else
		If Request("CalcServiceFee") <> "N" Then
			Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
		End If
	End If
	
	
End If	

'===================================================

'FAMILY PACK SEASON SUBSCRIPTION DISCOUNT

If FullSubscription = "Y" And FamilyPack = "Y" Then    	

            '----------------------------
             
            'ADULT - FAMILY PACK DISCOUNT
                     
                'Count number of tickets which have been given a discount     
		        SQLDiscAdultCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode IN (" & AdultList & ")"
		        Set rsDiscAdultCount = OBJdbConnection11.Execute(SQLDiscAdultCount)
		        AppliedAdultCount = rsDiscAdultCount("LineCount")		
		        rsDiscAdultCount.Close
		        Set rsDiscAdultCount = nothing
                            
                'Count number of tickets which have not been given a discount
	            SQLCount = "SELECT COUNT(OrderLine.ItemNumber) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND OrderLine.SeatTypeCode IN (" & AdultList & ") AND OrderLine.Discount <> 0 AND DiscountTypeNumber = " & DiscountTypeNumber
	            Set rsCount = OBJdbConnection12.Execute(SQLCount)
	            Count = rsCount("AppliedCount")
	            rsCount.Close
	            Set rsCount = nothing 
	             
	                     
		        If AppliedAdultCount < AdultSubCount  Then	
				        Select Case SeatTypeCode
						Case 1' Adult	
						    Remainder = AdultSubCount MOD 2
						    If Remainder > 0 Then
						        If AppliedAdultCount =  Remainder Then 
							     NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(FullSubPercentage)/100), 2)
							    Else
								    NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(FamilyPackPercentage)/100), 2)
							    End If
							Else
								NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(FamilyPackPercentage)/100), 2)	    
							End If 
                        End Select
                Else
				        Select Case SeatTypeCode                	
			            Case 1' Adult
				        NewPrice = Clean(Request("Price")) - SingleTicketDiscount
				        End Select
				End If

     	         
    	    '----------------------------
    	    
    	    'STUDENT - FAMILY PACK DISCOUNT
    	    
		        SQLDiscStudentCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode IN (" & StudentList & ")"
		        Set rsDiscStudentCount = OBJdbConnection13.Execute(SQLDiscStudentCount)
		        AppliedStudentCount = rsDiscStudentCount("LineCount")		
		        rsDiscStudentCount.Close
		        Set rsDiscStudentCount = nothing  
		        
		        	              
		        If AppliedStudentCount < StudentSubCount  Then
                                		    
                        Select Case SeatTypeCode                	
                              Case 6' Student
	                          NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(FamilyPackPercentage)/100), 2)
	                    End Select				     

				Else
				        Select Case SeatTypeCode                	
			            Case 6' Student
				        NewPrice = Clean(Request("Price")) - SingleTicketDiscount
				        End Select
				End If
    	         
    	    '----------------------------
    	    
    	    'Senior - Full Season Discount
    	    
    	    If SeniorActCount = SeriesCount Then
    	    
		            SQLDiscSeniorCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode IN (" & SeniorList & ")"
		            Set rsDiscSeniorCount = OBJdbConnection14.Execute(SQLDiscSeniorCount)
		            AppliedSeniorCount = rsDiscSeniorCount("LineCount")		
		            rsDiscSeniorCount.Close
		            Set rsDiscSeniorCount = nothing  
    		        	              
		            If AppliedSeniorCount < SeniorSubCount  Then
                                            		    
                          Select Case SeatTypeCode                	
                          Case 3' Senior
                          NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(FullSubPercentage)/100), 2)
                          End Select

				     Else
	                        Select Case SeatTypeCode                	
                            Case 3' Senior
                            NewPrice = Clean(Request("Price")) - SingleTicketDiscount
	                        End Select
				     End If
	
    	     Else
                    Select Case SeatTypeCode                	
                    Case 3' Senior
                    NewPrice = Clean(Request("Price")) - SingleTicketDiscount
                    End Select
			End If
    	    '----------------------------  
    		
	            If Price > NewPrice Then
		            DiscountAmount = Clean(Request("Price")) - NewPrice
		            AppliedFlag = "Y"
	            End If
					
		        If Request("NewSurcharge") <> "" Then
			        Surcharge = NewSurcharge
		        Else
			        If Request("CalcServiceFee") <> "N" Then
				        Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
			        End If
		        End If
	
End If
	


'===================================================

Call DBClose(OBJdbConnection)
Call DBClose(OBJdbConnection2)
Call DBClose(OBJdbConnection3)
Call DBClose(OBJdbConnection4)
Call DBClose(OBJdbConnection5)
Call DBClose(OBJdbConnection6)
Call DBClose(OBJdbConnection7)
Call DBClose(OBJdbConnection8)
Call DBClose(OBJdbConnection9)
Call DBClose(OBJdbConnection10)
Call DBClose(OBJdbConnection11)
Call DBClose(OBJdbConnection12)
Call DBClose(OBJdbConnection13)
Call DBClose(OBJdbConnection14)
Call DBClose(OBJdbConnection15)

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>