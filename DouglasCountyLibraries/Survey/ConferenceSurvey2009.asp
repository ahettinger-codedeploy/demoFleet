<!--#INCLUDE virtual=/PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=/GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=/DBOpenInclude.asp -->
<%

'Douglas County Libraries - 2009 Writers Conference - UPDATE 9/11/2009
'Updated list of workshops for each of the four sessions due to changes in the programming


'Douglas County Libraries - 2009 Writers Conference - 9/08/2009
'This survey allows patron to select 4 workshop choices (from list of 12 each session) 
'This survey allows patron to select a lunch option
'This survey allows patron to select agent and apppointment time for pitch session
'Patron is required to answer name and workshop questions.

'Initialize Parameters
Page = "Survey"
SurveyNumber = 563
SurveyName = "ConferenceSurvey.asp"

'Initialize Survey Variables

'===================================
'Session One 
'===================================
		
EventA01 = "First Chapter Lighting"
PresnA01 = "Presented by: Mario Acevedo and Warren Hammond"
EventA02 = "Tickling the Muse: Exercises to Break Through Writers Block"
PresnA02 = "Presented by: Chris Mandeville"
EventA03 = "Ten Steps to Creating Memorable Characters"
PresnA03 = "Presented by: Sandra Hicks"
EventA04 = "Dismembering the Best Seller"
PresnA04 = "Presented by: Bonnie Ramthun"
EventA05 = "GET REAL:  Writing Nonfiction for Children and Adults"
PresnA05 = "Presented by: Phyllis Perry"
EventA06 = "Turning Regular Life into Extraordinary Stories"
PresnA06 = "Presented by: Robert Sanchez"
EventA07 = "Liposuction for your Overweight Manuscript"
PresnA07 = "Presented by: Linda Berry"
EventA08 = "The Art of Creating a Short Story"
PresnA08 = "Presented by: Davin Colten"
EventA09 = "No Ideas But in Things: Poetry 101"
PresnA09 = "Presented by: Kirsten Lasinski"
EventA10 = "The 5 Second Rule: Pointers for Hooking Readers and Keeping them Reading"
PresnA10 = "Presented by: Sandy Whelchel"
EventA11 = "Business Management for Writers"
PresnA11 = "Presented by: Steve Replin"
EventA12 = "Three Secrets Every Writer Should Know: Publishing Nuts & Bolts"
PresnA12 = "Presented by: Anne Fenske"

'===================================
'Session Two 
'===================================
		
EventB01 = "Stimulus Response"
PresnB01 = "Presented by: Warren Hammond and Jeanne Stein"
EventB02 = "Opening That Can of Worms: Setting Up the Story Question"
PresnB02 = "Presented by: Laurie Marr Wasmund"
EventB03 = "I've Got an Idea for a Novel, Now What?"
PresnB03 = "Presented by: Carleen Brice"
EventB04 = "Tapping into your Inner Teen aka Writing for Young Adults"
PresnB04 = "Presented by: Terri Clark"
EventB05 = "Freelancing: 7 Articles, 7 Routes to Publication, 7 Case Histories"
PresnB05 = "Presented by Page Lambert"
EventB06 = "Playing Spider: Enticing Your Web Audience"
PresnB06 = "Presented by: Ron Heimbecher"
EventB07 = "Becoming a Storyteller"
PresnB07 = "Presented by: Stephen Singular"
EventB08 = "Tools to Help You Build a Good Story"
PresnB08 = "Presented by: Linda Berry"
EventB09 = "Permission to Create: Using Poetry to Initiate Self discovery & Dialogue"
PresnB09 = "Presented by: Susan de Wardt"
EventB10 = "Mash-Up - Mixing Genres"
PresnB10 = "Presented by: David Boop"
EventB11 = "How to Build a Better Query"
PresnB11 = "Presented by: Kate Schafer Testerman"
EventB12 = "The Author As Speaker"
PresnB12 = "Presented by: Michele Cushatt"

'===================================
'Session Three Information
'===================================
		
EventC01 = "Make it Fresh"
PresnC01 = "Presented by: Mario Acevedo and Jeanne Stein"
EventC02 = "Improve with Improv"
PresnC02 = "Presented by: Chris Mandeville"
EventC03 = "Bridging the Gap"
PresnC03 = "Presented by: Carleen Brice"
EventC04 = "Creating a Sense of Place"
PresnC04 = "Presented by Page Lambert"
EventC05 = "Writing a Memoir"
PresnC05 = "Presented by: Bonnie Ramthun"
EventC06 = "Researching Little Known Facts about a Specific Time & Place"
PresnC06 = "Presented by: David Boop"
EventC07 = "The Art of Self-Edit"
PresnC07 = "Presented by: Robert Sanchez"
EventC08 = "Dialogue is Key to Any Great Story"
PresnC08 = "Presented by: Davin Colten"
EventC09 = "Polishing the Silver - Revising Poetry"
PresnC09 = "Presented by: Kirsten Lasinski"
EventC10 = "Fear of Success/Fear of Failure: The Two Sides of the Writer's Coin"
PresnC10 = "Presented by: Kirsten Lasinski"
EventC11 = "Finding the Right Literary Agent for You"
PresnC11 = "Presented by: Kirsten Lasinski"
EventC12 = "Three Secrets Every Writer Should Know: Know Your Audience"
PresnC12 = "Presented by: Anne Fenske"

'===================================
'Session Four Information
'===================================
		
EventD01 = "He said, She said: Basics for Moving Readers Through the Story with Dialogue"
PresnD01 = "Presented by: Sandy Whelchel"
EventD02 = "I'm a What?: Unleashing Dynamic Metaphors"
PresnD02 = "Presented by: Laurie Marr Wasmund"
EventD03 = "Your Writing is Rock Solid…Now What"
PresnD03 = "Presented by Kate Schafer Testerman"
EventD04 = "Werewolves, Witches & Vamps, Oh My!  Writing Paranormal Fiction"
PresnD04 = "Presented by: Terri Clark"
EventD05 = "Tips to Getting Accepted in the Magazine World"
PresnD05 = "Presented by: Kerrie Flanagan"
EventD06 = "The Art of Interviewing"
PresnD06 = "Presented by: Stephen Singular"
EventD07 = "There Will be Blood or How I Learned to Love Self-Mutilation Before My Editor Cut Me to Ribbons"
PresnD07 = "Presented by: Sandra Hicks"
EventD08 = "Writing Around the Block"
PresnD08 = "Presented by: Susan de Wardt"
EventD09 = "Haiku Moment, Haiku Mind: The Art of Mindful Observation"
PresnD09 = "Presented by: Gary Schroeder"
EventD10 = "The Top 10 Reasons to be a Writer Rather than a Supermodel and How they Apply to You"
PresnD10 = "Presented by: Jodi Anderson"
EventD11 = "Protecting Your Intellectual Property"
PresnD11 = "Presented by: Steve Replin"
EventD12 = "Leveraging the Internet to Strengthen Your Platform"
PresnD12 = "Presented by: Michele Cushatt"

'===================================
'Lunch 
'===================================

Lunch01 = "Turkey Wrap" 
Lunch02 = "Chicken and Avocado Sandwich"
Lunch03 = "Haystack Mountain Goat Cheese Salad"


'===================================
'Agent 
'===================================

Agent01 = "Sandra Bond" 
Agent02 = "April Eberhardt"


'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

'Start the Survey
If Clean(Request("FormName")) <> "SurveyForm" Then
	Call SurveyForm
Else
	Call UpdateSurveyAnswer
End If

OBJdbConnection.Close
Set OBJdbConnection = nothing

'==============================
Sub SurveyForm

%>

<!--#INCLUDE virtual="/TopNavInclude.asp"-->

<html> 
<head> 
	<title>Workshop Registration</title> 
	<link href="/Clients/DouglasCountyLibraries/NewSurvey/Images/wforms.css" rel="stylesheet" type="text/css"> 
	<link href="/Clients/DouglasCountyLibraries/NewSurvey/Images/wforms-jsonly.css" rel="alternate stylesheet" title="This stylesheet activated by javascript" type="text/css"> 
	<link href="/Clients/DouglasCountyLibraries/NewSurvey/Images/wforms-layout.css" rel="stylesheet" type="text/css"> 
	<!--[if IE 7]>
	<link href="/Clients/DouglasCountyLibraries/NewSurvey/Images/wforms-layout-ie7.css" rel="stylesheet" type="text/css">
	<![endif]--> 
	<script type="text/javascript" src="/Clients/DouglasCountyLibraries/NewSurvey/Images/wforms.js"></script> 
	<script type="text/javascript" src="/Clients/DouglasCountyLibraries/NewSurvey/Images/wforms_custom_validation.js"></script> 
	<script type="text/javascript" src="/Clients/DouglasCountyLibraries/NewSurvey/Images/localization-en_US.js"></script> 	
	<link href="/Clients/DouglasCountyLibraries/NewSurvey/Images/form.css" rel="stylesheet" type="text/css"> 
	<style type="text/css"> 
	</style> 
</head> 
<body class="default"> 

<div class="wFormContainer"> 
<IMG SRC="/Clients/DouglasCountyLibraries/Survey/Images/logo.png" WIDTH="300"><br>
<h3 class="wFormTitle"><span>2009 Douglas County Libraries<br>Writers Conference Workshops</span></h3>
<div>Register now while seats are available!</div>
<div class="wForm wFormdefaultWidth">
</center>		
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" class="labelsLeftAligned hintsSide">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">		

<%

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

SQLEvent = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue WITH (NOLOCK) ON Event.VenueCode = Venue.VenueCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.SurveyNumber = " & SurveyNumber & " GROUP BY Event.EventCode, Event.EventDate, Act.Act, Venue.Venue ORDER BY Event.EventDate, Act.Act, Venue.Venue"
Set rsEvent = OBJdbConnection.Execute(SQLEvent)

Do Until rsEvent.EOF

    SQLOrderLine = "SELECT OrderLine.LineNumber FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & rsEvent("EventCode") & " ORDER BY OrderLine.LineNumber"
    Set rsOrderLine = OBJdbConnection2.Execute(SQLOrderLine)
  
    TotalLines = 0
  
    Do Until rsOrderLine.EOF

        %>
        		
        <fieldset id="AttendeeInformat" class=""> 
        <legend>Attendee Information</legend> 

        <%

        '===================================
        'First Name 
        '===================================

        FieldName = "FirstName"
        FieldLabel = "First Name"
        			
        'Get existing OrderLineDetail values for this order if there are any.
        SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
        Set rsOrderLineDetail = OBJdbConnection3.Execute(SQLOrderLineDetail)
        			
        If Not rsOrderLineDetail.EOF Then
	        FirstName = rsOrderLineDetail("FieldValue")
        Else
	        FirstName = ""
        End If
        			
        rsOrderLineDetail.Close
        Set rsOrderLineDetail = nothing

        %>

        <div id="FirstName-D" class="oneField"> 
        <label class="preField" for="FirstName">First Name<span class="reqMark">*</span></label> 
        <input type="text" id="FirstName" name="FirstName<%=TotalLines+1%>" VALUE="<%=FirstName%>" size="40" class="required"><br>
        <span class="errMsg" id="FirstName-E"> </span> 
        </div> 

        <%

        '===================================
        'Last Name 
        '===================================

        FieldName = "LastName"
        FieldLabel = "Last Name"
        			
        'Get existing OrderLineDetail values for this order if there are any.
        SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
        Set rsOrderLineDetail = OBJdbConnection4.Execute(SQLOrderLineDetail)
        			
        If Not rsOrderLineDetail.EOF Then
	        LastName = rsOrderLineDetail("FieldValue")
        Else
	        LastName = ""
        End If
        			
        rsOrderLineDetail.Close
        Set rsOrderLineDetail = nothing

        %>

        <div id="LastName-D" class="oneField"> 
        <label class="preField" for="LastName">Last Name <span class="reqMark">*</span></label>
        <input type="text" id="LastName" name="LastName<%=TotalLines+1%>" VALUE="<%=LastName%>" size="40" class="required">
        <span class="errMsg" id="LastName-E"> </span> 
        </div> 
        </fieldset> 
        <fieldset id="Workshops" class=""> 
        <%
        '===================================
        'Workshop Selection
        '===================================
        %>
        <legend>Workshops</legend> 
        <%
        '===================================
        ' Session One 
        '===================================

        FieldName = "SessionOne"
        FieldLabel = "Session One"
        			
        'Get existing OrderLineDetail values for this order if there are any.
        SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
        Set rsOrderLineDetail = OBJdbConnection5.Execute(SQLOrderLineDetail)
        			
        If Not rsOrderLineDetail.EOF Then
	        SessionOne = rsOrderLineDetail("FieldValue")
        Else
	        SessionOne = ""
        End If
        			
        rsOrderLineDetail.Close
        Set rsOrderLineDetail = nothing
        %>
        <div id="SessionOne-D" class="oneField labelsLeftAligned"> 
        <label class="preField" for="SessionOne">Session One<BR>(9:30 – 10:20 am)<span class="reqMark">*</span></label>
        <select id="SessionOne" name="SessionOne<%=TotalLines+1%>" class="required">
        <option value="">Please select...</option> 
        <option value="<%=EventA01%>" class=""><%=EventA01%>&nbsp;&nbsp;<%=PresnA01%></option> 
        <option value="<%=EventA02%>" class=""><%=EventA02%>&nbsp;&nbsp;<%=PresnA02%></option>
        <option value="<%=EventA03%>" class=""><%=EventA03%>&nbsp;&nbsp;<%=PresnA03%></option>
        <option value="<%=EventA04%>" class=""><%=EventA04%>&nbsp;&nbsp;<%=PresnA04%></option>
        <option value="<%=EventA05%>" class=""><%=EventA05%>&nbsp;&nbsp;<%=PresnA05%></option>
        <option value="<%=EventA06%>" class=""><%=EventA06%>&nbsp;&nbsp;<%=PresnA06%></option>
        <option value="<%=EventA07%>" class=""><%=EventA07%>&nbsp;&nbsp;<%=PresnA07%></option>
        <option value="<%=EventA08%>" class=""><%=EventA08%>&nbsp;&nbsp;<%=PresnA08%></option>
        <option value="<%=EventA09%>" class=""><%=EventA09%>&nbsp;&nbsp;<%=PresnA09%></option>
        <option value="<%=EventA10%>" class=""><%=EventA10%>&nbsp;&nbsp;<%=PresnA10%></option>
        <option value="<%=EventA11%>" class=""><%=EventA11%>&nbsp;&nbsp;<%=PresnA11%></option>
        <option value="<%=EventA12%>" class=""><%=EventA12%>&nbsp;&nbsp;<%=PresnA12%></option>
        </select><br><span class="errMsg" id="WorkshopSessionO-E"> </span> 
        </div> 
        <BR>
        <%
        '===================================
        'Session Two 
        '===================================
        		
        FieldName = "SessionTwo"
        FieldLabel = "Session Two"
        			
        'Get existing OrderLineDetail values for this order if there are any.
        SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
        Set rsOrderLineDetail = OBJdbConnection6.Execute(SQLOrderLineDetail)
        			
        If Not rsOrderLineDetail.EOF Then
	        SessionTwo = rsOrderLineDetail("FieldValue")
        Else
	        SessionTwo = ""
        End If
        			
        rsOrderLineDetail.Close
        Set rsOrderLineDetail = nothing

        %>
        		
        <div id="SessionTwo-D" class="oneField labelsLeftAligned">
        <label class="preField" for="SessionTwo">Session Two<BR>(12:40-1:30 pm)<span class="reqMark">*</span></label> 
        <select id="SessionTwo" name="SessionTwo<%=TotalLines+1%>" class="required">
        <option value="">Please select...</option> 
        <option value="<%=EventB01%>" class=""><%=EventB01%>&nbsp;&nbsp;<%=PresnB01%></option> 
        <option value="<%=EventB02%>" class=""><%=EventB02%>&nbsp;&nbsp;<%=PresnB02%></option>
        <option value="<%=EventB03%>" class=""><%=EventB03%>&nbsp;&nbsp;<%=PresnB03%></option>
        <option value="<%=EventB04%>" class=""><%=EventB04%>&nbsp;&nbsp;<%=PresnB04%></option>
        <option value="<%=EventB05%>" class=""><%=EventB05%>&nbsp;&nbsp;<%=PresnB05%></option>
        <option value="<%=EventB06%>" class=""><%=EventB06%>&nbsp;&nbsp;<%=PresnB06%></option>
        <option value="<%=EventB07%>" class=""><%=EventB07%>&nbsp;&nbsp;<%=PresnB07%></option>
        <option value="<%=EventB08%>" class=""><%=EventB08%>&nbsp;&nbsp;<%=PresnB08%></option>
        <option value="<%=EventB09%>" class=""><%=EventB09%>&nbsp;&nbsp;<%=PresnB09%></option>
        <option value="<%=EventB10%>" class=""><%=EventB10%>&nbsp;&nbsp;<%=PresnB10%></option>
        <option value="<%=EventB11%>" class=""><%=EventB11%>&nbsp;&nbsp;<%=PresnB11%></option>
        <option value="<%=EventB12%>" class=""><%=EventB12%>&nbsp;&nbsp;<%=PresnB12%></option>
        </select><br><span class="errMsg" id="SessionTwo-E"> </span> 
        </div> 
        <BR>
        <%

        '===================================
        'Session Three Information
        '===================================

        FieldName = "SessionThree"
        FieldLabel = "Session Three"
        			
        'Get existing OrderLineDetail values for this order if there are any.
        SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
        Set rsOrderLineDetail = OBJdbConnection7.Execute(SQLOrderLineDetail)
        			
        If Not rsOrderLineDetail.EOF Then
	        SessionThree = rsOrderLineDetail("FieldValue")
        Else
	        SessionThree = ""
        End If
        			
        rsOrderLineDetail.Close
        Set rsOrderLineDetail = nothing

        %>

        <div id="SessionThree-D" class="oneField labelsLeftAligned">
        <label class="preField" for="SessionThree">Session Three<BR>(1:40-2:30 pm)<span class="reqMark">*</span></label>
        <BR>
        <BR>
        <select id="SessionThree" name="SessionThree<%=TotalLines+1%>" class="required">
        <option value="">Please select...</option> 
        <option value="<%=EventC01%>" class=""><%=EventC01%>&nbsp;&nbsp;<%=PresnC01%></option> 
        <option value="<%=EventC02%>" class=""><%=EventC02%>&nbsp;&nbsp;<%=PresnC02%></option>
        <option value="<%=EventC03%>" class=""><%=EventC03%>&nbsp;&nbsp;<%=PresnC03%></option>
        <option value="<%=EventC04%>" class=""><%=EventC04%>&nbsp;&nbsp;<%=PresnC04%></option>
        <option value="<%=EventC05%>" class=""><%=EventC05%>&nbsp;&nbsp;<%=PresnC05%></option>
        <option value="<%=EventC06%>" class=""><%=EventC06%>&nbsp;&nbsp;<%=PresnC06%></option>
        <option value="<%=EventC07%>" class=""><%=EventC07%>&nbsp;&nbsp;<%=PresnC07%></option>
        <option value="<%=EventC08%>" class=""><%=EventC08%>&nbsp;&nbsp;<%=PresnC08%></option>
        <option value="<%=EventC09%>" class=""><%=EventC09%>&nbsp;&nbsp;<%=PresnC09%></option>
        <option value="<%=EventC10%>" class=""><%=EventC10%>&nbsp;&nbsp;<%=PresnC10%></option>
        <option value="<%=EventC11%>" class=""><%=EventC11%>&nbsp;&nbsp;<%=PresnC11%></option>
        <option value="<%=EventC12%>" class=""><%=EventC12%>&nbsp;&nbsp;<%=PresnC12%></option>
        </select> <br><span class="errMsg" id="SessionThree-E"> </span> 
        </div> 
        <BR>
        <%

        '===================================
        'Session Four Information
        '===================================

        FieldName = "SessionFour"
        FieldLabel = "Session Four"
        			
        'Get existing OrderLineDetail values for this order if there are any.
        SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
        Set rsOrderLineDetail = OBJdbConnection8.Execute(SQLOrderLineDetail)
        			
        If Not rsOrderLineDetail.EOF Then
	        SessionFour = rsOrderLineDetail("FieldValue")
        Else
	        SessionFour = ""
        End If
        			
        rsOrderLineDetail.Close
        Set rsOrderLineDetail = nothing

        %>

        <div id="SessionFour" class="oneField labelsLeftAligned">
        <label class="preField" for="SessionFour">Session Four<BR>(2:40-3:30 pm)<span class="reqMark">*</span></label> 
        <select id="SessionFour" name="SessionFour<%=TotalLines+1%>" class="required">
        <option value="">Please select...</option> 
        <option value="<%=EventD01%>" class=""><%=EventD01%>&nbsp;&nbsp;<%=PresnD01%></option> 
        <option value="<%=EventD02%>" class=""><%=EventD02%>&nbsp;&nbsp;<%=PresnD02%></option>
        <option value="<%=EventD03%>" class=""><%=EventD03%>&nbsp;&nbsp;<%=PresnD03%></option>
        <option value="<%=EventD04%>" class=""><%=EventD04%>&nbsp;&nbsp;<%=PresnD04%></option>
        <option value="<%=EventD05%>" class=""><%=EventD05%>&nbsp;&nbsp;<%=PresnD05%></option>
        <option value="<%=EventD06%>" class=""><%=EventD06%>&nbsp;&nbsp;<%=PresnD06%></option>
        <option value="<%=EventD07%>" class=""><%=EventD07%>&nbsp;&nbsp;<%=PresnD07%></option>
        <option value="<%=EventD08%>" class=""><%=EventD08%>&nbsp;&nbsp;<%=PresnD08%></option>
        <option value="<%=EventD09%>" class=""><%=EventD09%>&nbsp;&nbsp;<%=PresnD09%></option>
        <option value="<%=EventD10%>" class=""><%=EventD10%>&nbsp;&nbsp;<%=PresnD10%></option>
        <option value="<%=EventD11%>" class=""><%=EventD11%>&nbsp;&nbsp;<%=PresnD11%></option>
        <option value="<%=EventD12%>" class=""><%=EventD12%>&nbsp;&nbsp;<%=PresnD12%></option>
        </select> <br><span class="errMsg" id="SessionFour-E"> </span> 
        </div> 
        </fieldset> 
        <BR>
        <%

        '===================================
        'Lunch 
        '===================================

        FieldName = "Lunch"
        FieldLabel = "Lunch"
        			
        'Get existing OrderLineDetail values for this order if there are any.
        SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
        Set rsOrderLineDetail = OBJdbConnection9.Execute(SQLOrderLineDetail)
        			
        If Not rsOrderLineDetail.EOF Then
	        Lunch = rsOrderLineDetail("FieldValue")
        Else
	        Lunch = ""
        End If
        			
        rsOrderLineDetail.Close
        Set rsOrderLineDetail = nothing

        %>

        <fieldset id="Lunch" class=""> 
        <legend>Lunch</legend> 
        At noon, we will break for a one hour lunch.<BR>
        <div id="Lunch-D" class="oneField labelsLeftAligned"> 

        <label class="preField" for="Lunch">Please select a meal preference.</label> 
        <BR>
        <select id="Lunch" name="Lunch<%=TotalLines+1%>" class="">
        <option value="">Please select...</option> 
        <option value="<%=Lunch01%>" class=""><%=Lunch01%></option> 
        <option value="<%=Lunch02%>" class=""><%=Lunch02%></option> 
        <option value="<%=Lunch03%>" class=""><%=Lunch03%></option>
        </select> <br><span class="errMsg" id="Lunch-E"> </span> 
        </div> 
        </fieldset>

        <%

        '===================================
        'Pitch Session 
        '===================================

        FieldName = "PitchSession"
        FieldLabel = "Pitch Session"

        		
        SQLTicketCode = "SELECT SeatTypeCode FROM OrderLine WITH (NOLOCK) WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber")
        Set rsTicketCode = OBJdbConnection10.Execute(SQLTicketCode)		

        If rsTicketCode("SeatTypeCode") = 3562 Then
	        PitchSession = "Yes"
        Else
	        PitchSession = "No"
        End If
        		
        rsTicketCode.Close
        Set rsTicketCode = nothing

        %>

        <input type="hidden" id="PitchSession" name="PitchSession<%=TotalLines+1%>" VALUE="<%=PitchSession%>">

        <%


        If PitchSession = "Yes" Then

        '===================================
        'Agent 
        '===================================

        Agent01 = "Sandra Bond" 
        Agent02 = "April Eberhardt"

        FieldName = "PitchAgent"
        FieldLabel = "Pitch Agent"
        						
        'Get existing OrderLineDetail values for this order if there are any.
        SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
        Set rsOrderLineDetail = OBJdbConnection11.Execute(SQLOrderLineDetail)
        						
        If Not rsOrderLineDetail.EOF Then
	        PitchAgent = rsOrderLineDetail("FieldValue")
        Else
	        PitchAgent = ""
        End If
        						
        rsOrderLineDetail.Close
        Set rsOrderLineDetail = nothing	

        %>

        <fieldset id="PitchSession" class="">
        <legend>Pitch Session</legend>


        <div id="PitchAgent-D" class="oneField labelsLeftAligned">
        <div style="float: left;">
        <label class="preField" for="PitchAgent">Pitch Agent</label> 

        <select id="PitchAgent" name="PitchAgent<%=TotalLines+1%>" class="">
        <option value="">Please select...</option>
        <option value="<%=Agent01%>" class=""><%=Agent01%></option> 
        <option value="<%=Agent02%>" class=""><%=Agent02%></option> 
        </select> <br><span class="errMsg" id="PitchAgent-E"> </span>

        </div>
        </div>
        <%

        '===================================
        'Pitch Time
        '===================================

        FieldName = "PitchSessionTime"
        FieldLabel = "Pitch Session Time"
        						
        'Get existing OrderLineDetail values for this order if there are any.
        SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
        Set rsOrderLineDetail = OBJdbConnection12.Execute(SQLOrderLineDetail)
        						
        If Not rsOrderLineDetail.EOF Then
	        PitchSessionTime = rsOrderLineDetail("FieldValue")
        Else
	        PitchSessionTime = ""
        End If
        						
        rsOrderLineDetail.Close
        Set rsOrderLineDetail = nothing							

        			
        %>
        <div style="float: left;">
        <div id="PitchSessionTime-D" class="oneField labelsLeftAligned">
        <label class="preField" for="PitchSessionTime">Pitch Session Time</label> 

        <select id="PitchSessionTime" name="PitchSessionTime<%=TotalLines+1%>" class=""><BR>
        <option value="">Please select...</option>
        <option value="9:30AM" class="">9:30am</option>
        <option value="9:40AM" class="">9:40am</option>
        <option value="9:50AM" class="">9:50am</option>
        <option value="10:00AM" class="">10:00am</option>
        <option value="10:10AM" class="">10:10am</option>
        <option value="12:40PM" class="">12:40pm</option>
        <option value="12:50PM" class="">12:50pm</option>
        <option value="1:00PM" class="">1:00pm</option>
        <option value="1:10PM" class="">1:10pm</option>
        <option value="1:20PM" class="">1:20pm</option>
        <option value="1:40PM" class="">1:40pm</option>
        <option value="1:50PM" class="">1:50pm</option>
        <option value="2:00PM" class="">2:00pm</option>
        <option value="2:10PM" class="">2:10pm</option>
        <option value="2:20PM" class="">2:20pm</option>
        <option value="2:40PM" class="">2:40pm</option>
        <option value="2:50PM" class="">2:50pm</option>
        <option value="3:00PM" class="">3:00pm</option>
        <option value="3:10PM" class="">3:10pm</option>
        <option value="3:20PM" class="">3:20pm</option>
        </select> <br><span class="errMsg" id="PitchSessionTime-E"> </span>
        </div>
        </div>
        </fieldset>
        <br><br>
        <%

        End If	

        TotalLines = TotalLines + 1
        rsOrderLine.MoveNext
        			
    Loop
    	
    rsOrderLine.Close
    Set rsOrderLine = nothing
    rsEvent.MoveNext
	
Loop

rsEvent.Close
Set rsEvent = nothing

%>
<center>
<div class="actions"> 
<input type="submit" class="primaryAction" id="submit-" name="submitAction" value="submit">
<input type="hidden" name="TotalLines" value="<%=TotalLines+1%>">
</div> 
</form>
</div> 
</div> 
</body> 
</html> 


<!--#INCLUDE virtual="/FooterInclude.asp"-->

<%

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

End Sub ' SurveyForm

'==============================

Sub UpdateSurveyAnswer

If Session("OrderNumber") <> "" Then

    SQLOrderLine = "SELECT TOP " & Request("TotalLines") & " OrderNumber, LineNumber FROM OrderLine WHERE OrderNumber = " & Session("OrderNumber")
    Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
    						
    i = 0
    Do Until rsOrderLine.EOF

        i = i + 1
        LineNumber = rsOrderLine("LineNumber")
        
		'Delete existing  records for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)

		'Insert First Name record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'FirstName', '" & Clean(Request("FirstName" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)

		'Insert Last Name record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'LastName', '" & Clean(Request("LastName" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
		'Insert Lunch record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'Lunch', '" & Clean(Request("Lunch" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
		'Insert Session One record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'SessionOne', '" & Clean(Request("SessionOne" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
		'Insert Session Two record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'SessionTwo', '" & Clean(Request("SessionTwo" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)

		'Insert Session Three record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'SessionThree', '" & Clean(Request("SessionThree" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
		'Insert Session Four record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'SessionFour', '" & Clean(Request("SessionFour" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
		'Insert Pitch Session record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'PitchSession', '" & Clean(Request("PitchSession" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
		'Insert Pitch Session Time record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'PitchSessionTime', '" & Clean(Request("PitchSessionTime" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)	
		
		'Insert Pitch Agent record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'PitchAgent', '" & Clean(Request("PitchAgent" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)


    	rsOrderLine.MoveNext	
	Loop
		
    rsOrderLine.Close
    Set rsOrderLine = nothing	
    
	If Session("UserNumber") = "" Then
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Ship.asp")
	Else
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Management/AdvanceShip.asp")
	End If
		
Else 'No Session Order Number
	
	If Session("UserNumber") = "" Then
		Session.Contents.Remove("OrderNumber") 
		OBJdbConnection.Close
		Set OBJdbConnection = nothing
		Response.Redirect("/Default.asp")
	Else
		Session.Contents.Remove("OrderNumber") 
		OBJdbConnection.Close
		Set OBJdbConnection = nothing
		Response.Redirect("http://" & Request.ServerVariables("SERVER_NAME") & "/Management/ClearOrderNumber.asp")
	End If

End If


End Sub 'Update SurveyAnswer

'==============================

%>
