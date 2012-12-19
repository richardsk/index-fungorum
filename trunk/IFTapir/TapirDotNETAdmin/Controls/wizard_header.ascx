<%@ Control Language="c#" AutoEventWireup="True" Codebehind="wizard_header.ascx.cs" Inherits="TapirDotNET.Controls.wizard_header" TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>		

	
	      <!-- ============= begin WIZARD HEADER ============= -->
	
	      <!-- ================ begin TOP MENU =============== -->
	    <asp:Label ID="resName" CssClass="section" Runat="server"></asp:Label>
	      
	    <br/>
	    <br/>
	    <asp:Table Runat="server" ID="headerTable" HorizontalAlign="center" CellSpacing="1" CellPadding="1" BackColor="#999999">
	        	        	    
		</asp:Table>
	
	      <!-- ================= end TOP MENU ================ -->
	
		<asp:Label ID="errorLabel" Runat="server"></asp:Label>
	
	      <form name="wizard" action="<%Response.Write(Request.Path);%>" method="post" >
	      <input type="hidden" name="resource" value="<%Response.Write(TapirDotNET.TpUtils.GetVar("resource", ""));%>"/>
	      <input type="hidden" name="form" value="<%Response.Write(form.GetStep());%>"/>
	      <input type = "hidden" name = "refresh" value = ""/>
	      	
	      <!-- ============= end WIZARD HEADER ============== -->
	
	