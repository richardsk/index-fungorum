<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum-Name Registration Form</title>
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
</head>
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<table width="100%" height="100%" class="mainbody">
  <tr> 
    <td height="105"> <table width="100%" border="0" class="mainbody">
      <tr> 
        <td class="h1"> <img src="../IMAGES/LogoIF.gif" alt="Index Fungorum" width="100" height="100">Index&nbsp;Fungorum 
          Name&nbsp;Registration&nbsp;System</td>
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
  NameOfFungus = document.getElementById("NameOfFungus").value;
  Author = document.getElementById("Author").value;
  page = document.getElementById("page").value;
  YearOfPublication = document.getElementById("YearOfPublication").value;
  TypificationDetails = document.getElementById("TypificationDetails").value;
  Email = document.getElementById("Email").value;
  
  if (NameOfFungus == "") {
  hideAllErrors();
document.getElementById("NameOfFungusError").style.display = "inline";
document.getElementById("NameOfFungus").select();
document.getElementById("NameOfFungus").focus();
  return false;
  } else if (Author == "") {
  hideAllErrors();
document.getElementById("AuthorError").style.display = "inline";
document.getElementById("Author").select();
document.getElementById("Author").focus();
  return false;
  } else if (page == "") {
  hideAllErrors();
document.getElementById("pageError").style.display = "inline";
document.getElementById("page").select();
document.getElementById("page").focus();
  return false;
  } else if (YearOfPublication == "") {
  hideAllErrors();
document.getElementById("YearOfPublicationError").style.display = "inline";
document.getElementById("YearOfPublication").select();
document.getElementById("YearOfPublication").focus();
  return false;
  } else if (TypificationDetails == "") {
  hideAllErrors();
document.getElementById("TypificationDetailsError").style.display = "inline";
document.getElementById("TypificationDetails").select();
document.getElementById("TypificationDetails").focus();
  return false;
  } else if (Email == "") {
  hideAllErrors();
document.getElementById("EmailError").style.display = "inline";
document.getElementById("Email").select();
document.getElementById("Email").focus();
  return false;
  }
  return true;
  }
 
  function hideAllErrors() {
document.getElementById("NameOfFungusError").style.display = "none"
document.getElementById("AuthorError").style.display = "none"
document.getElementById("pageError").style.display = "none"
document.getElementById("YearOfPublicationError").style.display = "none"
document.getElementById("TypificationDetailsError").style.display = "none"
document.getElementById("EmailError").style.display = "none"
  }
</script>

<%
sub DisplayRecord()
	dim strNameOfFungus, strAuthor, strPublishingAuthors, strPubLink, strVolume, strPart
	dim strPage, strYearOfPublication, strYearOnPublication, strTypificationDetails, strEmail
	dim strSynonymy, strHost, strLocation, strNotes, pubIMIAbbr, strOtherPublication
	dim strPopup, strStr, strJava, strRecordNumber, strDiagnosis
		'CLEAR SESSION VARIABLES IN CASE OF GO-BACK
		session("strNameOfFungus") = ""
		session("strAuthor") = ""
		session("strPublishingAuthors") = ""
		session("strPubLink") = ""
		session("strOtherPublication") = ""
		session("strVolume") = ""
		session("strPart") = ""
		session("strPage") = ""
		session("strYearOfPublication") = ""
		session("strYearOnPublication") = ""
		session("strSynonymy") = ""
		session("strHost") = ""
		session("strLocation") = ""
		session("strTypificationDetails") = ""
		session("strDiagnosis") = ""
		session("strNotes") = ""
		session("strEmail") = ""
		strRecordNumber = ""

	response.write("<form name='frmIndexFungorumAdd' onSubmit='return checkForm();' method=post action='../Names/IndexFungorumRegisterName.asp'>")
	response.write("<table width='100%' border='1' cellspacing='0' cellpadding='5'>")
	
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Name of Fungus</span></td>")
	response.write("<td width='85%'><input type=text value='' name=NameOfFungus id=NameOfFungus size='80' maxlength='100'>")
	response.write("<div class=error id=NameOfFungusError>Required: Please enter the name</div>&nbsp;<font color='#FF0000'><b>*</b></font></td>")
	response.write("</tr>")
	
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Author(s) of name</span></td>")
	response.write("<td width='85%'><input type=text value='' name=Author id=Author size='80' maxlength='100'>")
	response.write("<div class=error id=AuthorError>Required: Please enter the author</div>&nbsp;<font color='#FF0000'><b>*</b></font></td>")
	response.write("</tr>")
	
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Publishing Authors</span></td>")
	response.write("<td width='85%'><input type=text value='' name=publishingauthors id=publishingauthors size='80' maxlength='100'></td>")
	response.write("</tr>")

	response.write("<tr>")
	response.write("<td width='15%'>Title of Journal or Book</td>")
	response.write("<td width='85%'><select name='PubLink'>")
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
	strSql = "SELECT tblRegistrationPublications.* FROM tblRegistrationPublications ORDER BY tblRegistrationPublications.pubIMIAbbr;"
	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.Open strSql, dbConn, 3
	if rs.RecordCount > 0 then
			rs.MoveFirst
				response.write("<option value=''></option>")
				do while not rs.eof
				response.write("<option value='" & rs("pubLink") & "'>" & rs("pubIMIAbbr") & "</option>")
				rs.MoveNext
			loop
	end if
	rs.close
	set rs = Nothing	
	dbConn.close
	set dbConn = Nothing
	response.write("</select></td>")
	response.write("</tr>")

	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Other publication not in list</span></td>")
	response.write("<td width='85%'><input type=text value='' name=otherpublication id=otherpublication size='80' maxlength='255'></td>")
	response.write("</tr>")

	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Volume</span></td>")
	response.write("<td width='85%'><input type=text value='' name=volume id=volume size='20' maxlength='100'></td>")
	response.write("</tr>")
	
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Part</span></td>")
	response.write("<td width='85%'><input type=text value='' name=part id=part size='20' maxlength='100'></td>")
	response.write("</tr>")
	
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Page</span></td>")
	response.write("<td width='85%'><input type=text value='' name=page id=page size='20' maxlength='100'>")
	response.write("<div class=error id=pageError>Required: Please enter the page or plate</div>&nbsp;<font color='#FF0000'><b>*</b></font></td>")
	response.write("</tr>")
	
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Year of publication</span></td>")
	response.write("<td width='85%'><input type=text value='' name=YearOfPublication id=YearOfPublication size='20' maxlength='4'>")
	response.write("<div class=error id=YearOfPublicationError>Required: Please enter the year of publication of the name</div>&nbsp;<font color='#FF0000'><b>*</b></font></td>")
	response.write("</tr>")

	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Year on publication</span></td>")
	response.write("<td width='85%'><input type=text value='' name=YearOnPublication id=YearOnPublication size='20' maxlength='20'></td>")
	response.write("</tr>")

	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Synonym</span></td>")

	strStr = chr(34) & chr(41)
	strJava = "javascript:popUp(" & chr(34)
	strPopup = "<a href='" & strJava & "FindBasionym.asp" & strStr & "'><img src='../IMAGES/i.gif' alt='Find basionym or replaced synonym' width='13' height='13' border='0'></a>"
	response.write("<td width='85%'><input type=text value='' name=synonymy id=synonymy size='80' maxlength='255'>&nbsp;" & strPopup & "</td>")
	response.write("</tr>")

	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Host or Substratum</span></td>")
	response.write("<td width='85%'><input type=text value='' name=host id=host size='80' maxlength='100'></td>")
	response.write("</tr>")

	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Country of origin of type</span></td>")
	response.write("<td width='85%'><select name='Location'>")
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
	strSql = "SELECT tblRegistrationTypeLocality.* FROM tblRegistrationTypeLocality ORDER BY ISOCountry, DisplayCountry;"
	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.Open strSql, dbConn, 3
	if rs.RecordCount > 0 then
			rs.MoveFirst
				response.write("<option value=''></option>")
				do while not rs.eof
				response.write("<option value='" & rs("IFcountry") & "'>" & rs("DisplayCountry") & "</option>")
				rs.MoveNext
			loop
	end if
	rs.close
	set rs = Nothing	
	dbConn.close
	set dbConn = Nothing
	response.write("</select></td>")
	response.write("</tr>")

	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Typification details</span></td>")
	response.write("<td width='85%'><input type=text value='' name=TypificationDetails id=TypificationDetails size='80' maxlength='100'>")
	response.write("<div class=error id=TypificationDetailsError>Required: Please enter details<br></div>&nbsp;<font color='#FF0000'><b>*</b></font></td>")
	response.write("</tr>")
	
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Diagnosis</span></td>")
	response.write("<td width='85%'><textarea type=text value='' name=Diagnosis id=comment cols='68' rows='5'></textarea></td>")
	response.write("</tr>")
	
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Email</span></td>")
	response.write("<td width='85%'><input type=text value='' name=Email id=Email size='40' maxlength='100'>")
	response.write("<div class=error id=EmailError>Required: Please enter your email<br></div>&nbsp;<font color='#FF0000'><b>*</b></font></td>")
	response.write("</tr>")
	
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Comment</span></td>")
	response.write("<td width='85%'><textarea type=text value='' name=Notes id=comment cols='68' rows='5'></textarea></td>")
	response.write("</tr>")
	
	response.write("</tr>")
	response.write("<td width='15%'><input type='submit' name='Submit' value='Register Name'></td>")
	response.write("<td width='85%'>&nbsp;<input type='hidden' name='RecordNumber' value='1'></td>")
	response.write("</tr>")
	response.write("</table>")
	
	response.write("</form>")
end sub
%> <%
	'build strPopup to add gif for display explanation
	strStr = chr(34) & chr(41)
	strJava = "javascript:popUp(" & chr(34)
	strPopup = "<a href='" & strJava & "DisplayExplanation.htm" & strStr & "'><img src='../IMAGES/i.gif' alt='Click here for help completing the fields' width='13' height='13' border='0'></a>"
	response.write("<h3>fields marked <font color='#FF0000' size='-1'><b>*</b></font> are mandatory&nbsp;" & strPopup & "</h3>")
	DisplayRecord()
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
