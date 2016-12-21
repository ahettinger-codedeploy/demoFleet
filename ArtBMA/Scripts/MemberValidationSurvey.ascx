<%@ Implements Interface="Tix.IWizardStep" %>
<%@ Control Language="VB" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<%@ Import Namespace="System.Security.Cryptography.X509Certificates" %>
<%@ Import Namespace="GlobalClass" %>
<%@ Import Namespace="Tix" %>

<script runat="server">
    'CHANGE LOG
    'TTT 6/11/15 - Created CustomUserControl
    'TTT 6/12/15 - Modified to update error message
    'JAI 11/12/15 - Changed Endpoint URL per BMA

    Dim UserName As String = "tix"
    Dim Password As String = "KUAxhgcHZJhYnOAjAM"
    Dim Endpoint As String = "https://api.artbma.org:8010/v1/resources/bma-checkMembership"
    Dim SeatTypeCodes As String = "67012, 67013, 67014, 67015"
    Dim CustomerLastName As String = ""

    Public Sub LoadStep() Implements IWizardStep.LoadStep
        Page.Form.DefaultFocus = txtMemberID.ClientID
        Dim btnNext As Button = CType(Me.Parent.FindControl("btnNext"), Button)
        If Not btnNext Is Nothing Then
            btnNext.Text = "Continue >>"
            Page.Form.DefaultButton = btnNext.UniqueID
        End If
    End Sub

    Public Function NextStep() As Boolean Implements IWizardStep.NextStep
        btnShoppingCart.Visible = False
        If CustomerLastName = "" Or txtMemberID.Text = "" OrElse Not IsNumeric(txtMemberID.Text) Then
            lblErrorMessage.Visible = True
            If CustomerLastName = "" Then
                lblErrorMessage.Text = "You must have a Last name in order to continue."
            Else
                lblErrorMessage.Text = "Please enter a numeric MemberID."
            End If
            Return False
        End If

        Dim RequestData As String = "rs:id=" & CleanNumeric(txtMemberID.Text) & "&rs:name=" & CustomerLastName
        ErrorLog("BMA Member Validation - Send Request")
        'Create the HttpWebRequest object
        Dim req As HttpWebRequest = WebRequest.Create(Endpoint & "?" & RequestData)
        req.Method = "GET"
        req.ContentType = "application/x-www-form-urlencoded"
        req.Headers.Add("Authorization", "Basic " & Convert.ToBase64String(ASCIIEncoding.ASCII.GetBytes(UserName & ":" & Password)))
        req.Timeout = 30000

        Dim ErrorMsg As String = ""
        Dim CCResponse As String = ""
        Try
            'Get the data as an HttpWebResponse object
            Dim resp As HttpWebResponse = req.GetResponse()

            'Convert the data into a string (assumes that you are requesting text)
            Dim sr As New StreamReader(resp.GetResponseStream())
            CCResponse = sr.ReadToEnd()
            sr.Close()

            ErrorLog("BMA Member Validation - Response: " & CCResponse)
            CCResponse = CCResponse.Replace("[", "").Replace("]", "")
            Dim APIResponse() As String = Split(CCResponse, "|") 'could be any delimeter by their end in the future
            Dim dictionary As New Dictionary(Of String, String)
            For i As Integer = 0 To UBound(APIResponse)
                Dim field() As String = Split(APIResponse(0).Replace("""", "").ToString(), ",")
                dictionary.Add(field(0), field(1))
            Next

            If dictionary.ContainsKey("status") Then
                Dim approve As String = Trim(dictionary.Item("status")).ToLower()
                If approve = "true" Then
                    Page.GetType().InvokeMember("UpdateTimer", Reflection.BindingFlags.InvokeMethod, Nothing, Me.Page, Nothing) 'Reset 5 minutes for order timeout
                Else
                    ErrorLog("BMA Member Validation - DECLINE - Isvalid MemberID: " & approve)
                    ErrorMsg = "The Baltimore Museum of Art Member ID you have entered does not match your customer information. Please check your membership information and try again.  If this problem persists, please call the Members Hotline, at 443-573-1800, between the hours of 9:00 a.m. and 5:00 p.m. Monday – Friday."
                    btnShoppingCart.Visible = True
                End If
            Else
                ErrorLog("BMA Member Validation - ERROR - Key field 'status' is not returned.")
                ErrorMsg = "There was a problem processing your MemberID validation.  Please try again."
            End If

        Catch wex As WebException
            ErrorLog("BMA Member Validation API Failure - " & wex.Message.ToString())
            ErrorMsg = "There was a problem submitting your MemberID.  Please try again."
        End Try

        If ErrorMsg <> "" Then
            lblErrorMessage.Visible = True
            lblErrorMessage.Text = ErrorMsg
            Return False
        End If

        Return True
    End Function

    Protected Sub Page_Init()
        Dim DBTix As New SqlConnection
        Dim DBCmd As New SqlCommand
        Dim DataReader As SqlDataReader

        DBOpen(DBTix)

        Dim SeatTypeFound As Boolean = False
        Dim SQLSeatTypes As String = "SELECT TOP(1) Customer.LastName FROM OrderLine WITH (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer WITH (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = @OrderNumber AND OrderLine.SeatTypeCode IN (SELECT IntValue FROM fnCsvToInt(@SeatTypeCodes)) AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')"
        DBCmd = New SqlCommand(SQLSeatTypes, DBTix)
        DBCmd.Parameters.AddWithValue("@OrderNumber", Session("OrderNumber"))
        DBCmd.Parameters.AddWithValue("@SeatTypeCodes", SeatTypeCodes)
        DataReader = DBCmd.ExecuteReader()
        DBCmd.Parameters.Clear()
        If DataReader.HasRows() Then
            SeatTypeFound = True
        End If
        DataReader.Close()

        Dim SQLCustomer As String = "SELECT LastName FROM Customer WITH (NOLOCK) WHERE CustomerNumber = @CustomerNumber"
        DBCmd = New SqlCommand(SQLCustomer, DBTix)
        DBCmd.Parameters.AddWithValue("@CustomerNumber", Session("CustomerNumber"))
        DataReader = DBCmd.ExecuteReader()
        DBCmd.Parameters.Clear()
        If DataReader.HasRows Then
            DataReader.Read()
            CustomerLastName = DataReader("LastName").ToString()
        End If
        DataReader.Close()

        DBCmd.Dispose()
        DBClose(DBTix)

        If Not SeatTypeFound Then
            Session("Checkout") = Session("OrderNumber")
            Page.GetType().InvokeMember("UpdateTimer", Reflection.BindingFlags.InvokeMethod, Nothing, Me.Page, Nothing)
            Response.Redirect("Pay.aspx")
        End If

    End Sub

    Protected Sub btnShoppingCart_Click(sender As Object, e As EventArgs)
        Response.Redirect("/ShoppingCart.aspx")
    End Sub
</script>

<asp:Label runat="server" ID="lblTitle" Font-Bold="true" Font-Size="Medium" Text="BMA Member Validation" /><br /><br />
<asp:Label runat="server" ID="lblMessage" Font-Size="Small" Text="Please enter your Baltimore Museum of Art Member ID for validation: " style="vertical-align:middle;" />
<asp:TextBox runat="server" ID="txtMemberID" Width="60px" /><div style="line-height:10px;">&nbsp;</div>
<asp:Label runat="server" ID="lblErrorMessage" Text="Please enter a numeric MemberID." visible="false" ForeColor="Red" />
<asp:RequiredFieldValidator runat="server" ID="rfvMemberID" ControlToValidate="txtMemberID" Display="Dynamic" Text="MemberID is required." ErrorMessage="MemberID is required." ForeColor="Red" /><div style="line-height:10px;">&nbsp;</div>
<asp:Button runat="server" ID="btnShoppingCart" Text="Back to Shopping Cart" Visible="false" CssClass="TixButtonBack" OnClick="btnShoppingCart_Click" />
