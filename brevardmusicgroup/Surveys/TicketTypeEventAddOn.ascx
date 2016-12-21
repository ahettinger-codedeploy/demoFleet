<%
    'CHANGE LOG
    'TTT 8/3/15 - created customer survey to display EventAddOn based on eligible ticket types
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
    Private EventCodes As String = ""
    Private EligibleTicketTypes As String = "1,1114"
    
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
    
    Protected Sub Page_Load()
        If EventCodes <> "" Then
            Dim ScriptFileName As String = "/UserControls/EventSchedule.ascx"
            Dim UCScript As UserControl = LoadControl(ScriptFileName)
            Dim ucType As Type = UCScript.GetType()

            Dim OrgNumProperty As Reflection.PropertyInfo = ucType.GetProperty("OrgNum")
            OrgNumProperty.SetValue(UCScript, OrderOrg(Session("OrderNumber"), True), Nothing)
            Dim EventCodeProperty As Reflection.PropertyInfo = ucType.GetProperty("EventCode")
            EventCodeProperty.SetValue(UCScript, EventCodes, Nothing)
            Dim EventAddOnProperty As Reflection.PropertyInfo = ucType.GetProperty("EventAddOn")
            EventAddOnProperty.SetValue(UCScript, "Y", Nothing)
            pnlWizardSchedule.Controls.Clear()
            pnlWizardSchedule.Controls.Add(UCScript)
        End If
        

        'REE 1/26/12 - Added Dynamic Title and Header based on Org Option.
        Dim PageTitle As String = OrgOption(OrderOrg(Session("OrderNumber"), True), "EventAddOnTitle")
        If PageTitle <> "" Then
            lblTitle.Text = PageTitle
        End If
        
        Dim PageHeader As String = OrgOption(OrderOrg(Session("OrderNumber"), True), "EventAddOnHeader")
        If PageHeader <> "" Then
            lblHeader.Text = PageHeader
        End If

        Dim PageFooter As String = OrgOption(OrderOrg(Session("OrderNumber"), True), "EventAddOnFooter")
        If PageFooter <> "" Then
            lblFooter.Text = PageFooter
        End If
    End Sub
    
    Public Sub LoadStep() Implements IWizardStep.LoadStep

    End Sub
    
    Public Function NextStep() As Boolean Implements IWizardStep.NextStep
        Dim btnNext As Button = CType(Me.Parent.FindControl("btnNext"), Button)
        If Not btnNext Is Nothing Then
            btnNext.Text = "Continue"
        End If
        
        Return True
    End Function
    
    Protected Sub Page_Init()
        'Check for Donation Records.  
        Dim DBTix As New SqlConnection
        Dim DBCmd As New SqlCommand
        Dim DataReader, DataReader2 As SqlDataReader

        DBOpen(DBTix)
        
        'check if survey's events have qualifying ticket types in shopping cart
        Dim SQLEventTicketTypes As String = "SELECT TOP(1) LineNumber FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = @OrdNum AND Event.SurveyNumber = @SurveyNumber AND OrderLine.SeatTypeCode IN (SELECT IntValue FROM fnCsvToInt(@SeatTypeCodes)) AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')"
        DBCmd = New SqlCommand(SQLEventTicketTypes, DBTix)
        DBCmd.Parameters.AddWithValue("@OrdNum", Session("OrderNumber"))
        DBCmd.Parameters.AddWithValue("@SurveyNumber", SurveyNumber)
        DBCmd.Parameters.AddWithValue("@SeatTypeCodes", EligibleTicketTypes)
        DataReader = DBCmd.ExecuteReader()
        DBCmd.Parameters.Clear()
        If DataReader.HasRows() Then
            'check for add-on events' availablity and if yet currently on order
            Dim SQLEventAddOn As String = "SELECT EventAddOn.AddOnEventCode FROM EventAddOn WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON Seat.EventCode = EventAddOn.EventCode INNER JOIN OrderLine WITH (NOLOCK) ON Seat.OrderNumber = OrderLine.OrderNumber AND Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN (SELECT EventCode, Count(*) As SeatCount FROM Seat WITH (NOLOCK) WHERE StatusCode = 'A' GROUP BY EventCode) AS EventAvailable ON EventAddOn.AddOnEventCode = EventAvailable.EventCode WHERE Seat.OrderNumber = @OrdNum AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND EventAddOn.AddOnEventCode NOT IN (SELECT DISTINCT EventCode FROM Seat WITH (NOLOCK) INNER JOIN OrderLine WITH (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber WHERE OrderLine.OrderNumber = @OrdNum AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')) GROUP BY EventAddOn.AddOnEventCode"
            DBCmd = New SqlCommand(SQLEventAddOn, DBTix)
            DBCmd.Parameters.AddWithValue("@OrdNum", Session("OrderNumber"))
            DataReader2 = DBCmd.ExecuteReader()
            DBCmd.Parameters.Clear()
            If DataReader2.HasRows() Then
                Do While DataReader2.Read()
                    EventCodes = EventCodes & DataReader2("AddOnEventCode") & ","
                Loop
                EventCodes = Left(EventCodes, Len(EventCodes) - 1)
            End If
            DataReader2.Close()
        End If
        DataReader.Close()

        DBCmd.Dispose()
        DBClose(DBTix)
        
        Dim btnNext As Button = CType(Me.Parent.FindControl("btnNext"), Button)
        If EventCodes <> "" Then
            btnNext.Text = "No Thanks"
        Else
            Page.GetType().InvokeMember("btnNext_Click", Reflection.BindingFlags.InvokeMethod, Nothing, Me.Page, Nothing)
        End If
       
    End Sub
    
    Protected Sub Page_PreRender()
        Dim gvSchedule As GridView = CType(FindControlRecursive(pnlWizardSchedule, "gvSchedule"), GridView)
        If Not gvSchedule Is Nothing Then
            For Each row As GridViewRow In gvSchedule.Rows
                Dim btnBuyTix As Button = CType(row.FindControl("btnBuyTix"), Button)
                If Not btnBuyTix Is Nothing Then
                    btnBuyTix.Text = "Add"
                End If
            Next
        End If
    End Sub
</script>

<br /><br />
<asp:Label runat="server" ID="lblTitle" Font-Bold="true" Font-Size="Small" Text="Additional Items" />
<br />
<asp:Label runat="server" ID="lblHeader" Font-Size="X-Small" Text="Click on the 'Add' button to add the following to your order." />
<br /><br />

<asp:Panel ID="pnlWizardSchedule" runat="server" />

<br />
<asp:Label runat="server" ID="lblFooter" Font-Size="X-Small" Text="" />
<br />
<br />
<asp:Label runat="server" ID="lblContinue" Font-Size="X-Small" Text="Click on the 'No Thanks' button below to checkout without adding the above items." />

<!--#INCLUDE VIRTUAL="~/TooltipInclude.html" -->