
<!--#include file="../Helpers/Utility.asp"-->
<%
function TestCaptcha(byval valSession, byval valCaptcha)
	dim tmpSession
	valSession = Trim(valSession)
	valCaptcha = Trim(valCaptcha)
	if (valSession = vbNullString) or (valCaptcha = vbNullString) then
		TestCaptcha = false
	else
		tmpSession = valSession
		valSession = Trim(Session(valSession))
		Session(tmpSession) = vbNullString
		if valSession = vbNullString then
			TestCaptcha = false
		else
			valCaptcha = Replace(valCaptcha,"i","I")
			if StrComp(valSession,valCaptcha,1) = 0 then
				TestCaptcha = true
			else
				TestCaptcha = false
			end if
		end if		
	end if
end function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/templates/TemplIF.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Index Fungorum - Insert NewRecord</title>
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

		' START OF CAPTCHA
		Response.Write("<form id='form1' name='form1' method='post' action=''>")
		Response.Write("<table width='500' border='1' align='center'>")
		Response.Write("<tr>")
		Response.write("<td colspan='2' align='center'>You are ready to register <b><font color='#FF0000'>" & session("strNameOfFungus") & " " & session("strAuthor") & " " & session("strYearOfPublication"))
		Response.write("</font></b><br><br>")
		Response.write("If this is incorrect <a href='javascript:history.go(-1)'>go back to the previous page</a><br><br></td>")
		Response.Write("</tr>")
		Response.Write("<tr>")
		Response.Write("<td width='400'>&nbsp;</td>")
		Response.Write("<td width='100' align='center'>")
		%>
		<img id="imgCaptcha" src="captcha.asp" /><br /><a href="javascript:void(0)" onclick="RefreshImage('imgCaptcha')">Change Image</a>
		<%
		Response.Write("</td>")
		Response.Write("</tr>")
		Response.Write("<tr>")
		Response.Write("<td>&nbsp;Write the characters in the image above&nbsp;</td>")
		Response.Write("<td><input name='captchacode' type='text' id='captchacode' size='10' /></td>")
		Response.Write("</tr>")
		Response.Write("<tr>")
		Response.Write("<td>&nbsp;</td>")
		Response.Write("<td><input type='submit' name='btnTest' id='btnTest' value='Submit' /></td>")
		Response.Write("</tr>")
	' TEST CAPTCHA
	if not IsEmpty(Request.Form("btnTest")) then
		Response.Write("<tr><td colspan=""2"" align=""center"">")
		if TestCaptcha("ASPCAPTCHA", Request.Form("captchacode")) then
			Response.Write("<b style=""color:#00CC33"">The code you enter verified</b>")
			' DEFINE VARIABLES FOR HIDING RECORD UNTIL CHECKED
			strLastFiveYears = "X"
			strSTSflag = "y"
			strDate = right(Left(Now(),10),4) & Mid(Left(Now(),10),4,2) & Left(Left(Now(),10),2)
			' GET THE PUBLICATION TITLE
'			if session("strPubLink") <> "" then
'				Set dbConn = Server.CreateObject("ADODB.Connection")
'				strIP = request.servervariables("LOCAL_ADDR")
'				if strIP = "10.0.3.13" then
'				   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
'				   dbConn.open strConn
'				elseif strIP = "10.0.5.4" then
'				   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
'				   dbConn.open strConn
'				elseif strIP = "192.168.0.3" then
'				   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\indexfungorum\indexfungorumlink.mdb"
'				   dbConn.open strConn
'				elseif strIP = "192.168.0.1" then
'				   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\cabi\cabilink.mdb"
'				   dbConn.open strConn
'				else
'				   dbConn.open "FILEDSN=cabilink"
'				end if
'				intPubLink = session("strPubLink")
'				intPubLink = CLng(intPubLink)
'				strSql = "SELECT tblRegistrationPublications.* FROM tblRegistrationPublications WHERE (((tblRegistrationPublications.pubLink) = " & intPubLink & "));"
'				Set RS = Server.CreateObject("ADODB.Recordset")
'				RS.Open strSql, dbConn, 3
'				session("strPublication") = RS("pubIMIAbbr")
'				RS.close
'				set RS = nothing
'			end if
			' GET THINGS SET UP FOR NEXT STEP
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
			elseif strIP = "192.168.0.3" then
			   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\indexfungorum\indexfungorumlink.mdb"
			   dbConn.open strConn
			elseif strIP = "192.168.0.1" then
			   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\cabi\cabilink.mdb"
			   dbConn.open strConn
			else
			   dbConn.open "FILEDSN=cabilink"
			end if
			' GET AN UNUSED RECORD NUMBER
'			strSQL = "SELECT tblRegistrationNumbers.RegistrationNumber, tblRegistrationNumbers.Used " _
'				& "FROM tblRegistrationNumbers " _
'				& "WHERE (((tblRegistrationNumbers.Used) = '0')) " _
'				& "ORDER BY tblRegistrationNumbers.RegistrationNumber;"
'			Set RS = Server.CreateObject("ADODB.Recordset")
'			RS.Open strSql, dbConn, 3
'       		RS.movefirst
'       		session("strRecordNumber") = (RS("RegistrationNumber"))
'       		RS.close
'       		set RS = nothing
			' FLAG AS USED
'			strSQL = "UPDATE tblRegistrationNumbers SET tblRegistrationNumbers.Used = '1' " _
'				& "WHERE (((tblRegistrationNumbers.RegistrationNumber) = " & session("strRecordNumber") & "));"
'			dbConn.Execute(strSQL)
			' INSERT THE RECORD
	strSQL = "INSERT INTO tblFunindexUpdates ([NAME OF FUNGUS], AUTHORS, [ORTHOGRAPHY COMMENT], [PUBLISHING AUTHORS], " _
		& "PubAcceptedTitle, VOLUME, PART, PAGE, [YEAR OF PUBLICATION], [YEAR ON PUBLICATION], SYNONYMY, " _
		& "HOST, LOCATION, [TYPIFICATION DETAILS], [RECORD NUMBER], [NOMENCLATURAL COMMENT], NOTES, AddedBy)"
	strSQL = strSQL & " VALUES"
	strSQL = strSQL & "('" & protectSQL(strNameOfFungus, false) & "', '" & protectSQL(strAuthors, false) & "', '" & protectSQL(strOrthographyComment, false) & "', '" _
		& " " & protectSQL(strPublishingAuthors, false) & "', '" & protectSQL(strPubAcceptedTitle, false) & "', '" & protectSQL(strVolume, false) & "', '" & protectSQL(strPart, false) & "', '" _
		& " " & protectSQL(strPage, false) & "', '" & protectSQL(strYearOfPublication, false) & "', '" & protectSQL(strYearOnPublication, false) & "', '" & protectSQL(strSynonymy, false) & "', '" _
		& " " & protectSQL(strHost, false) & "', '" & protectSQL(strLocation, false) & "', '" & protectSQL(strTypificationDetails, false) & "', '" & protectSQL(strRecordNumber, false) & "', '" _
		& " " & protectSQL(strNomenclaturalComment, false) & "', '" & protectSQL(strNotes, false) & "', '" & protectSQL(strAddedBy, false) & "');"
			dbConn.Execute(strSQL)
			dbConn.close
			set dbConn = Nothing
'			response.Redirect("../Names/RegisterNameEmailer.asp")
		else
			Response.Write("<b style=""color:#FF0000"">You entered the wrong code - try again</b>")
		end if
		Response.Write("</td></tr>" & vbCrLf)

		response.write("<h3><font color='#FF0000'>Index Fungorum addition/update form</font></h3><br><br>")
		response.write("Thanks for providing this update; your contribution is appreciated and ")
		response.write("will be incorporated in the live database, following review, at the next update.<br><br>")
		response.write("<br>")
		response.write("<form name='thanks' method='post' action='../Names/Names.asp'>")
		response.write("<input type='submit' name='Submit' value='new search'>")
		response.write("</form>")
	end if
		Response.Write("</table>")
		Response.Write("</form>")











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
