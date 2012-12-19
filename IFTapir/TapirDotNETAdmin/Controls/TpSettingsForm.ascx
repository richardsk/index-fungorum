<%@ Control language="c#" Codebehind="TpSettingsForm.ascx.cs" AutoEventWireup="True" Inherits="TapirDotNET.Controls.TpSettingsForm" %>
<!-- beginning of SettingsForm -->
<br>
<table align="center" width="92%" cellspacing="1" cellpadding="1" bgcolor="#999999">
	<tr bgcolor="#ffffee">
		<td align="left" valign="middle" width="40%" class="label_required">
			<%Response.Write(this.GetHtmlLabel("max_repetitions", true));%>
		</td>
		<td align="left" valign="middle" width="60%">
			<input type="text" name="max_repetitions" value="<%Response.Write(r_settings.GetMaxElementRepetitions());%>" size="10">
		</td>
	</tr>
	<tr bgcolor="#ffffee">
		<td align="left" valign="middle" width="40%" class="label_required">
			<%Response.Write(this.GetHtmlLabel("max_levels", true));%>
		</td>
		<td align="left" valign="middle" width="60%">
			<input type="text" name="max_levels" value="<%Response.Write(r_settings.GetMaxElementLevels());%>" size="10">
		</td>
	</tr>
	<tr bgcolor="#ffffee">
		<td align="left" valign="middle" width="40%" class="label_required">
			<%Response.Write(this.GetHtmlLabel("log_only", true));%>
		</td>
		<td align="left" valign="middle" width="60%">
			<%Response.Write(new TapirDotNET.TpHtmlUtils().GetCombo("log_only", r_settings.GetLogOnly(), this.GetOptions("logonly"), false, 0, ""));%>
			<br>
		</td>
	</tr>
	<tr bgcolor="#ffffee">
		<td align="left" valign="middle" width="40%" class="label_required">
			<%Response.Write(this.GetHtmlLabel("case_sensitive_equals", true));%>
		</td>
		<td align="left" valign="middle" width="60%">
			<%Response.Write(new TapirDotNET.TpHtmlUtils().GetCombo("case_sensitive_equals", r_settings.GetCaseSensitiveInEquals() ? "true" : "false", this.GetOptions("boolean"), false, 0, ""));%>
			<br>
		</td>
	</tr>
	<tr bgcolor="#ffffee">
		<td align="left" valign="middle" width="40%" class="label_required">
			<%Response.Write(this.GetHtmlLabel("case_sensitive_like", true));%>
		</td>
		<td align="left" valign="middle" width="60%">
			<%Response.Write(new TapirDotNET.TpHtmlUtils().GetCombo("case_sensitive_like", r_settings.GetCaseSensitiveInLike() ? "true" : "false", this.GetOptions("boolean"), false, 0, ""));%>
			<br>
		</td>
	</tr>
	<tr bgcolor="#ffffee">
		<td align="left" valign="middle" width="40%" class="label_required">
			<%Response.Write(this.GetHtmlLabel("date_last_modified", true));%>
		</td>
		<td align="left" valign="middle" width="60%">
			<span class="label">Dynamically from field: </span>
			<br>
			<%Response.Write(new TapirDotNET.TpHtmlUtils().GetCombo("modifier", r_settings.GetModifier(), this.GetOptions("tables_and_columns"), false, 0, ""));%>
			<br>
			<br>
			<span class="label">Or from fixed value:</span>
			<br>
			<input type="text" name="modified" value="<%Response.Write(r_settings.GetModified());%>" size="30">&nbsp;
			<input type="submit" name="set_modified" value="set to now">
			<br>
		</td>
	</tr>
</table>
<p class="tip"><%Response.Write(TapirDotNET.TpConfigManager.TP_MANDATORY_FIELD_FLAG);%>Indicates 
	mandatory fields</p>
<br>
<!-- end of SettingsForm -->
