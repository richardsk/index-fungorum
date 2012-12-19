<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum-Name RegistrationForm</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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
</head>
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<a name="TopOfPage"></a> 
<table width="100%" height="100%" class="mainbody">
  <tr> 
    <td height="105"> <table width="100%" border="0" class="mainbody">
        <tr> 
          <td width="50%" class="h1"> <img src="../IMAGES/LogoIF.gif" alt="Index Fungorum - Species Fungorum" width="100" height="100">Index&nbsp;Fungorum</td>
          <td valign="top">&nbsp;</td>
        </tr>
        <tr> 
          <td colspan="2"><hr noshade></td>
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
  page = document.getElementById("page").value;
  YearOfPublication = document.getElementById("YearOfPublication").value;
  TypificationDetails = document.getElementById("TypificationDetails").value;
  email = document.getElementById("email").value;
  
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
document.getElementById("pageError").style.display = "inline";
document.getElementById("page").select();
document.getElementById("page").focus();
  return false;
  } else if (YearOfPublication == "") {
  hideAllErrors();
document.getElementById("YearOfPublicationError").style.display = "inline";
document.getElementById("YearOfPublication").select();
document.getElementById("YearOfPublication").focus();
  return false;

  } else if (TypificationDetails == "") {
  hideAllErrors();
document.getElementById("TypificationDetailsError").style.display = "inline";
document.getElementById("TypificationDetails").select();
document.getElementById("TypificationDetails").focus();
  return false;


  } else if (email == "") {
  hideAllErrors();
document.getElementById("emailError").style.display = "inline";
document.getElementById("email").select();
document.getElementById("email").focus();
  return false;
  }
  return true;
  }
 
  function hideAllErrors() {
document.getElementById("NameOfFungusError").style.display = "none"
document.getElementById("AuthorError").style.display = "none"
document.getElementById("pageError").style.display = "none"
document.getElementById("YearOfPublicationError").style.display = "none"
document.getElementById("TypificationDetailsError").style.display = "none"
document.getElementById("emailError").style.display = "none"
  }
</script>

<%
sub DisplayRecord()
	dim strNameOfFungus, strAuthor, strPublishingAuthors, strPubAcceptedTitle, strVolume, strPart
	dim strPage, strYearOfPublication, strYearOnPublication, strTypificationDetails, strAddedBy
	dim strSynonymy, strHost, strNotes
		'CLEAR SESSION VARIABLES IN CASE OF GO-BACK
		session("strNameOfFungus") = ""
		session("strAuthor") = ""
		session("strPublishingAuthors") = ""
		session("strPubAcceptedTitle") = ""
		session("strVolume") = ""
		session("strPart") = ""
		session("strPage") = ""
		session("strYearOfPublication") = ""
		session("strYearOnPublication") = ""
		session("strSynonymy") = ""
		session("strHost") = ""
		session("strTypificationDetails") = ""
		strRecordNumber = ""
		session("strNotes") = ""
		session("strAddedBy") = ""

   response.write("<form name='frmIndexFungorumAdd' onSubmit='return checkForm();' method=post action='../Names/RegisterName.asp'>")
   response.write("<table width='100%' border='1' cellspacing='0' cellpadding='5'>")

   response.write("<tr>")
   response.write("<td width='15%'><span class=label>Name</span></td>")
   response.write("<td width='85%'><input type=text value='' name=NameOfFungus id=NameOfFungus size='80' maxlength='100'>")
   response.write("<div class=error id=NameOfFungusError>Required: Please enter the name</div></td>")
   response.write("</tr>")

   response.write("<tr>")
   response.write("<td width='15%'><span class=label>Author</span></td>")
   response.write("<td width='85%'><input type=text value='' name=Author id=Author size='80' maxlength='100'>")
   response.write("<div class=error id=AuthorError>Required: Please enter the author</div></td>")
   response.write("</tr>")

   response.write("<tr>")
   response.write("<td width='15%'><span class=label>PublishingAuthors</span></td>")
   response.write("<td width='85%'><input type=text value='' name=publishingauthors id=publishingauthors size='80' maxlength='100'></td>")
   response.write("</tr>")

   response.write("<tr>")
   response.write("<td width='15%'><span class=label>PubAcceptedTitle</span></td>")
   response.write("<td width='85%'><input type=text value='' name=pubacceptedtitle id=pubacceptedtitle size='80' maxlength='100'></td>")
   response.write("</tr>")

   response.write("<tr>")
   response.write("<td width='15%'><span class=label>Volume</span></td>")
   response.write("<td width='85%'><input type=text value='' name=volume id=volume size='80' maxlength='100'></td>")
   response.write("</tr>")

   response.write("<tr>")
   response.write("<td width='15%'><span class=label>Part</span></td>")
   response.write("<td width='85%'><input type=text value='' name=part id=part size='80' maxlength='100'></td>")
   response.write("</tr>")

   response.write("<tr>")
   response.write("<td width='15%'><span class=label>Page</span></td>")
   response.write("<td width='85%'><input type=text value='' name=page id=page size='80' maxlength='100'>")
   response.write("<div class=error id=pageError>Required: Please enter the page</div></td>")
   response.write("</tr>")

   response.write("<tr>")
   response.write("<td width='15%'><span class=label>Year of publication</span></td>")
   response.write("<td width='85%'><input type=text value='' name=YearOfPublication id=YearOfPublication size='80' maxlength='100'>")
   response.write("<div class=error id=YearOfPublicationError>Required: Please enter the year of publication of the name</div></td>")
   response.write("</tr>")

   response.write("<tr>")
   response.write("<td width='15%'><span class=label>Year on publication</span></td>")
   response.write("<td width='85%'><input type=text value='' name=YearOnPublication id=YearOnPublication size='80' maxlength='100'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'><span class=label>Synonymy</span></td>")
   response.write("<td width='85%'><input type=text value='' name=synonymy id=synonymy size='80' maxlength='100'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'><span class=label>Host or Substratum</span></td>")
   response.write("<td width='85%'><input type=text value='' name=host id=host size='80' maxlength='100'></td>")
   response.write("</tr>")
   response.write("<tr>")
   response.write("<td width='15%'><span class=label>Country of origin of type</span></td>")
   response.write("<td width='85%'><input type=text value='' name=location id=location size='80' maxlength='100'></td>")
   response.write("</tr>")

   response.write("<tr>")
   response.write("<td width='15%'><span class=label>Typification details</span></td>")
   response.write("<td width='85%'><input type=text value='' name=TypificationDetails id=TypificationDetails size='80' maxlength='100'>")
   response.write("<div class=error id=TypificationDetailsError>Required: Please enter your email address<br></div></td>")
   response.write("</tr>")

   response.write("<tr>")
   response.write("<td width='15%'><span class=label>Email</span></td>")
   response.write("<td width='85%'><input type=text value='' name=email id=email size='80' maxlength='100'>")
   response.write("<div class=error id=emailError>Required: Please enter your email address<br></div></td>")
   response.write("</tr>")

   response.write("<tr>")
   response.write("<td width='15%'><span class=label>Comment</span></td>")
   response.write("<td width='85%'><textarea type=text value='' name=comment id=comment cols='67' rows='5'></textarea></td>")
   response.write("</tr>")

   response.write("</tr>")
   response.write("<td width='15%'><input type='submit' name='Submit' value='Register Name'></td>")
   response.write("<td width='85%'><input type='hidden' name='RecordNumber' value='1'></td>")
   response.write("</tr>")
   response.write("</table>")

   response.write("</form>")
end sub
%> <%
   response.write("<h3><font color='#FF0000'>Index Fungorum name registration form</font></h3>")
   DisplayRecord()
%>
</body>
</html>
</td>
        </tr>
      </td>
  </tr>
  <tr> 
    <td height="10" class="Footer"> <hr noshade> &copy; 2010 <a href=javascript:popUp("../Names/IndexFungorumPartnership.htm") onMouseOver="MM_displayStatusMsg('Index Fungorum Partnership');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Index 
      Fungorum Partnership</a></td>
  </tr>
</table>
<a name="BottomOfPage"></a> 
</body>
</html>
