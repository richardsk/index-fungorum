<%@ Control Language="VB" AutoEventWireup="false" CodeFile="HomeControl.ascx.vb" Inherits="Controls_HomeControl" %>

<style type="text/css">



.error
{
	color:Red;	
}

</style>

<asp:Table ID="provTable" runat="server" cssclass="provTable" >
    <asp:TableRow runat="server">  
        <asp:TableCell runat="server" cssclass="provTableHeader"></asp:TableCell>
        <asp:TableCell runat="server" cssclass="provTableHeader">Provider</asp:TableCell>
        <asp:TableCell runat="server" cssclass="provTableHeader">Last successful update</asp:TableCell>
        <asp:TableCell runat="server" cssclass="provTableHeader">Number of new/modified records</asp:TableCell>
        <asp:TableCell runat="server" cssclass="provTableHeader"></asp:TableCell>
    </asp:TableRow>
</asp:Table>

<p>
    <asp:Label ID="errLabel" runat="server" CssClass="error"></asp:Label>
    </p>


