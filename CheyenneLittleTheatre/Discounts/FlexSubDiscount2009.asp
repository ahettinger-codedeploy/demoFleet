<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'FULL SEASON SUBSCRIPTION
'Includes 6 shows: Melodrama, Annie, Talent, Romance/Romance, Rabbit, Funny
'Adult subscription price is $93.50 + $2.50 processing fee = $96.00
'Senior subscription price is $83.30 + $2.50 processing fee = $85.80
'Student subscription price is $64.60 + $2.50 processing fee = $67.10

'FULL SEASON FAMILIY SUBSCRIPTION
'Includes same shows as Full Season
'2 Adult and 2 Student subscriptions are $301.32 + $2.50 processing fee = $303.82
'Additional Student subscriptions are $61.56 + $2.50 processing fee = $64.06
'Additional Adult subscriptions are $93.50 + 2.50 processing fee = $96.00
'Seniors subscriptions are $83.30 + $2.50 processing fee = $85.80

'TWO PLUS TWO SUBSCRIPTION
'Includes two dramas: Talent and Rabbit
'Includes two musicals: Melodrama, Annie, Romance/Romance, Funny
'Adult subscription is $72.20 + $1.75 processing fee = $73.95
'Senior subscription is $64.60 + $1.75 processing fee = $66.35
'Student subscription is $49.40 + $1.75 processing fee = $51.15

'READERS THEATER SUBSCRIPTION
'Includes 4 shows: Dead Man, Wonderful Life, New Play, High School Plays
'ONLY with purchase of Full Season or Family Pack or Two Plus Two
'Adult, Senior or Student subscription is $36.00 + no processing fee

'CHILDRENS THEATER SUBSCRIPTION
'Includes 3 Shows: Many Moons, Schoolhouse Rock, Jar
'ONLY with purchase of Full Season, Family Pack or Two Plus Two
'Adult subscription is $21.60 + no processing fee
'Senior subscription is $18.00 + no processing fee
'Student subscription is $14.40 + no processing fee
 
'Private Eyes
'with purchase of Full Season, Family Pack or Two Plus Two
'Adult price is $14.40 + no processing fee
'Senior price is $12.60 + no processing fee
'Student price is $9.00 + no processing fee


'Initialize Variables
Price = Clean(Request("Price"))
NewSurcharge = CDbl(Clean(Request("NewSurcharge")))

'Set Discount Variables
SeriesCount = 6
SeriesFee = 2.50
SeriesPercentage = 15
ActCodeList = "37284,37288,37221,37222,37287,37289"


'Count # of Acts on the order.
SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
Set rsActCount = OBJdbConnection.Execute(SQLActCount)
ActCount = rsActCount("ActCount")
rsActCount.Close
Set rsActCount = nothing


If ActCount >= SeriesCount Then 
						
						'Full Season Subscription
						'=========================
						'Get the least number of tickets for any applicable ActCode
						SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
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

						'Count # of existing seats which have discount applied for this act and seat type code
						SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
						Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
						AppliedCount = rsDiscCount("LineCount")
						rsDiscCount.Close
						Set rsDiscCount = nothing

						'If the # of discounts at this price for these events < the total possible, discount price
						If AppliedCount < NbrSubscriptions Then		    
									NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)			       
						End If	



					'Determine the service fee to be charged	
					'Count number of tickets which have been given a discount
					SQLCount = "SELECT COUNT(OrderLine.ItemNumber) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
					Set rsCount = OBJdbConnection.Execute(SQLCount)
					Count = rsCount("AppliedCount")
					rsCount.Close
					Set rsCount = nothing  

					'Assign each discounted ticket with a fraction of the per order service fee
					Remainder = Count MOD (SeriesCount * NbrSubscriptions)
					If Remainder = ((SeriesCount * NbrSubscriptions) - 1) Then 
					    Surcharge = SeriesFee - (((SeriesCount * NbrSubscriptions) - 1) * Round(SeriesFee /(SeriesCount * NbrSubscriptions), 2))
					Else
						 Surcharge = Round(SeriesFee /(SeriesCount * NbrSubscriptions), 2)
					End If  


													
End If
			
If Price > NewPrice Then
	DiscountAmount = Clean(Request("Price")) - NewPrice
	AppliedFlag = "Y"
End If

	


Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>