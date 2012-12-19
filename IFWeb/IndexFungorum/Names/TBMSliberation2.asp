<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>TBMS Liberation</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
<!--#include file="../Connections/DataAccess.asp"-->
<script language="JavaScript">
<!--
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=700,height=495,left=100,top=00');");
}
//-->
</script>
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
          <td valign="top">&nbsp;</td>
          <td valign="top">
		  </td>
        </tr>
        <tr> 
          <td valign="top">
<%
dim strTitleVolume
strTitleVolume = Request.Form("TitleVolume")

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

strSQL = "UPDATE IndexFungorum " _
	& "SET IndexFungorum.CORRECTION = [tblLinkUpdate].[CORRECTION] " _
	& "FROM tblLinkUpdate INNER JOIN IndexFungorum " _
	& "ON IndexFungorum.[RECORD NUMBER] = tblLinkUpdate.RecordNumber " _
	& "WHERE (((tblLinkUpdate.TitleVolume)='" & strTitleVolume & "') AND ((tblLinkUpdate.Done)='0'));"

dbConn.Execute(strSQL)

strSQL = "UPDATE tblLinkUpdate " _
	& "SET tblLinkUpdate.Done = '1' " _
	& "WHERE (((tblLinkUpdate.TitleVolume)='" & strTitleVolume & "'));"

dbConn.Execute(strSQL)

dbConn.close
set dbConn = Nothing

	Response.Write("<table width='400' border='1' align='center'>")
	Response.Write("<tr><td colspan=""2"" align=""center"">")
	Response.write("<h3>Content Liberation system</h3>")
	Response.write("<b><font color='#FF0000'>The selected content has been liberated</font></b><br><br>")
	Response.write("<a href='http://www.indexfungorum.org/Names/TBMSliberation.asp'>Liberate more content</a>")
	'Clear the session
	Session.Abandon
	Response.Write("</td></tr>" & vbCrLf)
	Response.Write("</table>")
	%>
</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="10" class="Footer"> <hr noshade>
    </td>
  </tr>
</table>
</body>
</html>
