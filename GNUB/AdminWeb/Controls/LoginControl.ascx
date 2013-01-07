<%@ Control Language="VB" AutoEventWireup="false" CodeFile="LoginControl.ascx.vb" Inherits="Controls_LoginControl" %>
        
    <br />
    Username:
    <asp:TextBox ID="userText" runat="server"></asp:TextBox>
    <br />
    Password:
    <asp:TextBox ID="pwdText" runat="server" TextMode="Password"></asp:TextBox>

<p>
    <asp:Button ID="loginButton" runat="server" Text="Login" />
&nbsp;
    <asp:Label ID="errLabel" runat="server" CssClass="error"></asp:Label>
</p>
<p>
    &nbsp;</p>

