
<!--#include file="../Connections/DataAccess.asp"-->
<!--#include file="../Helpers/Utility.asp"-->
<%
Option Explicit
Dim strError, strSQL, objRS, strConn, dbConn, strPassword, strUser, strIP
'see if the form has been submitted
If Request.Form("action") = "login" Then
   'the form has been submitted
   '// validate the form
   'check if a username has been entered
   If Request.Form("username") = "" Then strError = strError & "- Please enter a username<br>" & vbNewLine
   'check if a password has been entered
   If Request.Form("password") = "" Then strError = strError & "- Please enter a password<br>" & vbNewLine 
   '// check if an error has occured
   If strError = "" Then
      'continue
      'include database connection code
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
      '// create the SQL
		strSQL = "SELECT tblRegistrationUsers.UserName, tblRegistrationUsers.UserPassword " _
			& "FROM tblRegistrationUsers " _
			& "WHERE (((tblRegistrationUsers.UserName) = '" & protectSQL(Request.Form("username"), false) & "'));"
      '// run the SQL
		Set objRS = Server.CreateObject("ADODB.Recordset")
		objRS.Open strSQL, dbConn, 3
      '// see if there are any records returned
      If objRS.EOF Then
          'no username found
          strError = "- Invalid username<br>" & vbNewLine
      Else
		strPassword = objRS("UserPassword")
		strUser = objRS("UserName")
          'check password
          If strPassword = Request.Form("password") Then
               'username/password valid
               'save session data
               Session("loggedin") = True
			   response.cookies("username") = Request.Form("username")
			   response.cookies("password") = Request.Form("password")
              Session("userid") = objRS("UserName")
               'redirect to members area
               response.redirect("IndexFungorumPublishNamePreselect.asp")
               response.End
          Else
               'invalid password
               strError = "- Invalid password<br>" & vbNewLine
          End If
      End If
   End If
   If strError <> "" Then
      'output the error message
      'add extra HTML...
      strError = "<p><font color=""#FF0000"">The following errors occured:</font><br>" & vbNewLine & strError
   End If
   'display message in URL.. (ie thank you for registering)
   If Request.QueryString("msg") <> "" And strError = "" Then
      strError = "<p>" & Request.QueryString("msg") & "</p>"
   End If
End If

're-set session data (ie log out)
Session("loggedin")=""
Session("userid") = ""
%>
<html>
<head>
<title>User Login</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
</head>

<body>
<script type="text/javascript">
var d = new Date();
var curr_year = d.getFullYear();
</script>
<script language="JavaScript">
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,top=00');");
}
</script>
<script>
self.moveTo(0,0);self.resizeTo(screen.availWidth,screen.availHeight);
</script>
<script language="JavaScript">
function popUp1(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=500,height=110,left=400,top=200');");
}
</script>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center" valign="middle"> <table border="0" cellpadding="0" cellspacing="0">
<tr> 
          <td height="30"> <table width="100%" height="30" border="0" cellpadding="0" cellspacing="0" class="mainbody">
              <tr> 
                <td width="4"><img src="../images/Frame_ulcorn.gif" width="4" height="30"></td>
                <td background="../images/Frame_uc.gif"><div align="left"><font color="#FFFF63" size="3" face="Arial, Helvetica, sans-serif">Login</font></div></td>
                <td width="4"><img src="../images/Frame_urcorn.gif" width="4" height="30"></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td> <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="mainbody">
              <tr> 
                <td width="4" background="../images/Frame_lb.gif">&nbsp;</td>
                <td valign="top" bgcolor="#FFF7E7"><table width="100%" border="0" cellspacing="0" cellpadding="10" class="mainbody">
                    <tr> 
                      <td></td>
                    </tr>
                  </table>
                  <table border="0" align="center" cellpadding="10" cellspacing="0" class="mainbody">
                    <tr> 
                      <td nowrap> <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif"><%=strError%></font></div>
                        <form action="login2.asp" method="POST">
                          <div align="center"> <font face="Verdana, Arial, Helvetica, sans-serif"> 
                            <input type="hidden" name="action" value="login">
                            </font> 
                            <table border="0" class="mainbody">
                              <tr> 
                                <td><font face="Verdana, Arial, Helvetica, sans-serif"><b>Username:</b></font></td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif"> 
                                  <input type="text" maxlength=50 name="username" style="Width:150px" value="<%=Server.HTMLEncode(Request.Form("username"))%>"  onfocus="style.backgroundColor='#C7E9FC'" onblur="style.backgroundColor='#FFFFFF'">
                                  </font></td>
                              </tr>
                              <tr> 
                                <td><font face="Verdana, Arial, Helvetica, sans-serif"><b>Password:</b></font></td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif"> 
                                  <input type="password" maxlength=50 name="password" style="Width:150px" value="<%=Server.HTMLEncode(Request.Form("password"))%>"  onfocus="style.backgroundColor='#C7E9FC'" onblur="style.backgroundColor='#FFFFFF'">
                                  </font></td>
                              </tr>
                              <tr> 
                                <td> </td>
                                <td rowspan="2"><div align="right"> <font face="Verdana, Arial, Helvetica, sans-serif"> 
                                    <input name="submit" type="submit" value="Login">
                                    </font></div></td>
                              </tr>
                              <tr>
                                <td><a href=javascript:popUp1("IndexFungorumPasswordRecover.asp")>forgotten<br>
                                  password</a></td>
                              </tr>
                            </table>
                          </div>
                        </form></td>
                    </tr>
                  </table></td>
                <td width="4" background="../images/Frame_rb.gif">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="30"> <table width="100%" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="5"><img src="../images/Frame_dlcorn.gif" width="5" height="29"></td>
                <td background="../images/Frame_dc.gif"><div align="center"><span class="copyright">&copy; 
                    <script>
document.write(curr_year);
</script> 
:: All rights reserved</span></div></td>
                <td width="4"><img src="../images/Frame_drcorn.gif" width="4" height="29"></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>
