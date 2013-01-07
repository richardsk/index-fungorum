<%@ Control Language="VB" AutoEventWireup="false" CodeFile="UpdateControl.ascx.vb" Inherits="Controls_UpdateControl" %>

<%@ Register assembly="System.Web.Entity, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" namespace="System.Web.UI.WebControls" tagprefix="asp" %>

<style type="text/css">


.error
{
	color:Red;	
}

</style>

<div class="contentForm">

    <asp:Table ID="updateTable" runat="server" >
        <asp:TableRow runat="server">
            <asp:TableCell CssClass="contentLabel" runat="server">Provider</asp:TableCell>
            <asp:TableCell ID="provNameCell" runat="server"></asp:TableCell>
        </asp:TableRow>
        <asp:TableRow runat="server">
            <asp:TableCell CssClass="contentLabel" runat="server">Number of changed records</asp:TableCell>
            <asp:TableCell ID="changedRecCell" runat="server"></asp:TableCell>
        </asp:TableRow>
        <asp:TableRow runat="server">
            <asp:TableCell  CssClass="contentLabel" runat="server">Last Status</asp:TableCell>
            <asp:TableCell ID="statusCell" runat="server"></asp:TableCell>
        </asp:TableRow>
    </asp:Table>
    
    <asp:Button ID="refreshBtn" runat="server" CssClass="button" Text="Refresh" />
    <br />
    
    <asp:Label ID="errLabel" runat="server" CssClass="error"></asp:Label>
    <br />
    <asp:Button ID="goButton" runat="server" CssClass="button" Text="Update now" />
    &nbsp;&nbsp;
    <br />
    <br />
    Last 20 Updates:<asp:GridView ID="gvUpdateLog" runat="server" 
        AutoGenerateColumns="False" DataKeyNames="UpdateLogId" 
        DataSourceID="updatesDS" CssClass="updateTable" PageSize="20">
        <Columns>
            <asp:BoundField DataField="UpdateLogId" HeaderText="UpdateLogId" 
                ReadOnly="True" SortExpression="UpdateLogId" Visible="False" />
            <asp:BoundField DataField="StartDate" HeaderText="StartDate" 
                SortExpression="StartDate" />
            <asp:BoundField DataField="CompleteDate" HeaderText="CompleteDate" 
                SortExpression="CompleteDate" />
            <asp:BoundField DataField="Status" HeaderText="Status" 
                SortExpression="Status" />
            <asp:BoundField DataField="Provider.ProviderID" HeaderText="Provider" 
                SortExpression="Provider.ProviderID" />
        </Columns>
    </asp:GridView>
    <br />
    
</div>
<asp:EntityDataSource ID="updatesDS" runat="server" 
    ConnectionString="name=GNUBAdminEntities" 
    DefaultContainerName="GNUBAdminEntities" EntitySetName="UpdateLog" 
    Where="it.Provider.[ProviderId] = @provId" EntityTypeFilter="" Select="" 
    OrderBy="it.[StartDate]">
    <WhereParameters>
        <asp:QueryStringParameter Name="provId" QueryStringField="provId" DbType="Guid" />
    </WhereParameters>
</asp:EntityDataSource>
