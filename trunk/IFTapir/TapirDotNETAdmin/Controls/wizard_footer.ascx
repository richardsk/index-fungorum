<%@ Control Language="c#" AutoEventWireup="True" Codebehind="wizard_footer.ascx.cs" Inherits="TapirDotNET.Controls.wizard_footer" TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<!-- ============ begin WIZARD FOOTER ============= -->
<asp:Panel Runat="server" ID="abortPanel" Visible="False"><INPUT onclick="return confirmRemoval()" type="submit" value="abort" name="abort">
		      &nbsp;&nbsp;&nbsp;&nbsp;
		</asp:Panel><br>
<asp:Panel Runat="server" ID="nextPanel" Visible="False">
	<INPUT type="submit" value="next step >>" name="next">
</asp:Panel><br>
<asp:Panel Runat="server" ID="savePanel" Visible="False">
	<INPUT type="submit" value="save new resource" name="save">
</asp:Panel><br>
<asp:Panel Runat="server" ID="updatePanel" Visible="False">
	<INPUT type="submit" value="save changes" name="update">
</asp:Panel>
<br>
</FORM> 
<!-- ============= end WIZARD FOOTER ============== -->
