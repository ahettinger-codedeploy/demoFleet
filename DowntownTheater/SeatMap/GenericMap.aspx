<%@ Page Language="VB" MasterPageFile="~/TixInner.master" CodeFile="~/GenericMap.aspx.vb" Inherits="GenericMap" AutoEventWireup="false" title="Tix - Seat Map" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<%@ Register src="~/UserControls/EventDetailShort.ascx" tagname="EventPanel" tagprefix="uc1" %>
<%@ Register src="~/UserControls/EventPricing.ascx" tagname="PricePanel" tagprefix="uc3" %>

<script runat="server">
'CHANGE LOG
'JAI 11/8/12 - Removed inline style
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="TixInnerHead" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TixInnerContent" Runat="Server">

    <asp:Panel ID="EventPanel" runat="server" Width="70%">
        <uc1:EventPanel ID="EventPanel1" runat="server" />
    </asp:Panel>
    <br />
    <asp:Label ID="SeatMapText" runat="server" Text="Click on a section below to see availability." Font-Bold="true"></asp:Label><br />
    <asp:Panel ID="SeatMapPanel" runat="server"></asp:Panel><br />
    <asp:Panel ID="PricePanel" runat="server" Width="70%">
        <uc3:PricePanel ID="PricePanel1" runat="server" />
    </asp:Panel>
    
    <!--#INCLUDE VIRTUAL="~/TooltipInclude.html" -->
    
</asp:Content>

