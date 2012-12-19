<%
dim strType, strSearchName, intTaxonID, bExact, strText, strSQL, dbConn, RS

if request.querystring.item("requesttype") <> "" then
	strType = request.querystring.item("requesttype")
else
	strType = ""
	response.write("No request included")
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
	response.write("It's type 3<br>")

' response for Request Type 4
elseif strType = "4" then
	response.write("It's type 4<br>")

else
	response.write("No request type defined")

end if

	if strType = "0" then
	'no SQL to define

	elseif strType = "1" then
		strSQL = "SELECT Funindex.* " _
			& "FROM FUNINDEX " _
			& "WHERE [GSD FLAG] Like 'GSD%' AND [NAME OF FUNGUS] Like '" & strSearchName & "%';"

	elseif strType = "2" then
		strSQL = "SELECT Funindex.*, [Fundic Classification].[Family name], Publication.pubIMIAbbr, " _
			& "Publication.pubIMISupAbbr, Publication.pubIMIAbbrLoc " _
			& "FROM (Funindex LEFT JOIN [Fundic Classification] " _
			& "ON Funindex.[NAME OF FUNGUS FUNDIC RECORD NUMBER] = [Fundic Classification].[Fundic Record Number]) " _
			& "LEFT JOIN Publication ON Funindex.[LITERATURE LINK] = Publication.pubLink " _
			& "WHERE [CURRENT NAME RECORD NUMBER] = " & intTaxonID & ";"

	elseif strType = "3" then
	'no SQL to define

	elseif strType = "4" then
	'no SQL to define

	elseif strType = "5" then
	'no SQL to define

	else
	'no SQL to define

	end if

		if strType = "0" then
			strText = chr(60) & "?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8"
			strText = strText & chr(34) & " ?" & chr(62) & ""
			response.write(strText)
			strText = chr(60) & "!DOCTYPE XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "XMLRESPONSE" & chr(62) & ""
			response.write(strText)
			strText = chr(60) & "CDMVERSION" & chr(62) & "1.2" & chr(60) & "/CDMVERSION" & chr(62)
			response.write(strText)
			strText = chr(60) & "/XMLRESPONSE" & chr(62) & ""
			response.write(strText)

		elseif strType = "1" then
			Set dbConn = Server.CreateObject("ADODB.Connection")
'	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_BIOSCIENCEWSRVR;Initial Catalog=IndexFungorum;Data Source=biosciencewsrvr"
			strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
			dbConn.open strConn

			strText = chr(60) & "?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8"
			strText = strText & chr(34) & " ?" & chr(62) & ""
			response.write(strText)
			strText = chr(60) & "!DOCTYPE XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "XMLRESPONSE" & chr(62)
			response.write(strText)

			Set RS = Server.CreateObject("ADODB.Recordset")
			RS.Open strSql, dbConn, 3

			strText = chr(60) & "TYPE1RESULT NUMBER=" & chr(34) & RS.RecordCount & chr(34) & chr(62)
			response.write(strText)

			if not RS.bof then
			do while not RS.eof

			strText = chr(60) & "SPECIESNAME IDENTIFIER=" & chr(34) & RS("RECORD NUMBER") & chr(34) & chr(62)
			response.write(strText)
			strText = chr(60) & "AVCNAME IDENTIFIER=" & chr(34) & RS("CURRENT NAME RECORD NUMBER") & chr(34)
			if RS("CURRENT NAME RECORD NUMBER") = RS("RECORD NUMBER") then
				strText = strText & " STATUS=" & chr(34) & "accepted" & chr(34) & chr(62)
			else
				strText = strText & " STATUS=" & chr(34) & "synonym" & chr(34) & chr(62)
			end if
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
			strText = strText & RS("AUTHORS") & chr(34)
			end if
			strText = strText & " /" & chr(62)
			response.write(strText)
			strText = chr(60) & "/NAME" & chr(62)
			response.write(strText)
			strText = chr(60) & "/AVCNAME" & chr(62)
			response.write(strText)
			strText = chr(60) & "/SPECIESNAME" & chr(62)
			response.write(strText)

			RS.Movenext
			loop
			strText = chr(60) & "/TYPE1RESULT" & chr(62)
			response.write(strText)
			strText = chr(60) & "/XMLRESPONSE" & chr(62)
			response.write(strText)

			else
			strText = chr(60) & "/TYPE1RESULT" & chr(62)
			response.write(strText)
			strText = chr(60) & "/XMLRESPONSE" & chr(62)
			response.write(strText)
			end if

			RS.close
			set RS = nothing
			dbConn.close
			set dbConn = nothing

		elseif strType = "2" then
			Set dbConn = Server.CreateObject("ADODB.Connection")
'	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_BIOSCIENCEWSRVR;Initial Catalog=IndexFungorum;Data Source=biosciencewsrvr"
			strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
			dbConn.open strConn
			Set RS = Server.CreateObject("ADODB.Recordset")
			RS.Open strSql, dbConn, 3

			strText = chr(60) & "?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8"
			strText = strText & chr(34) & " ?" & chr(62)
			response.write(strText)
			strText = chr(60) & "XMLRESPONSE" & chr(62)
			response.write(strText)
			strText = chr(60) & "TYPE2RESULT" & chr(62)
			response.write(strText)

			if not RS.bof then
			do while not RS.eof

			strText = chr(60) & "STANDARDDATA COMMENT=" & chr(34) & chr(34)
			if RS("Family name") <> "Incertae sedis" then strText = strText & " FAMILY=" & chr(34) & RS("Family name") & chr(34)
			strText = strText & chr(62) & ""
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
			strText = strText & chr(34) & chr(62) & ""
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
			strText = chr(60) & "OTHERLINKS /" & chr(62)
			response.write(strText)
			strText = chr(60) & "AVCNAMEWITHREFS" & chr(62)
			response.write(strText)
			strText = chr(60) & "AVCNAME IDENTIFIER=" & chr(34) 
			strText = strText & RS("CURRENT NAME RECORD NUMBER") & chr(34)
			if RS("CURRENT NAME RECORD NUMBER") = RS("RECORD NUMBER") then
				strText = strText & " STATUS=" & chr(34) & "accepted"
			else
				if RS("CURRENT NAME RECORD NUMBER") <> "" then
					strText = strText & " STATUS=" & chr(34) & "synonym"
				else
					strText = strText & " STATUS=" & chr(34) & "unknown"
				end if
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
			strText = chr(60) & "/STANDARDDATA" & chr(62)
			response.write(strText)

			RS.Movenext
			loop

			strText = chr(60) & "/TYPE2RESULT" & chr(62)
			response.write(strText)
			strText = chr(60) & "/XMLRESPONSE" & chr(62)
			response.write(strText)

			else
			'no record found
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

		elseif strType = "3" then
			strText = chr(60) & "?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8"
			strText = strText & chr(34) & " ?" & chr(62) & ""
			response.write(strText)
			strText = chr(60) & "!DOCTYPE XMLRESPONSE (View Source for full doctype...)" & chr(62)
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

		elseif strType = "4" then
			response.write("Not yet implemented")
		elseif strType = "5" then
			response.write("Not yet implemented")
		else
			response.write("Unrecognized request type")
		end if
%>