<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/TemplSF.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Species Fungorum - Search Page</title>
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
<script type="text/javascript">
<!--
var d = new Date();
var curr_year = d.getFullYear();
//-->
</script>
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
<!--#include file="../Connections/DataAccess.asp"-->
<!--#include file="../Helpers/Utility.asp"-->
</head> 
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCFFCC">
<a name="TopOfPage"></a> 
<table width="100%" height="100%" class="mainbody">
  <tr>
    <td height="105"> 
      <table width="100%" border="0" class="mainbody">
        <tr> 
          <td width="50%" class="h1"> <img src="../IMAGES/LogoSF.gif" alt="Index Fungorum - Species Fungorum" width="100" height="100">&nbsp;Species 
            Fungorum</td>
          <td valign="top"> <table height="100%" align="center">
              <tr class="mainbody"> 
                <td><a href="Names.asp" onMouseOver="MM_displayStatusMsg('Search Species Fungorum');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Species Fungorum</a> : <font color="#FF0000"><strong><a href=javascript:popUp("SpeciesFungorumCookies.htm") onMouseOver="MM_displayStatusMsg('Cookies');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Cookies</a></strong></font></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="../BSM/bsm.asp" onMouseOver="MM_displayStatusMsg('Search Bibliography of Systematic Mycology');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Bibliography of Systematic Mycology</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="Fundic.asp" onMouseOver="MM_displayStatusMsg('Search Dictionary of the Fungi Hierarchy');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Dictionary of the Fungi Hierarchy</a></td>
              </tr>
              <tr class="mainbody"> 
                <td>&nbsp; </td>
              </tr>
              <tr class="mainbody"> 
                <td>&nbsp;</td>
              </tr>
              <tr class="mainbody"> 
                <td>&nbsp;</td>
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
	dim strSearch, strType, intPageNumber, intNumRecords, intPageSize, intPageCount, strOpen, strOrder, strFamily, strGenus
	SERVER.SCRIPTTIMEOUT = 180
	intPageSize = 200
	strSearch = session("strSearch")
	strType = session("strType")
	strGenus = session("strGenus")
	strOrder = session("strOrder")
	strFamily = session("strFamily")
	if request.form.item("Submit") <> "" then
		if request.form.item("SearchTerm") <> ""  then
			'trap single quote
			strSearch = replace(request.form.item("SearchTerm"),"'","")
			' right trim
			strSearch = rtrim(strSearch)
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
'		if request.querystring.item("GSD") <> "" then strType = "N"
	end if
	if request.querystring.item("strEpithet") <> "" then
		strSearch = request.querystring.item("strEpithet")
		session("strSearch") = strSearch
		strType = "E"
		session("strType") = strType
		intPageNumber = "1"
		session("intPageNumber") = intPageNumber
	end if

if request.form.item("Submit") = "View Orders" then
	intPageNumber = "1"
	session("intPageNumber") = intPageNumber
	strType = "OS"
	session("strType") = strType
	strGenus = ""
	session("strGenus") = ""
elseif request.querystring.item("RecordID") <> "" then
	intPageNumber = "1"
	strType = request.querystring.item("Type")
	session("strType") = strType
	select case strType
		case "O"
		strOrder = request.querystring.item("RecordID")
		session("strOrder") = strOrder
		case "F"
		strFamily = request.querystring.item("RecordID")
		session("strFamily") = strFamily
		case "G"
		strGenus = request.querystring.item("RecordID")
		session("strGenus") = strGenus
	end select
end if




' back door for all records	
	if request.querystring.item("P") = "PMK" then
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
			response.write("<a href='" & frm & ".asp?pg=" & intPageNumber + 1 & "'>[Next &gt;&gt;]</a> ")
		end if
		response.write(" <b>of " & intNumRecords & " records.</b>")
		response.write(" <a class='LinkColour1a' href='#TopOfPage'>TofP</a> <a class='LinkColour1a' href='#BottomOfPage'>BofP</a></p>")
	else
		response.write("<p>" & intNumRecords & " records</p>")
	end if
end sub

sub ResList (rs)
	dim strLink, strLinkType, i
	rs.absoluteposition=((intPageNumber-1) * intPageSize) +1
	if strType = "E" or strType = "N" then
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
	
			if rs("RECORD NUMBER") = rs("CURRENT NAME RECORD NUMBER") then
				strLink = "GSDSpecies.asp?RecordID=" & server.urlencode(rs("RECORD NUMBER"))
				response.write("<a class='LinkColour" & strLinkType & "' href=" & strLink & " >" & rs("NAME OF FUNGUS") & "</a>")
			else
				strLink = "NamesRecord.asp?RecordID=" & server.urlencode(rs("RECORD NUMBER"))
				response.write("<a class='LinkColour" & strLinkType & "' href=" & strLink & " >" & rs("NAME OF FUNGUS") & "</a>")
			end if
			if rs("AUTHORS") <> "" then
				response.write(" " & encodeHtml(rs("AUTHORS")))
			else
		' ONLY TAKE TEXT BEFORE ";"
				if rs("MISAPPLICATION AUTHORS") <> "" then
					if instr(rs("MISAPPLICATION AUTHORS"),"; fide") then
						response.write(" sensu " & encodeHtml(left(rs("MISAPPLICATION AUTHORS"),instr(rs("MISAPPLICATION AUTHORS"),"; fide")-1)))
					else
						response.write(" sensu " & encodeHtml(rs("MISAPPLICATION AUTHORS")))
					end if
				end if
			end if
			if rs("YEAR OF PUBLICATION") <> "" then
				response.write(" (" & rs("YEAR OF PUBLICATION") & ")")
			end if
			if rs("NAME OF FUNGUS") <> rs("CURRENT NAME") and rs("CURRENT NAME") <> "" then
				if left(rs("GSD FLAG"),3) = "GSD" then
					strLink = "GSDSpecies.asp?RecordID=" & rs("CURRENT NAME RECORD NUMBER")
				else
					strLink = "GSDSpecies.asp?RecordID=" & rs("CURRENT NAME RECORD NUMBER")
				end if
				response.write(", (= ")
				strLinkType = 4
				response.write("<a class='LinkColour" & strLinkType & "' href=" & strLink & " >" & rs("CURRENT NAME") & "</a>)")
			end if
'			if rs("GSD FLAG") <> "" then
'				if rs("GSD FLAG") = "RSD" then
'					response.write(", [RSD]")
'				else
'					response.write(", [GSD]")
'				end if
'			end if
			parenttaxon = ""
			' determine whether name has a current name to assign appropriate parent taxon
			if rs("CURRENT NAME") <> "" then
			' it's got a current name so get the parent linked to this name
				strData = (rs("CurrentAnamorphType"))
				if strData = "hyphomycetous anamorph" or strData = "coelomycetous anamorph" then
					if rs("CurrentTeleomorphLink") <> "" then
						strData = rtrim(left(rs("CurrentTeleomorphLink"),instr(rs("CurrentTeleomorphLink")," ")))
						strRecordID = right(rs("CurrentTeleomorphLink"),5)
						if right(strData,5) = "aceae" then
							strLink = "familyrecord.asp?strRecordID=" & strRecordID
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
							strRecordID = right(rs("CurrentTeleomorphLink"),5)
							if right(strData,5) = "aceae" then
								strLink = "familyrecord.asp?strRecordID=" & strRecordID
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
							strRecordID = right(rs("TeleomorphLink"),5)
							if right(strData,5) = "aceae" then
								strLink = "familyrecord.asp?strRecordID=" & strRecordID
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
					elseif instr(rs("Phylum name"),"Fossil") then
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
	
	else
		'response.write("<p></p>session variables " & strType & " " & strSearch & strGenus & "</b><br>")
		select case strType
		case "G" 
			response.write("<p></p><b>Genus, Family, Order</b><p></p>") 
			for i = 1 to rs.PageSize
			if rs.eof then exit for
			if rs.bof then exit for 
			strGenus = rs("Genus name")
			strLink = "Names.asp?strGenus=" & server.urlencode(strGenus) & "&GSD=Yes"
			response.write("<a href=" & strLink &  " >" & strGenus & "</a>, ")
			if rs("family name") <> "" then
				strFamily = rs("family name")
				strLink = "Names.asp?RecordID=" & server.urlencode(strFamily) & "&Type=F"
				response.write("<a href=" & strLink &  " >" & strFamily & "</a>, ")
			else
				strFamily = "not assigned"
			end if
			if rs("order name") <> "" then
				strOrder = rs("order name")
				strLink = "Names.asp?RecordID=" & server.urlencode(strOrder) & "&Type=O"
				response.write("<a href=" & strLink &  " >" & strOrder & "</a>, ")
			else
				strOrder = "not assigned"
			end if
			session("strGenus") = strGenus
			session("strFamily") = strFamily
			session("strOrder") = strOrder
			rs.Movenext
			response.write("<br>")
			next
		case "OS" 
			response.write("<p></p><b>Orders</b><br>") 
			for i = 1 to rs.PageSize
			if rs.eof then exit for
			if rs.bof then exit for
			strLink = "Names.asp?RecordID=" & server.urlencode(rs("Order name")) & "&Type=O" 
			response.write("<a href=" & strLink &  " >" & rs("Order name") & "</a>")
			rs.Movenext
			response.write("<br>")
			next
		case "O" 
			response.write("<p></p><b>Families<br> in Order " & strOrder & "</b><br>") 
			for i = 1 to rs.PageSize
			if rs.eof then exit for
			if rs.bof then exit for
			if isnull(rs("family name")) then 
				strOut = "not assigned"
			else
				strOut = rs("family name")
			end if
			strLink = "Names.asp?RecordID=" & server.urlencode(strOut) & "&Type=F"
			response.write("<a href=" & strLink &  " >" & strOut & "</a>")
			rs.Movenext
			response.write("<br>")
			next
		case "F" 
			response.write("<p></p><b>Genera<br> in Family " & strFamily & ",<br> in Order " & strOrder  & "</b><br>") 
			for i = 1 to rs.PageSize
			if rs.eof then exit for
			if rs.bof then exit for
			if not isnull(rs("genus name")) then 
				strGenus = rs("Genus name")
				strLink = "Names.asp?strGenus=" & server.urlencode(strGenus) & "&GSD=Yes"
				response.write("<a href=" & strLink & " >" & strGenus & "</a> ")
			end if
			rs.Movenext
			response.write("<br>")
			next
		end select
	
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
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "10.0.5.10" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "202.27.240.46" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_Devserver01;Initial Catalog=IndexFungorum;Data Source=Devserver01"
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "192.168.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\cabi\cabilink.mdb"
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "127.0.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=cabilink"
	end if
	if strType = "N" then
	strSQL = "SELECT IndexFungorum.[NAME OF FUNGUS], IndexFungorum.[MISAPPLICATION AUTHORS], IndexFungorum.AUTHORS, " _
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
		& "WHERE (((IndexFungorum.[NAME OF FUNGUS]) Like '" & protectSQL(strSearch, false) & "%') " _
		& "AND ((IndexFungorum.[CURRENT NAME]) Is Not Null) AND ((IndexFungorum.[STS FLAG]) Is Null)) " _
		& "ORDER BY IndexFungorum.[NAME OF FUNGUS], IndexFungorum.[YEAR OF PUBLICATION];"
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
		& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = FundicClassification_1.[Fundic Record Number] "
		if strOpen <> "OK" then
			strSQL = strSql & "WHERE (((IndexFungorum.[CURRENT NAME]) Is Not Null) " _
				& "AND ((IndexFungorum.[SPECIFIC EPITHET]) Like '" & protectSQL(strSearch, false) & "%') AND ((IndexFungorum.[STS FLAG]) Is Null)) " _
				& "OR (((IndexFungorum.[CURRENT NAME]) Is Not Null) " _
				& "AND ((IndexFungorum.[INFRASPECIFIC EPITHET]) Like '" & protectSQL(strSearch, false) & "%') AND ((IndexFungorum.[STS FLAG]) Is Null)) " _
				& "ORDER BY IndexFungorum.[SPECIFIC EPITHET], IndexFungorum.[NAME OF FUNGUS], IndexFungorum.[YEAR OF PUBLICATION];"
		else
			strSQL = strSql & "(((IndexFungorum.[CURRENT NAME]) Is Not Null) AND ((IndexFungorum.[SPECIFIC EPITHET]) Like '" & protectSQL(strSearch, false) & "%')) " _
				& "OR (((IndexFungorum.[CURRENT NAME]) Is Not Null) AND ((IndexFungorum.[INFRASPECIFIC EPITHET]) Like '" & protectSQL(strSearch, false) & "%')) " _
				& "ORDER BY IndexFungorum.[SPECIFIC EPITHET], IndexFungorum.[NAME OF FUNGUS], IndexFungorum.[YEAR OF PUBLICATION];"
		end if
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
		& "ORDER BY IndexFungorum.[NAME OF FUNGUS], IndexFungorum.[YEAR OF PUBLICATION];"

	elseif strType <> "Z" then
	select case strType
	case "G"
		strSQL = "SELECT DISTINCT FundicClassification.[Fundic Record Number], FundicClassification.[Genus name], " _
		& "FundicClassification.[Family name], FundicClassification.[Order name] " _
		& "FROM IndexFungorum INNER JOIN FundicClassification " _
		& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = FundicClassification.[Fundic Record Number] " _
		& "WHERE (((FundicClassification.[Genus name]) Like '" & protectSQL(strGenus, false) & "%') AND ((IndexFungorum.[GSD FLAG]) Like 'GSD%')) " _
		& "ORDER BY FundicClassification.[Genus name];"
	case "OS" 
		strSQL = "SELECT DISTINCT FundicClassification.[Order name] " _
		& "FROM IndexFungorum INNER JOIN FundicClassification " _
		& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = FundicClassification.[Fundic Record Number] " _
		& "WHERE (((IndexFungorum.[GSD FLAG]) Like 'GSD%')) " _
		& "ORDER BY FundicClassification.[Order name];"
	case "O"
		strSql = "SELECT DISTINCT FundicClassification.[Family name], FundicClassification.[Order name] " _
		& "FROM IndexFungorum INNER JOIN FundicClassification " _
		& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = FundicClassification.[Fundic Record Number] " _
		& "WHERE (((FundicClassification.[Order name])='" & protectSQL(strOrder, false) & "') AND ((IndexFungorum.[GSD FLAG]) Like 'GSD%')) " _
		& "ORDER BY FundicClassification.[Family name];"
	case "F"
		strSql = "SELECT DISTINCT FundicClassification.[Order name], " _
		& "FundicClassification.[Family name], " _
		& "FundicClassification.[Genus name], " _
		& "FundicClassification.[Fundic Record Number] " _
		& "FROM IndexFungorum INNER JOIN FundicClassification " _
		& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = FundicClassification.[Fundic Record Number] " _
		& "WHERE "
		if strOrder <> "not assigned" then
			strSql = strSql & "(((FundicClassification.[Order name])='" & protectSQL(strOrder, false) & "')) and "
		else
			strSql = strSql & "((FundicClassification.[Order name]) is null) and "
		end if
		if strFamily <> "not assigned" then
			strSql = strSQL & "(((FundicClassification.[Family name])='" & protectSQL(strFamily, false) & "'))"
		else
			strSql = strSql & "((FundicClassification.[Family name]) is null) "
		end if
		strSql = strSql & "ORDER BY FundicClassification.[Genus name];"
	case else
		exit sub
	end select


  else
response.write("it failed the SQL case " & strSQL & "why?")
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
		response.write("There are no records - check Index Fungorum for nomenclatural data on " & strSearch & " " & strType)
	end if
end sub
%>
<!-- InstanceEndEditable --><!-- InstanceBeginEditable name="Main" --> 
            <form method="post" action="Names.asp" name="search">
              <table width="582" border="0" name="Name" height="60">
                <tr> 
                  <td colspan="4"><b>Search by:-</b></td>
                  <td colspan="3" align="right"> <%
if strNumRecords = "" then
	dim strSQL, dbConn, rs, strConn, strNumRecords, strIP, strRemoteIP
	Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
	if true then        
       strConn = GetConnectionString()
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "192.168.0.3" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_WEBSERVER;Initial Catalog=IndexFungorum;Data Source=webserver"
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "10.0.5.10" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "202.27.240.46" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_Devserver01;Initial Catalog=IndexFungorum;Data Source=Devserver01"
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "192.168.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\cabi\cabilink.mdb"
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "127.0.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=cabilink"
	end if

		strSQL = "SELECT DISTINCT IndexFungorum.[CURRENT NAME] " _
			& "FROM IndexFungorum " _
			& "WHERE (((IndexFungorum.[CURRENT NAME]) Like '% %' " _
			& "And (IndexFungorum.[CURRENT NAME]) Not Like '% % %'));"
		Set rs = Server.CreateObject("ADODB.Recordset")
			rs.Open strSql, dbConn, 3
       		rs.movelast
       		rs.movefirst
       		strNumRecords = rs.recordcount
		response.write("<b><font color='#339900'>" & strNumRecords & "</font></b> species included")
end if
%> 
                  </td>
                </tr>
                <tr> 
                  <td width="38"><b>Name</b></td>
                  <td width="46"><b>Epithet</b></td>
                  <td colspan="2">&nbsp;</td>
                  <td width="174"><b>Enter a search term:-</b></td>
                  <td width="193" align="right">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="38"><input type="radio" name="SearchBy" value="Name" <%if strType <> "E" then response.write("checked")%>></td>
                  <td width="46"> <div align="left"> 
                      <input type="radio" name="SearchBy" value="epithet" <%if strType = "E" then response.write("checked")%>>
                    </div></td>
                  <td colspan="2"> <div align="left">
                      <input type="submit" name="Submit" value="View Orders">
                    </div></td>
                  <td colspan="2" valign="bottom"> <input type="text" name="SearchTerm" size="45" <%response.write("value=" & chr(34) & strSearch & chr(34))%>			  onKeyDown="if ((event.which && event.which == 13)
                      || (event.keyCode && event.keyCode == 13)) {
                    this.form.submit.click();
                    return false;
                  }
                  else return true;"> <input type="submit" name="submit" value="Search"> 
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
<font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#333333">
&copy;
<script>
document.write(curr_year);
</script>
<a href=javascript:popUp("../Names/IndexFungorumPartnership.htm")>Species 
      Fungorum</a>. Return to <a href="../Index.htm">main page</a>. Return to 
      <a href="#TopOfPage">top of page</a>.</td>
  </tr>
</table>
<a name="BottomOfPage"></a>
</body>
<!-- InstanceEnd --></html>
