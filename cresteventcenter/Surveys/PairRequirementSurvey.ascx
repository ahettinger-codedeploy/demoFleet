<%
'CHANGE LOG
'JAI 7/1/16 - Created.  Requires purchase in pairs, but allows single seats when section (table) full.
%>

<%@ Implements Interface="Tix.IWizardStep" %>
<%@ Control Language="VB" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="GlobalClass" %>
<%@ Import Namespace="Tix" %>

<script runat="server">
    Private SurveyNumber As Integer = 0
    Private StrLastSurvey As String = ""

    Public WriteOnly Property SetSurveyNumber() As Integer
        Set(ByVal Value As Integer)
            SurveyNumber = Value
        End Set
    End Property

    Public WriteOnly Property SetLastSurvey() As String
        Set(ByVal Value As String)
            StrLastSurvey = Value
        End Set
    End Property

    Public Sub LoadStep() Implements IWizardStep.LoadStep

    End Sub

    Public Function NextStep() As Boolean Implements IWizardStep.NextStep
        Return True
    End Function

    Protected Sub Page_Init()
        Dim DBTix As New SqlConnection
        Dim DBCmd As New SqlCommand
        Dim DataReader, DataReader2 As SqlDataReader
        Dim btnNext As Button = CType(Me.Parent.FindControl("btnNext"), Button)
        Dim Message As String = ""

        DBOpen(DBTix)

        Dim SQLEventSections As String = "SELECT Act.Act, Event.EventCode, Event.EventDate, Seat.SectionCode, Section.Section, COUNT(*) AS TotalTix FROM Event WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine WITH (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section WITH (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode WHERE OrderLine.OrderNumber = @OrderNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Event.SurveyNumber = @SurveyNumber GROUP BY Act.Act, Event.EventCode, Event.EventDate, Seat.SectionCode, Section.Section"
        DBCmd = New SqlCommand(SQLEventSections, DBTix)
        DBCmd.Parameters.AddWithValue("@OrderNumber", Session("OrderNumber"))
        DBCmd.Parameters.AddWithValue("@SurveyNumber", SurveyNumber)
        DataReader = DBCmd.ExecuteReader()
        DBCmd.Parameters.Clear()
        Do While DataReader.Read()
            If CInt(DataReader("TotalTix")) Mod 2 <> 0 Then

                Dim SQLTableFull As String = "SELECT COUNT(ItemNumber) AS SeatCount FROM Seat (NOLOCK) WHERE EventCode = @EventCode AND SectionCode = @SectionCode AND StatusCode = 'A'"
                DBCmd = New SqlCommand(SQLTableFull, DBTix)
                DBCmd.Parameters.AddWithValue("@EventCode", DataReader("EventCode"))
                DBCmd.Parameters.AddWithValue("@SectionCode", DataReader("SectionCode"))
                DataReader2 = DBCmd.ExecuteReader()
                DBCmd.Parameters.Clear()
                DataReader2.Read()
                If DataReader2("SeatCount") <> 0 Then

                    If Message = "" Then
                        Message = "Please Note:  Tickets to this event must be purchased in pairs.  You have selected an odd number of tickets for the following performance(s) / section(s):<BR><BR><UL>"
                    End If
                    Message &= "<LI>" & DataReader("Act") & " - " & DataReader("Eventdate") & " / " & DataReader("Section") & "</LI>"

                End If
                DataReader2.Close()

            End If
        Loop
        DataReader.Close()
        DBCmd.Dispose()
        DBClose(DBTix)

        If Message <> "" Then
            If Not btnNext Is Nothing Then
                btnNext.Visible = False
            End If
            lblMessage.Text = Message & "</UL>"
        Else
            If Not btnNext Is Nothing Then
                Page.GetType().InvokeMember("btnNext_Click", Reflection.BindingFlags.InvokeMethod, Nothing, Me.Page, Nothing)
            End If
        End If

    End Sub

</script>

<asp:Label runat="server" ID="lblTitle" Text="Ticket Pair Requirement" Font-Size="Medium" Font-Bold="true" /><br /><br />

<asp:Label runat="server" ID="lblMessage" Font-Size="Small" /><br />

<asp:Label runat="server" ID="lblFooter" Text="In order to complete your purchase, please click on Back to Shopping or the Shopping Cart to add or remove the appropriate number of tickets for these items." Font-Size="Small" /><br /><br />
