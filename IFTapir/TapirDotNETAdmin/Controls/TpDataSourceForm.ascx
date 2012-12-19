<%@ Control language="c#" Codebehind="TpDataSourceForm.ascx.cs" AutoEventWireup="True" Inherits="TapirDotNET.Controls.TpDataSourceForm" %>
<asp:Panel runat="server" id="Panel1"> <!-- beginning of DataSourceForm --><BR>
	<TABLE cellSpacing="1" cellPadding="1" width="92%" align="center" bgColor="#999999">
		<TR bgColor="#ffffee">
			<TD vAlign="middle" align="left" width="25%"><SPAN class="label"><%Response.Write(TapirDotNET.TpConfigManager.TP_MANDATORY_FIELD_FLAG);%>Driver: 
      </SPAN></TD>
			<TD vAlign="middle" align="left" width="75%"><%Response.Write(new TapirDotNET.TpHtmlUtils().GetCombo("dbtype", r_data_source.GetDriverName(), this.GetOptions("oledbDrivers"), false, false, "document.forms[1].refresh.value='showTemplate';document.forms[1].submit()"));%><BR>
			</TD>
		</TR>
		<TR bgColor="#ffffee">
			<TD vAlign="middle" align="left" width="25%"><SPAN class="label"><%Response.Write(TapirDotNET.TpConfigManager.TP_MANDATORY_FIELD_FLAG);%>Database 
      encoding: </SPAN></TD>
			<TD vAlign="middle" align="left" width="75%"><%Response.Write(new TapirDotNET.TpHtmlUtils().GetCombo("encoding", r_data_source.GetEncoding(), this.GetOptions("encodings"), false, 0, ""));%><BR>
			</TD>
		</TR>
		<TR bgColor="#ffffee">
			<TD vAlign="middle" align="left" width="25%"><SPAN class="label"><%Response.Write(TapirDotNET.TpConfigManager.TP_MANDATORY_FIELD_FLAG);%>
                <%Response.Write(String.Format("<a href='aa' onClick=\"javascript:window.open('help.aspx?name=DataSourceString&amp;doc={0}','help','width=400,height=250,menubar=no,toolbar=no,scrollbars=yes,resizable=yes,personalbar=no,locationbar=no,statusbar=no').focus(); return false;\" onMouseOver=\"javascript:window.status='{1}'; return true;\" onMouseOut=\"window.status=''; return true;\">Datasource string</a>:",
                      System.Web.HttpUtility.UrlEncode("Ole DB connection string to the database.  For more details on connection strings, see http://www.connectionstrings.com"), "Ole DB connection string to the database.  For more details on connection strings, see http://www.connectionstrings.com"));%>
            </SPAN></TD>
			<TD vAlign="middle" align="left" width="75%"><INPUT type=text size=70 
      value="<%Response.Write(System.Web.HttpUtility.HtmlEncode(r_data_source.GetConnectionString()));%>" 
      name=constr>
				<asp:PlaceHolder id="templTip" runat="server"></asp:PlaceHolder></TD>
		</TR>
		<!-- TODO
		<TR bgColor="#ffffee">
			<TD vAlign="middle" align="left" width="25%"><SPAN class="label"><%Response.Write(TapirDotNET.TpConfigManager.TP_MANDATORY_FIELD_FLAG);%>Username: 
      </SPAN></TD>
			<TD vAlign="middle" align="left" width="75%"><INPUT type=text size=20 
      value="<%Response.Write(r_data_source.GetUsername());%>" 
      name=uid>
			</TD>
		</TR>
		<TR bgColor="#ffffee">
			<TD vAlign="middle" align="left" width="25%"><SPAN class="label">Password: 
      </SPAN></TD>
			<TD vAlign="middle" align="left" width="75%"><INPUT type=password size=20 
      value="<%Response.Write(r_data_source.GetPassword());%>" name=pwd></TD>
		</TR>
		<TR bgColor="#ffffee">
			<TD vAlign="middle" align="left" width="25%"><SPAN class="label"><%Response.Write(TapirDotNET.TpConfigManager.TP_MANDATORY_FIELD_FLAG);%>Database 
      name: </SPAN></TD>
			<TD vAlign="middle" align="left" width="75%"><INPUT type=text size=20 
      value="<%Response.Write(r_data_source.GetDatabase());%>" 
      name=database>
			</TD>
		</TR> -->
	</TABLE>
	<P class="label_required"><%Response.Write(TapirDotNET.TpConfigManager.TP_MANDATORY_FIELD_FLAG);%>Indicates 
		mandatory fields <!--, but you can usually choose filling in "datasource string" or the next 3 fields-->
	</P>
	<BR> <!-- end of DataSourceForm -->
</asp:Panel>
