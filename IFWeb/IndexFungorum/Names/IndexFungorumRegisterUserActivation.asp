<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum-User Activation</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script language="JavaScript">
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=820,height=495,left=100,top=00');");
}
function MM_displayStatusMsg(msgStr) { //v1.0
  status=msgStr;
  document.MM_returnValue = true;
}
</script>
<script type="text/javascript">
var d = new Date();
var curr_year = d.getFullYear();
</script>
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
<!--#include file="../Connections/DataAccess.asp"-->
<!--#include file="../Helpers/Utility.asp"-->
</head>
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<table width="100%" height="100%" class="mainbody">
  <tr> 
    <td height="105"> <table width="100%" border="0" class="mainbody">
      <tr> 
        <td class="h1"> <img src="../IMAGES/LogoIF.gif" alt="Index Fungorum" width="100" height="100">Index&nbsp;Fungorum 
          User&nbsp;Activation</td>
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
<style>
  .error {
  font-family: Verdana, Arial, Helvetica, sans-serif;
  font-size: 8pt;
  color: red;
  margin-left: 50px;
  display:none;
  }
</style>
  
<%
sub ActivateUser()
	dim strIP, dbConn, strUUID, strUserName

		strUUID = request.querystring.item("UUID")
		' activate user name
		' set up database connection
		Set dbConn = Server.CreateObject("ADODB.Connection")
		strIP = request.servervariables("LOCAL_ADDR")
		if true then        
           strConn = GetConnectionString()
	       dbConn.connectiontimeout = 180
	       dbConn.commandtimeout = 180
	       dbConn.open strConn
	    elseif strIP = "10.0.5.10" then
		   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
		   dbConn.open strConn
		elseif strIP = "10.0.5.4" then
		   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
		   dbConn.open strConn
		elseif strIP = "192.168.0.12" then
		   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_KIRK-WEBSERVER;Initial Catalog=IndexFungorum;Data Source=KIRK-WEBSERVER"
		   dbConn.open strConn
		else
		   dbConn.open "FILEDSN=cabilink"
		end if
		' update record
		strSQL = "UPDATE tblRegistrationUsers SET tblRegistrationUsers.ActiveStatus = 'Y' " _
			& "WHERE (((tblRegistrationUsers.UUID) = '" & protectSQL(strUUID,true) & "'));"
		dbConn.Execute(strSQL)
		' find user login
		strSQL = "SELECT tblRegistrationUsers.UserName " _
			& "FROM tblRegistrationUsers " _
			& "WHERE (((tblRegistrationUsers.UUID) = '" & protectSQL(strUUID,true) & "'));"
		Set RS = Server.CreateObject("ADODB.Recordset")
		RS.Open strSQL, dbConn, 3
		strUserName = RS("UserName")
		RS.close
		set RS = nothing
		dbConn.close
		set dbConn = Nothing
		' completion message and options for next step
		Response.Write("<b><font color='#0000FF'>" & strUserName & "</b> has been activated</font><br><br>")
end sub
%>
<%
	ActivateUser()
%>
</td>
  <tr> 
    <td height="10" class="Footer"> <hr noshade> &copy;
	<script>
document.write(curr_year);
</script> 
<a href=javascript:popUp("../Names/IndexFungorumPartnership.htm") onMouseOver="MM_displayStatusMsg('Index Fungorum Partnership');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Index 
      Fungorum Partnership</a></td>
  </tr>
</table>
</body>
</html>
