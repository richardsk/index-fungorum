<%@ Control language="c#" Codebehind="TpUddiForm.ascx.cs" AutoEventWireup="True" Inherits="TapirDotNET.Controls.TpUddiForm" %>
<!-- ============ begin UDDI FORM ============= -->
<span class="section">UDDI Registration</span>
<br>

<asp:Panel ID="uddiPanel" Runat="server" Visible=False>
	<form name="uddiForm" action="<%Response.Write(Request.Path);%>" method="post">
		<INPUT type="hidden" value="1" name="uddi">
		<BR>
		<BR>
		<TABLE cellSpacing="3" cellPadding="1" width="90%" bgColor="#ffffff">
			<TR>
				<TD align="left"><SPAN class="label">Registry name: </SPAN><INPUT type=text 
      size=10 
      value="<%Response.Write(TapirDotNET.TpUtils.GetVar("uddi_name", TapirDotNET.TpConfigManager.TP_UDDI_OPERATOR_NAME));%>" 
      name=uddi_name> &nbsp;&nbsp;
					<SPAN class="label">Tmodel name: </SPAN><INPUT 
      type=text size=10 
      value="<%Response.Write(TapirDotNET.TpUtils.GetVar("tmodel_name", TapirDotNET.TpConfigManager.TP_UDDI_TMODEL_NAME));%>" 
      name=tmodel_name>
				</TD>
			</TR>
			<TR>
				<TD align="left"><SPAN class="label">Inquiry URL: </SPAN><INPUT type=text 
      size=50 
      value="<%Response.Write(TapirDotNET.TpUtils.GetVar("inquiry_url", TapirDotNET.TpConfigManager.TP_UDDI_INQUIRY_URL));%>" 
      name=inquiry_url> &nbsp;&nbsp;
					<SPAN class="label">Port: </SPAN><INPUT 
      type=text size=4 
      value="<%Response.Write(TapirDotNET.TpUtils.GetVar("inquiry_port", TapirDotNET.TpConfigManager.TP_UDDI_INQUIRY_PORT));%>" 
      name=inquiry_port>
				</TD>
			</TR>
			<TR>
				<TD align="left"><SPAN class="label">Publish URL: </SPAN><INPUT type=text 
      size=50 
      value="<%Response.Write(TapirDotNET.TpUtils.GetVar("publish_url", TapirDotNET.TpConfigManager.TP_UDDI_PUBLISH_URL));%>" 
      name=publish_url> &nbsp;&nbsp;
					<SPAN class="label">Port: </SPAN><INPUT 
      type=text size=4 
      value="<%Response.Write(TapirDotNET.TpUtils.GetVar("publish_port", TapirDotNET.TpConfigManager.TP_UDDI_PUBLISH_PORT));%>" 
      name=publish_port>
				</TD>
			</TR>
			<TR>
				<TD align="left">
					<TABLE cellSpacing="1" cellPadding="1" width="100%" bgColor="#999999">
						<asp:PlaceHolder id="placeHolder1" Runat="server"></asp:PlaceHolder></TABLE>
				</TD>
			</TR>
		</TABLE>
		
	</form>	
</asp:Panel>
<br>
<%
		if (TapirDotNET.TpConfigManager._DEBUG)
		{
		%>
<!-- //TODO -->
<div align="left">
	<pre>
		<%
		%>
		
		</pre>
</div>
<%
		}
	%>
	
<!-- ============= end UDDI FORM ============== -->
