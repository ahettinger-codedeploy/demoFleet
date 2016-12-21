<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->
<!--

=================================
Colorado West School (10/12/2010)

Series Count:
Must purchase 1 ticket to each of 5 different Acts

Valid Acts:
Incendio (56705)
Holiday Concert (56703)
Feast (56701)
Marcin Arendt (56702)
Cello-Piano Surprises (56749)

Service Fees
Recalcuate per ticket fees

Parameters
Subscription can include any combination of ticket type
Subscription can include any combination of sections
Subscription can include any combination of venues

Subscription Pricing

Green or 1Green Section

    Avalon Theatre (9020)
    Roper Ballroom (VenueCode = 9018)
    Montrose Pavilion-Main Auditorium (9016)
    Montrose Pavilion-Seating on the Stage (9017)    
    ----------------------------------------------------
    Adult $27.00 per ticket  ($135.00 Series Price)
    Child $16.60 per ticket  ($83.00 Series Price)

    Paradise Theatre (9021)
    Blue Sage Center for the Arts (9019)
    ---------------------------------------------------
    Adult $25.00 per ticket ($125.00 Series Price)
    Child $16.60 per ticket ($72.00 Series Price)


Blue Section

    Avalon Theatre (9020)
    Roper Ballroom (VenueCode = 9018)
    Montrose Pavilion-Main Auditorium (9016)
    Montrose Pavilion-Seating on the Stage (9017)  
    ---------------------------------------------------
    Adult $22.00 per ticket ($110.00 Series Price)
    Child $12.80 per ticket ($64.00 Series Price)

    Paradise Theatre (9021)
    Blue Sage Center for the Arts (9019)
    ---------------------------------------------------
    Adult $20.00 per ticket ($100.00 Series Price)
    Child $12.80 per ticket ($64.00 Series Price)


DarkRed Section

    Avalon Theatre (9020)
    Roper Ballroom (VenueCode = 9018)
    Montrose Pavilion-Main Auditorium (9016)
    Montrose Pavilion-Seating on the Stage (9017)  
    ---------------------------------------------------
    Adult $17.80 per ticket ($89.00 Series Price)
    Child  $9.00 per ticket ($40.00 Series Price)

    Paradise Theatre (9021)
    Blue Sage Center for the Arts (9019)
    ---------------------------------------------------
    Adult $16.20 per ticket ($81.00 Series Price)
    Child  $9.00 per ticket ($40.00 Series Price)

-->

<%

'Set Discount Variables
SeriesCount = 5 
ActCodeList = "56705,56703,56701,56702,56749"

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

'Count number of Acts on the order.
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
	ActCount = rsActCount("ActCount")	
	rsActCount.Close
	Set rsActCount = nothing
	
	If ActCount >= SeriesCount Then

		'Get the least number of tickets for any applicable ActCode
		SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
		Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
		NbrSubscriptions = rsMinTicketCount("NumSubs")		
		rsMinTicketCount.Close
		Set rsMinTicketCount = nothing
		
		'Get the Act Code
		SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
		Set rsAct = OBJdbConnection.Execute(SQLAct)		
		ActCode = rsAct("ActCode")		
		rsAct.Close
		Set rsAct = nothing
		
		'Get the Section Color
	    SQLColor = "SELECT Color FROM Section(NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "'"
	    Set rsColor = OBJdbConnection.Execute(SQLColor)	
	    SectionColor = UCase(rsColor("Color"))	
	    rsColor.Close
	    Set rsColor = nothing
	    
	    'Get the Venue Code
		SQLVenue = "SELECT VenueCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
		Set rsVenue = OBJdbConnection.Execute(SQLVenue)		
		VenueCode = rsVenue("VenueCode")		
		rsVenue.Close
		Set rsVenue = nothing

		'Count # of existing seats which have discount applied for this act and seat type code
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
		AppliedCount = rsDiscCount("LineCount")		
		rsDiscCount.Close
		Set rsDiscCount = nothing

		If AppliedCount < NbrSubscriptions Then	

					Select Case SectionColor
										
					Case "GREEN", "1GREEN"
			            Select Case VenueCode
			                Case 9016, 9017, 9018, 9020 'Montrose Pavilion-Main Auditorium, Montrose Pavilion-Seating on the Stage, Roper, Avalon Theatre
	                            Select Case SeatTypeCode
                                    Case 1 'Adult
                                    NewPrice = Price - 5
                                    Case 417 'Child
                                    NewPrice = Price - 5
	                            End Select

					        Case 9019, 9021 'Paradise Theatre, Blue Sage Center for the Arts
					            Select Case SeatTypeCode
						            Case 1 'Adult
						            NewPrice = Price - 5
						            Case 417 'Child
						            NewPrice = Price - 5
						        End Select	
						End Select 

                    Case "BLUE", "2BLUE"
                        Select Case VenueCode
			                Case 9016, 9017, 9018, 9020 'Montrose Pavilion-Main Auditorium, Montrose Pavilion-Seating on the Stage, Roper, Avalon Theatre
			                    Select Case SeatTypeCode
		                            Case 1 'Adult
		                            NewPrice = Price - 5
		                            Case 417 'Child
		                            NewPrice = Price - 5
			                    End Select			        
					        Case 9019, 9021 'Paradise Theatre, Blue Sage Center for the Arts
					            Select Case SeatTypeCode
						            Case 1 'Adult
						            NewPrice =  Price - 5
						            Case 417 'Child
						            NewPrice =  Price - 5
						        End Select
						    End Select	

					Case "DARKRED", "RED"
					    Select Case VenueCode
			                Case 9016, 9017, 9018, 9020 'Montrose Pavilion-Main Auditorium, Montrose Pavilion-Seating on the Stage, Roper, Avalon Theatre
			                    Select Case SeatTypeCode
		                            Case 1 'Adult
		                            NewPrice = Price - 4.20
		                            Case 417 'Child
		                            NewPrice = Price - 5
			                    End Select
					        Case 9019, 9021 'Paradise Theatre, Blue Sage Center for the Arts
					            Select Case SeatTypeCode
						            Case 1 'Adult
						            NewPrice = Price - 3.80
						            Case 417 'Child
						            NewPrice = Price - 5
						        End Select
					        End Select
					        
					
					End Select
					
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
    End If
	
End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>