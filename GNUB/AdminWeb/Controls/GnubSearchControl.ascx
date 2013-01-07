<%@ Control Language="VB" AutoEventWireup="false" CodeFile="GnubSearchControl.ascx.vb" Inherits="Controls_GnubSearchControl" %>
<%@ Register assembly="System.Web.Entity, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" namespace="System.Web.UI.WebControls" tagprefix="asp" %>

<script language="javascript" type="text/javascript">
    function onEnter(e) {

        if (e.keyCode == 13) {
            
            //document.forms(0).submit();
            //document.getElementById('ctl00_tblMain_ctl00_searchButton').submit();
            //__doPostBack(document.getElementById('ctl00_tblMain_ctl00_searchButton'), 'Search');
            //document.getElementById('ctl00_tblMain_ctl00_searchButton').click();
            document.aspnetForm.ctl00_tblMain_ctl00_searchButton.click();
        }
    }
</script>

<div class="searchPage">

<table style="width: 100%;">
    <tr>
        <td>
            Search for taxon name usage:</td>
        <td>
            <asp:TextBox ID="searchText" runat="server" Columns="50" onkeypress="javascript: onEnter(event);" ></asp:TextBox>
&nbsp;<asp:Button ID="searchButton" runat="server" CssClass="button" Text="Search" />
        </td>
    </tr>
    <tr>
        <td>
            &nbsp;</td>
        <td>
            &nbsp;</td>
    </tr>
</table>
<asp:EntityDataSource ID="TNUs" runat="server" 
    ConnectionString="name=GNUBEntities" DefaultContainerName="GNUBEntities" 
    EntitySetName="TaxonNameUsage" Include="" 
    OrderBy="it.[VerbatimNameString]" 
    Select="it.[TaxonNameUsageID], it.[NameElement], it.[VerbatimNameString], it.[Page], it.[PageQualifier]" 
    Where="1=0">
</asp:EntityDataSource>
<asp:GridView ID="ResultsView" runat="server" AllowPaging="True" 
    AllowSorting="True" AutoGenerateColumns="False" DataSourceID="TNUs" 
    PageSize="50">
    <Columns>
        <asp:BoundField DataField="TaxonNameUsageID" HeaderText="TaxonNameUsageID" 
            ReadOnly="True" SortExpression="TaxonNameUsageID" />
        <asp:BoundField DataField="NameElement" HeaderText="NameElement" 
            ReadOnly="True" SortExpression="NameElement" />
        <asp:BoundField DataField="VerbatimNameString" HeaderText="VerbatimNameString" 
            ReadOnly="True" SortExpression="VerbatimNameString" />
        <asp:BoundField DataField="Page" HeaderText="Page" ReadOnly="True" 
            SortExpression="Page" />
        <asp:BoundField DataField="PageQualifier" HeaderText="PageQualifier" 
            ReadOnly="True" SortExpression="PageQualifier" />
        <asp:TemplateField HeaderText="External ID"></asp:TemplateField>
        <asp:TemplateField HeaderText="Source"></asp:TemplateField>
    </Columns>
</asp:GridView>
<asp:Label ID="errLabel" runat="server" CssClass="error"></asp:Label>

</div>
