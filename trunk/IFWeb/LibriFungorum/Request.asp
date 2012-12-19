<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Libri Fungorum - Request Form</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=700,height=495,left=100,top=00');");
}
function MM_displayStatusMsg(msgStr) { //v1.0
  status=msgStr;
  document.MM_returnValue = true;
}
function ImagepopUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=700,height=650,left=100,top=00');");
}
function MM_displayStatusMsg(msgStr) { //v1.0
  status=msgStr;
  document.MM_returnValue = true;
}
</script>
<link href="StyleIXF.css" rel="stylesheet" type="text/css">
<!--#include file="Connections/DataAccess.asp"-->
<!--#include file="Helpers/Utility.asp"-->
</head>
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCC99">
<table width="100%" height="100%" class="mainbody">
  <tr> 
    <td height="105"> <table width="100%" border="0" class="mainbody">
        <tr> 
          <td width="50%" class="h1"> <img src="IMAGES/LogoLF.gif" alt="Index Fungorum - Species Fungorum" width="100" height="100">Libri&nbsp;Fungorum</td>
          <td align="right" valign="top"><a href="javascript:window.close();">Close</a></td>
        </tr>
        <tr> 
          <td colspan="2"><hr noshade></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="100%" cellpadding="5">
        <tr> 
          <td> <%
dim strDetails, strEmail, strDateSubmitted

if request.form.item("Details") <> "" then
	strDetails = request.form.item("Details")
	strEmail = request.form.item("Email")
	strDateSubmitted = date()
end if

dim strSQL, dbConn, rs
  Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
	if true then        
       strConn = GetConnectionString()
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "192.168.0.3" then
		strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_WEBSERVER;Initial Catalog=LibriFungorum;Data Source=WEBSERVER"
	   dbConn.open strConn
	elseif strIP = "194.203.77.76" then
		strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=LibriFungorum;Data Source=EDWINBUTLER"
		dbConn.open strConn
	elseif strIP = "194.203.77.68" then
		strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=LibriFungorum;Data Source=EDWINBUTLER"
		dbConn.open strConn
	elseif strIP = "127.0.0.1" then
		strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\librifungorum\librifungorum.mdb"
		dbConn.open strConn
	else
	   dbConn.open "FILEDSN=LibriFungorum"
	end if
'Write to the database
	if strDetails <> "" then
		strSQL = "INSERT INTO tblUserRequests ([UserRequest], [EmailAddress], [DateSubmitted])"
		strSQL = strSQL & " VALUES"
		strSQL = strSQL & "('" & protectSQL(strDetails, false) & "', '" & protectSQL(strEmail, false) & "', '" & protectSQL(strDateSubmitted, false) & "');"
		dbConn.Execute(strSQL)
		strDetails = ""
		response.write("<p>Thanks you for the submission</p>")
	end if
'Close connection
  dbConn.close
  set dbConn = nothing
%>
<form name="form" method="post" action="request.asp">
              <p>If resources are available (and that may be a big 'If') we would 
                like to prioritize what we add to this digital archive. Please 
                send us details using the form below.</p>
              <p>Enter information about the publication (journal, book or other 
                item of literature) in the text box below, add your email address 
                to the email box so we can contact you, and press the submit button.</p>
              <p> 
                <input name="Details" type="text" size="105" maxlength="255">
              </p>
              <p>your email address: 
                <input name="Email" type="text" size="25" maxlength="100">
              </p>
              <p> 
                <input type="submit" name="Submit" value="Submit">
              </p>
            </form></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="10" class="Footer"> <hr noshade>
      &copy; 2004 Libri Fungorum</td>
  </tr>
</table>
</body>
</html>
