<%@ Control language="c#" Codebehind="TpMetadataForm.ascx.cs" AutoEventWireup="True" Inherits="TapirDotNET.Controls.TpMetadataForm" %>
<!-- beginning of MetadataForm --><asp:panel id="Panel1" HorizontalAlign="Left" CssClass="box1" Runat="server"><%Response.Write(GetHtmlLabel("id", true));%>
	<asp:TextBox id="mid" Runat="server" Columns="30" AutoPostBack="True" ontextchanged="mid_TextChanged"></asp:TextBox>
	<BR>
	<BR>
	<%Response.Write(GetHtmlLabel("accesspoint", true));%>
	<asp:TextBox id="accesspoint" Runat="server" Columns="70"></asp:TextBox>
	<BR> <!-- default language --><BR>
	<%Response.Write(GetHtmlLabel("default_language", false));%>
	<%Response.Write(new TapirDotNET.TpHtmlUtils().GetCombo("default_language", r_metadata.GetDefaultLanguage(), this.GetOptions("lang"), false, 0, ""));%>
	<BR> <!-- titles -->
	<asp:Panel id="titlesPanel" Runat="server" CssClass="box2" HorizontalAlign="left"></asp:Panel> <!-- descriptions -->
	<asp:Panel id="descPanel" Runat="server" CssClass="box2" HorizontalAlign="left"></asp:Panel> <!-- subjects -->
	<asp:Panel id="subjPanel" Runat="server" CssClass="box2" HorizontalAlign="left"></asp:Panel> <!-- bibliographic citations -->
	<asp:Panel id="bibPanel" Runat="server" CssClass="box2" HorizontalAlign="left"></asp:Panel> <!-- rights -->
	<asp:Panel id="rightsPanel" Runat="server" CssClass="box2" HorizontalAlign="left"></asp:Panel> <!-- underlying database (language and date last modified) -->
	<asp:Panel id="dbLangPanel" Runat="server" CssClass="box2" HorizontalAlign="left"></asp:Panel> <!-- indexing preferences -->
	<asp:Panel id="prefsPanel" Runat="server" CssClass="box2" HorizontalAlign="left"></asp:Panel> <!-- related entities -->
	<asp:Panel id="relEntPanel" Runat="server" CssClass="box2" HorizontalAlign="left"></asp:Panel>
</asp:panel>
<p class="tip"><%Response.Write(TapirDotNET.TpConfigManager.TP_MANDATORY_FIELD_FLAG);%>Indicates 
	mandatory fields</p> <!-- end of MetadataForm -->
