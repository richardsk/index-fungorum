
<!--#include file="../Connections/DataAccess.asp"-->
<%
dim strType, strSearchName, intTaxonID, strTaxon, strRank, strText, strSQL, dbConn, RS, strTruncation, strOut
dim intSkip, intLimit
SERVER.SCRIPTTIMEOUT = 300

if request.querystring.item("requesttype") <> "" then
	strType = request.querystring.item("requesttype")
else
	strType = ""
end if

strTruncation = ""

' response for Request Type 0
if strType = "0" then
' nothing to process

' response for Request Type 1
elseif strType = "1" then
	strSearchName = request.querystring.item("searchname")
		' detect if it's a CAS cache request
		if strSearchName = "*" or strSearchName = "%" then
			strType = "1a"
			intSkip = request.QueryString.item("skip") ' default value is "0" (start at begining)
			intLimit = request.QueryString.item("limit") ' default value is "-1" (return all names)
			' if intSkip is >0 then intLimit is set to last record = intSkip + intLimit
			if intLimit = "-1" then
				strTruncation = "true"
			else
				if intSkip = "0" then
					intLimit = clng(intLimit) + 1
				else
					intLimit = clng(intSkip) + clng(intLimit) + 1
				end if
			end if
			intSkip = clng(intSkip)



		' detect left hand truncation for normal request
		elseif left(strSearchName,1) = "*" or left(strSearchName,1) = "%" then 
			strTruncation = "true"
			strSearchName = replace(strSearchName,"*","")
			strSearchName = replace(strSearchName,"%","")
		end if

' response for Request Type 2
elseif strType = "2" then
	intTaxonID = request.querystring.item("taxonid")

' response for Request Type 3
elseif strType = "3" then
' nothing to process

' response for Request Type 4
elseif strType = "4" then
	strTaxon = request.querystring.item("taxon")
	strRank = left(strTaxon,1)
	if StrTaxon <> "" then strTaxon = right(strTaxon,len(strTaxon)-1)

' response for Request Type 5
elseif strType = "5" then
	strHighertaxon = request.querystring.item("Highertaxon")

end if

	if strType = "0" then
	'no SQL to define

	elseif strType = "1" then
		strSQL = "SELECT IndexFungorum.*, IndexFungorum_1.AUTHORS AS [CURRENT NAME AUTHORS], " _
			& "IndexFungorum_1.[SPECIFIC EPITHET] AS [CURRENT NAME SPECIFIC EPITHET] " _
			& "FROM IndexFungorum INNER JOIN IndexFungorum AS IndexFungorum_1 " _
			& "ON IndexFungorum.[CURRENT NAME RECORD NUMBER] = IndexFungorum_1.[RECORD NUMBER] " _
			& "WHERE (((IndexFungorum.[NAME OF FUNGUS]) Like '" & strSearchName & "%') AND ((IndexFungorum.[GSD FLAG]) = 'RSD')) " _
			& "ORDER BY IndexFungorum.[NAME OF FUNGUS];"

	elseif strType = "1a" then
' THIS WORKS WITH THE CUT DOWN RESPONSE
'		strSQL = "SELECT IndexFungorum.*, tblSkipLimit.ID, IndexFungorum_1.AUTHORS AS [CURRENT NAME AUTHORS], " _
'			& "IndexFungorum_1.[SPECIFIC EPITHET] AS [CURRENT NAME SPECIFIC EPITHET] " _
'			& "FROM tblSkipLimit INNER JOIN (IndexFungorum INNER JOIN IndexFungorum AS IndexFungorum_1 " _
'			& "ON IndexFungorum.[CURRENT NAME RECORD NUMBER] = IndexFungorum_1.[RECORD NUMBER]) " _
'			& "ON tblSkipLimit.RecordNumber = IndexFungorum.[RECORD NUMBER] " _
'			& "WHERE (((IndexFungorum.[NAME OF FUNGUS]) Like '%') " _
'			& "AND ((tblSkipLimit.ID)>0 And (tblSkipLimit.ID)<20)) " _
'			& "ORDER BY tblSkipLimit.ID;"

		strSQL = "SELECT IndexFungorum.*, tblSkipLimit.ID, IndexFungorum_1.AUTHORS AS [CURRENT NAME AUTHORS], " _
			& "IndexFungorum_1.[SPECIFIC EPITHET] AS [CURRENT NAME SPECIFIC EPITHET] " _
			& "FROM tblSkipLimit INNER JOIN (IndexFungorum INNER JOIN IndexFungorum AS IndexFungorum_1 " _
			& "ON IndexFungorum.[CURRENT NAME RECORD NUMBER] = IndexFungorum_1.[RECORD NUMBER]) " _
			& "ON tblSkipLimit.RecordNumber = IndexFungorum.[RECORD NUMBER] " _
			& "WHERE (((IndexFungorum.[NAME OF FUNGUS]) Like '%') " _
			& "AND ((tblSkipLimit.ID)>" & intSkip & " And (tblSkipLimit.ID)<" & intLimit & ")) " _
			& "ORDER BY tblSkipLimit.ID;"


	elseif strType = "2" then
	'get the current name
		strSQL = "SELECT IndexFungorum.*, FundicClassification.[Family name], Publications.pubIMIAbbr, " _
			& "Publications.pubIMISupAbbr, Publications.pubIMIAbbrLoc " _
			& "FROM (IndexFungorum LEFT JOIN FundicClassification " _
			& "ON IndexFungorum.[NAME OF FUNGUS FUNDIC RECORD NUMBER] = FundicClassification.[Fundic Record Number]) " _
			& "LEFT JOIN Publications ON IndexFungorum.[LITERATURE LINK] = Publications.pubLink " _
			& "WHERE (((IndexFungorum.[RECORD NUMBER]) = " & intTaxonID & "));"
	'get the synonyms
		strSQL1 = "SELECT IndexFungorum.*, FundicClassification.[Family name], Publications.pubIMIAbbr, " _
			& "Publications.pubIMISupAbbr, Publications.pubIMIAbbrLoc " _
			& "FROM (IndexFungorum LEFT JOIN FundicClassification " _
			& "ON IndexFungorum.[NAME OF FUNGUS FUNDIC RECORD NUMBER] = FundicClassification.[Fundic Record Number]) " _
			& "LEFT JOIN Publications ON IndexFungorum.[LITERATURE LINK] = Publications.pubLink " _
			& "WHERE (((IndexFungorum.[CURRENT NAME RECORD NUMBER]) = " & intTaxonID & ") AND ((IndexFungorum.[RECORD NUMBER]) <> " & intTaxonID & "));"

	elseif strType = "3" then
	'no SQL to define

	elseif strType = "4" then
	'need to determine if at bottom of hierarchy or top
	'probably needs something like G-Dimargaris, F-Dimargaritaceae etc
		if strRank = "G" then
			strSQL = "SELECT [FundicClassification].[Family name] " _
				& "FROM IndexFungorum INNER JOIN [FundicClassification] " _
				& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = [FundicClassification].[Fundic Record Number] " _
				& "WHERE (((IndexFungorum.[CURRENT NAME RECORD NUMBER]) = " & strTaxon & "));"
		elseif strRank = "F" then
			strSQL = "SELECT [FundicClassification].[Order name] " _
				& "FROM IndexFungorum INNER JOIN [FundicClassification] " _
				& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = [FundicClassification].[Fundic Record Number] " _
				& "WHERE (((IndexFungorum.[CURRENT NAME RECORD NUMBER]) = " & strTaxon & "));"
		elseif strRank = "O" then
			strSQL = "SELECT [FundicClassification].[Class name] " _
				& "FROM IndexFungorum INNER JOIN [FundicClassification] " _
				& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = [FundicClassification].[Fundic Record Number] " _
				& "WHERE (((IndexFungorum.[CURRENT NAME RECORD NUMBER]) = " & strTaxon & "));"
		elseif strRank = "C" then
			strSQL = "SELECT [FundicClassification].[Phylum name] " _
				& "FROM IndexFungorum INNER JOIN [FundicClassification] " _
				& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = [FundicClassification].[Fundic Record Number] " _
				& "WHERE (((IndexFungorum.[CURRENT NAME RECORD NUMBER]) = " & strTaxon & "));"
		elseif strRank = "P" then
			strSQL = "SELECT [FundicClassification].[Kingdom name] " _
				& "FROM IndexFungorum INNER JOIN [FundicClassification] " _
				& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = [FundicClassification].[Fundic Record Number] " _
				& "WHERE (((IndexFungorum.[CURRENT NAME RECORD NUMBER]) = " & strTaxon & "));"
		else
			'put in a string which will return no records
			strTaxon = 0
			strSQL = "SELECT [FundicClassification].[Kingdom name] " _
				& "FROM IndexFungorum INNER JOIN [FundicClassification] " _
				& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = [FundicClassification].[Fundic Record Number] " _
				& "WHERE (((IndexFungorum.[CURRENT NAME RECORD NUMBER]) = " & strTaxon & "));"
		end if

	elseif strType = "5" then
				if right(strHighertaxon,5) = "aceae" then
					strRank = "Family"
					strChildRank = "Genus"
				elseif right(strHighertaxon,4) = "ales" then
					strRank = "Order"
					strChildRank = "Family"
				elseif right(strHighertaxon,7) = "mycetes" then
					strRank = "Class"
					strChildRank = "Order"
				elseif right(strHighertaxon,6) = "mycota" then
					strRank = "Phylum"
					strChildRank = "Class"
				else
					strRank = "Kingdom"
					strChildRank = "Phylum"
				end if

		strSQL = "SELECT DISTINCT [FundicClassification].[" & strChildRank & " " & "name] " _
			& "FROM IndexFungorum INNER JOIN [FundicClassification] " _
			& "ON IndexFungorum.[CURRENT NAME FUNDIC RECORD NUMBER] = [FundicClassification].[Fundic Record Number] " _
			& "WHERE (((IndexFungorum.[GSD FLAG]) Like 'GSD%') " _
			& "AND (([FundicClassification].[" & strRank & " " & "name]) = '" & strHighertaxon & "')) " _
			& "OR (((IndexFungorum.[TAXONOMIC REFEREE]) Is Not Null) " _
			& "AND (([FundicClassification].[" & strRank & " " & "name]) = '" & strHighertaxon & "'));"

	else
	'no SQL to define

	end if

'TYPE 0 RESPONSE
		if strType = "0" then
			strText = chr(60) & "?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8"
			strText = strText & chr(34) & " ?" & chr(62)
			response.write(strText)
			strText = chr(60) & "!DOCTYPE XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "CDMVERSION" & chr(62) & "1.2" & chr(60) & "/CDMVERSION" & chr(62)
			response.write(strText)
			strText = chr(60) & "/XMLRESPONSE" & chr(62)
			response.write(strText)

'TYPE 1 RESPONSE
		elseif strType = "1" then
'		elseif strType = "1" or strType = "1a" then
		'trap null searchname
		if strSearchName <> "" then
		'cludge to prevent left hand trunctions
		if strTruncation <> "true" then
			Set dbConn = Server.CreateObject("ADODB.Connection")
			strIP = request.servervariables("LOCAL_ADDR")
			if true then        
               strConn = GetConnectionString()
	           dbConn.connectiontimeout = 180
	           dbConn.commandtimeout = 180
	           dbConn.open strConn
	        elseif strIP = "10.0.5.10" then
				strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
				dbConn.connectiontimeout = 300
				dbConn.commandtimeout = 300
				dbConn.open strConn
			elseif strIP = "127.0.0.1" then
				strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
				dbConn.connectiontimeout = 300
				dbConn.commandtimeout = 300
				dbConn.open strConn
			elseif strIP = "192.168.0.3" then
				strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_WEBSERVER;Initial Catalog=IndexFungorum;Data Source=webserver"
				dbConn.connectiontimeout = 300
				dbConn.commandtimeout = 300
				dbConn.open strConn
			else
				dbConn.open "FILEDSN=cabilink"
			end if
			Set RS = Server.CreateObject("ADODB.Recordset")
			RS.Open strSql, dbConn, 3

			strText = chr(60) & "?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8"
			strText = strText & chr(34) & " ?" & chr(62)
			response.write(strText)
			strText = chr(60) & "!DOCTYPE XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "TYPE1RESULT NUMBER=" & chr(34) & RS.RecordCount & chr(34) & chr(62)
			response.write(strText)

			if not RS.bof then
			do while not RS.eof
				'check if its an AVC or a synonym
				if RS("CURRENT NAME RECORD NUMBER") = RS("RECORD NUMBER") then
					strText = chr(60) & "SPECIESNAME IDENTIFIER=" & chr(34) & RS("RECORD NUMBER") & chr(34) & chr(62)
					response.write(strText)
					strText = chr(60) & "AVCNAME STATUS=" & chr(34) & "accepted" & chr(34) & chr(62)
					response.write(strText)
					strText = chr(60) & "NAME" & chr(62)
					response.write(strText)
					strText = chr(60) & "FULLNAME GENUS=" 
					strGenus = server.HTMLEncode(left(RS("NAME OF FUNGUS"),instr(RS("NAME OF FUNGUS")," ")-1))
					strText = strText & chr(34) & strGenus & chr(34) & " SPECIFICEPITHET="
					strText = strText & chr(34) & server.HTMLEncode(RS("SPECIFIC EPITHET")) & chr(34) & " AUTHORITY=" & chr(34)
					if RS("AUTHORS") <> "" then
						strText = strText & server.HTMLEncode(RS("AUTHORS")) & chr(34)
					else
						if RS("MISAPPLICATION AUTHORS") <> "" then
							strText = strText & "sensu " & server.HTMLEncode(RS("MISAPPLICATION AUTHORS")) & chr(34)
						else
							strText = strText & chr(34)
						end if
					end if
					strText = strText & " /" & chr(62)
					response.write(strText)
					strText = chr(60) & "/NAME" & chr(62)
					response.write(strText)
					strText = chr(60) & "/AVCNAME" & chr(62)
					response.write(strText)
					strText = chr(60) & "/SPECIESNAME" & chr(62)
					response.write(strText)
				else
					'its a synonym
					strText = chr(60) & "SPECIESNAME IDENTIFIER=" & chr(34) & RS("CURRENT NAME RECORD NUMBER") & chr(34) & chr(62)
					response.write(strText)
					strText = chr(60) & "SYNONYMWITHAVC" & chr(62)
					response.write(strText)
					strText = chr(60) & "SYNONYM INFRASPECIFICPORTION="
					if RS("INFRASPECIFIC EPITHET") <> "" then
						strText = strText & chr(34) & server.htmlencode(RS("INFRASPECIFIC RANK")) & " " & server.htmlencode(RS("INFRASPECIFIC EPITHET")) & chr(34)
					else
						strText = strText & chr(34) & chr(34)
					end if
					strText = strText & " STATUS=" & chr(34) & "synonym" & chr(34) & chr(62)
					response.write(strText)
					strText = chr(60) & "FULLNAME GENUS=" 
					strGenus = server.HTMLEncode(left(RS("NAME OF FUNGUS"),instr(RS("NAME OF FUNGUS")," ")-1))
					strText = strText & chr(34) & strGenus & chr(34) & " SPECIFICEPITHET="
					strText = strText & chr(34) & server.HTMLEncode(RS("SPECIFIC EPITHET")) & chr(34) & " AUTHORITY=" & chr(34)
					if RS("AUTHORS") <> "" then
						strText = strText & server.HTMLEncode(RS("AUTHORS")) & chr(34)
					else
						if RS("MISAPPLICATION AUTHORS") <> "" then
							strText = strText & "sensu " & server.HTMLEncode(RS("MISAPPLICATION AUTHORS")) & chr(34)
						else
							strText = strText & chr(34)
						end if
					end if
						strText = strText & " /" & chr(62)
					response.write(strText)
					strText = chr(60) & "/SYNONYM" & chr(62)
					response.write(strText)
					strText = chr(60) & "AVCNAME STATUS=" & chr(34) & "accepted" & chr(34) & chr(62)
					response.write(strText)
					strText = chr(60) & "NAME" & chr(62)
					response.write(strText)
					strText = chr(60) & "FULLNAME GENUS=" 
					strGenus = server.HTMLEncode(left(RS("CURRENT NAME"),instr(RS("CURRENT NAME")," ")-1))
					strText = strText & chr(34) & strGenus & chr(34) & " SPECIFICEPITHET="
					strText = strText & chr(34) & server.HTMLEncode(RS("CURRENT NAME SPECIFIC EPITHET")) & chr(34) & " AUTHORITY=" & chr(34)
					if RS("CURRENT NAME AUTHORS") <> "" then
						strText = strText & server.HTMLEncode(RS("CURRENT NAME AUTHORS")) & chr(34)
					else
						strText = strText & chr(34)
					end if
					strText = strText & " /" & chr(62)
					response.write(strText)
					strText = chr(60) & "/NAME" & chr(62)
					response.write(strText)
					strText = chr(60) & "/AVCNAME" & chr(62)
					response.write(strText)
					strText = chr(60) & "/SYNONYMWITHAVC" & chr(62)
					response.write(strText)
					strText = chr(60) & "/SPECIESNAME" & chr(62)
					response.write(strText)
				end if
			RS.Movenext
			loop
				'put in the last bits after the record set is completed
				strText = chr(60) & "/TYPE1RESULT" & chr(62)
				response.write(strText)
				strText = chr(60) & "/XMLRESPONSE" & chr(62)
				response.write(strText)
			else
				'put in the last bits where no records were found
				strText = chr(60) & "/TYPE1RESULT" & chr(62)
				response.write(strText)
				strText = chr(60) & "/XMLRESPONSE" & chr(62)
				response.write(strText)
			end if

			RS.close
			set RS = nothing
			dbConn.close
			set dbConn = nothing

		else
			strText = chr(60) & "?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8"
			strText = strText & chr(34) & " ?" & chr(62)
			response.write(strText)
			strText = chr(60) & "!DOCTYPE XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "TYPE1RESULT NUMBER=" & chr(34) & "0" & chr(34) & chr(62)
			response.write(strText)
			strText = chr(60) & "SPECIESNAME IDENTIFIER=" & chr(34) & "999999" & chr(34) & chr(62)
			response.write(strText)
			strText = chr(60) & "AVCNAME STATUS=" & chr(34) & "accepted" & chr(34) & chr(62)
			response.write(strText)
			strText = chr(60) & "NAME" & chr(62)
			response.write(strText)
			strText = chr(60) & "FULLNAME GENUS=" 
			strText = strText & chr(34) & "LEFT TRUNCATION NOT YET IMPLEMENTED BY THIS GSD" & chr(34) & " SPECIFICEPITHET="
			strText = strText & chr(34) & chr(34) & " AUTHORITY=" & chr(34) & chr(34)
			strText = strText & " /" & chr(62)
			response.write(strText)
			strText = chr(60) & "/NAME" & chr(62)
			response.write(strText)
			strText = chr(60) & "/AVCNAME" & chr(62)
			response.write(strText)
			strText = chr(60) & "/SPECIESNAME" & chr(62)
			response.write(strText)
			strText = chr(60) & "/TYPE1RESULT" & chr(62)
			response.write(strText)
			strText = chr(60) & "/XMLRESPONSE" & chr(62)
			response.write(strText)
		end if
		'rest of null searchname trap
		else
			strText = chr(60) & "?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8"
			strText = strText & chr(34) & " ?" & chr(62)
			response.write(strText)
			strText = chr(60) & "!DOCTYPE XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "TYPE1RESULT NUMBER=" & chr(34) & "0" & chr(34) & chr(62)
			response.write(strText)
			strText = chr(60) & "/TYPE1RESULT" & chr(62)
			response.write(strText)
			strText = chr(60) & "/XMLRESPONSE" & chr(62)
			response.write(strText)
		end if


'TYPE 1a RESPONSE
		elseif strType = "1a" then
		'trap null searchname
		if strSearchName <> "" then
		'cludge to prevent left hand trunctions
		if strTruncation <> "true" then
			Set dbConn = Server.CreateObject("ADODB.Connection")
			strIP = request.servervariables("LOCAL_ADDR")
			if true then        
               strConn = GetConnectionString()
	           dbConn.connectiontimeout = 180
	           dbConn.commandtimeout = 180
	           dbConn.open strConn
	        elseif strIP = "10.0.5.10" then
				strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
				dbConn.connectiontimeout = 300
				dbConn.commandtimeout = 300
				dbConn.open strConn
			elseif strIP = "127.0.0.1" then
				strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
				dbConn.connectiontimeout = 300
				dbConn.commandtimeout = 300
				dbConn.open strConn
			elseif strIP = "192.168.0.3" then
				strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_WEBSERVER;Initial Catalog=IndexFungorum;Data Source=webserver"
				dbConn.connectiontimeout = 300
				dbConn.commandtimeout = 300
				dbConn.open strConn
			else
				dbConn.open "FILEDSN=cabilink"
			end if
			Set RS = Server.CreateObject("ADODB.Recordset")
			RS.Open strSql, dbConn, 3

			strText = chr(60) & "?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8"
			strText = strText & chr(34) & " ?" & chr(62)
			response.write(strText)
			strText = chr(60) & "!DOCTYPE XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "TYPE1RESULT NUMBER=" & chr(34) & RS.RecordCount & chr(34) & chr(62)
			response.write(strText)

			if not RS.bof then
			do while not RS.eof
					strOut = RS("ID") & "; " & server.HTMLEncode(RS("NAME OF FUNGUS")) & "; " & RS("RECORD NUMBER")
					strText = chr(60) & "SPECIESNAME IDENTIFIER=" & chr(34) & strOut & chr(34) & chr(62)
					response.write(strText)
					strText = chr(60) & "/SPECIESNAME" & chr(62)
					response.write(strText)
			RS.Movenext
			loop
				'put in the last bits after the record set is completed
				strText = chr(60) & "/TYPE1RESULT" & chr(62)
				response.write(strText)
				strText = chr(60) & "/XMLRESPONSE" & chr(62)
				response.write(strText)
			else
				'put in the last bits where no records were found
				strText = chr(60) & "/TYPE1RESULT" & chr(62)
				response.write(strText)
				strText = chr(60) & "/XMLRESPONSE" & chr(62)
				response.write(strText)
			end if

			RS.close
			set RS = nothing
			dbConn.close
			set dbConn = nothing

		else
			strText = chr(60) & "?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8"
			strText = strText & chr(34) & " ?" & chr(62)
			response.write(strText)
			strText = chr(60) & "!DOCTYPE XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "TYPE1RESULT NUMBER=" & chr(34) & "0" & chr(34) & chr(62)
			response.write(strText)
			strText = chr(60) & "SPECIESNAME IDENTIFIER=" & chr(34) & "999999" & chr(34) & chr(62)
			response.write(strText)
			strText = chr(60) & "AVCNAME STATUS=" & chr(34) & "accepted" & chr(34) & chr(62)
			response.write(strText)
			strText = chr(60) & "NAME" & chr(62)
			response.write(strText)
			strText = chr(60) & "FULLNAME GENUS=" 
			strText = strText & chr(34) & "LEFT TRUNCATION NOT YET IMPLEMENTED BY THIS GSD" & chr(34) & " SPECIFICEPITHET="
			strText = strText & chr(34) & chr(34) & " AUTHORITY=" & chr(34) & chr(34)
			strText = strText & " /" & chr(62)
			response.write(strText)
			strText = chr(60) & "/NAME" & chr(62)
			response.write(strText)
			strText = chr(60) & "/AVCNAME" & chr(62)
			response.write(strText)
			strText = chr(60) & "/SPECIESNAME" & chr(62)
			response.write(strText)
			strText = chr(60) & "/TYPE1RESULT" & chr(62)
			response.write(strText)
			strText = chr(60) & "/XMLRESPONSE" & chr(62)
			response.write(strText)
		end if
		'rest of null searchname trap
		else
			strText = chr(60) & "?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8"
			strText = strText & chr(34) & " ?" & chr(62)
			response.write(strText)
			strText = chr(60) & "!DOCTYPE XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "TYPE1RESULT NUMBER=" & chr(34) & "0" & chr(34) & chr(62)
			response.write(strText)
			strText = chr(60) & "/TYPE1RESULT" & chr(62)
			response.write(strText)
			strText = chr(60) & "/XMLRESPONSE" & chr(62)
			response.write(strText)
		end if

' simple response to test things
	elseif strType = "2" then
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
		elseif strIP = "127.0.0.1" then
		   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
		   dbConn.open strConn
		elseif strIP = "192.168.0.3" then
		   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_WEBSERVER;Initial Catalog=IndexFungorum;Data Source=webserver"
		   dbConn.open strConn
		else
		   dbConn.open "FILEDSN=cabilink"
		end if
		Set RS = Server.CreateObject("ADODB.Recordset")
		RS.Open strSQL, dbConn, 3
		if not RS.bof then
			strText = chr(60) & "?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8"
			strText = strText & chr(34) & " ?" & chr(62)
			response.write(strText)
			strText = chr(60) & "!DOCTYPE XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "TYPE2RESULT" & chr(62)
			response.write(strText)

		' simple data output to test things
'			strText = chr(60) & "STANDARDDATA" & chr(62)
'			response.write(strText)
'				strOut = server.HTMLEncode(RS("NAME OF FUNGUS")) & "; " & RS("RECORD NUMBER")
'				strText = chr(60) & "SPECIESNAME IDENTIFIER=" & chr(34) & strOut & chr(34) & chr(62)
'				response.write(strText)
'				strText = chr(60) & "/SPECIESNAME" & chr(62)
'				response.write(strText)

					strText = chr(60) & "STANDARDDATA COMMENT=" & chr(34) & chr(34)
					if RS("Family name") <> "Incertae sedis" then
						strText = strText & " FAMILY=" & chr(34) & RS("Family name") & chr(34)
					else
						strText = strText & " FAMILY=" & chr(34) & chr(34)
					end if
					strText = strText & chr(62)
					response.write(strText)
					strText = chr(60) & "SCRUTINY PERSON=" & chr(34)
					if RS("TAXONOMIC REFEREE") <> "" then
						strText = strText & left(RS("TAXONOMIC REFEREE"),instr(RS("TAXONOMIC REFEREE"),"(")-2) & chr(34)
					else
						strText = strText & chr(34)
					end if
					strText = strText & " LINK=" & chr(34)
					if RS("INTERNET LINK") <> "" then strText = strText & replace(RS("INTERNET LINK"),"&","&amp;")
'					strText = strText & "http://www.cabi-publishing.org/bookshop/BookDisplay.asp?SubjectArea=&Subject=&PID=1529"
'					strText = strText & "INTERNET LINK"
'					strText = strText & "http://www.cabi-publishing.org/bookshop/BookDisplay.asp?SubjectArea=&Subject=&PID=1529"
					strText = strText & chr(34) & chr(62)
					response.write(strText)
					strText = chr(60) & "DATE YEAR=" & chr(34)
'					if RS("TAXONOMIC REFEREE") <> "" then
'						strText = strText & mid(RS("TAXONOMIC REFEREE"),instr(RS("TAXONOMIC REFEREE"),"(")+1,4) & chr(34) & " /" & chr(62)
						strText = strText & "TAXONOMIC REFEREE" & chr(34) & " /" & chr(62)
'					else
'						strText = strText & chr(34) & " /" & chr(62)
'					end if
					response.write(strText)
					strText = chr(60) & "/SCRUTINY" & chr(62)
					response.write(strText)
					strText = chr(60) & "OTHERLINK" & chr(62) 
					strText = strText & "http://www.speciesfungorum.org/Names/GSDspecies.asp?RecordID=" & RS("RECORD NUMBER")
					strText = strText & chr(60) & "/OTHERLINK" & chr(62) 
					response.write(strText)




		RS.close



		RS.Open strSQL1, dbConn, 3
		if not RS.bof then

			do while not RS.eof
				strOut = server.HTMLEncode(RS("NAME OF FUNGUS")) & "; " & RS("RECORD NUMBER")
				strText = chr(60) & "SPECIESNAME IDENTIFIER=" & chr(34) & strOut & chr(34) & chr(62)
				response.write(strText)
				strText = chr(60) & "/SPECIESNAME" & chr(62)
				response.write(strText)
			RS.Movenext
			loop

		end if



		'put in the last bits after the record set is completed
			strText = chr(60) & "/STANDARDDATA" & chr(62)
			response.write(strText)
			strText = chr(60) & "/TYPE2RESULT" & chr(62)
			response.write(strText)
			strText = chr(60) & "/XMLRESPONSE" & chr(62)
			response.write(strText)
		else
			'no records found so put out a response to say no record found
			strText = chr(60) & "?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8"
			strText = strText & chr(34) & " ?" & chr(62)
			response.write(strText)
			strText = chr(60) & "XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "TYPE2RESULT" & chr(62)
			response.write(strText)
			strText = chr(60) & "STANDARDDATA COMMENT=" & chr(34) & "no record found" & chr(34) & chr(62)
			response.write(strText)
			strText = chr(60) & "/STANDARDDATA" & chr(62)
			response.write(strText)
			strText = chr(60) & "/TYPE2RESULT" & chr(62)
			response.write(strText)
			strText = chr(60) & "/XMLRESPONSE" & chr(62)
			response.write(strText)
		end if
		RS.close
		set RS = nothing
		dbConn.close
		set dbConn = nothing







'TYPE 2 RESPONSE
	elseif strType = "9" then
		'trap null intTaxonID
'		if intTaxonID <> "" then
			Set dbConn = Server.CreateObject("ADODB.Connection")
			strIP = request.servervariables("LOCAL_ADDR")
			if strIP = "10.0.5.10" then
			   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
			   dbConn.open strConn
			elseif strIP = "127.0.0.1" then
			   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
			   dbConn.open strConn
			elseif strIP = "192.168.0.3" then
			   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_WEBSERVER;Initial Catalog=IndexFungorum;Data Source=webserver"
			   dbConn.open strConn
			else
			   dbConn.open "FILEDSN=cabilink"
			end if
			Set RS = Server.CreateObject("ADODB.Recordset")
			RS.Open strSql, dbConn, 3
			if not RS.bof then
				strText = chr(60) & "?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8"
				strText = strText & chr(34) & " ?" & chr(62)
				response.write(strText)
				strText = chr(60) & "!DOCTYPE XMLRESPONSE" & chr(62)
				response.write(strText)
				strText = chr(60) & "XMLRESPONSE" & chr(62)
				response.write(strText)
				strText = chr(60) & "TYPE2RESULT" & chr(62)
				response.write(strText)
				'output the standard data and output the AVC record
					strText = chr(60) & "STANDARDDATA COMMENT=" & chr(34) & chr(34)
					if RS("Family name") <> "Incertae sedis" then
						strText = strText & " FAMILY=" & chr(34) & RS("Family name") & chr(34)
					else
						strText = strText & " FAMILY=" & chr(34) & chr(34)
					end if
					strText = strText & chr(62)
					response.write(strText)
					strText = chr(60) & "SCRUTINY PERSON=" & chr(34)
					if RS("TAXONOMIC REFEREE") <> "" then
						strText = strText & left(RS("TAXONOMIC REFEREE"),instr(RS("TAXONOMIC REFEREE"),"(")-2) & chr(34)
					else
						strText = strText & chr(34)
					end if
					strText = strText & " LINK=" & chr(34)
					if RS("INTERNET LINK") <> "" then strText = strText & RS("INTERNET LINK")
					strText = strText & chr(34) & chr(62)
					response.write(strText)
					strText = chr(60) & "DATE YEAR=" & chr(34)
					if RS("TAXONOMIC REFEREE") <> "" then
						strText = strText & mid(RS("TAXONOMIC REFEREE"),instr(RS("TAXONOMIC REFEREE"),"(")+1,4) & chr(34) & " /" & chr(62)
					else
						strText = strText & chr(34) & " /" & chr(62)
					end if
					response.write(strText)
					strText = chr(60) & "/SCRUTINY" & chr(62)
					response.write(strText)
					strText = chr(60) & "OTHERLINK" & chr(62) 
					strText = strText & "http://www.speciesfungorum.org/Names/GSDspecies.asp?RecordID=" & RS("RECORD NUMBER")
					strText = strText & chr(60) & "/OTHERLINK" & chr(62) 
					response.write(strText)
					strText = chr(60) & "AVCNAMEWITHREFS" & chr(62)
					response.write(strText)
					strText = chr(60) & "AVCNAME" 
					strText = strText & " STATUS=" & chr(34) & "accepted"
					strText = strText & chr(34) & chr(62)
					response.write(strText)
					strText = chr(60) & "NAME" & chr(62)
					response.write(strText)
					strGenus = server.HTMLEncode(left(RS("NAME OF FUNGUS"),instr(RS("NAME OF FUNGUS")," ")-1))
					strText = chr(60) & "FULLNAME GENUS=" & chr(34) & strGenus & chr(34) & " SPECIFICEPITHET="
				' concatenate infraspecific epithet if present
					if RS("INFRASPECIFIC EPITHET") <> "" then
						strText = strText & chr(34) & server.HTMLEncode(RS("SPECIFIC EPITHET")) & " " & server.HTMLEncode(RS("INFRASPECIFIC rank")) & " " & server.HTMLEncode(RS("INFRASPECIFIC EPITHET")) & chr(34) & " AUTHORITY=" & chr(34)
					else
						strText = strText & chr(34) & server.HTMLEncode(RS("SPECIFIC EPITHET")) & chr(34) & " AUTHORITY=" & chr(34)
					end if
					if RS("AUTHORS") <> "" then
						strText = strText & server.HTMLEncode(RS("AUTHORS"))
					else
						strText = strText
					end if
					strText = strText & ", " & RS("YEAR OF PUBLICATION") & chr(34) & " /" & chr(62)
					response.write(strText)
					strText = chr(60) & "/NAME" & chr(62)
					response.write(strText)
					strText = chr(60) & "/AVCNAME" & chr(62)
					response.write(strText)
					strText = chr(60) & "STATUSREF REFTYPE=" & chr(34) & "validity" & chr(34) & chr(62)
					response.write(strText)
					strText = chr(60) & "REFERENCE REFID=" 
					strText = strText & chr(34) & RS("RECORD NUMBER") & chr(34) & chr(62)
					response.write(strText)
					if RS("PUBLISHING AUTHORS") <> "" then
						strText = chr(60) & "LITREF AUTHOR=" & chr(34) & server.HTMLEncode(RS("PUBLISHING AUTHORS")) & chr(34)
					else
						strText = chr(60) & "LITREF AUTHOR=" & chr(34) & "unavailable" & chr(34)
					end if
					strText = strText & " TITLE=" & chr(34) & "unavailable" & chr(34) & " YEAR="
					if RS("YEAR OF PUBLICATION") <> "" then
						if RS("YEAR ON PUBLICATION") <> "" then
							strText = strText & chr(34) & RS("YEAR ON PUBLICATION") & ", publ. " & RS("YEAR OF PUBLICATION") & chr(34) & " DETAILS="
						else
							strText = strText & chr(34) & RS("YEAR OF PUBLICATION") & chr(34) & " DETAILS="
						end if
					else
						strText = strText & chr(34) & "unavailable" & chr(34) & " DETAILS="
					end if
					
					if RS("pubIMIAbbr") <> "" then
						strText = strText & chr(34) & server.HTMLEncode(RS("pubIMIAbbr"))
					else
						strText = strText & chr(34)
					end if
					if RS("pubIMISupAbbr") <> "" then strText = strText & ", " & server.HTMLEncode(RS("pubIMISupAbbr"))
					if RS("pubIMIAbbrLoc") <> "" then strText = strText & " (" & server.HTMLEncode(RS("pubIMIAbbrLoc")) & ")"
					if RS("VOLUME") <> "" then
						if RS("PAGE") <> "" then 
							strText = strText & " " & RS("VOLUME") & ": " & RS("PAGE")
						else
							strText = strText & " " & RS("VOLUME")
						end if
					else
						if RS("PAGE") <> "" then 
							strText = strText & ": " & RS("PAGE")
						else
							strText = strText
						end if
					end if
					strText = strText & chr(34) & " /" & chr(62)
					response.write(strText)
					strText = chr(60) & "/REFERENCE" & chr(62)
					response.write(strText)
					strText = chr(60) & "/STATUSREF" & chr(62)
					response.write(strText)
					strText = chr(60) & "/AVCNAMEWITHREFS" & chr(62)
					response.write(strText)
				RS.Close
		' output the synonym(s)
			RS.Open strSQL1, dbConn, 3
			if not RS.bof then
				do while not RS.eof
					if RS("CURRENT NAME RECORD NUMBER") <> RS("RECORD NUMBER") then
						strText = chr(60) & "SYNONYMWITHREFS" & chr(62)
						response.write(strText)
						strText = chr(60) & "SYNONYM" 
						if RS("INFRASPECIFIC EPITHET") <> "" then
							strText = strText & " " & "INFRASPECIFICPORTION=" & chr(34) & server.htmlencode(RS("INFRASPECIFIC RANK")) & " " & RS("INFRASPECIFIC EPITHET") & chr(34)
						end if
						strText = strText & " STATUS=" & chr(34) & "synonym" & chr(34) & chr(62)
						response.write(strText)
						strGenus = server.HTMLEncode(left(RS("NAME OF FUNGUS"),instr(RS("NAME OF FUNGUS")," ")-1))
						strText = chr(60) & "FULLNAME GENUS=" & chr(34) & strGenus & chr(34) & " SPECIFICEPITHET="
						strText = strText & chr(34) & server.HTMLEncode(RS("SPECIFIC EPITHET")) & chr(34) & " AUTHORITY=" & chr(34)
						if RS("AUTHORS") <> "" then
							strText = strText & server.HTMLEncode(RS("AUTHORS"))
						else
							strText = strText
						end if
						if RS("YEAR OF PUBLICATION") <> "" then
							strText = strText & ", " & RS("YEAR OF PUBLICATION") & chr(34) & " /" & chr(62)
						else
							strText = strText & chr(34) & " /" & chr(62)
						end if
						response.write(strText)
						strText = chr(60) & "/SYNONYM" & chr(62)
						response.write(strText)
						strText = chr(60) & "STATUSREF REFTYPE=" & chr(34) & "validity" & chr(34) & chr(62)
						response.write(strText)
						strText = chr(60) & "REFERENCE REFID=" 
						strText = strText & chr(34) & RS("RECORD NUMBER") & chr(34) & chr(62)
						response.write(strText)
						strText = chr(60) & "LITREF AUTHOR=" & chr(34) & "unavailable" & chr(34)
						strText = strText & " TITLE=" & chr(34) & "unavailable" & chr(34) & " YEAR=" 
						strText = strText & chr(34) & RS("YEAR OF PUBLICATION") & chr(34) & " DETAILS="
						if RS("pubIMIAbbr") <> "" then
							strText = strText & chr(34) & server.HTMLEncode(RS("pubIMIAbbr"))
						else
							strText = strText & chr(34)
						end if
						if RS("pubIMISupAbbr") <> "" then strText = strText & ", " & server.HTMLEncode(RS("pubIMISupAbbr"))
						if RS("pubIMIAbbrLoc") <> "" then strText = strText & " (" & server.HTMLEncode(RS("pubIMIAbbrLoc")) & ")"
						if RS("VOLUME") <> "" then
							if RS("PAGE") <> "" then 
								strText = strText & " " & RS("VOLUME") & ": " & RS("PAGE")
							else
								strText = strText & " " & RS("VOLUME")
							end if
						else
							if RS("PAGE") <> "" then 
								strText = strText & ": " & RS("PAGE")
							else
								strText = strText
							end if
						end if
						strText = strText & chr(34) & " /" & chr(62)
						response.write(strText)
						strText = chr(60) & "/REFERENCE" & chr(62)
						response.write(strText)
						strText = chr(60) & "/STATUSREF" & chr(62)
						response.write(strText)
						strText = chr(60) & "/SYNONYMWITHREFS" & chr(62)
						response.write(strText)
					end if
				RS.Movenext
				loop
			end if
			'put in the last bits after the record set is completed
				strText = chr(60) & "/STANDARDDATA" & chr(62)
				response.write(strText)
				strText = chr(60) & "/TYPE2RESULT" & chr(62)
				response.write(strText)
				strText = chr(60) & "/XMLRESPONSE" & chr(62)
				response.write(strText)
			else
			'no records found so put out a response to say no record found
				strText = chr(60) & "?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8"
				strText = strText & chr(34) & " ?" & chr(62)
				response.write(strText)
				strText = chr(60) & "XMLRESPONSE" & chr(62)
				response.write(strText)
				strText = chr(60) & "TYPE2RESULT" & chr(62)
				response.write(strText)
				strText = chr(60) & "STANDARDDATA COMMENT=" & chr(34) & "no record found" & chr(34) & chr(62)
				response.write(strText)
				strText = chr(60) & "/STANDARDDATA" & chr(62)
				response.write(strText)
				strText = chr(60) & "/TYPE2RESULT" & chr(62)
				response.write(strText)
				strText = chr(60) & "/XMLRESPONSE" & chr(62)
				response.write(strText)
			end if
			RS.close
			set RS = nothing
			dbConn.close
			set dbConn = nothing

		'rest of null intTaxonID trap
'		else
'			strText = chr(60) & "?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8"
'			strText = strText & chr(34) & " ?" & chr(62)
'			response.write(strText)
'			strText = chr(60) & "!DOCTYPE XMLRESPONSE" & chr(62)
'			response.write(strText)
'			strText = chr(60) & "XMLRESPONSE" & chr(62)
'			response.write(strText)
'			strText = chr(60) & "TYPE1RESULT NUMBER=" & chr(34) & "0" & chr(34) & chr(62)
'			response.write(strText)
'			strText = chr(60) & "/TYPE1RESULT" & chr(62)
'			response.write(strText)
'			strText = chr(60) & "/XMLRESPONSE" & chr(62)
'			response.write(strText)
'		end if

'TYPE 3 RESPONSE
		elseif strType = "3" then
			'this is hard coded for each GSD - needs to be edited when separate files for each GSD are prepared
			strText = chr(60) & "?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8"
			strText = strText & chr(34) & " ?" & chr(62)
			response.write(strText)
			strText = chr(60) & "!DOCTYPE XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "TYPE3RESULT" & chr(62)
			response.write(strText)
			strText = chr(60) & "GSDINFO IDENTIFIER=" & chr(34) & "Species Fungorum" & chr(34)
			strText = strText & " GSDSHORTNAME=" & chr(34) & "SF" & chr(34) 
			strText = strText & " GSDTITLE=" & chr(34) & "Species Fungorum - global checklist of fungi" & chr(34) 
			strText = strText & " DESCRIPTION=" & chr(34) & "Species Fungorum - global checklist of fungi" & chr(34) 
			strText = strText & " VERSION=" & chr(34) & "5" & chr(34) 
			strText = strText & " VIEW=" & chr(34) & "SF" & chr(34) 
			strText = strText & " WRAPPERVERSION=" & chr(34) & "1" & chr(34) 
			strText = strText & " HOMELINK=" & chr(34) & "http://www.speciesfungorum.org" & chr(34) 
			strText = strText & " CONTACTLINK=" & chr(34) & "p.kirk@cabi.org" & chr(34) 
			strText = strText & " SEARCHLINK=" & chr(34) & "http://www.speciesfungorum.org/names/names.asp" & chr(34) 
			strText = strText & " LOGOLINK=" & chr(34) & "http://www.speciesfungorum.org/images/cabilogo-small.gif" & chr(34) 
			strText = strText & chr(62)
			response.write(strText)
			strText = chr(60) & "DATE YEAR=" & chr(34) & mid(now(),7,4) & chr(34)
			if left(mid(now(),4,2),1) <> "0" then
				strText = strText & " MONTH=" & chr(34) & mid(now(),4,2) & chr(34)
			else
				strText = strText & " MONTH=" & chr(34) & mid(now(),5,1) & chr(34)
			end if
			if left(now(),1) <> "0" then
			' to prevent the cache updating every day fix day as '1' so date only changes every month
'				strText = strText & " DAY=" & chr(34) & left(now(),2) & chr(34)
				strText = strText & " DAY=" & chr(34) & "1" & chr(34)
			else
'				strText = strText & " DAY=" & chr(34) & mid(now(),2,1) & chr(34)
				strText = strText & " DAY=" & chr(34) & "1" & chr(34)
			end if
			strText = strText & " /" & chr(62)
			response.write(strText)
			strText = chr(60) & "/GSDINFO" & chr(62)
			response.write(strText)
			strText = chr(60) & "/TYPE3RESULT" & chr(62)
			response.write(strText)
			strText = chr(60) & "/XMLRESPONSE" & chr(62)
			response.write(strText)

'TYPE 4 RESPONSE
		elseif strType = "4" then
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
			elseif strIP = "127.0.0.1" then
			   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
			   dbConn.open strConn
			elseif strIP = "192.168.0.3" then
			   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_WEBSERVER;Initial Catalog=IndexFungorum;Data Source=webserver"
			   dbConn.open strConn
			else
			   dbConn.open "FILEDSN=cabilink"
			end if
			Set RS = Server.CreateObject("ADODB.Recordset")
			RS.Open strSql, dbConn, 3

			strText = chr(60) & "?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8"
			strText = strText & chr(34) & " ?" & chr(62)
			response.write(strText)
			strText = chr(60) & "!DOCTYPE XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "TYPE4RESULT" & chr(62)
			response.write(strText)

			if not RS.bof then
			if strRank = "G" then
				strText = chr(60) & "HIGHERTAXON IDENTIFIER=" & chr(34) & RS("Family name") & chr(34)
				strText = strText & " RANK=" & chr(34) & "Family" & chr(34)
				strText = strText & " TAXONNAME=" & chr(34) & RS("Family name") & chr(34)
				strText = strText & " AUTHORITY=" & chr(34) & chr(34)
				strText = strText & " VIEW=" & chr(34) & chr(34)
				strText = strText & " /" & chr(62)
				response.write(strText)
			elseif strRank = "F" then
				strText = chr(60) & "HIGHERTAXON IDENTIFIER=" & chr(34) & RS("Order name") & chr(34)
				strText = strText & " RANK=" & chr(34) & "Order" & chr(34)
				strText = strText & " TAXONNAME=" & chr(34) & RS("Order name") & chr(34)
				strText = strText & " AUTHORITY=" & chr(34) & chr(34)
				strText = strText & " VIEW=" & chr(34) & chr(34)
				strText = strText & " /" & chr(62)
				response.write(strText)
			elseif strRank = "O" then
				strText = chr(60) & "HIGHERTAXON IDENTIFIER=" & chr(34) & RS("Class name") & chr(34)
				strText = strText & " RANK=" & chr(34) & "Class" & chr(34)
				strText = strText & " TAXONNAME=" & chr(34) & RS("Class name") & chr(34)
				strText = strText & " AUTHORITY=" & chr(34) & chr(34)
				strText = strText & " VIEW=" & chr(34) & chr(34)
				strText = strText & " /" & chr(62)
				response.write(strText)
			elseif strRank = "C" then
				strText = chr(60) & "HIGHERTAXON IDENTIFIER=" & chr(34) & RS("Phylum name") & chr(34)
				strText = strText & " RANK=" & chr(34) & "Phylum" & chr(34)
				strText = strText & " TAXONNAME=" & chr(34) & RS("Phylum name") & chr(34)
				strText = strText & " AUTHORITY=" & chr(34) & chr(34)
				strText = strText & " VIEW=" & chr(34) & chr(34)
				strText = strText & " /" & chr(62)
				response.write(strText)
			elseif strRank = "P" then
				strText = chr(60) & "HIGHERTAXON IDENTIFIER=" & chr(34) & RS("Kingdom name") & chr(34)
				strText = strText & " RANK=" & chr(34) & "Kingdom" & chr(34)
				strText = strText & " TAXONNAME=" & chr(34) & RS("Kingdom name") & chr(34)
				strText = strText & " AUTHORITY=" & chr(34) & chr(34)
				strText = strText & " VIEW=" & chr(34) & chr(34)
				strText = strText & " /" & chr(62)
				response.write(strText)
			end if
			end if

			RS.close
			set RS = nothing
			dbConn.close
			set dbConn = nothing

			strText = chr(60) & "/TYPE4RESULT" & chr(62)
			response.write(strText)
			strText = chr(60) & "/XMLRESPONSE" & chr(62)
			response.write(strText)

'TYPE 5 RESPONSE
		elseif strType = "5" then
			Set dbConn = Server.CreateObject("ADODB.Connection")
			strIP = request.servervariables("LOCAL_ADDR")
			if true then        
               strConn = GetConnectionString()
	           dbConn.connectiontimeout = 180
	           dbConn.commandtimeout = 180
	           dbConn.open strConn
	        elseif strIP = "10.0.5.10" then
				strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
				dbConn.connectiontimeout = 300
				dbConn.commandtimeout = 300
				dbConn.open strConn
			elseif strIP = "127.0.0.1" then
				strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
				dbConn.connectiontimeout = 300
				dbConn.commandtimeout = 300
				dbConn.open strConn
			elseif strIP = "192.168.0.3" then
				strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_WEBSERVER;Initial Catalog=IndexFungorum;Data Source=webserver"
				dbConn.connectiontimeout = 300
				dbConn.commandtimeout = 300
				dbConn.open strConn
			else
				dbConn.open "FILEDSN=cabilink"
			end if
			Set RS = Server.CreateObject("ADODB.Recordset")
			RS.Open strSql, dbConn, 3

			strText = chr(60) & "?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8"
			strText = strText & chr(34) & " ?" & chr(62)
			response.write(strText)
			strText = chr(60) & "!DOCTYPE XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "TYPE5RESULT" & chr(62)
			response.write(strText)

			if not RS.bof then
			do while not RS.eof
			
				if strChildRank = "Genus" then
					strText = chr(60) & "TAXON IDENTIFIER=" & chr(34) & RS("Genus name") & chr(34) & chr(62)
					response.write(strText)
					strText = chr(60) & "HIGHERTAXON IDENTIFIER=" & chr(34) & RS("Genus name") & chr(34)
					strText = strText & " RANK=" & chr(34) & strChildRank & chr(34)
					strText = strText & " TAXONNAME=" & chr(34) & RS("Genus name") & chr(34)
					strText = strText & " AUTHORITY=" & chr(34) & chr(34)
					strText = strText & " VIEW=" & chr(34) & chr(34)
					strText = strText & " /" & chr(62)
					response.write(strText)
					strText = chr(60) & "/TAXON" & chr(62)
					response.write(strText)
				elseif strChildRank = "Family" then
					if RS("Family name") <> "Incertae sedis" then
						strText = chr(60) & "TAXON IDENTIFIER=" & chr(34) & RS("Family name") & chr(34) & chr(62)
						response.write(strText)
						strText = chr(60) & "HIGHERTAXON IDENTIFIER=" & chr(34) & RS("Family name") & chr(34)
						strText = strText & " RANK=" & chr(34) & strChildRank & chr(34)
						strText = strText & " TAXONNAME=" & chr(34) & RS("Family name") & chr(34)
						strText = strText & " AUTHORITY=" & chr(34) & chr(34)
						strText = strText & " VIEW=" & chr(34) & chr(34)
						strText = strText & " /" & chr(62)
						response.write(strText)
						strText = chr(60) & "/TAXON" & chr(62)
						response.write(strText)
					end if
				elseif strChildRank = "Order" then
					if RS("Order name") <> "Incertae sedis" then
						strText = chr(60) & "TAXON IDENTIFIER=" & chr(34) & RS("Order name") & chr(34) & chr(62)
						response.write(strText)
						strText = chr(60) & "HIGHERTAXON IDENTIFIER=" & chr(34) & RS("Order name") & chr(34)
						strText = strText & " RANK=" & chr(34) & strChildRank & chr(34)
						strText = strText & " TAXONNAME=" & chr(34) & RS("Order name") & chr(34)
						strText = strText & " AUTHORITY=" & chr(34) & chr(34)
						strText = strText & " VIEW=" & chr(34) & chr(34)
						strText = strText & " /" & chr(62)
						response.write(strText)
						strText = chr(60) & "/TAXON" & chr(62)
						response.write(strText)
					end if
				elseif strChildRank = "Class" then
					if RS("Class name") <> "Incertae sedis" then
						strText = chr(60) & "TAXON IDENTIFIER=" & chr(34) & RS("Class name") & chr(34) & chr(62)
						response.write(strText)
						strText = chr(60) & "HIGHERTAXON IDENTIFIER=" & chr(34) & RS("Class name") & chr(34)
						strText = strText & " RANK=" & chr(34) & strChildRank & chr(34)
						strText = strText & " TAXONNAME=" & chr(34) & RS("Class name") & chr(34)
						strText = strText & " AUTHORITY=" & chr(34) & chr(34)
						strText = strText & " VIEW=" & chr(34) & chr(34)
						strText = strText & " /" & chr(62)
						response.write(strText)
						strText = chr(60) & "/TAXON" & chr(62)
						response.write(strText)
					end if
				else
					if RS("Phylum name") <> "Incertae sedis" then
						strText = chr(60) & "TAXON IDENTIFIER=" & chr(34) & RS("Phylum name") & chr(34) & chr(62)
						response.write(strText)
						strText = chr(60) & "HIGHERTAXON IDENTIFIER=" & chr(34) & RS("Phylum name") & chr(34)
						strText = strText & " RANK=" & chr(34) & strChildRank & chr(34)
						strText = strText & " TAXONNAME=" & chr(34) & RS("Phylum name") & chr(34)
						strText = strText & " AUTHORITY=" & chr(34) & chr(34)
						strText = strText & " VIEW=" & chr(34) & chr(34)
						strText = strText & " /" & chr(62)
						response.write(strText)
						strText = chr(60) & "/TAXON" & chr(62)
						response.write(strText)
					end if
				end if
	
			RS.Movenext
			loop

			end if

			RS.close
			set RS = nothing
			dbConn.close
			set dbConn = nothing
			strRank = ""
			strChildRank = ""

			strText = chr(60) & "/TYPE5RESULT" & chr(62)
			response.write(strText)
			strText = chr(60) & "/XMLRESPONSE" & chr(62)
			response.write(strText)

		else
			'no parameters transmitted or type not supported so send a type0 response
			strText = chr(60) & "?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8"
			strText = strText & chr(34) & " ?" & chr(62)
			response.write(strText)
			strText = chr(60) & "!DOCTYPE XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "CDMVERSION" & chr(62) & "1.2" & chr(60) & "/CDMVERSION" & chr(62)
			response.write(strText)
			strText = chr(60) & "/XMLRESPONSE" & chr(62)
			response.write(strText)
		end if
%>