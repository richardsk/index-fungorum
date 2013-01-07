<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ProvSearchControl.ascx.vb" Inherits="Controls_ProvSearchControl" %>
<%@ Register assembly="System.Web.Entity, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" namespace="System.Web.UI.WebControls" tagprefix="asp" %>


<div class="searchPage">

<table style="width: 100%;">
    <tr>
        <td>
            Search provider data:</td>
        <td>
            <asp:TextBox ID="searchText" runat="server" Columns="50" ></asp:TextBox>
&nbsp;<asp:Button ID="searchButton" runat="server" UseSubmitBehavior="true" CssClass="button" Text="Search" />
        </td>
    </tr>
    <tr>
        <td>
            &nbsp;</td>
        <td>
            &nbsp;</td>
    </tr>
</table>
<asp:GridView ID="ResultsView" runat="server" AllowPaging="True" 
    AllowSorting="True" AutoGenerateColumns="False" 
    PageSize="50" CssClass="tnuDetails">
    <Columns>
        <asp:BoundField DataField="Identifier1" HeaderText="External ID" />
        <asp:BoundField DataField="NameElement" HeaderText="Name Element" />
        <asp:BoundField DataField="VerbatimNameString" HeaderText="Verbatim Name" />
        <asp:BoundField DataField="TaxonNameUsageID" HeaderText="TNUID" />
        <asp:BoundField DataField="Abbreviation" HeaderText="Source" />
    </Columns>
</asp:GridView>
<asp:Label ID="errLabel" runat="server" CssClass="error"></asp:Label>

</div>
