<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/HerbIMI.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>HerbIMI-Online - country search</title>
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
   dim strSearch, strType, intPageNumber, intNumRecords, intPageSize, strGenus, intPageCount
   dim strContinent, strRegion, strArea, strCountry
   
   strSearch = session("strSearch")
   strGenus = session("strGenus")
   strType = session("strType")
   strContinent = session("strContinent")
   strRegion = session("strRegion")
   strArea = session("strArea")
   intPageSize = 50

   if request.form.item("Submit") = "Search for Country" then
      	 intPageNumber = "1"
   	  	 strSearch = request.form.item("SearchTerm")
         session("strSearch") = strSearch
   	  	 strType = "G"
		 session("strType") = strType
   elseif request.form.item("Submit") = "View Countries" then
      	 intPageNumber = "1"
   	  	 strType = "KS"
         session("strType") = strType
		 strGenus = ""
		 session("strGenus") = ""
   elseif request.querystring.item("RecordID") <> "" then
      	 intPageNumber = "1"
   		 strType = request.querystring.item("Type")
		 session("strType") = strType

		 select case strType
		 case "K"
		 	  strContinent = request.querystring.item("RecordID")
			  session("strContinent") = strContinent
		 case "P"
		 	  strRegion = request.querystring.item("RecordID")
			  session("strRegion") = strRegion
		 case "C"
		 	  strArea = request.querystring.item("RecordID")
			  session("strArea") = strArea
		 case "S"
		 	  strSubClass = request.querystring.item("RecordID")
			  session("strCountry") = strCountry
	    end select
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

sub DisplayRes 
dim strSQL, dbConn, RS
	if strType = "G" and strSearch = "" then exit sub
	Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
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

if strType = "" then exit sub
   select case strType

   	 case "G" 'Search
       strSQL = "SELECT tblTDWGgeography.* " _
			& "FROM tblTDWGgeography " _
			& "WHERE (((tblTDWGgeography.[L4ISOcode]) = '" & protectSQL(strSearch, false) & "')) " _
			& "ORDER BY tblTDWGgeography.[L4ISOcode];"

     case "KS" 'Continent
       strSQL = "SELECT DISTINCT tblTDWGgeography.L1continent, " _
	   		& "tblTDWGgeography.Ref1, " _
	   		& "tblTDWGgeography.L1code " _
	 		& "FROM tblTDWGgeography " _
			& "ORDER BY tblTDWGgeography.L1continent; "

      case "K" 'Region
        strSql = "SELECT DISTINCT tblTDWGgeography.L2region, " _
	 		& "tblTDWGgeography.L1continent, " _
			& "tblTDWGgeography.Ref2, " _
	   		& "tblTDWGgeography.L2code " _
			& "FROM tblTDWGgeography " _
			& "WHERE (((tblTDWGgeography.L1continent)='" & protectSQL(strContinent, false) & "')) " _
			& "ORDER BY tblTDWGgeography.L2region;"

	  case "P" 'Area
        strSql = "SELECT DISTINCT tblTDWGgeography.L3area, " _
	 		& "tblTDWGgeography.L1continent, " _
			& "tblTDWGgeography.L2region, " _
			& "tblTDWGgeography.Ref3, " _
	   		& "tblTDWGgeography.L3code " _
			& "FROM tblTDWGgeography " _
			& "WHERE (((tblTDWGgeography.L2region)='" & protectSQL(strRegion, false) & "')) " _
			& "ORDER BY tblTDWGgeography.L3area;"

 	   case "C" ' Country
        strSql = "SELECT DISTINCT tblTDWGgeography.L4country, " _
			& "tblTDWGgeography.L1continent, " _
			& "tblTDWGgeography.L2region, " _
			& "tblTDWGgeography.L3area, " _
			& "tblTDWGgeography.Ref4, " _
	   		& "tblTDWGgeography.L4code " _
			& "FROM tblTDWGgeography " _
			& "WHERE (((tblTDWGgeography.L3area)='" & protectSQL(strArea, false) & "')) " _
			& "ORDER BY tblTDWGgeography.L4country;"
	  case else
	        exit sub
  end select
  Set RS = Server.CreateObject("ADODB.Recordset")
  RS.Open strSql, dbConn, 3
	if not rs.bof then
       rs.pagesize = intPageSize
	   rs.movelast
	   rs.movefirst
	   intNumRecords = rs.recordcount
		intPageCount = rs.pagecount
	    ResList(RS)
	else
	   response.write("No records found<br>")
	end if
  RS.close
  set RS=nothing
  dbConn.close
  set dbConn = nothing
end sub

sub ResList (rs)
	dim strLink, i, strOut, strGenus
	  select case strType
	    case "G" 
	  	 response.write("<p></p><b>Country:</b><p></p>") 
	  	 for i = 1 to rs.PageSize
	  	   if rs.eof then exit for
		   if rs.bof then exit for 
		   strCountry = rs("L4country")
		   strLink = "DisplayResults.asp?strCountry=" & server.urlencode(rs("L4ISOcode")) 
		   response.write("<a href=" & strLink & " >" & strCountry & "</a>")			  	  		  	  
		   session("strGenus") = strGenus
		   session("strCountry") = strCountry
		   session("strArea") = strArea
		   session("strRegion") = strRegion
		   session("strContinent")  = strContinent
		   RS.Movenext
		   response.write("<br>")
   	     next

	    case "KS" 
		 response.write("<b>Continent</b>") 
		 response.write("<table border='0' cellspacing='2' cellpadding='2' class='mainbody'>")
	  	 for i = 1 to rs.PageSize
		   if rs.eof then exit for
		   if rs.bof then exit for
		   strLink = "countries.asp?RecordID=" & server.urlencode(rs("L1continent")) & "&Type=K"
		   strLink2 = "DisplayResults.asp?strCountry=L1Code+" & server.urlencode(rs("L1code"))		   
		   response.write("<tr>")
		   response.write("<td width='200' nowrap>" & rs("L1continent") & "</td>")
		   		if rs("Ref1") = 1 then
				   response.write("<td><a href=" & strLink2 & ">Show records</a></td>")
					response.write("<td><a href=" & strLink & " >Move to next level for " & rs("L1continent") & "</a></td>")
				else
					response.write("<td><font color='#666666'>No records for " & rs("L1continent") & "</font></td>")
				   response.write("<td>&nbsp;</td>")
				end if
		   response.write("</tr>")		   
 		   RS.Movenext
   	     next
		   response.write("</table>")

	   case "K" 
	  	 response.write("<b>Regions in Continent: " & strContinent & "</b>") 
		 response.write("<table border='0' cellspacing='2' cellpadding='2' class='mainbody'>")
	  	 for i = 1 to rs.PageSize
	  	   if rs.eof then exit for
		   if rs.bof then exit for
		   if isnull(rs("L2region")) then 
		   	  strOut = "not assigned"
		   else
		   	  strOut = rs("L2region")
		   end if
		   strLink = "countries.asp?RecordID=" & server.urlencode(strOut) & "&Type=P"
		   strLink2 = "DisplayResults.asp?strCountry=L2Code+" & server.urlencode(rs("L2code"))
		   response.write("<tr>")
		   response.write("<td width='200' nowrap>" & strOut & "</td>")
		   		if rs("Ref2") = 1 then
				   response.write("<td><a href=" & strLink2 & ">Show records</a></td>")
					response.write("<td><a href=" & strLink & " >Move to next level for " & rs("L2region") & "</a></td>")
				else
					response.write("<td><font color='#666666'>No records for " & rs("L2region") & "</font></td>")
				   response.write("<td>&nbsp;</td>")
				end if
		   response.write("</tr>")
 		   RS.Movenext
   	     next
		   response.write("</table>")
		   
	   case "P" 
	  	 response.write("<b>Areas in Region: " & strRegion & ", in Continent: " & strContinent & "</b>") 
		 response.write("<table border='0' cellspacing='2' cellpadding='2' class='mainbody'>")
	  	 for i = 1 to rs.PageSize
	  	   if rs.eof then exit for
		   if rs.bof then exit for
		   if isnull(rs("L3area")) then 
				strOut = "not assigned"
		   else
				strOut = rs("L3area")
		   end if
		   strLink = "countries.asp?RecordID=" & server.urlencode(strOut) & "&Type=C"
		   strLink2 = "DisplayResults.asp?strCountry=L3Code+" & server.urlencode(rs("L3code"))
		   response.write("<tr>")
		   response.write("<td width='200' nowrap>" & strOut & "</td>")
		   		if rs("Ref3") = 1 then
		   response.write("<td><a href=" & strLink2 & ">Show Records</a></td>")
					response.write("<td><a href=" & strLink & " >Move to next level for " & rs("L3area") & "</a></td>")
				else
					response.write("<td><font color='#666666'>No records for " & rs("L3area") & "</font></td>")
				   response.write("<td>&nbsp;</td>")
				end if
 		   RS.Movenext
		   response.write("</tr>")
   	     next
		   response.write("</table>")
		   
	   case "C" 
	  	 response.write("<p></p><b>Countries in Area: " & strArea & ", in Region: " & strRegion & ", in Continent: " & strContinent & "</b>") 
		 response.write("<table border='0' cellspacing='2' cellpadding='2' class='mainbody'>")
	  	 for i = 1 to rs.PageSize
	  	   if rs.eof then exit for
		   if rs.bof then exit for
		   if isnull(rs("L4Country")) then 
		   	  strOut = "not assigned"
		   else
		   	   strOut = rs("L4Country")
		   end if
		   strLink2 = "DisplayResults.asp?strCountry=L4Code+" & server.urlencode(rs("L4code")) 
		   response.write("<tr>")		   
		   response.write("<td width='200' nowrap>" & strOut & "</td>")
		   response.write("<td><a href=" & strLink2 & ">Show</a></td>")
 		   RS.Movenext
		   response.write("</tr>")
   	     next
		 response.write("</table>")
	 end select
end sub
%>
            <%
function FillCountriesDrop
	dim rs, dbConn, strSql
	Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
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

		strSql = "SELECT tblISOCountries.* FROM tblISOCountries ORDER BY tblISOCountries.ISOCountry;"
		Set rs = Server.CreateObject("ADODB.Recordset")
		rs.Open strSql, dbConn, 3
		if rs.RecordCount > 0 then
			response.write("<select name='SearchTerm'>")
				rs.MoveFirst
					response.write("<option value=''></option>")
					do while not rs.eof
					response.write("<option value='" & rs("ISOCode") & "'>" & rs("ISOCountry") & "</option>")
					rs.MoveNext
				loop
			response.write("</select>")
			end if
			rs.close
			set rs = Nothing	
			dbConn.close
			set dbConn = Nothing
end function
%>
            <!-- InstanceEndEditable --><!-- InstanceBeginEditable name="Main" --> 
            <form method="post" action="countries.asp">
              <table border="1" bgcolor="#99FF99" bordercolor="#000000">
                <tr bgcolor="#99FF99" bordercolor="#99FF99"> 
                  <td bordercolor="#99FF99"><b><font face="Verdana, Arial, Helvetica, sans-serif">Country:</font></b> 
                  </td>
                  <td> 
                    <%
FillCountriesDrop
%>
                  </td>
                </tr>
                <tr bgcolor="#99FF99" bordercolor="#99FF99"> 
                  <td> <input type="submit" name="Submit" style="width: 150px" value="View Countries"> 
                  </td>
                  <td> <input type="submit" name="Submit" style="width: 150px" value="Search for Country"> 
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
      &copy; 2008<font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#333333"> 
      <a href="http://www.cabi.org/">CABI</a></font>. Return to <a href="Index.htm">main 
      page</a>. Return to <a href="#TopOfPage">top of page</a>.</td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
