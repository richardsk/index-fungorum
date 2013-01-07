<%@ Control Language="VB" AutoEventWireup="false" CodeFile="HeaderControl.ascx.vb" Inherits="Controls_HeaderControl" %>

<asp:Table runat="server" CssClass="content">
    <asp:TableRow>
        <asp:TableCell ID="homeCell" CssClass="menu" runat="server">
            <asp:HyperLink ID="homeLink" runat="server" 
                NavigateUrl="~/Default.aspx?tab=home" >Home</asp:HyperLink>
        </asp:TableCell>
        <asp:TableCell ID="provSearchCell" CssClass="menu" runat="server">
            <asp:HyperLink ID="provSearchLink" runat="server" 
                NavigateUrl="~/Default.aspx?tab=provSearch">Provider Search</asp:HyperLink>
        </asp:TableCell>
        <asp:TableCell id="searchCell" CssClass="menu" runat="server">
            <asp:HyperLink ID="gnubSearchLink" runat="server" 
                NavigateUrl="~/Default.aspx?tab=gnubSearch">GNUB Search</asp:HyperLink>
        </asp:TableCell>
    </asp:TableRow>
</asp:Table>
