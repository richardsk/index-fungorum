<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- #BeginTemplate "/templates/Templ.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Family Record Details</title>
<!-- #EndEditable -->
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
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
<!--#include file="../Connections/DataAccess.asp"-->
<!--#include file="../Helpers/Utility.asp"-->
</head> 
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<a name="TopOfPage"></a> 
<table width="100%" height="100%" class="mainbody">
  <tr>
    <td height="105"> 
      <table width="100%" border="0" class="mainbody">
        <tr> 
          <td width="50%" class="h1"> <img src="../IMAGES/LogoIF.gif" alt="Index Fungorum - Species Fungorum" width="100" height="100">Index&nbsp;Fungorum</td>
          <td valign="top"> <table height="100%" align="center">
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("../Names/IndexFungorumPartnership.htm") onMouseOver="MM_displayStatusMsg('Index Fungorum Partnership');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Index 
                  Fungorum Partnership</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("../Names/Acknowledge.htm") onMouseOver="MM_displayStatusMsg('Acknowledgements');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Acknowledgements</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href=javascript:popUp("../Names/IndexFungorum.htm") onMouseOver="MM_displayStatusMsg('Help with searching');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Help 
                  with searching</a> : <font color="#FF0000"><strong><a href=javascript:popUp("/IndexFungorumCookies.htm") onMouseOver="MM_displayStatusMsg('Cookies');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Cookies</a></strong></font></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="../Names/AuthorsOfFungalNames.asp" onMouseOver="MM_displayStatusMsg('Search Authors of Fungal Names');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Authors of Fungal Names</a></td>
              </tr>
              <tr class="mainbody"> 
                <td><a href="../Names/Names.asp" onMouseOver="MM_displayStatusMsg('Search Index Fungorum');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Search 
                  Index Fungorum</a></td>
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
          <td><!-- #BeginEditable "head" --><!-- #EndEditable --><!-- #BeginEditable "Main" --> 
      <h2>Family Record Details </h2>
<%
if request.querystring.count > 0 then
	DisplayResults()
else
   response.write("Unexpected error: there are no variables to process?")
end if
%> 
            <p>Please contact <a href="mailto:p.kirk@cabi.org">Paul Kirk</a> if 
              you have any additions or errors.</p>
<%
		response.write("<p><a href='javascript:history.go(-1)'>back to previous page</a></p>")
%>
       
<%
sub DisplayResults()
   dim strSQL, dbConn, rs, strName
	strName = ""
    strPass = request.querystring.item("P")
	Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
	if true then        
       strConn = GetConnectionString()
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "192.168.0.3" then
	   strConn = "Provider=SQLOLEDB.1;Password=WebServerSQL;Integrated security=SSPI;User ID=WebServerSQL;Initial Catalog=IndexFungorum;Data Source=WebServer"
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
	   dbConn.open strConn
	elseif strIP = "194.203.77.78" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_INDEXFUNGORUM;Initial Catalog=IndexFungorum;Data Source=INDEXFUNGORUM"
	   dbConn.open strConn
	elseif strIP = "10.0.3.13" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=IndexFungorum;Data Source=EDWINBUTLER"
	   dbConn.open strConn
	elseif strIP = "202.27.240.46" then
		strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_Devserver01;Initial Catalog=IndexFungorum;Data Source=Devserver01"
	   dbConn.open strConn
	elseif strIP = "192.168.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\cabi\cabilink.mdb"
	   dbConn.open strConn
	elseif strIP = "127.0.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\IndexFungorum\IndexFungorumlink.mdb"
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=cabilink"
	end if
	strSQL = "SELECT [FamilyNames].*, [FamilyDescriptions].Description "_
		& "FROM [FamilyNames] LEFT JOIN [FamilyDescriptions] ON [FamilyNames].ID = [FamilyDescriptions].ID " _
		& "WHERE ((([FamilyNames].[ID]) =" & protectSQL(request.querystring.item("strRecordID"),true) & "));"
  Set rs = Server.CreateObject("ADODB.Recordset")
  rs.Open strSQL, dbConn, 3
  if rs.bof then 
	  rs.close
	  set rs = nothing
	  dbConn.close
	  set dbConn = nothing
	  exit sub
  end if
  strName = DisplayFamily(rs)
  response.write("<p>" & strName & "</p>")
  DisplayDescription rs
  DisplayLinkedData rs
  rs.close
  set rs = nothing
  dbConn.close
  set dbConn = nothing
end sub

function DisplayFamily(rs)
	dim strData, strName, strLit
	strName = ""
	strLit = ""
	strData = strn(rs("Family NAME"))
	if  strdata <> "" then
			strName = strName & "<b>" & strData & "</b>"
	end if	
	strData = strn(rs("AUTHORS"))
	if  strdata <> "" then
		strName = strName & " " & strData
	end if	
	strData = strn(rs("ORTHOGRAPHY COMMENT"))
	if  strdata <> "" then
		strName = strName & " [as '" & strData & "']"
	end if	
	strData = strn(rs("PUBLISHING AUTHORS"))
	if  strData <> "" then
		if strName <> "" then strName = strName & ","
		strName = strName & " in " & strData
	end if	
	strData = strn(rs("Literature Title"))
	if  strData <> "" then
		strLit = strLit & " <i>" & strData & "</i>"
	end if	
	strData = strn(rs("VOLUME"))
	if strData <> "" then
		strLit = strLit & " <b>" & strdata & "</b>"
	end if
	strData = strn(rs("PART"))
	if strData <> "" then
		strLit = strLit & "(" & strData & ")"
	end if
	strData = strn(rs("PAGE")) 
	if strData<> "" then
		strLit = strLit & ": " & strData
	end if
   	strData = strn(rs("YEAR OF PUBLICATION"))
	if strData <> "" then
		strLit = strLit & " (" & strData & ")"
	end if
	strData = strn(rs("YEAR ON PUBLICATION")) 
	if strData <> "" and strShow <> "" then
		strLit = strLit & " [" & strData & "]"
   	end if
	if strName <> "" and right(strName,1) <> "," and strLit <> "" then strName = strName & ","
 	DisplayFamily = strName & strLit
end function

sub DisplayLinkedData(rs)
	dim strData, strName
	strData = ""
	strName = ""
	strData = strn(rs("Synonymy"))
	if strData <> "" then
		response.write("<p><b>Synonymy:</b><br> " & strData & "</p>")
	end if
	strData = strn(rs("Type genus name"))
	if strData <> "" then
		if strn(rs("Genus Fundic Record Number")) <> "" then
			strName = strName & "<b><a href='genusrecord.asp?RecordID=" & strn(rs("Genus Fundic Record Number")) & "'>" & strData & "</a></b>"
		else
			strName = "<b>" & strData & "</b>"
		end if
	end if
	strData = strn(rs("type genus authors"))
	if strData <> "" then
		strName = strName & " " & strData
	end if
	if strName <> "" then
		response.write("<p><b>Type genus:</b><br> " & strName & "</p>")
	end if
	strData = strn(rs("Editorial comment"))
	if strData <> "" then
		response.write("<p><b>Editorial comment:</b><br> " & strData & "</p>")
	end if
end sub

sub DisplayDescription(rs)
	dim strData
	strData = ""
	strData = strn(rs("Description"))
	if strData <> "" then
		response.write("<p><b>Description:</b><br> " & strData & "</p>")
	end if
end sub

function strn(str)
	if isnull(str) then 
		strn = ""
	else
		strn = str
	end if  
end function 
%>
<!-- #EndEditable --></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td height="10" class="Footer">
	  <hr noshade>
      &copy; 2008 <a href=javascript:popUp("../Names/IndexFungorumPartnership.htm") onMouseOver="MM_displayStatusMsg('Index Fungorum Partnership');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Index 
      Fungorum Partnership</a>. Return to <a href="../Index.htm" onMouseOver="MM_displayStatusMsg('CABI Bioscience Databases home page');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">main 
      page</a>. Return to <a href="#TopOfPage" onMouseOver="MM_displayStatusMsg('Go to top of page');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">top 
      of page</a>. </td>
  </tr>
</table>
<a name="BottomOfPage"></a>
</body>
<!-- #EndTemplate --></html>
