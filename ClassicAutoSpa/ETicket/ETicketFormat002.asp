<%

'CHANGE LOG - Update
'SSR 12/5/2011
'Boerne Performing Arts
'Proper Case Spelling of Billing and Shipping Name
'Added ShortAct and Producer options

'CHANGE LOG - Update
'SSR 10/4/2011
'George Little Management
'Date/Time Supress - E-Ticket will supress date/time if the event does.

'CHANGE LOG - Update
'SSR 8/11/2011
'Downtown Theater
'Case Statement - ticket will automatcially switch between GA and Rsvd formats 

'CHANGE LOG - Update
'SSR 6/24/2011
'Downtown Theater
'Ticket count added

%>

<!--#INCLUDE virtual=GlobalInclude.asp -->
<!--#INCLUDE virtual="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL ="ETicketInclude.asp"-->

<%

OrderNumber = Clean(Request("OrderNumber"))
TicketNumber = Clean(Request("TicketNumber"))

'===============================================
'CLASSIC AUTO SPA -- E-Ticket Options

'----------------------

'Display Custom Logo 
'for default logo set variable to blank
CustomETicketLogo = "/Clients/ClassicAutoSpa/ETicket/Images/CustomETicketLogo.gif"

'----------------------

'Display Custom Background
'for default background set variable to blank
CustomETicketBackground = "/Clients/ClassicAutoSpa/ETicket/Images/CustomETicketBackground.png"
CustomBackgroundColor = "#FFD718"

'----------------------

'Display Custom Bottom Bar
'for default background set variable to blank
CustomETicketBottomBar = "/Clients/ClassicAutoSpa/ETicket/Images/CustomETicketBottomBar.jpg"

'----------------------

'Producer/Organization Presents Option
'3 Options:
'ShowPresents = "Producer"
'ShowPresents = "Organization" 
'ShowPresents = "None"

 ShowPresents = "None"

'----------------------

'Short Act vs Act Option
ShowShortAct = False

'----------------------

'Show BarCode on TicketBody
ShowBarCode = False

'----------------------

'Ticket Text 1

			
TicketText1 = ""

SQLVerifyEvent = "SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat on Event.EventCode = Seat.EventCode INNER JOIN OrderLine on Seat.ItemNumber = OrderLine.ItemNumber WHERE OrderLine.OrderNumber = " &  OrderNumber & ""
Set rsVerifyEvent = OBJdbConnection.Execute(SQLVerifyEvent)

 If NOT rsVerifyEvent.EOF Then 

    SQLVerifyOption = "SELECT OptionName FROM EventOptions WHERE EventOptions.OptionName = 'TicketText1' AND EventOptions.EventCode = " &  rsVerifyEvent("EventCode")  & ""
    Set rsVerifyOption = OBJdbConnection.Execute(SQLVerifyOption)

        If NOT rsVerifyOption.EOF Then     
 
            SQLCustomText = "SELECT OptionValue FROM EventOptions WHERE EventOptions.OptionName = '" &  rsVerifyOption("OptionName") & "' AND EventOptions.EventCode = " &  rsVerifyEvent("EventCode")  & ""
            Set rsCustomText = OBJdbConnection.Execute(SQLCustomText)

             If rsCustomText("OptionValue") <> "" Then 
                TicketText1 = rsCustomText("OptionValue")
             End If
 
            rsCustomText.Close
            Set rsCustomText = nothing

        End If	
        
End If	
     	
rsVerifyOption.Close
Set rsVerifyOption = nothing

rsVerifyEvent.Close
Set rsVerifyEvent = nothing

'----------------------

'Ticket Text 2

			
TicketText2= ""

SQLVerifyEvent = "SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat on Event.EventCode = Seat.EventCode INNER JOIN OrderLine on Seat.ItemNumber = OrderLine.ItemNumber WHERE OrderLine.OrderNumber = " &  OrderNumber & ""
Set rsVerifyEvent = OBJdbConnection.Execute(SQLVerifyEvent)

 If NOT rsVerifyEvent.EOF Then 

    SQLVerifyOption = "SELECT OptionName FROM EventOptions WHERE EventOptions.OptionName = 'TicketText2' AND EventOptions.EventCode = " &  rsVerifyEvent("EventCode")  & ""
    Set rsVerifyOption = OBJdbConnection.Execute(SQLVerifyOption)

        If NOT rsVerifyOption.EOF Then     
 
            SQLCustomText = "SELECT OptionValue FROM EventOptions WHERE EventOptions.OptionName = '" &  rsVerifyOption("OptionName") & "' AND EventOptions.EventCode = " &  rsVerifyEvent("EventCode")  & ""
            Set rsCustomText = OBJdbConnection.Execute(SQLCustomText)

             If rsCustomText("OptionValue") <> "" Then 
                TicketText2= rsCustomText("OptionValue")
             End If
 
            rsCustomText.Close
            Set rsCustomText = nothing

        End If	
        
End If	
     	
rsVerifyOption.Close
Set rsVerifyOption = nothing

rsVerifyEvent.Close
Set rsVerifyEvent = nothing

'----------------------

'Event Order Confirmation Notes
			
EventOrderConfirmationNotes = ""

SQLVerifyEvent = "SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat on Event.EventCode = Seat.EventCode INNER JOIN OrderLine on Seat.ItemNumber = OrderLine.ItemNumber WHERE OrderLine.OrderNumber = " &  OrderNumber & ""
Set rsVerifyEvent = OBJdbConnection.Execute(SQLVerifyEvent)

 If NOT rsVerifyEvent.EOF Then 

    SQLVerifyOption = "SELECT OptionName FROM EventOptions WHERE EventOptions.OptionName = 'EventOrderConfirmationNotes' AND EventOptions.EventCode = " &  rsVerifyEvent("EventCode")  & ""
    Set rsVerifyOption = OBJdbConnection.Execute(SQLVerifyOption)

        If NOT rsVerifyOption.EOF Then     
 
            SQLCustomText = "SELECT OptionValue FROM EventOptions WHERE EventOptions.OptionName = '" &  rsVerifyOption("OptionName") & "' AND EventOptions.EventCode = " &  rsVerifyEvent("EventCode")  & ""
            Set rsCustomText = OBJdbConnection.Execute(SQLCustomText)

             If rsCustomText("OptionValue") <> "" Then 
                EventOrderConfirmationNotes = rsCustomText("OptionValue")
             End If
 
            rsCustomText.Close
            Set rsCustomText = nothing

        End If	
        
End If	
     	
rsVerifyOption.Close
Set rsVerifyOption = nothing

rsVerifyEvent.Close
Set rsVerifyEvent = nothing

'----------------------


'Date Suppress Options

SQLVerifyEventCode = "SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat on Event.EventCode = Seat.EventCode INNER JOIN OrderLine on Seat.ItemNumber = OrderLine.ItemNumber WHERE OrderLine.OrderNumber = " &  OrderNumber & ""
Set rsVerifyEventCode = OBJdbConnection.Execute(SQLVerifyEventCode)

If NOT rsVerifyEventCode.EOF Then 

    SQLVerifyOption = "SELECT OptionName FROM EventOptions WHERE EventOptions.OptionName = 'DateSuppress' AND EventOptions.EventCode = " &  rsVerifyEventCode("EventCode")  & ""
    Set rsVerifyOption = OBJdbConnection.Execute(SQLVerifyOption)

        If NOT rsVerifyOption.EOF Then     
 
            SQLOptionFlag = "SELECT OptionValue FROM EventOptions WHERE EventOptions.OptionName = '" &  rsVerifyOption("OptionName") & "' AND EventOptions.EventCode = " &  rsVerifyEventCode("EventCode")  & ""
            Set rsOptionFlag = OBJdbConnection.Execute(SQLOptionFlag)

             If rsOptionFlag("OptionValue") = "Y" Then 
                DateSuppress = "True"
             End If
 
            rsOptionFlag.Close
            Set rsOptionFlag = nothing

        End If	
        
End If	
     	
rsVerifyOption.Close
Set rsVerifyOption = nothing

rsVerifyEventCode.Close
Set rsVerifyEventCode = nothing

'----------------------

'Time Suppress Options

SQLVerifyEventCode = "SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat on Event.EventCode = Seat.EventCode INNER JOIN OrderLine on Seat.ItemNumber = OrderLine.ItemNumber WHERE OrderLine.OrderNumber = " &  OrderNumber & ""
Set rsVerifyEventCode = OBJdbConnection.Execute(SQLVerifyEventCode)

If NOT rsVerifyEventCode.EOF Then 

    SQLVerifyOption = "SELECT OptionName FROM EventOptions WHERE EventOptions.OptionName = 'TimeSuppress' AND EventOptions.EventCode = " &  rsVerifyEventCode("EventCode")  & ""
    Set rsVerifyOption = OBJdbConnection.Execute(SQLVerifyOption)

        If NOT rsVerifyOption.EOF Then     
 
            SQLOptionFlag = "SELECT OptionValue FROM EventOptions WHERE EventOptions.OptionName = '" &  rsVerifyOption("OptionName") & "' AND EventOptions.EventCode = " &  rsVerifyEventCode("EventCode")  & ""
            Set rsOptionFlag = OBJdbConnection.Execute(SQLOptionFlag)

             If rsOptionFlag("OptionValue") = "Y" Then 
                TimeSuppress = "True"
             End If
 
            rsOptionFlag.Close
            Set rsOptionFlag = nothing

        End If	
        
End If	
     	
rsVerifyOption.Close
Set rsVerifyOption = nothing

rsVerifyEventCode.Close
Set rsVerifyEventCode = nothing


'===============================================

'Find the OrderNumber for this Ticket.  Check using both OrderNumber and TicketNumber for added security.
SQLOrderNum = "SELECT OrderNumber FROM Ticket (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND TicketNumber = '" & TicketNumber & "'"
Set rsOrderNum = OBJdbConnection.Execute(SQLOrderNum)

If Not rsOrderNum.EOF Then

	'Check the Order for ETicket (ShipCode=13)
    SQLTix = "SELECT OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipCountry, OrderLine.ShipPostalCode, OrderLine.Price, OrderLine.Discount AS LineDiscount, OrderLine.Price - OrderLine.Discount AS NetPrice, OrderLine.ItemType, OrderHeader.OrderNumber, OrderHeader.Subtotal, OrderHeader.ShipFee, OrderHeader.OrderSurcharge, OrderHeader.Total, OrderHeader.Discount AS OrderDiscount, OrderDate, OrderHeader.OrderTypeNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.Country, Customer.PostalCode, Seat.ItemNumber, Seat.Row, Seat.Seat, Section.SectionCode, Section.Section, Event.EventCode, Event.EventDate, Event.Phone AS EventPhoneNumber, Event.EMailAddress AS EventEMailAddress, Event.Map, Act.Act, Act.Actcode, Act.ShortAct, Act.Comments AS ActComments, Event.Comments AS EventComments, Venue.Venue, Venue.Address_1 AS VenueAddress1, Venue.Address_2 AS VenueAddress2, Venue.City AS VenueCity, Venue.State AS VenueState, Venue.Zip_Code AS VenuePostalCode, SeatType.SeatType, Shipping.ShipType, OrderType, Organization.Organization, Ticket.TicketNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ShipCode = 13 AND Ticket.StatusCode = 'A' AND OrganizationVenue.Owner = 1"
	Set rsTix = OBJdbConnection.Execute(SQLTix)

	If Not rsTix.EOF Then

		SQLTotalTix = "SELECT COUNT(TicketNumber) AS TotalTix FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ShipCode = 13 AND Ticket.StatusCode = 'A' AND OrderLine.ItemType = 'SubFixedEvent' AND OrganizationVenue.Owner = 1"
		Set rsTotalTix = OBJdbConnection.Execute(SQLTotalTix)
		
		TotalTix = rsTotalTix("TotalTix")
		
		rsTotalTix.Close
		Set rsTotalTix = nothing

		Response.Write "<HTML>" & vbCrLf
		Response.Write "<HEAD>" & vbCrLf
		Response.Write "<TITLE>www.TIX.com - E-Ticket</TITLE>" & vbCrLf
		Response.Write "</HEAD>" & vbCrLf
		Response.Write "<BODY onLoad=""window.print()"">" & vbCrLf
		
        %>
                
        <style type="text/css">
            
        .PageBreak {page-break-before: always}
        
        div {page-break-before: always}
            
        body
        {
        font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
        line-height: 1 em;
        }
        #upperhalf td
        {
	    padding-left: 15px;
	    padding-right: 15px;
	    padding-top: 15px;
	    padding-bottom: 15px;
        }
        #lowerhalf
        {
        font-size: 10px;
        font-weight: 400;
        text-align: left;
        border-collapse: collapse;
        }
        #lowerhalf td
        {
	    padding-left: 5px;
	    padding-right: 5px;
	    padding-top: 5px;
	    padding-bottom: 5px;
        }
        #lowerhalf b
        {
        font-size: 11px;
        font-weight: 600;
        }
        </style>
        
        <%

		
		Response.Write "</STYLE>" & vbCrLf

		Response.Write "<CENTER>" & vbCrLf

        TixCount = 0
		Do Until rsTix.EOF	
			
'===============================================
'E-Ticket - Individual Event
'===============================================

If rsTix("ItemType") = "Seat" Then

	        If TixCount <> 0 And TixCount < TotalTix Then
		        Response.Write "<DIV>&nbsp;</DIV>" 'Page Break
	        End If

		    Response.Write "<TABLE WIDTH=""620"" BORDER=""0"">" & vbCrLf
            Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""4""><B>THIS IS YOUR TICKET.  " & "<FONT FACE=""Arial, Helvetica"" SIZE=""3"">Present this entire page at the event.</B></FONT>" & vbCrLf 
			Response.Write "<BR>" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD VALIGN=""top"">" & vbCrLf
			
                '-------------------------
                'Custom Background Option 
                '-------------------------
			
			
                    ETicketBackground = "/Images/ETicketBackground.gif"

                    If CustomETicketBackground <> "" Then
                    ETicketBackground = CustomETicketBackground
                    End If
			
			        Response.Write "<TABLE WIDTH=""615"" HEIGHT=""240"" BORDER=""1"" BACKGROUND=""" & ETicketBackground & """ BGCOLOR=""" & CustomBackgroundColor & """ CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
    			    
			        Response.Write "<TR>" & vbCrLf			    
			        Response.Write "<TD WIDTH=""500"" VALIGN=""top"">" & vbCrLf
			    
			        Response.Write "<TABLE BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
			        Response.Write "<TR>" & vbCrLf
			        Response.Write "<TD WIDTH=""220"" HEIGHT=""70"" VALIGN=""top"">" & vbCrLf
			
			    '---------------------
                'Custom Logo Option 
                '---------------------

                    ETicketLogo = "/Images/ETicketLogo.gif"
        			
			        If CustomETicketLogo <> "" Then
			            ETicketLogo = CustomETicketLogo
			        End If
					        
                    Response.Write "<IMG src=""" & ETicketLogo & """>" & vbCrLf        
			
			        Response.Write "</TD>" & vbCrLf
			        Response.Write "<TD VALIGN=""top"" ALIGN=""right"">" & vbCrLf
			
			        'REE 7/8/6 - Modified to allow flexible length ticket numbers.  Insert dash after every 4th digit.
			        TicketDigit = 1
			        ETicketNumber = ""
			        Do Until TicketDigit >= Len(rsTix("TicketNumber"))
				        If TicketDigit < Len(rsTix("TicketNumber")) - 4 Then
					        ETicketNumber = ETicketNumber & Mid(rsTix("TicketNumber"), TicketDigit, 4) & "-"
					        TicketDigit = TicketDigit + 4
				        Else
					        ETicketNumber = ETicketNumber & Mid(rsTix("TicketNumber"), TicketDigit, (Len(rsTix("TicketNumber")) - TicketDigit) + 1)
					        TicketDigit = Len(rsTix("TicketNumber"))
				        End If
			        Loop
			        Response.Write "<FONT FACE=""Verdana,Arial,Helvetica"" SIZE=""1"">" & ETicketNumber & "&nbsp;&nbsp;&nbsp;&nbsp;" & rsTix("OrderNumber") & " - " & rsTix("ItemNumber") & "</FONT></TD>" & vbCrLf '********** ADDED FOR TEST DRIVE **********
					
			        Response.Write "</TD>" & vbCrLf
			        Response.Write "</TR>" & vbCrLf
			        Response.Write "</TABLE>" & vbCrLf
			        Response.Write "<TABLE BORDER=""0"" CELLPADDING=""10"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
			        Response.Write "<TR>" & vbCrLf

			        Response.Write "</TD>" & vbCrLf
			        Response.Write "<TD VALIGN=""top"">" & vbCrLf
			
'Producer Name Option 
'---------------------

            ETicketProducer = ""
			
			If ShowPresents <> "" Then
			
                Select Case ShowPresents
                
                    Case "Producer"
                        SQLNewProducer = "SELECT Producer FROM Act WHERE ActCode = " & rsTix("ActCode") & ""
                        Set rsNewProducer = OBJdbConnection.Execute(SQLNewProducer)
                            If NOT rsNewProducer.EOF Then    
                                If rsNewProducer("Producer") <> "" Then 
                                    ETicketProducer = rsNewProducer("Producer")
                                End If
			                End If
                        rsNewProducer.Close
                        Set rsNewProducer = nothing	
			        
                    Case "Organization"
                    
                        ETicketProducer = rsTix("Organization") + "&nbsp;presents"
                        
                    Case Else
                    
                        ETicketProducer = ""
                    
                End Select
                
            End If
            
			
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><I>" & ETicketProducer & "</I></FONT><BR>" & vbCrLf
			
                    '-----------------
                    'Short Act Option 
                    '-----------------
			
			        ETicketAct = rsTix("Act")
        			
			        If ShowShortAct Then
        			
			            SQLNewAct = "SELECT ShortAct FROM Act WHERE ActCode = " & rsTix("ActCode") & ""
                        Set rsNewAct = OBJdbConnection.Execute(SQLNewAct)
                        
                         If NOT rsNewAct.EOF Then     
                        
                             If rsNewAct("ShortAct") <> "" Then 
                                ETicketAct = rsNewAct("ShortAct")
                             End If
                         
                            rsNewAct.Close
                            Set rsNewAct = nothing
             
			             End If		
        			     	
			        End If	
			
			        Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""5""><B>" & ETicketAct & "</B></FONT><BR>" & vbCrLf
        			
			        Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3""><B>" & rsTix("Venue") & "</B></FONT><BR>" & vbCrLf
			
                    '---------------------------			
                    'Date / Time Suppress Option
                    '---------------------------	
                    
                    ETicketDate = FormatDateTime(rsTix("EventDate"), vbLongDate)		
		    
		            If DateSuppress Then	    		
			            ETicketDate = "<BR>"
			        End If
			        
			        
			        ETicketTime = Left(FormatDateTime(rsTix("EventDate"),vbLongTime),Len(FormatDateTime(rsTix("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("EventDate"),vbLongTime),3)
			        
			        If TimeSuppress Then	    		
			            ETicketTime = "<BR>"
			        End If
			
			        Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3"">" & ETicketDate & " " & ETicketTime & "" & vbCrLf
			        
			        '-------------------
                    'Seat Type / Price
                    '-------------------

			         Response.Write "<BR><BR>" & vbCrLf
			         Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2"">" & rsTix("SeatType") & "  $" & FormatNumber(rsTix("Price"),2) & "</FONT>" & vbCrLf
			        'Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2"">" & rsTix("SeatType") & "</FONT>" & vbCrLf
			
			        '-------------------------------------------------------------	
                    'Display Reserved Section / Hide GA Section
                    '-------------------------------------------------------------	
					
                    If rsTix("Map") = "general" Then
		                Response.Write "&nbsp;" & vbCrLf
                    Else
                        Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><B>Section: " & rsTix("Section") & "&nbsp;&nbsp;&nbsp;&nbsp;Row: " & rsTix("Row") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Seat: " & rsTix("Seat") & "</B></FONT><BR>" & vbCrLf
                    End If
            	
            	
            		'-------------------------------------------------------------	
                    'Ticket Text 1 Option
                    '-------------------------------------------------------------	
                    
            	    Response.Write " " & TicketText1 & " " & vbCrLf
            	
		            Response.Write "</TD>" & vbCrLf
		            Response.Write "</TR>" & vbCrLf
		            Response.Write "</TABLE>" & vbCrLf
			        Response.Write "</TD>" & vbCrLf

                    '--------------------			    
                    'Show BarCode Option
                    '--------------------
                    
				    If ShowBarCode Then	
    								
			            Response.Write "<TD ALIGN=""center"" VALIGN=""center"">" & vbCrLf
			            Response.Write "<IMG alt=""Barcode Image"" src=""/Barcode.asp?Barcode=" & rsTix("TicketNumber") & "&Rotate=270"">&nbsp;" & vbCrLf
			            Response.Write "</TD>" & vbCrLf
    			    
			        End If
			    
			        Response.Write "</TR>" & vbCrLf
					  
			        Response.Write "<TR>" & vbCrLf
			        Response.Write "<TD ALIGN=""center"" COLSPAN=""2"" VALIGN=""bottom"" BGCOLOR=""#000000"" HEIGHT=""20"">" & vbCrLf
			        
			        '--------------------------
                    'Custom Bottom Bar Option 
                    '--------------------------
                
                    ETicketBottomBar = "/Images/ETicketBottomBar.gif"
        			
		            If CustomETicketBottomBar <> "" Then
		                ETicketBottomBar = CustomETicketBottomBar
		            End If
					        
                    Response.Write "<IMG src=""" & ETicketBottomBar & """>" & vbCrLf			        

			        Response.Write "</TD>" & vbCrLf
			        Response.Write "</TR>" & vbCrLf
			        Response.Write "</TABLE>" & vbCrLf
			        
			        
			    Response.Write "</TD>" & vbCrLf
			    Response.Write "</TR>" & vbCrLf
			    Response.Write "</TABLE>" & vbCrLf
			        
			
'---------------------------------
'Order Information - Single Event
'---------------------------------
        		
		
			
'Order Information
'Billing Information
'General Information

            Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" CELLPADDING=""5"" CELLSPACING=""5"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			
			'------------------------------------------------------
			
			Response.Write "<TD VALIGN=""top"" WIDTH = ""33%"">" & vbCrLf		
			
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			Response.Write "<B>ORDER INFORMATION</B><BR><BR>" & vbCrLf
			Response.Write "Order Number:&nbsp;&nbsp;" & rsTix("OrderNumber") & "<BR>" & vbCrLf
			Response.Write "Order Date:&nbsp;&nbsp;" & FormatDateTime(rsTix("OrderDate"), vbShortDate) & "<BR>" & vbCrLf
			Response.Write "Order Time:&nbsp;&nbsp;" & FormatDateTime(rsTix("OrderDate"), vbShortTime) & "<BR>" & vbCrLf
			Response.Write "Order Total:&nbsp;&nbsp;" & FormatCurrency(rsTix("Total"),2)& "<BR>" & vbCrLf
			Response.Write "<BR>" & vbCrLf						
			Response.Write "</FONT>" & vbCrLf			
			
			Response.Write "</TD>" & vbCrLf	
			
			'------------------------------------------------------			
					
			Response.Write "<TD VALIGN=""top"" WIDTH = ""33%"">" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			
			Response.Write "<B>BILLING INFORMATION</B><BR><BR>" & vbCrLf
			Response.Write rsTix("FirstName") & " " & rsTix("LastName") & "<BR>" & vbCrLf
			Response.Write rsTix("Address1") & "<BR>" & vbCrLf
			If rsTix("Address2") <> "" Then
				Response.Write rsTix("Address2") & "<BR>" & vbCrLf
			End If
			Response.Write rsTix("City") & ", " & rsTix("State") & " " & rsTix("PostalCode") & "<BR>" & vbCrLf
            
			Response.Write "</TD>" & vbCrLf
			
			'------------------------------------------------------	
				
			Response.Write "<TD VALIGN=""top"" WIDTH = ""34%"">" & vbCrLf
			
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			Response.Write "<B>GENERAL INFORMATION</B><BR><BR>" & vbCrLf
			Response.Write "</FONT>" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""1"">" & vbCrLf
			Response.Write "NO REFUNDS - NO EXCHANGES.  DO NOT COPY THIS TICKET.  MULTIPLE COPIES INVALID.  Holder assumes all risk and danger including, without limitation, injury, death, personal loss, property damage, or other related harm.  Management reserves the right to refuse admission or eject any person who fails to comply with the terms and conditions and/or rules for the event in which this ticket is issued." & vbCrLf
			Response.Write "</FONT>" & vbCrLf
			
			Response.Write "</TD>" & vbCrLf
			
			Response.Write "</TR>" & vbCrLf
						
			
			'------------------------------------------------------	
			
'BarCode 1
			Response.Write "<TR>" & vbCrLf

	        Response.Write "<TD VALIGN=""top"" WIDTH = ""34%"">" & vbCrLf						
			Response.Write "<IMG alt=""Barcode Image"" src=""/Barcode.asp?Barcode=" & rsTix("TicketNumber") & """><BR>" & vbCrLf
			Response.Write "<BR>" & vbCrLf
			Response.Write "</TD>" & vbCrLf 
	        
	        Response.Write "<TD VALIGN=""top"" WIDTH = ""34%"">" & vbCrLf
	        Response.Write "<BR>" & vbCrLf
	        Response.Write "</TD>" & vbCrLf
	        
	        Response.Write "<TD VALIGN=""top"" WIDTH = ""34%"">" & vbCrLf
	        Response.Write "<BR>" & vbCrLf
	        Response.Write "</TD>" & vbCrLf
			 
			
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			
			
			'------------------------------------------------------	
 'Begin Ad Space		   

			Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD ALIGN=""center"">" & vbCrLf
			Response.Write "<IMG SRC=""/Clients/ClassicAutoSpa/ETicket/Images/ETicketAd.jpg"" WIDTH=""300"">" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
            

            Response.Write "<DIV>&nbsp;</DIV>" 'Page Break
       
            
'===============================================
'E-Ticket - Subscription Event
'===============================================		
            
		
ElseIf rsTix("ItemType") = "SubSeat" Then


            'Grab the child event within the subscription
			 SQLChildEvent = "SELECT Event.EventCode FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.Eventcode = Event.EventCode WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ItemType = 'SubSeat' AND ParentLineNumber IN (SELECT ParentLineNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ItemNumber = " & rsTix("ItemNumber") & ")"
			 Set rsChildEvent  = OBJdbConnection.Execute(SQLChildEvent)
			    ChildEventCode = rsChildEvent("EventCode")
            rsChildEvent.Close   
            Set rsChildEvent = Nothing 
			
			'Determine if this is the current event			
			If ChildEventCode = rsTix("EventCode") Then
			
            If TixCount <> 0 And TixCount < TotalTix Then
            'REE 3/9/7 - Added space inbetween DIV tag to resolve IE 7 Page Break issue.
            Response.Write "<DIV>&nbsp;</DIV>" 'Page Break
            End If
			 
			 'Determine the parent event code for this subscription
			 SQLParentEvent = "SELECT  SubscriptionNumber FROM SubscriptionEvent (NOLOCK)WHERE EventCode = " &  ChildEventCode & ""
			 Set rsParentEvent  = OBJdbConnection.Execute(SQLParentEvent)
			    ParentEventCode = rsParentEvent("SubscriptionNumber")
			 rsParentEvent.Close   
             Set rsParentEvent = Nothing 
			    
			    'Determine the Parent Act Name
                SQLPackages = "SELECT Act.Act FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE Event.EventCode = " & ParentEventCode  & " "
                Set rsPackages = OBJdbConnection.Execute(SQLPackages)           
                ParentActName = rsPackages("Act")
                rsPackages.Close   
                Set rsPackages = Nothing 
                    
                'Determine the Parent TicketType and Price
                SQLSeatType = "SELECT Price.SeatTypeCode, SeatType.SeatType, Price.Price FROM Price (NOLOCK) INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Price.EventCode = " & ParentEventCode  & ""
	            Set rsSeatType = OBJdbConnection.Execute(SQLSeatType)
	                ParentSeatType = rsSeatType("SeatType")
	                ParentPrice = rsSeatType("Price")
                rsSeatType.Close   
                Set rsrsSeatType = Nothing                


		    Response.Write "<TABLE WIDTH=""620"" BORDER=""0"">" & vbCrLf
            Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""4""><B>THIS IS YOUR TICKET.  " & "<FONT FACE=""Arial, Helvetica"" SIZE=""3"">Present this entire page at the event.</B></FONT>" & vbCrLf 
			Response.Write "<BR>" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD VALIGN=""top"">" & vbCrLf
			
            '-------------------------
            'Custom Background Option 
            '-------------------------
			
                    ETicketBackground = "/Images/ETicketBackground.gif"

                    If CustomETicketBackground <> "" Then
                    ETicketBackground = CustomETicketBackground
                    End If
			
			        Response.Write "<TABLE WIDTH=""615"" HEIGHT=""240"" BORDER=""1"" BACKGROUND=""" & ETicketBackground & """ BGCOLOR=""" & CustomBackgroundColor & """ CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
			   
			        Response.Write "<TR>" & vbCrLf			    
			        Response.Write "<TD WIDTH=""500"" VALIGN=""top"">" & vbCrLf
			    
			        Response.Write "<TABLE BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
			        Response.Write "<TR>" & vbCrLf
			        Response.Write "<TD WIDTH=""220"" HEIGHT=""70"" VALIGN=""top"">" & vbCrLf
			
			'---------------------
            'Custom Logo Option 
            '---------------------

                    ETicketLogo = "/Images/ETicketLogo.gif"
        			
			        If CustomETicketLogo <> "" Then
			            ETicketLogo = CustomETicketLogo
			        End If
					        
                    Response.Write "<IMG src=""" & ETicketLogo & """>" & vbCrLf        
			
			        Response.Write "</TD>" & vbCrLf
			        Response.Write "<TD VALIGN=""top"" ALIGN=""right"">" & vbCrLf
			
			        TicketDigit = 1
			        ETicketNumber = ""
			        Do Until TicketDigit >= Len(rsTix("TicketNumber"))
				        If TicketDigit < Len(rsTix("TicketNumber")) - 4 Then
					        ETicketNumber = ETicketNumber & Mid(rsTix("TicketNumber"), TicketDigit, 4) & "-"
					        TicketDigit = TicketDigit + 4
				        Else
					        ETicketNumber = ETicketNumber & Mid(rsTix("TicketNumber"), TicketDigit, (Len(rsTix("TicketNumber")) - TicketDigit) + 1)
					        TicketDigit = Len(rsTix("TicketNumber"))
				        End If
			        Loop
			        Response.Write "<FONT FACE=""Verdana,Arial,Helvetica"" SIZE=""1"">" & ETicketNumber & "&nbsp;&nbsp;&nbsp;&nbsp;" & rsTix("OrderNumber") & " - " & rsTix("ItemNumber") & "</FONT></TD>" & vbCrLf '********** ADDED FOR TEST DRIVE **********
					
			        Response.Write "</TD>" & vbCrLf
			        Response.Write "</TR>" & vbCrLf
			        Response.Write "</TABLE>" & vbCrLf
			        Response.Write "<TABLE BORDER=""0"" CELLPADDING=""10"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
			        Response.Write "<TR>" & vbCrLf

			        Response.Write "</TD>" & vbCrLf
			        Response.Write "<TD VALIGN=""top"">" & vbCrLf
			        
			'---------------------
            'Producer Name Option 
            '---------------------

                    ETicketProducer = ""
        			
			        If ShowPresents <> "" Then
        			
                        Select Case ShowPresents
                        
                            Case "Producer"
                                SQLNewProducer = "SELECT Producer FROM Act WHERE ActCode = " & rsTix("ActCode") & ""
                                Set rsNewProducer = OBJdbConnection.Execute(SQLNewProducer)
                                    If NOT rsNewProducer.EOF Then    
                                        If rsNewProducer("Producer") <> "" Then 
                                            ETicketProducer = rsNewProducer("Producer")
                                        End If
			                        End If
                                rsNewProducer.Close
                                Set rsNewProducer = nothing	
        			        
                            Case "Organization"
                            
                                ETicketProducer = rsTix("Organization") + "&nbsp;presents"
                                
                            Case Else
                            
                                ETicketProducer = ""
                            
                        End Select
                        
                    End If
                    
        			
			        Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><I>" & ETicketProducer & "</I></FONT><BR>" & vbCrLf
			
            '-----------------
            'Short Act Option 
            '-----------------
			
			        ETicketAct  = ParentActName
        			
			        If ShowShortAct Then
        			
			            SQLNewAct = "SELECT ShortAct FROM Act WHERE ActCode = " & rsTix("ActCode") & ""
                        Set rsNewAct = OBJdbConnection.Execute(SQLNewAct)
                        
                         If NOT rsNewAct.EOF Then     
                        
                             If rsNewAct("ShortAct") <> "" Then 
                                ETicketAct = rsNewAct("ShortAct")
                             End If
                         
                            rsNewAct.Close
                            Set rsNewAct = nothing
             
			             End If		
        			     	
			        End If	
			
			        Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""5""><B>" & ETicketAct & "</B></FONT><BR>" & vbCrLf
			        
			        
            '--------------------
            'Venue
            '--------------------
        			
			        Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3""><B>" & rsTix("Venue") & "</B></FONT>" & vbCrLf
			
            '---------------------------			
            'Date / Time Suppress Option
            '---------------------------	
                    
                    ETicketDate = FormatDateTime(rsTix("EventDate"), vbLongDate)	
		    
		            If DateSuppress Then	    		
			            ETicketDate = ""
			        End If
			        
			        
			        ETicketTime = Left(FormatDateTime(rsTix("EventDate"),vbLongTime),Len(FormatDateTime(rsTix("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("EventDate"),vbLongTime),3)
			        
			        If TimeSuppress Then	    		
			            ETicketTime = ""
			        End If
			
			        Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3"">" & ETicketDate & " " & ETicketTime & "" & vbCrLf
			        
            '--------------------
            'Seat Type and Price
            '--------------------
            
                    ETicketSeatType  = ParentSeatType
                    ETicketPrice  = ParentPrice
			        Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2"">" & ETicketSeatType & "  $" & FormatNumber(ETicketPrice ,2) & "</FONT>" & vbCrLf
			
			'-------------------------------------------------------------	
            'Display Reserved Section / Hide GA Section
            '-------------------------------------------------------------	
					
                    If rsTix("Map") = "general" Then
		                Response.Write "&nbsp;" & vbCrLf
                    Else
                        Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><B>Section: " & rsTix("Section") & "&nbsp;&nbsp;&nbsp;&nbsp;Row: " & rsTix("Row") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Seat: " & rsTix("Seat") & "</B></FONT><BR>" & vbCrLf
                    End If
            	
            	
            '------------------------	
            'Ticket Text 1 Option
            '------------------------
            
            	    Response.Write "" & TicketText1 & " " & vbCrLf
            	
		            Response.Write "</TD>" & vbCrLf
		            Response.Write "</TR>" & vbCrLf
		            Response.Write "</TABLE>" & vbCrLf
			        Response.Write "</TD>" & vbCrLf

            '--------------------			    
            'Show BarCode Option
            '--------------------
                    
				    If ShowBarCode Then	
    								
			            Response.Write "<TD ALIGN=""center"" VALIGN=""center"">" & vbCrLf
			            Response.Write "<IMG alt=""Barcode Image"" src=""/Barcode.asp?Barcode=" & rsTix("TicketNumber") & "&Rotate=270"">&nbsp;" & vbCrLf
			            Response.Write "</TD>" & vbCrLf
    			    
			        End If
			    
			        Response.Write "</TR>" & vbCrLf
					  
			        Response.Write "<TR>" & vbCrLf
			        Response.Write "<TD ALIGN=""center"" COLSPAN=""2"" VALIGN=""bottom"" BGCOLOR=""#000000"" HEIGHT=""20"">" & vbCrLf
			        
			        
			'--------------------------
            'Custom Bottom Bar Option 
            '--------------------------
                
                    ETicketBottomBar = "/Images/ETicketBottomBar.gif"
        			
		            If CustomETicketBottomBar <> "" Then
		                ETicketBottomBar = CustomETicketBottomBar
		            End If
					        
                    Response.Write "<IMG src=""" & ETicketBottomBar & """>" & vbCrLf			        

			        Response.Write "</TD>" & vbCrLf
			        Response.Write "</TR>" & vbCrLf
			        Response.Write "</TABLE>" & vbCrLf
			        
			        
			    Response.Write "</TD>" & vbCrLf
			    Response.Write "</TR>" & vbCrLf
			    Response.Write "</TABLE>" & vbCrLf
			    
'=======================
'End Ticket

'Begin Body Space

'Start Order Details
'=======================

			        Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" CELLPADDING=""5"" CELLSPACING=""5"">" & vbCrLf	
        			
			        Response.Write "<TR>" & vbCrLf
			
			'--------------------------
            'Order Information
            '--------------------------
			
			        Response.Write "<TD VALIGN=""top"" WIDTH = ""33%"">" & vbCrLf		
        			
			        Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			        Response.Write "<B>ORDER INFORMATION</B><BR><BR>" & vbCrLf
			        Response.Write "Order Number:&nbsp;&nbsp;" & rsTix("OrderNumber") & "<BR>" & vbCrLf
			        Response.Write "Order Date:&nbsp;&nbsp;" & FormatDateTime(rsTix("OrderDate"), vbShortDate) & "<BR>" & vbCrLf
			        Response.Write "Order Time:&nbsp;&nbsp;" & FormatDateTime(rsTix("OrderDate"), vbShortTime) & "<BR>" & vbCrLf
			        Response.Write "Order Total:&nbsp;&nbsp;" & FormatCurrency(rsTix("Total"),2)& "<BR>" & vbCrLf
			        Response.Write "<BR>" & vbCrLf						
			        Response.Write "</FONT>" & vbCrLf			
        			
			        Response.Write "</TD>" & vbCrLf	
			
			'--------------------------
            'Billing Information
            '--------------------------	
					
			        Response.Write "<TD VALIGN=""top"" WIDTH = ""33%"">" & vbCrLf
			        Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
        			
			        Response.Write "<B>BILLING INFORMATION</B><BR><BR>" & vbCrLf
			        Response.Write rsTix("FirstName") & " " & rsTix("LastName") & "<BR>" & vbCrLf
			        Response.Write rsTix("Address1") & "<BR>" & vbCrLf
			        If rsTix("Address2") <> "" Then
				        Response.Write rsTix("Address2") & "<BR>" & vbCrLf
			        End If
			        Response.Write rsTix("City") & ", " & rsTix("State") & " " & rsTix("PostalCode") & "<BR>" & vbCrLf
                    
			        Response.Write "</TD>" & vbCrLf
			
			'--------------------------
            'General Information
            '--------------------------
				
			        Response.Write "<TD VALIGN=""top"" WIDTH = ""34%"">" & vbCrLf
        			
			        Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			        Response.Write "<B>GENERAL INFORMATION</B><BR><BR>" & vbCrLf
			        Response.Write "</FONT>" & vbCrLf
			        Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""1"">" & vbCrLf
			        Response.Write "NO REFUNDS - NO EXCHANGES.  DO NOT COPY THIS TICKET.  MULTIPLE COPIES INVALID.  Holder assumes all risk and danger including, without limitation, injury, death, personal loss, property damage, or other related harm.  Management reserves the right to refuse admission or eject any person who fails to comply with the terms and conditions and/or rules for the event in which this ticket is issued." & vbCrLf
			        Response.Write "</FONT>" & vbCrLf
        			
			        Response.Write "</TD>" & vbCrLf
			
			'--------------------------
            'Bar Codes
            '--------------------------
			 
			    SQLChildBarCode = "SELECT Ticket.TicketNumber, Event.EventDate, Event.ActCode FROM Ticket (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON Ticket.ItemNumber = OrderLine.ItemNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.Eventcode = Event.EventCode WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ItemType = 'SubSeat' AND Ticket.StatusCode = 'A'  AND ParentLineNumber IN (SELECT ParentLineNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ItemNumber = " & rsTix("ItemNumber") & ") ORDER BY Event.EventDate"
			    Set rsChildBarCode = OBJdbConnection.Execute(SQLChildBarCode)
			    
			    CellNumber = 1
			    
			    Do While Not rsChildBarCode.EOF 
			    
			        CellCount = CellNumber Mod 3
			        
			        If CellCount = 1 Then
			            Response.Write "<TR>" & vbCrLf
			            Response.Write "<TD align=""center"">" & vbCrLf
			        Else
			            Response.Write "<TD align=""center"">" & vbCrLf
			        End If
			    			    
			        SQLActName = "SELECT Act FROM Act (NOLOCK) WHERE ActCode = " & rsChildBarCode("ActCode")& ""
			        Set rsActName = OBJdbConnection.Execute(SQLActName)
			        Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2""><B>" & rsActName("Act")& "<Br>" & vbCrLf
                    rsActName.Close
                    Set rsActName = Nothing 
			        Response.Write "<IMG alt=""Barcode Image"" src=""/Barcode.asp?Barcode=" & rsChildBarCode("TicketNumber") & """><BR><BR>" & vbCrLf
			        Response.Write "</B></FONT>" & vbCrLf
			        
                    If CellCount = 0 Then
                        Response.Write "</TD>" & vbCrLf
                        Response.Write "</TR>" & vbCrLf
                    Else
                        Response.Write "</TD>" & vbCrLf
                    End If
			        
			        CellNumber = CellNumber + 1
			        
			    rsChildBarCode.MoveNext
			    Loop
			    rsChildBarCode.Close
			    Set rsChildBarCode = Nothing    
			    Response.Write "</FONT>" & vbCrLf
			
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
		    
'------------------------------------------------------	
'End Order Information

            ErrorLog ("CellNumber: " & CellNumber & "")

            If CellNumber < 6 Then

		        'Begin Ad Space

			    Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
			    Response.Write "<TR>" & vbCrLf
			    Response.Write "<TD ALIGN=""center"">" & vbCrLf
			    Response.Write "<IMG SRC=""/Clients/ClassicAutoSpa/ETicket/Images/ETicketAd.jpg"" WIDTH=""300"">" & vbCrLf
			    Response.Write "</TD>" & vbCrLf
			    Response.Write "</TR>" & vbCrLf
			    Response.Write "</TABLE>" & vbCrLf
			    
			End If

		    'End Ad Space
		    
		    If TixCount < TotalTix Then
				Response.Write "<DIV CLASS=""PageBreak"">&nbsp;</DIV>" 'Page Break
			End If		    
		        
		    End If
		
		End If
		

			
			rsTix.MoveNext

		Loop   

		

		Response.Write "</CENTER>" & vbCrLf
		Response.Write "</BODY>" & vbCrLf
		Response.Write "</HTML>" & vbCrLf

	Else

		ETicketError("ETicketFormat - Ticket #" & TicketNumber)
		ErrorLog("ETicketPrint - Invalid Ticket - Order #" & OrderNumber & " - Ticket #" & TicketNumber & " - " & SQLTix)

	End If

	rsTix.Close
	Set rsTix = nothing

Else

	ETicketError("Invalid Ticket")
	ErrorLog("ETicketPrint - Invalid Ticket - Order #" & OrderNumber & " - Ticket #" & TicketNumber)

End If


rsOrderNum.Close
Set rsOrderNum = nothing



%>
  