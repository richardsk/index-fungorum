<%@ Control language="c#" Codebehind="TpResourceForm.ascx.cs" AutoEventWireup="True" Inherits="TapirDotNET.Controls.TpResourceForm" %>
	
	
	      <!-- ============ begin RESOURCE FORM ============= -->
	
	      <!------------------ begin TOP MENU ------------------>
	      <span class="section"><%Response.Write(mrResource.GetCode());%></span>
	      <br/>
	      <br/>
	      <asp:Panel Runat=server ID="panel1">
	      </asp:Panel>
	      <!------------------- end TOP MENU ------------------->
	
	  	
	      <form name="resource" action="<%Response.Write(Request.Path);%>" method="post">
	      <input type="hidden" name="resource" value="<%Response.Write(TapirDotNET.TpUtils.GetVar("resource", ""));%>"/>
	      <input type = "hidden" name = "refresh" value = ""/>
	      <input type = "hidden" name = "scroll"/>
	
	      <br/>
	      <br/>
	      <table width="60%" border="0">
	       <tr>
	        <td class="label" width="20%" valign="top" align="left">Status:</td>
	        <td width="80%" valign="top" align="left">
	          <%Response.Write(mrResource.GetStatus());%>
	          <pre>
	<span class="tip">metadata............<%
		if (mrResource.ConfiguredMetadata())
		{
		%>OK<%
		}
		else
		{
		%>incomplete<%
		}
	%></span>
	<span class="tip">data source.........<%
		if (mrResource.ConfiguredDatasource())
		{
		%>OK (checking completeness, not validity)<%
		}
		else
		{
		%>incomplete<%
		}
	%></span>
	<span class="tip">tables..............<%
		if (mrResource.ConfiguredTables())
		{
		%>OK (checking completeness, not validity)<%
		}
		else
		{
		%>incomplete<%
		}
	%></span>
	<span class="tip">local filter........<%
		if (mrResource.ConfiguredLocalFilter())
		{
		%>OK (checking completeness, not validity)<%
		}
		else
		{
		%>incomplete<%
		}
	%></span>
	<span class="tip">mapping.............<%
		if (mrResource.ConfiguredMapping())
		{
		%>OK (checking completeness, not validity)<%
		}
		else
		{
		%>incomplete<%
		}
	%></span>
	<span class="tip">settings............<%
		if (mrResource.ConfiguredSettings())
		{
		%>OK (checking completeness, not validity)<%
		}
		else
		{
		%>incomplete<%
		}
	%></span>
	          </pre>
	          <%
	    if (new TapirDotNET.TpDiagnostics().Count(new Utility.OrderedMap(TapirDotNET.TpConfigManager.DIAG_ERROR, TapirDotNET.TpConfigManager.DIAG_FATAL)) > 0)
		{
		%><span class="tip"><%
		      Response.Write(Utility.StringSupport.Nl2br(new TapirDotNET.TpDiagnostics().Dump()));
		%></span><br/><br/><%
		}
	%>
	        </td>
	       </tr>
	       <tr>
	        <%string accesspoint = mrResource.GetAccesspoint();
	%>
	        <td class="label" valign="top" align="left">Accesspoint:</td>
	        <td valign="top" align="left"><%
		if (accesspoint.Length > 0)
		{
		%><a href="<%Response.Write(mrResource.GetAccesspoint());
		%>"><%Response.Write(mrResource.GetAccesspoint());
		%></a><%
		}
		else
		{
		%>?<%
		}
	%></td>
	       </tr>
	      </table>
	      <br/>
	      <br/>
	      <br/>
	      <input type = "submit" name = "remove" value = "remove this resource" onClick = "return confirmRemoval()">&nbsp;&nbsp;
	
	      <br/>
	      </form>
	
	      <!-- ============= end RESOURCE FORM ============== -->
	