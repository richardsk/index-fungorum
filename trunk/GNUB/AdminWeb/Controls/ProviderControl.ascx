<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ProviderControl.ascx.vb" Inherits="Controls_ProviderControl" %>

<%@ Register assembly="System.Web.Entity, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" namespace="System.Web.UI.WebControls" tagprefix="asp" %>

<link href="../gnub.css" rel="stylesheet" type="text/css" />

<div class="contentForm">

<table >
    <tr>
        <td class="contentLabel" >
            Provider Name</td>
        <td>
            <asp:TextBox ID="provNameText" runat="server" Columns="50"></asp:TextBox>
        </td>
    </tr>
    
    <tr>
        <td class="contentLabel">
            Url</td>
        <td>
            <asp:TextBox ID="urlText" runat="server" Columns="60"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td class="contentLabel">
            Contact User</td>
        <td>
            <asp:DropDownList ID="userCombo" runat="server" Height="25px" Width="223px">
            </asp:DropDownList>
        </td>
    </tr>
</table>

    <asp:HiddenField ID="hiddenProvId" runat="server" />
    <asp:Label ID="errLabel" runat="server" CssClass="error"></asp:Label>
    <br />
    <table style="width: 40%;">
        <tr>
            <td>
    <asp:Button ID="SaveButton" runat="server" CssClass="btn" Text="Save" />
            </td>
            <td>
    <asp:Button ID="CncButton" runat="server" CssClass="btn" Text="Cancel" />
            </td>
        </tr>
    </table>

</div>
<p>
    &nbsp;</p>


