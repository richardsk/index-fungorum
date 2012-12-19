<%
If Session("loggedin") <> True Then Response.Redirect "login.asp"
strUsername = request.cookies("UserName")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum - Publish Name Preselect</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
<!--#include file="../Connections/DataAccess.asp"-->
<!--#include file="../Helpers/Utility.asp"-->
<script language="JavaScript">
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=800,height=800,left=50,top=20');");
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
</head>
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<table width="100%" height="100%" class="mainbody">
  <tr> 
    <td height="105"> <table width="100%" border="0" class="mainbody">
        <tr> 
          <td class="h1"><img src="../IMAGES/LogoIF.gif" alt="Index Fungorum" width="100" height="100">Index&nbsp;Fungorum 
            Name&nbsp;Publication:&nbsp;Name&nbsp;Selection</td>
        </tr>
        <tr> 
          <td><hr noshade></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="80%" cellpadding="5">
        <tr> 
          <td valign="top">&nbsp;</td>
          <td valign="top"></td>
        </tr>
        <tr> 
          <td valign="top">
<%
	dim strNameOfFungus, strAuthor, strPublishingAuthors, strPublication, strVolume, strPart
	dim strPage, strYearOfPublication, strYearOnPublication, strTypificationDetails, strEmail
	dim strSynonymy, strHost, strNotes, strRecordNumber, strPubLink, strOtherPublication
	dim strNameDetails, strPublicationDetails, strOtherDetails, objEmail 

'select unpublished names for this user and display in table with tick box
'get Users Full Name
	Set dbConn = Server.CreateObject("ADODB.Connection")
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
			strSQL = "SELECT tblRegistrationUsers.UsersFullName FROM tblRegistrationUsers WHERE (((tblRegistrationUsers.UserName) = '" & strUserName & "'));"
			set RS = Server.CreateObject("ADODB.Recordset")
			RS.Open strSQL, dbConn, 3
				if RS("UsersFullName") <> "" then strUsersFullName = RS("UsersFullName")
'select users unpublished names
		strSQL = "SELECT IndexFungorum.[NAME OF FUNGUS], IndexFungorum.AUTHORS, IndexFungorum.[STS FLAG], IndexFungorum.[RECORD NUMBER] " _
			& "FROM tblRegistrationUsers INNER JOIN (tblRegistrationUsersNames INNER JOIN IndexFungorum " _
			& "ON tblRegistrationUsersNames.[IF-FK] = IndexFungorum.[RECORD NUMBER]) ON tblRegistrationUsers.ID = tblRegistrationUsersNames.UserID " _
			& "WHERE (((tblRegistrationUsers.UserName)= '" & protectSQL(strUsername, false) & "') AND ((IndexFungorum.[STS FLAG])='y' Or (IndexFungorum.[STS FLAG])='t') " _
			& "AND ((IndexFungorum.[LAST FIVE YEARS FLAG])='X')) ORDER BY IndexFungorum.[NAME OF FUNGUS];"
		set RS = Server.CreateObject("ADODB.Recordset")
		RS.Open strSql, dbConn, 3
		if not RS.bof then
			response.write("<h3>Unpublished names registered by " & protectSQL(strUsersFullName, false) & "</h3>")
			response.write("Please be aware that you are responsible for the accuracy of the information you are about to publish; if you are unsure please seek advice.")
			'form
			response.write("<FORM action='IndexFungorumPublishNamePreview.asp' method='post' name='NameSelection'>")
			response.write("<FIELDSET>")
			'table headers
			response.write("<table width='100%' border='1' cellspacing='1' cellpadding='1'>")
			response.write("<tr>")
			response.write("<td width='5%'><font size='-1'><b>ID</b></font></td>")
			response.write("<td width='85%'><div align='center'><font size='-1'><b>Name</b></font></div></td>")
			response.write("<td width='10%'><div align='center'><font size='-1'><b>Publish</b></font></div></td>")
			response.write("</tr>")
			response.write("<tr>")
			do while not RS.eof
				response.write("<tr>")
				response.write("<td><div align='left'><font size='-1'>" & RS("RECORD NUMBER") & "</font></div></td>")
				if RS("STS FLAG") = "t" then
					strNameOfFungus = RS("NAME OF FUNGUS") & " " & server.HTMLEncode(RS("AUTHORS")) & "&nbsp;(typification)"
				else
					strNameOfFungus = RS("NAME OF FUNGUS") & " " & server.HTMLEncode(RS("AUTHORS"))
				end if
				if strNameOfFungus <> "" then
					response.write("<td><div align='left'><font size='-1'>" & strNameOfFungus & "</font></div></td>")
				else
					response.write("<td><font size='-1'>&nbsp;</font></td>")
				end if
				response.write("<td><div align='center'><font size='-1'>")
				response.write("<input name='1' type='checkbox' value='" & RS("RECORD NUMBER") & "'>")
				response.write("</font></div></td>")
				response.write("</tr>")
				RS.Movenext
			loop
			response.write("<tr>")
			response.write("<td><div align='center'><font size='-1'>&nbsp;</font></div></td>")
			response.write("<td><div align='center'><font size='-1'>&nbsp;</font></div></td>")
			response.write("<td><div align='center'><font size='-1'><input type='submit' name='submit' value='Publish'></font></div></td>")
			response.write("</tr>")
			response.write("</table>")
			response.write("</FIELDSET>")
			response.write("</FORM>")
		else
			'none found
			response.write("<h3>No unpublished names have been registered by " & strUsersFullName & "</h3>")
			response.write("Return to <a href='../Index.htm'>Index Fungorum main page</a> or <a href='IndexFungorumRegisterName.asp'>register a name</a>")
		end if
		RS.close
		set RS = nothing
		dbConn.close
		set dbConn = nothing
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
