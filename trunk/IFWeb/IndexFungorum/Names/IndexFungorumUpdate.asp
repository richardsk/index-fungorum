<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum - Submit update</title>
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
<!--#include file="../Helpers/Utility.asp"-->
</head>
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<a name="TopOfPage"></a> 
<table width="100%" height="100%" class="mainbody">
  <tr> 
    <td height="105"> <table width="100%" border="0" class="mainbody">
        <tr> 
          <td class="h1"> <img src="../IMAGES/LogoIF.gif" alt="Index Fungorum - Species Fungorum" width="100" height="100">Index&nbsp;Fungorum 
            - update name</td>
        </tr>
        <tr> 
          <td><hr noshade></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="100%" cellpadding="5">
        <tr> 
          <td> <script language="JavaScript">
//Function to check form is filled in correctly before submitting
function CheckForm () {
	//Check for an e-mail
	if (document.frmIndexFungorumUpdate.AddedBy.value==""){
		alert("Please enter your name (or e-mail address) in the 'Added by' box");
		document.frmIndexFungorumUpdate.AddedBy.focus();
		return false;
	}
	return true	
}
</script> <%
sub DisplayRecord()
	dim strNameOfFungus, strAuthor, strOrthographyComment, strPublishingAuthors, strPubAcceptedTitle, strVolume
	dim strPart, strPage, strYearOfPublication, strYearOnPublication, strSynonymy, strHost, strLocation
	dim strTypificationDetails, strNomenclaturalComment, strRecordNumber, strNotes, strEmail 
	dim strRecentRecord, strPopup, strStr, strJava, strSQL, dbConn, rs
		'CLEAR SESSION VARIABLES IN CASE OF GO-BACK
		session("strNameOfFungus") = ""
		session("strAuthor") = ""
		session("strOrthographyComment") = ""
		session("strPublishingAuthors") = ""
		session("strPubAcceptedTitle") = ""
		session("strVolume") = ""
		session("strPart") = ""
		session("strPage") = ""
		session("strYearOfPublication") = ""
		session("strYearOnPublication") = ""
		session("strSynonymy") = ""
		session("strHost") = ""
		session("strLocation") = ""
		session("strTypificationDetails") = ""
		session("strNomenclaturalComment") = ""
		strRecordNumber = ""
		session("strNotes") = ""
		session("strEmail") = ""

	Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
	if true then        
       strConn = GetConnectionString()
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "192.168.0.12" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_KIRK-WEBSERVER;Initial Catalog=IndexFungorum;Data Source=KIRK-WEBSERVER"
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
	   dbConn.open strConn
	elseif strIP = "10.0.3.13" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
	   dbConn.open strConn
	elseif strIP = "202.27.240.46" then
		strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_Devserver01;Initial Catalog=IndexFungorum;Data Source=Devserver01"
	   dbConn.open strConn
	elseif strIP = "192.168.0.1" then
	   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\cabi\cabilink.mdb"
	   dbConn.open strConn
	elseif strIP = "127.0.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=cabilink"
	end if
	strSQL ="SELECT IndexFungorum.*, Publications.* " _
		& "FROM IndexFungorum LEFT JOIN Publications ON IndexFungorum.[LITERATURE LINK] = Publications.pubLink " _
		& "WHERE (((IndexFungorum.[RECORD NUMBER])=" & protectSQL(request.querystring.item("RecordID"),true) & "));"
    Set rs = Server.CreateObject("ADODB.Recordset")
    rs.Open strSQL, dbConn, 3
    if rs.bof then 
	  rs.close
	  set rs = nothing
	  dbConn.close
	  set dbConn = nothing
	  exit sub
    end if

	strNameOfFungus = rs("NAME OF FUNGUS")
	strAuthors = rs("AUTHORS")
	strOrthographyComment = rs("ORTHOGRAPHY COMMENT")
	strPublishingAuthors = rs("PUBLISHING AUTHORS")
	strPubAcceptedTitle = rs("PubAcceptedTitle")
	strVolume = rs("VOLUME")
	strPart = rs("PART")
	strPage = rs("PAGE")
	strYearOfPublication = rs("YEAR OF PUBLICATION")
	strYearOnPublication = rs("YEAR ON PUBLICATION")
	strSynonymy = rs("SYNONYMY")
	strHost = rs("HOST")
	strLocation = rs("LOCATION")
	strTypificationDetails = rs("TYPIFICATION DETAILS")
	strNomenclaturalComment = rs("NOMENCLATURAL COMMENT")
	strNotes = rs("NOTES")
	strRecordNumber = rs("RECORD NUMBER")
	strRecentRecord = rs("LAST FIVE YEARS FLAG")

	if strRecentRecord = "X" then
		response.write("<a href='http://www.cabi.org/AbstractDatabases.asp?PID=514'>This is a recent record: see Index of Fungi</a>")
	else
	   response.write("<form name='frmIndexFungorumUpdate' method='post' action='../Names/IndexFungorumUpdateInsertUpdate.asp' onSubmit='return CheckForm();'>")
	   response.write("<table width='100%' border='0' cellspacing='0' cellpadding='5'>")
	
		response.write("<tr>")
		response.write("<td width='15%'><span class=label>Name of Fungus</span></td>")
		response.write("<td width='85%'><input type=text value='" & strn(strNameOfFungus) & "' name=NameOfFungus id=NameOfFungus size='80' maxlength='100'>")
		response.write("</tr>")
		response.write("<tr>")
		response.write("<td width='15%'><span class=label>Author(s) of name</span></td>")
		response.write("<td width='85%'><input type=text value='" & strn(strAuthors) & "' name=Author id=Author size='80' maxlength='100'>")
		response.write("</tr>")
		response.write("<tr>")
		response.write("<td width='15%'><span class=label>Original orthography</span></td>")
		response.write("<td width='85%'><input type=text value='" & strn(strOrthographyComment) & "' name=OrthographyComment id=OrthographyComment size='80' maxlength='80'>")
		response.write("</tr>")
		response.write("<tr>")
		response.write("<td width='15%'><span class=label>Publishing authors</span></td>")
		response.write("<td width='85%'><input type=text value='" & strn(strPublishingAuthors) & "' name=PublishingAuthors id=PublishingAuthors size='80' maxlength='110'>")
		response.write("</tr>")
		response.write("<tr>")
		response.write("<td width='15%'><span class=label>Literature title</span></td>")
		response.write("<td width='85%'><input type=text value='" & strn(strPubAcceptedTitle) & "' name=PubAcceptedTitle id=PubAcceptedTitle size='80' maxlength='255'>")
		response.write("</tr>")
		response.write("<tr>")
		response.write("<td width='15%'><span class=label>Volume</span></td>")
		response.write("<td width='85%'><input type=text value='" & strn(strVolume) & "' name=Volume id=Volume size='20' maxlength='100'></td>")
		response.write("</tr>")
		response.write("<tr>")
		response.write("<td width='15%'><span class=label>Part</span></td>")
		response.write("<td width='85%'><input type=text value='" & strn(strPart) & "' name=Part id=Part size='20' maxlength='100'></td>")
		response.write("</tr>")
		response.write("<tr>")
		response.write("<td width='15%'><span class=label>Page</span></td>")
		response.write("<td width='85%'><input type=text value='" & strn(strPage) & "' name=Page id=Page size='20' maxlength='100'>")
		response.write("</tr>")
		response.write("<tr>")
		response.write("<td width='15%'><span class=label>Year of publication</span></td>")
		response.write("<td width='85%'><input type=text value='" & strn(strYearOfPublication) & "' name=YearOfPublication id=YearOfPublication size='20' maxlength='100'>")
		response.write("</tr>")
		response.write("<tr>")
		response.write("<td width='15%'><span class=label>Year on publication</span></td>")
		response.write("<td width='85%'><input type=text value='" & strn(strYearOnPublication) & "' name=YearOnPublication id=YearOnPublication size='20' maxlength='100'>")
		response.write("</tr>")
		response.write("<tr>")
		response.write("<td width='15%'><span class=label>Replaced/competing synonym</span></td>")
		response.write("<td width='85%'><input type=text value='" & strn(strSynonymy) & "' name=Synonymy id=Synonymy size='80' maxlength='255'>")
		response.write("</tr>")
		response.write("<tr>")
		response.write("<td width='15%'><span class=label>Type substratum</span></td>")
		response.write("<td width='85%'><input type=text value='" & strn(strHost) & "' name=Host id=Host size='80' maxlength='255'>")
		response.write("</tr>")
		response.write("<tr>")
		response.write("<td width='15%'><span class=label>Type locality</span></td>")
		response.write("<td width='85%'><input type=text value='" & strn(strLocation) & "' name=Location id=Location size='80' maxlength='255'>")
		response.write("</tr>")
		response.write("<tr>")
		response.write("<td width='15%'><span class=label>Typification details</span></td>")
		response.write("<td width='85%'><input type=text value='" & strn(strTypificationDetails) & "' name=TypificationDetails id=TypificationDetails size='80' maxlength='255'>")
		response.write("</tr>")
		response.write("<tr>")
		response.write("<td width='15%'><span class=label>Nomenclatural comment</span></td>")
		response.write("<td width='85%'><input type=text value='" & strn(strNomenclaturalComment) & "' name=NomenclaturalComment id=NomenclaturalComment size='80' maxlength='255'>")
		response.write("</tr>")
		response.write("<tr>")
		response.write("<td width='15%'><span class=label>Comment</span></td>")
		response.write("<td width='85%'><textarea type=text value='" & strn(strNotes) & "' name=Notes id=Notes cols='68' rows='5'></textarea></td>")
		response.write("</tr>")
		response.write("<tr>")
		response.write("<td width='15%'><span class=label>Updated by (email address)</span></td>")
		response.write("<td width='85%'><input type=text value='' name=strEmail id=strEmail size='80' maxlength='80'>")
		response.write("</tr>")
		response.write("<tr>")
		response.write("<td width='15%'><input type='submit' name='Submit' value='Submit Changes'></td>")
		response.write("<td width='85%'><input type='hidden' name='RECORDNUMBER' value='" & strRecordNumber & "'></td>")
		response.write("</tr>")
		response.write("</table>")
		response.write("</form>")
	end if
		rs.close
		set rs = nothing
		dbConn.close
		set dbConn = nothing
end sub

function strn(str)
	if isnull(str) then
		strn = ""
	else
		if instr(str,"'") <> 0 then
			do while instr(str,"'") <> 0
				str = left(str,instr(str,"'")-1) & right(str,len(str)-instr(str,"'"))
			loop
			strn = str
		else
			strn = str
		end if
	end if  
end function 
%> 
            <%
if request.querystring.count > 0 then
   DisplayRecord()
else
   response.write("Unexpected error: there are no variables to process?")
end if
   response.write("<p><a href='javascript:history.go(-1)'>back to previous page</a></p>")
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
