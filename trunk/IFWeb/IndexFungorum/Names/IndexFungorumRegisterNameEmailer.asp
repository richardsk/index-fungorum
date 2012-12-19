<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum - Registered Name Emailer</title>
<meta http-equiv="Content-Type" content="text/html; charset=charset=utf-8">
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
	dim strNameOfFungus, strAuthor, strPublishingAuthors, strPublication, strVolume, strPart
	dim strPage, strYearOfPublication, strYearOnPublication, strTypificationDetails, strEmail
	dim strSynonymy, strHost, strNotes, strRecordNumber, strPubLink, dbConn, strIP, strConn
	dim strNameDetails, strPublicationDetails, strOtherDetails, objEmail, strData, strSQL, RS

	strNameDetails = Session("strNameOfFungus") & " " & Session("strAuthor") & " " & Session("strYearOfPublication") & ")"
	strNameDetails = replace(strNameDetails,"  "," ")
	strNameDetails = replace(strNameDetails,"  "," ")
	strNameDetails = replace(strNameDetails,"  "," ")

	if Session("strPublication") <> "" then
		strPublicationDetails = Session("strPublication")
	else
		strPublicationDetails = Session("strOtherPublication")
	end if

	if Session("strVolume") <> "" then
		strPublicationDetails = strPublicationDetails &  " " & Session("strVolume")
	else
		strPublicationDetails = strPublicationDetails & " [no volume]"
	end if
	
	if Session("strPart") <> "" then
		strPublicationDetails = strPublicationDetails & "(" & Session("strPart") & "): " & Session("strPage")
	else
		strPublicationDetails = strPublicationDetails & ": " & Session("strPage")
	end if
	strPublicationDetails = replace(strPublicationDetails,"  "," ")
	strPublicationDetails = replace(strPublicationDetails,"  "," ")
	strPublicationDetails = replace(strPublicationDetails,"  "," ")

	Set objEmail = CreateObject("CDO.Message")
	objEmail.From = "p.kirk@cabi.org"
	objEmail.To = session("strEmail")
	objEmail.Cc = "p.kirk@cabi.org"
' compose email body depending on act type
if Session("strActType") = "New typification" then  
	if Session("strTypificationType") = "lectotype" then strData = "lectotypification"
	if Session("strTypificationType") = "neotype" then strData = "neotypification"
	if Session("strTypificationType") = "epitype" then strData = "epitypification"
	objEmail.Subject = "Name " & strData & " for: " & Session("strTypifiedName") & " (IF" & Session("intRecordNumber") & ")"
	Body = "Name " & strData & " details" & vbCrLf & vbCrLf
	Body = Body & "Name details: " & Session("strTypifiedName") & vbCrLf & vbCrLf & vbCrLf
	Body = Body & "Publication details: " & strPublicationDetails & vbCrLf & vbCrLf & vbCrLf
	if Session("strTypificationDetails") <> "" then
		Body = Body & "Typification: " & Session("strTypificationDetails") & vbCrLf & vbCrLf
	end if
	if Session("strNotes") <> "" then
		Body = Body & "Notes: " & Session("strNotes")
	end if
else
	objEmail.Subject = "Name registration: " & Session("strNameOfFungus") & " (IF" & Session("intRecordNumber") & ")"
	Body = "Registration details" & vbCrLf & vbCrLf
	Body = Body & "Name Registered: " & strNameDetails & vbCrLf & vbCrLf
	Body = Body & "Publication details: " & strPublicationDetails & vbCrLf & vbCrLf
	if Session("strHost") <> "" then
		Body = Body & "Host/substratum details: " & Session("strHost") & vbCrLf & vbCrLf
	end if
	if Session("strLocation") <> "" then
		Body = Body & vbCrLf & "Type locality: " & Session("strLocation") & vbCrLf & vbCrLf
	end if
	if Session("strTypificationDetails") <> "" then
		Body = Body & "Typification: " & Session("strTypificationDetails") & vbCrLf & vbCrLf
	end if
	if Session("strNotes") <> "" then
		Body = Body & "Notes: " & Session("strNotes")
	end if
end if
'	Body = Body & strOtherDetails & vbCrLf
'	objEmail.HTMLBody = Body
	objEmail.TextBody = Body
	objEmail.Send
	Set objEmail = Nothing

		Response.Write("<table width='400' border='1' align='center'>")
		Response.Write("<tr><td colspan=""2"" align=""center"">")
		Response.write("<h3><font color='#FF0000'>Index Fungorum name registration system</font></h3>")
	if Session("strActType") = "New typification" then 
		Response.write("Thank you for registering a <b><font color='#0000FF'>" & Session("strTypificationType") & " for " &  Session("strTypifiedName") & "</font>")
	else
		Response.write("Thank you for registering <b><font color='#0000FF'>" & Session("strNameOfFungus") & " " & Session("strAuthor") & " " & Session("strYearOfPublication") & "</font>")
	end if
		Response.write("</b>; an email will be sent containing the IF identifer and details of the registered name.&nbsp;")
		Response.write("</b>This name will be incorporated in the live database following effective publication -&nbsp;")
		Response.write("please reply to this email, adding relevant details, as soon as you are aware that this has happened.<br><br>")
		Response.write("<a href='../Names/IndexFungorumRegisterName.asp'>register another name</a>")
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
