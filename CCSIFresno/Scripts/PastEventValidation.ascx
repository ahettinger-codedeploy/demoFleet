<%@ Implements Interface="Tix.IWizardStep" %>
<%@ Control Language="VB" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="GlobalClass" %>
<%@ Import Namespace="Tix" %>

<script runat="server">
    'CHANGE LOG
	'SLM 9/13/2013 - Nwe custom checkout control
    
    Public Sub LoadStep() Implements IWizardStep.LoadStep
        Dim DBTix As New SqlConnection
        Dim DBCmd As New SqlCommand
        Dim DataReader, DataReader2 As SqlDataReader
        Dim RequiredEvent As Integer = 412541
        Dim CheckEvents As String = "601355"
        
        DBOpen(DBTix)
        
        'check if any events needed to be checked is on order
        Dim SQLCheckEvents = "SELECT Seat.EventCode FROM Seat WITH (NOLOCK) INNER JOIN OrderLine WITH (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber WHERE OrderLine.OrderNumber = @OrderNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Seat.EventCode IN (" & CheckEvents & ")"
        DBCmd = New SqlCommand(SQLCheckEvents, DBTix)
        DBCmd.Parameters.AddWithValue("@OrderNumber", Session("OrderNumber"))
        DataReader = DBCmd.ExecuteReader()
        DBCmd.Parameters.Clear()
        If DataReader.HasRows() Then
            'check if required event has been purchased from past or currently on order
            Dim SQLRequiredTickets As String = "SELECT TOP 1 OrderHeader.CustomerNumber FROM OrderLine WITH (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE Seat.EventCode = @RequiredEvent AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND ((OrderHeader.OrderNumber <> @OrderNumber AND OrderLine.StatusCode = 'S' AND OrderHeader.CustomerNumber = @CustomerNumber) OR OrderHeader.OrderNumber = @OrderNumber)"
            DBCmd = New SqlCommand(SQLRequiredTickets, DBTix)
            DBCmd.Parameters.AddWithValue("@OrderNumber", Session("OrderNumber"))
            DBCmd.Parameters.AddWithValue("@CustomerNumber", Session("CustomerNumber"))
            DBCmd.Parameters.AddWithValue("@RequiredEvent", RequiredEvent)
            DataReader2 = DBCmd.ExecuteReader()
            DBCmd.Parameters.Clear()
            If DataReader2.HasRows() = False Then
                Dim btnNext As Button = CType(Me.Parent.FindControl("btnNext"), Button)
                If Not btnNext Is Nothing Then
                    btnNext.Visible = False
                End If
                
                pnlWarning.Visible = True
            Else
                Session("Checkout") = Session("OrderNumber")
                Page.GetType().InvokeMember("UpdateTimer", Reflection.BindingFlags.InvokeMethod, Nothing, Me.Page, Nothing)
                Response.Redirect("Pay.aspx")
            End If
            DataReader2.Close()
        Else
            Session("Checkout") = Session("OrderNumber")
            Page.GetType().InvokeMember("UpdateTimer", Reflection.BindingFlags.InvokeMethod, Nothing, Me.Page, Nothing)
            Response.Redirect("Pay.aspx")
        End If
        DataReader.Close()
        
        DBCmd.Dispose()
        DBClose(DBTix)
    End Sub
    
    Public Function NextStep() As Boolean Implements IWizardStep.NextStep
        Return True
    End Function
    
    Private Sub BackShopping()
        Response.Redirect(PL("HomePage"))
    End Sub
</script>

<br />
<asp:Panel ID="pnlWarning" runat="server" Visible="false">
    <asp:Label ID="lblWarning" runat="server" Text="You cannot purchase Diwali tickets without purchasing a CCSI Annual Membership. Please click on the 'Back To Shopping' button to purchase the required membership." Font-Bold="true" Font-Size="Small" /><br /><br />
    <asp:Button ID="btnBackShopping" runat="server" Text="Back To Shopping" OnClick="BackShopping" />
</asp:Panel>

