<%@ Control language="c#" Codebehind="TpMappingForm.ascx.cs" AutoEventWireup="True" Inherits="TapirDotNET.Controls.TpMappingForm" %>
<!-- beginning of MappingForm -->
<br>
<table align="center" width="95%" cellspacing="1" cellpadding="1" bgcolor="#ffffff">
	<%
		if (Utility.OrderedMap.CountElements(unmapped_schemas) > 0)
		{
		%>
	<tr bgcolor="#ffffff">
		<td width="30%" align="left" nowrap><span class="label">Available schemas to map: </span></td>
		<td width="70%" align="left" nowrap>
			<asp:PlaceHolder Runat="server" ID="availableSchemas"></asp:PlaceHolder>
		</td>
	</tr>
	<%
		}
	%>
	<tr bgcolor="#ffffff">
		<td width="30%" align="left" nowrap><span class="label">Location of additional schema: </span></td>
		<td width="70%" align="left" nowrap><input type="text" name="load_from_location" value="<%TapirDotNET.TpUtils.GetVar("location", "");%>" size="45"></td>
	</tr>
</table>
<br>
<input type="submit" name="load_schemas" value="load the specified schemas above"><br>
<asp:Panel Runat="server" ID="fieldsPanel">
</asp:Panel>
<br>
<!-- end of MappingForm -->
