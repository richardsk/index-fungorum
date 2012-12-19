<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum - Name Registration Form</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script language="javascript">
<!--
function Year_onchange(frmSelect) {
	frmSelect.submit(); 
}
//-->
<!--
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=1040,height=450,left=50,top=00');");
}
function MM_displayStatusMsg(msgStr) { //v1.0
  status=msgStr;
  document.MM_returnValue = true;
}
//-->
</script>
<script type="text/javascript">
var d = new Date();
var curr_year = d.getFullYear();
</script>
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
<!--#include file="../Connections/DataAccess.asp"-->
<!--#include file="../Helpers/Utility.asp"-->
</head>
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<table width="100%" height="100%" class="mainbody">
  <tr> 
    <td height="105"> <table width="100%" border="0" class="mainbody">
        <tr> 
          <td class="h1"> <img src="../IMAGES/LogoIF.gif" alt="Index Fungorum - Species Fungorum" width="100" height="100">Index&nbsp;Fungorum 
            - register a name or other nomenclatural act</td>
        </tr>
        <tr> 
          <td><hr noshade></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="100%" cellpadding="5">
        <tr> 
          <td>

<style>
  .error {
  font-family: Verdana, Arial, Helvetica, sans-serif;
  font-size: 8pt;
  color: red;
  margin-left: 50px;
  display:none;
  }
</style>
  
<script>
  function checkForm() {
  NameOfFungus = document.getElementById("NameOfFungus").value;
  Author = document.getElementById("Author").value;
  Page = document.getElementById("Page").value;
  YearOfPublication = document.getElementById("YearOfPublication").value;
  Basionym = document.getElementById("Basionym").value;
  TypificationDetails = document.getElementById("TypificationDetails").value;
  Email = document.getElementById("Email").value;
  
  if (NameOfFungus == "") {
  hideAllErrors();
document.getElementById("NameOfFungusError").style.display = "inline";
document.getElementById("NameOfFungus").select();
document.getElementById("NameOfFungus").focus();
  return false;
  } else if (Author == "") {
  hideAllErrors();
document.getElementById("AuthorError").style.display = "inline";
document.getElementById("Author").select();
document.getElementById("Author").focus();
  return false;
  } else if (page == "") {
  hideAllErrors();
document.getElementById("PageError").style.display = "inline";
document.getElementById("Page").select();
document.getElementById("Page").focus();
  return false;
  } else if (YearOfPublication == "") {
  hideAllErrors();
document.getElementById("YearOfPublicationError").style.display = "inline";
document.getElementById("YearOfPublication").select();
document.getElementById("YearOfPublication").focus();
  return false;
  } else if (TypificationDetails == "") {
  hideAllErrors();
document.getElementById("BasionymError").style.display = "inline";
document.getElementById("Basionym").select();
document.getElementById("Basionym").focus();
  return false;
  } else if (Email == "") {
  hideAllErrors();
document.getElementById("TypificationDetailsError").style.display = "inline";
document.getElementById("TypificationDetails").select();
document.getElementById("TypificationDetails").focus();
  return false;
  } else if (Email == "") {
  hideAllErrors();
document.getElementById("EmailError").style.display = "inline";
document.getElementById("Email").select();
document.getElementById("Email").focus();
  return false;
  }
  return true;
  }
 
  function hideAllErrors() {
document.getElementById("NameOfFungusError").style.display = "none"
document.getElementById("AuthorError").style.display = "none"
document.getElementById("PageError").style.display = "none"
document.getElementById("YearOfPublicationError").style.display = "none"
document.getElementById("TypificationDetailsError").style.display = "none"
document.getElementById("EmailError").style.display = "none"
  }
</script>

<%
	dim strSQL, dbConn, RS, strText
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
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=IndexFungorum;Data Source=AINSWORTH"
	   dbConn.open strConn
	elseif strIP = "192.168.0.12" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_KIRK-WEBSERVER;Initial Catalog=IndexFungorum;Data Source=KIRK-WEBSERVER"
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=cabilink"
	end if

	if strn(Request.Form("Year")) = "New species" then
		strText = "New species"
		strSQL = "SELECT tblNomenclaturalActs.NomenclaturalAct " _
			& "FROM tblNomenclaturalActs " _
			& "WHERE (((tblNomenclaturalActs.NomenclaturalAct) LIKE '" & protectSQL(strText, false) & "%')) " _
			& "ORDER BY tblNomenclaturalActs.ID;"
		strText = ""
	elseif strn(Request.Form("Year")) = "New subspecies" then
		strText = "New subspecies"
		strSQL = "SELECT tblNomenclaturalActs.NomenclaturalAct " _
			& "FROM tblNomenclaturalActs " _
			& "WHERE (((tblNomenclaturalActs.NomenclaturalAct) LIKE '" & protectSQL(strText, false) & "%')) " _
			& "ORDER BY tblNomenclaturalActs.ID;"
		strText = ""
	elseif strn(Request.Form("Year")) = "New variety" then
		strText = "New variety"
		strSQL = "SELECT tblNomenclaturalActs.NomenclaturalAct " _
			& "FROM tblNomenclaturalActs " _
			& "WHERE (((tblNomenclaturalActs.NomenclaturalAct) LIKE '" & protectSQL(strText, false) & "%')) " _
			& "ORDER BY tblNomenclaturalActs.ID;"
		strText = ""
	elseif strn(Request.Form("Year")) = "New form" then
		strText = "New form"
		strSQL = "SELECT tblNomenclaturalActs.NomenclaturalAct " _
			& "FROM tblNomenclaturalActs " _
			& "WHERE (((tblNomenclaturalActs.NomenclaturalAct) LIKE '" & protectSQL(strText, false) & "%')) " _
			& "ORDER BY tblNomenclaturalActs.ID;"
		strText = ""
	elseif strn(Request.Form("Year")) = "New infraspecific taxon" then
		strText = "New infraspecific taxon"
		strSQL = "SELECT tblNomenclaturalActs.NomenclaturalAct " _
			& "FROM tblNomenclaturalActs " _
			& "WHERE (((tblNomenclaturalActs.NomenclaturalAct) LIKE '" & protectSQL(strText, false) & "%')) " _
			& "ORDER BY tblNomenclaturalActs.ID;"
		strText = ""
	elseif strn(Request.Form("Year")) = "New genus" then
		strText = "New genus"
		strSQL = "SELECT tblNomenclaturalActs.NomenclaturalAct " _
			& "FROM tblNomenclaturalActs " _
			& "WHERE (((tblNomenclaturalActs.NomenclaturalAct) LIKE '" & protectSQL(strText, false) & "%')) " _
			& "ORDER BY tblNomenclaturalActs.ID;"
		strText = ""
	elseif strn(Request.Form("Year")) = "New family" then
		strText = "New family"
		strSQL = "SELECT tblNomenclaturalActs.NomenclaturalAct " _
			& "FROM tblNomenclaturalActs " _
			& "WHERE (((tblNomenclaturalActs.NomenclaturalAct) LIKE '" & protectSQL(strText, false) & "%')) " _
			& "ORDER BY tblNomenclaturalActs.ID;"
		strText = ""
	elseif strn(Request.Form("Year")) = "New order" then
		strText = "New order"
		strSQL = "SELECT tblNomenclaturalActs.NomenclaturalAct " _
			& "FROM tblNomenclaturalActs " _
			& "WHERE (((tblNomenclaturalActs.NomenclaturalAct) LIKE '" & protectSQL(strText, false) & "%')) " _
			& "ORDER BY tblNomenclaturalActs.ID;"
		strText = ""
	elseif strn(Request.Form("Year")) = "New class" then
		strText = "New class"
		strSQL = "SELECT tblNomenclaturalActs.NomenclaturalAct " _
			& "FROM tblNomenclaturalActs " _
			& "WHERE (((tblNomenclaturalActs.NomenclaturalAct) LIKE '" & protectSQL(strText, false) & "%')) " _
			& "ORDER BY tblNomenclaturalActs.ID;"
		strText = ""
	elseif strn(Request.Form("Year")) = "New phylum" then
		strText = "New phylum"
		strSQL = "SELECT tblNomenclaturalActs.NomenclaturalAct " _
			& "FROM tblNomenclaturalActs " _
			& "WHERE (((tblNomenclaturalActs.NomenclaturalAct) LIKE '" & protectSQL(strText, false) & "%')) " _
			& "ORDER BY tblNomenclaturalActs.ID;"
		strText = ""
	elseif strn(Request.Form("Year")) = "New combination" then
		strText = "New combination"
		strSQL = "SELECT tblNomenclaturalActs.NomenclaturalAct " _
			& "FROM tblNomenclaturalActs " _
			& "WHERE (((tblNomenclaturalActs.NomenclaturalAct) LIKE '" & protectSQL(strText, false) & "%')) " _
			& "ORDER BY tblNomenclaturalActs.ID;"
		strText = ""
	elseif strn(Request.Form("Year")) = "New name" then
		strText = "New name"
		strSQL = "SELECT tblNomenclaturalActs.NomenclaturalAct " _
			& "FROM tblNomenclaturalActs " _
			& "WHERE (((tblNomenclaturalActs.NomenclaturalAct) LIKE '" & protectSQL(strText, false) & "%')) " _
			& "ORDER BY tblNomenclaturalActs.ID;"
		strText = ""
	elseif strn(Request.Form("Year")) = "New typification" then
		strText = "New typification"
		strSQL = "SELECT tblNomenclaturalActs.NomenclaturalAct " _
			& "FROM tblNomenclaturalActs " _
			& "WHERE (((tblNomenclaturalActs.NomenclaturalAct) LIKE '" & protectSQL(strText, false) & "%')) " _
			& "ORDER BY tblNomenclaturalActs.ID;"
		strText = ""
	else
		strText = ""
		strSQL = "SELECT tblNomenclaturalActs.NomenclaturalAct " _
			& "FROM tblNomenclaturalActs " _
			& "WHERE (((tblNomenclaturalActs.NomenclaturalAct) LIKE '" & protectSQL(strText, false) & "%')) " _
			& "ORDER BY tblNomenclaturalActs.ID;"
	end if

	Set RS = Server.CreateObject("ADODB.Recordset")
	RS.Open strSql, dbConn, 3
		intRecordCount = RS.RecordCount
	if not RS.bof then
		response.write("<table width='60%' align='center' border='1' cellspacing='0' cellpadding='2'>")
		response.write("<tr>")
		response.write("<td width='60%' align='center'><b>Nomenclatural Act (new species is default)</b></td>")
		response.write("</tr>")

		response.write("<tr>")
		response.write("<td width='60%' align='center'>")
		
		response.write("<FORM name='frmSelect' method='Post' action='Films.asp'>")

		response.write("<SELECT name='Year' LANGUAGE=javascript onchange='return Year_onchange(frmSelect)'>")
		response.write("<OPTION></OPTION>")

		response.write("<OPTION>New species</OPTION>")
		response.write("<OPTION>New subspecies</OPTION>")
		response.write("<OPTION>New variety</OPTION>")
		response.write("<OPTION>New form</OPTION>")
		response.write("<OPTION>New infraspecific taxon</OPTION>")
		response.write("<OPTION>New genus</OPTION>")
'		response.write("<OPTION>New subgenus</OPTION>")
'		response.write("<OPTION>New infrageneric taxon</OPTION>")
		response.write("<OPTION>New family</OPTION>")
'		response.write("<OPTION>New subfamily</OPTION>")
'		response.write("<OPTION>New infrafamilial name</OPTION>")
'		response.write("<OPTION>New superfamily</OPTION>")
		response.write("<OPTION>New order</OPTION>")
'		response.write("<OPTION>New suborder</OPTION>")
		response.write("<OPTION>New class</OPTION>")
'		response.write("<OPTION>New subclass</OPTION>")
		response.write("<OPTION>New phylum</OPTION>")
'		response.write("<OPTION>New subphylum</OPTION>")
		response.write("<OPTION>New combination</OPTION>")
		response.write("<OPTION>New name</OPTION>")
		response.write("<OPTION>New typification</OPTION>")
		response.write("</SELECT>")
	
		response.write("</FORM>")
		response.write("</td>")
		response.write("</tr>")

		
		do while not RS.bof and not RS.eof
'load the correct form
		response.write("<form name='frmIndexFungorumRegisterName' onSubmit='return checkForm();' method=post action='../Names/IndexFungorumRegisterNameCompletion.asp'>")
		strText = ""
		strText = RS("NomenclaturalAct")
		if strText <> "" then 
'New species
		if strText = "New species" then
		response.write("<table width='60%' align='center' border='1' cellpadding='2' class='mainbody'>")
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>&nbsp;</span></td>")
		response.write("<td width='80%'><b><span class=label>Registering a new species</span></b></td>")
		response.write("</tr>")

		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Name of Fungus</span></td>")
		response.write("<td width='80%'><input type=text value='' name=NameOfFungus id=NameOfFungus size='80' maxlength='100'>")
		response.write("<div class=error id=NameOfFungusError><font color='#FF0000'>Required: Please enter the name</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Author(s) of name</span></td>")
		response.write("<td width='80%'><input type=text value='' name=Author id=Author size='80' maxlength='100'>")
		response.write("<div class=error id=AuthorError><font color='#FF0000'>Required: Please enter the author</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Publishing Authors</span></td>")
		response.write("<td width='80%'><input type=text value='' name=publishingauthors id=publishingauthors size='80' maxlength='100'></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'>Title of Journal or Book</td>")
		response.write("<td width='80%'><select name='PubLink'>")
		strSQL1 = "SELECT tblRegistrationPublications.* FROM tblRegistrationPublications ORDER BY tblRegistrationPublications.pubIMIAbbr;"
		Set RS1 = Server.CreateObject("ADODB.Recordset")
		RS1.Open strSQL1, dbConn, 3
		if RS1.RecordCount > 0 then
			RS1.MoveFirst
			response.write("<option value=''></option>")
			do while not RS1.eof
				response.write("<option value='" & server.HTMLEncode(RS1("pubLink")) & "'>" & server.HTMLEncode(RS1("pubIMIAbbr")) & "</option>")
				RS1.MoveNext
			loop
		end if
		RS1.close
		set RS1 = Nothing	
		response.write("</select></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Other publication not in list</span></td>")
		response.write("<td width='80%'><input type=text value='' name=otherpublication id=otherpublication size='80' maxlength='255'></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Volume</span></td>")
		response.write("<td width='80%'><input type=text value='' name=volume id=volume size='20' maxlength='100'></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Part</span></td>")
		response.write("<td width='80%'><input type=text value='' name=part id=part size='20' maxlength='100'></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Page</span></td>")
		response.write("<td width='80%'><input type=text value='' name=Page id=Page size='20' maxlength='100'>")
		response.write("<div class=error id=PageError><font color='#FF0000'>Required: Please enter the page or plate</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Year of publication</span></td>")
		response.write("<td width='80%'><input type=text value='' name=YearOfPublication id=YearOfPublication size='20' maxlength='4'>")
		response.write("<div class=error id=YearOfPublicationError><font color='#FF0000'>Required: Please enter the year of publication of the name</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Year on publication</span></td>")
		response.write("<td width='80%'><input type=text value='' name=YearOnPublication id=YearOnPublication size='20' maxlength='20'></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Host or Substratum</span></td>")
		response.write("<td width='80%'><input type=text value='' name=host id=host size='80' maxlength='100'></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Country of origin of type</span></td>")
		response.write("<td width='80%'><select name='Location'>")
		strSQL1 = "SELECT tblRegistrationTypeLocality.* FROM tblRegistrationTypeLocality ORDER BY ISOCountry, DisplayCountry;"
		Set RS1 = Server.CreateObject("ADODB.Recordset")
		RS1.Open strSQL1, dbConn, 3
		if RS1.RecordCount > 0 then
			RS1.MoveFirst
			response.write("<option value=''></option>")
			do while not RS1.eof
				response.write("<option value='" & server.HTMLEncode(RS1("IFcountry")) & "'>" & server.HTMLEncode(RS1("DisplayCountry")) & "</option>")
				RS1.MoveNext
			loop
		end if
		RS1.close
		set RS1 = Nothing	
		response.write("</select></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Typification details</span></td>")
		response.write("<td width='80%'><input type=text value='' name=TypificationDetails id=TypificationDetails size='80' maxlength='100'>")
		response.write("<div class=error id=TypificationDetailsError><font color='#FF0000'>Required: Please enter details<br></div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Diagnosis</span></td>")
		response.write("<td width='80%'><textarea type=text value='' name=Diagnosis id=comment cols='68' rows='5'></textarea></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Email</span></td>")
		response.write("<td width='80%'><input type=text value='' name=Email id=Email size='40' maxlength='100'>")
		response.write("<div class=error id=EmailError><font color='#FF0000'>Required: Please enter your email<br></div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Comment</span></td>")
		response.write("<td width='80%'><textarea type=text value='' name=Notes id=comment cols='68' rows='5'></textarea></td>")
		response.write("</tr>")
	
'New infraspecific taxon
		elseif strText = "New subspecies" or strText = "New variety" or strText = "New form" or strText = "New infraspecific taxon" then
		response.write("<table width='60%' align='center' border='1' cellpadding='2' class='mainbody'>")
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>&nbsp;</span></td>")
		response.write("<td width='80%'><b><span class=label>Registering a new infraspecific taxon</span></b></td>")
		response.write("</tr>")

		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Name of Fungus</span></td>")
		response.write("<td width='80%'><input type=text value='' name=NameOfFungus id=NameOfFungus size='80' maxlength='100'>")
		response.write("<div class=error id=NameOfFungusError><font color='#FF0000'>Required: Please enter the name</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")

		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Rank</span></td>")
		response.write("<td width='80%'>")
		response.write("<SELECT name='Rank'>")
		response.write("<OPTION></OPTION>")
		response.write("<OPTION>subspecies</OPTION>")
		response.write("<OPTION>variety</OPTION>")
		response.write("<OPTION>form</OPTION>")
		response.write("<OPTION>other infraspecific taxon</OPTION>")
		response.write("</SELECT>")
		response.write("</td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Author(s) of name</span></td>")
		response.write("<td width='80%'><input type=text value='' name=Author id=Author size='80' maxlength='100'>")
		response.write("<div class=error id=AuthorError><font color='#FF0000'>Required: Please enter the author</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Publishing Authors</span></td>")
		response.write("<td width='80%'><input type=text value='' name=publishingauthors id=publishingauthors size='80' maxlength='100'></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'>Title of Journal or Book</td>")
		response.write("<td width='80%'><select name='PubLink'>")
		strSQL1 = "SELECT tblRegistrationPublications.* FROM tblRegistrationPublications ORDER BY tblRegistrationPublications.pubIMIAbbr;"
		Set RS1 = Server.CreateObject("ADODB.Recordset")
		RS1.Open strSQL1, dbConn, 3
		if RS1.RecordCount > 0 then
			RS1.MoveFirst
			response.write("<option value=''></option>")
			do while not RS1.eof
				response.write("<option value='" & server.HTMLEncode(RS1("pubLink")) & "'>" & server.HTMLEncode(RS1("pubIMIAbbr")) & "</option>")
				RS1.MoveNext
			loop
		end if
		RS1.close
		set RS1 = Nothing	
		response.write("</select></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Other publication not in list</span></td>")
		response.write("<td width='80%'><input type=text value='' name=otherpublication id=otherpublication size='80' maxlength='255'></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Volume</span></td>")
		response.write("<td width='80%'><input type=text value='' name=volume id=volume size='20' maxlength='100'></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Part</span></td>")
		response.write("<td width='80%'><input type=text value='' name=part id=part size='20' maxlength='100'></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Page</span></td>")
		response.write("<td width='80%'><input type=text value='' name=Page id=Page size='20' maxlength='100'>")
		response.write("<div class=error id=PageError><font color='#FF0000'>Required: Please enter the page or plate</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Year of publication</span></td>")
		response.write("<td width='80%'><input type=text value='' name=YearOfPublication id=YearOfPublication size='20' maxlength='4'>")
		response.write("<div class=error id=YearOfPublicationError><font color='#FF0000'>Required: Please enter the year of publication of the name</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Year on publication</span></td>")
		response.write("<td width='80%'><input type=text value='' name=YearOnPublication id=YearOnPublication size='20' maxlength='20'></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Host or Substratum</span></td>")
		response.write("<td width='80%'><input type=text value='' name=host id=host size='80' maxlength='100'></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Country of origin of type</span></td>")
		response.write("<td width='80%'><select name='Location'>")
		strSQL1 = "SELECT tblRegistrationTypeLocality.* FROM tblRegistrationTypeLocality ORDER BY ISOCountry, DisplayCountry;"
		Set RS1 = Server.CreateObject("ADODB.Recordset")
		RS1.Open strSQL1, dbConn, 3
		if RS1.RecordCount > 0 then
			RS1.MoveFirst
			response.write("<option value=''></option>")
			do while not RS1.eof
				response.write("<option value='" & server.HTMLEncode(RS1("IFcountry")) & "'>" & server.HTMLEncode(RS1("DisplayCountry")) & "</option>")
				RS1.MoveNext
			loop
		end if
		RS1.close
		set RS1 = Nothing	
		response.write("</select></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Typification details</span></td>")
		response.write("<td width='80%'><input type=text value='' name=TypificationDetails id=TypificationDetails size='80' maxlength='100'>")
		response.write("<div class=error id=TypificationDetailsError><font color='#FF0000'>Required: Please enter details<br></div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Diagnosis</span></td>")
		response.write("<td width='80%'><textarea type=text value='' name=Diagnosis id=comment cols='68' rows='5'></textarea></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Email</span></td>")
		response.write("<td width='80%'><input type=text value='' name=Email id=Email size='40' maxlength='100'>")
		response.write("<div class=error id=EmailError><font color='#FF0000'>Required: Please enter your email<br></div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Comment</span></td>")
		response.write("<td width='80%'><textarea type=text value='' name=Notes id=comment cols='68' rows='5'></textarea></td>")
		response.write("</tr>")

'New genus
		elseif strText = "New genus" then
		response.write("<table width='60%' align='center' border='1' cellpadding='2' class='mainbody'>")
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>&nbsp;</span></td>")
		response.write("<td width='80%'><b><span class=label>Registering a new genus</span></b></td>")
		response.write("</tr>")

		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Name of Fungus</span></td>")
		response.write("<td width='80%'><input type=text value='' name=NameOfFungus id=NameOfFungus size='80' maxlength='100'>")
		response.write("<div class=error id=NameOfFungusError><font color='#FF0000'>Required: Please enter the name</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Author(s) of name</span></td>")
		response.write("<td width='80%'><input type=text value='' name=Author id=Author size='80' maxlength='100'>")
		response.write("<div class=error id=AuthorError><font color='#FF0000'>Required: Please enter the author</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Publishing Authors</span></td>")
		response.write("<td width='80%'><input type=text value='' name=publishingauthors id=publishingauthors size='80' maxlength='100'></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'>Title of Journal or Book</td>")
		response.write("<td width='80%'><select name='PubLink'>")
		strSQL1 = "SELECT tblRegistrationPublications.* FROM tblRegistrationPublications ORDER BY tblRegistrationPublications.pubIMIAbbr;"
		Set RS1 = Server.CreateObject("ADODB.Recordset")
		RS1.Open strSQL1, dbConn, 3
		if RS1.RecordCount > 0 then
			RS1.MoveFirst
			response.write("<option value=''></option>")
			do while not RS1.eof
				response.write("<option value='" & server.HTMLEncode(RS1("pubLink")) & "'>" & server.HTMLEncode(RS1("pubIMIAbbr")) & "</option>")
				RS1.MoveNext
			loop
		end if
		RS1.close
		set RS1 = Nothing	
		response.write("</select></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Other publication not in list</span></td>")
		response.write("<td width='80%'><input type=text value='' name=otherpublication id=otherpublication size='80' maxlength='255'></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Volume</span></td>")
		response.write("<td width='80%'><input type=text value='' name=volume id=volume size='20' maxlength='100'></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Part</span></td>")
		response.write("<td width='80%'><input type=text value='' name=part id=part size='20' maxlength='100'></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Page</span></td>")
		response.write("<td width='80%'><input type=text value='' name=Page id=Page size='20' maxlength='100'>")
		response.write("<div class=error id=PageError><font color='#FF0000'>Required: Please enter the page or plate</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Year of publication</span></td>")
		response.write("<td width='80%'><input type=text value='' name=YearOfPublication id=YearOfPublication size='20' maxlength='4'>")
		response.write("<div class=error id=YearOfPublicationError><font color='#FF0000'>Required: Please enter the year of publication of the name</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Year on publication</span></td>")
		response.write("<td width='80%'><input type=text value='' name=YearOnPublication id=YearOnPublication size='20' maxlength='20'></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Typification</span></td>")
		strStr = chr(34) & chr(41)
		strJava = "javascript:popUp(" & chr(34)
		strPopup = "<a href='" & strJava & "FindBasionym.asp" & strStr & "'><img src='../IMAGES/i.gif' alt='Find type species' width='13' height='13' border='0'></a>"
		response.write("<td width='80%'><input type=text value='' name=TypificationDetails id=TypificationDetails size='80' maxlength='100'>&nbsp;" & strPopup)
		response.write("<div class=error id=TypificationDetailsError><font color='#FF0000'>Required: Please enter details<br></div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Diagnosis</span></td>")
		response.write("<td width='80%'><textarea type=text value='' name=Diagnosis id=comment cols='68' rows='5'></textarea></td>")
		response.write("</tr>")

		response.write("<tr>")
		response.write("<td width='20%'>Family name</td>")
		response.write("<td width='80%'><select name='Classification'>")
		strSQL1 = "SELECT DISTINCT FundicClassification.[Family name] FROM FundicClassification ORDER BY FundicClassification.[Family name];"
		Set RS1 = Server.CreateObject("ADODB.Recordset")
		RS1.Open strSQL1, dbConn, 3
		if RS1.RecordCount > 0 then
			RS1.MoveFirst
			response.write("<option value=''></option>")
			do while not RS1.eof
				response.write("<option value='" & RS1("Family name") & "'>" & RS1("Family name") & "</option>")
				RS1.MoveNext
			loop
		end if
		RS1.close
		set RS1 = Nothing	
		response.write("</select></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Email</span></td>")
		response.write("<td width='80%'><input type=text value='' name=Email id=Email size='40' maxlength='100'>")
		response.write("<div class=error id=EmailError><font color='#FF0000'>Required: Please enter your email<br></div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Comment</span></td>")
		response.write("<td width='80%'><textarea type=text value='' name=Notes id=comment cols='68' rows='5'></textarea></td>")
		response.write("</tr>")

'New family
		elseif strText = "New family" then
		response.write("<table width='60%' align='center' border='1' cellpadding='2' class='mainbody'>")
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>&nbsp;</span></td>")
		response.write("<td width='80%'><b><span class=label>Registering a new family</span></b></td>")
		response.write("</tr>")

		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Name of Fungus</span></td>")
		response.write("<td width='80%'><input type=text value='' name=NameOfFungus id=NameOfFungus size='80' maxlength='100'>")
		response.write("<div class=error id=NameOfFungusError><font color='#FF0000'>Required: Please enter the name</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Author(s) of name</span></td>")
		response.write("<td width='80%'><input type=text value='' name=Author id=Author size='80' maxlength='100'>")
		response.write("<div class=error id=AuthorError><font color='#FF0000'>Required: Please enter the author</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Publishing Authors</span></td>")
		response.write("<td width='80%'><input type=text value='' name=publishingauthors id=publishingauthors size='80' maxlength='100'></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'>Title of Journal or Book</td>")
		response.write("<td width='80%'><select name='PubLink'>")
		strSQL1 = "SELECT tblRegistrationPublications.* FROM tblRegistrationPublications ORDER BY tblRegistrationPublications.pubIMIAbbr;"
		Set RS1 = Server.CreateObject("ADODB.Recordset")
		RS1.Open strSQL1, dbConn, 3
		if RS1.RecordCount > 0 then
			RS1.MoveFirst
			response.write("<option value=''></option>")
			do while not RS1.eof
				response.write("<option value='" & server.HTMLEncode(RS1("pubLink")) & "'>" & server.HTMLEncode(RS1("pubIMIAbbr")) & "</option>")
				RS1.MoveNext
			loop
		end if
		RS1.close
		set RS1 = Nothing	
		response.write("</select></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Other publication not in list</span></td>")
		response.write("<td width='80%'><input type=text value='' name=otherpublication id=otherpublication size='80' maxlength='255'></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Volume</span></td>")
		response.write("<td width='80%'><input type=text value='' name=volume id=volume size='20' maxlength='100'></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Part</span></td>")
		response.write("<td width='80%'><input type=text value='' name=part id=part size='20' maxlength='100'></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Page</span></td>")
		response.write("<td width='80%'><input type=text value='' name=Page id=Page size='20' maxlength='100'>")
		response.write("<div class=error id=PageError><font color='#FF0000'>Required: Please enter the page or plate</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Year of publication</span></td>")
		response.write("<td width='80%'><input type=text value='' name=YearOfPublication id=YearOfPublication size='20' maxlength='4'>")
		response.write("<div class=error id=YearOfPublicationError><font color='#FF0000'>Required: Please enter the year of publication of the name</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Year on publication</span></td>")
		response.write("<td width='80%'><input type=text value='' name=YearOnPublication id=YearOnPublication size='20' maxlength='20'></td>")
		response.write("</tr>")

		response.write("<tr>")
		response.write("<td width='20%'>Typification details</td>")
		response.write("<td width='80%'><select name='TypificationDetails'>")
		strSQL1 = "SELECT FundicClassification.[Genus name], FundicClassification.[Fundic Record Number] FROM FundicClassification ORDER BY FundicClassification.[Genus name];"
		Set RS1 = Server.CreateObject("ADODB.Recordset")
		RS1.Open strSQL1, dbConn, 3
		if RS1.RecordCount > 0 then
			RS1.MoveFirst
			response.write("<option value=''></option>")
			do while not RS1.eof
				response.write("<option value='" & RS1("Fundic Record Number") & "'>" & RS1("Genus name") & "</option>")
				RS1.MoveNext
			loop
		end if
		RS1.close
		set RS1 = Nothing	
		response.write("</select>")
		response.write("<div class=error id=TypificationDetailsError><font color='#FF0000'>Required: Please enter details<br></div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")

		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Diagnosis</span></td>")
		response.write("<td width='80%'><textarea type=text value='' name=Diagnosis id=comment cols='68' rows='5'></textarea></td>")
		response.write("</tr>")

		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Email</span></td>")
		response.write("<td width='80%'><input type=text value='' name=Email id=Email size='40' maxlength='100'>")
		response.write("<div class=error id=EmailError><font color='#FF0000'>Required: Please enter your email<br></div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Comment</span></td>")
		response.write("<td width='80%'><textarea type=text value='' name=Notes id=comment cols='68' rows='5'></textarea></td>")
		response.write("</tr>")


		elseif strText = "New order" then
			response.write("<td align='left' width='5%'>" & RS("NomenclaturalAct") & "</td>")


		elseif strText = "New class" then
			response.write("<td align='left' width='5%'>" & RS("NomenclaturalAct") & "</td>")


		elseif strText = "New phylum" then
			response.write("<td align='left' width='5%'>" & RS("NomenclaturalAct") & "</td>")

'New combination
		elseif strText = "New combination" then
		response.write("<table width='60%' align='center' border='1' cellpadding='2' class='mainbody'>")
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>&nbsp;</span></td>")
		response.write("<td width='80%'><b><span class=label>Registering a new combination</span></b></td>")
		response.write("</tr>")

		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Name of Fungus</span></td>")
		response.write("<td width='80%'><input type=text value='' name=NameOfFungus id=NameOfFungus size='80' maxlength='100'>")
		response.write("<div class=error id=NameOfFungusError><font color='#FF0000'>Required: Please enter the name</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Author(s) of name</span></td>")
		response.write("<td width='80%'><input type=text value='' name=Author id=Author size='80' maxlength='100'>")
		response.write("<div class=error id=AuthorError><font color='#FF0000'>Required: Please enter the author</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Publishing Authors</span></td>")
		response.write("<td width='80%'><input type=text value='' name=publishingauthors id=publishingauthors size='80' maxlength='100'></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'>Title of Journal or Book</td>")
		response.write("<td width='80%'><select name='PubLink'>")
		strSQL1 = "SELECT tblRegistrationPublications.* FROM tblRegistrationPublications ORDER BY tblRegistrationPublications.pubIMIAbbr;"
		Set RS1 = Server.CreateObject("ADODB.Recordset")
		RS1.Open strSQL1, dbConn, 3
		if RS1.RecordCount > 0 then
			RS1.MoveFirst
			response.write("<option value=''></option>")
			do while not RS1.eof
				response.write("<option value='" & server.HTMLEncode(RS1("pubLink")) & "'>" & server.HTMLEncode(RS1("pubIMIAbbr")) & "</option>")
				RS1.MoveNext
			loop
		end if
		RS1.close
		set RS1 = Nothing	
		response.write("</select></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Other publication not in list</span></td>")
		response.write("<td width='80%'><input type=text value='' name=otherpublication id=otherpublication size='80' maxlength='255'></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Volume</span></td>")
		response.write("<td width='80%'><input type=text value='' name=volume id=volume size='20' maxlength='100'></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Part</span></td>")
		response.write("<td width='80%'><input type=text value='' name=part id=part size='20' maxlength='100'></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Page</span></td>")
		response.write("<td width='80%'><input type=text value='' name=Page id=Page size='20' maxlength='100'>")
		response.write("<div class=error id=PageError><font color='#FF0000'>Required: Please enter the page or plate</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Year of publication</span></td>")
		response.write("<td width='80%'><input type=text value='' name=YearOfPublication id=YearOfPublication size='20' maxlength='4'>")
		response.write("<div class=error id=YearOfPublicationError><font color='#FF0000'>Required: Please enter the year of publication of the name</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Year on publication</span></td>")
		response.write("<td width='80%'><input type=text value='' name=YearOnPublication id=YearOnPublication size='20' maxlength='20'></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Basionym</span></td>")
		strStr = chr(34) & chr(41)
		strJava = "javascript:popUp(" & chr(34)
		strPopup = "<a href='" & strJava & "FindBasionym.asp" & strStr & "'><img src='../IMAGES/i.gif' alt='Find type species' width='13' height='13' border='0'></a>"
		response.write("<td width='80%'><input type=text value='' name=Basionym id=Basionym size='80' maxlength='100'>&nbsp;" & strPopup)
		response.write("<div class=error id=Basionym><font color='#FF0000'>Required: Please enter the basionym<br></div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Email</span></td>")
		response.write("<td width='80%'><input type=text value='' name=Email id=Email size='40' maxlength='100'>")
		response.write("<div class=error id=EmailError><font color='#FF0000'>Required: Please enter your email<br></div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Comment</span></td>")
		response.write("<td width='80%'><textarea type=text value='' name=Notes id=comment cols='68' rows='5'></textarea></td>")
		response.write("</tr>")

'New name
		elseif strText = "New name" then
		response.write("<table width='60%' align='center' border='1' cellpadding='2' class='mainbody'>")
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>&nbsp;</span></td>")
		response.write("<td width='80%'><b><span class=label>Registering a new name</span></b></td>")
		response.write("</tr>")

		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Name of Fungus</span></td>")
		response.write("<td width='80%'><input type=text value='' name=NameOfFungus id=NameOfFungus size='80' maxlength='100'>")
		response.write("<div class=error id=NameOfFungusError><font color='#FF0000'>Required: Please enter the name</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Author(s) of name</span></td>")
		response.write("<td width='80%'><input type=text value='' name=Author id=Author size='80' maxlength='100'>")
		response.write("<div class=error id=AuthorError><font color='#FF0000'>Required: Please enter the author</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Publishing Authors</span></td>")
		response.write("<td width='80%'><input type=text value='' name=publishingauthors id=publishingauthors size='80' maxlength='100'></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'>Title of Journal or Book</td>")
		response.write("<td width='80%'><select name='PubLink'>")
		strSQL1 = "SELECT tblRegistrationPublications.* FROM tblRegistrationPublications ORDER BY tblRegistrationPublications.pubIMIAbbr;"
		Set RS1 = Server.CreateObject("ADODB.Recordset")
		RS1.Open strSQL1, dbConn, 3
		if RS1.RecordCount > 0 then
			RS1.MoveFirst
			response.write("<option value=''></option>")
			do while not RS1.eof
				response.write("<option value='" & server.HTMLEncode(RS1("pubLink")) & "'>" & server.HTMLEncode(RS1("pubIMIAbbr")) & "</option>")
				RS1.MoveNext
			loop
		end if
		RS1.close
		set RS1 = Nothing	
		response.write("</select></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Other publication not in list</span></td>")
		response.write("<td width='80%'><input type=text value='' name=otherpublication id=otherpublication size='80' maxlength='255'></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Volume</span></td>")
		response.write("<td width='80%'><input type=text value='' name=volume id=volume size='20' maxlength='100'></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Part</span></td>")
		response.write("<td width='80%'><input type=text value='' name=part id=part size='20' maxlength='100'></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Page</span></td>")
		response.write("<td width='80%'><input type=text value='' name=Page id=Page size='20' maxlength='100'>")
		response.write("<div class=error id=PageError><font color='#FF0000'>Required: Please enter the page or plate</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Year of publication</span></td>")
		response.write("<td width='80%'><input type=text value='' name=YearOfPublication id=YearOfPublication size='20' maxlength='4'>")
		response.write("<div class=error id=YearOfPublicationError><font color='#FF0000'>Required: Please enter the year of publication of the name</div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Year on publication</span></td>")
		response.write("<td width='80%'><input type=text value='' name=YearOnPublication id=YearOnPublication size='20' maxlength='20'></td>")
		response.write("</tr>")
	
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Replaced synonym</span></td>")
		strStr = chr(34) & chr(41)
		strJava = "javascript:popUp(" & chr(34)
		strPopup = "<a href='" & strJava & "FindBasionym.asp" & strStr & "'><img src='../IMAGES/i.gif' alt='Find replaced synonym' width='13' height='13' border='0'></a>"
		response.write("<td width='80%'><input type=text value='' name=Basionym id=Basionym size='80' maxlength='100'>&nbsp;" & strPopup)
		response.write("<div class=error id=Basionym><font color='#FF0000'>Required: Please enter the replaced synonym<br></div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Competing/blocking synonym</span></td>")
		strStr = chr(34) & chr(41)
		strJava = "javascript:popUp(" & chr(34)
		strPopup = "<a href='" & strJava & "FindBasionym.asp" & strStr & "'><img src='../IMAGES/i.gif' alt='Find competing/blocking synonym' width='13' height='13' border='0'></a>"
		response.write("<td width='80%'><input type=text value='' name=Basionym id=Basionym size='80' maxlength='100'>&nbsp;" & strPopup)
		response.write("<div class=error id=Basionym><font color='#FF0000'>Required: Please enter the competing/blocking synonym<br></div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")

		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Email</span></td>")
		response.write("<td width='80%'><input type=text value='' name=Email id=Email size='40' maxlength='100'>")
		response.write("<div class=error id=EmailError><font color='#FF0000'>Required: Please enter your email<br></div>&nbsp;<b>*</b></font></td>")
		response.write("</tr>")
		
		response.write("<tr>")
		response.write("<td width='20%'><span class=label>Comment</span></td>")
		response.write("<td width='80%'><textarea type=text value='' name=Notes id=comment cols='68' rows='5'></textarea></td>")
		response.write("</tr>")

'register new typification		
		elseif strText = "New typification" then
		response.write("<td align='left' width='5%'>" & RS("NomenclaturalAct") & "</td>")
		response.write("<td align='left' width='5%'>Contact me</td>")

		else
			response.write("<td align='left' width='5%'>undefined rank</td>")
		end if
		response.write("</tr>")
		response.write("<td width='20%'><input type='submit' name='Submit' value='Register Name'></td>")
		response.write("<td width='80%'><a href='javascript:history.go(-1)'>back to previous page</a><input type='hidden' name='RecordNumber' value='1'></td>")
		response.write("</tr>")
		response.write("</table>")
		response.write("</form>")
		end if
		RS.MoveNext
		loop
		response.write("</table>")
	else
		response.write("No records found<br><br>")
	end if
	RS.close
	set RS = nothing
	dbConn.close
	set dbConn = nothing
	
	function strn(str)
		if isnull(str) then 
			strn = ""
		else
			strn = str
		end if  
	end function
%>
  <tr> 
    <td class="Footer"> <hr noshade> &copy;
                    <script>
document.write(curr_year);
</script> 
	 <a href=javascript:popUp("../Names/IndexFungorumPartnership.htm") onMouseOver="MM_displayStatusMsg('Index Fungorum Partnership');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Index 
      Fungorum Partnership</a>. Return to <a href="../Index.htm" onMouseOver="MM_displayStatusMsg('CABI Bioscience Databases home page');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">main 
      page</a>. Return to <a href="#TopOfPage" onMouseOver="MM_displayStatusMsg('Go to top of page');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">top 
      of page</a>.</td>
  </tr>
</table>
</body>
</html>
