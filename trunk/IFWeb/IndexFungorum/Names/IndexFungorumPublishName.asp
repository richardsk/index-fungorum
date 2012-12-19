<%
If Session("loggedin") <> True Then Response.Redirect "login.asp"
strUserName = request.cookies("UserName")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum - Publish Name</title>
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
	dim RS, strSQL, RS1, strSQL1, objEmail, strUsersFullName, strPublication, strEmail, intIssueNumber
	dim strUserName, strNameDetails, strPublicationDetails, strOtherDetails, strPublishRequest, strDate
	dim strHTML, dbConn, strConn, FS, F, Path, strFileName, strPublishedNames, strTemp, strRank, intRecordNumber

' add title and any other header information
	strHTML = "<div align='center'><p><b>Index Fungorum no.&nbsp;"
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
			if RS.bof then 
			'it's the first publication
				intIssueNumber = 1
			else
				RS.movelast
				intIssueNumber = RS("IssueNumber")
				intIssueNumber = intIssueNumber + 1
			end if
	RS.close
	set RS = nothing

	strHTML = strHTML & intIssueNumber & "</p></div>"
	strHTML = strHTML & "<p>Effectively published&nbsp;" & FormatDateTime(Now) & "&nbsp;&nbsp;(ISSN 2049-2375)</p>"
	strHTML = strHTML & "<p>Nomenclatural novelties&nbsp;:&nbsp;"
'add code to get Users Full Name
		strSQL = "SELECT tblRegistrationUsers.UsersFullName FROM tblRegistrationUsers WHERE (((tblRegistrationUsers.UserName) = '" & protectSQL(strUserName, false) & "'));"
		set RS = Server.CreateObject("ADODB.Recordset")
		RS.Open strSQL, dbConn, 3
			if RS("UsersFullName") <> "" then strUsersFullName = RS("UsersFullName")
		RS.close
		set RS = nothing
	strHTML = strHTML & strUsersFullName & "</b></p></centre>"
'assemble data and list all names selected
	if request.querystring.item("PublishRequest") <> "" then
		if request.querystring.item("PublishRequest") <> "" then
			intPublishRequest = Request.querystring.item("PublishRequest")
			strPublishedNames = protectSQL(intPublishRequest,true)
		'walk through request string
			if instr(intPublishRequest,",") then
				do while instr(intPublishRequest,",")
					strRemainder = right(intPublishRequest,len(intPublishRequest)-instr(intPublishRequest,","))
					intPublishRequest = left(intPublishRequest,instr(intPublishRequest,",")-1)
						strHTML = strHTML & "<p>" & Protologue(intPublishRequest) & "</p>"
					intPublishRequest = strRemainder
				loop
		' do the final request
					strHTML = strHTML & "<p>" & Protologue(intPublishRequest) & "</p>"
			else
		' there is only one
				strHTML = strHTML & "<p>" & Protologue(intPublishRequest) & "</p>"
			end if
		end if
		strHTML = strHTML & "<br>"
	end if
' add intIssueNumber into filename
	strFileName = "Index Fungorum" & intIssueNumber & ".html"
	if strIP = "10.0.5.10" then
		Path = Server.MapPath("\Publications\HTML" & "\") 
	elseif strIP = "10.0.5.4" then
		Path = Server.MapPath("\Publications\HTML" & "\") 
	elseif strIP = "192.168.0.12" then
		Path = Server.MapPath("\IndexFungorum\Publications\HTML" & "\") 
	else
		Path = Server.MapPath("\Publications\HTML" & "\") 
	end if

'create HTML file
	set FS=Server.CreateObject("Scripting.FileSystemObject") 
	set F=FS.CreateTextFile(Path & "\" & strFileName,true)
	F.write(strHTML)
	F.close
	set F=nothing
'create PDF
	GeneratePDF(intIssueNumber)
	set FS=nothing
'update tblIndexFungorumPublications with this published number
	strSQL = "INSERT INTO tblIndexFungorumPublications ([IssueNumber])"
	strSQL = strSQL & " VALUES"
	strSQL = strSQL & "('" & protectSQL(intIssueNumber, false) & "');"
'only on live server
	if strIP = "10.0.5.4" then dbConn.Execute(strSQL)

'update Index Fungorum for published names (this also filters out published names for the preselect as long as 'X' and 'y' are used and no unpublished names are open)
'build SQL string for 1->many records
	if instr(strPublishedNames,",") then
		strSQL =  replace(strPublishedNames,","," OR (IndexFungorum.[RECORD NUMBER])=")
		strSQL =  "(((IndexFungorum.[RECORD NUMBER])=" & strSQL & "))"
		strTemp = "there is more than one record number"
	else
		strSQL = "(((IndexFungorum.[RECORD NUMBER])=" & strPublishedNames & "))"
		strTemp = "there is only one record number"
	end if
'save SQL string for use below
	strSQL1 = strSQL
	strSQL = "UPDATE IndexFungorum SET IndexFungorum.[STS FLAG] = Null, IndexFungorum.[LAST FIVE YEARS FLAG] = Null WHERE " & strSQL & ";"
'only on live server
	if strIP = "10.0.5.4" then dbConn.Execute(strSQL)

	'update [STS FLAG] for supraspecific names
	set RS = Server.CreateObject("ADODB.Recordset")
	strSQL = "SELECT IndexFungorum.[INFRASPECIFIC RANK], IndexFungorum.[RECORD NUMBER] FROM IndexFungorum WHERE " & strSQL1 & ";"
	RS.Open strSQL, dbConn, 3
	do while not RS.bof and not RS.eof
		strRank = RS("INFRASPECIFIC RANK")
		intRecordNumber = RS("RECORD NUMBER")
		if strRank <> "" then
			'populate variable to deal with supraspecific ranks
			'need to deal with other suprageneric ranks
				if strRank = "gen." then
					strRank = "g"
				elseif strRank = "subgen." then
					strRank = "g"
				elseif strRank = "fam." then
					strRank = "f"
				elseif strRank = "subfam." then
					strRank = "f"
				elseif strRank = "supfam." then
					strRank = "f"
				elseif strRank = "ord." then
					strRank = "r"
				elseif strRank = "subord." then
					strRank = "r"
				elseif strRank = "class." then
					strRank = "c"
				elseif strRank = "subclass." then
					strRank = "c"
				elseif strRank = "phyl." then
					strRank = "p"
				elseif strRank = "subphyl." then
					strRank = "p"
				else
					strTemp = ""
				end if
			'update [STS FLAG] for this record with correct rank flag
			strSQL = "UPDATE IndexFungorum SET IndexFungorum.[STS FLAG] = '" & protectSQL(strRank, false) & "' WHERE IndexFungorum.[RECORD NUMBER] = " & RS("RECORD NUMBER") & ";"
'only on live server
			if strIP = "10.0.5.4" then dbConn.Execute(strSQL)
		end if
		RS.movenext
	loop
	RS.close
	set RS = nothing

'send email with details and attached PDF
	Set objEmail = CreateObject("CDO.Message")
	objEmail.From = "p.kirk@cabi.org"
	objEmail.To = strUserName
	objEmail.CC = "p.kirk@cabi.org"
	objEmail.BCC = "k.hudson@cabi.org;LDO-Electronic@bl.uk;a.decock@cbs.knaw.nl"
	objEmail.Subject = "Index Fungorum no. " & intIssueNumber & " was published " & FormatDateTime(Now)
	Body = "Thank you for using Index Fungorum Publisher" & vbCrLf & vbCrLf
	Body = Body & "Index Fungorum no. " & intIssueNumber & " was published on " & FormatDateTime(Now) & vbCrLf & vbCrLf
	'get the URL for download
	if strIP = "10.0.5.10" then
		strURL = "http://backup.indexfungorum.org"
	elseif strIP = "10.0.5.4" then
		strURL = "http://www.indexfungorum.org"
	elseif strIP = "192.168.0.12" then
		strURL = "http://94.172.195.133/Indexfungorum"
	else
		strURL = "http://www.indexfungorum.org"
	end if
	strURL = strURL & "/Publications/Index%20Fungorum%20no." & intIssueNumber & ".pdf"
	Body = Body & "Your publication can be downloaded from: " & strURL & vbCrLf & vbCrLf
	objEmail.TextBody = Body
'only send from live server
	if strIP = "10.0.5.4" then objEmail.Send
	Set objEmail = Nothing

'add links with information
	response.write("<br><br>&nbsp;&nbsp;&nbsp;&nbsp;Thank you for using the Index Fungorum publisher; your names are now validly published and are visible from the Index Fungorum database<br><br>")
	response.write("&nbsp;&nbsp;&nbsp;&nbsp;You will receive an email which includes the details of what you published and a link so that you can download the PDF; which has been added to the British Library digital archive (others will be included soon)<br><br>")
	strLink = "IndexFungorumPublishNamePreselect.asp"
	response.write("&nbsp;&nbsp;&nbsp;&nbsp;<a href=" & strLink & " >Go back to preselect other names</a><br><br>")
	strLink = "IndexFungorumPublicationsListing.asp"
	response.write("&nbsp;&nbsp;&nbsp;&nbsp;<a href=" & strLink & " >View other Index Fungorum publications</a><br><br>")

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

Function GeneratePDF(intIssueNumber)
	Set Pdf = Server.CreateObject("Persits.Pdf")
	Set Doc = Pdf.CreateDocument
	Set page = Doc.Pages.Add(594, 842)
	'use Arial font
	Set Font = Doc.Fonts("Arial")
	if strIP = "10.0.5.10" then
		Path = Server.MapPath("\Publications\HTML\Index Fungorum" & intIssueNumber & ".html") 
	elseif strIP = "10.0.5.4" then
		Path = Server.MapPath("\Publications\HTML\Index Fungorum" & intIssueNumber & ".html") 
	elseif strIP = "192.168.0.12" then
		Path = Server.MapPath("\IndexFungorum\Publications\HTML\Index Fungorum" & intIssueNumber & ".html") 
	else
		Path = Server.MapPath("\Publications\HTML\Index Fungorum" & intIssueNumber & ".html") 
	end if
	'load string from file
	Text = Pdf.LoadTextFromFile(Path)
	Set param = pdf.CreateParam("x=10; y=832; width=574; height=822; html=true")
	Do While Len(Text) > 0	
		CharsPrinted = Page.Canvas.DrawText(Text, param, Font)
		'save HTML tag generated by DrawText to reflect current font state
		HtmlTag = Page.Canvas.HtmlTag
		' Print page numbers bottom right
		Params = "x=0; y=15; width=584; alignment=center; size=10"
		Page.Canvas.DrawText Page.Index, Params, doc.fonts("Helvetica")
		'entire string printed so exit loop.
		if CharsPrinted = Len(Text) then Exit Do
		'otherwise print remaining text on next page
		Set Page = Page.NextPage
		Text = HtmlTag & Right(Text, Len(Text) - CharsPrinted)
	Loop
	if strIP = "10.0.5.10" then
		Path = Server.MapPath("\Publications\") & "\Index Fungorum no." & intIssueNumber & ".pdf"
	elseif strIP = "10.0.5.4" then
		Path = Server.MapPath("\Publications\") & "\Index Fungorum no." & intIssueNumber & ".pdf"
	elseif strIP = "192.168.0.12" then
		Path = Server.MapPath("\IndexFungorum\Publications\") & "\Index Fungorum no." & intIssueNumber & ".pdf"
	else
		Path = Server.MapPath("\Publications\HTML" & "\") 
	end if
	' Save document
	FileName = Doc.Save(Path, false)
End Function
%>
</body>
</html>
