<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum - Register Name</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script language="JavaScript">
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=700,height=495,left=100,top=00');");
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

<script language="javascript">
<!--
function Act_onchange(frmSelect) {
	frmSelect.submit(); 
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
          <td class="h1"> <img src="../IMAGES/LogoIF.gif" alt="Index Fungorum - Species Fungorum" width="100" height="100">Index&nbsp;Fungorum 
            - register or publish name</td>
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
sub DisplayForm()
	dim RS, strConn, dbConn, strNameOfFungus, strAuthor, strPublishingAuthors, strPubLink, strVolume, strPart
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

' if form value is null the do not display action
	if strn(Request.Form("frmRegistrationSelectAct")) = "New species" then
		strText = "New species"
		response.write("selection was" & strText)
		strText = ""
	elseif strn(Request.Form("frmRegistrationSelectAct")) = "New genus" then
		strText = "New genus"
		response.write("selection was" & strText)
		strText = ""
	else
		response.write(strText)
	end if












	response.write("<FORM name='frmRegistrationSelectAct' LANGUAGE=javascript onchange='return Act_onchange(frmSelect)' onSubmit='return checkForm();' method=post action='IndexFungorumRegisterTest.asp'>")
	response.write("<table width='100%' border='1' cellspacing='0' cellpadding='5'>")

	response.write("<tr>")
	response.write("<td width='15%'>Nomenclatural Act</td>")
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
	strSql = "SELECT tblNomenclaturalActs.* FROM tblNomenclaturalActs ORDER BY tblNomenclaturalActs.ID;"
	Set RS = Server.CreateObject("ADODB.Recordset")
	RS.Open strSql, dbConn, 3
	if RS.RecordCount > 0 then
			RS.MoveFirst
				response.write("<option value=''></option>")
				do while not RS.eof
				response.write("<option value='" & RS("ID") & "'>" & RS("NomenclaturalAct") & "</option>")
				RS.MoveNext
			loop
	end if
	rs.close
	set rs = Nothing	
	dbConn.close
	set dbConn = Nothing
	response.write("</select></td>")
	response.write("</tr>")

	response.write("</tr>")
	response.write("<td width='15%'><input type='submit' name='Submit' value='Register Name'></td>")
	response.write("<td width='85%'>&nbsp;<input type='hidden' name='RecordNumber' value='1'></td>")
	response.write("</tr>")
	response.write("</table>")
	
	response.write("</form>")
end sub

	function strn(str)
		if isnull(str) then 
			strn = ""
		else
			strn = str
		end if  
	end function

%> <%
	'build strPopup to add gif for display explanation
	strStr = chr(34) & chr(41)
	strJava = "javascript:popUp(" & chr(34)
	strPopup = "<a href='" & strJava & "DisplayExplanation.htm" & strStr & "'><img src='../IMAGES/i.gif' alt='Click here for help completing the fields' width='13' height='13' border='0'></a>"
	response.write("<h3>fields marked <font color='#FF0000' size='-1'><b>*</b></font> are mandatory&nbsp;" & strPopup & "</h3>")
	DisplayForm()
%>
<p>&nbsp;</p>
            <p><a href='javascript:history.go(-1)'>back to previous page</a></p></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="10" class="Footer"> <hr noshade> &copy;
                    <script>
document.write(curr_year);
</script> 
	 <a href=javascript:popUp("../Names/IndexFungorumPartnership.htm") onMouseOver="MM_displayStatusMsg('Index Fungorum Partnership');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Index 
      Fungorum Partnership</a>. Return to <a href="../Index.htm" onMouseOver="MM_displayStatusMsg('CABI Bioscience Databases home page');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">main 
      page</a>. Return to <a href="#TopOfPage" onMouseOver="MM_displayStatusMsg('Go to top of page');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">top 
      of page</a>. </td>
  </tr>
</table>
</body>
</html>
