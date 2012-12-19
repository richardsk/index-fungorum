<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>TBMS Liberation</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script language="JavaScript">
<!--
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=820,height=495,left=100,top=00');");
}
//-->
</script>
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
<!--#include file="../Connections/DataAccess.asp"-->
</head>
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<table width="100%" height="100%" class="mainbody">
  <tr> 
    <td height="105"> <table width="100%" border="0" class="mainbody">
      <tr> 
        <td class="h1">&nbsp;TBMS&nbsp;Liberation</td>
      </tr>
      <tr> 
        <td><hr noshade></td>
      </tr>
    </table></td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="100%" cellpadding="5">
        <tr> 
          <td>
<%
sub StartForm()
	dim strTitleVolume

	response.write("<form name='frmIndexFungorumAdd' onSubmit='return checkForm();' method=post action='../Names/TBMSliberation2.asp'>")
	response.write("<table width='100%' border='1' cellspacing='0' cellpadding='5'>")
	
	response.write("<tr>")
	response.write("<td width='35%'>Title of Journal or Book to Liberate</td>")
	response.write("<td width='65%'><select name='TitleVolume'>")
	Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
	if true then        
       strConn = GetConnectionString()
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "10.0.3.13" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=cabilink"
	end if
	strSql = "SELECT DISTINCT tblLinkUpdate.TitleVolume FROM tblLinkUpdate WHERE (((tblLinkUpdate.Done)='0'));"

	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.Open strSql, dbConn, 3
	if rs.RecordCount > 0 then
			rs.MoveFirst
				response.write("<option value=''></option>")
				do while not rs.eof
				response.write("<option value='" & rs("TitleVolume") & "'>" & rs("TitleVolume") & "</option>")
				rs.MoveNext
			loop
	end if
	rs.close
	set rs = Nothing	
	dbConn.close
	set dbConn = Nothing
	response.write("</select></td>")
	response.write("</tr>")

	response.write("</tr>")
	response.write("<td width='35%'><input type='submit' name='Submit' value='Liberate Content'></td>")
	response.write("<td width='65%'>&nbsp;</td>")
	response.write("</tr>")
	response.write("</table>")
	
	response.write("</form>")
end sub
%> <%
	'build strPopup to add gif for display explanation
	response.write("<h3>select from the list and click the liberate button</h3>")
	StartForm()
%>
</td>
  <tr> 
    <td height="10" class="Footer"> <hr noshade>
        </td>
  </tr>
</table>
</body>
</html>
