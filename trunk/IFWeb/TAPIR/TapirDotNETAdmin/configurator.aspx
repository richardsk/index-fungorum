<%@ Page EnableEventValidation="false" validateRequest=false language="c#" Codebehind="configurator.aspx.cs" AutoEventWireup="True" Inherits="TapirDotNET.admin.configurator" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 //EN">
<HTML>
	<HEAD>
		<title>TapirDotNET Configurator</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="StyleSheet" href="layout.css" type="text/css">
			<!-- common functions -->
			<script language="JavaScript" src="utils.js" type="text/javascript"></script>
	</HEAD>
	<body bgcolor="#ffffff"> <!--onLoad="loadScroll()"-->
		<table width="100%" border="0" align="center" cellspacing="2" cellpadding="4">
			<tr>
				<td width="15%" align="left" valign="top">
					<!-- =============== begin SIDE MENU ============== -->
					<asp:Panel id="MenuPanel" runat="server"></asp:Panel>
					<!-- ================ end SIDE MENU ================ -->
				</td>
				<td width="85%" align="center" valign="top">
					<form runat="server" ID="Form1">
						<asp:Panel id="MainPanel" runat="server"></asp:Panel>
						<!-- =============== begin MAIN FRAME ============== -->
						<!-- ================ end MAIN FRAME =============== -->
					</form>
				</td>
			</tr>
		</table>
		<asp:Panel id="DebugPanel" runat="server"></asp:Panel>
	</body>
</HTML>
