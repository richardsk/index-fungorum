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
<title>Index Fungorum - InsertRegisteredName</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
<!--#include file="../Connections/DataAccess.asp"-->
<script language="JavaScript">
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=700,height=495,left=100,top=00');");
}
function MM_displayStatusMsg(msgStr) { //v1.0
  status=msgStr;
  document.MM_returnValue = true;
}
function RefreshImage(valImageId) {
	var objImage = document.images[valImageId];
	if (objImage == undefined) {
		return;
	}
	var now = new Date();
	objImage.src = objImage.src.split('?')[0] + '?x=' + now.toUTCString();
}
</script>
</head>
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<table width="100%" height="100%" class="mainbody">
  <tr> 
    <td height="105"> <table width="100%" border="0" class="mainbody">
        <tr> 
          <td class="h1"><img src="../IMAGES/LogoIF.gif" alt="Index Fungorum" width="100" height="100">Index&nbsp;Fungorum 
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
          <td valign="top">&nbsp;</td>
          <td valign="top">
		  </td>
        </tr>
        <tr> 
          <td valign="top">
<%
	dim strNameOfFungus, strAuthor, strPublishingAuthors, strPubLink, strVolume, strPart
	dim strPage, strYearOfPublication, strYearOnPublication, strTypificationDetails, strEmail
	dim strSynonymy, strHost, strLocation, strNotes, strRecordNumber, strPublication
	dim RS, StrSQL, intPubLink, strDate
	strNameOfFungus = session("strNameOfFungus")
		if strNameOfFungus <> "" then
			strNameOfFungus = strNameOfFungus
		else
			session("strNameOfFungus") = replace(Request.Form("NameOfFungus"),"'","")
		end if
	strAuthor = session("strAuthor")
		if strAuthor <> "" then
			strAuthor = strAuthor
		else
			session("strAuthor") = replace(Request.Form("Author"),"'","")
		end if
	strPublishingAuthors = session("strPublishingAuthors")
		if strPublishingAuthors <> "" then
			strPublishingAuthors = strPublishingAuthors
		else
			session("strPublishingAuthors") = replace(Request.Form("PublishingAuthors"),"'","")
		end if
	strPubLink = session("strPubLink")
		if strPubLink <> "" then
			strPubLink = strPubLink
		else
			session("strPubLink") = replace(Request.Form("PubLink"),"'","")
		end if
	strVolume = session("strVolume")
		if strVolume <> "" then
			strVolume = strVolume
		else
			session("strVolume") = replace(Request.Form("Volume"),"'","")
		end if
	strPart = session("strPart")
		if strPart <> "" then
			strPart = strPart
		else
			session("strPart") = replace(Request.Form("Part"),"'","")
		end if
	strPage = session("strPage")
		if strPage <> "" then
			strPage = strPage
		else
			session("strPage") = replace(Request.Form("Page"),"'","")
		end if
	strYearOfPublication = session("strYearOfPublication")
		if strYearOfPublication <> "" then
			strYearOfPublication = strYearOfPublication
		else
			session("strYearOfPublication") = replace(Request.Form("YearOfPublication"),"'","")
		end if
	strYearOnPublication = session("strYearOnPublication")
		if strYearOnPublication <> "" then
			strYearOnPublication = strYearOnPublication
		else
			session("strYearOnPublication") = replace(Request.Form("YearOnPublication"),"'","")
		end if
	strSynonymy = session("strSynonymy")
		if strSynonymy <> "" then
			strSynonymy = strSynonymy
		else
			session("strSynonymy") = replace(Request.Form("Synonymy"),"'","")
		end if
	strHost = session("strHost")
		if strHost <> "" then
			strHost = strHost
		else
			session("strHost") = replace(Request.Form("Host"),"'","")
		end if
	strLocation = session("strLocation")
		if strLocation <> "" then
			strLocation = strLocation
		else
			session("strLocation") = replace(Request.Form("Location"),"'","")
		end if
	strTypificationDetails = session("strTypificationDetails")
		if strTypificationDetails <> "" then
			strTypificationDetails = strTypificationDetails
		else
			session("strTypificationDetails") = replace(Request.Form("TypificationDetails"),"'","")
		end if
	strNotes = session("strNotes")
		if strNotes <> "" then
			strNotes = strNotes
		else
			session("strNotes") = replace(Request.Form("Notes"),"'","")
		end if
	strEmail = session("strEmail")
		if strEmail <> "" then
			strEmail = strEmail
		else
			session("strEmail") = replace(Request.Form("Email"),"'","")
		end if
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
			if session("strPubLink") <> "" then
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
				intPubLink = session("strPubLink")
				intPubLink = CLng(intPubLink)
				strSql = "SELECT tblRegistrationPublications.* FROM tblRegistrationPublications WHERE (((tblRegistrationPublications.pubLink) = " & protectSQL(intPubLink,true) & "));"
				Set RS = Server.CreateObject("ADODB.Recordset")
				RS.Open strSql, dbConn, 3
				session("strPublication") = RS("pubIMIAbbr")
				RS.close
				set RS = nothing
			end if
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
			strSQL = "SELECT tblRegistrationNumbers.RegistrationNumber, tblRegistrationNumbers.Used " _
				& "FROM tblRegistrationNumbers " _
				& "WHERE (((tblRegistrationNumbers.Used) = '0')) " _
				& "ORDER BY tblRegistrationNumbers.RegistrationNumber;"
			Set RS = Server.CreateObject("ADODB.Recordset")
			RS.Open strSql, dbConn, 3
       		RS.movefirst
       		session("strRecordNumber") = (RS("RegistrationNumber"))
       		RS.close
       		set RS = nothing
			' FLAG AS USED
			strSQL = "UPDATE tblRegistrationNumbers SET tblRegistrationNumbers.Used = '1' " _
				& "WHERE (((tblRegistrationNumbers.RegistrationNumber) = " & protectSQL(session("strRecordNumber"),true) & "));"
			dbConn.Execute(strSQL)
			' INSERT THE RECORD
			strSQL = "INSERT INTO IndexFungorum ([NAME OF FUNGUS], AUTHORS, [PUBLISHING AUTHORS], " _
				& "[LITERATURE LINK], VOLUME, PART, PAGE, " _
				& "[YEAR OF PUBLICATION], [YEAR ON PUBLICATION], SYNONYMY, " _
				& "HOST, LOCATION, [TYPIFICATION DETAILS], [RECORD NUMBER], " _
				& "NOTES, [LAST FIVE YEARS FLAG], [STS FLAG], AddedDate, AddedBy)"
			strSQL = strSQL & " VALUES"
			strSQL = strSQL & "('" & protectSQL(session("strNameOfFungus"), false) & "', '" & protectSQL(session("strAuthor"), false) & "', '" & protectSQL(session("strPublishingAuthors"), false) & "', '" _
				& protectSQL(session("strPubLink"), false) & "', '" & protectSQL(session("strVolume"), false) & "', '" & protectSQL(session("strPart"), false) & "', '" & protectSQL(session("strPage"), false) & "', '" _
				& protectSQL(session("strYearOfPublication"), false) & "', '" & protectSQL(session("strYearOnPublication"), false) & "', '" & protectSQL(session("strSynonymy"), false) & "', '" _
				& protectSQL(session("strHost"), false) & "', '" & protectSQL(session("strLocation"), false) & "', '" & protectSQL(session("strTypificationDetails"), false) & "', '" & protectSQL(session("strRecordNumber"), false) & "', '" _
				& protectSQL(session("strNotes"), false) & "', '" & protectSQL(strLastFiveYears, false) & "', '" & protectSQL(strSTSflag, false) & "', '" & protectSQL(strDate, false) & "', 'Registered by: " & protectSQL(session("strEmail"), false) & "');"
			dbConn.Execute(strSQL)
			dbConn.close
			set dbConn = Nothing
			response.Redirect("../Names/RegisterNameEmailer.asp")
		else
			Response.Write("<b style=""color:#FF0000"">You entered the wrong code - try again</b>")
		end if
		Response.Write("</td></tr>" & vbCrLf)
	end if
		Response.Write("</table>")
		Response.Write("</form>")
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
    <td height="10" class="Footer"> <hr noshade> &copy; 2010 <a href=javascript:popUp("../Names/IndexFungorumPartnership.htm") onMouseOver="MM_displayStatusMsg('Index Fungorum Partnership');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Index 
      Fungorum Partnership</a></td>
  </tr>
</table>
</body>
</html>
