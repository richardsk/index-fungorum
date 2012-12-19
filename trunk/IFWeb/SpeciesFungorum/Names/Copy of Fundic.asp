<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- #BeginTemplate "/Templates/templ.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Dictionary of the Fungi</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
<!--
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=700,height=495,left=100,top=00');");
}

function MM_displayStatusMsg(msgStr) { //v1.0
  status=msgStr;
  document.MM_returnValue = true;
}
//-->
</script>
<script type="text/javascript">
<!--
var d = new Date();
var curr_year = d.getFullYear();
//-->
</script>
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
</head> 
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#9CFF9C">
<a name="TopOfPage"></a> 
<table width="100%" height="100%" class="mainbody">
  <tr>
    <td height="105"> 
      <table width="100%" border="0" class="mainbody">
        <tr> 
          <td width="59%" class="h1"> <img src="../IMAGES/CABILogo.gif" width="100" height="100"> 
            CABI databases</td>
          <td width="41%" valign="top"><table height="100%" align="right" halign="center">
              <tr class="mainbody"> 
                <td width="267"><a href="./Names/Names.asp" onMouseOver="MM_displayStatusMsg('Search Index Fungorum');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Species Fungorum</a> : <font color="#FF0000"><strong><a href=javascript:popUp("SpeciesFungorumCookies.htm") onMouseOver="MM_displayStatusMsg('Cookies');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Cookies</a></strong></font></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="./BSM/bsm.asp" onMouseOver="MM_displayStatusMsg('Search Bibliography of Systematic Mycology');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Bibliography of Systematic Mycology</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="./Names/Fundic.asp" onMouseOver="MM_displayStatusMsg('Search Dictionary of the Fungi Hierarchy');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Dictionary of the Fungi Hierarchy</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="./GSD/GSDquery.asp" onMouseOver="MM_displayStatusMsg('Search Species 2000 Fungal GSDs');return document.MM_returnValue" onMouseOut="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Species 2000 Fungal GSDs</a></td>
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
          <td bgcolor="#CCFFCC"><!-- #BeginEditable "head" -->
<%
dim strSearch, strType, intPageNumber, intNumRecords, intPageSize, strGenus, intPageCount
dim strKingdom, strPhylum, strClass, strSubClass, strOrder, strFamily
   
   strSearch = session("strSearch")
   strGenus = session("strGenus")
   strType = session("strType")
   strKingdom = session("strKingdom")
   strPhylum = session("strPhylum")
   strClass = session("strClass")
   strSubClass = session("strSubClass")
   strOrder = session("strOrder")
   strFamily = session("strFamily")
   intPageSize = 50

   if request.form.item("Submit") = "Search for genus" then
      	 intPageNumber = "1"
   	  	 strSearch = request.form.item("SearchTerm")
         session("strSearch") = strSearch
   	  	 strType = "G"
		 session("strType") = strType
   elseif request.form.item("Submit") = "View Kingdoms" then
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
		 	  strKingdom = request.querystring.item("RecordID")
			  session("strKingdom") = strKingdom
		 case "P"
		 	  strPhylum = request.querystring.item("RecordID")
			  session("strPhylum") = strPhylum
		 case "C"
		 	  strClass = request.querystring.item("RecordID")
			  session("strClass") = strClass
		 case "S"
		 	  strSubClass = request.querystring.item("RecordID")
			  session("strSubClass") = strSubClass
		 case "O"
		 	  strOrder = request.querystring.item("RecordID")
			  session("strOrder") = strOrder
		 case "F"
		 	  strFamily = request.querystring.item("RecordID")
			  session("strFamily") = strFamily
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

sub NavForm 
	dim i, frm
	if intPageCount <> "" then
		frm  = "fundic"
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

sub DisplayRes 
dim strSQL, dbConn, RS
	if strType = "G" and strSearch = "" then exit sub
	Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
	if strIP = "192.168.0.3" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_WEBSERVER;Initial Catalog=IndexFungorum;Data Source=webserver"
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
	   dbConn.open strConn
	elseif strIP = "10.0.5.10" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
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
   select case strType

   	 case "G"
       strSQL = "SELECT [FundicClassification].[Genus name], " _
	 		& "[FundicClassification].[Family name], " _
			& "[FundicClassification].[Order name], " _
			& "[FundicClassification].[Subclass name], " _
			& "[FundicClassification].[Class name], " _
			& "[FundicClassification].[Phylum name], " _
			& "[FundicClassification].[Kingdom name], " _
			& "[Authors], " _
			& "[Year of publication], " _
			& "[TeleomorphLink], " _
			& "[Fundic Record Number] " _
			& "FROM [FundicClassification] " _
			& "WHERE ((([FundicClassification].[Genus name]) Like '" & strSearch & "%') " _
			& "AND ((FundicClassification.[Current Use])<>'S')) " _
			& "ORDER BY [FundicClassification].[Genus name];"

     case "KS" 
       strSQL = "SELECT DISTINCT [Kingdom name] " _
	 		& "FROM [FundicClassification] " _
			& "WHERE ((Not ([Kingdom name]) Is Null)) " _
			& "ORDER BY [Kingdom name]; "

      case "K"
        strSql = "SELECT DISTINCT [Kingdom name], " _
	 		& "[Phylum name] " _
			& "FROM [FundicClassification] " _
			& "WHERE ((([Kingdom name])='" & strKingdom & "')) " _
			& "ORDER BY [Phylum name];"

	  case "P"
        strSql = "SELECT DISTINCT [Kingdom name], " _
	 		& "[Phylum name], " _
			& "[Class name] " _
			& "FROM [FundicClassification] " _
			& "WHERE ((([Kingdom name])='" & strKingdom & "')) and "
			if strPhylum <> "not assigned" then
			   strSql = strSQL & "((([Phylum name])='" & strPhylum & "')) "
			else
			   strSql = strSql & "(([Phylum name]) is null) "
			end if
			strSql = strSql & "ORDER BY [Class name];"

 	   case "C"
        strSql = "SELECT DISTINCT [Kingdom name], " _
			& "[Phylum name], " _
			& "[Class name], " _
			& "[Subclass name] " _
			& "FROM [FundicClassification] " _
			& "WHERE ((([Kingdom name])='" & strKingdom & "')) and "
			if strPhylum <> "not assigned" then
			   strSql = strSQL & "((([Phylum name])='" & strPhylum & "')) and "
			else
			   strSql = strSql & "(([Phylum name]) is null) and "
			end if
			if strClass <> "not assigned" then
			   strSql = strSql & "((([Class name])='" & strClass & "'))"
			else
			   strSql = strSql & "(([Class name]) is null)"
			end if
			strSql = strSql & "ORDER BY [Subclass name]; "

 	   case "S"
        strSql = "SELECT DISTINCT [Kingdom name], " _
	 		& "[Phylum name], " _
			& "[Class name], " _
			& "[Subclass name], " _
			& "[Order name] " _
			& "FROM [FundicClassification] " _
			& "WHERE ((([Kingdom name])='" & strKingdom & "')) and "
			if strPhylum <> "not assigned" then
			   strSql = strSQL & "((([Phylum name])='" & strPhylum & "')) and "
			else
			   strSql = strSql & "(([Phylum name]) is null)  and "
			end if
			if strClass <> "not assigned" then
			   strSql = strSQL & "((([Class name])='" & strClass & "')) and "
			else
			   strSql = strSql & "(([Class name]) is null) and "
			end if
			if strSubClass <> "not assigned" then
			   strSql = strSQL & "((([Subclass name])='" & strSubClass & "')) "
			else
			   strSql = strSql & "(([Subclass name]) is null) "
			end if
			strSql = strSql & "ORDER BY [Order name];"

 	   case "O"
        strSql = "SELECT DISTINCT [Kingdom name], " _
	 		& "[Phylum name], " _
			& "[Class name], " _
			& "[Subclass name], " _
			& "[Order name], " _
			& "[Family name] " _
			& "FROM [FundicClassification] " _
			& "WHERE ((([Kingdom name])='" & strKingdom & "')) and "
			if strPhylum <> "not assigned" then
			   strSql = strSQL & "((([Phylum name])='" & strPhylum & "')) and "
			else
			   strSql = strSql & "(([Phylum name]) is null)  and "
			end if
			if strClass <> "not assigned" then
			   strSql = strSQL & "((([Class name])='" & strClass & "')) and "
			else
			   strSql = strSql & "(([Class name]) is null) and "
			end if
			if strSubClass <> "not assigned" then
			   strSql = strSQL & "((([Subclass name])='" & strSubClass & "')) and "
			else
			   strSql = strSql & "(([Subclass name]) is null) and "
			end if
			if strOrder <> "not assigned" then
			   strSql = strSQL & "((([Order name])='" & strOrder & "')) "
			else
			   strSql = strSql & "(([Order name]) is null) "
			end if
			strSql = strSql & "ORDER BY [Family name];"

 	   case "F"
        strSql = "SELECT [Kingdom name], " _
	 		& "[Phylum name], " _
			& "[Class name], " _
			& "[Subclass name], " _
			& "[Order name], " _
			& "[Family name], " _
			& "[Genus name], " _
			& "[Authors], " _
			& "[Year of publication], " _
			& "[Fundic Record Number] " _
			& "FROM [FundicClassification] " _
			& "WHERE ((([Kingdom name])='" & strKingdom & "')) and "
			if strPhylum <> "not assigned" then
			   strSql = strSQL & "((([Phylum name])='" & strPhylum & "')) and "
			else
			   strSql = strSql & "(([Phylum name]) is null)  and "
			end if
			if strClass <> "not assigned" then
			   strSql = strSQL & "((([Class name])='" & strClass & "')) and "
			else
			   strSql = strSql & "(([Class name]) is null) and "
			end if
			if strSubClass <> "not assigned" then
			   strSql = strSQL & "((([Subclass name])='" & strSubClass & "')) and "
			else
			   strSql = strSql & "(([Subclass name]) is null) and "
			end if
			if strOrder <> "not assigned" then
			   strSql = strSQL & "((([Order name])='" & strOrder & "')) and "
			else
			   strSql = strSql & "(([Order name]) is null) and "
			end if
			if strFamily <> "not assigned" then
			   strSql = strSQL & "((([Family name])='" & strFamily & "'))"
			else
			   strSql = strSql & "(([Family name]) is null) "
			end if
			strSql = strSQL & "and ((([Current Use])='X'))"
			strSql = strSql & "ORDER BY [Genus name];"
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

	  rs.absoluteposition=((intPageNumber-1) * rs.PageSize) + 1
	  NavForm
	  select case strType

	    case "G" 
	  	 response.write("<p></p><b>Genus, Family, Order, Subclass, Class, Phylum, Kingdom</b><p></p>") 
	  	 for i = 1 to rs.PageSize
	  	   if rs.eof then exit for
		   if rs.bof then exit for 
		   strGenus = rs("Genus name")
		   strLink = "genusrecord.asp?RecordID=" & server.urlencode(rs("Fundic Record Number")) 
		   response.write("<a href=" & strLink &  " >" & strGenus & "</a> " & rs("Authors") & " " & rs("year of publication") & ", ")			  	  		  	  

		   if rs("Phylum name") = "Anamorphic fungi" then
   	   		  if rs("TeleomorphLink") <> "" then
				  	strTeleomorph = rtrim(left(rs("TeleomorphLink"),instr(rs("TeleomorphLink")," ")))
				  if right(strTeleomorph,5) = "aceae" then
			  		strLink = "fundic.asp?RecordID=" & server.urlencode(strTeleomorph) & "&Type=F"
		      		response.write("Anamorphic <a href=" & strLink & " >" & strTeleomorph & "</a>")	
				  elseif right(strTeleomorph,4) = "ales" then
					response.write("Anamorphic " & strTeleomorph)
				  elseif right(strTeleomorph,7) = "mycetes" then
					response.write("Anamorphic " & strTeleomorph)
				  elseif right(strTeleomorph,6) = "mycota" then
					response.write("Anamorphic " & strTeleomorph)
				  else
				  	strTeleomorph = left(rs("TeleomorphLink"),instr(rs("TeleomorphLink")," "))
				  	strLink = "genusrecord.asp?RecordID=" & server.urlencode(right(rs("TeleomorphLink"),len(rs("TeleomorphLink"))-instr(rs("TeleomorphLink")," ")))
				  	response.write("Anamorphic <a href=" & strLink &  " >" & strTeleomorph & "</a>")
				  end if
			  else
			  	  response.write(rs("Phylum name"))
			  end if
		   elseif rtrim(left(rs("Phylum name"),instr(rs("Phylum name")," "))) = "Fossil" then
		   		  response.write(rs("Phylum name"))
		   else

		   if rs("family name") <> "" then
		   	  strFamily = rs("family name")
			  strLink = "fundic.asp?RecordID=" & server.urlencode(strFamily) _
		   		   	 & "&Type=F"
		      response.write("<a href=" & strLink & " >" & strFamily & "</a>, ")
		   else
		   	   strFamily = "not assigned"
		   end if
		   if rs("order name") <> "" then
		   	  strOrder = rs("order name")
			  strLink = "fundic.asp?RecordID=" & server.urlencode(strOrder) _
		   		   	 & "&Type=O"
		      response.write("<a href=" & strLink & " >" & strOrder & "</a>, ")
		   else
		   	   strOrder = "not assigned"
		   end if
		   if rs("subclass name") <> "" then
		   	  strSubclass = rs("subclass name")
		   	  strLink = "fundic.asp?RecordID=" & server.urlencode(strSubclass) _
		   		   	 & "&Type=S"
		   	  response.write("<a href=" & strLink & " >" & strSubclass & "</a>, ")
		   else
		   	   strClass = "not assigned"
		   end if
		   if rs("class name") <> "" then
		   	  strClass = rs("class name")
		   	  strLink = "fundic.asp?RecordID=" & server.urlencode(strClass) _
		   		   	 & "&Type=C"
		   	  response.write("<a href=" & strLink & " >" & strClass & "</a>, ")
		   else
		   	   strClass = "not assigned"
		   end if
		   if rs("phylum name") <> "" then
		   	  strPhylum= rs("phylum name")
		   	  strLink = "fundic.asp?RecordID=" & server.urlencode(strPhylum) _
		   		   	 & "&Type=P"
		   	  response.write("<a href=" & strLink & " >" & strPhylum & "</a>, ")
		   else
		   	   strPhylum = "not assigned"
		   end if
		   if rs("kingdom name") <> "" then
		   	  strKingdom = rs("kingdom name")
		   	  strLink = "fundic.asp?RecordID=" & server.urlencode(strKingdom) _
		   		   	 & "&Type=K" 
		   			 response.write("<a href=" & strLink & " >" & strKingdom & "</a>")
		   else
		   	   strKingdom = "not assigned"
		   end if
		   end if
		   
		   session("strGenus") = strGenus
		   session("strFamily") = strFamily
		   session("strOrder") = strOrder
		   session("strSubclass") = strSubClass
		   session("strClass") = strClass
		   session("strPhylum") = strPhylum
		   session("strKingdom")  = strKingdom
		   RS.Movenext
		   response.write("<br>")
   	     next

	    case "KS" 
		 response.write("<p></p><b>Kingdom</b><br>") 
	  	 for i = 1 to rs.PageSize
		   if rs.eof then exit for
		   if rs.bof then exit for
		   strLink = "fundic.asp?RecordID=" & server.urlencode(rs("kingdom name")) _
		   		   	 & "&Type=K" 
		   response.write("<a href=" & strLink&  " >" & rs("kingdom name") & "</a>")
 		    RS.Movenext
		   response.write("<br>")
   	     next

	   case "K" 
	  	 response.write("<p></p><b>Phyla<br> in Kingdom " & strKingdom & "</b><br>") 
	  	 for i = 1 to rs.PageSize
	  	   if rs.eof then exit for
		   if rs.bof then exit for
		   if isnull(rs("phylum name")) then 
		   	  strOut = "not assigned"
		   else
		   	  strOut = rs("phylum name")
		   end if
		   strLink = "fundic.asp?RecordID=" & server.urlencode(strOut) _
		   		   	 & "&Type=P"
		   response.write("<a href=" & strLink&  " >" & strOut & "</a>")
 		    RS.Movenext
		   response.write("<br>")
   	     next

	   case "P" 
	  	 response.write("<p></p><b>Classes<br> in Phylum " & strPhylum & ",<br> in Kingdom " & strKingdom & "</b><br>") 
	  	 for i = 1 to rs.PageSize
	  	   if rs.eof then exit for
		   if rs.bof then exit for
		   if isnull(rs("class name")) then 
		   	  strOut = "not assigned"
		   else
		   	   strOut = rs("class name")
		   end if
		   strLink = "fundic.asp?RecordID=" & server.urlencode(strOut) _
		   		   	 & "&Type=C"
		   response.write("<a href=" & strLink&  " >" & strOut & "</a>")
 		    RS.Movenext
		   response.write("<br>")
   	     next

	   case "C" 
	  	 response.write("<p></p><b>Subclasses<br> in Class " & strClass & ",<br> in Phylum " & strPhylum & ",<br> in Kingdom " & strKingdom & "</b><br>") 
	  	 for i = 1 to rs.PageSize
	  	   if rs.eof then exit for
		   if rs.bof then exit for
		   if isnull(rs("subclass name")) then 
		   	  strOut = "not assigned"
		   else
		   	   strOut = rs("subclass name")
		   end if
		   strLink = "fundic.asp?RecordID=" & server.urlencode(strOut) _
		   		   	 & "&Type=S"
		   response.write("<a href=" & strLink&  " >" & strOut & "</a>")
 		    RS.Movenext
		   response.write("<br>")
   	     next

	   case "S" 
	  	 response.write("<p></p><strong>Orders<br> in Subclass " & strSubClass & ",<br> in Class " & strClass & ",<br> in Phylum " & strPhylum & ",<br> in Kingdom " & strKingdom & "</strong><br>") 
	  	 for i = 1 to rs.PageSize
	  	   if rs.eof then exit for
		   if rs.bof then exit for
		   if isnull(rs("order name")) then 
		   	  strOut = "not assigned"
		   else
		   	   strOut = rs("order name")
		   end if
		   strLink = "fundic.asp?RecordID=" & server.urlencode(strOut) _
		   		   	 & "&Type=O"
		   response.write("<a href=" & strLink&  " >" & strOut & "</a>")
 		    RS.Movenext
		   response.write("<br>")
   	     next

	   case "O" 
	  	 response.write("<p></p><b>Families<br> in Order " & strOrder & ",<br> in Subclass " & strSubClass & ",<br> in Class " & strClass & ",<br> in Phylum " & strPhylum & ",<br> in Kingdom " & strKingdom & "</b><br>") 
	  	 for i = 1 to rs.PageSize
	  	   if rs.eof then exit for
		   if rs.bof then exit for
		   if isnull(rs("family name")) then 
		   	  strOut = "not assigned"
		   else
		   	   strOut = rs("family name")
		   end if
		   strLink = "fundic.asp?RecordID=" & server.urlencode(strOut) _
		   		   	 & "&Type=F"
		   response.write("<a href=" & strLink&  " >" & strOut & "</a>")
 		    RS.Movenext
		   response.write("<br>")
   	     next

	   case "F" 
	  	 response.write("<p></p><b>Genera<br> in Family " & strFamily & ",<br> in Order " & strOrder & ",<br> in Subclass " & strSubClass & ",<br> in Class " & strClass & ",<br> in Phylum " & strPhylum & ",<br> in Kingdom " & strKingdom & "</b><br>") 
	  	 for i = 1 to rs.PageSize
	  	   if rs.eof then exit for
		   if rs.bof then exit for
		   if isnull(rs("genus name")) then 
		   	  strOut = "not assigned"
		   else
		   	   strOut = rs("genus name")
		   end if
		   strLink = "genusrecord.asp?RecordID=" & server.urlencode(rs("Fundic Record Number")) 
		   response.write("<a href=" & strLink&  " >" & strOut & "</a> " & rs("Authors") & " " & rs("year of publication"))
 		    RS.Movenext
		   response.write("<br>")
   	     next

	 end select
	  NavForm
 end sub
%>
            <!-- #EndEditable --><!-- #BeginEditable "Main" --> 
            <h4>Classification based on 10th edition of the <a href="http://www.cabi.org/bk_BookDisplay.asp?PID=2112">Dictionary 
              of the Fungi</a> (largely AFTOL)</h4>
            <p>Enter a search string to locate a genus, or click on View Kingdoms 
              for the taxonomic hierarchy. The search term can be right truncated, 
              e.g. 'agaric'.</p>
            <form method="post" action="fundic.asp">
              <table width="293" border="1" bgcolor="#99FF99" bordercolor="#000000">
                <tr bgcolor="#99FF99" bordercolor="#99FF99"> 
                  <td width="133" height="15" bordercolor="#99FF99"><b><font face="Verdana, Arial, Helvetica, sans-serif">Genus 
                    search term: </font></b> </td>
                  <td width="149" height="15"> <input type="text" name="SearchTerm" size="24" <%response.write("value=" & chr(34) & session("strSearch") & chr(34))%>nKeyDown="if ((event.which && event.which == 13)
                      || (event.keyCode && event.keyCode == 13)) {
                    this.form.submit.click();
                    return false;
                  }
                  else return true;"> </td>
                </tr>
                <tr bgcolor="#99FF99" bordercolor="#99FF99"> 
                  <td width="133" height="3"> <input type="submit" name="Submit" value="View Kingdoms"> 
                  </td>
                  <td width="148" height="3"> <input type="submit" name="Submit" value="Search for genus"> 
                  </td>
                </tr>
              </table>
            </form>
            <% 
	GetNav
	DisplayRes
  %>
            <!-- #EndEditable --></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td height="53" class="Footer"> 
      <hr noshade>
<font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#333333">
&copy;
<script>
document.write(curr_year);
</script>
      <a href="http://www.cabi.org/">CABI</a></font>. Return to <a href="../Index.htm">main 
      page</a>. Return to <a href="#TopOfPage">top of page</a>.</td>
  </tr>
</table>
<a name="BottomOfPage"></a>
</body>
<!-- #EndTemplate --></html>
