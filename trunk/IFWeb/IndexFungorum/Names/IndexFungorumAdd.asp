<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum - Add New Record</title>
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
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
<!--#include file="../Connections/DataAccess.asp"-->
</head>
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<a name="TopOfPage"></a> 
<table width="100%" height="100%" class="mainbody">
  <tr> 
    <td height="105"> <table width="100%" border="0" class="mainbody">
        <tr> 
          <td class="h1"> <img src="../IMAGES/LogoIF.gif" alt="Index Fungorum - Species Fungorum" width="100" height="100">Index&nbsp;Fungorum 
            - add missing name </td>
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
sub DisplayRecord()
	dim RS, strSQL, dbConn, strConn, strNameOfFungus, strAuthor, strOrthographyComment, strPublishingAuthors, strPubAcceptedTitle
	dim strVolume, strPart, strPage, strYearOfPublication, strYearOnPublication, strSynonymy, strHost, strLocation
	dim strTypificationDetails, strNomenclaturalComment, strRecordNumber, strNotes, strEmail 
	dim strPopup, strStr, strJava

	response.write("<form name='frmIndexFungorumAdd' method='post' action='../Names/IndexFungorumAddNameValidation.asp' onSubmit='return CheckForm();'>")
	response.write("<table width='100%' border='1' cellspacing='0' cellpadding='5'>")
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Name of Fungus</span></td>")
	response.write("<td width='85%'><input type=text value='' name=NameOfFungus id=NameOfFungus size='80' maxlength='100'>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Author(s) of name</span></td>")
	response.write("<td width='85%'><input type=text value='' name=Author id=Author size='80' maxlength='100'>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Original orthography</span></td>")
	response.write("<td width='85%'><input type=text value='' name=OrthographyComment id=OrthographyComment size='80' maxlength='80'>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Publishing authors</span></td>")
	response.write("<td width='85%'><input type=text value='' name=PublishingAuthors id=PublishingAuthors size='80' maxlength='110'>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<tr>")
	response.write("<td width='20%'>Title of Journal or Book</td>")
	response.write("<td width='80%'><select name='PubLink'>")
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
	strSQL = "SELECT tblRegistrationPublications.* FROM tblRegistrationPublications ORDER BY tblRegistrationPublications.pubIMIAbbr;"
	Set RS = Server.CreateObject("ADODB.Recordset")
	RS.Open strSQL, dbConn, 3
	if RS.RecordCount > 0 then
		RS.MoveFirst
		response.write("<option value=''></option>")
		do while not RS.eof
			response.write("<option value='" & server.HTMLEncode(RS("pubLink")) & "'>" & server.HTMLEncode(RS("pubIMIAbbr")) & "</option>")
			RS.MoveNext
		loop
	end if
	RS.close
	set RS = Nothing	
	response.write("</select></td>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<td width='20%'><span class=label>Other publication not in list</span></td>")
	response.write("<td width='80%'><input type=text value='' name=otherpublication id=otherpublication size='80' maxlength='255'></td>")
	response.write("</tr>")
	response.write("<td width='15%'><span class=label>Volume</span></td>")
	response.write("<td width='85%'><input type=text value='' name=Volume id=Volume size='20' maxlength='100'></td>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Part</span></td>")
	response.write("<td width='85%'><input type=text value='' name=Part id=Part size='20' maxlength='100'></td>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Page</span></td>")
	response.write("<td width='85%'><input type=text value='' name=Page id=Page size='20' maxlength='100'>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Year of publication</span></td>")
	response.write("<td width='85%'><input type=text value='' name=YearOfPublication id=YearOfPublication size='20' maxlength='100'>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Year on publication</span></td>")
	response.write("<td width='85%'><input type=text value='' name=YearOnPublication id=YearOnPublication size='20' maxlength='100'>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Basionym</span></td>")
	response.write("<td width='85%'><input type=text value='' name=Basionym id=Basionym size='80' maxlength='255'>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Type substratum</span></td>")
	response.write("<td width='85%'><input type=text value='' name=Host id=Host size='80' maxlength='255'>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<td width='20%'><span class=label>Country of origin of type</span></td>")
	response.write("<td width='80%'><select name='Location'>")
	strSQL = "SELECT tblRegistrationTypeLocality.* FROM tblRegistrationTypeLocality ORDER BY ISOCountry, DisplayCountry;"
	Set RS = Server.CreateObject("ADODB.Recordset")
	RS.Open strSQL, dbConn, 3
	if RS.RecordCount > 0 then
		RS.MoveFirst
		response.write("<option value=''></option>")
		do while not RS.eof
			response.write("<option value='" & server.HTMLEncode(RS("IFcountry")) & "'>" & server.HTMLEncode(RS("DisplayCountry")) & "</option>")
			RS.MoveNext
		loop
	end if
	RS.close
	set RS = Nothing	
	response.write("</select></td>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Typification details</span></td>")
	response.write("<td width='85%'><input type=text value='' name=TypificationDetails id=TypificationDetails size='80' maxlength='255'>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Nomenclatural comment</span></td>")
	response.write("<td width='85%'><input type=text value='' name=NomenclaturalComment id=NomenclaturalComment size='80' maxlength='255'>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Comment</span></td>")
	response.write("<td width='85%'><textarea type=text value='' name=Notes id=Notes cols='68' rows='5'></textarea></td>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<td width='15%'><span class=label>Added by</span></td>")
	response.write("<td width='85%'><input type=text value='' name=Email id=Email size='80' maxlength='80'>")
	response.write("</tr>")
	response.write("<tr>")
	response.write("<td width='15%'><input type='submit' name='Submit' value='Submit Addition'></td>")
	response.write("<td width='85%'><input type='hidden' name='RecordNumber' value='1'>&nbsp;</td>")
	response.write("</tr>")
	response.write("</table>")
	response.write("</form>")
	response.write("<a href='javascript:history.go(-1)'>back to previous page</a>")
end sub
%> <%
	DisplayRecord()
%> </td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="10" class="Footer"> <hr noshade> &copy;
	<script>
document.write(curr_year);
</script>&nbsp;<a href=javascript:popUp("../Names/IndexFungorumPartnership.htm") onMouseOver="MM_displayStatusMsg('Index Fungorum Partnership');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Index 
      Fungorum Partnership</a>. Return to <a href="../Index.htm" onMouseOver="MM_displayStatusMsg('CABI Bioscience Databases home page');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">main 
      page</a>. Return to <a href="#TopOfPage" onMouseOver="MM_displayStatusMsg('Go to top of page');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">top 
      of page</a>. </td>
  </tr>
</table>
<a name="BottomOfPage"></a> 
</body>
</html>
