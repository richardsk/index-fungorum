<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/templates/TemplIF.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Index Fungorum - Submit update</title>
<!-- InstanceEndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=700,height=495,left=100,top=00');");
}
function MM_displayStatusMsg(msgStr) { //v1.0
  status=msgStr;
  document.MM_returnValue = true;
}
</script>
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
</head> 
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<a name="TopOfPage"></a> 
<table width="100%" height="100%" class="mainbody">
  <tr>
    <td height="105"> 
      <table width="100%" border="0" class="mainbody">
        <tr> 
          <td width="50%" class="h1"> <img src="../IMAGES/LogoIF.gif" alt="Index Fungorum - Species Fungorum" width="100" height="100">Index&nbsp;Fungorum</td>
          <td valign="top"> <table height="100%" align="center">
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("IndexFungorumPartnership.htm") onMouseOver="MM_displayStatusMsg('Index Fungorum Partnership');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Index 
                  Fungorum Partnership</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("Acknowledge.htm") onMouseOver="MM_displayStatusMsg('Acknowledgements');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Acknowledgements</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("IndexFungorum.htm") onMouseOver="MM_displayStatusMsg('Help with searching');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Help 
                  with searching</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="AuthorsOfFungalNames.asp" onMouseOver="MM_displayStatusMsg('Search Authors of Fungal Names');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Authors of Fungal Names</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="Names.asp" onMouseOver="MM_displayStatusMsg('Search Index Fungorum');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Index Fungorum</a></td>
              </tr>
              <tr class="mainbody">
                <td><a href=javascript:popUp("IndexFungorumLSIDs.htm") onMouseOver="MM_displayStatusMsg('Important Announcement');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Important 
                  Announcement</a></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td colspan="2"><hr noshade></td>
        </tr>
      </table>
      
    </td>
  </tr>
  <tr>
    <td align="left" valign="top"><table width="100%" cellpadding="5">
        <tr>
          <td><!-- InstanceBeginEditable name="head" -->
<script language="JavaScript">
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
</script>
 
<%
sub DisplayRecord()
    dim strSQL, dbConn, rs
	Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
	if strIP = "192.168.0.3" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_WEBSERVER;Initial Catalog=IndexFungorum;Data Source=webserver"
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
	   dbConn.open strConn
	elseif strIP = "194.203.77.68" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
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
		& "WHERE (((IndexFungorum.[RECORD NUMBER])=" & request.querystring.item("RecordID") & "));"
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
strAddedBy = rs("AddedBy")
strRecentRecord = rs("LAST FIVE YEARS FLAG")

if strRecentRecord = "X" then
	response.write("<a href='http://www.cabi-publishing.org/products/taxonomy/IOF/Index.asp'>This is a recent record: see Index of Fungi</a>")
else
   response.write("<form name='frmIndexFungorumUpdate' method='post' action='../Names/InsertUpdate.asp' onSubmit='return CheckForm();'>")
   response.write("<table width='100%' border='0' cellspacing='0' cellpadding='5'>")
   response.write("<tr>")
   response.write("<td width='15%'>Name</td>")
   response.write("<td width='85%'><input type='text' name='NAMEOFFUNGUS' size='68' maxlength='100' value='" & strn(strNameOfFungus) & "'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Authors</td>")
   response.write("<td width='85%'><input type='text' name='AUTHORS' size='68' maxlength='150' value='" & strn(strAuthors) & "'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Original orthography</td>")
   response.write("<td width='85%'><input type='text' name='ORTHOGRAPHYCOMMENT' size='68' maxlength='70' value='" & strn(strOrthographyComment) & "'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Publishing authors</td>")
   response.write("<td width='85%'><input type='text' name='PUBLISHINGAUTHORS' size='68' maxlength='110' value='" & strn(strPublishingAuthors) & "'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Literature title</td>")
   response.write("<td width='85%'><input type='text' name='PubAcceptedTitle' size='68' maxlength='255' value='" & strn(strPubAcceptedTitle) & "'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Volume</td>")
   response.write("<td width='85%'><input type='text' name='VOLUME' size='68' maxlength='15' value='" & strn(strVolume) & "'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Part</td>")
   response.write("<td width='85%'><input type='text' name='PART' size='68' maxlength='25' value='" & strn(strPart) & "'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Page</td>")
   response.write("<td width='85%'><input type='text' name='PAGE' size='68' maxlength='50' value='" & strn(strPage) & "'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Year of publication</td>")
   response.write("<td width='85%'><input type='text' name='YEAROFPUBLICATION' size='68' maxlength='4' value='" & strn(strYearOfPublication) & "'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Year on publication</td>")
   response.write("<td width='85%'><input type='text' name='YEARONPUBLICATION' size='68' maxlength='15' value='" & strn(strYearOnPublication) & "'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Basionym</td>")
   response.write("<td width='85%'><input type='text' name='SYNONYMY' size='68' maxlength='255' value='" & strn(strSynonymy) & "'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Type substratum</td>")
   response.write("<td width='85%'><input type='text' name='HOST' size='68' maxlength='255' value='" & strn(strHost) & "'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Type locality</td>")
   response.write("<td width='85%'><input type='text' name='LOCATION' size='68' maxlength='75' value='" & strn(strLocation) & "'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Typification details</td>")
   response.write("<td width='85%'><input type='text' name='TYPIFICATIONDETAILS' size='68' maxlength='100' value='" & strn(strTypificationDetails) & "'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Nomenclatural comment</td>")
   response.write("<td width='85%'><input type='text' name='NOMENCLATURALCOMMENT' size='68' maxlength='100' value='" & strn(strNomenclaturalComment) & "'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%' hight='100'>Notes</td>")
   response.write("<td width='85%' hight='100'><textarea name='NOTES' cols='67' rows='6' wrap='virtual'>" & strn(strNotes) & "</textarea></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'>Added by</td>")
   response.write("<td width='85%'><input type='text' name='AddedBy' size='68' maxlength='30' value=''></td>")
   response.write("</tr>")
   response.write("<td width='15%'><input type='submit' name='Submit' value='Submit Changes'></td>")
   response.write("<td width='85%'><input type='hidden' name='RECORDNUMBER' value='" & strn(rs("RECORD NUMBER")) & "'></td>")
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
<!-- InstanceEndEditable --><!-- InstanceBeginEditable name="Main" -->
<%
if request.querystring.count > 0 then
   response.write("<p><h1><font color='#FF0000'>Index Fungorum update form</font></h1></p>")
   DisplayRecord()
else
   response.write("Unexpected error: there are no variables to process?")
end if

   response.write("<p><a href='javascript:history.go(-1)'>back to previous page</a></p>")
%>
<!-- InstanceEndEditable --></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td height="10" class="Footer">
	  <hr noshade>
      &copy; 2008 <a href=javascript:popUp("../Names/IndexFungorumPartnership.htm") onMouseOver="MM_displayStatusMsg('Index Fungorum Partnership');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Index 
      Fungorum Partnership</a>. Return to <a href="../Index.htm" onMouseOver="MM_displayStatusMsg('CABI Bioscience Databases home page');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">main 
      page</a>. Return to <a href="#TopOfPage" onMouseOver="MM_displayStatusMsg('Go to top of page');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">top 
      of page</a>. </td>
  </tr>
</table>
<a name="BottomOfPage"></a>
</body>
<!-- InstanceEnd --></html>
