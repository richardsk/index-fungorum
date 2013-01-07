<%@ Control Language="VB" AutoEventWireup="false" CodeFile="TNUControl.ascx.vb" Inherits="Controls_TNUControl" %>
<%@ Register assembly="System.Web.Entity, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" namespace="System.Web.UI.WebControls" tagprefix="asp" %>
<style type="text/css">


.error
{
	color:Red;	
}

</style>
<p class="H1">
    Taxon Name Usage<br />
    <asp:Label ID="errLabel" runat="server" CssClass="error"></asp:Label>
    </p>
<asp:DetailsView ID="TNUDetails" CssClass="tnuDetails" runat="server" 
    AutoGenerateRows="False" DataSourceID="tnuDs" DataKeyNames="TaxonNameUsageID">
    <Fields>
        <asp:BoundField DataField="TaxonNameUsageID" HeaderText="PK" ReadOnly="True" 
            SortExpression="TaxonNameUsageID" />
        <asp:BoundField DataField="NameElement" HeaderText="NameElement" 
            SortExpression="NameElement" />
        <asp:BoundField DataField="VerbatimNameString" HeaderText="VerbatimNameString" 
            SortExpression="VerbatimNameString" />
        <asp:BoundField DataField="Page" HeaderText="Page" SortExpression="Page" />
        <asp:BoundField DataField="PageQualifier" HeaderText="PageQualifier" 
            SortExpression="PageQualifier" />
        <asp:CheckBoxField DataField="IsNothoTaxon" HeaderText="IsNothoTaxon" 
            SortExpression="IsNothoTaxon" />
        <asp:BoundField DataField="CacheNameComplete" HeaderText="CacheNameComplete" 
            SortExpression="CacheNameComplete" />
        <asp:BoundField DataField="Protonym.ProtonymID" HeaderText="ProtonymID" 
            SortExpression="Protonym.ProtonymID" />
        <asp:BoundField DataField="Reference.ReferenceID" HeaderText="Reference" 
            SortExpression="Reference.ReferenceID" />
        <asp:BoundField DataField="TaxonNameUsage2.TaxonNameUsageID" 
            HeaderText="ValidUsageID" SortExpression="TaxonNameUsage2.TaxonNameUsageID" />
        <asp:BoundField DataField="TaxonNameUsage3.TaxonNameUsageID" 
            HeaderText="ParentUsageID" SortExpression="TaxonNameUsage3.TaxonNameUsageID" />
        <asp:BoundField DataField="TaxonRank.TaxonRankID" HeaderText="TaxonRank" 
            SortExpression="TaxonRank.TaxonRankID" />
    </Fields>
</asp:DetailsView>
<asp:EntityDataSource ID="tnuDs" runat="server" 
    ConnectionString="name=GNUBEntities" DefaultContainerName="GNUBEntities" 
    EntitySetName="TaxonNameUsage" Include="">
</asp:EntityDataSource>

<asp:EntityDataSource ID="tnaDs" runat="server" 
    ConnectionString="name=GNUBEntities" DefaultContainerName="GNUBEntities" 
    EntitySetName="NomenclaturalAct" 
    Where="">
</asp:EntityDataSource>
<p>
    &nbsp;</p>
<asp:GridView ID="ActsList" runat="server" AutoGenerateColumns="False" 
    DataKeyNames="NomenclaturalActID" DataSourceID="tnaDs" 
    CssClass="tnuDetails">
    <Columns>
        <asp:BoundField DataField="NomenclaturalActID" HeaderText="PK" ReadOnly="True" 
            SortExpression="NomenclaturalActID" />
        <asp:BoundField DataField="ActText" HeaderText="ActText" 
            SortExpression="ActText" />
        <asp:BoundField DataField="ActComment" HeaderText="ActComment" 
            SortExpression="ActComment" />
        <asp:BoundField DataField="NomenclaturalAct2.NomenclaturalActID" 
            HeaderText="Related Act" 
            SortExpression="NomenclaturalAct2.NomenclaturalActID" />
        <asp:BoundField DataField="NomenclaturalActType.NomenclaturalActTypeID" 
            HeaderText="Act Type" 
            SortExpression="NomenclaturalActType.NomenclaturalActTypeID" />
        <asp:BoundField DataField="TaxonNameUsage.TaxonNameUsageID" 
            HeaderText="TaxonNameUsageID" 
            SortExpression="TaxonNameUsage.TaxonNameUsageID" Visible="False" />
    </Columns>
</asp:GridView>


