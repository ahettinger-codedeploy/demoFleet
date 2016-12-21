<%

'CHANGE LOG - Inception
'SSR 3/29/2011
'Subscription Reminder. 

%>

<!--#INCLUDE virtual=GlobalInclude.asp -->
<!--#INCLUDE virtual="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL ="ETicketInclude.asp"-->

<%

'========================================

'5/20/2011
'Viva Las Vegas
'Custom E-Ticket Format


'========================================

OrderNumber = Clean(Request("OrderNumber"))
TicketNumber = Clean(Request("TicketNumber"))

'Find the OrderNumber for this Ticket.  Check using both OrderNumber and TicketNumber for added security.
SQLOrderNum = "SELECT OrderNumber FROM Ticket (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND TicketNumber = '" & TicketNumber & "'"
Set rsOrderNum = OBJdbConnection.Execute(SQLOrderNum)

If Not rsOrderNum.EOF Then

	'Check the Order for ETicket (that is ShipCode=13)
	SQLTix = "SELECT OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipCountry, OrderLine.ShipPostalCode, OrderLine.Price, OrderLine.Discount AS LineDiscount, OrderHeader.OrderNumber, OrderHeader.Subtotal, OrderHeader.ShipFee, OrderHeader.OrderSurcharge, OrderHeader.Total, OrderHeader.Discount AS OrderDiscount, OrderDate, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.Country, Customer.PostalCode, Seat.ItemNumber, Seat.Row, Seat.Seat, Section.SectionCode, Section.Section, Event.EventCode, Event.EventDate, Event.Map, Event.Phone AS EventPhoneNumber, Event.EMailAddress AS EventEMailAddress, Act.Act, Act.ActCode, Act.ShortAct, Act.Producer, Act.Comments AS ActComments, Event.Comments AS EventComments, Venue.VenueCode, Venue.Venue, Venue.Address_1 AS VenueAddress1, Venue.Address_2 AS VenueAddress2, Venue.City AS VenueCity, Venue.State AS VenueState, Venue.Zip_Code AS VenuePostalCode, SeatType.SeatType, Shipping.ShipType, OrderType, Organization.Organization, Ticket.TicketNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ShipCode = 13 AND Ticket.StatusCode = 'A' AND OrganizationVenue.Owner = 1"
	Set rsTix = OBJdbConnection.Execute(SQLTix)

	If Not rsTix.EOF Then

		SQLTotalTix = "SELECT COUNT(TicketNumber) AS TotalTix FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ShipCode = 13 AND Ticket.StatusCode = 'A' AND OrganizationVenue.Owner = 1"
		Set rsTotalTix = OBJdbConnection.Execute(SQLTotalTix)		
		TotalTix = rsTotalTix("TotalTix")		
		rsTotalTix.Close
		Set rsTotalTix = nothing
%>		
		<HTML>
		<HEAD>
		<TITLE>www.TIX.com - E-Ticket</TITLE>
		</HEAD>
		<BODY onLoad="window.print()">

		<!-- Set Page Break Style -->
		
		<STYLE>
		.PageBreak {page-break-before: always}
		</STYLE>

		<CENTER>
<%
		Do Until rsTix.EOF
		
			TixCount = TixCount + 1

		'Begin Ticket
%>

<TABLE WIDTH="620" BORDER="0">
<TR>
    <TD VALIGN="top">
    
    <TABLE WIDTH="615" HEIGHT="240" BORDER="1" BACKGROUND="/Images/ETicketBackground.gif" BGCOLOR="#FFD718" CELLPADDING="0" CELLSPACING="0">
        <TR>
            <TD WIDTH="500" VALIGN="top">        
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
                    <TR>
                        <TD WIDTH="220" HEIGHT="70" VALIGN="top"><IMG SRC="/Images/ETicketLogo.gif"></TD>
                        <TD VALIGN="top" ALIGN="right">
<%			
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
%>			
			            <!-- ADDED FOR TEST DRIVE -->
			            
			            <FONT FACE="Verdana,Arial,Helvetica" SIZE="1"><%=ETicketNumber %>&nbsp;&nbsp;&nbsp;&nbsp;<%=rsTix("OrderNumber") %> - <%=rsTix("ItemNumber") %></FONT></TD>				
			            </TD>
		            </TR>
	            </TABLE>
    			
    			 <!-- Ticket Image begin -->
			    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
			        <TR>
			            <TD WIDTH="20">&nbsp;</TD>
			            <TD VALIGN="top">
			                <FONT FACE="Arial,Helvetica" SIZE="2"><I><%=rsTix("Organization") %> Presents</I></FONT><BR>
			                <FONT FACE="Arial,Helvetica" SIZE="5"><B><%=rsTix("Act") %></B></FONT><BR>
			                <FONT FACE="Arial,Helvetica" SIZE="3"><B><%=rsTix("Venue") %></B></FONT><BR>
			                <FONT FACE="Arial,Helvetica" SIZE="3"><%=FormatDateTime(rsTix("EventDate"), vbLongDate) %> at <%=Left(FormatDateTime(rsTix("EventDate"),vbLongTime),Len(FormatDateTime(rsTix("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("EventDate"),vbLongTime),3) %></FONT><BR><BR>
			                <FONT FACE="Arial,Helvetica" SIZE="2"><%=rsTix("SeatType") %>  $<%=FormatNumber(rsTix("Price"),2) %></FONT><BR>
        			
			                <!--Change section/row/seat labels if the seat map is not general admission -->

			                <% If rsTix("Map") <> "general" Then %>			
			                    <FONT FACE="Arial,Helvetica" SIZE="2"><B>Section: <%= rsTix("Section") %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Row: <%= rsTix("Row") %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Seat: <%= rsTix("Seat") %></B></FONT><BR>			
			                <% Else %>
			                    <FONT FACE="Arial,Helvetica" SIZE="2"><B><%= rsTix("Section") %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Seat: <%= rsTix("Seat") %></B></FONT><BR>			
		                    <% End If %>
        			
			            </TD>
			        </TR>
			    </TABLE>

			</TD>									
			<TD ALIGN="center" VALIGN="center"><IMG alt="Barcode Image" src="/Barcode.asp?Barcode=" & rsTix("TicketNumber") & "&Rotate=270">&nbsp;</TD>
		</TR>
        <TR>
			<TD ALIGN="center" COLSPAN="2" VALIGN="bottom" BGCOLOR="#000000" HEIGHT="20"><IMG SRC="/Images/ETicketBottomBar.gif"></TD>
		</TR>
	</TABLE>
	</TD>
	</TR>
</TABLE>

<!-- End Ticket -->

<!--  Begin Body Space -->

			<TABLE WIDTH="620" BORDER="0">
			    			    	
<!-- ------------------	-->	
<!--  Begin Left Column -->
<!-- ------------------	-->
			   
			   <TR>
			        <TD VALIGN="top" ALIGN="center" COLSPAN="3">
			        =============== Begin FREQUENTLY ASKED QUESTIONS =
			        </TD>
			  </TR>
			  <TR>
			        <TD VALIGN="top" ALIGN="center" COLSPAN="3">
			        ===============  TERMS & CONDITIONS  =============
			        </TD>
			  </TR>
			   <TR>
			        <TD VALIGN="top" ALIGN="center" COLSPAN="3">
			        ===============  GENERAL INFORMATION  =============
			        </TD>
			  </TR>
			
		            <TD VALIGN="top" WIDTH = "33%">
		            <FONT FACE="Arial, Helvetica" SIZE="2">
		            <!--  ORDER INFORMATION -->
		            <B>ORDER INFORMATION</B><BR>
		            Order Number:&nbsp;&nbsp;<%= rsTix("OrderNumber") %><BR>
		            Order Date:&nbsp;&nbsp;<%= FormatDateTime(rsTix("OrderDate"), vbShortDate) %><BR>
		            Order Time:&nbsp;&nbsp;<%= FormatDateTime(rsTix("OrderDate"), vbShortTime) %><BR>
		            Order Total:&nbsp;&nbsp;<%= FormatCurrency(rsTix("Total"),2)%><BR><BR>
			            
			            
		            <!--  Venue Information -->			
		            <TD VALIGN="top" WIDTH="33%">
		            <FONT FACE="Arial, Helvetica" SIZE="2">
		            <B>VENUE INFORMATION</B><BR>
		            <%= rsTix("Venue") %><BR>
		            <%= rsTix("VenueAddress1") %><BR>
		            <%= rsTix("VenueAddress2") %><br />			    
		            <%= rsTix("VenueCity") %>, <%= rsTix("VenueState") %> <%= rsTix("VenuePostalCode") %><BR>
		            Phone: <%= FormatPhone(rsTix("EventPhoneNumber"), "United States") %><BR><BR>
        			            
			                

			        </TD>		
			</TD>
			
<!-- -------------------- --->	
<!--  Begin Middle Column  -->
<!-- -------------------- --->
			    
			    
	    		<!--  BILLING INFORMATION -->
	            <B>BILLING INFORMATION</B><BR>
	            <%= rsTix("FirstName") %> <%= rsTix("LastName") %><BR>
	            <%= rsTix("Address1") %><BR>
	            
	            <%If rsTix("Address2") <> "" Then %>
		            <%= rsTix("Address2") %><BR>
	            <%End If%>
	            
	            <%= rsTix("City") %>, <%= rsTix("State") %> <%= rsTix("PostalCode") %><BR><BR>
	            
	            
                <!-- ATTENDEE INFORMATION -->
                <B>ATTENDEE INFORMATION</B><BR>
                <%= rsTix("ShipFirstName") %> <%= rsTix("ShipLastName") %><BR>
                <%= rsTix("ShipAddress1") %><BR>

                <%If rsTix("ShipAddress2") <> "" Then %>
                <%= rsTix("ShipAddress2") %><BR>
                <%End If%>

                <%=rsTix("ShipCity") %>, <%= rsTix("ShipState") %> <%= rsTix("ShipPostalCode") %><BR><BR></FONT>
			
			
<!-- -------------------- --->	
<!--     Right Column     --->
<!-- -------------------- --->
			    
			    <!---- BarCode and Map ---->
			   <!--  Venue Information -->	
			    <TD VALIGN="top" WIDTH="34%">
			    <IMG alt="Barcode Image" src="/Barcode.asp?Barcode="<%= rsTix("TicketNumber") %>"><BR>
			    <BR>				        	       
	        
                <FONT FACE="Arial, Helvetica" SIZE="2">
		        <B><%= MapTitle %></B><BR>
                <IMG SRC = <%= MapImage %> " WIDTH="200">
		        </FONT>        			
		        </TD>
		    </TR>
		</TABLE>
			
	    <!-- End Map Space -->
			
		<TABLE WIDTH="620" BORDER="0" CELLPADDING="0" CELLSPACING="0">
		    <TR>
		        <TD>
		            <FONT FACE="Arial, Helvetica" SIZE="2"><B>GENERAL INFORMATION</B><BR></FONT>
		            <FONT FACE="Arial, Helvetica" SIZE="1">NO REFUNDS - NO EXCHANGES.  DO NOT COPY THIS TICKET.  MULTIPLE COPIES INVALID.  Holder assumes all risk and danger including, without limitation, injury, death, personal loss, property damage, or other related harm.  Management reserves the right to refuse admission or eject any person who fails to comply with the terms and conditions and/or rules for the event in which this ticket is issued.</FONT>
		        </TD>
		    </TR>
		</TABLE>

		<!--  Begin Horizonal Rule -->
		
		<TABLE WIDTH="620" BORDER="0" CELLPADDING="0" CELLSPACING="0">
			<TR>
			    <TD ALIGN="center">
			    <HR>
			    </TD>
			</TR>
		</TABLE>

		<!-- End Body Space -------->
  
		<!------- Start Ad Space -------->

<%				
		'Display different advertising image based on act code						
			
			Select Case rsTix("ActCode") 
			Case 35146 'Abraham Lincoln
				AdSpaceImage = "Images/2010LincolnAd.jpg"
				AdSpaceWidth = "500"
			Case 48590 'Polar Express 
				AdSpaceImage = "Images/2010PolarExpressAd.jpg"
				AdSpaceWidth = "500"
			Case 48206 'Fall Foliage Train Excursion
				AdSpaceImage = "Images/2010FallTourAd.jpg"
				AdSpaceWidth = "500"
			Case Else 'Default Advertisting Image
				AdSpaceImage = "/Images/ETicketTixLogo.gif"	
				AdSpaceWidth = "200"
	        End Select		        
%>

			<TABLE WIDTH="620" BORDER="0" CELLPADDING="0" CELLSPACING="0">
			<TR>
			<TD ALIGN="center">
			<IMG SRC = <%= AdSpaceImage %> WIDTH= <%= AdSpaceWidth %> >
			</TD>
			</TR>
			</TABLE>

		    <!------- End Ad Space -------->
<%			
			If TixCount < TotalTix Then
			'REE 3/9/7 - Added space inbetween DIV tag to resolve IE 7 Page Break issue.
%>				
			<DIV CLASS="PageBreak">&nbsp;</DIV>" 'Page Break
<%				
			End If

			rsTix.MoveNext

		Loop
%>
		</CENTER>
		</BODY>
		</HTML>
<%
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