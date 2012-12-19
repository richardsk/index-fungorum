<%
dim strType, strSearchName, intTaxonID, strTaxon, strRank, strText, strSQL, dbConn, RS

if request.querystring.item("requesttype") <> "" then
	strType = request.querystring.item("requesttype")
else
	strType = ""
	response.write("No request included; ")
end if

' response for Request Type 0
if strType = "0" then
' nothing to process

' response for Request Type 1
elseif strType = "1" then
	strSearchName = request.querystring.item("searchname")

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

else
	response.write("No request type defined; ")

end if

	if strType = "0" then
	'no SQL to define

	elseif strType = "1" then
		strSQL = "SELECT IndexFungorum.*, IndexFungorum_1.AUTHORS AS [CURRENT NAME AUTHORS], " _
			& "IndexFungorum_1.[SPECIFIC EPITHET] AS [CURRENT NAME SPECIFIC EPITHET] " _
			& "FROM IndexFungorum INNER JOIN IndexFungorum AS IndexFungorum_1 " _
			& "ON IndexFungorum.[CURRENT NAME RECORD NUMBER] = IndexFungorum_1.[RECORD NUMBER] " _
			& "WHERE (((IndexFungorum.[GSD FLAG]) Like 'GSD%') AND ((IndexFungorum.[NAME OF FUNGUS]) Like '" & strSearchName & "%') " _
			& "AND ((IndexFungorum.[INFRASPECIFIC EPITHET]) Is Null)) " _
			& "ORDER BY IndexFungorum.[NAME OF FUNGUS];"

	elseif strType = "2" then
		strSQL = "SELECT IndexFungorum.*, [FundicClassification].[Family name], Publication.pubIMIAbbr, " _
			& "Publication.pubIMISupAbbr, Publication.pubIMIAbbrLoc " _
			& "FROM (IndexFungorum LEFT JOIN [FundicClassification] " _
			& "ON IndexFungorum.[NAME OF FUNGUS FUNDIC RECORD NUMBER] = [FundicClassification].[Fundic Record Number]) " _
			& "LEFT JOIN Publication ON IndexFungorum.[LITERATURE LINK] = Publication.pubLink " _
			& "WHERE (((IndexFungorum.[GSD FLAG]) Like 'GSD%') AND (([CURRENT NAME RECORD NUMBER]) = " & intTaxonID & ") " _
			& "AND ((IndexFungorum.[INFRASPECIFIC EPITHET]) Is Null)) " _
			& "ORDER BY IndexFungorum.[NAME OF FUNGUS];"

	elseif strType = "3" then
	'no SQL to define

	elseif strType = "4" then
	'need to determine if at bottom of hierarchy or top
	'probably needs something like G-Dimargaris, F-Dimargaritaceae ets
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
			Set dbConn = Server.CreateObject("ADODB.Connection")
			strIP = request.servervariables("LOCAL_ADDR")
			if strIP = "194.203.77.76" then
			   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
			   dbConn.open strConn
			elseif strIP = "10.0.5.10" then
			   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
			   dbConn.open strConn
			elseif strIP = "127.0.0.1" then
			   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
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
						strText = strText & chr(34)
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
					'its a synponym
					strText = chr(60) & "SPECIESNAME IDENTIFIER=" & chr(34) & RS("CURRENT NAME RECORD NUMBER") & chr(34) & chr(62)
					response.write(strText)
					strText = chr(60) & "SYNONYMWITHAVCNAME" & chr(62)
					response.write(strText)
					strText = chr(60) & "SYNONYM STATUS=" & chr(34) & "synonym" & chr(34) & chr(62)
					response.write(strText)
					strText = chr(60) & "FULLNAME GENUS=" 
					strGenus = server.HTMLEncode(left(RS("NAME OF FUNGUS"),instr(RS("NAME OF FUNGUS")," ")-1))
					strText = strText & chr(34) & strGenus & chr(34) & " SPECIFICEPITHET="
					strText = strText & chr(34) & server.HTMLEncode(RS("SPECIFIC EPITHET")) & chr(34) & " AUTHORITY=" & chr(34)
					if RS("AUTHORS") <> "" then
						strText = strText & server.HTMLEncode(RS("AUTHORS")) & chr(34)
					else
						strText = strText & chr(34)
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
					strText = chr(60) & "/SYNONYMWITHAVCNAME" & chr(62)
					response.write(strText)
					strText = chr(60) & "/SPECIESNAME" & chr(62)
					response.write(strText)
				end if
			RS.Movenext
			loop

				'put in the last bits afte the record set is completed
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

'TYPE 2 RESPONSE
		elseif strType = "2" then
			Set dbConn = Server.CreateObject("ADODB.Connection")
			strIP = request.servervariables("LOCAL_ADDR")
			if strIP = "194.203.77.76" then
			   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
			   dbConn.open strConn
			elseif strIP = "10.0.5.10" then
			   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
			   dbConn.open strConn
			elseif strIP = "127.0.0.1" then
			   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
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
			strText = chr(60) & "TYPE2RESULT" & chr(62)
			response.write(strText)

			if not RS.bof then
			do while not RS.eof
				'run through the record ser to find the AVC to get the standard data
				if RS("CURRENT NAME RECORD NUMBER") = RS("RECORD NUMBER") then
					strText = chr(60) & "STANDARDDATA COMMENT=" & chr(34) & chr(34)
					if RS("Family name") <> "Incertae sedis" then strText = strText & " FAMILY=" & chr(34) & RS("Family name") & chr(34)
					strText = strText & chr(62)
					response.write(strText)
					strText = chr(60) & "SCRUTINY PERSON=" & chr(34)
					if RS("GSD FLAG") <> "" and RS("TAXONOMIC REFEREE") <> "" then
					strText = strText & left(RS("TAXONOMIC REFEREE"),instr(RS("TAXONOMIC REFEREE"),"(")-2) & chr(34)
					else
					strText = strText & chr(34)
					end if
					strText = strText & " LINK=" & chr(34)
					if RS("GSD FLAG") <> "" and RS("INTERNET LINK") <> "" then
					if left(RS("INTERNET LINK"),6) = "mailto" then strText = strText & RS("INTERNET LINK")
					end if
					strText = strText & chr(34) & chr(62)
					response.write(strText)
					strText = chr(60) & "DATE YEAR=" & chr(34)
					if RS("GSD FLAG") <> "" and RS("TAXONOMIC REFEREE") <> "" then
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
				end if
			RS.Movenext
			loop

			RS.Movefirst
			do while not RS.eof
			'start at the first record again to output all the records
			'check if its an AVC or a synonym
			if RS("CURRENT NAME RECORD NUMBER") = RS("RECORD NUMBER") then
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
				strText = strText & chr(34) & server.HTMLEncode(RS("SPECIFIC EPITHET")) & chr(34) & " AUTHORITY=" & chr(34)
				if RS("AUTHORS") <> "" then
				strText = strText & server.HTMLEncode(RS("AUTHORS"))
				else
				strText = strText & RS("AUTHORS")
				end if
				StrText = strText & ", " & RS("YEAR OF PUBLICATION") & chr(34) & " /" & chr(62)
				response.write(strText)
				strText = chr(60) & "/NAME" & chr(62)
				response.write(strText)
				strText = chr(60) & "/AVCNAME" & chr(62)
				response.write(strText)
				strText = chr(60) & "STATUSREF REFTYPE=" & chr(34) & "validity" & chr(34) & chr(62)
				response.write(strText)
				strText = chr(60) & "REFERENCE REFID=" 
				StrText = strText & chr(34) & RS("RECORD NUMBER") & chr(34) & chr(62)
				response.write(strText)
				strText = chr(60) & "LITREF YEAR=" 
				StrText = strText & chr(34) & RS("YEAR OF PUBLICATION") & chr(34) & " DETAILS="
				if RS("pubIMIAbbr") <> "" then
				strText = strText & chr(34) & server.HTMLEncode(RS("pubIMIAbbr"))
				else
				strText = strText & chr(34) & RS("pubIMIAbbr")
				end if
				if RS("pubIMISupAbbr") <> "" then strText = strText & ", " & server.HTMLEncode(RS("pubIMISupAbbr"))
				if RS("pubIMIAbbrLoc") <> "" then strText = strText & " (" & server.HTMLEncode(RS("pubIMIAbbrLoc")) & ")"
				if RS("VOLUME") <> "" then
					strText = strText & " " & RS("VOLUME") & ": "
				else
					strText = strText & ": "
				end if
				if RS("PAGE") <> "" then 
				strText = strText & RS("PAGE") & "." & chr(34) & " /"
				else
				strText = strText & chr(34) & " /"
				end if
				strText = strText & chr(62)
				response.write(strText)
				strText = chr(60) & "/REFERENCE" & chr(62)
				response.write(strText)
				strText = chr(60) & "/STATUSREF" & chr(62)
				response.write(strText)
				strText = chr(60) & "/AVCNAMEWITHREFS" & chr(62)
				response.write(strText)
			else
				'its a synponym
				strText = chr(60) & "SYNONYMWITHREFS" & chr(62)
				response.write(strText)
				strText = chr(60) & "SYNONYM" 
				if RS("CURRENT NAME RECORD NUMBER") <> "" then
					strText = strText & " STATUS=" & chr(34) & "synonym"
				else
					strText = strText & " STATUS=" & chr(34) & "unknown"
				end if
				strText = strText & chr(34) & chr(62)
				response.write(strText)
				strText = chr(60) & "NAME" & chr(62)
				response.write(strText)
				strGenus = server.HTMLEncode(left(RS("NAME OF FUNGUS"),instr(RS("NAME OF FUNGUS")," ")-1))
				strText = chr(60) & "FULLNAME GENUS=" & chr(34) & strGenus & chr(34) & " SPECIFICEPITHET="
				strText = strText & chr(34) & server.HTMLEncode(RS("SPECIFIC EPITHET")) & chr(34) & " AUTHORITY=" & chr(34)
				if RS("AUTHORS") <> "" then
					strText = strText & server.HTMLEncode(RS("AUTHORS"))
				else
					strText = strText
				end if
				StrText = strText & ", " & RS("YEAR OF PUBLICATION") & chr(34) & " /" & chr(62)
				response.write(strText)
				strText = chr(60) & "/NAME" & chr(62)
				response.write(strText)
				strText = chr(60) & "/SYNONYM" & chr(62)
				response.write(strText)
				strText = chr(60) & "STATUSREF REFTYPE=" & chr(34) & "validity" & chr(34) & chr(62)
				response.write(strText)
				strText = chr(60) & "REFERENCE REFID=" 
				StrText = strText & chr(34) & RS("RECORD NUMBER") & chr(34) & chr(62)
				response.write(strText)
				strText = chr(60) & "LITREF YEAR=" 
				StrText = strText & chr(34) & RS("YEAR OF PUBLICATION") & chr(34) & " DETAILS="
				if RS("pubIMIAbbr") <> "" then
					strText = strText & chr(34) & server.HTMLEncode(RS("pubIMIAbbr"))
				else
					strText = strText & chr(34) & RS("pubIMIAbbr")
				end if
				if RS("pubIMISupAbbr") <> "" then strText = strText & ", " & server.HTMLEncode(RS("pubIMISupAbbr"))
				if RS("pubIMIAbbrLoc") <> "" then strText = strText & " (" & server.HTMLEncode(RS("pubIMIAbbrLoc")) & ")"
				if RS("VOLUME") <> "" then
					strText = strText & " " & RS("VOLUME") & ": "
				else
					strText = strText & ": "
				end if
				if RS("PAGE") <> "" then 
					strText = strText & RS("PAGE") & "." & chr(34) & " /"
				else
					strText = strText & chr(34) & " /"
				end if
				strText = strText & chr(62)
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

				'put in the last bits afte the record set is completed
				strText = chr(60) & "/STANDARDDATA" & chr(62)
				response.write(strText)
				strText = chr(60) & "/TYPE2RESULT" & chr(62)
				response.write(strText)
				strText = chr(60) & "/XMLRESPONSE" & chr(62)
				response.write(strText)

			else
				'put in the last bits where no records were found
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
			strText = chr(60) & "GSDINFO IDENTIFIER=" & chr(34) & "Zygomycetes p.p." & chr(34)
			strText = strText & " HOMELINK=" & chr(34) & "http://www.speciesfungorum.org" & chr(34) 
			strText = strText & " CONTACTLINK=" & chr(34) & "p.kirk@cabi.org" & chr(34) 
			strText = strText & " SEARCHLINK=" & chr(34) & "http://www.speciesfungorum.org/gsd/gsdquery.asp" & chr(34) 
			strText = strText & chr(62)
			response.write(strText)
			strText = chr(60) & "DATE YEAR=" & chr(34) & mid(now(),7,4) & chr(34)
			if left(mid(now(),4,2),1) <> "0" then
				strText = strText & " MONTH=" & chr(34) & mid(now(),4,2) & chr(34)
			else
				strText = strText & " MONTH=" & chr(34) & mid(now(),5,1) & chr(34)
			end if
			if left(now(),1) <> "0" then
				strText = strText & " DAY=" & chr(34) & mid(now(),4,2) & chr(34)
			else
				strText = strText & " DAY=" & chr(34) & mid(now(),2,1) & chr(34)
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
			if strIP = "194.203.77.76" then
			   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
			   dbConn.open strConn
			elseif strIP = "10.0.5.10" then
			   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
			   dbConn.open strConn
			elseif strIP = "127.0.0.1" then
			   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
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
			if strIP = "194.203.77.76" then
			   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
			   dbConn.open strConn
			elseif strIP = "10.0.5.10" then
			   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
			   dbConn.open strConn
			elseif strIP = "127.0.0.1" then
			   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
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
			'no parameters transmitted
			response.write("Unrecognized request type<br><br>")
			response.write("<a href='http://www.speciesfungorum.org/spice/spice.asp?requesttype=0'>http://www.speciesfungorum.org/spice/spice.asp?requesttype=0</a><br><br>")
			response.write("<a href='http://www.speciesfungorum.org/spice/spice.asp?requesttype=1&searchname=dimargaris'>http://www.speciesfungorum.org/spice/spice.asp?requesttype=1&searchname=dimargaris&searchtypevalue=scientific</a><br><br>")
			response.write("<a href='http://www.speciesfungorum.org/spice/spice.asp?requesttype=2&taxonid=330002'>http://www.speciesfungorum.org/spice/spice.asp?requesttype=2&taxonid=330002</a><br><br>")
			response.write("<a href='http://www.speciesfungorum.org/spice/spice.asp?requesttype=3'>http://www.speciesfungorum.org/spice/spice.asp?requesttype=3</a><br><br>")
			response.write("<a href='http://www.speciesfungorum.org/spice/spice.asp?requesttype=4'>http://www.speciesfungorum.org/spice/spice.asp?requesttype=4</a><br><br>")
			response.write("<a href='http://www.speciesfungorum.org/spice/spice.asp?requesttype=5'>http://www.speciesfungorum.org/spice/spice.asp?requesttype=5</a><br><br>")
		end if
%>