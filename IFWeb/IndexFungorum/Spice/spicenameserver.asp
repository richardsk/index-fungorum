
<!--#include file="../Helpers/Utility.asp"-->
<!--#include file="../Connections/DataAccess.asp"-->
<%
dim strType, strSearchName, intTaxonID, strTaxon, strRank, strText, strSQL, dbConn, RS, strTruncation
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
		' detect left hand truncation
		if left(strSearchName,1) = "*" or left(strSearchName,1) = "%" then strTruncation = "true"
		strSearchName = replace(strSearchName,"*","")
		strSearchName = replace(strSearchName,"%","")

' response for Request Type 2
elseif strType = "2" then
	intTaxonID = request.querystring.item("taxonid")

' response for Request Type 3
elseif strType = "3" then
' nothing to process

end if

	if strType = "0" then
	'no SQL to define

	elseif strType = "1" then
		strSQL = "SELECT IndexFungorum.* " _
			& "FROM IndexFungorum " _
			& "WHERE ((IndexFungorum.[NAME OF FUNGUS]) Like '" & protectSQL(strSearchName, false) & "%') AND ((IndexFungorum.[INFRASPECIFIC EPITHET]) Is Null) AND ((IndexFungorum.[MISAPPLICATION AUTHORS]) Is Null) " _
			& "ORDER BY IndexFungorum.[NAME OF FUNGUS];"

	elseif strType = "2" then
		strSQL = "SELECT IndexFungorum.*, FundicClassification.[Family name], Publications.pubIMIAbbr, " _
			& "Publications.pubIMISupAbbr, Publications.pubIMIAbbrLoc " _
			& "FROM (IndexFungorum LEFT JOIN FundicClassification " _
			& "ON IndexFungorum.[NAME OF FUNGUS FUNDIC RECORD NUMBER] = FundicClassification.[Fundic Record Number]) " _
			& "LEFT JOIN Publications ON IndexFungorum.[LITERATURE LINK] = Publications.pubLink " _
			& "WHERE (((IndexFungorum.[RECORD NUMBER]) = " & protectSQL(intTaxonID,true) & ")) " _
			& "ORDER BY IndexFungorum.[NAME OF FUNGUS];"

	elseif strType = "3" then
	'no SQL to define

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
	        elseif strIP = "194.131.255.4" then
				strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_BIOSCIENCEWSRVR;Initial Catalog=IndexFungorum;Data Source=biosciencewsrvr"
				dbConn.connectiontimeout = 300
				dbConn.commandtimeout = 300
				dbConn.open strConn
			elseif strIP = "194.203.77.78" then
				strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_INDEXFUNGORUM;Initial Catalog=IndexFungorum;Data Source=INDEXFUNGORUM"
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
					strText = chr(60) & "SPECIESNAME IDENTIFIER=" & chr(34) & RS("RECORD NUMBER") & chr(34) & chr(62)
					response.write(strText)
					strText = chr(60) & "AVCNAME STATUS=" & chr(34) & "provisional" & chr(34) & chr(62)
					response.write(strText)
					strText = chr(60) & "NAME" & chr(62)
					response.write(strText)
					strText = chr(60) & "FULLNAME GENUS=" 
					strGenus = encodeHtml(left(RS("NAME OF FUNGUS"),instr(RS("NAME OF FUNGUS")," ")-1))
					strText = strText & chr(34) & strGenus & chr(34) & " SPECIFICEPITHET="
					strText = strText & chr(34) & encodeHtml(RS("SPECIFIC EPITHET")) & chr(34) & " AUTHORITY=" & chr(34)
					if RS("AUTHORS") <> "" then
						strText = strText & encodeHtml(RS("AUTHORS")) & chr(34)
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

'TYPE 2 RESPONSE
		elseif strType = "2" then
			Set dbConn = Server.CreateObject("ADODB.Connection")
			strIP = request.servervariables("LOCAL_ADDR")
			if true then        
               strConn = GetConnectionString()
	           dbConn.connectiontimeout = 180
	           dbConn.commandtimeout = 180
	           dbConn.open strConn
	        elseif strIP = "194.131.255.4" then
			   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_BIOSCIENCEWSRVR;Initial Catalog=IndexFungorum;Data Source=biosciencewsrvr"
			   dbConn.open strConn
			elseif strIP = "194.203.77.78" then
				strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_INDEXFUNGORUM;Initial Catalog=IndexFungorum;Data Source=INDEXFUNGORUM"
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

				do while not RS.eof
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
					strText = strText & "http://www.indexfungorum.org/Names/NamesRecord.asp?RecordID=" & RS("RECORD NUMBER")
					strText = strText & chr(60) & "/OTHERLINK" & chr(62) 
					response.write(strText)
					strText = chr(60) & "AVCNAMEWITHREFS" & chr(62)
					response.write(strText)
					strText = chr(60) & "AVCNAME" 
					strText = strText & " STATUS=" & chr(34) & "provisional"
					strText = strText & chr(34) & chr(62)
					response.write(strText)
					strText = chr(60) & "NAME" & chr(62)
					response.write(strText)
					strGenus = encodeHtml(left(RS("NAME OF FUNGUS"),instr(RS("NAME OF FUNGUS")," ")-1))
					strText = chr(60) & "FULLNAME GENUS=" & chr(34) & strGenus & chr(34) & " SPECIFICEPITHET="
					strText = strText & chr(34) & encodeHtml(RS("SPECIFIC EPITHET")) & chr(34) & " AUTHORITY=" & chr(34)
					if RS("AUTHORS") <> "" then
						strText = strText & encodeHtml(RS("AUTHORS"))
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
					strText = chr(60) & "LITREF AUTHOR=" & chr(34) & "anon." & chr(34)
					strText = strText & " TITLE=" & chr(34) & "title unavailable" & chr(34) & " YEAR=" 
					strText = strText & chr(34) & RS("YEAR OF PUBLICATION") & chr(34) & " DETAILS="
					if RS("pubIMIAbbr") <> "" then
						strText = strText & chr(34) & encodeHtml(RS("pubIMIAbbr"))
					else
						strText = strText & chr(34)
					end if
					if RS("pubIMISupAbbr") <> "" then strText = strText & ", " & encodeHtml(RS("pubIMISupAbbr"))
					if RS("pubIMIAbbrLoc") <> "" then strText = strText & " (" & encodeHtml(RS("pubIMIAbbrLoc")) & ")"
					if RS("VOLUME") <> "" then
						if RS("PAGE") <> "" then 
							strText = strText & " " & RS("VOLUME") & ": " & RS("PAGE") & "." & chr(34) & " /"
						else
							strText = strText & " " & RS("VOLUME") & "." & chr(34) & " /"
						end if
					else
						if RS("PAGE") <> "" then 
							strText = strText & ": " & RS("PAGE") & "." & chr(34) & " /"
						else
							strText = strText & "." & chr(34) & " /"
						end if
					end if
					strText = strText & chr(62)
					response.write(strText)
					strText = chr(60) & "/REFERENCE" & chr(62)
					response.write(strText)
					strText = chr(60) & "/STATUSREF" & chr(62)
					response.write(strText)
					strText = chr(60) & "/AVCNAMEWITHREFS" & chr(62)
					response.write(strText)
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
			strText = chr(60) & "GSDINFO IDENTIFIER=" & chr(34) & "Index Fungorum" & chr(34)
			strText = strText & " GSDSHORTNAME=" & chr(34) & "IF" & chr(34) 
			strText = strText & " GSDTITLE=" & chr(34) & "Index Fungorum - global nomenclator for fungi" & chr(34) 
			strText = strText & " DESCRIPTION=" & chr(34) & "Index Fungorum - global nomenclator for fungi" & chr(34) 
			strText = strText & " VERSION=" & chr(34) & "5" & chr(34) 
			strText = strText & " VIEW=" & chr(34) & "SF" & chr(34) 
			strText = strText & " WRAPPERVERSION=" & chr(34) & "1" & chr(34) 
			strText = strText & " HOMELINK=" & chr(34) & "http://www.indexfungorum.org" & chr(34) 
			strText = strText & " CONTACTLINK=" & chr(34) & "p.kirk@cabi.org" & chr(34) 
			strText = strText & " SEARCHLINK=" & chr(34) & "http://www.indexfungorum.org/names/names.asp" & chr(34) 
			strText = strText & " LOGOLINK=" & chr(34) & "http://www.indexfungorum.org/images/cabilogo-small.gif" & chr(34) 
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
				strText = strText & " DAY=" & chr(34) & "1" & chr(34)
			else
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