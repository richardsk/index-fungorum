<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="file:///C|/Dreamweaver/IndexFungorum/templates/TemplIF.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Index Fungorum - Search Page</title>
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
<!--#include file="Connections/DataAccess.asp"-->
<!--#include file="Helpers/Utility.asp"-->
<link href="file:///C|/Dreamweaver/IndexFungorum/StyleIXF.css" rel="stylesheet" type="text/css">
</head> 
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<a name="TopOfPage"></a> 
<table width="100%" height="100%" class="mainbody">
  <tr>
    <td height="105"> 
      <table width="100%" border="0" class="mainbody">
        <tr> 
          <td width="50%" class="h1"> <img src="file:///C|/Dreamweaver/IndexFungorum/IMAGES/LogoIF.gif" alt="Index Fungorum - Species Fungorum" width="100" height="100">Index&nbsp;Fungorum</td>
          <td valign="top"> <table height="100%" align="center">
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("../Names/IndexFungorumPartnership.htm") onMouseOver="MM_displayStatusMsg('Index Fungorum Partnership');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Index Fungorum Partnership</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("../Names/Acknowledge.htm") onMouseOver="MM_displayStatusMsg('Acknowledgements');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Acknowledgements</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("../Names/IndexFungorum.htm") onMouseOver="MM_displayStatusMsg('Help with searching');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Help with searching</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="file:///C|/Dreamweaver/IndexFungorum/Names/AuthorsOfFungalNames.asp" onMouseOver="MM_displayStatusMsg('Search Authors of Fungal Names');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Search Authors of Fungal Names</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="file:///C|/Dreamweaver/IndexFungorum/Names/Names.asp" onMouseOver="MM_displayStatusMsg('Search Index Fungorum');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Search Index Fungorum</a></td>
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
<%
	dim strSearch, strType, intPageNumber, intNumRecords, intPageSize, intPageCount, strOpen
	intPageSize = 200
	strSearch = session("strSearch")
	strType = session("strType")
	if request.form.item("Submit") <> "" then
		if request.form.item("SearchTerm") <> ""  then
			'trap single quote
			strSearch = replace(request.form.item("SearchTerm"),"'","")
			' trap leading %
			strSearch = replace(strSearch,"%","")
			session("strSearch") = strSearch
			intPageNumber = "1"
			if request.form.item("SearchBy") = "Name" then
				strType = "N"
				session("strType") = strType
			elseif request.form.item("SearchBy") = "epithet" then
				strType = "E"
				session("strType") = strType
			end if
	  end if
	end if
	if request.querystring.item("strGenus") <> "" then
		strSearch = request.querystring.item("strGenus")
		session("strSearch") = strSearch
		strType = "N"
		session("strType") = strType
		intPageNumber = "1"
		session("intPageNumber") = intPageNumber
		if request.querystring.item("GSD") <> "" then strType = "G"
	end if
	if request.querystring.item("strEpithet") <> "" then
		strSearch = request.querystring.item("strEpithet")
		session("strSearch") = strSearch
		strType = "E"
		session("strType") = strType
		intPageNumber = "1"
		session("intPageNumber") = intPageNumber
	end if
' back door for all records	
	if request.querystring.item("P") <> "" then
		strOpen = "OK"
	else
		strOpen = ""
	end if

sub GetNav
	select case request.querystring("pg")
		case "-1"
			intPageNumber = intPageNumber - 1
		case "+1"
			intPageNumber = intPageNumber + 1
		case else
			intPageNumber = request.querystring("pg")
	end select
	if intPageNumber = "" then intPageNumber = "1"
end sub

sub NavForm
	dim i, frm
	if intPageCount <> "" then
		frm  = "names"
		response.write("<p><b>Pages: </b>")
		if intPageNumber > 1 then
			response.write("<a href='" & frm & ".asp?pg=" & intPageNumber -1 & "'>[Prev &lt;&lt;]</a> ")
		end if
		for i = 1 to intPageCount
			if cstr(i) = intPageNumber then
				response.write("<b>" & i & "</b> ")
			else
				response.write("<a href='" & frm & ".asp?pg=" & i & "'>" & i & "</a> ")
			end if	
		next
		if clng(intPageNumber) < clng(intPageCount) then
			response.write("<a href='" & frm & ".asp?pg=" & intPageNumber + 1 & "'>[Next &gt;&gt;]</a>")
		end if
		response.write(" <b>of " & intNumRecords & " records.</b></p>")
	else
		response.write("<p>" & intNumRecords & " records</p>")
	end if
end sub

sub ResList (rs)
	dim strLink, i
	rs.absoluteposition=((intPageNumber-1) * intPageSize) +1
	response.write("<p></p><b>Name, Author, Year, (Current name), Parent taxon</b><p></p>")
	NavForm
	for i = 1 to rs.PageSize
		if rs.eof then exit for
		if rs.bof then exit for
		if strType = "E" then
			if rs("SPECIFIC EPITHET") <> "" then
				response.write(" " & rs("SPECIFIC EPITHET") & ", ")
			end if
		end if

' set variable for link colours
'1 - OK name
		strLinkType = 1
'2 - misapplication
		if rs("MISAPPLICATION AUTHORS") <> "" then strLinkType = 2
'3 - unpublished name
		if instr(rs("AUTHORS"),"ined.") then strLinkType = 3
'4 - current name
		if rs("RECORD NUMBER") = rs("CURRENT NAME RECORD NUMBER") then strLinkType = 4

'		strLink = "NamesRecord.asp?RecordID=" & server.urlencode(rs("RECORD NUMBER"))
'		response.write("<a href=" & strLink & " >" & rs("NAME OF FUNGUS") & "</a>")
		if rs("RECORD NUMBER") = rs("CURRENT NAME RECORD NUMBER") then
			strLink = "SynSpecies.asp?RecordID=" & server.urlencode(rs("RECORD NUMBER"))
			response.write("<a class='LinkColour" & strLinkType & "' href=" & strLink & " >" & rs("NAME OF FUNGUS") & "</a>")
		else
			strLink = "NamesRecord.asp?RecordID=" & server.urlencode(rs("RECORD NUMBER"))
			response.write("<a class='LinkColour" & strLinkType & "' href=" & strLink & " >" & rs("NAME OF FUNGUS") & "</a>")
'			response.write("<a href=" & strLink & " >" & rs("NAME OF FUNGUS") & "</a>")
		end if

		if rs("AUTHORS") <> "" then
			response.write(" " & server.HTMLEncode(rs("AUTHORS")))
		else
' ONLY TAKE TEXT BEFORE ";"
			if rs("MISAPPLICATION AUTHORS") <> "" then
				if instr(rs("MISAPPLICATION AUTHORS"),"; fide") then
					response.write(" sensu " & server.HTMLEncode(left(rs("MISAPPLICATION AUTHORS"),instr(rs("MISAPPLICATION AUTHORS"),"; fide")-1)))
				else
					response.write(" sensu " & server.HTMLEncode(rs("MISAPPLICATION AUTHORS")))
				end if
			end if
		end if
		if rs("YEAR OF PUBLICATION") <> "" then
			response.write(" (" & rs("YEAR OF PUBLICATION") & ")")
		end if
		if rs("NAME OF FUNGUS") <> rs("CURRENT NAME") and rs("CURRENT NAME") <> "" then
			if rs("GSD FLAG") <> "" then
				strLink = "GSDSpecies.asp?RecordID=" & rs("CURRENT NAME RECORD NUMBER")
'				strLink = "NamesRecord.asp?RecordID=" & rs("CURRENT NAME RECORD NUMBER")
			else
				strLink = "SynSpecies.asp?RecordID=" & rs("CURRENT NAME RECORD NUMBER")
			end if
			response.write(", (= ")
			strLinkType = 4
			response.write("<a class='LinkColour" & strLinkType & "' href=" & strLink & " >" & rs("CURRENT NAME") & "</a>)")
		end if
		if rs("GSD FLAG") <> "" then
			response.write(", [GSD]")
		end if
		parenttaxon = ""
		' determine whether name has a current name to assign appropriate parent taxon
		if rs("CURRENT NAME") <> "" then
		' it's got a current name so get the parent linked to this name
			strData = (rs("CurrentAnamorphType"))
			if strData = "hyphomycetous anamorph" or strData = "coelomycetous anamorph" then
				if rs("CurrentTeleomorphLink") <> "" then
					strData = rtrim(left(rs("CurrentTeleomorphLink"),instr(rs("CurrentTeleomorphLink")," ")))
					if right(strData,5) = "aceae" then
						strLink = "fundic.asp?RecordID=" & server.urlencode(strData) & "&Type=F"
						response.write("; Anamorphic <a href=" & strLink & " >" & strData & "</a>")	
					elseif right(strData,4) = "ales" then
						response.write("; Anamorphic " & strData)
					elseif right(strData,7) = "mycetes" then
						response.write("; Anamorphic " & strData)
					elseif right(strData,6) = "mycota" then
						response.write("; Anamorphic " & strData)
					else
						strData = left(rs("CurrentTeleomorphLink"),instr(rs("CurrentTeleomorphLink")," "))
						strLink = "GenusRecord.asp?RecordID=" & server.urlencode(right(rs("CurrentTeleomorphLink"),len(rs("CurrentTeleomorphLink"))-instr(rs("CurrentTeleomorphLink")," ")))
						response.write("; Anamorphic <a href=" & strLink &  " >" & strData & "</a>")
					end if
				else
						response.write("; " & rs("CurrentPhylum"))
				end if
'			elseif instr(rs("CurrentPhylum"),"Fossil") then
'				response.write("; " & rs("CurrentPhylum"))
			else
				if right(rs("CurrentFamily"),5) = "aceae" then
					if parenttaxon = "" then
						parenttaxon = "<a href='families.asp?FamilyName=" & rs("CurrentFamily") & "'>" & rs("CurrentFamily") & "</a>"
					end if
				end if
				if right(rs("CurrentOrder"),4) = "ales" then
					if parenttaxon = "" then
						parenttaxon = rs("CurrentOrder")
					end if
				end if
				if right(rs("CurrentSubclass"),9) = "mycetidae" then
					if parenttaxon = "" then
						parenttaxon = rs("CurrentSubclass")
					end if
				end if
				if right(rs("CurrentClass"),7) = "mycetes" then
					if parenttaxon = "" then
						parenttaxon = rs("CurrentClass")
					end if
				end if
				if right(rs("CurrentPhylum"),6) = "mycota" then
					if parenttaxon = "" then
						parenttaxon = rs("CurrentPhylum")
					end if
				end if
				if rs("CurrentKingdom") <> "" then
					if parenttaxon = "" then
						parenttaxon = rs("CurrentKingdom")
					end if
				end if
				response.write("; " & parenttaxon)
			end if
		else
		' there is no current name so either get parent from name or if current name fundic record number included get from same as above
			if rs("CURRENT NAME FUNDIC RECORD NUMBER") <> "" then
			' current name fundic record number included get assumed parent taxon
				strData = (rs("CurrentAnamorphType"))
				if strData = "hyphomycetous anamorph" or strData = "coelomycetous anamorph" then
					if rs("CurrentTeleomorphLink") <> "" then
						strData = rtrim(left(rs("CurrentTeleomorphLink"),instr(rs("CurrentTeleomorphLink")," ")))
						if right(strData,5) = "aceae" then
							strLink = "fundic.asp?RecordID=" & server.urlencode(strData) & "&Type=F"
							response.write("; Anamorphic <a href=" & strLink & " >" & strData & "</a>")	
						elseif right(strData,4) = "ales" then
							response.write("; Anamorphic " & strData)
						elseif right(strData,7) = "mycetes" then
							response.write("; Anamorphic " & strData)
						elseif right(strData,6) = "mycota" then
							response.write("; Anamorphic " & strData)
						else
							strData = left(rs("CurrentTeleomorphLink"),instr(rs("CurrentTeleomorphLink")," "))
							strLink = "GenusRecord.asp?RecordID=" & server.urlencode(right(rs("CurrentTeleomorphLink"),len(rs("CurrentTeleomorphLink"))-instr(rs("TeleomorphLink")," ")))
							response.write("; Anamorphic <a href=" & strLink &  " >" & strData & "</a>")
						end if
					else
							response.write("; " & rs("CurrentPhylum"))
					end if
				elseif instr(rs("CurrentPhylum"),"Fossil") then
					response.write("; " & rs("CurrentPhylum"))
				else
					if right(rs("CurrentFamily"),5) = "aceae" then
						if parenttaxon = "" then
							parenttaxon = "<a href='families.asp?FamilyName=" & rs("CurrentFamily") & "'>" & rs("CurrentFamily") & "</a>"
						end if
					end if
					if right(rs("CurrentOrder"),4) = "ales" then
						if parenttaxon = "" then
							parenttaxon = rs("CurrentOrder")
						end if
					end if
					if right(rs("CurrentSubclass"),9) = "mycetidae" then
						if parenttaxon = "" then
							parenttaxon = rs("CurrentSubclass")
						end if
					end if
					if right(rs("CurrentClass"),7) = "mycetes" then
						if parenttaxon = "" then
							parenttaxon = rs("CurrentClass")
						end if
					end if
					if right(rs("CurrentPhylum"),6) = "mycota" then
						if parenttaxon = "" then
							parenttaxon = rs("CurrentPhylum")
						end if
					end if
					if rs("CurrentKingdom") <> "" then
						if parenttaxon = "" then
							parenttaxon = rs("CurrentKingdom")
						end if
					end if
					response.write("; <font color='#FFFF33'>assumed</font> " & parenttaxon)
				end if
			else
			' there is no current name so either get parent from name
				strData = (rs("AnamorphType"))
				if strData = "hyphomycetous anamorph" or strData = "coelomycetous anamorph" then
					if rs("TeleomorphLink") <> "" then
						strData = rtrim(left(rs("TeleomorphLink"),instr(rs("TeleomorphLink")," ")))
						if right(strData,5) = "aceae" then
							strLink = "fundic.asp?RecordID=" & server.urlencode(strData) & "&Type=F"
							response.write("; Anamorphic <a href=" & strLink & " >" & strData & "</a>")	
						elseif right(strData,4) = "ales" then
							response.write("; Anamorphic " & strData)
						elseif right(strData,7) = "mycetes" then
							response.write("; Anamorphic " & strData)
						elseif right(strData,6) = "mycota" then
							response.write("; Anamorphic " & strData)
						else
							strData = left(rs("TeleomorphLink"),instr(rs("TeleomorphLink")," "))
							strLink = "genusrecord.asp?RecordID=" & server.urlencode(right(rs("TeleomorphLink"),len(rs("TeleomorphLink"))-instr(rs("TeleomorphLink")," ")))
							response.write("; Anamorphic <a href=" & strLink &  " >" & strData & "</a>")
						end if
					else
							response.write("; " & rs("Phylum name"))
					end if
				elseif rtrim(left(rs("Phylum name"),instr(rs("Phylum name")," "))) = "Fossil" then
					response.write("; " & rs("Phylum name"))
				else
					if right(rs("family name"),5) = "aceae" then
						if parenttaxon = "" then
							parenttaxon = "<a href='families.asp?FamilyName=" & rs("family name") & "'>" & rs("family name") & "</a>"
						end if
					end if
					if right(rs("order name"),4) = "ales" then
						if parenttaxon = "" then
							parenttaxon = rs("order name")
						end if
					end if
					if right(rs("subclass name"),9) = "mycetidae" then
						if parenttaxon = "" then
							parenttaxon = rs("subclass name")
						end if
					end if
					if right(rs("class name"),7) = "mycetes" then
						if parenttaxon = "" then
							parenttaxon = rs("class name")
						end if
					end if
					if right(rs("phylum name"),6) = "mycota" then
						if parenttaxon = "" then
							parenttaxon = rs("phylum name")
						end if
					end if
					if rs("kingdom name") <> "" then
						if parenttaxon = "" then
							parenttaxon = rs("kingdom name")
						end if
					end if
					response.write("; " & parenttaxon)
				end if
			end if
		end if
		rs.Movenext
		response.write("<br>")
	next
	NavForm
end sub

sub OrthVar
	dim strSQL, dbConn, rs
	if strSearch = "" then exit sub
	Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
	if true then        
       strConn = GetConnectionString()
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "192.168.0.3" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_WEBSERVER;Initial Catalog=IndexFungorum;Data Source=webserver"
	   dbConn.open strConn
	elseif strIP = "194.203.77.76" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_BIOSCIENCEWSRVR;Initial Catalog=IndexFungorum;Data Source=biosciencewsrvr"
	   dbConn.open strConn
	elseif strIP = "194.131.255.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_BIOSCIENCEWSRVR;Initial Catalog=IndexFungorum;Data Source=biosciencewsrvr"
	   dbConn.open strConn
	elseif strIP = "202.27.240.46" then
		strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_Devserver01;Initial Catalog=IndexFungorum;Data Source=Devserver01"
	   dbConn.open strConn
	elseif strIP = "192.168.0.1" then
	   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\cabi\cabilink.mdb"
	   dbConn.open strConn
	elseif strIP = "127.0.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=cabilink"
	end if
	if strType = "N" then
		if instr(strSearch," ") then strSearch = left(strSearch,instr(strSearch," ")-1)
		strSQL = "SELECT tblOrthVar.* FROM tblOrthVar " _
			& "WHERE (((tblOrthVar.OrthographicVariant) Like '" & protectSQL(strSearch, false) & "%')) " _
			& "ORDER BY tblOrthVar.OrthographicVariant;"
	elseif strType = "E" then
		strSQL = "SELECT tblOrthVarEpithets.* FROM tblOrthVarEpithets " _
			& "WHERE (((tblOrthVarEpithets.[ORTHOGRAPHY COMMENT]) Like '" & protectSQL(strSearch, false) & "%')) " _
			& "ORDER BY tblOrthVarEpithets.[ORTHOGRAPHY COMMENT];"
	else
		exit sub
	end if

	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.Open strSql, dbConn, 3
	if not rs.bof then
		intNumRecords = rs.recordcount
		if intNumRecords = "1" then
			response.write("The search term <b>" & strSearch & "</b> was not found but the following orthographic variant was:<br><br>")
		else
			response.write("The search term <b>" & strSearch & "</b> was not found but the following orthographic variants were:<br><br>")
		end if
		rs.movefirst
	do while not rs.bof and not rs.eof
		if strType = "N" then
			response.write("<b><a href='names.asp?strGenus=" & rs("CorrectForm") & "'>" & rs("CorrectForm") & "</a></b><br><br>")
		else
			response.write("<b><a href='names.asp?strEpithet=" & rs("CorrectForm") & "'>" & rs("CorrectForm") & "</a></b><br><br>")
		end if
		rs.movenext
	loop

	else
		response.write("No records found; click ")
		response.write("<a href='IndexFungorumAdd.asp'>here</a> to submit a new record<br>")
	end if
	rs.close
	set rs = nothing
	dbConn.close
	set dbConn = nothing
end sub

sub DisplayRes
	dim strSQL, dbConn, rs
	if strSearch = "" then exit sub
	Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
	if true then        
       strConn = GetConnectionString()
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "192.168.0.3" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_WEBSERVER;Initial Catalog=IndexFungorum;Data Source=webserver"
	   dbConn.open strConn
	elseif strIP = "194.203.77.76" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_BIOSCIENCEWSRVR;Initial Catalog=IndexFungorum;Data Source=biosciencewsrvr"
	   dbConn.open strConn
	elseif strIP = "194.131.255.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_BIOSCIENCEWSRVR;Initial Catalog=IndexFungorum;Data Source=biosciencewsrvr"
	   dbConn.open strConn
	elseif strIP = "202.27.240.46" then
		strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_Devserver01;Initial Catalog=IndexFungorum;Data Source=Devserver01"
	   dbConn.open strConn
	elseif strIP = "192.168.0.1" then
	   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\cabi\cabilink.mdb"
	   dbConn.open strConn
	elseif strIP = "127.0.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=cabilink"
	end if
	if strType = "N" then
	strSQL = "SELECT TOP 6000 IndexFungorum.[NAME OF FUNGUS], IndexFungorum.[MISAPPLICATION AUTHORS], IndexFungorum.AUTHORS, " _
		& "IndexFungorum.[CURRENT NAME], IndexFungorum.[CURRENT NAME RECORD NUMBER], IndexFungorum.[YEAR OF PUBLICATION], " _
		& "IndexFungorum.[RECORD NUMBER], IndexFungorum.[GSD FLAG], IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER], " _
		& "FundicClassification.[Family name], FundicClassification.TeleomorphLink, " _
		& "FundicClassification.[Order name], FundicClassification.[Subclass name], FundicClassification.[Class name], " _
		& "FundicClassification.[Phylum name], FundicClassification.[Kingdom name], FundicClassification.AnamorphType, " _
		& "FundicClassification_1.[Family name] AS CurrentFamily, FundicClassification_1.TeleomorphLink AS CurrentTeleomorphLink, " _
		& "FundicClassification_1.[Order name] AS CurrentOrder, FundicClassification_1.[Subclass name] AS CurrentSubclass, " _
		& "FundicClassification_1.[Class name] AS CurrentClass, FundicClassification_1.[Phylum name] AS CurrentPhylum, " _
		& "FundicClassification_1.[Kingdom name] AS CurrentKingdom, FundicClassification_1.AnamorphType AS CurrentAnamorphType " _
		& "FROM (IndexFungorum LEFT JOIN FundicClassification " _
		& "ON IndexFungorum.[NAME OF FUNGUS FUNDIC RECORD NUMBER] = FundicClassification.[Fundic Record Number]) " _
		& "LEFT JOIN FundicClassification AS FundicClassification_1 " _
		& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = FundicClassification_1.[Fundic Record Number] " _
		& "WHERE (((IndexFungorum.[NAME OF FUNGUS]) Like '" & protectSQL(strSearch, false) & "%')) "
		if strOpen <> "OK" then
			strSQL = strSql & "AND (((IndexFungorum.[STS FLAG]) Is Null)) ORDER BY IndexFungorum.[NAME OF FUNGUS];"
		else
			strSQL = strSql & "ORDER BY IndexFungorum.[NAME OF FUNGUS];"
		end if
	elseif strType = "E" then
	strSQL = "SELECT TOP 6000 IndexFungorum.[SPECIFIC EPITHET], IndexFungorum.[MISAPPLICATION AUTHORS], IndexFungorum.[NAME OF FUNGUS], " _
		& "IndexFungorum.AUTHORS, IndexFungorum.[YEAR OF PUBLICATION], IndexFungorum.[CURRENT NAME], IndexFungorum.[GSD FLAG], " _
		& "IndexFungorum.[RECORD NUMBER], IndexFungorum.[CURRENT NAME RECORD NUMBER], IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER], " _
		& "FundicClassification.[Family name], FundicClassification.TeleomorphLink, FundicClassification.[Order name], " _
		& "FundicClassification.[Subclass name], FundicClassification.[Class name], FundicClassification.[Phylum name], " _
		& "FundicClassification.[Kingdom name], FundicClassification.AnamorphType, " _
		& "FundicClassification_1.[Family name] AS CurrentFamily, " _
		& "FundicClassification_1.[Order name] AS CurrentOrder, FundicClassification_1.[Subclass name] AS CurrentSubclass, " _
		& "FundicClassification_1.[Class name] AS CurrentClass, FundicClassification_1.[Phylum name] AS CurrentPhylum, " _
		& "FundicClassification_1.[Kingdom name] AS CurrentKingdom, FundicClassification_1.AnamorphType AS CurrentAnamorphType, " _
		& "FundicClassification_1.TeleomorphLink AS CurrentTeleomorphLink " _
		& "FROM (IndexFungorum LEFT JOIN FundicClassification " _
		& "ON IndexFungorum.[NAME OF FUNGUS FUNDIC RECORD NUMBER] = FundicClassification.[Fundic Record Number]) " _
		& "LEFT JOIN FundicClassification AS FundicClassification_1 " _
		& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = FundicClassification_1.[Fundic Record Number] " _
		& "WHERE (((IndexFungorum.[SPECIFIC EPITHET]) Like '" & protectSQL(strSearch,true) & "%')) " _
		& "OR (((IndexFungorum.[INFRASPECIFIC EPITHET]) Like '" & protectSQL(strSearch,true) & "%')) " _
		& "ORDER BY IndexFungorum.[SPECIFIC EPITHET], IndexFungorum.[NAME OF FUNGUS];"
   	elseif strType = "G" then
	strSQL = "SELECT TOP 6000 IndexFungorum.[NAME OF FUNGUS], IndexFungorum.[MISAPPLICATION AUTHORS], IndexFungorum.AUTHORS, " _
		& "IndexFungorum.[CURRENT NAME], IndexFungorum.[CURRENT NAME RECORD NUMBER], IndexFungorum.[YEAR OF PUBLICATION], " _
		& "IndexFungorum.[GSD FLAG], IndexFungorum.[RECORD NUMBER], IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER], " _
		& "FundicClassification.[Family name], FundicClassification.TeleomorphLink, FundicClassification.[Order name], " _
		& "FundicClassification.[Subclass name], FundicClassification.[Class name], FundicClassification.[Phylum name], " _
		& "FundicClassification.[Kingdom name], FundicClassification.AnamorphType, " _
		& "FundicClassification_1.[Family name] AS CurrentFamily, " _
		& "FundicClassification_1.[Order name] AS CurrentOrder, FundicClassification_1.[Subclass name] AS CurrentSubclass, " _
		& "FundicClassification_1.[Class name] AS CurrentClass, FundicClassification_1.[Phylum name] AS CurrentPhylum, " _
		& "FundicClassification_1.[Kingdom name] AS CurrentKingdom, FundicClassification_1.AnamorphType AS CurrentAnamorphType, " _
		& "FundicClassification_1.TeleomorphLink AS CurrentTeleomorphLink " _
		& "FROM (IndexFungorum LEFT JOIN FundicClassification " _
		& "ON IndexFungorum.[NAME OF FUNGUS FUNDIC RECORD NUMBER] = FundicClassification.[Fundic Record Number]) " _
		& "LEFT JOIN FundicClassification AS FundicClassification_1 " _
		& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = FundicClassification_1.[Fundic Record Number] " _
		& "WHERE (((IndexFungorum.[NAME OF FUNGUS]) Like '" & protectSQL(strSearch, false) & "%') AND ((IndexFungorum.[GSD FLAG]) Is Not Null)) " _
		& "ORDER BY IndexFungorum.[NAME OF FUNGUS];"
  else
	exit sub
  end if
	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.Open strSql, dbConn, 3
	if not rs.bof then
		rs.pagesize = intPageSize
		rs.movelast
		rs.movefirst
		intNumRecords = rs.recordcount
		intPageCount = rs.pagecount
		ResList(rs)
	else
		OrthVar
	end if
	rs.close
	set rs = nothing
	dbConn.close
	set dbConn = nothing
end sub
%>
<!-- InstanceEndEditable --><!-- InstanceBeginEditable name="Main" --> 
            <form method="post" action="file:///C|/Dreamweaver/IndexFungorum/Names/Names.asp" name="search">
              <table width="390" border="0" name="Name" height="60">
                <tr> 
                  <td colspan="4"><b>Search by:-</b></td>
                  <td colspan="3" align="right"> 
<%
if strNumRecords = "" then
	dim strSQL, dbConn, rs, strConn, strNumRecords
	Set dbConn = Server.CreateObject("ADODB.Connection")

	strIP = request.servervariables("LOCAL_ADDR")
	if true then        
       strConn = GetConnectionString()
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "192.168.0.3" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_WEBSERVER;Initial Catalog=IndexFungorum;Data Source=webserver"
	   dbConn.open strConn
	elseif strIP = "194.203.77.76" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_BIOSCIENCEWSRVR;Initial Catalog=IndexFungorum;Data Source=biosciencewsrvr"
	   dbConn.open strConn
	elseif strIP = "194.131.255.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_BIOSCIENCEWSRVR;Initial Catalog=IndexFungorum;Data Source=biosciencewsrvr"
	   dbConn.open strConn
	elseif strIP = "202.27.240.46" then
		strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_Devserver01;Initial Catalog=IndexFungorum;Data Source=Devserver01"
	   dbConn.open strConn
	elseif strIP = "192.168.0.1" then
	   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\cabi\cabilink.mdb"
	   dbConn.open strConn
	elseif strIP = "127.0.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=cabilink"
	end if

	if strIP = "192.168.0.3" then
		strSQL = "SELECT [sysindexes].[rows] FROM [sysindexes] WHERE [sysindexes].[name] = 'PK_IndexFungorum';"
		Set rs = Server.CreateObject("ADODB.Recordset")
			rs.Open strSql, dbConn, 3
       		strNumRecords = rs("rows")
	elseif strIP = "194.131.255.4" then
		strSQL = "SELECT [sysindexes].[rows] FROM [sysindexes] WHERE [sysindexes].[name] = 'PK_IndexFungorum';"
		Set rs = Server.CreateObject("ADODB.Recordset")
			rs.Open strSql, dbConn, 3
       		strNumRecords = rs("rows")
	else
		strSQL = "SELECT IndexFungorum.[RECORD NUMBER] FROM IndexFungorum;"
		Set rs = Server.CreateObject("ADODB.Recordset")
			rs.Open strSql, dbConn, 3
       		rs.movelast
       		rs.movefirst
       		strNumRecords = rs.recordcount
	end if
	   response.write("<b><font color='#339900'>" & strNumRecords & "</font></b> records on-line")
end if
%>
			 &nbsp;</td>
                </tr>
                <tr> 
                  <td width="40"><b>Name</b></td>
                  <td width="46"><b>Epithet</b></td>
                  <td colspan="2">&nbsp;</td>
                  <td colspan="3"><b>Enter a search term:-</b></td>
                </tr>
                <tr> 
                  <td width="40"><input type="radio" name="SearchBy" value="Name" <%if strType <> "E" then response.write("checked")%>></td>
                  <td width="46"> <div align="left"> 
                      <input type="radio" name="SearchBy" value="epithet" <%if strType= "E" then response.write("checked")%>>
                    </div></td>
                  <td colspan="2"> <div align="left"> </div></td>
                  <td width="190" valign="bottom"> 
                    <input type="text" name="SearchTerm" size="30" <%response.write("value=" & chr(34) & strSearch & chr(34))%>			  onKeyDown="if ((event.which && event.which == 13)
                      || (event.keyCode && event.keyCode == 13)) {
                    this.form.submit.click();
                    return false;
                  }
                  else return true;">
                  </td>
                  <td width="80" valign="middle"><input type="submit" name="submit" value="Search">
                  </td>
                </tr>
              </table>
      </form>
<% 
	GetNav
	DisplayRes
%>
<!-- InstanceEndEditable --></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td height="10" class="Footer">
	  <hr noshade>
      &copy; 
      2004 <a href=javascript:popUp("../Names/IndexFungorumPartnership.htm")>Index Fungorum Partnership</a>. 
      Return to <a href="file:///C|/Dreamweaver/IndexFungorum/Index.htm">main page</a>. Return to <a href="#TopOfPage">top 
      of page</a>.</td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
