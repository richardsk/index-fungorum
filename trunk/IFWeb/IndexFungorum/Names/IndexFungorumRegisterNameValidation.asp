<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum - Registered Name Validation</title>
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
	dim strBasionym, strHost, strLocation, strComment, intRecordNumber, strPublication, strData, strRank, intFDC
	dim strActType, strDate, strDiagnosis, strOtherPublication, intRegistrationUserID, strValidated
	dim RS, strSQL, RS1, strSQL1, RS2, strSQL2
	dim strGenus, strSpecificEpithet, strInfraspecificEpithet, strRemainder, intIFnumberTypified, strTypificationType, strInfragenericEpithet

'add content of all form elements to session variables
Session("strActType") = Request.Form("ActType")
Session("strNameOfFungus") = Request.Form("NameOfFungus")
Session("strRank") = Request.Form("Rank")
Session("strAuthor") = Request.Form("Author")
Session("strPublishingAuthors") = Request.Form("PublishingAuthors")
Session("intPubLink") = Request.Form("PubLink")
Session("strOtherPublication") = Request.Form("OtherPublication")
Session("strVolume") = Request.Form("Volume")
Session("strPart") = Request.Form("Part")
Session("strPage") = Request.Form("Page")
Session("strYearOfPublication") = Request.Form("YearOfPublication")
Session("strYearOnPublication") = Request.Form("YearOnPublication")
Session("strHost") = Request.Form("Host")
Session("strLocation") = Request.Form("Location")
Session("strBasionym") = Request.Form("Basionym")
Session("strReplacedSynonym") = Request.Form("ReplacedSynonym")
Session("strCompetingSynonym") = Request.Form("CompetingSynonym")
Session("strTypificationDetails") = Request.Form("TypificationDetails")
Session("strDiagnosis") = Request.Form("Diagnosis")
Session("strComment") = Request.Form("Comment")
Session("strEmail") = Request.Form("Email")
Session("intIFnumberTypified") = Request.Form("IFnumberTypified")
Session("strTypificationType") = Request.Form("TypificationType")
Session("intRecordNumber") = intRecordNumber
Session("intRegistrationUserID") = intRegistrationUserID
Session("intFDC") = intFDC
Session("strPublication") = strPublication
Session("strValidated") = strValidated
Session("strTypifiedName") = strTypifiedName
Session("strTypifiedAuthors") = strTypifiedAuthors
Session("strTypifiedYear") = strTypifiedYear
Session("strCaptcha") = strCaptcha

strValidated = "0"
validation()

if strValidated = "0" then
'	Response.write("<br>There are still some items to verify&nbsp;<a href='javascript:history.go(-1)'>go back to the previous page</a>&nbsp;and enter the required data.<br>")
else
	Response.write("<br>Everything required has verified and you are ready to <a href='IndexFungorumRegisterNameCompletion.asp'>complete registration</a>.&nbsp;You can still&nbsp;<a href='javascript:history.go(-1)'>go back to the previous page</a>&nbsp;if you wish to make changes or additions.<br>")
	Response.write("<br>Please be aware that you are responsible for the accuracy of the information you are adding; if you are unsure please seek advice.")
end if

sub validation()
'open DB connection
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
	strValidated = "0"
	strActType = Request.Form("ActType")
	Response.write("The act type is:&nbsp;<b>" & Request.Form("ActType") & "</b><br>")

if strActType <> "New typification" then
	strNameOfFungus = Request.Form("NameOfFungus")
	strNameOfFungus = Replace(Trim(strNameOfFungus),chr(34), Chr(39))
	strNameOfFungus = Replace(strNameOfFungus,"'","")
	strRank = Request.Form("Rank")
	strRank = Replace(Trim(strRank),chr(34), Chr(39))
	strRank = Replace(strRank,"'","")
	if strNameOfFungus <> "" then
		'make sure the form of infraspecific names is correct
		if strActType = "New subspecies" or strActType = "New variety" or strActType = "New form" or strActType = "New infraspecific taxon" then
			'check if infraspecific taxon and make sure rank if entered
			if strActType = "New infraspecific taxon" then
				strRank = Request.Form("Rank")
				Session("strRank") = Replace(Trim(Request.Form("Rank")),chr(34), Chr(39))
				Session("strRank") = Replace(Session("strRank"),"'","")
				if strRank <> "" then
					'a rank has been entered
				else
					Response.write("The name to be registered, a new infraspecific taxon, is missing a rank: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
					strValidated = "0"
					exit sub
				end if
			end if
			strRank = Request.Form("Rank")
			Session("strRank") = Replace(Trim(Request.Form("Rank")),chr(34), Chr(39))
			Session("strRank") = Replace(Session("strRank"),"'","")
			'check if name has four 'words' or coding will fail 
			if strRank <> "" then
				'it's a new infraspecific taxon
				if instr(strNameOfFungus," ") then
					strGenus = left(strNameOfFungus,instr(strNameOfFungus," ")-1)
					strRemainder = right(strNameOfFungus,len(strNameOfFungus)-instr(strNameOfFungus," "))
					if instr(strRemainder," ") then
						strSpecificEpithet = left(strRemainder,instr(strRemainder," "))
						strRemainder = right(strRemainder,len(strRemainder)-instr(strRemainder," "))
						if instr(strRemainder," ") then
							strRank = left(strRemainder,instr(strRemainder," "))
							strInfraspecificEpithet = right(strRemainder,len(strRemainder)-instr(strRemainder," "))
								Response.write("The name to be registered is:&nbsp;<b>" & strGenus & " " & strSpecificEpithet & " " & Session("strRank") & " " & strInfraspecificEpithet & "</b><br>")
								strValidated = "1"
						else
						'there are only two spaces in the name
							Response.write("The name to be registered is not of the correct form for the selected rank: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
							strValidated = "0"
							exit sub
						end if
					else
					'there is only one space in the name
						Response.write("The name to be registered is not of the correct form for the selected rank: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
						strValidated = "0"
						exit sub
					end if
				else
				'these are no spaces
					Response.write("The name to be registered is not of the correct form for the selected rank: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
					strValidated = "0"
					exit sub
				end if
			else
				'it's a new subspecies, variety or form
				if instr(strNameOfFungus," ") then
					strGenus = left(strNameOfFungus,instr(strNameOfFungus," ")-1)
					strRemainder = right(strNameOfFungus,len(strNameOfFungus)-instr(strNameOfFungus," "))
					if instr(strRemainder," ") then
						strSpecificEpithet = left(strRemainder,instr(strRemainder," "))
						strRemainder = right(strRemainder,len(strRemainder)-instr(strRemainder," "))
						if instr(strRemainder," ") then
							strRank = left(strRemainder,instr(strRemainder," "))
							strInfraspecificEpithet = right(strRemainder,len(strRemainder)-instr(strRemainder," "))
							if strActType = "New subspecies" then
								Response.write("The name to be registered is:&nbsp;<b>" & strGenus & " " & strSpecificEpithet & " subsp. " & strInfraspecificEpithet & "</b><br>")
								strValidated = "1"
							elseif strActType = "New variety" then
								Response.write("The name to be registered is:&nbsp;<b>" & strGenus & " " & strSpecificEpithet & " var. " & strInfraspecificEpithet & "</b><br>")
								strValidated = "1"
							elseif strActType = "New form" then
								Response.write("The name to be registered is:&nbsp;<b>" & strGenus & " " & strSpecificEpithet & " f. " & strInfraspecificEpithet & "</b><br>")
								strValidated = "1"
							else
							' the name is for a rank of New infraspecific taxon
							end if
						else
						'there are only two spaces in the name
							Response.write("The name to be registered is not of the correct form for the selected rank: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
							strValidated = "0"
							exit sub
						end if
					else
					'there is only one space in the name
						Response.write("The name to be registered is not of the correct form for the selected rank: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
						strValidated = "0"
						exit sub
					end if
				else
				'these are no spaces
					Response.write("The name to be registered is not of the correct form for the selected rank: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
					strValidated = "0"
					exit sub
				end if
			end if
		elseif strActType = "New subgenus" or strActType = "New section" or strActType = "New subsection" or strActType = "New series" or strActType = "New subseries" or strActType = "New infrageneric taxon" then
			'check name has two spaces
			strGenus = left(strNameOfFungus,instr(strNameOfFungus," ")-1)
			strRemainder = right(strNameOfFungus,len(strNameOfFungus)-instr(strNameOfFungus," "))
			if instr(strRemainder," ") then
				strRank = left(strRemainder,instr(strRemainder," "))
				strInfragenericEpithet = right(strRemainder,len(strRemainder)-instr(strRemainder," "))
				if strActType = "New subgenus" then
					Response.write("The name to be registered is:&nbsp;<b>" & strGenus & " " & " subgen. " & strInfragenericEpithet & "</b><br>")
					strValidated = "1"
				elseif strActType = "New section" then
					Response.write("The name to be registered is:&nbsp;<b>" & strGenus & " " & " sect. " & strInfragenericEpithet & "</b><br>")
					strValidated = "1"
				elseif strActType = "New subsection" then
					Response.write("The name to be registered is:&nbsp;<b>" & strGenus & " " & " subsect. " & strInfragenericEpithet & "</b><br>")
					strValidated = "1"
				elseif strActType = "New series" then
					Response.write("The name to be registered is:&nbsp;<b>" & strGenus & " " & " ser. " & strInfragenericEpithet & "</b><br>")
					strValidated = "1"
				elseif strActType = "New subseries" then
					Response.write("The name to be registered is:&nbsp;<b>" & strGenus & " " & " subser. " & strInfragenericEpithet & "</b><br>")
					strValidated = "1"
				else
				' the name is for another infrageneric taxon
					Response.write("The name to be registered is:&nbsp;<b>" & strNameOfFungus & "</b><br>")
					strValidated = "1"
				end if
			else
			'there are only two spaces in the name
				Response.write("The name to be registered is not of the correct form for the selected rank - three words are required: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
				strValidated = "0"
				exit sub
			end if

		elseif strActType = "New family" or strActType = "New subfamily" then
			if instr(strNameOfFungus," ") then
				Response.write("The name to be registered, '" & strActType & "', is not of the correct form for the selected rank: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
				strValidated = "0"
				exit sub
			end if
			Session("strNameOfFungus") = Replace(Trim(Request.Form("NameOfFungus")),chr(34), Chr(39))
			Session("strNameOfFungus") = Replace(Session("strNameOfFungus"),"'","")
			Response.write("The name is:&nbsp;<b>" & Session("strNameOfFungus") & "</b><br>")
			strValidated = "1"
		elseif strActType = "New combination" then
			'check to see that there is at least one space in the name
			strRank = Request.Form("Rank")
			if instr(strNameOfFungus," ") then
				if strRank <> "" then
					'need to check for form of name
					if strRank = "species" then
						'get the first and the second word only
						strGenus = left(strNameOfFungus,instr(strNameOfFungus," ")-1)
						strSpecificEpithet = right(strNameOfFungus,len(strNameOfFungus)-instr(strNameOfFungus," "))
						if instr(strSpecificEpithet," ") then
							Response.write("The name to be registered is not of the correct form for the selected rank: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
							strValidated = "0"
							exit sub
						else
							strNameOfFungus = strGenus & " " & strSpecificEpithet
							Response.write("The name of the species to be registered is:&nbsp;<b>" & strNameOfFungus & "</b><br>")
							strValidated = "1"
						end if
					elseif strRank = "subspecies" or strRank = "variety" or strRank = "form" or strRank = "other infraspecific rank" then
						strGenus = left(strNameOfFungus,instr(strNameOfFungus," ")-1)
						strRemainder = right(strNameOfFungus,len(strNameOfFungus)-instr(strNameOfFungus," "))
							if instr(strRemainder," ") then
								strSpecificEpithet = left(strRemainder,instr(strRemainder," "))
								strRemainder = right(strRemainder,len(strRemainder)-instr(strRemainder," "))
								if instr(strRemainder," ") then
									strInfraspecificEpithet = right(strRemainder,len(strRemainder)-instr(strRemainder," "))
									if strRank = "subspecies" then strRank = "subsp."
									if strRank = "variety" then strRank = "var."
									if strRank = "form" then strRank = "f."
									strNameOfFungus = strGenus & " " & strSpecificEpithet & " " & strRank & " " & strInfraspecificEpithet
									Response.write("The name to be registered is:&nbsp;<b>" & strNameOfFungus & "</b><br>")
									Response.write("The strSpecificEpithet is:&nbsp;<b>" & strSpecificEpithet & "</b><br>")
									strValidated = "1"
								else
									Response.write("The name to be registered is not of the correct form for the selected rank: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
									strValidated = "0"
									exit sub
								end if
							else
								Response.write("The name to be registered is not of the correct form for the selected rank: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
								strValidated = "0"
								exit sub
							end if
					elseif strRank = "subgenus" or strRank = "section" or strRank = "subsection" or strRank = "series" or strRank = "subseries" then
						strGenus = left(strNameOfFungus,instr(strNameOfFungus," ")-1)
						strRemainder = right(strNameOfFungus,len(strNameOfFungus)-instr(strNameOfFungus," "))
						strInfragenericEpithet = right(strRemainder,len(strRemainder)-instr(strRemainder," "))
						if strRank = "subgenus" then strRank = "subgen."
						if strRank = "section" then strRank = "sect."
						if strRank = "subsection" then strRank = "subsect."
						if strRank = "series" then strRank = "ser."
						if strRank = "subseries" then strRank = "subser."
						strNameOfFungus = strGenus & " " & strRank & " " & strInfragenericEpithet
						Response.write("The name to be registered is:&nbsp;<b>" & strNameOfFungus & "</b><br>")
						strValidated = "1"
					else
						'the rank is either "other infraspecific rank" or "other infrageneric rank"
						Response.write("The name to be registered is:&nbsp;<b>" & strNameOfFungus & "</b><br>")
						strValidated = "1"
					end if
				else
				'check if it's a genus
					strRank = Request.Form("Rank")
					if strRank = "genus" then
						strGenus = left(strNameOfFungus,instr(strNameOfFungus," ")-1)
						strNameOfFungus = strGenus
						Response.write("The name to be registered is:&nbsp;<b>" & strNameOfFungus & "</b><br>")
						strValidated = "1"
					elseif strRank = "" then
						Response.write("The rank for the name to be registered is missing: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
						strValidated = "0"
						exit sub
					else
						Response.write("The name to be registered is not of the correct form for the selected rank: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
						strValidated = "0"
						exit sub
					end if
				end if
			else
			'check if it's a genus
				strRank = Request.Form("ActType")
				if strRank = "New genus" then
					if instr(strNameOfFungus," ") then
						Response.write("The name to be registered is not of the correct form for the selected rank: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
						strValidated = "0"
						exit sub
					else
						Session("strNameOfFungus") = Replace(Trim(Request.Form("NameOfFungus")),chr(34), Chr(39))
						Session("strNameOfFungus") = Replace(Session("strNameOfFungus"),"'","")
						Response.write("The name to be registered is:&nbsp;<b>" & strNameOfFungus & "</b><br>")
						strValidated = "1"
					end if
				else
					Response.write("The rank for the name to be registered is missing: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
					strValidated = "0"
					exit sub
				end if
			end if
		else
			strRank = Request.Form("ActType")
			if strRank = "New genus" then
				if instr(strNameOfFungus," ") then
					Response.write("The name to be registered is not of the correct form for the selected rank: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
					strValidated = "0"
					exit sub
				else
					Session("strNameOfFungus") = Replace(Trim(Request.Form("NameOfFungus")),chr(34), Chr(39))
					Session("strNameOfFungus") = Replace(Session("strNameOfFungus"),"'","")
					Response.write("The name to be registered is:&nbsp;<b>" & strNameOfFungus & "</b><br>")
					strValidated = "1"
				end if
			else
			'it's a name at species rank but check for only one space
                if instr(strNameOfFungus, " ") <> 0 then                     
				    strGenus = left(strNameOfFungus,instr(strNameOfFungus," ")-1)
				    strRemainder = right(strNameOfFungus,len(strNameOfFungus)-instr(strNameOfFungus," "))
                else 
                    strGenus = strNameOfFungus
                end if
				if instr(strRemainder," ") or strGenus = "" then
					Response.write("The name to be registered, '" & strActType & "', is not of the correct form for the selected rank: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
					strValidated = "0"
					exit sub
				end if
				Session("strNameOfFungus") = Replace(Trim(Request.Form("NameOfFungus")),chr(34), Chr(39))
				Session("strNameOfFungus") = Replace(Session("strNameOfFungus"),"'","")
				Response.write("The name is:&nbsp;<b>" & Session("strNameOfFungus") & "</b><br>")
				strValidated = "1"
			end if
		end if
	else
		Response.write("The name to be registered is missing: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
		strValidated = "0"
		exit sub
	end if

	if strActType = "New species" or strActType = "New subspecies" or strActType = "New variety" or strActType = "New form" or strActType = "New infraspecific taxon" then
	    if instr(Session("strNameOfFungus"), " ") <> 0 then
            strGenus = rtrim(left(Session("strNameOfFungus"),instr(Session("strNameOfFungus")," ")-1))
        else
            strGenus = rtrim(Session("strNameOfFungus"))
        end if
		strSQL = "SELECT FundicClassification.[Fundic Record Number] FROM FundicClassification WHERE (((FundicClassification.[Genus Name]) = '" & protectSQL(strGenus, false) & "'));"
		Set RS = Server.CreateObject("ADODB.Recordset")
		RS.Open strSQL, dbConn, 3
		if not RS.bof and not RS.eof then
			strData = RS.recordcount
			if strData <> "1" then
				'there is more than one record
				'assume current so look for any which are not syns and not invalid/illegitimate
				strSQL1 = "SELECT FundicClassification.[Fundic Record Number] FROM FundicClassification " _
				& "WHERE (((FundicClassification.[Genus name])= '" & protectSQL(strGenus, false) & "') " _
				& "((FundicClassification.[Correct Name]) Is Null) AND ((FundicClassification.NomenclaturalComment) Is Null));"
				Set RS1 = Server.CreateObject("ADODB.Recordset")
				RS1.Open strSQL1, dbConn, 3
				if not RS1.bof and not RS1.eof then
					strData = RS1.recordcount
					if strData <> "1" then
						'assume only one of any pair/tripple is legitimate
						strSQL2 = "SELECT FundicClassification.[Fundic Record Number] FROM FundicClassification " _
						& "WHERE (((FundicClassification.[Genus name])= '" & protectSQL(strGenus, false) & "') AND ((FundicClassification.NomenclaturalComment) Is Null)) " _
						& "ORDER BY FundicClassification.[Year of Publication];"
						Set RS2 = Server.CreateObject("ADODB.Recordset")
						RS2.Open strSQL2, dbConn, 3
						if not RS2.bof and not RS2.eof then
							strData = RS1.recordcount
							if strData <> "1" then
								'take the earliest
								Session("intFDC") = RS2("Fundic Record Number")
							else
								'there is only one record which is legitimate
								Session("intFDC") = RS2("Fundic Record Number")
							end if
						end if
						RS2.close
						set RS2 = nothing
					else
						'there is only one record which is current
						Session("intFDC") = RS1("Fundic Record Number")
					end if
				end if
				RS1.close
				set RS1 = nothing
			else
				'there is only one record
				Session("intFDC") = RS("Fundic Record Number")
			end if
		end if
		RS.close
		set RS = nothing
	end if

	strAuthor = Request.Form("Author")
		if strAuthor <> "" then
			if strActType <> "New combination" then
				'all new taxa and new names should have non-parenthetical authors
				if instr(strAuthor,"(") or instr(strAuthor,")") then
					Response.write("The author citation for the name to be registered is not of the correct form for a new taxon (no parenthetical authors are allowed): <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
					strValidated = "0"
					exit sub
				else
					Session("strAuthor") = Replace(Trim(Request.Form("Author")),chr(34), Chr(39))
					Session("strAuthor") = Replace(Session("strAuthor"),"'","")
					Response.write("The author citation is:&nbsp;<b>" & Session("strAuthor") & "</b><br>")
					strValidated = "1"
				end if
			else
				'all new combinations should have parenthetical authors
				if instr(strAuthor,"(") or instr(strAuthor,")") then
					Session("strAuthor") = Replace(Trim(Request.Form("Author")),chr(34), Chr(39))
					Session("strAuthor") = Replace(Session("strAuthor"),"'","")
					Response.write("The author citation is:&nbsp;<b>" & Session("strAuthor") & "</b><br>")
					strValidated = "1"
				else
					Response.write("The author citation for the name to be registered is not of the correct form for a new combination (parenthetical authors are required): <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
					strValidated = "0"
					exit sub
				end if
			end if
		else
			Response.write("The author(s) of the name to be registered is missing: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
			strValidated = "0"
			exit sub
		end if
end if

	if strActType = "New typification" then
		intIFnumberTypified = Request.Form("IFnumberTypified")
			if intIFnumberTypified <> "" then
					'add code to get Name+Author+Year
					strSQL = "SELECT IndexFungorum.* FROM IndexFungorum WHERE (((IndexFungorum.[RECORD NUMBER]) = " & protectSQL(Request.Form("IFnumberTypified"),true) & "));"
					Set RS = Server.CreateObject("ADODB.Recordset")
					RS.Open strSQL, dbConn, 3
					if not RS.bof then
					'build up display string
					Session("strTypifiedName") = RS("NAME OF FUNGUS")
					Session("strTypifiedAuthors") = RS("AUTHORS")
					Session("strTypifiedYear") = RS("YEAR OF PUBLICATION")
					strData = RS("NAME OF FUNGUS") & " " & RS("AUTHORS") & " " & RS("YEAR OF PUBLICATION")
					end if
					RS.close
					set RS = nothing
				Session("intIFnumberTypified") = Replace(Trim(Request.Form("IFnumberTypified")),chr(34), Chr(39))
				Session("intIFnumberTypified") = Replace(Session("intIFnumberTypified"),"'","")
				Response.write("The name to be typified is:&nbsp;<b>" & strData & "&nbsp;(IF" & Session("intIFnumberTypified") & ")</b><br>")
				strValidated = "1"
			else
				Response.write("The IF number of the name to be typified is missing: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
				strValidated = "0"
				exit sub
			end if
	end if

	strPublishingAuthors = Request.Form("PublishingAuthors")
	if strActType = "New typification" then
		if strPublishingAuthors <> "" then
			Session("strPublishingAuthors") = Replace(Trim(Request.Form("PublishingAuthors")),chr(34), Chr(39))
			Session("strPublishingAuthors") = Replace(Session("strPublishingAuthors"),"'","")
			Response.write("The publishing authors are:&nbsp;<b>" & Session("strPublishingAuthors") & "</b><br>")
			strValidated = "1"
		else
			Response.write("The authors of the publication in which the typification is being published are missing: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
			strValidated = "0"
			exit sub
		end if
	else
		if strPublishingAuthors <> "" then
			Session("strPublishingAuthors") = Replace(Trim(Request.Form("PublishingAuthors")),chr(34), Chr(39))
			Session("strPublishingAuthors") = Replace(Session("strPublishingAuthors"),"'","")
			Response.write("The publishing authors are:&nbsp;<b>" & Session("strPublishingAuthors") & "</b><br>")
		else
			Session("strPublishingAuthors") = Session("strPublishingAuthors")
		end if
	end if

	intPubLink = Request.Form("PubLink")
	strOtherPublication = Request.Form("OtherPublication")
		if intPubLink <> "" then
			intPubLink = Request.Form("PubLink")
			intPubLink = CLng(intPubLink)
			strSql = "SELECT tblRegistrationPublications.* FROM tblRegistrationPublications WHERE (((tblRegistrationPublications.pubLink) = " & protectSQL(intPubLink,true) & "));"
			Set RS = Server.CreateObject("ADODB.Recordset")
			RS.Open strSql, dbConn, 3
			strPublication = ltrim(RS("pubIMIAbbr"))
			RS.close
			set RS = nothing
			Response.write("The journal or book title is:&nbsp;<b>" & strPublication & "</b><br>")
		else
			if strOtherPublication <> "" then
				Session("strOtherPublication") = Replace(Trim(Request.Form("OtherPublication")),chr(34), Chr(39))
				Session("strOtherPublication") = Replace(Session("strOtherPublication"),"'","")
				Response.write("The journal or book title is:&nbsp;<b>" & Session("strOtherPublication") & "</b><br>")
				strValidated = "1"
			else
				Response.write("A journal or book title from the list must be selected <b>OR</b> details of the journal or book must be entered&nbsp;")
				Response.write("to indicate where the name will be published: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
				strValidated = "0"
				exit sub
			end if
		end if

	strVolume = Request.Form("Volume")
		if strVolume <> "" then
			Session("strVolume") = Replace(Trim(Request.Form("Volume")),chr(34), Chr(39))
			Session("strVolume") = Replace(Session("strVolume"),"'","")
			Response.write("The volume is:&nbsp;<b>" & Session("strVolume") & "</b><br>")
		else
			Session("strVolume") = Session("strVolume")
		end if

	strPart = Request.Form("Part")
		if strPart <> "" then
			Session("strPart") = Replace(Trim(Request.Form("Part")),chr(34), Chr(39))
			Session("strPart") = Replace(Session("strPart"),"'","")
			Response.write("The part is:&nbsp;<b>" & Session("strPart") & "</b><br>")
		else
			Session("strPart") = Session("strPart")
		end if

	strPage = Request.Form("Page")
		if strPage <> "" then
			Session("strPage") = Replace(Trim(Request.Form("Page")),chr(34), Chr(39))
			Session("strPage") = Replace(Session("strPage"),"'","")
			Response.write("The page is:&nbsp;<b>" & Session("strPage") & "</b><br>")
			strValidated = "1"
		else
			Response.write("The page or plate number the name is to be published on is missing; ")
			Response.write("if it is unknown enter [1]: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
			strValidated = "0"
			exit sub
		end if

	strYearOfPublication = Request.Form("YearOfPublication")
		if strYearOfPublication <> "" then
			Session("strYearOfPublication") = Replace(Trim(Request.Form("YearOfPublication")),chr(34), Chr(39))
			Session("strYearOfPublication") = Replace(Session("strYearOfPublication"),"'","")
			Response.write("The year is:&nbsp;<b>" & Session("strYearOfPublication") & "</b><br>")
			strValidated = "1"
		else
			Response.write("The year the name is to be published is missing; ")
			Response.write("if it is unknown enter the current year: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
			strValidated = "0"
			exit sub
		end if

	strYearOnPublication = Request.Form("YearOnPublication")
		if strYearOnPublication <> "" then
			Session("strYearOnPublication") = Replace(Trim(Request.Form("YearOnPublication")),chr(34), Chr(39))
			Session("strYearOnPublication") = Replace(Session("strYearOnPublication"),"'","")
			Response.write("The year appearing on the publication will be: <b>" & Session("strYearOnPublication") & "</b><br>")
		else
			Session("strYearOnPublication") = Session("strYearOnPublication")
		end if

	if strActType = "New combination" then
		strBasionym = Request.Form("Basionym")
			if strBasionym <> "" then
				'check to see if it's a number
				if left(strBasionym,1) = "1" or left(strBasionym,1) = "2" or left(strBasionym,1) = "3" or left(strBasionym,1) = "4" or left(strBasionym,1) = "5" or left(strBasionym,1) = "6" or left(strBasionym,1) = "7" or left(strBasionym,1) = "8" or left(strBasionym,1) = "9" then
					'add code to get Name+Author+Year
					strSql = "SELECT IndexFungorum.* FROM IndexFungorum WHERE (((IndexFungorum.[RECORD NUMBER]) = " & protectSQL(Request.Form("Basionym"),true) & "));"
					Set RS = Server.CreateObject("ADODB.Recordset")
					RS.Open strSql, dbConn, 3
					if not RS.bof then
					'build up display string
					strData = RS("NAME OF FUNGUS") & " " & encodeHtml(RS("AUTHORS")) & " " & RS("YEAR OF PUBLICATION")
					end if
					RS.close
					set RS = nothing
					Response.write("The basionym is: <b>" & strData & "</b><br>")
					strValidated = "1"
				else
					Response.write("The basionym IF record number for this combination is missing; ")
					Response.write("please enter the IF record number: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
					strValidated = "0"
					exit sub
				end if
			else
				Response.write("The basionym for this combination is missing; ")
				Response.write("please enter the IF record number: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
				strValidated = "0"
				exit sub
			end if
	end if

	if strActType = "New name" then
		strReplacedSynonym = Request.Form("ReplacedSynonym")
			if strReplacedSynonym <> "" then
				'check to see if it's a number
				if left(strReplacedSynonym,1) = "1" or left(strReplacedSynonym,1) = "2" or left(strReplacedSynonym,1) = "3" or left(strReplacedSynonym,1) = "4" or left(strReplacedSynonym,1) = "5" or left(strReplacedSynonym,1) = "6" or left(strReplacedSynonym,1) = "7" or left(strReplacedSynonym,1) = "8" or left(strReplacedSynonym,1) = "9" then
					'code to get Name+Author+Year
					strSQL = "SELECT IndexFungorum.* FROM IndexFungorum WHERE (((IndexFungorum.[RECORD NUMBER]) = " & protectSQL(Request.Form("ReplacedSynonym"),true) & "));"
					Set RS = Server.CreateObject("ADODB.Recordset")
					RS.Open strSQL, dbConn, 3
					if not RS.bof then
					'build up display string
					strData = RS("NAME OF FUNGUS") & " " & RS("AUTHORS") & " " & RS("YEAR OF PUBLICATION")
					end if
					RS.close
					set RS = nothing
					Response.write("The replaced synonym is: <b>" & strData & "</b><br>")
					strValidated = "1"
				else
					Response.write("The replaced synonym IF record number for this combination is missing; ")
					Response.write("please enter the IF record number: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
					strValidated = "0"
					exit sub
				end if
			else
				Response.write("The replaced synonym for this combination is missing; ")
				Response.write("please enter the IF record number: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
				strValidated = "0"
				exit sub
			end if
	
		strCompetingSynonym = Request.Form("CompetingSynonym")
			if strCompetingSynonym <> "" then
				'check to see if it's a number
				if left(strCompetingSynonym,1) = "1" or left(strCompetingSynonym,1) = "2" or left(strCompetingSynonym,1) = "3" or left(strCompetingSynonym,1) = "4" or left(strCompetingSynonym,1) = "5" or left(strCompetingSynonym,1) = "6" or left(strCompetingSynonym,1) = "7" or left(strCompetingSynonym,1) = "8" or left(strCompetingSynonym,1) = "9" then
					'code to get Name+Author+Year
					strSQL = "SELECT IndexFungorum.* FROM IndexFungorum WHERE (((IndexFungorum.[RECORD NUMBER]) = " & protectSQL(Request.Form("CompetingSynonym"),true) & "));"
					Set RS = Server.CreateObject("ADODB.Recordset")
					RS.Open strSQL, dbConn, 3
					if not RS.bof then
					'build up display string
					strData = RS("NAME OF FUNGUS") & " " & RS("AUTHORS") & " " & RS("YEAR OF PUBLICATION")
					end if
					RS.close
					set RS = nothing
					Response.write("The competing synonym is: <b>" & strData & "</b><br>")
					strValidated = "1"
				else
					Response.write("The competing synonym IF record number for this combination is missing; ")
					Response.write("please enter the IF record number: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
					strValidated = "0"
					exit sub
				end if
			else
				Response.write("The competing synonym IF record number for this combination is missing; ")
				Response.write("please enter the IF record number: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
				strValidated = "0"
				exit sub
			end if
	end if

	strHost = Request.Form("Host")
		if strHost <> "" then
			Session("strHost") = Replace(Trim(Request.Form("Host")),chr(34), Chr(39))
			Session("strHost") = Replace(Session("strHost"),"'","")
			Response.write("The host, associated organism or ecosystem where the type was collected is:&nbsp;<b>" & Session("strHost") & "</b><br>")
		else
			Session("strHost") = Session("strHost")
		end if
	strLocation = Request.Form("Location")
		if strLocation <> "" then
			Session("strLocation") = Request.Form("Location")
			Response.write("The origin of the type is:&nbsp;<b>" & Session("strLocation") & "</b><br>")
		else
			Session("strLocation") = Session("strLocation")
		end if

	if strActType = "New species" or strActType = "New subspecies" or strActType = "New variety" or strActType = "New form" or strActType = "New infraspecific taxon" then
		strTypificationDetails = Request.Form("TypificationDetails")
			if strTypificationDetails <> "" then
				Session("strTypificationDetails") = Replace(Trim(Session("strTypificationDetails")),chr(34), Chr(39))
				Session("strTypificationDetails") = Replace(Session("strTypificationDetails"),"'","")
				' add 'Holotype' to details of typification
				Session("strTypificationDetails") = "Holotype " & strTypificationDetails
				Response.write("The typification details are:&nbsp;<b>" & Session("strTypificationDetails") & "</b><br>")
				strValidated = "1"
			else
				Response.write("The typification details of the name to be registered are missing: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
				strValidated = "0"
				exit sub
			end if
		strDiagnosis = Request.Form("Diagnosis")
			if strDiagnosis <> "" then
				Session("strDiagnosis") = Replace(Trim(Request.Form("Diagnosis")),chr(34), Chr(39))
				Session("strDiagnosis") = Replace(Session("strDiagnosis"),"'","")
				Response.write("The diagnosis is:&nbsp;<b>" & Session("strDiagnosis") & "</b><br>")
				strValidated = "1"
			else
				Response.write("The diagnosis for the name to be registered is missing: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
				strValidated = "0"
				exit sub
			end if
	end if

	if strActType = "New genus" or strActType = "New subgenus" or strActType = "New infrageneric taxon" or strActType = "New family" or strActType = "New subfamily" or strActType = "New infrafamilial name" then
		strTypificationDetails = Request.Form("TypificationDetails")
			if strTypificationDetails <> "" then
				'code to get Name+Author+Year
				strSQL = "SELECT IndexFungorum.* FROM IndexFungorum WHERE (((IndexFungorum.[RECORD NUMBER]) = " & protectSQL(Request.Form("TypificationDetails"),true) & "));"
				Set RS = Server.CreateObject("ADODB.Recordset")
				RS.Open strSQL, dbConn, 3
				if not RS.bof then
				'build up display string
				strData = RS("NAME OF FUNGUS") & " " & RS("AUTHORS") & " " & RS("YEAR OF PUBLICATION")
				end if
				RS.close
				set RS = nothing
				Session("strTypificationDetails") = Replace(Trim(Session("strTypificationDetails")),chr(34), Chr(39))
				Session("strTypificationDetails") = Replace(Session("strTypificationDetails"),"'","")
				' do not add 'Holotype' to details of typification; construct correct data form during publication
				strTypificationDetails = "Holotype " & strData
				Response.write("The typification details are:&nbsp;<b>" & strTypificationDetails & "</b><br>")
				strValidated = "1"
			else
				Response.write("The typification details of the name to be registered are missing: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
				strValidated = "0"
				exit sub
			end if
		strDiagnosis = Request.Form("Diagnosis")
			if strDiagnosis <> "" then
				Session("strDiagnosis") = Replace(Trim(Request.Form("Diagnosis")),chr(34), Chr(39))
				Session("strDiagnosis") = Replace(Session("strDiagnosis"),"'","")
				Response.write("The diagnosis is:&nbsp;<b>" & Session("strDiagnosis") & "</b><br>")
				strValidated = "1"
			else
				Response.write("The diagnosis for the name to be registered is missing: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
				strValidated = "0"
				exit sub
			end if
	end if

	if strActType = "New superfamily" or strActType = "New order" or strActType = "New suborder" or strActType = "New class" or strActType = "New subclass" or strActType = "New phylum" or strActType = "New subphylum" then
		strRank = Request.Form("Rank")
			if strRank <> "" then
				Response.write("The Rank is:&nbsp;<b>" & Request.Form("Rank") & "</b><br>")
				Session("strRank") = Request.Form("Rank")
				strValidated = "1"
			else
				Response.write("The rank for the name to be registered is missing: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
				strValidated = "0"
				exit sub
			end if
		strTypificationDetails = Request.Form("TypificationDetails")
			if strTypificationDetails <> "" then
				Session("strTypificationDetails") = Replace(Trim(Request.Form("TypificationDetails")),chr(34), Chr(39))
				Session("strTypificationDetails") = Replace(Session("strTypificationDetails"),"'","")
				Session("strTypificationDetails") = "Holotype " & Session("strTypificationDetails")
				Response.write("The typification details are:&nbsp;<b>" & Session("strTypificationDetails") & "</b><br>")
				strValidated = "1"
			else
				Response.write("The typification details of the name to be registered are missing: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
				strValidated = "0"
				exit sub
			end if
		strDiagnosis = Request.Form("Diagnosis")
			if strDiagnosis <> "" then
				Session("strDiagnosis") = Replace(Trim(Request.Form("Diagnosis")),chr(34), Chr(39))
				Session("strDiagnosis") = Replace(Session("strDiagnosis"),"'","")
				Response.write("The diagnosis is:&nbsp;<b>" & Session("strDiagnosis") & "</b><br>")
				strValidated = "1"
			else
				Response.write("The diagnosis for the name to be registered is missing: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
				strValidated = "0"
				exit sub
			end if
	end if

	if strActType = "New typification" then
		strTypificationType = Request.Form("TypificationType")
			if strTypificationType <> "" then
				Session("strTypificationType") = Replace(Trim(Request.Form("TypificationType")),chr(34), Chr(39))
				Session("strTypificationType") = Replace(Session("strTypificationType"),"'","")
				Response.write("The typification type for the name to be typified is:&nbsp;<b>" & Session("strTypificationType") & "</b><br>")
				strValidated = "1"
			else
				Response.write("The typification type for the name to be typified is missing: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
				strValidated = "0"
				exit sub
			end if
		strTypificationDetails = Request.Form("TypificationDetails")
			if strTypificationDetails <> "" then
				Session("strTypificationDetails") = Replace(Trim(Request.Form("TypificationDetails")),chr(34), Chr(39))
				Session("strTypificationDetails") = Replace(Session("strTypificationDetails"),"'","")
				Session("strTypificationDetails") = "Holotype " & Session("strTypificationDetails")
				Response.write("The typification details are:&nbsp;<b>" & Session("strTypificationDetails") & "</b><br>")
				strValidated = "1"
			else
				Response.write("The typification details for the name to be typified are missing: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
				strValidated = "0"
				exit sub
			end if
	end if

	strComment = Request.Form("Comment")
		if strNotes <> "" then
			Session("strComment") = Replace(Trim(Request.Form("Comment")),chr(34), Chr(39))
			Session("strComment") = Replace(Session("strComment"),"'","")
			Response.write("These comments are included:&nbsp;<b>" & Session("strComment") & "</b><br>")
		else
			Session("strComment") = Session("strComment")
		end if

	strEmail = Request.Form("Email")
		if strEmail <> "" then
			Session("strEmail") = Replace(Trim(Request.Form("Email")),chr(34), Chr(39))
			Session("strEmail") = Replace(Session("strEmail"),"'","")
			Response.write("Your email is:&nbsp;<b>" & Session("strEmail") & "</b><br>")
			strValidated = "1"
		else
			Response.write("Your email address is missing; the IF identifier which you are required to include in the protologue, ")
			Response.write("cannot be mailed to you: <a href='javascript:history.go(-1)'>go back to the previous page</a><br>")
			strValidated = "0"
			exit sub
		end if
end sub
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
