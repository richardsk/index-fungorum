<?xml version="1.0" encoding="iso-8859-1"?><%@LANGUAGE="VBSCRIPT"%>
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
<html>
<head>
<title>Index Fungorum - Insert update</title>
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
<script language="javascript">
function RefreshImage(valImageId) {
	var objImage = document.images[valImageId];
	if (objImage == undefined) {
		return;
	}
	var now = new Date();
	objImage.src = objImage.src.split('?')[0] + '?x=' + now.toUTCString();
}
</script>
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
</head>
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<a name="TopOfPage"></a> 
<table width="100%" height="100%" class="mainbody">
  <tr> 
    <td height="105"> <table width="100%" border="0" class="mainbody">
        <tr> 
          <td width="50%" class="h1"> <img src="../IMAGES/LogoIF.gif" alt="Index Fungorum - Species Fungorum" width="100" height="100">Index&nbsp;Fungorum</td>
          <td valign="top">&nbsp;</td>
        </tr>
        <tr> 
          <td colspan="2"><hr noshade></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="100%" cellpadding="5">
        <tr> 
          <td valign="top">&nbsp;</td>
          <td valign="top">
		  </td>
        </tr>
        <tr> 
          <td valign="top">
<%
sub GetData()
	dim strNameOfFungus, strAuthors, strPublishingAuthors, strPubAcceptedTitle, strVolume, strPart
	dim strPage, strYearOfPublication, strYearOnPublication, strTypificationDetails, strAddedBy
	strNameOfFungus = replace(Request.Form("NameOfFungus"),"'","")
	strAuthors = replace(Request.Form("Author"),"'","")
	strPublishingAuthors = replace(Request.Form("PublishingAuthors"),"'","")
	strPubAcceptedTitle = replace(Request.Form("PubAcceptedTitle"),"'","")
	strVolume = replace(Request.Form("Volume"),"'","")
	strPart = replace(Request.Form("Part"),"'","")
	strPage = replace(Request.Form("Page"),"'","")
	strYearOfPublication = replace(Request.Form("YearOfPublication"),"'","")
	strYearOnPublication = replace(Request.Form("YearOnPublication"),"'","")
	strSynonymy = replace(Request.Form("Synonymy"),"'","")
	strHost = replace(Request.Form("Host"),"'","")
	strLocation = replace(Request.Form("Location"),"'","")
	strTypificationDetails = replace(Request.Form("TypificationDetails"),"'","")
	
	' still to sort out record number
	strRecordNumber = replace(Request.Form("RecordNumber"),"'","")
	strNotes = replace(Request.Form("Notes"),"'","")
	strAddedBy = replace(Request.Form("email"),"'","")
	strLastFiveYears = "X"
	strSTSflag = "y"

response.write(strNameOfFungus & "&nbsp;is the name<br>")
response.write(strAuthors & "&nbsp;is the author<br>")
response.write(strYearOfPublication & "&nbsp;is the year<br>")
response.write(strAddedBy & "&nbsp;is the email<br>")


end sub


%>
<form id="form1" name="form1" method="post" action="">
  <table width="400" border="1" align="center">
    <tr>
      <td colspan="2" align="center"><strong>CAPTCHA Example</strong></td>
    </tr>
    <tr>
      <td width="261">CAPTCHA Image</td>
      <td width="123"><img id="imgCaptcha" src="captcha.asp" /><br /><a href="javascript:void(0)" onclick="RefreshImage('imgCaptcha')">Change Image</a></td>
    </tr>
    <tr>
      <td>Write the characters in the image above</td>
      <td><input name="captchacode" type="text" id="captchacode" size="10" /></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td><input type="submit" name="btnTest" id="btnTest" value="Test Input" /></td>
    </tr>
    <%
	if not IsEmpty(Request.Form("btnTest")) then
		Response.Write("<tr><td colspan=""2"" align=""center"">")

		if TestCaptcha("ASPCAPTCHA", Request.Form("captchacode")) then
			Response.Write("<b style=""color:#00CC33"">The code you enter verified.</b>")
	




strNameOfFungus = "test"



		Set dbConn = Server.CreateObject("ADODB.Connection")
		strIP = request.servervariables("LOCAL_ADDR")
		if strIP = "10.0.3.13" then
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
		strSQL = strSQL & "('" & strNameOfFungus & "', '" & strAuthors & "', '" & strOrthographyComment & "', '" _
			& " " & strPublishingAuthors & "', '" & strPubAcceptedTitle & "', '" & strVolume & "', '" & strPart & "', '" _
			& " " & strPage & "', '" & strYearOfPublication & "', '" & strYearOnPublication & "', '" & strSynonymy & "', '" _
			& " " & strHost & "', '" & strLocation & "', '" & strTypificationDetails & "', '" & strRecordNumber & "', '" _
			& " " & strNomenclaturalComment & "', '" & strNotes & "', '" & strAddedBy & "');"
	
		'Write to the database
		dbConn.Execute(strSQL)
	
		'Close connection
		Set dbConn = Nothing
	
		response.write("<h3><font color='#FF0000'>Index Fungorum name registration system</font></h3><br><br>")
		response.write("Thanks for registering this name; your contribution will be reviewed and ")
		response.write("will be incorporated in the live database at the next update.<br><br>")
		response.write("<br>")
		response.write("<form name='thanks1' method='post' action='http://backup.indexfungorum.org/Names/IndexFungorumRegistration.asp'>")
		response.write("<input type='submit' name='Submit' value='register another name'>")
		response.write("<br>")
		response.write("<form name='thanks2' method='post' action='../Names/Names.asp'>")
		response.write("<input type='submit' name='Submit' value='search for a name'>")
		response.write("</form>")


		else
			Response.Write("<b style=""color:#FF0000"">You entered the wrong code.</b>")
		end if
		Response.Write("</td></tr>" & vbCrLf)
	end if
	%>
  </table>
</form>

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
    <td height="10" class="Footer"> <hr noshade> &copy; 2008 <a href=javascript:popUp("../Names/IndexFungorumPartnership.htm") onMouseOver="MM_displayStatusMsg('Index Fungorum Partnership');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Index 
      Fungorum Partnership</a>. Return to <a href="../Index.htm" onMouseOver="MM_displayStatusMsg('CABI Bioscience Databases home page');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">main 
      page</a>. Return to <a href="#TopOfPage" onMouseOver="MM_displayStatusMsg('Go to top of page');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">top 
      of page</a>. </td>
  </tr>
</table>
<a name="BottomOfPage"></a> 
</body>
</html>
