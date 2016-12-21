<%
<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
%>

<table border="1" cellspacing="0" cellpadding="5" width="600">
    <tr>
        <th>EventCode (filename)</th>
        <th>ActCode (filename 0)</th>
        <th>Act (filename 1)</th>
        <th>EventDate (filename 2)</th>
    </tr>
    <%
	GetEvents(2266)
	%>
        <tr>
            <td><%= Filename %></td>
            <td><%= Files(Filename)(0) %></td>
            <td><%= Files(Filename)(1) %></td>
            <td><%= Files(Filename)(2) %></td>
        </tr>
        <%
    %>
</table>


<%

function GetEvents(OrganizationNumber)

dim EventList
set EventList = Server.CreateObject("SCRIPTING.DICTIONARY")


SQLEvents = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue, Map From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode WHERE Event.EventDate >= " & FormatDateTime(Now(), vbShortDate) & "  AND OrganizationAct.OrganizationNumber = " & OrganizationNumber & " AND OrganizationVenue.OrganizationNumber = " & OrganizationNumber & " AND Event.OnSale = 1 AND Event.SaleStartDate <= " & Now() &  " ORDER BY Event.EventDate, Act.Act"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

Do While Not rsEvents.EOF

EventCode = rsEvents("EventCode")
ActCode = rsEvents("ActCode")
Act = rsEvents("Act")
EventDate = rsEvents("EventDate")

Eventlist.Add EventCode, Array(ActCode, Act, EventDate)

rsEvents.MoveNext
Loop 

rsEvents.Close
Set rsEvents = Nothing

set GetEvents = Eventlist
    
End Function
 
%>