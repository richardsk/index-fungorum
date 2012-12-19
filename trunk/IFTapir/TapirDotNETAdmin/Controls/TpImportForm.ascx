<%@ Control language="c#" Codebehind="TpImportForm.ascx.cs" AutoEventWireup="True" Inherits="TapirDotNET.Controls.TpImportForm" %>
		
	
	      <!-- ============ begin import FORM ============= -->
	      <span class="section">Import DiGIR configuration</span>
	      <br/>
	  
		  <asp:PlaceHolder ID="placeHolder1" Runat=server></asp:PlaceHolder>
			
	      <br/>
	      <br/>
	      <br/>
	      <form name="import" action="<%Response.Write(Request.Path);%>" method="post">
	      <input type = "hidden" name = "import" value = "1"/>
	      <table border="0" width="90%">
	       <tr>
	        <td width="30%" class="label" align="left" nowrap="nowrap">DiGIR config directory: </td>
	        <td width="70%" align="left"><input type="text" name="config_dir" value="<%Response.Write(TapirDotNET.TpUtils.GetVar("config_dir", ""));%>" size="50"/></td>
	       </tr>
	       <tr>
	        <td class="label" align="left" nowrap="nowrap">Resources file: </td>
	        <td align="left"><input type="text" name="resource_file" value="<%Response.Write(TapirDotNET.TpUtils.GetVar("resource_file", "resources.xml"));%>" size="50"/></td>
	       </tr>
	       <tr>
	        <td class="label" align="left" nowrap="nowrap">Provider metadata file: </td>
	        <td align="left"><input type="text" name="metadata_file" value="<%Response.Write(TapirDotNET.TpUtils.GetVar("metadata_file", "providerMeta.xml"));%>" size="50"/>&nbsp;<input type = "submit" name = "show_resources" value = "show resources"/></td>
	       </tr>
	      </table>
	      <br/>
	      
	      <asp:PlaceHolder ID="placeHolder2" Runat=server></asp:PlaceHolder>
	
	      </form>
	      <!-- ============= end import FORM ============== -->
	