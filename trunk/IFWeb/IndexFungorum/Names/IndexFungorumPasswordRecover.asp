<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum - User Password Recover</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
<!--#include file="../Connections/DataAccess.asp"-->
<!--#include file="../Helpers/Utility.asp"-->
</head>
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<%
sub RecoverPassword()
	dim dbConn, RS, strUserName, strUserPassword, strActiveStatus, strData

	if request.form.item("UserName") <> "" then
		strUserName = request.form.item("UserName")
		' recover password
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
	
		strSQL = "SELECT tblRegistrationUsers.UserPassword " _
			& "FROM tblRegistrationUsers " _
			& "WHERE (((tblRegistrationUsers.UserName) = '" & protectSQL(strUserName, false) & "'));"
		Set RS = Server.CreateObject("ADODB.Recordset")
		RS.Open strSQL, dbConn, 3
		strUserPassword = RS("UserPassword")
		strData = strUserName & "|" & strUserPassword
		SendEmail(strData)
		RS.close
		set RS = nothing
		dbConn.close
		set dbConn = Nothing
	end if
'response.write("SQL is:&nbsp;" & strSQL)

	response.write("<br>")
	response.write("<form name='frmIndexFungorumUserPasswordRecover' method='post' action='../Names/IndexFungorumPasswordRecover.asp'>")
	response.write("<table width='20%' border='1' cellspacing='0' cellpadding='5' align='center'>")
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>enter your email address</span></td>")
	response.write("<td width='85%'><input type=text value='' name=UserName id=UserName size='25' maxlength='25'>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<td width='15%'><input type='submit' name='Submit' value='Recover Password'></td>")
	response.write("<td width='85%'>&nbsp;</td>")
	response.write("</tr>")
	response.write("</table>")
	response.write("</form>")
end sub

sub SendEmail(strData)
	strUserName = left(strData,instr(strData,"|")-1)
	strUserPassword = right(strData,len(strData)-len(strUserName)-1)
	'response.write("user name is:&nbsp;" & strUserName & "<br>")
	'response.write("user password is:&nbsp;" & strUserPassword)
		Set objEmail = CreateObject("CDO.Message")
		objEmail.From = "p.kirk@cabi.org"
		objEmail.To = strUserName
		objEmail.Cc = "p.kirk@cabi.org"
		objEmail.Subject = "Index Fungorum User Name Password Recovery"
		Body = "Your username and password for Index Fungorum" & vbCrLf & vbCrLf
		Body = Body & "User name: " & strUserName & vbCrLf & vbCrLf
		Body = Body & "Password: " & strUserPassword & vbCrLf & vbCrLf
		objEmail.HTMLBody = Body
		objEmail.Send
		Set objEmail = Nothing
end sub

%>
<%
	RecoverPassword()
%>
</body>
</html>
