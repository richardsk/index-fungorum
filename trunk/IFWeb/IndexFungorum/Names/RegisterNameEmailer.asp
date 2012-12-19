<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum - RegisteredNameEmailer</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=700,height=495,left=100,top=00');");
}
function MM_displayStatusMsg(msgStr) { //v1.0
  status=msgStr;
  document.MM_returnValue = true;
}
</script>
</head>
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<table width="100%" height="100%" class="mainbody">
  <tr> 
    <td height="105"> <table width="100%" border="0" class="mainbody">
        <tr> 
          <td class="h1"><img src="../IMAGES/LogoIF.gif" alt="Index Fungorum" width="100" height="100">Index&nbsp;Fungorum&nbsp; 
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
	dim strNameOfFungus, strAuthor, strPublishingAuthors, strPublication, strVolume, strPart
	dim strPage, strYearOfPublication, strYearOnPublication, strTypificationDetails, strEmail
	dim strSynonymy, strHost, strNotes, strRecordNumber, strPubLink
	dim strNameDetails, strPublicationDetails, strOtherDetails, objEmail

	strNameDetails = session("strNameOfFungus") & " " & session("strAuthor") & " " & session("strYearOfPublication") & " (IF" & session("strRecordNumber") & ")"
	strNameDetails = replace(strNameDetails,"  "," ")
	strNameDetails = replace(strNameDetails,"  "," ")
	strNameDetails = replace(strNameDetails,"  "," ")

	if session("strPublication") <> "" then
		strPublicationDetails = session("strPublication")
	else
		strPublicationDetails = "[Publication not in list]"
	end if
	
	if session("strVolume") <> "" then
		strPublicationDetails = strPublicationDetails &  " " & session("strVolume")
	else
		strPublicationDetails = strPublicationDetails & ":"
	end if
	
	if session("strPart") <> "" then
		strPublicationDetails = strPublicationDetails & "(" & session("strPart") & "): " & session("strPage")
	else
		strPublicationDetails = strPublicationDetails & ": " & session("strPage")
	end if
	strPublicationDetails = replace(strPublicationDetails,"  "," ")
	strPublicationDetails = replace(strPublicationDetails,"  "," ")
	strPublicationDetails = replace(strPublicationDetails,"  "," ")

	Set objEmail = CreateObject("CDO.Message")
	objEmail.From = "p.kirk@cabi.org"
	objEmail.To = session("strEmail")
	objEmail.Cc = "p.kirk@cabi.org"
'	objEmail.Cc = "kerstin.voigt@uni-jena.de"
	objEmail.Subject = "Name registration: " & session("strNameOfFungus") & " (IF" & session("strRecordNumber") & ")"
	Body = "Registration details" & vbCrLf & vbCrLf
	Body = Body & "Name Registered: " & strNameDetails & vbCrLf & vbCrLf
	Body = Body & "Publication details: " & strPublicationDetails & vbCrLf
	if session("strHost") <> "" then
		Body = Body & "Host/substratum details: " & session("strHost") & vbCrLf
	end if
	if session("strLocation") <> "" then
		Body = Body & vbCrLf & "Type locality: " & session("strLocation") & vbCrLf
	end if
	Body = Body & "Typification: " & session("strTypificationDetails") & vbCrLf & vbCrLf
	if session("strNotes") <> "" then
		Body = Body & "Notes: " & session("strNotes")
	end if
'	Body = Body & strOtherDetails & vbCrLf
'	objEmail.HTMLBody = Body
	objEmail.TextBody = Body
	objEmail.Send
	Set objEmail = Nothing

		Response.Write("<table width='400' border='1' align='center'>")
		Response.Write("<tr><td colspan=""2"" align=""center"">")
		Response.write("<h3><font color='#FF0000'>Index Fungorum name registration system</font></h3>")
		Response.write("Thanks for registering <b><font color='#0000FF'>" & session("strNameOfFungus") & " " & session("strAuthor") & " " & session("strYearOfPublication") & "</font>&nbsp;(IF" & session("strRecordNumber") & ")")
		Response.write("</b>; your contribution will be reviewed and ")
'		Response.write("will be incorporated in the live database at the next update" & Date() & " date<br><br>")
		Response.write("will be incorporated in the live database at the next update<br><br>")
		Response.write("<a href='http://www.indexfungorum.org/Names/IndexFungorumRegistration.asp'>register another name</a>")
		'Clear the session
		Session.Abandon
		Response.Write("</td></tr>" & vbCrLf)
		Response.Write("</table>")
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
