<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/HerbIMI.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>HerbIMI-Online - results display</title>
<!-- InstanceEndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
<!--
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=840,height=450,left=150,top=00');");
}

function MM_displayStatusMsg(msgStr) { //v1.0
  status=msgStr;
  document.MM_returnValue = true;
}
//-->
</script>
<link href="StyleSheets/HerbIMI.css" rel="stylesheet" type="text/css">
<!--#include file="../Connections/DataAccess.asp"-->
<!--#include file="../Helpers/Utility.asp"-->
</head> 
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#9CFF9C">
<a name="TopOfPage"></a> 
<table width="100%" height="100%" class="mainbody">
  <tr>
    <td height="105"> 
      <table width="100%" border="0" class="mainbody">
        <tr> 
          <td width="59%" class="h1"> <img src="Images/CABILogo.gif" width="100" height="100"> 
            CABI Databases</td>
          <td width="41%" valign="top"><table height="100%" align="center">
              <tr class="mainbody"> 
                <td width="205"><strong><font size="4">HERB. IMI ON-LINE</font></strong></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="IMINumber.asp" onMouseOver="MM_displayStatusMsg('Search herb. IMI Number');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  herb. IMI Number</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="Name.asp" onMouseOver="MM_displayStatusMsg('Search Fungus Name');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Fungus Name</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="Association.asp" onMouseOver="MM_displayStatusMsg('Search Associated Organism Name');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Associated Organism Name</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="Countries.asp" onMouseOver="MM_displayStatusMsg('Search by Country Names');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  by Country Names</a></td>
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
          <td bgcolor="#CCFFCC"><!-- InstanceBeginEditable name="head" --> 
            <%
	dim intPageNumber, intNumRecords, intPageSize, intPageCount
	intPageSize = 250		
  	strIMINumber = session("strIMINumber")
	strName = session("strName")
	strCountry = session("strCountry")
	strAssociation = session("strAssociation")

	if request.querystring("strName") <> "" then
		blankvars
		strName = trim(request.querystring("strName"))
		session("strName") = strName
	end if
	if request.querystring("strCountry") <> "" then
		blankvars
		strCountry = trim(request.querystring("strCountry"))
		session("strCountry") = strCountry
	end if
	if request.querystring("strAssociation") <> "" then
		blankvars
		strAssociation = trim(request.querystring("strAssociation") )
		session("strAssociation") = strAssociation
	end if
	if  request.querystring("strIMINumber") <> "" then
		blankvars
		strIMINumber = trim(request.querystring("strIMINumber"))
		session("strIMINumber") = strIMINumber
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

sub blankvars
  	strIMINumber = ""
	strCountry = ""
	strAssociation = ""
	strName = ""
  	session("intIMINumber") = ""
	session("strCountry") = ""
	session("strAssociation") = ""
	session("strName") = ""
end sub

sub NavForm 
	dim i, frm
	if intPageCount <> "" then
		frm  = "DisplayResults"
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

sub ResList(rs)
	dim i, strOut, strText, strUnlock, strPass, strLink
		rs.absoluteposition=((intPageNumber-1) * intPageSize) +1
		strPass = request.querystring("P")
		NavForm
	strIP = request.servervariables("LOCAL_ADDR")
	'build strPopup to add gif for display explanation
	strStr = chr(34) & chr(41)
	strJava = "javascript:popUp(" & chr(34)
	strPopup = "<a href='" & strJava & "DisplayExplanation.htm" & strStr & "'><img src='Images/i.gif' alt='Click here to get an explanation of the display' width='13' height='13' border='0'></a>"
	if strAssociation <> "" then
		response.write("<h3>Herb. IMI records for Associated organism: " & strAssociation & "&nbsp;" & strPopup & "</h3>")
	elseif strCountry <> "" then
		if left(strCountry,2) = "L1" then
			response.write("<h3>Herb. IMI records for Geographical unit: " & rs("L1continent") & "&nbsp;" & strPopup & "</h3>")
		elseif left(strCountry,2) = "L2" then
			response.write("<h3>Herb. IMI records for Geographical unit: " & rs("L2region") & "&nbsp;" & strPopup & "</h3>")
		elseif left(strCountry,2) = "L3" then
			response.write("<h3>Herb. IMI records for Geographical unit: " & rs("L3area") & "&nbsp;" & strPopup & "</h3>")
		elseif left(strCountry,2) = "L4" then
			response.write("<h3>Herb. IMI records for Geographical unit: " & rs("L4country") & "&nbsp;" & strPopup & "</h3>")
		else
			response.write("<h3>Herb. IMI records for ISO Country: " & rs("L4ISOcountry") & "&nbsp;" & strPopup & "</h3>")
		end if
	elseif strName <> "" then
		response.write("<h3>Herb. IMI records for Fungus: " & strName & "&nbsp;" & strPopup & "</h3>")
	else
		response.write("<h3>Herb. IMI records:&nbsp;" & strPopup & "</h3>")
	end if
	for i = 1 to rs.PageSize
	  	if rs.eof then exit for
		if rs.bof then exit for
		strOut = ""
		strLink = ""
		strText = ""


	if strIP = "10.0.5.4" then
		strText = strn(rs("FinalNameDataEdited"))
		if strText <> "" then 
			' link to IndexFungorum with javascript popup
			strLink = strn(rs("FinalNameDataIF-DFnumber"))
				if strLink <> "" then
		' NEED CODE HERE TO DEAL WITH 5nnnnn NUMBERS
					if instr(strText," ") <> 0 then
						strID = strn(rs("FinalNameDataIF-DFnumber")) & chr(34) & chr(41)
						strpopup = "javascript:popUp(" & chr(34)
						strOut = "<b><a href='" & strpopup & "http://www.indexfungorum.org/Names/namesrecord.asp?RecordID=" & strID & "'>" & strText & "</a></b>"
					else
						strID = strn(rs("FinalNameDataIF-DFnumber")) & chr(34) & chr(41)
						strpopup = "javascript:popUp(" & chr(34)
						strOut = "<b><a href='" & strpopup & "http://www.indexfungorum.org/Names/genusrecord.asp?RecordID=" & strID & "'>" & strText & "</a></b>"
					end if
				else
					strOut = "<b>" & strText & "</b>"
				end if
			' add substratum details
			strText = strn(rs("Substratum"))
			if strText <> "" then 
				if strn(rs("Vouchered")) = "g" then
					strOut = strOut & ", isolated from " & strText
				elseif strn(rs("Vouchered")) = "h" then
					strOut = strOut & ", on " & strText
				else
					strOut = strOut & ", on/isolated from " & strText
				end if
			else
				strOut = strOut & ", on/isolated from"
			end if
			' add associated organism details
			strText = strn(rs("AssociatedOrganism"))
			if strText <> "" then 
			' link to IPNI with javascript popup
			strLink = strn(rs("AssociatedOrganismFK"))
					if strLink <> "" then
						if instr(strText," ") <> 0 then
							if strn(rs("AssociatedOrganismType")) = "p" then
								strID = strn(rs("AssociatedOrganismFK")) & "-1&query_type=by_id&back_page=query_ipni.html&output_format=object_view" & chr(34) & chr(41)
								strpopup = "javascript:popUp(" & chr(34)
								strOut = strOut & ", of/associated with <i><a href='" & strpopup & "http://www.ipni.org/ipni/plantsearch?id=" & strID & "'>" & strText & "</a></i>"
							elseif strn(rs("AssociatedOrganismType")) = "f" then
								strID = strn(rs("AssociatedOrganismFK")) & chr(34) & chr(41)
								strpopup = "javascript:popUp(" & chr(34)
								strOut = strOut & ", of/associated with <i><a href='" & strpopup & "http://www.indexfungorum.org/Names/namesrecord.asp?RecordID=" & strID & "'>" & strText & "</a></i>"
							else
								strOut = strOut & ", of/associated with <i>" & strText & "</i>"
							end if
						elseif instr(strText," ") = 0 then
							if strn(rs("AssociatedOrganismType")) = "f" then
								strID = strn(rs("AssociatedOrganismFK")) & chr(34) & chr(41)
								strpopup = "javascript:popUp(" & chr(34)
								strOut = strOut & ", of/associated with <i><a href='" & strpopup & "http://www.indexfungorum.org/Names/genusrecord.asp?RecordID=" & strID & "'>" & strText & "</a></i>"
							else
								strOut = strOut & ", of/associated with <i>" & strText & "</i>"
							end if
						else
							strOut = strOut & ", of/associated with <i>" & strText & "</i>"
						end if
					else
						strOut = strOut & ", of/associated with <i>" & strText & "</i>"
					end if
			end if
			' add Country details
			if strn(rs("L4country")) <> "" then
				strOut = strOut & ", " & strn(rs("L4country"))
			else
				if strn(rs("L3area")) <> "" then
					strOut = strOut & ", " & strn(rs("L3area"))
				else
					if strn(rs("L2region")) <> "" then
						strOut = strOut & ", " & strn(rs("L2region"))
					else
						if strn(rs("L1continent")) <> "" then
							strOut = strOut & ", " & strn(rs("L1continent"))
						else
							if strn(rs("Locality")) <> "" then
								strOut = strOut & ", " & strn(rs("Locality"))
							else
								if strn(rs("L4ISOcountry")) <> "" then
									strOut = strOut & ", " & strn(rs("L4ISOcountry"))
								else
									strOut = strOut & ", unlocalized"
								end if
							end if
						end if
					end if
				end if
			end if
			strText = strn(rs("Collector"))
				if strText <> "" then strOut = strOut & ", " & strText
			strText = strn(rs("DayOfCollection"))
				if strText <> "" then strOut = strOut & ", " & strText
			strText = strn(rs("MonthOfCollection"))
				if strText <> "" then strOut = strOut & "/" & strText
			strText = strn(rs("YearOfCollection"))
				if strText <> "" then strOut = strOut & "/" & strText
				' add link to GRC site
				strGRC = rs("Vouchered")
				if strGRC = "g" then
					strID = rs("IMI")
					strGRC = "<a href=http://194.203.77.76/grc/DisplayResults.asp?strGRCNumber=" & strID & " target=_blank>" & strID & "</a>"
					'build popup for LabelData
						strText = rs("IMI") & chr(34) & chr(41)
						strpopup = "javascript:popUp(" & chr(34)
						strOut = strOut & ", <a href='" & strpopup & "LabelData.asp?RecordID=" & strText & "'>IMI</a></i>"
					strOut = strOut & " " & strGRC
				else
					'check for discards
					strID = rs("IMI")
					strStatus = strn(rs("Vouchered"))
					if strStatus = "" or strStatus = "d" then
						strOut = strOut & ", IMI <font color='#666666'> <b>" & strID & "</b></font>"
					else
						'build popup for LabelData
						strText = rs("IMI") & chr(34) & chr(41)
						strpopup = "javascript:popUp(" & chr(34)
						strOut = strOut & ", <a href='" & strpopup & "LabelData.asp?RecordID=" & strText & "'>IMI</a></i>"
						strOut = strOut & " <b>" & strID & "</b>"
					end if
				end if
			strText = strn(rs("SpecimenTypeStatus"))
			if strText <> "" then
				strOut = strOut & " <font color='#FF0000'><b>" & strText & "</b></font>"
			end if
			strOut = trim(strOut)
			if right(strOut,1) = "," then strOut = left(strOut,len(strOut)-1)
			strOut = "<p>" & strOut & "</p>"
			response.write(strOut)
		end if
	else
		strText = strn(rs("NameOfFungus"))
		if strText <> "" then 
			' link to IndexFungorum with javascript popup
			strLink = strn(rs("NameOfFungusNumber"))
				if strLink <> "" then
		' NEED CODE HERE TO DEAL WITH 5nnnnn NUMBERS
					if instr(strText," ") <> 0 then
						strID = strn(rs("NameOfFungusNumber")) & chr(34) & chr(41)
						strpopup = "javascript:popUp(" & chr(34)
						strOut = "<b><a href='" & strpopup & "http://www.indexfungorum.org/Names/namesrecord.asp?RecordID=" & strID & "'>" & strText & "</a></b>"
					else
						strID = strn(rs("NameOfFungusNumber")) & chr(34) & chr(41)
						strpopup = "javascript:popUp(" & chr(34)
						strOut = "<b><a href='" & strpopup & "http://www.indexfungorum.org/Names/genusrecord.asp?RecordID=" & strID & "'>" & strText & "</a></b>"
					end if
				else
					strOut = "<b>" & strText & "</b>"
				end if
			' add substratum details
			strText = strn(rs("Substratum"))
			if strText <> "" then 
				if strn(rs("SpecimenCulture")) = "c" then
					strOut = strOut & ", isolated from " & strText
				elseif strn(rs("SpecimenCulture")) = "s" then
					strOut = strOut & ", on " & strText
				else
					strOut = strOut & ", on/isolated from " & strText
				end if
			else
				strOut = strOut & ", on/isolated from"
			end if
			' add associated organism details
			strText = strn(rs("AssociatedOrganism"))
			if strText <> "" then 
			' link to IPNI with javascript popup
			strLink = strn(rs("AssociatedOrganismNumber"))
					if strLink <> "" then
						if instr(strText," ") <> 0 then
							if strn(rs("AssociatedOrganismType")) = "p" then
								strID = strn(rs("AssociatedOrganismNumber")) & "-1&query_type=by_id&back_page=query_ipni.html&output_format=object_view" & chr(34) & chr(41)
								strpopup = "javascript:popUp(" & chr(34)
								strOut = strOut & ", of/associated with <i><a href='" & strpopup & "http://www.ipni.org/ipni/plantsearch?id=" & strID & "'>" & strText & "</a></i>"
							elseif strn(rs("AssociatedOrganismType")) = "f" then
								strID = strn(rs("AssociatedOrganismNumber")) & chr(34) & chr(41)
								strpopup = "javascript:popUp(" & chr(34)
								strOut = strOut & ", of/associated with <i><a href='" & strpopup & "http://www.indexfungorum.org/Names/namesrecord.asp?RecordID=" & strID & "'>" & strText & "</a></i>"
							else
								strOut = strOut & ", of/associated with <i>" & strText & "</i>"
							end if
						elseif instr(strText," ") = 0 then
							if strn(rs("AssociatedOrganismType")) = "f" then
								strID = strn(rs("AssociatedOrganismNumber")) & chr(34) & chr(41)
								strpopup = "javascript:popUp(" & chr(34)
								strOut = strOut & ", of/associated with <i><a href='" & strpopup & "http://www.indexfungorum.org/Names/genusrecord.asp?RecordID=" & strID & "'>" & strText & "</a></i>"
							else
								strOut = strOut & ", of/associated with <i>" & strText & "</i>"
							end if
						else
							strOut = strOut & ", of/associated with <i>" & strText & "</i>"
						end if
					else
						strOut = strOut & ", of/associated with <i>" & strText & "</i>"
					end if
			end if
			' add Country details
			if strn(rs("L4country")) <> "" then
				strOut = strOut & ", " & strn(rs("L4country"))
			else
				if strn(rs("L3area")) <> "" then
					strOut = strOut & ", " & strn(rs("L3area"))
				else
					if strn(rs("L2region")) <> "" then
						strOut = strOut & ", " & strn(rs("L2region"))
					else
						if strn(rs("L1continent")) <> "" then
							strOut = strOut & ", " & strn(rs("L1continent"))
						else
							if strn(rs("Locality")) <> "" then
								strOut = strOut & ", " & strn(rs("Locality"))
							else
								if strn(rs("L4ISOcountry")) <> "" then
									strOut = strOut & ", " & strn(rs("L4ISOcountry"))
								else
									strOut = strOut & ", unlocalized"
								end if
							end if
						end if
					end if
				end if
			end if
			strText = strn(rs("Year"))
				if strText <> "" then strOut = strOut & ", " & strText
			strText = strn(rs("IMInumber"))
			if strText <> "" then
				' add link to UKNCC site
				strUKNCC = strn(rs("UKNCCnumber"))
				if strUKNCC <> "" then
					strUKNCC = "<a href=http://www.ukncc.co.uk/html/Databases/Data.asp?DATA=" & strUKNCC & " target=_blank>" & strText & "</a>"
					'build popup for LabelData
						strID = strn(rs("IMInumber")) & chr(34) & chr(41)
						strpopup = "javascript:popUp(" & chr(34)
						strOut = strOut & ", <a href='" & strpopup & "LabelData.asp?RecordID=" & strID & "'>IMI</a></i>"
					strOut = strOut & " " & strUKNCC
				else
					'check for discards
					strStatus = strn(rs("Vouchered"))
					if strStatus = "" or strStatus = "d" then
						strOut = strOut & ", IMI <font color='#666666'> <b>" & strText & "</b></font>"
					else
						'build popup for LabelData
						strID = strn(rs("IMInumber")) & chr(34) & chr(41)
						strpopup = "javascript:popUp(" & chr(34)
						strOut = strOut & ", <a href='" & strpopup & "LabelData.asp?RecordID=" & strID & "'>IMI</a></i>"
						strOut = strOut & " <b>" & strText & "</b>"
					end if
				end if
			end if
			strText = strn(rs("TypeStatus"))
			if strText <> "" then
				strOut = strOut & " <font color='#FF0000'><b>" & strText & "</b></font>"
			end if
			strOut = trim(strOut)
			if right(strOut,1) = "," then strOut = left(strOut,len(strOut)-1)
			strOut = "<p>" & strOut & "</p>"
			response.write(strOut)
		end if
	end if
		rs.movenext
	next
	NavForm
end sub

function strn(str)
	if isnull(str) then 
		strn = ""
	else
		strn = str
	end if  
end function

sub DisplayRes
	strIP = request.servervariables("LOCAL_ADDR")
	if strIP = "10.0.5.4" then
		if strCountry <> "" then
			' check type of request
			if len(strCountry) <> 2 then
			' it's a TDWG request
			strField = left(strCountry,6)
				if strField = "L1Code" then
					strSearch = right(strCountry,1)
				elseif strField = "L2Code" then
					strSearch = right(strCountry,2)
				elseif strField = "L3Code" then
					strSearch = right(strCountry,3)
				elseif strField = "L4Code" then
					strSearch = right(strCountry,6)
				else
				end if
			' its and ISO request
			else
				strSearch = strCountry
				strField = "L4ISOcode"
			end if
			strSql = "SELECT tblHerbIMI.[FinalNameDataIF-DFnumber], tblHerbIMI.FinalNameDataEdited, tblHerbIMI.AssociatedOrganism, " _
				& "tblHerbIMI.AssociatedOrganismType, tblHerbIMI.AssociatedOrganismFK, tblHerbIMI.DayOfCollection, tblHerbIMI.MonthOfCollection, tblHerbIMI.YearOfCollection, " _
				& "tblHerbIMI.IMINumber AS IMI, tblHerbIMI.Substratum, tblHerbIMI.Vouchered, tblHerbIMI.Collector, tblHerbIMI.SpecimenTypeStatus, tblGeography.* " _
				& "FROM tblHerbIMI INNER JOIN tblGeography ON tblHerbIMI.IMInumberNumeric = tblGeography.IMInumber"
			if strField = "L1Code" or strField = "L2Code" then
				strSQL = strSQL & " WHERE ((([tblGeography].[" & protectSQL(strField, false) & "]) = " & protectSQL(strSearch, false) & "))"
			else
				strSQL = strSQL & " WHERE ((([tblGeography].[" & protectSQL(strField, false) & "]) = '" & protectSQL(strSearch, false) & "'))"
			end if
				strSQL = strSQL & " AND tblHerbIMI.FinalNameDataEdited <> ''"
				strSQL = strSQL & " ORDER BY tblHerbIMI.FinalNameDataEdited;"
		elseif strAssociation <> "" then
			strSql = "SELECT tblHerbIMI.[FinalNameDataIF-DFnumber], tblHerbIMI.FinalNameDataEdited, tblHerbIMI.AssociatedOrganism, " _
				& "tblHerbIMI.AssociatedOrganismType, tblHerbIMI.AssociatedOrganismFK, tblHerbIMI.DayOfCollection, tblHerbIMI.MonthOfCollection, tblHerbIMI.YearOfCollection, " _
				& "tblHerbIMI.IMINumber AS IMI, tblHerbIMI.Substratum, tblHerbIMI.Vouchered, tblHerbIMI.Collector, tblHerbIMI.SpecimenTypeStatus, tblGeography.* " _
				& "FROM tblHerbIMI INNER JOIN tblGeography ON tblHerbIMI.IMInumberNumeric = tblGeography.IMInumber " _
				& "WHERE (((tblHerbIMI.AssociatedOrganism) = '" & protectSQL(strAssociation, false) & "'));"
		elseif strIMINumber <> "" then
			strSql = "SELECT tblHerbIMI.[FinalNameDataIF-DFnumber], tblHerbIMI.FinalNameDataEdited, tblHerbIMI.AssociatedOrganism, " _
				& "tblHerbIMI.AssociatedOrganismType, tblHerbIMI.AssociatedOrganismFK, tblHerbIMI.DayOfCollection, tblHerbIMI.MonthOfCollection, tblHerbIMI.YearOfCollection, " _
				& "tblHerbIMI.IMINumber AS IMI, tblHerbIMI.Substratum, tblHerbIMI.Vouchered, tblHerbIMI.Collector, tblHerbIMI.SpecimenTypeStatus, tblGeography.* " _
				& "FROM tblHerbIMI INNER JOIN tblGeography ON tblHerbIMI.[IMINumberNumeric] = tblGeography.IMInumber " _
				& "WHERE (((tblHerbIMI.IMINumber) = '" & protectSQL(strIMINumber,true) & "')) " _
				& "ORDER BY tblHerbIMI.[IMINumberNumeric];"
		elseif strName <> "" then
			strSql = "SELECT tblHerbIMI.[FinalNameDataIF-DFnumber], tblHerbIMI.FinalNameDataEdited, tblHerbIMI.AssociatedOrganism, " _
				& "tblHerbIMI.AssociatedOrganismType, tblHerbIMI.AssociatedOrganismFK, tblHerbIMI.DayOfCollection, tblHerbIMI.MonthOfCollection, tblHerbIMI.YearOfCollection, " _
				& "tblHerbIMI.IMINumber AS IMI, tblHerbIMI.Substratum, tblHerbIMI.Vouchered, tblHerbIMI.Collector, tblHerbIMI.SpecimenTypeStatus, tblGeography.* " _
				& "FROM tblHerbIMI INNER JOIN tblGeography ON tblHerbIMI.[IMINumberNumeric] = tblGeography.IMInumber " _
				& "WHERE (((tblHerbIMI.FinalNameDataEdited) = '" & protectSQL(strName, false) & "')) " _
				& "ORDER BY tblHerbIMI.[IMINumberNumeric];"
		else
			response.write("Invalid query string<br>")
			exit sub
		end if
	else
		if strCountry <> "" then
			' check type of request
			if len(strCountry) <> 2 then
			' it's a TDWG request
			strField = left(strCountry,6)
				if strField = "L1Code" then
					strSearch = right(strCountry,1)
				elseif strField = "L2Code" then
					strSearch = right(strCountry,2)
				elseif strField = "L3Code" then
					strSearch = right(strCountry,3)
				elseif strField = "L4Code" then
					strSearch = right(strCountry,6)
				else
				end if
			' its and ISO request
			else
				strSearch = strCountry
				strField = "L4ISOcode"
			end if
			strSql = "SELECT tblHerbIMI.NameOfFungusNumber, tblHerbIMI.NameOfFungus, tblHerbIMI.AssociatedOrganism, " _
				& "tblHerbIMI.AssociatedOrganismType, tblHerbIMI.AssociatedOrganismNumber, tblHerbIMI.UKNCCnumber, " _
				& "tblHerbIMI.Substratum, tblHerbIMI.Vouchered, tblHerbIMI.SpecimenCulture, tblHerbIMI.TypeStatus, tblGeography.* " _
				& "FROM tblHerbIMI INNER JOIN tblGeography ON tblHerbIMI.AccessionNumber = tblGeography.IMInumber"
			if strField = "L1Code" or strField = "L2Code" then
				strSQL = strSQL & " WHERE ((([tblGeography].[" & protectSQL(strField, false) & "]) = " & protectSQL(strSearch, false) & "))"
			else
				strSQL = strSQL & " WHERE ((([tblGeography].[" & protectSQL(strField, false) & "]) = '" & protectSQL(strSearch, false) & "'))"
			end if
				strSQL = strSQL & " AND tblHerbIMI.NameOfFungus <> ''"
				strSQL = strSQL & " ORDER BY tblHerbIMI.NameOfFungus;"
		elseif strAssociation <> "" then
			strSql = "SELECT tblHerbIMI.NameOfFungusNumber, tblHerbIMI.NameOfFungus, tblHerbIMI.AssociatedOrganism, " _
				& "tblHerbIMI.AssociatedOrganismType, tblHerbIMI.AssociatedOrganismNumber, tblHerbIMI.Year, tblHerbIMI.UKNCCnumber, " _
				& "tblHerbIMI.Substratum, tblHerbIMI.Vouchered, tblHerbIMI.SpecimenCulture, tblHerbIMI.TypeStatus, tblGeography.* " _
				& "FROM tblHerbIMI INNER JOIN tblGeography ON tblHerbIMI.AccessionNumber = tblGeography.IMInumber " _
				& "WHERE (((tblHerbIMI.AssociatedOrganism) = '" & protectSQL(strAssociation, false) & "'));"
		elseif strIMINumber <> "" then
			strSql = "SELECT tblHerbIMI.NameOfFungusNumber, tblHerbIMI.NameOfFungus, tblHerbIMI.AssociatedOrganism, " _
				& "tblHerbIMI.AssociatedOrganismType, tblHerbIMI.AssociatedOrganismNumber, tblHerbIMI.Year, tblHerbIMI.UKNCCnumber, " _
				& "tblHerbIMI.Substratum, tblHerbIMI.Vouchered, tblHerbIMI.SpecimenCulture, tblHerbIMI.TypeStatus, tblGeography.* " _
				& "FROM tblHerbIMI INNER JOIN tblGeography ON tblHerbIMI.AccessionNumber = tblGeography.IMInumber " _
				& "WHERE (((tblHerbIMI.IMINumber) = '" & protectSQL(strIMINumber,true) & "'));"
		elseif strName <> "" then
			strSql = "SELECT tblHerbIMI.NameOfFungusNumber, tblHerbIMI.NameOfFungus, tblHerbIMI.AssociatedOrganism, " _
				& "tblHerbIMI.AssociatedOrganismType, tblHerbIMI.AssociatedOrganismNumber, tblHerbIMI.Year, tblHerbIMI.UKNCCnumber, " _
				& "tblHerbIMI.Substratum, tblHerbIMI.Vouchered, tblHerbIMI.SpecimenCulture, tblHerbIMI.TypeStatus, tblGeography.* " _
				& "FROM tblHerbIMI INNER JOIN tblGeography ON tblHerbIMI.AccessionNumber = tblGeography.IMInumber " _
				& "WHERE (((tblHerbIMI.NameOfFungus) = '" & protectSQL(strName, false) & "')) " _
				& "ORDER BY tblHerbIMI.AccessionNumber;"
		else
			response.write("Invalid query string<br>")
			exit sub
		end if
	end if

		Set dbConn = Server.CreateObject("ADODB.Connection")
	if true then        
       strConn = GetConnectionString()
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "192.168.0.3" then
'	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_WEBSERVER;Initial Catalog=herbIMI;Data Source=webserver"
	   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\herbimi\herbimi.mdb"
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=herbIMI;Data Source=AINSWORTH"
	   dbConn.open strConn
	elseif strIP = "194.203.77.76" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_INDEXFUNGORUM;Initial Catalog=herbIMI;Data Source=indexfungorum"
	   dbConn.open strConn
	elseif strIP = "194.131.255.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_INDEXFUNGORUM;Initial Catalog=herbIMI;Data Source=indexfungorum"
	   dbConn.open strConn
	elseif strIP = "192.168.0.1" then
	   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\herbimi\herbimi.mdb"
	   dbConn.open strConn
	elseif strIP = "127.0.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\herbimi\herbimi.mdb"
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=herbimi"
	end if
	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.Open strSql, dbConn, 3, 3
	if not rs.bof then 
		rs.pagesize = intPageSize
		rs.movelast
		rs.movefirst
		intNumRecords = rs.recordcount
		intPageCount = rs.Pagecount
		ResList(rs)
	else
		response.write("No records found.<br>")
	end if
	rs.close
	set rs = nothing
	dbConn.close
	set dbConn = nothing
end sub
%>
            <!-- InstanceEndEditable --><!-- InstanceBeginEditable name="Main" -->
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
      &copy; 2008<font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#333333"> 
      <a href="http://www.cabi.org/">CABI</a></font>. Return to <a href="Index.htm">main 
      page</a>. Return to <a href="#TopOfPage">top of page</a>.</td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
