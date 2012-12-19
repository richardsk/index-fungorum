<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum-User Registration Form</title>
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
<table width="100%" height="100%">
  <tr> 
    <td height="95"> <table width="95%" border="0">
      <tr> 
        <td class="h1"> <img src="../IMAGES/LogoIF.gif" alt="Index Fungorum" width="100" height="100">Index&nbsp;Fungorum 
          User&nbsp;Registration</td>
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
  
<script>
  function checkForm() {
  UserName = document.getElementById("UserName").value;
  Password = document.getElementById("Password").value;
  UsersFullName = document.getElementById("UsersFullName").value;
  
  if (UserName == "") {
  hideAllErrors();
document.getElementById("UserNameError").style.display = "inline";
document.getElementById("UserName").select();
document.getElementById("UserName").focus();
  return false;
  } else if (Password == "") {
  hideAllErrors();
document.getElementById("PasswordError").style.display = "inline";
document.getElementById("Password").select();
document.getElementById("Password").focus();
  return false;
  } else if (UsersFullName == "") {
  hideAllErrors();
document.getElementById("UsersFullNameError").style.display = "inline";
document.getElementById("UsersFullName").select();
document.getElementById("UsersFullName").focus();
  return false;
  }
  return true;
  }
 
  function hideAllErrors() {
document.getElementById("UserNameError").style.display = "none"
document.getElementById("PasswordError").style.display = "none"
document.getElementById("UsersFullNameError").style.display = "none"
  }
</script>

<%
sub RegisterUser()
	dim dbConn, RS, strUserName, strPassword, strActiveStatus, strUsed, strUsersFullName

	' check to see if this user already exists
	strUserName = request.form.item("UserName")
	if strUserName <> "" then
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
		strSQL = "SELECT tblRegistrationUsers.UserName " _
			& "FROM tblRegistrationUsers " _
			& "WHERE (((tblRegistrationUsers.UserName) = '" & protectSQL(strUserName, false) & "'));"
		Set RS = Server.CreateObject("ADODB.Recordset")
		RS.Open strSQL, dbConn, 3
		if not RS.eof then
		' there is already a record
		RS.close
		set RS = nothing
		' add message
		strUserName = ""
		strPassword = ""
		'find out how to clear form values
		' document.getElementById("UserName").reset();
		Response.Write("This username has already been registered, please chose another username<br><br>")
	else
		' user OK
		Register()
	end if
	end if

	strStr = chr(34) & chr(41)
	strJava = "javascript:popUp(" & chr(34)
	strPopup = "<a href='" & strJava & "IndexFungorumRegisterUserHelp.htm" & strStr & "'><img src='../IMAGES/i.gif' alt='Click here for help registering' width='13' height='13' border='0'></a>"
'	response.write(strPopup)
	response.write("User Name: Use a valid email address so that the system can contact you;<br>Password: Your choice, but do not make it too easy;<br>")
	response.write("Users Full Name: This will be the form of your name used as an author of any publications you create")
	response.write("<form name='frmIndexFungorumUserAdd' onSubmit='return checkForm();' method=post action='../Names/IndexFungorumRegisterUser.asp'>")
	response.write("<table width='70%' border='1' cellspacing='0' cellpadding='5'>")
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>User name</span></td>")
	response.write("<td width='85%'><input type=text value='' name=UserName id=UserName size='50' maxlength='50'>")
	response.write("<div class=error id=UserNameError><b>Required: Please enter your email address</b></div>&nbsp;<font color='#FF0000'><b>*</b></font></td>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Password</span></td>")
	response.write("<td width='85%'><input type=text value='' name=Password id=Password size='50' maxlength='50'>")
	response.write("<div class=error id=PasswordError><b>Required: Please enter a password</b></div>&nbsp;<font color='#FF0000'><b>*</b></font></td>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Users Full Name</span></td>")
	response.write("<td width='85%'><input type=text value='' name=UsersFullName id=UsersFullName size='50' maxlength='50'>")
	response.write("<div class=error id=UsersFullNameError><b>Required: Please enter your full name</b></div>&nbsp;<font color='#FF0000'><b>*</b></font></td>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<td width='15%'><input type='submit' name='Submit' value='RegisterUser'></td>")
	response.write("<td width='85%'>&nbsp;</td>")
	response.write("</tr>")
	response.write("</table>")
	response.write("</form>")
end sub

sub Register()
	if request.form.item("UserName") <> "" and request.form.item("Password") <> "" then
		strUserName = request.form.item("UserName")
		strPassword = request.form.item("Password")
		strUsersFullName = request.form.item("UsersFullName")
		' add to database
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
		' insert the record
		strActiveStatus = "N"
		strSQL = "INSERT INTO tblRegistrationUsers ([UserName], [UserPassword], [UsersFullName], [ActiveStatus])"
		strSQL = strSQL & " VALUES"
		strSQL = strSQL & "('" & protectSQL(strUserName, false) & "', '" & protectSQL(strPassword, false) & "', '" & protectSQL(strUsersFullName, false) & "', '" & protectSQL(strActiveStatus, false) & "');"
		dbConn.Execute(strSQL)
	
	' generate email with UUID link to activate
	' find UUID for this user
		strSQL = "SELECT tblRegistrationUsers.UUID " _
			& "FROM tblRegistrationUsers " _
			& "WHERE (((tblRegistrationUsers.UserName) = '" & protectSQL(strUserName, false) & "'));"
		Set RS = Server.CreateObject("ADODB.Recordset")
		RS.Open strSQL, dbConn, 3
		strUUID = RS("UUID")
		RS.close
		set RS = nothing
		dbConn.close
		set dbConn = Nothing

		Set objEmail = CreateObject("CDO.Message")
		objEmail.From = "p.kirk@cabi.org"
		objEmail.To = strUserName
		objEmail.Cc = "p.kirk@cabi.org"
		objEmail.Subject = "Index Fungorum User Name Activation"
		Body = "Thank you for registering with Index Fungorum" & vbCrLf & vbCrLf
		Body = Body & "User name: " & strUserName & vbCrLf & vbCrLf
		Body = Body & "Password: " & strPassword & vbCrLf & vbCrLf
		Body = Body & "Your password will be activated shortly and an email will be sent confirming this" & vbCrLf & vbCrLf
		objEmail.HTMLBody = Body
	'	objEmail.TextBody = Body
		objEmail.Send

		objEmail.From = "p.kirk@cabi.org"
		objEmail.To = "p.kirk@cabi.org"
		objEmail.Subject = "Index Fungorum User Name Activation"
		Body = "Thank you for registering with Index Fungorum" & vbCrLf & vbCrLf
		Body = Body & "User name: " & strUserName & vbCrLf & vbCrLf
		Body = Body & "Password: " & strPassword & vbCrLf & vbCrLf
		Body = Body & "To Activate your password use the following link: " & vbCrLf & vbCrLf
		if strIP = "10.0.5.10" then
			strURL = "http://backup.indexfungorum.org/names/IndexFungorumRegisterUserActivation.asp?UUID=" & strUUID
		elseif strIP = "10.0.5.4" then
			strURL = "http://www.indexfungorum.org/names/IndexFungorumRegisterUserActivation.asp?UUID=" & strUUID
		else
			strURL = "http://www.indexfungorum.org/names/IndexFungorumRegisterUserActivation.asp?UUID=" & strUUID
		end if
		Body = Body & strURL & vbCrLf & vbCrLf
		objEmail.HTMLBody = Body
	'	objEmail.TextBody = Body
		objEmail.Send
		Set objEmail = Nothing
	
	' completion message and options for next step
		Response.Write("<b><font color='#0000FF'>" & strUserName & "</b> has been registered</font><br><br>")
		strUserName = ""
		strPassword = ""
		Response.Write("check your email for notification of account activation<br><br>")
	end if
end sub
%>
<%
	RegisterUser()
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
