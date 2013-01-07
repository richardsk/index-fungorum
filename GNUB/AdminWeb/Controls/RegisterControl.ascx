<%@ Control Language="VB" AutoEventWireup="false" CodeFile="RegisterControl.ascx.vb" Inherits="Controls_RegisterControl" %>
<style type="text/css">
    .style1
    {
        width: 100%;
    }
</style>
<table class="style1" width="50%">
    <tr>
        <td width="20%">
            Username</td>
        <td>
    <asp:TextBox ID="userText" runat="server" Columns="50" MaxLength="50"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td>
            Email</td>
        <td>
    <asp:TextBox ID="emailText" runat="server" Columns="50" MaxLength="500"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td>
    <asp:Button ID="registerButton" runat="server" Text="Register" />
&nbsp;
        </td>
        <td>
            &nbsp;</td>
    </tr>
    <tr>
        <td>
    <asp:Label ID="errLabel" runat="server" CssClass="error"></asp:Label>
        </td>
        <td>
            &nbsp;</td>
    </tr>
</table>
