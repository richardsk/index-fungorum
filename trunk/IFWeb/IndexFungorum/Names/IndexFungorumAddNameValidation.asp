<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum - Add Name Validation</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
<!--#include file="../Connections/DataAccess.asp"-->
<!--#include file="../Helpers/Utility.asp"-->
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
	dim strNameOfFungus, strAuthor, strPublishingAuthors, intPubLink, strVolume, strPart
	dim strPage, strYearOfPublication, strYearOnPublication, strTypificationDetails, strEmail
	dim strBasionym, strHost, strLocation, strNotes, intRecordNumber, strPublication
	dim strDate, strDiagnosis, strOtherPublication, strData, strOrthographyComment

'add content of all form elements to session variables
Session("strNameOfFungus") = replace(Request.Form("NameOfFungus"),"'","")
Session("strAuthor") = replace(Request.Form("Author"),"'","")
Session("strOrthographyComment") = replace(Request.Form("OrthographyComment"),"'","")
Session("strPublishingAuthors") = replace(Request.Form("PublishingAuthors"),"'","")
Session("intPubLink") = Request.Form("PubLink")
Session("strOtherPublication") = Request.Form("OtherPublication")
Session("strVolume") = Request.Form("Volume")
Session("strPage") = Request.Form("Page")
Session("strYearOfPublication") = Request.Form("YearOfPublication")
Session("strYearOnPublication") = Request.Form("YearOnPublication")
Session("strHost") = Request.Form("Host")
Session("strLocation") = Request.Form("Location")
Session("strBasionym") = Request.Form("Basionym")
Session("strTypificationDetails") = Request.Form("TypificationDetails")
Session("strNotes") = Request.Form("Notes")
Session("strEmail") = Request.Form("Email")

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

'data validation
	strNameOfFungus = Request.Form("NameOfFungus")
		if strNameOfFungus <> "" then
			Response.write("The name is:&nbsp;<b>" & Request.Form("NameOfFungus") & "</b><br>")
		else
			Response.write("The name is missing:&nbsp;<a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
			Session("strNameOfFungus") = replace(Request.Form("NameOfFungus"),"'","")
		end if

	strAuthor = Request.Form("Author")
		if strAuthor <> "" then
			Response.write("The author(s) is:&nbsp;<b>" & Request.Form("Author") & "</b><br>")
		else
			Response.write("The author(s) of the name is missing:&nbsp;<a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
			Session("strPublishingAuthors") = replace(Request.Form("PublishingAuthors"),"'","")
		end if

	strOrthographyComment = Request.Form("OrthographyComment")
		if strOrthographyComment <> "" then
			Response.write("The original orthography is:&nbsp;<b>" & Request.Form("OrthographyComment") & "</b><br>")
		else
			Session("strOrthographyComment") = replace(Request.Form("OrthographyComment"),"'","")
		end if

	strPublishingAuthors = Request.Form("PublishingAuthors")
		if strPublishingAuthors <> "" then
			Response.write("The publishing authors are:&nbsp;<b>" & Request.Form("PublishingAuthors") & "</b><br>")
		else
			Session("strPublishingAuthors") = replace(Request.Form("PublishingAuthors"),"'","")
		end if

	intPubLink = Request.Form("PubLink")
	strOtherPublication = Request.Form("OtherPublication")
		if intPubLink <> "" then
			intPubLink = Request.Form("PubLink")
			intPubLink = CLng(intPubLink)
			strSql = "SELECT tblRegistrationPublications.* FROM tblRegistrationPublications WHERE (((tblRegistrationPublications.pubLink) = " & protectSQL(intPubLink, true) & "));"
			Set RS = Server.CreateObject("ADODB.Recordset")
			RS.Open strSql, dbConn, 3
			strPublication = RS("pubIMIAbbr")
			RS.close
			set RS = nothing
			Response.write("The journal or book title is:&nbsp;<b>" & strPublication & "</b><br>")
			intPubLink = intPubLink
		else
			if strOtherPublication <> "" then
				Response.write("The journal or book title is:&nbsp;<b>" & Request.Form("OtherPublication") & "</b><br>")
			else
				Response.write("A journal or book title from the list must be selected <b>OR</b> details of the journal or book must be entered&nbsp;")
				Response.write("to indicate where the name has been published:&nbsp<a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
				Session("strPubLink") = replace(Request.Form("PubLink"),"'","")
			end if
		end if

	strVolume = Request.Form("Volume")
		if strVolume <> "" then
			Response.write("The volume is:&nbsp;<b>" & Request.Form("Volume") & "</b><br>")
		else
			Session("strVolume") = replace(Request.Form("Volume"),"'","")
		end if

	strPart = Request.Form("Part")
		if strPart <> "" then
			Response.write("The part is:&nbsp;<b>" & Request.Form("Part") & "</b><br>")
		else
			Session("strPart") = replace(Request.Form("Part"),"'","")
		end if

	strPage = Request.Form("Page")
		if strPage <> "" then
			Response.write("The page is:&nbsp;<b>" & Request.Form("Page") & "</b><br>")
		else
			Response.write("The page or plate number the name is published on is missing:&nbsp;")
			Response.write("<a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
			Session("strPart") = replace(Request.Form("Part"),"'","")
		end if
	strYearOfPublication = Request.Form("YearOfPublication")
		if strYearOfPublication <> "" then
			Response.write("The year is:&nbsp;<b>" & Request.Form("YearOfPublication") & "</b><br>")
		else
			Response.write("The year the name is published is missing:&nbsp;")
			Response.write("<a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
			Session("strYearOfPublication") = replace(Request.Form("YearOfPublication"),"'","")
		end if
	strYearOnPublication = Request.Form("YearOnPublication")
		if strYearOnPublication <> "" then
			Response.write("The year appearing on the publication will be:&nbsp;<b>" & Request.Form("YearOnPublication") & "</b><br>")
		else
			Session("strYearOnPublication") = replace(Request.Form("YearOnPublication"),"'","")
		end if
	strBasionym = Request.Form("Basionym")
		if strBasionym <> "" then
			Response.write("The basionym is:&nbsp;<b>" & Request.Form("Basionym") & "</b><br>")
		else
			Session("strBasionym") = replace(Request.Form("Basionym"),"'","")
		end if
	strHost = Request.Form("Host")
		if strHost <> "" then
			Response.write("The host, associated organism or ecosystem where the type was collected is:&nbsp;<b>" & Request.Form("Host") & "</b><br>")
		else
			Session("strHost") = replace(Request.Form("Host"),"'","")
		end if
	strLocation = Request.Form("Location")
		if strLocation <> "" then
			Response.write("The origin of the type is:&nbsp;<b>" & Request.Form("Location") & "</b><br>")
		else
			Session("strLocation") = replace(Request.Form("Location"),"'","")
		end if
	strTypificationDetails = Request.Form("TypificationDetails")
		if strTypificationDetails <> "" then
			Response.write("The typification details are:&nbsp;<b>" & Request.Form("TypificationDetails") & "</b><br>")
		else
			Session("strTypificationDetails") = replace(Request.Form("TypificationDetails"),"'","")
		end if
	strNotes = Request.Form("Notes")
		if strNotes <> "" then
			Response.write("These notes are included:&nbsp;<b>" & Request.Form("Notes") & "</b><br>")
		else
			Session("strNotes") = replace(Request.Form("Notes"),"'","")
		end if
	strEmail = Request.Form("Email")
		if strEmail <> "" then
			Response.write("Your email is:&nbsp;<b>" & Request.Form("Email") & "</b><br>")
		else
			Response.write("Your email address is missing; if there are queries about the name and you cannot be contacted&nbsp;")
			Response.write("the name may not be added or may remain hidden pending verification:&nbsp;<a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
			Session("strEmail") = replace(Request.Form("Email"),"'","")
		end if
	dbConn.close
	set dbConn = nothing

Response.write("Are you ready to <a href='IndexFungorumAddInsertAddition.asp'>add this name</a>&nbsp;or do you want to&nbsp;<a href='javascript:history.go(-1)'>go back to the previous page</a>&nbsp;and make changes or additions<br>")
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
