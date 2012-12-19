<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/templates/TemplIF.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Index Fungorum - Insert update</title>
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
<!--#include file="../Connections/DataAccess.asp"-->
<!--#include file="../Helpers/Utility.asp"-->
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
                  with searching</a> : <font color="#FF0000"><strong><a href="javascript:popUp("IndexFungorumCookies.htm")"IndexFungorumCookies.htm")" target="_blank">Cookies</a></strong></font></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="AuthorsOfFungalNames.asp" onMouseOver="MM_displayStatusMsg('Search Authors of Fungal Names');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Authors of Fungal Names</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="Names.asp" onMouseOver="MM_displayStatusMsg('Search Index Fungorum');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Index Fungorum</a></td>
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
<!-- InstanceEndEditable --><!-- InstanceBeginEditable name="Main" -->
<%	
strNameOfFungus = replace(Request.Form("NAMEOFFUNGUS"),"'","")
strAuthors = replace(Request.Form("AUTHORS"),"'","")
strOrthographyComment = replace(Request.Form("ORTHOGRAPHYCOMMENT"),"'","")
strPublishingAuthors = replace(Request.Form("PUBLISHINGAUTHORS"),"'","")
strPubAcceptedTitle = replace(Request.Form("PubAcceptedTitle"),"'","")
strVolume = replace(Request.Form("VOLUME"),"'","")
strPart = replace(Request.Form("PART"),"'","")
strPage = replace(Request.Form("PAGE"),"'","")
strYearOfPublication = replace(Request.Form("YEAROFPUBLICATION"),"'","")
strYearOnPublication = replace(Request.Form("YEARONPUBLICATION"),"'","")
strSynonymy = replace(Request.Form("SYNONYMY"),"'","")
strHost = replace(Request.Form("HOST"),"'","")
strLocation = replace(Request.Form("LOCATION"),"'","")
strTypificationDetails = replace(Request.Form("TYPIFICATIONDETAILS"),"'","")
strNomenclaturalComment = replace(Request.Form("NOMENCLATURALCOMMENT"),"'","")
strNotes = replace(Request.Form("NOTES"),"'","")
strAddedBy = replace(Request.Form("AddedBy"),"'","")
strRecordNumber = replace(Request.Form("RECORDNUMBER"),"'","")

	Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
	if true then        
       strConn = GetConnectionString()
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "10.0.3.13" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
	   dbConn.open strConn
	elseif strIP = "194.203.77.78" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_INDEXFUNGORUM;Initial Catalog=IndexFungorum;Data Source=INDEXFUNGORUM"
	   dbConn.open strConn
	elseif strIP = "192.168.0.3" then
	   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\indexfungorum\indexfungorumlink.mdb"
	   dbConn.open strConn
	elseif strIP = "192.168.0.1" then
	   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\cabi\cabilink.mdb"
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=cabilink"
	end if
	strSQL = "INSERT INTO tblFunindexUpdates ([NAME OF FUNGUS], AUTHORS, [ORTHOGRAPHY COMMENT], [PUBLISHING AUTHORS], " _
		& "PubAcceptedTitle, VOLUME, PART, PAGE, [YEAR OF PUBLICATION], [YEAR ON PUBLICATION], SYNONYMY, " _
		& "HOST, LOCATION, [TYPIFICATION DETAILS], [RECORD NUMBER], [NOMENCLATURAL COMMENT], NOTES, AddedBy)"
	strSQL = strSQL & " VALUES"
	strSQL = strSQL & "('" & protectSQL(strNameOfFungus, false) & "', '" & protectSQL(strAuthors, false) & "', '" & protectSQL(strOrthographyComment, false) & "', '" _
		& " " & protectSQL(strPublishingAuthors, false) & "', '" & protectSQL(strPubAcceptedTitle, false) & "', '" & protectSQL(strVolume, false) & "', '" & protectSQL(strPart, false) & "', '" _
		& " " & protectSQL(strPage, false) & "', '" & protectSQL(strYearOfPublication, false) & "', '" & protectSQL(strYearOnPublication, false) & "', '" & protectSQL(strSynonymy, false) & "', '" _
		& " " & protectSQL(strHost, false) & "', '" & protectSQL(strLocation, false) & "', '" & protectSQL(strTypificationDetails, false) & "', '" & protectSQL(strRecordNumber, false) & "', '" _
		& " " & protectSQL(strNomenclaturalComment, false) & "', '" & protectSQL(strNotes, false) & "', '" & protectSQL(strAddedBy, false) & "');"

'Write to the database
	dbConn.Execute(strSQL)

'Close connection
	Set dbConn = Nothing

	response.write("<h3><font color='#FF0000'>Index Fungorum addition/update form</font></h3><br><br>")
	response.write("Thanks for providing this update; your contribution is appreciated and ")
	response.write("will be incorporated in the live database, following review, at the next update.<br><br>")
	response.write("<br>")
	response.write("<form name='thanks' method='post' action='../Names/Names.asp'>")
	response.write("<input type='submit' name='Submit' value='new search'>")
	response.write("</form>")

function quote(str)
' function to remove single quotes from string and replace with unicode character

end function
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
