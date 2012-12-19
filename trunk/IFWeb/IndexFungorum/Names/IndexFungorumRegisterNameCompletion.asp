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
<title>Index Fungorum - Insert Registered Name</title>
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
'add code to prevent unverified names slipping in by the back door (?add to top of page like 'loggedin' test
'If Session("loggedin") <> True Then Response.Redirect "login.asp"
'if Session("strValidated") = "0" then response.Redirect("/Names/IndexFungorumRegisterName.asp.asp")
' ...
' ...
' ...
'end if

dim strNameOfFungus, strAuthor, strPublishingAuthors, intPubLink, strVolume, strPart, strInfragenericEpithet
dim strPage, strYearOfPublication, strYearOnPublication, strTypificationDetails, strEmail, strRank, strRemainder
dim strBasionym, strHost, strLocation, strNotes, intRecordNumber, strPublication, strSpecificEpithet, strGenus
dim strActType, strDate, strDiagnosis, strOtherPublication, strData, strSTSflag, strInfraspecificEpithet

		'start captcha
		Response.Write("<form id='form1' name='form1' method='post' action=''>")
		Response.Write("<table width='500' border='1' align='center'>")
		Response.Write("<tr>")
		if Session("strTypifiedName") <> "" then
			if Session("strTypificationType") = "lectotype" then strData = "a lectotypification"
			if Session("strTypificationType") = "neotype" then strData = "a neotypification"
			if Session("strTypificationType") = "epitype" then strData = "an epitypification"
		Response.write("<td colspan='2' align='center'>You are ready to register " & strData & " of <b><font color='#0000FF'>" & session("strTypifiedName") & " " & session("strTypifiedAuthors") & " " & session("strTypifiedYear"))
		else
		Response.write("<td colspan='2' align='center'>You are ready to register <b><font color='#0000FF'>" & session("strNameOfFungus") & " " & session("strAuthor") & " " & session("strYearOfPublication"))
		end if
		Response.write("</font></b><br><br>")
		Response.write("If this is incorrect <a href='javascript:history.go(-1)'>go back to the previous page</a><br><br>")
'		Response.write("strActType is " & Session("strActType") & "<br><br>")
		Response.Write("</td>")
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
	'test captcha
	if not IsEmpty(Request.Form("btnTest")) then
		Response.Write("<tr><td colspan=""2"" align=""center"">")
		if TestCaptcha("ASPCAPTCHA", Request.Form("captchacode")) then
			Response.Write("<b style=""color:#00CC33"">The code you entered verified</b>")
			'define variable for hiding record until checked or published with a user login
			strLastFiveYears = "X"
			if Session("strActType") = "New typification" then
				strSTSflag = "t"
			else
				strSTSflag = "y"
			end if
			strDate = now()
'			strDate = right(Left(Now(),10),4) & Mid(Left(Now(),10),4,2) & Left(Left(Now(),10),2)
				' SET UP THE DATABASE CONNECTION
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

			'get the publication details
			if Session("intPubLink") <> "" then
				'the publication was selected from the list
				intPubLink = Request.Form("intPubLink")
				strSql = "SELECT tblRegistrationPublications.* FROM tblRegistrationPublications WHERE (((tblRegistrationPublications.pubLink) = " & protectSQL(Session("intPubLink"),true) & "));"
				Set RS = Server.CreateObject("ADODB.Recordset")
				RS.Open strSql, dbConn, 3
				if not RS.bof then
					Session("strPublication") = ltrim(RS("pubIMIAbbr"))
				end if
				RS.close
				set RS = nothing
			else
				'it's an unlisted publication
				'get the next Publink
				strSQL = "SELECT tblRegistrationPublicationNumber.PublicationNumber " _
					& "FROM tblRegistrationPublicationNumber " _
					& "WHERE (((tblRegistrationPublicationNumber.Used) = '0')) " _
					& "ORDER BY tblRegistrationPublicationNumber.PublicationNumber;"
				Set RS = Server.CreateObject("ADODB.Recordset")
				RS.Open strSql, dbConn, 3
				RS.movefirst
				intPubLink = RS("PublicationNumber")
				Session("intPubLink") = intPubLink
				RS.close
				set RS = nothing
				'flag as used
				strSQL = "UPDATE tblRegistrationPublicationNumber SET tblRegistrationPublicationNumber.Used = '1' " _
					& "WHERE ((([tblRegistrationPublicationNumber].PublicationNumber) = " & protectSQL(intPubLink,true) & "));"
				dbConn.Execute(strSQL)
				'insert the new Publications record 
				strSQL = "INSERT INTO Publications ([pubLink], [pubOriginalTitle], [pubIMIAbbr])"
				strSQL = strSQL & " VALUES"
				strSQL = strSQL & "('" & protectSQL(Session("intPubLink"),true) & "', '" & protectSQL(Session("strOtherPublication"), false) & "', '" & protectSQL(Session("strOtherPublication"), false) & "');"
				dbConn.Execute(strSQL)
			end if

			'get an unused identifier
			strSQL = "SELECT tblRegistrationNumbers.RegistrationNumber " _
				& "FROM tblRegistrationNumbers " _
				& "WHERE (((tblRegistrationNumbers.Used) = '0')) " _
				& "ORDER BY tblRegistrationNumbers.RegistrationNumber;"
			Set RS = Server.CreateObject("ADODB.Recordset")
			RS.Open strSql, dbConn, 3
       		RS.movefirst
       		intRecordNumber = (RS("RegistrationNumber"))
			Session("intRecordNumber") = intRecordNumber
			RS.close
       		set RS = nothing
			'flag as used
			strSQL = "UPDATE tblRegistrationNumbers SET tblRegistrationNumbers.Used = '1' " _
				& "WHERE (((tblRegistrationNumbers.RegistrationNumber) = " & protectSQL(intRecordNumber,true) & "));"
			dbConn.Execute(strSQL)
			'insert the record
				if Session("strActType") = "New species" then
					Session("strActType") = "sp."
					'seed basionym number
					Session("strBasionym") = Session("intRecordNumber")
				elseif Session("strActType") = "New subspecies" then
					Session("strActType") = "subsp."
					'seed basionym number
					Session("strBasionym") = Session("intRecordNumber")
				elseif Session("strActType") = "New variety" then
					Session("strActType") = "var."
					'seed basionym number
					Session("strBasionym") = Session("intRecordNumber")
				elseif Session("strActType") = "New form" then
					Session("strActType") = "f."
					'seed basionym number
					Session("strBasionym") = Session("intRecordNumber")
				elseif Session("strActType") = "New genus" then
					Session("strActType") = "gen."
					'seed basionym number
					Session("strBasionym") = Session("intRecordNumber")
				elseif Session("strActType") = "New subgenus" then
					Session("strActType") = "subgen."
					'seed basionym number
					Session("strBasionym") = Session("intRecordNumber")
				elseif Session("strActType") = "New family" then
					Session("strActType") = "fam."
					'seed basionym number
					Session("strBasionym") = Session("intRecordNumber")
				elseif Session("strActType") = "New subfamily" then
					Session("strActType") = "subfam."
					'seed basionym number
					Session("strBasionym") = Session("intRecordNumber")
				elseif Session("strActType") = "New superfamily" then
					Session("strActType") = "supfam."
					'seed basionym number
					Session("strBasionym") = Session("intRecordNumber")
				elseif Session("strActType") = "New order" then
					Session("strActType") = "ord."
					'seed basionym number
					Session("strBasionym") = Session("intRecordNumber")
				elseif Session("strActType") = "New suborder" then
					Session("strActType") = "subord."
					'seed basionym number
					Session("strBasionym") = Session("intRecordNumber")
				elseif Session("strActType") = "New class" then
					Session("strActType") = "class."
					'seed basionym number
					Session("strBasionym") = Session("intRecordNumber")
				elseif Session("strActType") = "New subclass" then
					Session("strActType") = "subclass."
					'seed basionym number
					Session("strBasionym") = Session("intRecordNumber")
				elseif Session("strActType") = "New phylum" then
					Session("strActType") = "phyl."
					'seed basionym number
					Session("strBasionym") = Session("intRecordNumber")
				elseif Session("strActType") = "New subphylum" then
					Session("strActType") = "subphyl."
					'seed basionym number
					Session("strBasionym") = Session("intRecordNumber")
'cannot do these without some serious coding ... but not yet fully implemented
				elseif Session("strActType") = "New infraspecific epithet" then
					Session("strActType") = ""
					'seed basionym number
					Session("strBasionym") = Session("intRecordNumber")
				elseif Session("strActType") = "New infrageneric epithet" then
					Session("strActType") = ""
					'seed basionym number
					Session("strBasionym") = Session("intRecordNumber")
				elseif Session("strActType") = "New infrafamilial name" then
					Session("strActType") = ""
					'seed basionym number
					Session("strBasionym") = Session("intRecordNumber")
				elseif Session("strActType") = "New combination" then
					'code to find rank
					strNameOfFungus = Session("strNameOfFungus")
						if instr(strNameOfFungus," ") then
							strRank = left(strNameOfFungus,instr(strNameOfFungus," ")-1)
							strRemainder = ltrim(right(strNameOfFungus,len(strNameOfFungus)-len(strRank)))
							if instr(strRemainder," ") then
							'more than one space so split remainder
							strRank = left(strRemainder,instr(strRemainder," ")-1)
							strRemainder = right(strRemainder,len(strRemainder)-len(strRank))					
								if instr(strRemainder," ") then
								'more than two space so split remainder
									if strRank = "subsp." then Session("strActType") = "subsp."
									if strRank = "var." then Session("strActType") = "var."
									if strRank = "f." then Session("strActType") = "f."
								else
									if strRank = "subgen." then Session("strActType") = "subgen."
									if strRank = "ser." then Session("strActType") = "ser."
									if strRank = "subser." then Session("strActType") = "subser."
									if strRank = "sect." then Session("strActType") = "sect."
									if strRank = "subsect." then Session("strActType") = "subsect."
								end if
							else
							'only one space so combination to species rank
								Session("strActType") = "sp."
							end if
						else
							'no spaces to combination to genus rank
							Session("strActType") = "gen."
						end if
				elseif Session("strActType") = "New name" then
					Session("strActType") = ""
				elseif Session("strActType") = "New typification" then
					Session("strActType") = ""
				end if


				' need to populate [SPECIFIC EPITHET], [INFRASPECIFIC EPITHET]
					if instr(Session("strNameOfFungus")," ") then
						strSpecificEpithet = ""
						strGenus = left(Session("strNameOfFungus"),instr(Session("strNameOfFungus")," ")-1)
						strRemainder = rtrim(ltrim(right(Session("strNameOfFungus"),len(Session("strNameOfFungus"))-len(strGenus))))
						if instr(strRemainder," ") then
						'more than one space so split remainder
						strSpecificEpithet = left(strRemainder,instr(strRemainder," ")-1)
						strRemainder = rtrim(ltrim(right(strRemainder,len(strRemainder)-len(strSpecificEpithet))))
							if instr(strRemainder," ") then
							'more than two spaces so split remainder
								strRank = left(strRemainder,instr(strRemainder," ")-1)
								strInfraspecificEpithet = right(strRemainder,len(strRemainder)-len(strRank))		
								strSpecificEpithet = ""
							else
							'infrageneric rank name
								strRank = strSpecificEpithet
								strInfraspecificEpithet = strRemainder
								strSpecificEpithet = ""
							end if
						else
						'only one space - so species
							strSpecificEpithet = strRemainder
						end if
					else
						'no spaces - so genus
						Session("strActType") = "gen."
					end if










			'sort out Basionym/ReplacedSynonym
			if Session("strBasionym") <> "" then
				strBasionym = Session("strBasionym")
			else
				if Session("strReplacedSynonym") <> "" then Session("strBasionym") = Session("strReplacedSynonym")
				if Session("strTypificationType") <> "" then Session("strBasionym") = intRecordNumber
			end if
			'put together string for competing synonym to go in [SYNONYMY]
			if Session("strCompetingSynonym") <> "" then
				strSql = "SELECT IndexFungorum.* FROM IndexFungorum WHERE (((IndexFungorum.[RECORD NUMBER]) = " & protectSQL(Session("strCompetingSynonym"),true) & "));"
				Set RS = Server.CreateObject("ADODB.Recordset")
				RS.Open strSql, dbConn, 3
				if not RS.bof then
				'build up display string
				strData = Session("strCompetingSynonym") & "$<i>" & RS("NAME OF FUNGUS") & "</i> " & RS("AUTHORS") & " " & RS("YEAR OF PUBLICATION")
				Session("strCompetingSynonym") = strData
				end if
				RS.close
				set RS = nothing
			end if
			'sort out some data for typification event : name, author
			if Session("strTypifiedName") <> "" then Session("strNameOfFungus") = Session("strTypifiedName")
			'sort out type of typification
			if Session("strTypificationType") = "lectotype" then
				Session("strTypificationDetails") = "Lectotype " & Session("strTypificationDetails")
			elseif Session("strTypificationType") = "neotype" then
				Session("strTypificationDetails") = "Neotype " & Session("strTypificationDetails")
			elseif Session("strTypificationType") = "epitype" then
				Session("strTypificationDetails") = "Epitype " & Session("strTypificationDetails")
'			else
'				Session("strTypificationDetails") = "Holotype " & Session("strTypificationDetails")
			end if

			if Session("strTypifiedName") <> "" then
				strSQL = "INSERT INTO IndexFungorum ([NAME OF FUNGUS], " _
					& "[LITERATURE LINK], VOLUME, PART, PAGE, " _
					& "[YEAR OF PUBLICATION], [YEAR ON PUBLICATION], SYNONYMY, " _
					& "[TYPIFICATION DETAILS], [RECORD NUMBER], " _
					& "[BASIONYM RECORD NUMBER], [INFRASPECIFIC RANK], [CURRENT NAME RECORD NUMBER], " _
					& "[NAME OF FUNGUS FUNDIC RECORD NUMBER], [LAST FIVE YEARS FLAG], [STS FLAG], AddedDate, AddedBy)"
				strSQL = strSQL & " VALUES"
				strSQL = strSQL & "('" & protectSQL(Session("strNameOfFungus"), false) & "', '" _
					& protectSQL(Session("intPubLink"), false) & "', '" & protectSQL(Session("strVolume"), false) & "', '" & protectSQL(Session("strPart"), false) & "', '" & protectSQL(Session("strPage"), false) & "', '" _
					& protectSQL(Session("strYearOfPublication"), false) & "', '" & protectSQL(Session("strYearOnPublication"), false) & "', '" & protectSQL(Session("strCompetingSynonym"), false) & "', '" _
					& protectSQL(Session("strTypificationDetails"), false) & "', '" & protectSQL(intRecordNumber, false) & "', '" _
					& protectSQL(Session("strBasionym"), false) & "', '" & protectSQL(Session("strActType"), false) & "', '" & protectSQL(Session("intIFnumberTypified"), false) & "', '" _
					& protectSQL(Session("intFDC"), false) & "', '" & protectSQL(strLastFiveYears, false) & "', '" & protectSQL(strSTSflag, false) & "', '" & protectSQL(strDate, false) _
                    & "', 'Registered by: " & protectSQL(Session("strEmail"), false) & "');"
			else
				strSQL = "INSERT INTO IndexFungorum ([NAME OF FUNGUS], AUTHORS, [PUBLISHING AUTHORS], " _
					& "[LITERATURE LINK], VOLUME, PART, PAGE, " _
					& "[YEAR OF PUBLICATION], [YEAR ON PUBLICATION], SYNONYMY, " _
					& "HOST, LOCATION, [TYPIFICATION DETAILS], [RECORD NUMBER], " _
					& "[BASIONYM RECORD NUMBER], [INFRASPECIFIC RANK], [SPECIFIC EPITHET], [INFRASPECIFIC EPITHET], " _
					& "[NAME OF FUNGUS FUNDIC RECORD NUMBER], [LAST FIVE YEARS FLAG], [STS FLAG], AddedDate, AddedBy)"
				strSQL = strSQL & " VALUES"
				strSQL = strSQL & "('" & protectSQL(Session("strNameOfFungus"), false) & "', '" & protectSQL(Session("strAuthor"), false) & "', '" & protectSQL(Session("strPublishingAuthors"), false) & "', '" _
					& protectSQL(Session("intPubLink"), true) & "', '" & protectSQL(Session("strVolume"), false) & "', '" & protectSQL(Session("strPart"), false) & "', '" & protectSQL(Session("strPage"), false) & "', '" _
					& protectSQL(Session("strYearOfPublication"), false) & "', '" & protectSQL(Session("strYearOnPublication"), false) & "', '" & protectSQL(Session("strCompetingSynonym"), false) & "', '" _
					& protectSQL(Session("strHost"), false) & "', '" & protectSQL(Session("strLocation"), false) & "', '" & protectSQL(Session("strTypificationDetails"), false) & "', '" & protectSQL(intRecordNumber, false) & "', '" _
					& protectSQL(Session("strBasionym"), false) & "', '" & protectSQL(Session("strActType"), false) & "', '" & protectSQL(Session("strSpecificEpithet"), false) & "', '" & protectSQL(Session("strInfraspecificEpithet"), false) & "', '" _
					& protectSQL(Session("intFDC"), false) & "', '" & protectSQL(strLastFiveYears, false) & "', '" & protectSQL(strSTSflag, false) & "', '" & protectSQL(strDate, false) & "', 'Registered by: " & protectSQL(Session("strEmail"), false) & "');"
			end if
			dbConn.Execute(strSQL)
			'insert the diagnosis (if new taxon) and anything else
			if session("strDiagnosis") <> "" then
				strSQL = "INSERT INTO tblDiagnosis (RecordNumberFK, Diagnosis)"
				strSQL = strSQL & " VALUES"
				strSQL = strSQL & "('" & protectSQL(Session("intRecordNumber"),true) & "', '" & protectSQL(Session("strDiagnosis")) & "');"
'TEMPORARILY COMMENTED OUT
'				dbConn.Execute(strSQL)
			end if

			'get users ID
			strSQL = "SELECT [tblRegistrationUsers].ID FROM [tblRegistrationUsers] WHERE ((([tblRegistrationUsers].UserName)='" & protectSQL(session("strEmail"), false) & "'));"
			Set RS = Server.CreateObject("ADODB.Recordset")
			RS.Open strSql, dbConn, 3
			if not RS.bof then
	       		intRegistrationUserID = RS("ID")
	       		Session("intRegistrationUserID") = RS("ID")
				'insert record for this user in tblRegistrationUsersNames
				strSQL = "INSERT INTO tblRegistrationUsersNames ([IF-FK], UserID)"
				strSQL = strSQL & " VALUES"
				strSQL = strSQL & "('" & protectSQL(Session("intRecordNumber"),true) & "', '" & protectSQL(Session("intRegistrationUserID"), false) & "');"
'TEMPORARILY COMMENTED OUT
'				dbConn.Execute(strSQL)
			end if
			RS.close
			set RS = nothing
			dbConn.close
			set dbConn = Nothing





'TEMPORARILY COMMENTED OUT
'		response.Redirect("../Names/IndexFungorumRegisterNameEmailer.asp")
		Response.Write("<br>Name is&nbsp;" & Session("strNameOfFungus"))
		Response.Write("<br>TEST is&nbsp;" & strTest)
		Response.Write("<br>Genus is&nbsp;" & strGenus)
		Response.Write("<br>Specific epithet is&nbsp;" & strSpecificEpithet)
		Response.Write("<br>Rank is&nbsp;" & strRank)
		Response.Write("<br>Infra epithet is&nbsp;" & strInfraspecificEpithet)
		Response.Write("<br>Date is&nbsp;" & Now())
		Response.Write("<br>Check everything looks OK")
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
