<%
If Session("loggedin") <> True Then Response.Redirect "login.asp"
strUsername = request.cookies("UserName")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum - Preview Name</title>
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
</script>
<script type="text/javascript">
var d = new Date();
var curr_year = d.getFullYear();
</script>
</head>
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<%
	dim strNameOfFungus, strAuthor, strPublishingAuthors, strPublication, strVolume, strPart
	dim strPage, strYearOfPublication, strYearOnPublication, strTypificationDetails, strEmail
	dim strSynonymy, strHost, strNotes, strRecordNumber, strPubLink, strOtherPublication, strTemp
	dim strNameDetails, strPublicationDetails, strOtherDetails, objEmail, strPublishRequest, strComments

		Response.Write("<table width='95%' border='0' align='center' cellpadding='5' class='mainbody' <tr><td>")
'add title and any other header information
		Response.Write("<br><div align='left'><h3>Index Fungorum no.")
'add code here to insert number
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
			strSQL = "SELECT tblIndexFungorumPublications.IssueNumber FROM tblIndexFungorumPublications ORDER BY tblIndexFungorumPublications.IssueNumber;"
			set RS = Server.CreateObject("ADODB.Recordset")
			RS.Open strSQL, dbConn, 3
			if not rs.bof then
				RS.movelast
					intIssueNumber = RS("IssueNumber")
					intIssueNumber = intIssueNumber +1
			else
				intIssueNumber = 1
			end if
			RS.close
			set RS = nothing

		Response.Write(intIssueNumber & "</h3>")
		Response.Write("<p>Effectively published&nbsp;" & FormatDateTime(Now) & "&nbsp;&nbsp;(ISSN 2049-2375)</p>")
		Response.Write("<p>Nomenclatural novelties&nbsp;:&nbsp;")
'add code to get Users Full Name
			strSQL = "SELECT tblRegistrationUsers.UsersFullName FROM tblRegistrationUsers WHERE (((tblRegistrationUsers.UserName) = '" & protectSQL(strUserName, false) & "'));"
			set RS = Server.CreateObject("ADODB.Recordset")
			RS.Open strSQL, dbConn, 3
				if RS("UsersFullName") <> "" then strUsersFullName = RS("UsersFullName")
			RS.close
			set RS = nothing
		Response.Write(strUsersFullName & "</b></p>")
		Response.Write("</div>")
		Response.Write("<br>")
'assemble data and list all names selected
if Request.Form("1") <> "" then
	if Request.Form("1") <> "" then
		intPublishRequest = Request.Form("1")
		'replace spaces for end of URL
		strPublishRequest = replace(Request.Form("1")," ","")
		'walk through request string
		if instr(intPublishRequest,", ") then
			do while instr(intPublishRequest,", ")
				strRemainder = right(intPublishRequest,len(intPublishRequest)-instr(intPublishRequest,", ")-1)
				intPublishRequest = left(intPublishRequest,instr(intPublishRequest,", ")-1)
					response.write(Protologue(intPublishRequest))
				intPublishRequest = strRemainder
			loop
			' do the final request
				response.write(Protologue(intPublishRequest))
		else
			' there is only one
			response.write(Protologue(intPublishRequest))
		end if
	end if
end if

' add footers and 
response.write("<hr noshade>")
response.write("</td>")
response.write("</tr>")
response.write("<tr>")
response.write("<td>")
response.write("<h3>Please check carefully that all the required data to validly publish these names are present; particularly new combinations and new names.<br><br>")
response.write("Go ahead and&nbsp;<a href='IndexFungorumPublishName.asp?PublishRequest=" & strPublishRequest & "'>publish</a>&nbsp; these names; you will be sent an email confirming this action.<br><br>")
response.write("Go back to&nbsp;<a href='IndexFungorumPublishNamePreselect.asp'>preselect</a>&nbsp; if you need to change your selection.<br><br>")
response.write("Go back to&nbsp;<a href='Names.asp'>search for a name to update</a>&nbsp; if you need to change data.<br><br></h3>")
response.write("</td>")
response.write("</tr>")
response.write("</table>")

Function Protologue(intPublishRequest)
	dim strData, RS, RS1, RS2, RS3, RS4, strSQL, strSQL1, strSQL4, strLit, strNomenclaturalAct, strBasionymName, strAuthors, intLitLink, strBasionym, intTypificationNumber
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
	strSQL = "SELECT IndexFungorum.* FROM IndexFungorum WHERE (((IndexFungorum.[RECORD NUMBER]) = " & protectSQL(intPublishRequest,true) & "));"
	set RS = Server.CreateObject("ADODB.Recordset")
	RS.Open strSql, dbConn, 3
'find if it's a typification and deal with this separately
	if RS("STS FLAG") = "t" then
		strData = "<b>" & RS("NAME OF FUNGUS") & "</b> " & RS("AUTHORS") & ", "
		' add full bibliographic reference
		intTypificationNumber = RS("CURRENT NAME RECORD NUMBER")	
		strSQL = "SELECT IndexFungorum.* FROM IndexFungorum WHERE (((IndexFungorum.[RECORD NUMBER]) = " & protectSQL(intTypificationNumber,true) & "));"
		set RS4 = Server.CreateObject("ADODB.Recordset")
		RS4.Open strSQL, dbConn, 3
			intLitLink = RS4("LITERATURE LINK")
			strLit = GetPublication(intLitLink)
		'get publication details
			if RS4("VOLUME") <> "" then strLit = strLit & "&nbsp;<b>" & RS4("VOLUME") & "</b>"
			if RS4("PART") <> "" then strLit = strLit & "(" & RS4("PART") & ")"
			if RS4("PAGE") <> "" then strLit = strLit & ":&nbsp;" & RS4("PAGE")
			if RS4("YEAR OF PUBLICATION") <> "" then strLit = strLit & "&nbsp;(" & RS4("YEAR OF PUBLICATION") & ")"
			if RS4("YEAR ON PUBLICATION") <> "" then strLit = strLit & "&nbsp;['" & RS4("YEAR ON PUBLICATION") & "']"
			strData = strData & strLit & ".<br>"
		strData = strData & "&nbsp;&nbsp;&nbsp;&nbsp;<b>IF" & intPublishRequest & "</b><br>"
		strData = strData & "&nbsp;&nbsp;&nbsp;&nbsp;" & encodeHtml(rtrim(RS("TYPIFICATION DETAILS"))) & ", hic designatus.<br>"
'if epitype then need to cite type to be supported
		if left(RS("TYPIFICATION DETAILS"),7) = "Epitype" then
			'get the details of the type to be supported - if none insert red warning message
			strSupportedType = encodeHtml(RS4("TYPIFICATION DETAILS"))
			if strSupportedType = "" then
				strData = strData & "Details of the type of the name to be epitypified are not present in Index Fungorum - you must update this record first.<br>"
				strData = strData & "Use the update request form, enter the missing data and a valid email address and wait for notification that the record has been updated.<br>"
			else
				strData = strData & "&nbsp;&nbsp;&nbsp;&nbsp;Supported " & strSupportedType & ".<br>"
			end if
		end if
		RS4.close
		set RS4 = nothing
	else
		' trim off any ined.
		if right(RS("AUTHORS"),6) = " ined." then
			strAuthors = left(RS("AUTHORS"),len(RS("AUTHORS"))-6)
		else
			strAuthors = encodeHtml(RS("AUTHORS"))
		end if 
		strData = "<b>" & RS("NAME OF FUNGUS") & "</b> " & strAuthors
		'add any publishing authors
		if RS("PUBLISHING AUTHORS") <> "" then strData = strData & ", in&nbsp;" & encodeHtml(RS("PUBLISHING AUTHORS")) & ",&nbsp;"
'find rank and determine type of nomenclatural act
'for new taxa
		if RS("RECORD NUMBER") = RS("BASIONYM RECORD NUMBER") then
			strNomenclaturalAct = ",&nbsp;" & RS("INFRASPECIFIC RANK") & "nov."
			strData = strData & strNomenclaturalAct & "<br>"
		'add identifier
			strData = strData & "&nbsp;&nbsp;&nbsp;&nbsp;<b>IF" & intPublishRequest & "</b><br>"
		'get diagnosis
			strDiagnosis = GetDiagnosis(intPublishRequest)
			strData = strData & strDiagnosis & "<br>"
		'get type
			if RS("TYPIFICATION DETAILS") <> "" then
			strTemp = RS("TYPIFICATION DETAILS")
		'find out if it's a number
				if left(strTemp,1) = "1" or left(strTemp,1) = "2" or left(strTemp,1) = "3" or left(strTemp,1) = "4" or left(strTemp,1) = "5" or left(strTemp,1) = "6" or left(strTemp,1) = "7" or left(strTemp,1) = "8" or left(strTemp,1) = "9" then
				'get the name of the type
					strSQL4 = "SELECT IndexFungorum.* FROM IndexFungorum WHERE (((IndexFungorum.[RECORD NUMBER]) = " & RS("TYPIFICATION DETAILS") & "));"
					set RS4 = Server.CreateObject("ADODB.Recordset")
					RS4.Open strSQL4, dbConn, 3
						if not RS4.bof then
						'build up type string
						strTemp = "<i>" & RS4("NAME OF FUNGUS") & "</i> " & RS4("AUTHORS") & " " & RS4("YEAR OF PUBLICATION")
						end if
						RS4.close
						set RS4 = nothing
					strData = strData & "&nbsp;&nbsp;&nbsp;&nbsp;Holotype:&nbsp;" & strTemp & ".<br>"
				else
				'check whether its a typification
					if left(RS("TYPIFICATION DETAILS"),1) = "H" then
						strData = strData & "&nbsp;&nbsp;&nbsp;&nbsp;" & encodeHtml(RS("TYPIFICATION DETAILS")) & ".<br>"
					else
						strData = strData & "&nbsp;&nbsp;&nbsp;&nbsp;" & encodeHtml(RS("TYPIFICATION DETAILS")) & "; here designated.<br>"
					end if	
				end if
			end if
'for new names
		elseif RS("RECORD NUMBER") <> RS("BASIONYM RECORD NUMBER") AND RS("SYNONYMY") <> "" then
			strNomenclaturalAct = "nom.nov."
			strData = strData & ", " & strNomenclaturalAct & "<br>"
		'add identifier
			strData = strData & "&nbsp;&nbsp;&nbsp;&nbsp;<b>IF" & intPublishRequest & "</b><br>"
		'get replaced synonym
			intBasionymRecordNumber = RS("BASIONYM RECORD NUMBER")
			strSQL = "SELECT IndexFungorum.* FROM IndexFungorum WHERE (((IndexFungorum.[RECORD NUMBER]) = " & protectSQL(intBasionymRecordNumber,true) & "));"
			set RS1 = Server.CreateObject("ADODB.Recordset")
			RS1.Open strSql, dbConn, 3
			strBasionymName = RS1("NAME OF FUNGUS")
			strBasionym = "&nbsp;&nbsp;&nbsp;&nbsp;Replaced synonym:&nbsp;<i>" & RS1("NAME OF FUNGUS") & "</i> " & RS1("AUTHORS") & ",&nbsp;"
			strData = strData & strBasionym
		'publishing authors
			if RS1("PUBLISHING AUTHORS") <> "" then strData = strData & "in&nbsp;" & RS1("PUBLISHING AUTHORS") & ",&nbsp;"
		'get publication title
			intLitLink = RS1("LITERATURE LINK")
			strLit = GetPublication(intLitLink)
		'get publication details
			if RS1("VOLUME") <> "" then strLit = strLit & ":&nbsp;<b>" & RS1("VOLUME") & "</b>"
			if RS1("PART") <> "" then strLit = strLit & "(" & RS1("PART") & ")"
			if RS1("PAGE") <> "" then strLit = strLit & ":&nbsp;" & RS1("PAGE")
			if RS1("YEAR OF PUBLICATION") <> "" then strLit = strLit & "&nbsp;(" & RS1("YEAR OF PUBLICATION") & ")"
			if RS1("YEAR ON PUBLICATION") <> "" then strLit = strLit & "&nbsp;['" & RS1("YEAR ON PUBLICATION") & "']"
			strData = strData & strLit & ".<br>"
			set RS1 = nothing
		'get competing synonym
			if RS("SYNONYMY") <> "" then intBasionymRecordNumber = left(RS("SYNONYMY"),6)
			strSQL = "SELECT IndexFungorum.* FROM IndexFungorum WHERE (((IndexFungorum.[RECORD NUMBER]) = " & protectSQL(intBasionymRecordNumber,true) & "));"
			set RS2 = Server.CreateObject("ADODB.Recordset")
			RS2.Open strSql, dbConn, 3
			if not RS.bof then
				if strBasionymName = RS2("NAME OF FUNGUS") then ' it's a replaced synonym
					strData = strData & "&nbsp;&nbsp;&nbsp;&nbsp;Competing synonym&nbsp;<i>" & RS2("NAME OF FUNGUS") & "</i> " & RS2("AUTHORS") & ",&nbsp;"
				else ' it's a competing synonym
					strData = strData & "&nbsp;&nbsp;&nbsp;&nbsp;Replaced synonym&nbsp;<i>" & RS2("NAME OF FUNGUS") & "</i> " & RS2("AUTHORS") & ",&nbsp;"
				end if
			end if
		'publishing authors
			if RS2("PUBLISHING AUTHORS") <> "" then strData = strData & ", in&nbsp;" & RS2("PUBLISHING AUTHORS") & ",&nbsp;"
		'get publication title
			intLitLink = RS2("LITERATURE LINK")
			strLit = GetPublication(intLitLink)
		'get publication details
			if RS2("VOLUME") <> "" then strLit = strLit & "&nbsp;<b>" & RS2("VOLUME") & "</b>"
			if RS2("PART") <> "" then strLit = strLit & "(" & RS2("PART") & ")"
			if RS2("PAGE") <> "" then strLit = strLit & ":&nbsp;" & RS2("PAGE")
			if RS2("YEAR OF PUBLICATION") <> "" then strLit = strLit & "&nbsp;(" & RS2("YEAR OF PUBLICATION") & ")"
			if RS2("YEAR ON PUBLICATION") <> "" then strLit = strLit & "&nbsp;['" & RS2("YEAR ON PUBLICATION") & "']"
			strData = strData & strLit & "<br>"
			set RS2 = nothing
		else
'for combinations
			strNomenclaturalAct = "comb.nov."
			strData = strData & ", " & strNomenclaturalAct & "<br>"
		'add identifier
			strData = strData & "&nbsp;&nbsp;&nbsp;&nbsp;<b>IF" & intPublishRequest & "</b><br>"
		'get basionym
			intBasionymRecordNumber = RS("BASIONYM RECORD NUMBER")
			strSQL = "SELECT IndexFungorum.* FROM IndexFungorum WHERE (((IndexFungorum.[RECORD NUMBER]) = " & protectSQL(intBasionymRecordNumber,true) & "));"
			set RS1 = Server.CreateObject("ADODB.Recordset")
			RS1.Open strSql, dbConn, 3
			strBasionym = "&nbsp;&nbsp;&nbsp;&nbsp;Basionym:&nbsp;<i>" & RS1("NAME OF FUNGUS") & "</i> " & RS1("AUTHORS") & ",&nbsp;"
			strData = strData & strBasionym
		'publishing authors
			if RS1("PUBLISHING AUTHORS") <> "" then strData = strData & "in&nbsp;" & RS1("PUBLISHING AUTHORS") & ",&nbsp;"
		'get publication title
			intLitLink = RS1("LITERATURE LINK")
			strLit = GetPublication(intLitLink)
			Protologue = Protologue & strLit
		'get publication details
			if RS1("VOLUME") <> "" then strLit = strLit & "&nbsp;<b>" & RS1("VOLUME") & "</b>"
			if RS1("PART") <> "" then strLit = strLit & "(" & RS1("PART") & ")"
			if RS1("PAGE") <> "" then strLit = strLit & ":&nbsp;" & RS1("PAGE")
			if RS1("YEAR OF PUBLICATION") <> "" then strLit = strLit & "&nbsp;(" & RS1("YEAR OF PUBLICATION") & ")"
			if RS1("YEAR ON PUBLICATION") <> "" then strLit = strLit & "&nbsp;['" & RS1("YEAR ON PUBLICATION") & "']"
			strData = strData & strLit & "<br>"
			set RS1 = nothing
		end if
	end if
	Protologue = strData & "<br>"
	Protologue = Protologue & GetComments(intPublishRequest)
	RS.close
	set RS = nothing
End Function

Function GetPublication(intLitLink)
	dim RS, strSQL, strPublication
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
	strSQL = "SELECT Publications.* FROM Publications WHERE (((Publications.[pubLink]) = " & protectSQL(intLitLink,true) & "));"
	set RS = Server.CreateObject("ADODB.Recordset")
	RS.Open strSQL, dbConn, 3
		strPublication = "<i>" & RS("pubIMIAbbr") & "</i>"
		if RS("pubIMISupAbbr") <> "" then strPublication = strPublication & "&nbsp;" & RS("pubIMISupAbbr")
		if RS("pubIMIAbbrLoc") <> "" then strPublication = strPublication & "&nbsp;(" & RS("pubIMIAbbrLoc") & ")"
		GetPublication = strPublication
	RS.close
	set RS = nothing
End Function

Function GetDiagnosis(intPublishRequest)
	dim RS, strSQL, strDiagnosis
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
	strSQL = "SELECT tblDiagnosis.Diagnosis FROM tblDiagnosis WHERE (((tblDiagnosis.RecordNumberFK) = " & protectSQL(intPublishRequest,true) & "));"
	set RS = Server.CreateObject("ADODB.Recordset")
	RS.Open strSQL, dbConn, 3
		if not RS.bof then
			if RS("Diagnosis") <> "" then strDiagnosis = encodeHtml(RS("Diagnosis")) & "."
			strDiagnosis = replace(strDiagnosis,"..",".")
		end if
	GetDiagnosis = strDiagnosis
	RS.close
	set RS = nothing
End Function

Function GetComments(intPublishRequest)
	dim RS, strSQL, strComments
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
	strSQL = "SELECT tblDiagnosis.Comments FROM tblDiagnosis WHERE (((tblDiagnosis.RecordNumberFK) = " & protectSQL(intPublishRequest,true) & "));"
	set RS = Server.CreateObject("ADODB.Recordset")
	RS.Open strSQL, dbConn, 3
		if not RS.bof then
			if RS("Comments") <> "" then strComments = RS("Comments") & ".<br><br>"
			strComments = replace(strComments,"..",".")
		end if
	GetComments = strComments
	RS.close
	set RS = nothing
End Function
%>
</body>
</html>
