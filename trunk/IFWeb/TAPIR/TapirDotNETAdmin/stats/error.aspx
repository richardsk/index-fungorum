
	<%@ Page language="c#" CodeBehind="error.aspx.cs" AutoEventWireup="false" Inherits="TapirDotNETAdmin.stats.error" %>
	
	
	<%
		Response.Write("The next line generates an error.<br>");
		printaline("PLEASE?");
		Response.Write("This will not be displayed due to the above error.");
		
	%>
	